Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BCEC2D0DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631DC206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SzRs86Bj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgAABJB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:01 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48610 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbgAABJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xep091223
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JE6wSjil/uWamwD2ruaczc9S6YPIBr8o39OhMRDHaMs=;
 b=SzRs86BjAx4NemHklgi28J0LVor/SAuFlcA0PAIdTdU3SR1RDK3OPQdzw7XED0RIJL78
 myjeXDA/Kge/lGh9WzXFMpJ4NlXJ6AKw3t41arJQX0tuZBYns0qjCToRUyNpoAnGc8Zx
 wqNnb/y/7kd5hNGH+Gzf26nrA3peqsYEmlzg0RnOrhfDs701NtaWuEDyEmWUHfV4G5OE
 MiOSD1WMCWLv5TLM3mZYHegZ566w9Nj/j76Xv819e3HCuGvDRsHRbI1y8shEkywVFE7H
 P7CRg4HwfkP5M1dyoriko9QdWPaLTYLQ6ImiRv6nd3uggW22V1iDAxKzWzufo/cvNSk5 eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118utM190241
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:08:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrfy0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:08:57 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00117tia010563
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:55 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:54 -0800
Subject: [PATCH 6/6] xfs: flush speculative space allocations when we run
 out of space
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:52 -0800
Message-ID: <157784087260.1361522.6620813422081256415.stgit@magnolia>
In-Reply-To: <157784083298.1361522.7064886067520069080.stgit@magnolia>
References: <157784083298.1361522.7064886067520069080.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a fs modification (creation, file write, reflink, etc.) is unable to
reserve enough space to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   13 ++++++++++++-
 fs/xfs/xfs_file.c      |   11 ++++-------
 fs/xfs/xfs_icache.c    |   40 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.h    |    1 +
 fs/xfs/xfs_inode.c     |   12 ++++++++++--
 fs/xfs/xfs_iomap.c     |   13 +++++++++++++
 fs/xfs/xfs_reflink.c   |   23 +++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    1 +
 8 files changed, 101 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 72965a22ad1d..cd993802cfa2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -807,7 +807,18 @@ xfs_alloc_file_space(
 retry:
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
-
+		/*
+		 * We weren't able to reserve enough space to handle fallocate.
+		 * Flush any disk space that was being held in the hopes of
+		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
+		 * do a synchronous scan.
+		 */
+		if (error == -ENOSPC && !cleared_space) {
+			cleared_space = true;
+			error = xfs_inode_free_blocks(ip->i_mount, false);
+			if (!error)
+				goto retry;
+		}
 		/*
 		 * Check for running out of space
 		 */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6b37d0435e3a..9a6873106ad4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -660,15 +660,12 @@ xfs_file_buffered_aio_write(
 			goto write_retry;
 		iolock = 0;
 	} else if (ret == -ENOSPC && !cleared_space) {
-		struct xfs_eofblocks eofb = {0};
-
-		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
-
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_EOF_FLAGS_SYNC;
-		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+		cleared_space = true;
+		ret = xfs_inode_free_blocks(ip->i_mount, true);
+		if (ret)
+			return ret;
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5dffa87973b4..83f2db32bc04 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,9 @@
 
 #include <linux/iversion.h>
 
+STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, void *args);
+STATIC int xfs_inode_free_cowblocks(struct xfs_inode *ip, void *args);
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -970,6 +973,21 @@ xfs_queue_eofblocks(
 	rcu_read_unlock();
 }
 
+/* Scan all incore inodes for block preallocations that we can remove. */
+static inline int
+xfs_blockgc_scan(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	int			error;
+
+	error = xfs_icache_free_eofblocks(mp, eofb);
+	if (error && error != -EAGAIN)
+		return error;
+
+	return xfs_icache_free_cowblocks(mp, eofb);
+}
+
 void
 xfs_eofblocks_worker(
 	struct work_struct *work)
@@ -1583,9 +1601,25 @@ xfs_inode_free_quota_blocks(
 
 	trace_xfs_inode_free_quota_blocks(ip->i_mount, &eofb, _RET_IP_);
 
-	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
-	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
-	return true;
+	return xfs_blockgc_scan(ip->i_mount, &eofb) == 0;
+}
+
+/*
+ * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ */
+int
+xfs_inode_free_blocks(
+	struct xfs_mount	*mp,
+	bool			sync)
+{
+	struct xfs_eofblocks	eofb = {0};
+
+	if (sync)
+		eofb.eof_flags |= XFS_EOF_FLAGS_SYNC;
+
+	trace_xfs_inode_free_blocks(mp, &eofb, _RET_IP_);
+
+	return xfs_blockgc_scan(mp, &eofb);
 }
 
 static inline unsigned long
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 835c735301b8..979e3e669be3 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -58,6 +58,7 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
 bool xfs_inode_free_quota_blocks(struct xfs_inode *ip, bool sync);
+int xfs_inode_free_blocks(struct xfs_mount *mp, bool sync);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c17ac64c0896..c41003fae9d5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1179,10 +1179,18 @@ xfs_create(
 	 */
 retry:
 	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
-	if (error == -ENOSPC) {
+	/*
+	 * We weren't able to reserve enough space to add the inode.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+		error = xfs_inode_free_blocks(mp, true);
+		if (!error)
+			goto retry;
 	}
 	if (error)
 		goto out_release_inode;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1eed29139b58..e45bee3c8faf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -246,6 +246,19 @@ xfs_iomap_write_direct(
 retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
 			tflags, &tp);
+	/*
+	 * We weren't able to reserve enough space for the direct write.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.  Historically, we expected callers to have preallocated
+	 * all the space before a direct write, but this is not an absolute
+	 * requirement.  We still hold the IOLOCK so we cannot do a sync scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(ip->i_mount, false);
+		if (!error)
+			goto retry;
+	}
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 6bff74ab49a0..dc553a0cc0ed 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -381,6 +381,18 @@ xfs_reflink_allocate_cow(
 	xfs_iunlock(ip, *lockmode);
 retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	/*
+	 * We weren't able to reserve enough space to handle copy on write.
+	 * Flush any disk space that was being held in the hopes of speeding up
+	 * the filesystem.  We potentially hold the IOLOCK so we cannot do a
+	 * synchronous scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(ip->i_mount, false);
+		if (!error)
+			goto retry;
+	}
 	*lockmode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, *lockmode);
 
@@ -1043,6 +1055,17 @@ xfs_reflink_remap_extent(
 	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	/*
+	 * We weren't able to reserve enough space for the remapping.  Flush
+	 * any disk space that was being held in the hopes of speeding up the
+	 * filesystem.  We still hold the IOLOCK so we cannot do a sync scan.
+	 */
+	if (error == -ENOSPC && !cleared_space) {
+		cleared_space = true;
+		error = xfs_inode_free_blocks(mp, false);
+		if (!error)
+			goto retry;
+	}
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8307d188aea7..df912c9a148d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3779,6 +3779,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_quota_blocks);
+DEFINE_EOFBLOCKS_EVENT(xfs_inode_free_blocks);
 
 #endif /* _TRACE_XFS_H */
 

