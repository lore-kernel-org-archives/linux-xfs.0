Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCFEC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 490B3207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kQNTQOOL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEVC4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:56:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36768 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgEVC4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:56:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2lmNi110958;
        Fri, 22 May 2020 02:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dKKANqICKc2UVHW+GzGPLVcCKivJYMavij+f66dpKZs=;
 b=kQNTQOOLXATa3gL80of3gSZGhU71Th7ognmvwHPiwyzeUbKDuuSX2dHokjlQ/LsKhxts
 /OA1IMkobs+co+y9Zrwaum+EO7kkvUFFoTz1XAIWIxfcnUwbodc/pJwZ37d/5uGPbLiT
 kTMwRiSfoAarKvajrRJN6j4UbQG7+ieWlweFwlYGsEipJ0b/0psMaUA+GNzTbNBDIKd0
 NcIgk96cGADLigBxO4qowFRKIlc1umU3Nh/x5kagcF5tLJiqYIUEVlt3cPb/jUQ/2CsP
 rBNd2NiN5fHiMNkWEJV1zxp6IW31rh5A9Z1e3fLtnT05Zguabz5Kxzv/0Ydz+w2kNu0M AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krkk2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:54:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nGjJ151904;
        Fri, 22 May 2020 02:54:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 315023h6uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:54:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M2sXGO015580;
        Fri, 22 May 2020 02:54:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:54:33 -0700
Subject: [PATCH 10/12] xfs: move xfs_inode_ag_iterator to be closer to the
 perag walking code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Thu, 21 May 2020 19:54:32 -0700
Message-ID: <159011607216.77079.15513788306075418133.stgit@magnolia>
In-Reply-To: <159011600616.77079.14748275956667624732.stgit@magnolia>
References: <159011600616.77079.14748275956667624732.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=1 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the xfs_inode_ag_iterator function to be nearer xfs_inode_ag_walk
so that we don't have to scroll back and forth to figure out how the
incore inode walking function works.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   88 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 791544a1d54c..0e25d50372e2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -791,6 +791,10 @@ xfs_inode_ag_walk_grab(
 	return false;
 }
 
+/*
+ * For a given per-AG structure @pag, grab, @execute, and rele all incore
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
+xfs_inode_walk_get_perag(
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
+	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
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
-xfs_inode_walk_get_perag(
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
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
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

