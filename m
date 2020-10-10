Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B009C433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 23:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0C42067C
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 23:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y4wFrR7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731449AbgJJW5X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33318 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387557AbgJJU0r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Oct 2020 16:26:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHYavA168407;
        Sat, 10 Oct 2020 17:34:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=govASsblsAlwTiC46jNKZJC2Uixv+2cOJlvPP46bmbU=;
 b=y4wFrR7es9I7uSZssSp1lhyL72yKHQq+q+En1T5nM2r6dC/FiJIferaZ7BVgcuPX0gly
 pqzLzzHH4/KdLKHkD/aCy2xraLslyI68bxjjKvnYVuFYzEDHQqieytRAwm6x2TJPOubK
 oSgF3af8V2sO4mgmHlMLW0/kV5wDGhbz9ha0L9P+74vejYndcGWdECEJTBkQq5omYN5x
 gzv8viDzC0ygfNNfRp5uOnM6VqPXj7+OtIb36onSS8lx7yGurWGkHuFDPjPHTjt8bAmh
 V1fpdYfiDaEOJFXewqT5aWE+6LplJ+c6UVReRGMm+KwvLKG9r3uZHOZTNaLzlWdc+gBM zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3432fa96me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 10 Oct 2020 17:34:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09AHVdhU019009;
        Sat, 10 Oct 2020 17:34:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 343309q4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Oct 2020 17:34:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09AHYZDa003445;
        Sat, 10 Oct 2020 17:34:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 10 Oct 2020 10:34:35 -0700
Subject: [PATCH 2/2] xfs: fix fallocate functions when rtextsize is larger
 than 1
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Date:   Sat, 10 Oct 2020 10:34:34 -0700
Message-ID: <160235127396.1384192.5095447151831725417.stgit@magnolia>
In-Reply-To: <160235126125.1384192.1096112127332769120.stgit@magnolia>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=3 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9770 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 impostorscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010100165
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit fe341eb151ec, I forgot that xfs_free_file_space isn't strictly
a "remove mapped blocks" function.  It is actually a function to zero
file space by punching out the middle and writing zeroes to the
unaligned ends of the specified range.  Therefore, putting a rtextsize
alignment check in that function is wrong because that breaks unaligned
ZERO_RANGE on the realtime volume.

Furthermore, xfs_file_fallocate already has alignment checks for the
functions require the file range to be aligned to the size of a
fundamental allocation unit (which is 1 FSB on the data volume and 1 rt
extent on the realtime volume).  Create a new helper to return the
desired allocation unit size, fix the fallocate frontend to use it,
fix free_file_space to delete the correct range, and remove a now
redundant check from insert_file_space.

Fixes: fe341eb151ec ("xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   17 ++++-------------
 fs/xfs/xfs_file.c      |   10 ++++------
 fs/xfs/xfs_inode.c     |   13 +++++++++++++
 fs/xfs/xfs_inode.h     |    1 +
 4 files changed, 22 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f2a8a0e75e1f..52cddcfee8a1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -947,11 +947,10 @@ xfs_free_file_space(
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
 	/* We can only free complete realtime extents. */
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
-
-		if ((startoffset_fsb | endoffset_fsb) & (extsz - 1))
-			return -EINVAL;
+	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 0) {
+		startoffset_fsb = round_up(startoffset_fsb,
+					   mp->m_sb.sb_rextsize);
+		endoffset_fsb = round_down(endoffset_fsb, mp->m_sb.sb_rextsize);
 	}
 
 	/*
@@ -1147,14 +1146,6 @@ xfs_insert_file_space(
 
 	trace_xfs_insert_file_space(ip);
 
-	/* We can only insert complete realtime extents. */
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
-
-		if ((stop_fsb | shift_fsb) & (extsz - 1))
-			return -EINVAL;
-	}
-
 	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3d1b95124744..e9b4b1dada75 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -803,6 +803,8 @@ xfs_file_fallocate(
 	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
+	unsigned int		blksize = xfs_inode_alloc_blocksize(ip);
+	unsigned int		blkmask = blksize - 1;
 	bool			do_file_insert = false;
 
 	if (!S_ISREG(inode->i_mode))
@@ -850,9 +852,7 @@ xfs_file_fallocate(
 		if (error)
 			goto out_unlock;
 	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
-		unsigned int blksize_mask = i_blocksize(inode) - 1;
-
-		if (offset & blksize_mask || len & blksize_mask) {
+		if ((offset | len) & blkmask) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
@@ -872,10 +872,9 @@ xfs_file_fallocate(
 		if (error)
 			goto out_unlock;
 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
-		unsigned int	blksize_mask = i_blocksize(inode) - 1;
 		loff_t		isize = i_size_read(inode);
 
-		if (offset & blksize_mask || len & blksize_mask) {
+		if ((offset | len) & blkmask) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
@@ -917,7 +916,6 @@ xfs_file_fallocate(
 			 *   2.) If prealloc returns ENOSPC, the file range is
 			 *       still zero-valued by virtue of the hole punch.
 			 */
-			unsigned int blksize = i_blocksize(inode);
 
 			trace_xfs_zero_file_space(ip);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2bfbcf28b1bd..20bb5fae0d00 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3813,3 +3813,16 @@ xfs_iunlock2_io_mmap(
 	if (!same_inode)
 		inode_unlock(VFS_I(ip1));
 }
+
+/* Returns the size of fundamental allocation unit for a file, in bytes. */
+unsigned int
+xfs_inode_alloc_blocksize(
+	struct xfs_inode	*ip)
+{
+	unsigned int		blocks = 1;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		blocks = ip->i_mount->m_sb.sb_rextsize;
+
+	return XFS_FSB_TO_B(ip->i_mount, blocks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 751a3d1d7d84..270b35d9dcb0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -475,5 +475,6 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+unsigned int xfs_inode_alloc_blocksize(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_H__ */

