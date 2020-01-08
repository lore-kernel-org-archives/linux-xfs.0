Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC113C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE02A2067D
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XrC7gJ1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgAHER4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:17:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHER4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:17:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EBCS048977
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/dpEWg3wZZXnSmcCygPCGUvjrJsaW6IO1sRBX9Wwm9s=;
 b=XrC7gJ1C+rQ6CtBOqdQfJME8v/zKVpuz/zfsNFQ2wYW4k4u5xsX4qz+VCP8Jll95JlrI
 dTLmKYPIvPPYT5jA9+yn6c3aGGiES/ttbFkbwuPmMqmlb4ucNWJxRCOXrxLsX9oHutuV
 lzqq2q7BmIySmTY1FyYiGJ7ixxDTnNAnFy2g/eUgakgJPsyb9p8QkyRUwI71nWWYLp2f
 ln1fpGDuXJQsP4Jn5gqgXj58D/QtrnI7f5EEOrCB4oen8FtpZGkfiP0wK2soNcGAgvJx
 Ub33Kxz04HXcju0y7wUg8im7rOtGvWxjMAR9SkmdhHIGM2MUzRfFouTbFm/WNBxnfbWp 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xaj4u1k2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EEBM064927
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpcrrxd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084HrCL018370
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:17:53 -0800
Subject: [PATCH 3/3] xfs: fix s_maxbytes computation on 32-bit kernels
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:17:51 -0800
Message-ID: <157845707130.82882.12708231277663860217.stgit@magnolia>
In-Reply-To: <157845705246.82882.11480625967486872968.stgit@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080036
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9493 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080036
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

Fix all this by setting s_maxbytes to MAX_LFS_FILESIZE directly and
aborting the mount with a warning if our assumptions ever break.  I have
no answer for why this seems to have been broken for years and nobody
noticed.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c |   48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d9ae27ddf253..05ca2a7bbe55 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -193,32 +193,6 @@ xfs_fs_show_options(
 	return 0;
 }
 
-static uint64_t
-xfs_max_file_offset(
-	unsigned int		blockshift)
-{
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
-	 */
-
-#if BITS_PER_LONG == 32
-	ASSERT(sizeof(sector_t) == 8);
-	pagefactor = PAGE_SIZE;
-	bitshift = BITS_PER_LONG;
-#endif
-
-	return (((uint64_t)pagefactor) << bitshift) - 1;
-}
-
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
@@ -1424,6 +1398,26 @@ xfs_fc_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	/*
+	 * XFS block mappings use 54 bits to store the logical block offset.
+	 * This should suffice to handle the maximum file size that the VFS
+	 * supports (currently 2^63 bytes on 64-bit and ULONG_MAX << PAGE_SHIFT
+	 * bytes on 32-bit), but as XFS and VFS have gotten the s_maxbytes
+	 * calculation wrong on 32-bit kernels in the past, we'll add a WARN_ON
+	 * to check this assertion.
+	 *
+	 * Avoid integer overflow by comparing the maximum bmbt offset to the
+	 * maximum pagecache offset in units of fs blocks.
+	 */
+	if (XFS_MAX_FILEOFF < XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE)) {
+		xfs_warn(mp,
+"MAX_LFS_FILESIZE block offset (%llu) exceeds extent map maximum (%llu)!",
+			 XFS_B_TO_FSBT(mp, MAX_LFS_FILESIZE),
+			 XFS_MAX_FILEOFF);
+		error = -EINVAL;
+		goto out_free_sb;
+	}
+
 	error = xfs_filestream_mount(mp);
 	if (error)
 		goto out_free_sb;
@@ -1435,7 +1429,7 @@ xfs_fc_fill_super(
 	sb->s_magic = XFS_SUPER_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
-	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
+	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_max_links = XFS_MAXLINK;
 	sb->s_time_gran = 1;
 	sb->s_time_min = S32_MIN;

