Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330F0C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083762075F
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 01:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BvZelhaV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgETBsh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 21:48:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47200 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:48:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1ldtI066176;
        Wed, 20 May 2020 01:48:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7UhTh9jl7CRy/kNqvNn+6ISvvnHoCTekbakDbDaqNPU=;
 b=BvZelhaVJkWw7UwILllns0aUAL6tPEmiS4NAUWUH7C6g5yYwy3V8RYH84L5yohNAUFiV
 1mJV+UiBy0PpTqTlP9Od1zt9ipsiAeAvf86dFIEpUjOhq420vziGrStAR9eZIIORZZCn
 m3cOYN26bg1kE7JwbhJ5xBV4mr/2Q97M8ZbKCGKErXpzUX2ZzHlb8/BUNLs1cg8Vhgxy
 /PmuFt6asElkUxeF2JczTzV81MvrEetxQ+TXlVAeI00uOSOdLStmkuJ7TmCDSlYVm/j6
 5SRCy7szMYxQkufvtsYv++SIqJXUpoArTn4qvxqXHZF23YqFequjEMH3Z3qIUTPicQmU pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3128tngf6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:48:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1gZEG143026;
        Wed, 20 May 2020 01:46:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj2kbbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:46:22 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1kLKQ008497;
        Wed, 20 May 2020 01:46:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:46:21 -0700
Subject: [PATCH 10/11] xfs: move xfs_inode_ag_iterator to be closer to the
 perag walking code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Tue, 19 May 2020 18:46:20 -0700
Message-ID: <158993918077.976105.14120724292952648260.stgit@magnolia>
In-Reply-To: <158993911808.976105.13679179790848338795.stgit@magnolia>
References: <158993911808.976105.13679179790848338795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the xfs_inode_ag_iterator function to be nearer xfs_inode_ag_walk
so that we don't have to scroll back and forth to figure out how the
incore inode walking function works.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   88 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6c8c626e7ef1..05614758fb1e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -791,6 +791,10 @@ xfs_inode_ag_walk_grab(
 	return false;
 }
 
+/*
+ * For a given per-AG structure @pag, @grab, @execute, and @rele all incore
+ * inodes with the given radix tree @tag.
+ */
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
@@ -896,6 +900,50 @@ xfs_inode_ag_walk(
 	return last_error;
 }
 
+/* Fetch the next (possibly tagged) per-AG structure. */
+static inline struct xfs_perag *
+xfs_ici_walk_get_perag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			tag)
+{
+	if (tag == XFS_ICI_NO_TAG)
+		return xfs_perag_get(mp, agno);
+	return xfs_perag_get_tag(mp, agno, tag);
+}
+
+/*
+ * Call the @execute function on all incore inodes matching the radix tree
+ * @tag.
+ */
+int
+xfs_inode_ag_iterator(
+	struct xfs_mount	*mp,
+	int			iter_flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		ag;
+
+	ag = 0;
+	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
+		ag = pag->pag_agno + 1;
+		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
+				iter_flags);
+		xfs_perag_put(pag);
+		if (error) {
+			last_error = error;
+			if (error == -EFSCORRUPTED)
+				break;
+		}
+	}
+	return last_error;
+}
+
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
  * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -959,46 +1007,6 @@ xfs_cowblocks_worker(
 	xfs_queue_cowblocks(mp);
 }
 
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_ici_walk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	int			tag)
-{
-	if (tag == XFS_ICI_NO_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
-int
-xfs_inode_ag_iterator(
-	struct xfs_mount	*mp,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_ag_walk(mp, pag, execute, args, tag,
-				iter_flags);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == -EFSCORRUPTED)
-				break;
-		}
-	}
-	return last_error;
-}
-
 /*
  * Grab the inode for reclaim exclusively.
  * Return 0 if we grabbed it, non-zero otherwise.

