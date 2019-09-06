Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA30C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B8F3206B8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 03:36:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Le1amfjW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391317AbfIFDg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 23:36:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42142 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390521AbfIFDg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:36:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863Z4Pj074904;
        Fri, 6 Sep 2019 03:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TPzX0hZZhbMMVxlkKPESlwYZKKHukbSk4P4buLNRt+Y=;
 b=Le1amfjWKQViEHCrXoXqwFut8NBoFxbKQ8Ey3Kg8dC3mZwxWi6vxqtyHgw95+9su+Oks
 cgeIYkcyUaMf+exvEjOR/ewd30D43YzYR8xKv767EGOFal+C2Nh57/ssiQwyHBt4DnTy
 Nz2BuR0kZWZKGlBeeo656JIoCwztjbamYOnBoh8wLlB1sBMM6bsetYhz2fwBim18SF0C
 K1IdiSkrNerF+nfCsxM0j7l15GTyOdpDvCurmuNJIjjaHcYsE+EdvgLcJCJ1g3UU9Qsw
 R36AFZwDY/paVtxXW6kpkxof4FbvBaY5vBcKprM5ck87r2binH//C+nUQrcPHbU1gB4u pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uuf51g34q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:36:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YOJN088518;
        Fri, 6 Sep 2019 03:34:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b99pph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:34:24 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863XlkF018591;
        Fri, 6 Sep 2019 03:33:47 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:33:47 -0700
Subject: [PATCH 4/5] xfs_scrub: separate internal metadata scrub functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:33:47 -0700
Message-ID: <156774082719.2643094.12163874100429393033.stgit@magnolia>
In-Reply-To: <156774080205.2643094.9791648860536208060.stgit@magnolia>
References: <156774080205.2643094.9791648860536208060.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
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
 scrub/scrub.c |   95 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 47 insertions(+), 48 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 083ed9a1..b1927f38 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -276,47 +276,64 @@ xfs_scrub_save_repair(
 	return true;
 }
 
+/* Scrub non-inode metadata, saving corruption reports for later. */
+static int
+xfs_scrub_meta(
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
 /* Scrub metadata, saving corruption reports for later. */
 static bool
-xfs_scrub_metadata(
+xfs_scrub_meta_type(
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
+		ret = xfs_scrub_meta(ctx, type, agno, alist);
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
@@ -332,28 +349,10 @@ xfs_scrub_primary_super(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	struct xfs_scrub_metadata	meta = {
-		.sm_type = XFS_SCRUB_TYPE_SB,
-	};
-	enum check_outcome		fix;
-
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
+	int				ret;
 
-	return true;
+	ret = xfs_scrub_meta(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
+	return ret == 0;
 }
 
 /* Scrub each AG's header blocks. */
@@ -363,7 +362,7 @@ xfs_scrub_ag_headers(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
+	return xfs_scrub_meta_type(ctx, XFROG_SCRUB_TYPE_AGHEADER, agno, alist);
 }
 
 /* Scrub each AG's metadata btrees. */
@@ -373,7 +372,7 @@ xfs_scrub_ag_metadata(
 	xfs_agnumber_t			agno,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
+	return xfs_scrub_meta_type(ctx, XFROG_SCRUB_TYPE_PERAG, agno, alist);
 }
 
 /* Scrub whole-FS metadata btrees. */
@@ -382,7 +381,7 @@ xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	return xfs_scrub_metadata(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
+	return xfs_scrub_meta_type(ctx, XFROG_SCRUB_TYPE_FS, 0, alist);
 }
 
 /* How many items do we have to check? */

