Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754253AbeFUSb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITGuS013660
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jmtgx3610-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:55 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVsrt003422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:54 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5LIVsKF028794
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:54 GMT
Subject: [PATCH 8/8] xfs: ensure post-EOF zeroing happens after zeroing part
 of a file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:53 -0700
Message-ID: <152960591330.26246.305971181988789033.stgit@magnolia>
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a user asks us to zero_range part of a file, the end of the range is
EOF, and not aligned to a page boundary, invoke writeback of the EOF
page to ensure that the post-EOF part of the page is zeroed.  This
ensures that we don't expose stale memory contents via mmap, if in a
clumsy manner.

Found by running generic/127 when it runs zero_range and mapread at EOF
one after the other.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index abc37b0899c0..c94d376e4152 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1208,7 +1208,20 @@ xfs_free_file_space(
 		return 0;
 	if (offset + len > XFS_ISIZE(ip))
 		len = XFS_ISIZE(ip) - offset;
-	return iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
+	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
+	if (error)
+		return error;
+
+	/*
+	 * If we zeroed right up to EOF and EOF straddles a page boundary we
+	 * must make sure that the post-EOF area is also zeroed because the
+	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
+	 * Writeback of the eof page will do this, albeit clumsily.
+	 */
+	if (offset + len < XFS_ISIZE(ip) || ((offset + len) & PAGE_MASK) == 0)
+		return 0;
+	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+			(offset + len) & ~PAGE_MASK, LLONG_MAX);
 }
 
 /*

