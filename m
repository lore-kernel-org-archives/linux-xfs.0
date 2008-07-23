Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 22:34:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N5YPrX026062
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 22:34:25 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [UPDATED RFC] Create with EA initial work
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
	<1215675545-2707-1-git-send-email-xaiki@sgi.com>
	<20080722043851.GA7244@infradead.org>
Date: Wed, 23 Jul 2008 15:35:23 +1000
In-Reply-To: <20080722043851.GA7244@infradead.org> (Christoph Hellwig's
	message of "Tue, 22 Jul 2008 00:38:51 -0400")
Message-ID: <87y73t9n8k.fsf@cxhome.ath.cx>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--=-=-=

Christoph Hellwig <hch@infradead.org> writes:
> On Thu, Jul 10, 2008 at 05:39:01PM +1000, Niv Sardi wrote:
>> There is a bug in this, that I can see with the Parent Pointers code
>> going on top of it (that will be posted soon), it is basically calling
>> xfs_attr_set_int_trans() in xfs_create() just before the last
>> commit. For some reason, the first call to xfs_roll_trans (after
>> xfs_bmap_add_attrfork_trans()) will complain about the inode being
>> unlocked after xfs_trans_commit(). I understand I need to call
>> xfs_trans_ihold(ip) on it, but we already do in xfs_create() so I
>> think I must be missing something else??? any ideas ?
>
> There are multiple ways to deal with inodes linked to transactions.
>
> In all cases it needs to be linked into the transaction by
> xfs_trans_ijoin, or the opencoded equivalent for a new inode in
> xfs_trans_iget.

Shouldn't the inode already be in the transaction ? we just created it
and added it to the directory ?

xfs_create()
  xfs_dir_ialloc(tp, dp, ip)
    xfs_ialloc(tp, dp, ip)
      xfs_trans_iget(tp, ip)

and it has a i_transp after dir_ialloc.

And is why don't we use ijoin in iget as we copy the exact same code a
few lines later ? (like in [0])

>  Then you can use xfs_trans_ihold to make sure on transaction commit
> the inode reference count is not dropped and the inode is not
> unlocked, or simply grab a reference to the inode and let the
> transaction commit handler unlock it and decrement the reference
> count.  The latter is what's used by xfs_create and the former is what
> the attr code does, and as far as I can see the only things what works
> with xfs_attr_rolltrans.

hum, that seemed to work on my UML, shall we require callers to do all
the ihold, ijoin stuff or should we do that (or at least check it) from
the new attr*_trans code ?

[0] 
--=-=-=
Content-Disposition: attachment

>From 18a682c77b0f89faae6906ebc0d73af59ddff632 Mon Sep 17 00:00:00 2001
From: Niv Sardi <xaiki@debian.org>
Date: Wed, 23 Jul 2008 11:27:20 +1000
Subject: [PATCH] Use xfs_trans_ijoin in xfs_trans_iget

Avoid some code duplication

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_trans_inode.c |   30 +-----------------------------
 1 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_trans_inode.c b/fs/xfs/xfs_trans_inode.c
index 2a1c0f0..1dbcbe9 100644
--- a/fs/xfs/xfs_trans_inode.c
+++ b/fs/xfs/xfs_trans_inode.c
@@ -138,35 +138,7 @@ xfs_trans_iget(
 	}
 	ASSERT(ip != NULL);
 
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	if (ip->i_itemp == NULL)
-		xfs_inode_item_init(ip, mp);
-	iip = ip->i_itemp;
-	(void) xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
-
-	xfs_trans_inode_broot_debug(ip);
-
-	/*
-	 * If the IO lock has been acquired, mark that in
-	 * the inode log item so we'll know to unlock it
-	 * when the transaction commits.
-	 */
-	ASSERT(iip->ili_flags == 0);
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_EXCL;
-	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		iip->ili_flags |= XFS_ILI_IOLOCKED_SHARED;
-	}
-
-	/*
-	 * Initialize i_transp so we can find it with xfs_inode_incore()
-	 * above.
-	 */
-	ip->i_transp = tp;
-
-	*ipp = ip;
+	xfs_trans_ijoin(tp, ip, lock_flags);
 	return 0;
 }
 
-- 
1.5.6


--=-=-=


Cheers,
-- 
Niv Sardi

--=-=-=--
