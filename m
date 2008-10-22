Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 01:24:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M8O9UJ014188
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:24:09 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C9FEE8FD217
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:25:54 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ZTEiE8Zh59kIGeRy for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 01:25:54 -0700 (PDT)
Date: Wed, 22 Oct 2008 19:25:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022082550.GM18495@disturbed>
References: <20081017165738.GA20818@infradead.org> <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com> <20081022075838.GK18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022075838.GK18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alexander Beregalov <a.beregalov@gmail.com>, lachlan@sgi.com, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Oct 22, 2008 at 06:58:38PM +1100, Dave Chinner wrote:
> On Tue, Oct 21, 2008 at 03:42:16PM +0400, Alexander Beregalov wrote:
> > Bisected to:
> > dd509097cb0b76d3836385f80d6b2d6fd3b97757 is first bad commit
> > commit dd509097cb0b76d3836385f80d6b2d6fd3b97757
> > Author: Lachlan McIlroy <lachlan@sgi.com>
> > Date:   Mon Sep 29 14:56:40 2008 +1000
> > 
> >     [XFS] Unlock inode before calling xfs_idestroy()
> > 
> >     Lock debugging reported the ilock was being destroyed without being
> >     unlocked. We don't need to lock the inode until we are going to insert it
> >     into the radix tree.
> 
> Ah, OK, I see the problem, though I don't understand why I'm not
> seeing the might_sleep() triggering all the time given that I always
> build with:
> 
> $ grep SLEEP .config
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> 
> Basically the above commit moved xfs_ilock() inside
> radix_tree_preload()/radix_tree_preload_end(), which means we are
> taking a rwsem() while we have an elevated preempt count. I'll
> get a patch out to fix it.

Patch below (against the xfs master/linux-next branch) should fix the
regression. I've just started QA on it. Can you please check that
it works for you, Alexander?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: Can't lock inodes in radix tree preload region

When we are inside a radix tree preload region, we cannot
sleep. Recently we moved the inode locking inside the
preload region for the inode radix tree. Fix that,
and fix a missed unlock in another error path in the
same code at the same time.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index fbc6088..837cae7 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -159,18 +159,19 @@ xfs_iget_cache_miss(
 		goto out_destroy;
 	}
 
+	if (lock_flags)
+		xfs_ilock(ip, lock_flags);
+
 	/*
 	 * Preload the radix tree so we can insert safely under the
-	 * write spinlock.
+	 * write spinlock. Note that we cannot sleep inside the preload
+	 * region.
 	 */
 	if (radix_tree_preload(GFP_KERNEL)) {
 		error = EAGAIN;
-		goto out_destroy;
+		goto out_unlock;
 	}
 
-	if (lock_flags)
-		xfs_ilock(ip, lock_flags);
-
 	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
 	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
@@ -181,7 +182,7 @@ xfs_iget_cache_miss(
 		WARN_ON(error != -EEXIST);
 		XFS_STATS_INC(xs_ig_dup);
 		error = EAGAIN;
-		goto out_unlock;
+		goto out_preload_end;
 	}
 
 	/* These values _must_ be set before releasing the radix tree lock! */
@@ -193,9 +194,12 @@ xfs_iget_cache_miss(
 	*ipp = ip;
 	return 0;
 
-out_unlock:
+out_preload_end:
 	write_unlock(&pag->pag_ici_lock);
 	radix_tree_preload_end();
+out_unlock:
+	if (lock_flags)
+		xfs_iunlock(ip, lock_flags);
 out_destroy:
 	xfs_destroy_inode(ip);
 	return error;
