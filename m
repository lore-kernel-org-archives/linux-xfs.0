Return-Path: <SRS0=3PXQ=AL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44D5C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA1F20760
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Jun 2020 15:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TNBblIVf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389624AbgF3Plp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Jun 2020 11:41:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56438 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389630AbgF3Plp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 11:41:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFRNvU011662
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hRYBCr6jC6glGbuOBR3GaeWU2RhkD9hy3m3QDOKmdyg=;
 b=TNBblIVfrd9ZfwOPeR9DWIqMMMgYItG+wsRXvikVSeQexFWSyV/Ddg7ND5zKi3KgKMVk
 mLh11Knvsg/pvTp/pq81j1nkM0SXHK/4lLb/7Q6jZvTW7FtAXFkGcV5R9OVTB0Yny9UV
 5w6T79899/exlO7E5nbSgN4ctnvO3qdAJNaWiXmNgf98c6WntY94HXtybYfoqYKungkJ
 ejiNRhAQeanGEKIh56TqPcD3WYvsINSWCQ4aC7/Wy8phwWu0llxtAZ8+QSPaULXFA0/F
 ja4E9I0r7VQlU2uy6kaxqNQef0NrJgKFicuMdkX1/we5jGlpzI3hqxU5kXRw4MskOAMF Fg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31xx1dt5x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UFNk9n051025
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31xg1wy4vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:42 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UFfgwL000435
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2020 15:41:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 15:41:41 +0000
Subject: [PATCH 1/2] xfs: rtbitmap scrubber should verify written extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 30 Jun 2020 08:41:41 -0700
Message-ID: <159353170100.2864648.5747092047346568608.stgit@magnolia>
In-Reply-To: <159353169466.2864648.10518851810473831328.stgit@magnolia>
References: <159353169466.2864648.10518851810473831328.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=1 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Ensure that the realtime bitmap file is backed entirely by written
extents.  No holes, no unwritten blocks, etc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/rtbitmap.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index c642bc206c41..c777c98c50c3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -13,6 +13,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_inode.h"
+#include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
@@ -58,6 +59,41 @@ xchk_rtbitmap_rec(
 	return 0;
 }
 
+/* Make sure the entire rtbitmap file is mapped with written extents. */
+STATIC int
+xchk_rtbitmap_check_extents(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_bmbt_irec	map;
+	xfs_rtblock_t		off;
+	int			nmap;
+	int			error = 0;
+
+	for (off = 0; off < mp->m_sb.sb_rbmblocks;) {
+		if (xchk_should_terminate(sc, &error) ||
+		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			break;
+
+		/* Make sure we have a written extent. */
+		nmap = 1;
+		error = xfs_bmapi_read(mp->m_rbmip, off,
+				mp->m_sb.sb_rbmblocks - off, &map, &nmap,
+				XFS_DATA_FORK);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
+			break;
+
+		if (nmap != 1 || !xfs_bmap_is_written_extent(&map)) {
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
+			break;
+		}
+
+		off += map.br_blockcount;
+	}
+
+	return error;
+}
+
 /* Scrub the realtime bitmap. */
 int
 xchk_rtbitmap(
@@ -70,6 +106,10 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
+	error = xchk_rtbitmap_check_extents(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
 	error = xfs_rtalloc_query_all(sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out;

