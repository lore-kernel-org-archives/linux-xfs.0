Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256C0C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D790F20809
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:40:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hAUJ193l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407477AbgJZXkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:40:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407476AbgJZXkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:40:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOxxt157912;
        Mon, 26 Oct 2020 23:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D4tMEd1voaClIbHR62OAfMT161ZEa04IvT7K7UsTahg=;
 b=hAUJ193l1gRLIkSbeS1lch67aahcaFcjM0DvlAWZlPWsyk2wlNui0Q8J0+uls3BN98l/
 6Or2uDSD9J+h+jM5eHRLC3Y1FxMNSEWxIrWK2L9fTobw/knPPPk1Pc3ZpxKMh0DbgYMZ
 MUIbGsYCwZCUDdqKct6S0F1/U30d1wUWLSDVEgBOLHAJfpDCvWtiigBEQO9FWWkEndSB
 m2BkjgN+us0+FfkQTH5R4w8Zm7JgLhANIOU9QMSJtzUSRWLzfdHD2QUQ2g3sOmLX44Po
 goFbRrtVDxliNFfXPybqyODFRDnAvBDWIelwk99u5jizgMPmTc3hAsva0X04FcVcBuyo mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxck110486;
        Mon, 26 Oct 2020 23:38:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5wftr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNc8Dq013939;
        Mon, 26 Oct 2020 23:38:08 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:07 -0700
Subject: [PATCH 11/21] xfs: avoid shared rmap operations for attr fork extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:06 -0700
Message-ID: <160375548682.882906.8680884874833056428.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: d7884e6e90da974b50dc2c3bf50e03b70750e5f1

During code review, I noticed that the rmap code uses the (slower)
shared mappings rmap functions for any extent of a reflinked file, even
if those extents are for the attr fork, which doesn't support sharing.
We can speed up rmap a tiny bit by optimizing out this case.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rmap.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 6fdaa04ff0d8..f02f38ac4565 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2504,12 +2504,15 @@ xfs_rmap_map_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
+	enum xfs_rmap_intent_type type = XFS_RMAP_MAP;
+
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
 
-	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
-			XFS_RMAP_MAP_SHARED : XFS_RMAP_MAP, ip->i_ino,
-			whichfork, PREV);
+	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
+		type = XFS_RMAP_MAP_SHARED;
+
+	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2520,12 +2523,15 @@ xfs_rmap_unmap_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
+	enum xfs_rmap_intent_type type = XFS_RMAP_UNMAP;
+
 	if (!xfs_rmap_update_is_needed(tp->t_mountp, whichfork))
 		return;
 
-	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
-			XFS_RMAP_UNMAP_SHARED : XFS_RMAP_UNMAP, ip->i_ino,
-			whichfork, PREV);
+	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
+		type = XFS_RMAP_UNMAP_SHARED;
+
+	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
 }
 
 /*
@@ -2542,12 +2548,15 @@ xfs_rmap_convert_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
+	enum xfs_rmap_intent_type type = XFS_RMAP_CONVERT;
+
 	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return;
 
-	__xfs_rmap_add(tp, xfs_is_reflink_inode(ip) ?
-			XFS_RMAP_CONVERT_SHARED : XFS_RMAP_CONVERT, ip->i_ino,
-			whichfork, PREV);
+	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
+		type = XFS_RMAP_CONVERT_SHARED;
+
+	__xfs_rmap_add(tp, type, ip->i_ino, whichfork, PREV);
 }
 
 /* Schedule the creation of an rmap for non-file data. */

