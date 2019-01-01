Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53534 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:54 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012E4Lj168473
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:53 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxar0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012Hlui002741
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:48 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012HlnU006359
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:47 GMT
Subject: [PATCH 09/12] xfs: retry fs writes when there isn't space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:46 -0800
Message-ID: <154630906634.16693.14439684008416608580.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Any time we try a file write that fails due to ENOSPC or EDQUOT, force
inactivation work to free up some resources and try one more time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c  |   11 +++++++++++
 fs/xfs/xfs_inode.c |    1 +
 fs/xfs/xfs_iomap.c |   10 +++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e47425071e65..7ba3b799702d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -652,6 +652,9 @@ xfs_file_buffered_aio_write(
 		if (enospc)
 			goto write_retry;
 		enospc = xfs_inode_free_quota_cowblocks(ip);
+		if (enospc)
+			goto write_retry;
+		enospc = xfs_inactive_free_quota(ip);
 		if (enospc)
 			goto write_retry;
 		iolock = 0;
@@ -665,6 +668,7 @@ xfs_file_buffered_aio_write(
 		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
 		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
 		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		xfs_inactive_force(ip->i_mount);
 		goto write_retry;
 	}
 
@@ -936,6 +940,7 @@ xfs_file_remap_range(
 	struct xfs_mount	*mp = src->i_mount;
 	loff_t			remapped = 0;
 	xfs_extlen_t		cowextsize;
+	bool			can_retry = true;
 	int			ret;
 
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
@@ -955,8 +960,14 @@ xfs_file_remap_range(
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
+retry:
 	ret = xfs_reflink_remap_blocks(src, pos_in, dest, pos_out, len,
 			&remapped);
+	if ((ret == -EDQUOT || ret == -ENOSPC) && can_retry) {
+		can_retry = false;
+		xfs_inactive_force(mp);
+		goto retry;
+	}
 	if (ret)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 26c8181f5760..2c7f8aeffa92 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1181,6 +1181,7 @@ xfs_create(
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
+		xfs_inactive_force(mp);
 		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
 	}
 	if (error)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 59772a7c7586..302ba859dd32 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -532,12 +532,13 @@ xfs_file_iomap_begin_delay(
 	struct xfs_bmbt_irec	got;
 	struct xfs_iext_cursor	icur;
 	xfs_fsblock_t		prealloc_blocks = 0;
+	bool			flush_inactive = true;
 
 	ASSERT(!XFS_IS_REALTIME_INODE(ip));
 	ASSERT(!xfs_get_extsz_hint(ip));
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
+start_over:
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
 	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
@@ -632,6 +633,13 @@ xfs_file_iomap_begin_delay(
 		break;
 	case -ENOSPC:
 	case -EDQUOT:
+		if (flush_inactive) {
+			flush_inactive = false;
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			xfs_inactive_force(mp);
+			xfs_ilock(ip, XFS_ILOCK_EXCL);
+			goto start_over;
+		}
 		/* retry without any preallocation */
 		trace_xfs_delalloc_enospc(ip, offset, count);
 		if (prealloc_blocks) {
