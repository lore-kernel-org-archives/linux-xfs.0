Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4VGPGFb055641 for <xfs@oss.sgi.com>; Tue, 31 May 2011 11:25:17 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 202B91BEE9B0
	for <xfs@oss.sgi.com>; Tue, 31 May 2011 09:25:15 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id vuutQ2NNRB1D02j2 for
	<xfs@oss.sgi.com>; Tue, 31 May 2011 09:25:15 -0700 (PDT)
Date: Tue, 31 May 2011 09:26:52 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
Subject: Re: [git pull] dentry_unhash() breakage
In-Reply-To: <20110530085922.GA11336@infradead.org>
Message-ID: <Pine.LNX.4.64.1105310924040.25709@cobra.newdream.net>
References: <20110530020604.GC561@dastard> <20110530034741.GD561@dastard>
	<Pine.LNX.4.64.1105292057570.9134@cobra.newdream.net>
	<20110530055601.GK11521@ZenIV.linux.org.uk>
	<20110530085922.GA11336@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org

On Mon, 30 May 2011, Christoph Hellwig wrote:
> On Mon, May 30, 2011 at 06:56:01AM +0100, Al Viro wrote:
> > A couple of dentry_unhash fallout fixes
> 
> Shouldn't we do the shrink_dcache_parent only after a successfull
> rmdir or rename?

Yeah, that makes more sense to me...

sage


>From 4e9be5f3fc5f9995b0b1966cda95bb5386e20444 Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Tue, 31 May 2011 09:26:13 -0700
Subject: [PATCH] vfs: shrink_dcache_parent on rmdir, dir rename only on success

Only prune the dentries of the rmdir or dir rename succeeds.  Doing so on
failure makes no sense (though it's mostly harmless).

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/namei.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e2e4e8d..72b0370 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2579,11 +2579,11 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (error)
 		goto out;
 
-	shrink_dcache_parent(dentry);
 	error = dir->i_op->rmdir(dir, dentry);
 	if (error)
 		goto out;
 
+	shrink_dcache_parent(dentry);
 	dentry->d_inode->i_flags |= S_DEAD;
 	dont_mount(dentry);
 
@@ -2994,13 +2994,12 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 	if (d_mountpoint(old_dentry) || d_mountpoint(new_dentry))
 		goto out;
 
-	if (target)
-		shrink_dcache_parent(new_dentry);
 	error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (error)
 		goto out;
 
 	if (target) {
+		shrink_dcache_parent(new_dentry);
 		target->i_flags |= S_DEAD;
 		dont_mount(new_dentry);
 	}
-- 
1.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
