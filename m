Return-Path: <SRS0=9vdY=DY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28101C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 21:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4DEE207BB
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Oct 2020 21:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DVsamJZr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439602AbgJQVuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Oct 2020 17:50:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439598AbgJQVuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Oct 2020 17:50:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HLoEvQ100007;
        Sat, 17 Oct 2020 21:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=O4StGvaMhIh0nL7s8lGGYThzvP2RrUQezk7GMnDgeog=;
 b=DVsamJZr191Khot3MrMi7awp8ec7ziRuC0lz0KygpZEQMsdEhQUohh3IGHIQJq4lyKPr
 H/ZW5i2OwEEWJ4hL8v/+73eaTWJZde7IAICE0MUM8vKGERTYj79HT8ePB/SnaT9a0T/a
 2zT1l7Rwgm7DK42KuItvd8Q8VIhzhX3GwiqHATfdnWyrgc9Lsyogf5Ec7IjUCCfEQU7H
 nvHPW/cho6Njpoma1d9iU7afaNWxwqWuKR08iju1UidEd5a/jYjwFFWyihFtwT//q+17
 /iaa77/e/OMWAfvnxUfcLOVuOpR2yq09rmlsC2BaMU9U3VdupZp3DtKx6uZBl+10Hoh0 KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 347rjkhb2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 17 Oct 2020 21:50:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09HLnhhx051640;
        Sat, 17 Oct 2020 21:50:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 347qxgubkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Oct 2020 21:50:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09HLoCOD024042;
        Sat, 17 Oct 2020 21:50:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 17 Oct 2020 14:50:12 -0700
Date:   Sat, 17 Oct 2020 14:50:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] xfs: fix fallocate functions when rtextsize is larger
 than 1
Message-ID: <20201017215011.GG9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=5 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010170159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9777 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=5 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010170159
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
extent on the realtime volume).  Create a new helper to check fallocate
arguments against the realtiem allocation unit size, fix the fallocate
frontend to use it, fix free_file_space to delete the correct range, and
remove a now redundant check from insert_file_space.

NOTE: The realtime extent size is not required to be a power of two!

Fixes: fe341eb151ec ("xfs: ensure that fpunch, fcollapse, and finsert operations are aligned to rt extent size")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix this to actually handle rtextsize not being a power of 2, add
testcase
---
 fs/xfs/xfs_bmap_util.c |   17 ++++-------------
 fs/xfs/xfs_file.c      |   40 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 18 deletions(-)

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
index 3d1b95124744..9e97815887c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -785,6 +785,39 @@ xfs_break_layouts(
 	return error;
 }
 
+/*
+ * Decide if the given file range is aligned to the size of the fundamental
+ * allocation unit for the file.
+ */
+static bool
+xfs_is_falloc_aligned(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	long long int		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint64_t		mask;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
+			u64	rextbytes;
+			u32	mod;
+
+			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+			div_u64_rem(pos, rextbytes, &mod);
+			if (mod)
+				return false;
+			div_u64_rem(len, rextbytes, &mod);
+			return mod == 0;
+		}
+		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
+	} else {
+		mask = mp->m_sb.sb_blocksize - 1;
+	}
+
+	return !((pos | len) & mask);
+}
+
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
@@ -850,9 +883,7 @@ xfs_file_fallocate(
 		if (error)
 			goto out_unlock;
 	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
-		unsigned int blksize_mask = i_blocksize(inode) - 1;
-
-		if (offset & blksize_mask || len & blksize_mask) {
+		if (!xfs_is_falloc_aligned(ip, offset, len)) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
@@ -872,10 +903,9 @@ xfs_file_fallocate(
 		if (error)
 			goto out_unlock;
 	} else if (mode & FALLOC_FL_INSERT_RANGE) {
-		unsigned int	blksize_mask = i_blocksize(inode) - 1;
 		loff_t		isize = i_size_read(inode);
 
-		if (offset & blksize_mask || len & blksize_mask) {
+		if (!xfs_is_falloc_aligned(ip, offset, len)) {
 			error = -EINVAL;
 			goto out_unlock;
 		}
