Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1D7C00523
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BFC620705
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 04:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nh/K+eLK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgAHERu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 23:17:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgAHERu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 23:17:50 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084EEFD048995
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DkcpXJE2+b8LQVu5Oqbsc19rzpDKgxpTY12t7tBL9rI=;
 b=nh/K+eLK3P3r9nqXZL7Ozn6Amxpt1rzOREXCRSTt+Ryooy60OgyCWNRzDXTcr5fCaAjQ
 uBdrgZvDoZsEKExfqmIGyISEh60a8pwo8kPGSFkFXIoCcPyCHU+WXJcs5I89Q9VtHRQm
 PPQelmJFKRXync5Uuo32tjZKTVtFO6WqoAFnctlz8/9hoAeh+VWHFD3qXeCqVHUd+rnC
 zqwzi9xrvlgfA3FfYbouLXutNvVBVBc+4BujzoC8GmN6CdpuAN7FMDbGG2HSJUCbc3LK
 VluTQoiT39PmK9ZD0zuE+XF4U9Mkere+fXTT92RhAXiHoj5/UR+IGTn9cHnS2kRlDlBv aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4u1k2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0084E5h4052501
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xcqbjvgfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2020 04:17:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0084Hl8e007785
        for <linux-xfs@vger.kernel.org>; Wed, 8 Jan 2020 04:17:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 20:17:47 -0800
Subject: [PATCH 2/3] xfs: truncate should remove all blocks,
 not just to the end of the page cache
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:17:45 -0800
Message-ID: <157845706502.82882.5903950627987445484.stgit@magnolia>
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

xfs_itruncate_extents_flags() is supposed to unmap every block in a file
from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
bunmapi range, even though s_maxbytes reflects the highest offset the
pagecache can support, not the highest offset that XFS supports.

The result of this confusion is that if you create a 20T file on a
64-bit machine, mount the filesystem on a 32-bit machine, and remove the
file, we leak everything above 16T.  Fix this by capping the bunmapi
request at the maximum possible block offset, not s_maxbytes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fc3aec26ef87..79799ab30c93 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1518,7 +1518,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
@@ -1540,21 +1539,21 @@ xfs_itruncate_extents_flags(
 	 * the end of the file (in a crash where the space is allocated
 	 * but the inode size is not yet updated), simply remove any
 	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
+	 * possible file size.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
+	if (first_unmap_block == XFS_MAX_FILEOFF)
 		return 0;
 
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	ASSERT(first_unmap_block < XFS_MAX_FILEOFF);
+	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1574,7 +1573,7 @@ xfs_itruncate_extents_flags(
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */
 		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
-				first_unmap_block, last_block, true);
+				first_unmap_block, XFS_MAX_FILEOFF, true);
 		if (error)
 			goto out;
 

