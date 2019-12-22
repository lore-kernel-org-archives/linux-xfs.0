Return-Path: <SRS0=cf1J=2M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9640EC2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 16:37:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 685AD2070A
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 16:37:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rc70m5qV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfLVQhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Dec 2019 11:37:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfLVQhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Dec 2019 11:37:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBMGYOel094909
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=Tb+IWkI8TIffUsV4AuOXOpuDMwSCV0QiME3QzJaqA4M=;
 b=rc70m5qVe+7+8P8YlN+cKOH0PC4aaezNe2zk3+AbaSEKMn1LThZzt+DVK9SV/m1X9Xhn
 7r67SB0VJLVFFtAVD7Iy0MFHVzBcMdala+y16h5OrF5c3fftslejxWuuPHvW4g30az3J
 hpsjozJOWLi/qixzBpS1OSV6S7APQJnPObge4b85uDokCen6+p/W+Cn3ZDjgrOKUghfX
 VmxFf49nzJghUD+sGlVdbdtC6lNi2kf2J0S5pGvpt8ThBeOlwgZEVrx66GHk+R6MlwkL
 YSr9tLcP98Dt+PXW0szaaNnAlbsHk2pGGLf812PNzQ3EDdHW9MoBPadOesf8qjUehKV7 sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x1attbrg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:37:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBMGYNbT107510
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:37:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x1wj7svhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:37:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBMGbCgn003739
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:37:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Dec 2019 08:37:12 -0800
Date:   Sun, 22 Dec 2019 08:37:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix s_maxbytes computation on 32-bit kernels
Message-ID: <20191222163711.GT7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912220150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912220150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

I observed a hang in generic/308 while running fstests on a i686 kernel.
The hang occurred when trying to purge the pagecache on a large sparse
file that had a page created past MAX_LFS_FILESIZE, which caused an
integer overflow in the pagecache xarray and resulted in an infinite
loop.

I then noticed that Linus changed the definition of MAX_LFS_FILESIZE in
commit 0cc3b0ec23ce ("Clarify (and fix) MAX_LFS_FILESIZE macros") so
that it is now one page short of the maximum page index on 32-bit
kernels.  Because the XFS function to compute max offset open-codes the
2005-era MAX_LFS_FILESIZE computation and neither the vfs nor mm perform
any sanity checking of s_maxbytes, the code in generic/308 can create a
page above the pagecache's limit and kaboom.

So, fix the function to return MAX_LFS_FILESIZE, but check that bmbt
record offsets have enough space to handle that many bytes.  I have no
answer for why this seems to have been broken for years and nobody
noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d9ae27ddf253..30a17e5ffa67 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -193,30 +193,25 @@ xfs_fs_show_options(
 	return 0;
 }
 
-static uint64_t
+static loff_t
 xfs_max_file_offset(
-	unsigned int		blockshift)
+	struct xfs_mount	*mp)
 {
-	unsigned int		pagefactor = 1;
-	unsigned int		bitshift = BITS_PER_LONG - 1;
-
-	/* Figure out maximum filesize, on Linux this can depend on
-	 * the filesystem blocksize (on 32 bit platforms).
-	 * __block_write_begin does this in an [unsigned] long long...
-	 *      page->index << (PAGE_SHIFT - bbits)
-	 * So, for page sized blocks (4K on 32 bit platforms),
-	 * this wraps at around 8Tb (hence MAX_LFS_FILESIZE which is
-	 *      (((u64)PAGE_SIZE << (BITS_PER_LONG-1))-1)
-	 * but for smaller blocksizes it is less (bbits = log2 bsize).
+	/*
+	 * XFS block mappings use 54 bits to store the logical block offset.
+	 * This should suffice to handle the maximum file size that the VFS
+	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
+	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
+	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
+	 * to check this assertion before returning MAX_LFS_FILESIZE.
+	 *
+	 * Avoid integer overflow by comparing the maximum bmbt offset to the
+	 * maximum pagecache offset in units of fs blocks.
 	 */
+	WARN_ON(((1ULL << BMBT_STARTOFF_BITLEN) - 1) <
+		XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE));
 
-#if BITS_PER_LONG == 32
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_SIZE;
-	bitshift = BITS_PER_LONG;
-#endif
-
-	return (((uint64_t)pagefactor) << bitshift) - 1;
+	return MAX_LFS_FILESIZE;
 }
 
 /*
@@ -1435,7 +1430,7 @@ xfs_fc_fill_super(
 	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_maxbytes = xfs_max_file_offset(mp);
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	sb->s_time_min = S32_MIN;
