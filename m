Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94574C2BA1E
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7679420731
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 18:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uXJvdeYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgDFSyx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:54:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgDFSyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 14:54:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Ihp8H008092;
        Mon, 6 Apr 2020 18:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+aJYxpe0IT6UwpZt9Sm8ixYGrMAvFv72KHPvNKPknkw=;
 b=uXJvdeYNYd2HRsCf8PaG2teKlX1LckpNF2kVMg8obCaCB3zGCHrGpuinAdTtmm332vF5
 6cH+eE6RbGI60JP4cMerCt+15WA/+6Kpmx4vxLHs24jTcSQEW00uC58FEDpKQXkJZUpy
 3CTu6/kDpGJzmY6sIM4M6dlpDkV5n+fd+2M/TCWWzjan4CTkik5srhIP6r0D/1daY5CZ
 SidDvmBRkkLzyIgzgh3fjDgzCzuwxXSqjdUkon1a0VMaTnOMA7GJkEAEUOwPgQG2V3hh
 wsSQ8ia9An2PhJRGxbUi3URR1SIgFgX69/FQkyuB5y/sQwkfEu/JaWmaay/MVu32JwZr nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 306hnr0raj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:54:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036IhEvQ116862;
        Mon, 6 Apr 2020 18:52:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3073qdt8ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 18:52:51 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036Iqotg028957;
        Mon, 6 Apr 2020 18:52:50 GMT
Received: from localhost (/10.159.131.9)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 11:52:50 -0700
Subject: [PATCH 4/5] xfs_repair: fix dir_read_buf use of libxfs_da_read_buf
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 06 Apr 2020 11:52:49 -0700
Message-ID: <158619916916.469742.10169263890587590189.stgit@magnolia>
In-Reply-To: <158619914362.469742.7048317858423621957.stgit@magnolia>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=934
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 mlxlogscore=994
 lowpriorityscore=0 spamscore=0 impostorscore=0 suspectscore=2
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004060146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_da_read_buf dropped the 'mappedbno' argument in favor of a flags
argument.  Foolishly, we're passing that parameter (which is -1 in all
callers) to xfs_da_read_buf, which gets us the wrong behavior.

Since mappedbno == -1 meant "complain if we fall into a hole" (which is
the default behavior of xfs_da_read_buf) we can fix this by passing a
zero flags argument and getting rid of mappedbno entirely.

Coverity-id: 1457898
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase6.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 3fb1af24..beceea9a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -179,7 +179,6 @@ static int
 dir_read_buf(
 	struct xfs_inode	*ip,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops,
 	int			*crc_error)
@@ -187,14 +186,13 @@ dir_read_buf(
 	int error;
 	int error2;
 
-	error = -libxfs_da_read_buf(NULL, ip, bno, mappedbno, bpp,
-				   XFS_DATA_FORK, ops);
+	error = -libxfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK, ops);
 
 	if (error != EFSBADCRC && error != EFSCORRUPTED)
 		return error;
 
-	error2 = -libxfs_da_read_buf(NULL, ip, bno, mappedbno, bpp,
-				   XFS_DATA_FORK, NULL);
+	error2 = -libxfs_da_read_buf(NULL, ip, bno, 0, bpp, XFS_DATA_FORK,
+			NULL);
 	if (error2)
 		return error2;
 
@@ -2035,8 +2033,7 @@ longform_dir2_check_leaf(
 	int			fixit = 0;
 
 	da_bno = mp->m_dir_geo->leafblk;
-	error = dir_read_buf(ip, da_bno, -1, &bp, &xfs_dir3_leaf1_buf_ops,
-			     &fixit);
+	error = dir_read_buf(ip, da_bno, &bp, &xfs_dir3_leaf1_buf_ops, &fixit);
 	if (error == EFSBADCRC || error == EFSCORRUPTED || fixit) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad CRC\n"),
@@ -2137,8 +2134,8 @@ longform_dir2_check_node(
 		 * a node block, then we'll skip it below based on a magic
 		 * number check.
 		 */
-		error = dir_read_buf(ip, da_bno, -1, &bp,
-				     &xfs_da3_node_buf_ops, &fixit);
+		error = dir_read_buf(ip, da_bno, &bp, &xfs_da3_node_buf_ops,
+				&fixit);
 		if (error) {
 			do_warn(
 	_("can't read leaf block %u for directory inode %" PRIu64 ", error %d\n"),
@@ -2205,8 +2202,8 @@ longform_dir2_check_node(
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
 
-		error = dir_read_buf(ip, da_bno, -1, &bp,
-				     &xfs_dir3_free_buf_ops, &fixit);
+		error = dir_read_buf(ip, da_bno, &bp, &xfs_dir3_free_buf_ops,
+				&fixit);
 		if (error) {
 			do_warn(
 	_("can't read freespace block %u for directory inode %" PRIu64 ", error %d\n"),
@@ -2367,7 +2364,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 		else
 			ops = &xfs_dir3_data_buf_ops;
 
-		error = dir_read_buf(ip, da_bno, -1, &bplist[db], ops, &fixit);
+		error = dir_read_buf(ip, da_bno, &bplist[db], ops, &fixit);
 		if (error) {
 			do_warn(
 	_("can't read data block %u for directory inode %" PRIu64 " error %d\n"),

