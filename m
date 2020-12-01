Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75890C64E7A
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1840C20796
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Dec 2020 03:38:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kB6Pygzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgLADiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:38:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbgLADiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Nov 2020 22:38:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13TSFs147067
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QrlX+8fWS67BIY3Ax5Tt6aIKtT+pED4nf2+mRIXFccQ=;
 b=kB6PygzkW1yo1pn3xZenTldjGHlnUf16LN90mKqeQmcKvDbw8pPAb4HUY5nqLQegParQ
 7chAuMQE5FX5c8Pf+PbcvO/YETpMkeoBMNH0bVL83nu277jurQWxklJRqEjrOiZKIit+
 UuAm9uX+CUcBqdCjFR3e2D8YaIzRv+tGpTjARhZhi/fFwD/F55jxPzW41ysgX95qbZGG
 m/8q6qGgNdHTeEbZFZ0s5nmRxfjtPDxx41EaaIV+b7tepCMtRUCYJ0Apo+DMTxApLe94
 tLwE6GyBss9WQuu9/3OS2PO7GTdyv5vYNRMjdOZWSwSk+GS0BvTW8lUYKNu8WF/cb+XW rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkgcqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B13VHpY071319
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fw8002-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Dec 2020 03:37:18 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B13bHf7004817
        for <linux-xfs@vger.kernel.org>; Tue, 1 Dec 2020 03:37:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 19:37:17 -0800
Subject: [PATCH 1/1] xfs: use reflink to assist unaligned copy_file_range
 calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 30 Nov 2020 19:37:16 -0800
Message-ID: <160679383664.447787.14224539520566294960.stgit@magnolia>
In-Reply-To: <160679383048.447787.12488361211673312070.stgit@magnolia>
References: <160679383048.447787.12488361211673312070.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a copy_file_range handler to XFS so that we can accelerate file
copies with reflink when the source and destination ranges are not
block-aligned.  We'll use the generic pagecache copy to handle the
unaligned edges and attempt to reflink the middle.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_file.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..9d1bb0dc30e2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1119,6 +1119,104 @@ xfs_file_remap_range(
 	return remapped > 0 ? remapped : ret;
 }
 
+/*
+ * Decide if we want to use reflink to accelerate a copy_file_range request.
+ *
+ * We need to use the generic pagecache copy routine if there's no reflink; if
+ * the two files are on different filesystems; if the two files are on
+ * different devices; or if the two offsets are not at the same offset within
+ * an fs block.  Studies on the author's computer show that reflink doesn't
+ * speed up copies smaller than 32k, so use the page cache for those.
+ */
+static inline bool
+xfs_want_reflink_copy_range(
+	struct xfs_inode	*src,
+	unsigned int		src_off,
+	struct xfs_inode	*dst,
+	unsigned int		dst_off,
+	size_t			len)
+{
+	struct xfs_mount	*mp = src->i_mount;
+
+	if (len < 32768)
+		return false;
+	if (mp != dst->i_mount)
+		return false;
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (XFS_IS_REALTIME_INODE(src) != XFS_IS_REALTIME_INODE(dst))
+		return false;
+	return (src_off & mp->m_blockmask) == (dst_off & mp->m_blockmask);
+}
+
+STATIC ssize_t
+xfs_file_copy_range(
+	struct file		*src_file,
+	loff_t			src_off,
+	struct file		*dst_file,
+	loff_t			dst_off,
+	size_t			len,
+	unsigned int		flags)
+{
+	struct inode		*inode_src = file_inode(src_file);
+	struct xfs_inode	*src = XFS_I(inode_src);
+	struct inode		*inode_dst = file_inode(dst_file);
+	struct xfs_inode	*dst = XFS_I(inode_dst);
+	struct xfs_mount	*mp = src->i_mount;
+	loff_t			copy_ret;
+	loff_t			next_block;
+	size_t			copy_len;
+	ssize_t			total_copied = 0;
+
+	/* Bypass all this if no copy acceleration is possible. */
+	if (!xfs_want_reflink_copy_range(src, src_off, dst, dst_off, len))
+		goto use_generic;
+
+	/* Use the regular copy until we're block aligned at the start. */
+	next_block = round_up(src_off + 1, mp->m_sb.sb_blocksize);
+	copy_len = min_t(size_t, len, next_block - src_off);
+	if (copy_len > 0) {
+		copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
+					dst_off, copy_len, flags);
+		if (copy_ret < 0)
+			return copy_ret;
+
+		src_off += copy_ret;
+		dst_off += copy_ret;
+		len -= copy_ret;
+		total_copied += copy_ret;
+		if (copy_ret < copy_len || len == 0)
+			return total_copied;
+	}
+
+	/*
+	 * Now try to reflink as many full blocks as we can.  If the end of the
+	 * copy request wasn't block-aligned or the reflink fails, we'll just
+	 * fall into the generic copy to do the rest.
+	 */
+	copy_len = round_down(len, mp->m_sb.sb_blocksize);
+	if (copy_len > 0) {
+		copy_ret = xfs_file_remap_range(src_file, src_off, dst_file,
+				dst_off, copy_len, REMAP_FILE_CAN_SHORTEN);
+		if (copy_ret >= 0) {
+			src_off += copy_ret;
+			dst_off += copy_ret;
+			len -= copy_ret;
+			total_copied += copy_ret;
+			if (copy_ret < copy_len || len == 0)
+				return total_copied;
+		}
+	}
+
+use_generic:
+	/* Use the regular copy to deal with leftover bytes. */
+	copy_ret = generic_copy_file_range(src_file, src_off, dst_file,
+			dst_off, len, flags);
+	if (copy_ret < 0)
+		return copy_ret;
+	return total_copied + copy_ret;
+}
+
 STATIC int
 xfs_file_open(
 	struct inode	*inode,
@@ -1381,6 +1479,7 @@ const struct file_operations xfs_file_operations = {
 	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
 	.fadvise	= xfs_file_fadvise,
+	.copy_file_range = xfs_file_copy_range,
 	.remap_file_range = xfs_file_remap_range,
 };
 

