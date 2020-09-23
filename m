Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E384DC2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 18:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78CE22220D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 18:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ue/QcfOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgIWSXo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 14:23:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56900 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWSXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 14:23:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NI8okO016862
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 18:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=TefSo923u3IlbPfa6JQMWogRkiTZRq2RIw0zhnJ5EZU=;
 b=ue/QcfOftU/m0pHP/ywBPWXApgVTnlGgvb3lhZDXpjFrCN1cCSdU12t1tjFWLyIhrEzW
 pHimrPHKDwakqAtHweWjsLqie/TheH+JiLrIJGggvj3MBBE3UIzX72WwDboJ/K0B1jm/
 aHEjAc5eHEyn9OXvZjUN35Nce+MmAOSzrrDiIuETnVwwlGYN5J3tOlKwgmaknEHD5s8L
 G5COagS6Rv/rOldwd9cPe7e9c0zLGSHipJtl+qvC361eFLGHewT/OyCVO2q5exKaAU98
 F9eFREgHnjs01dw/72sAHp6Qk2uPu0IgKWJ4o+Ccn7McDUaz/hNJfN5183egAetFcGW+ 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnum53p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 18:23:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NIBQQK165998
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 18:23:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux1hugf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 18:23:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NINf7w022179
        for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2020 18:23:42 GMT
Received: from localhost (/10.159.225.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 11:23:41 -0700
Date:   Wed, 23 Sep 2020 11:23:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: avoid shared rmap operations for attr fork extents
Message-ID: <20200923182340.GV7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230138
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

During code review, I noticed that the rmap code uses the (slower)
shared mappings rmap functions for any extent of a reflinked file, even
if those extents are for the attr fork, which doesn't support sharing.
We can speed up rmap a tiny bit by optimizing out this case.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 27c39268c31f..340c83f76c80 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2505,12 +2505,15 @@ xfs_rmap_map_extent(
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
@@ -2521,12 +2524,15 @@ xfs_rmap_unmap_extent(
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
@@ -2543,12 +2549,15 @@ xfs_rmap_convert_extent(
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
