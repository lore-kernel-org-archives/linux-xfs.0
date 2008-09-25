Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 14:21:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PLL1oa015429
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:21:02 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E78F51AF11ED
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:22:35 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id gcBHr4w3EM172dVl for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 14:22:35 -0700 (PDT)
Message-ID: <48DC0109.7070608@sandeen.net>
Date: Thu, 25 Sep 2008 16:22:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/10] xfs: Fix error handling in	write_super_lockfs/unlockfs
References: <20080922195637t-sato@mail.jp.nec.com> <20080922234120.GV5811@disturbed>
In-Reply-To: <20080922234120.GV5811@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Dave Chinner wrote:

> xfs_fs_log_dummy() currently is void because it had nowhere to
> return errors to. It silently throws away errors because of this.
> Hence the correct thing to do here is to fix xfs_fs_log_dummy()
> to return the errors it currently ignores. i.e. catch the errors
> from xfs_trans_reserve() and xfs_trans_commit() calls in
> xfs_fs_log_dummy().
>
> Cheers,
>
> Dave.
>   
Here's that part in case it's helpful :)  Feel free to roll it into
your patch.

-Eric

Make xfs_fs_log_dummy() return errors which can then be returned by
xfs_fs_lockfs(), once it is capable of doing so.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c	2008-08-04 15:30:31.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_fsops.c	2008-09-25 16:16:46.916001110 -0500
@@ -589,17 +589,19 @@ out:
 	return 0;
 }
 
-void
+int
 xfs_fs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
+	int		error = 0;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	if (xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0)) {
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return;
+		return error;
 	}
 
 	ip = mp->m_rootip;
@@ -609,9 +611,10 @@ xfs_fs_log_dummy(
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
-	xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp, 0);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
Index: linux-2.6/fs/xfs/xfs_fsops.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.h	2008-06-05 13:44:24.000000000 -0500
+++ linux-2.6/fs/xfs/xfs_fsops.h	2008-09-25 16:16:58.303000603 -0500
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern void xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
