Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Aug 2008 18:36:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7T1Zw2C012481
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 18:35:58 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75A15FDFADB
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 18:37:21 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Rn6HtkoXaPcNfjeA for <xfs@oss.sgi.com>; Thu, 28 Aug 2008 18:37:21 -0700 (PDT)
Date: Fri, 29 Aug 2008 11:37:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080829013708.GD6016@disturbed>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com> <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins> <20080825215532.GB28188@lst.de> <20080826024547.GX5706@disturbed> <20080826193508.GA17542@infradead.org> <48B74EDB.7060407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B74EDB.7060407@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Daniel J Blueman <daniel.blueman@gmail.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Aug 29, 2008 at 11:20:27AM +1000, Peter Leckie wrote:
> Christoph Hellwig wrote:
>> Looks good.  We probably don't need the #ifdef DEBUG as ASSERT is
>> debug-only anyway.
> Hey Dave did you want to update the patch?

Below.
-- 
Dave Chinner
david@fromorbit.com


XFS: prevent lockdep false positives when locking two inodes

If we call xfs_lock_two_inodes() to grab both the iolock and
the ilock, then drop the ilocks on both inodes, then grab
them again (as xfs_swap_extents() does) then lockdep will
report a locking order problem. This is a false positive.

To avoid this, disallow xfs_lock_two_inodes() fom locking both
inode locks at once - force calers to make two separate calls.
This means that nested dropping and regaining of the ilocks
will retain the same lockdep subclass and so lockdep will
not see anything wrong with this code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_dfrag.c    |    9 ++++++++-
 fs/xfs/xfs_vnodeops.c |    8 ++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 760f4c5..75b0cd4 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -149,7 +149,14 @@ xfs_swap_extents(
 
 	sbp = &sxp->sx_stat;
 
-	xfs_lock_two_inodes(ip, tip, lock_flags);
+	/*
+	 * we have to do two separate lock calls here to keep lockdep
+	 * happy. If we try to get all the locks in one call, lock will
+	 * report false positives when we drop the ILOCK and regain them
+	 * below.
+	 */
+	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
+	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
 	locked = 1;
 
 	/* Verify that both files have the same format */
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 883b8b1..ac2e4e9 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1836,6 +1836,12 @@ again:
 #endif
 }
 
+/*
+ * xfs_lock_two_inodes() can only be used to lock one type of lock
+ * at a time - the iolock or the ilock, but not both at once. If
+ * we lock both at once, lockdep will report false positives saying
+ * we have violated locking orders.
+ */
 void
 xfs_lock_two_inodes(
 	xfs_inode_t		*ip0,
@@ -1846,6 +1852,8 @@ xfs_lock_two_inodes(
 	int			attempts = 0;
 	xfs_log_item_t		*lp;
 
+	if (lock_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL))
+		ASSERT((lock_mode & (XFS_ILOCK_SHARED|XFS_ILOCK_EXCL)) == 0);
 	ASSERT(ip0->i_ino != ip1->i_ino);
 
 	if (ip0->i_ino > ip1->i_ino) {
