Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125D1C432C2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC3821D80
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 21:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BzukGVdd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfIYVdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:33:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbfIYVdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:33:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTOHM050827;
        Wed, 25 Sep 2019 21:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=C7Yn5LhFV50oLNuGhuHbeZasL838OVzWKm4729WiPKk=;
 b=BzukGVddC3oLEPpjZn5bBxlF+ccjfNGXV12Ms75o9luxJrOOxVbSWZeOtqj5mVOMMRv7
 2K+25+IgmA/QK7TMJx8vBSNm9oAuxfFc4aTwxlcuZb9ANuNiSNL/qCF5hXYh2bwRVZfi
 sRNzvI3esI9uUDLHUxVyid/KJJvYnTTFEksGjAGGffdwzkru04Z/0RIX5bTi8IrGcIQo
 VLJC6iEbQFldy8vam9mU0DrLx9Tfz5RN+JMPinYjkIchzABrO7Ck6bWZL8QJsx576c0b
 EAVOumKMV1YP8A3D9sv1hEZKffjeMIVXgh8FLJaRKgw8vKKt5C+/XtBXVpVvqIvQtBkT UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2v5cgr7erb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:33:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLTEa8011682;
        Wed, 25 Sep 2019 21:31:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuhp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:31:33 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLVWQL013490;
        Wed, 25 Sep 2019 21:31:32 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:31:32 -0700
Subject: [PATCH 4/5] xfs_scrub: separate internal metadata scrub functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:31:29 -0700
Message-ID: <156944708984.296129.4265304780428958376.stgit@magnolia>
In-Reply-To: <156944706528.296129.7604742756772046951.stgit@magnolia>
References: <156944706528.296129.7604742756772046951.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_scrub_metadata into two functions -- one to make a single
call xfs_check_metadata, and the second retains the loop logic.  The
name is a little easy to confuse with other functions, so rename it to
reflect what it actually does: scrub all internal metadata of a given
class (AG header, AG metadata, FS metadata).  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/scrub.c |  101 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 52 insertions(+), 49 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 083ed9a1..2557da2a 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -276,47 +276,68 @@ xfs_scrub_save_repair(
 	return true;
 }
 
-/* Scrub metadata, saving corruption reports for later. */
+/* Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later. */
+static int
+xfs_scrub_meta_type(
+	struct scrub_ctx		*ctx,
+	unsigned int			type,
+	xfs_agnumber_t			agno,
+	struct xfs_action_list		*alist)
+{
+	struct xfs_scrub_metadata	meta = {
+		.sm_type		= type,
+		.sm_agno		= agno,
+	};
+	enum check_outcome		fix;
+
+	background_sleep();
+
+	/* Check the item. */
+	fix = xfs_check_metadata(ctx, &meta, false);
+	progress_add(1);
+
+	switch (fix) {
+	case CHECK_ABORT:
+		return ECANCELED;
+	case CHECK_REPAIR:
+		if (!xfs_scrub_save_repair(ctx, alist, &meta))
+			return ENOMEM;
+		/* fall through */
+	case CHECK_DONE:
+		return 0;
+	default:
+		/* CHECK_RETRY should never happen. */
+		abort();
+	}
+}
+
+/*
+ * Scrub all metadata types that are assigned to the given XFROG_SCRUB_TYPE_*,
+ * saving corruption reports for later.  This should not be used for
+ * XFROG_SCRUB_TYPE_INODE or for checking summary metadata.
+ */
 static bool
-xfs_scrub_metadata(
+xfs_scrub_all_types(
 	struct scrub_ctx		*ctx,
 	enum xfrog_scrub_type		scrub_type,
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	struct xfs_scrub_metadata	meta = {0};
 	const struct xfrog_scrub_descr	*sc;
-	enum check_outcome		fix;
-	int				type;
+	unsigned int			type;
 
 	sc = xfrog_scrubbers;
 	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		int			ret;
+
 		if (sc->type != scrub_type)
 			continue;
 		if (sc->flags & XFROG_SCRUB_DESCR_SUMMARY)
 			continue;
 
-		meta.sm_type = type;
-		meta.sm_flags = 0;
-		meta.sm_agno = agno;
-		background_sleep();
-
-		/* Check the item. */
-		fix = xfs_check_metadata(ctx, &meta, false);
-		progress_add(1);
-		switch (fix) {
-		case CHECK_ABORT:
+		ret = xfs_scrub_meta_type(ctx, type, agno, alist);
+		if (ret)
 			return false;
-		case CHECK_REPAIR:
-			if (!xfs_scrub_save_repair(ctx, alist, &meta))
-				return false;
-			/* fall through */
-		case CHECK_DONE:
-			continue;
-		case CHECK_RETRY:
-			abort();
-			break;
-		}
 	}
 
 	return true;
@@ -332,28 +353,10 @@ xfs_scrub_primary_super(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	struct xfs_scrub_metadata	meta = {
-		.sm_type = XFS_SCRUB_TYPE_SB,
-	};
-	enum check_outcome		fix;
+	int				ret;
 
-	/* Check the item. */
-	fix = xfs_check_metadata(ctx, &meta, false);
-	switch (fix) {
-	case CHECK_ABORT:
-		return false;
-	case CHECK_REPAIR:
-		if (!xfs_scrub_save_repair(ctx, alist, &meta))
-			return false;
-		/* fall through */
-	case CHECK_DONE:
-		return true;
-	case CHECK_RETRY:
-		abort();
-		break;
-	}
-
-	return true;
+	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
+	return ret == 0;
 }
 
 /* Scrub each AG's header blocks. */
@@ -363,7 +366,7 @@ xfs_scrub_ag_headers(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
+	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
 }
 
 /* Scrub each AG's metadata btrees. */
@@ -373,7 +376,7 @@ xfs_scrub_ag_metadata(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
+	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
 }
 
 /* Scrub whole-FS metadata btrees. */
@@ -382,7 +385,7 @@ xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
+	return xfs_scrub_all_types(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
 }
 
 /* How many items do we have to check? */

