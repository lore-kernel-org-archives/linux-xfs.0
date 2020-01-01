Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B784DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8637B2072A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iq/sT1Sa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgAABCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:02:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgAABCB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:02:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00110Afd104665;
        Wed, 1 Jan 2020 01:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DKK4IHitI0OH66pMFXDNlwIBOm9APi5eDvBCiOTJB48=;
 b=iq/sT1SaXWVVYWL/msq5lJd8CFd6IFGEMHH8KRw7a2bxv4DDdcD2/ha03sFQMaCO3l6D
 tYUF9s+CnH/Cja5UxPZ/GDGRRWIyoUND2bGOVFC+/A3APD0JejZQThxTj3sqEEzsN86b
 9dlwwRoWQvGAAF6kmsrHUDbDz9FAqUvw4ZFfwZJ9oVJ98TxLotGJ2SoiofopspiIhbF6
 dfNrwly7i1Cbl31eUGYi8l2LYYZftXBEr/H/0kCpUxfMHVYEA7u2t0UbYwDMzAfGlwsB
 3DUqjIqJTFyP4nlqNzMUa0SS/RWle/OtsnynNhzmSnBODMvUy5HqwKC3IMpkHA1XywPC rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x5xftk24s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:01:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wgup172120;
        Wed, 1 Jan 2020 01:01:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2x8bsrftj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:01:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00111t3a007749;
        Wed, 1 Jan 2020 01:01:55 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:01:55 -0800
Subject: [PATCH 2/5] xfs: replace open-coded bitmap weight logic
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Date:   Tue, 31 Dec 2019 17:01:53 -0800
Message-ID: <157784051320.1357533.2919743766130763189.stgit@magnolia>
In-Reply-To: <157784050067.1357533.242585262978035395.stgit@magnolia>
References: <157784050067.1357533.242585262978035395.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a xbitmap_hweight helper function so that we can get rid of the
open-coded loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/agheader_repair.c |   12 ++----------
 fs/xfs/scrub/bitmap.c          |   15 +++++++++++++++
 fs/xfs/scrub/bitmap.h          |    1 +
 3 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 9fbb6035f4e2..f35596cc26fb 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -482,8 +482,6 @@ xrep_agfl_collect_blocks(
 	struct xrep_agfl	ra;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_btree_cur	*cur;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*n;
 	int			error;
 
 	ra.sc = sc;
@@ -527,14 +525,8 @@ xrep_agfl_collect_blocks(
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
 	 * the AGFL we'll free them later.
 	 */
-	*flcount = 0;
-	for_each_xbitmap_extent(br, n, agfl_extents) {
-		*flcount += br->len;
-		if (*flcount > xfs_agfl_size(mp))
-			break;
-	}
-	if (*flcount > xfs_agfl_size(mp))
-		*flcount = xfs_agfl_size(mp);
+	*flcount = min_t(uint64_t, xbitmap_hweight(agfl_extents),
+			 xfs_agfl_size(mp));
 	return 0;
 
 err:
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index ab26201e9110..f88694f22d05 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -297,3 +297,18 @@ xbitmap_set_btblocks(
 	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock,
 			XFS_BTREE_VISIT_ALL, bitmap);
 }
+
+/* How many bits are set in this bitmap? */
+uint64_t
+xbitmap_hweight(
+	struct xbitmap		*bitmap)
+{
+	struct xbitmap_range	*bmr;
+	struct xbitmap_range	*n;
+	uint64_t		ret = 0;
+
+	for_each_xbitmap_extent(bmr, n, bitmap)
+		ret += bmr->len;
+
+	return ret;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 8db4017ac78e..900646b72de1 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -32,5 +32,6 @@ int xbitmap_set_btcur_path(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
 int xbitmap_set_btblocks(struct xbitmap *bitmap,
 		struct xfs_btree_cur *cur);
+uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

