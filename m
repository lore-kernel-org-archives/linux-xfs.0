Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4199C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7712064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g67j3ckc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABJK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48742 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAABJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001198Cj091316
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=oJjBzELjruZx+FKsvSEFwR369Qz0YSXuX9Cpc+Wcs4E=;
 b=g67j3ckceM/JrIYzmxOSHGZwmudPNtWR5org4RdCUYrl8gunsLSUtLRWM7CWtYF95Mqk
 qIqCEuJWIAV6DkCLcfpt6Rq5Ep/+Era5yypTPjyxCm4qbmndu7nK3W23PeDLQsoHJC1a
 cmfR8K4jdq2MZizplZ8kO3AoqDffpzuq8KAVFyU+ji+2WPOWRQaonLjAhXxcLsyz9LDR
 SGaytlFyEPvXksG8EmlVVLlPUm5l5gi5uLObHiq1fwQpRka+SipCUeFRBlRTzJi3kWUa
 w8nJmelFSUOGg3RgKukNsDEQGgQSZxrvnvEIfesOBCiAVlWkjGt1JfHscHuy/TzI1Md9 mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Maa039570
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2x7medfab9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:07:07 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 001176xV030729
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:07:06 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:07:06 -0800
Subject: [PATCH 10/11] xfs: move xfs_inode_ag_iterator to be closer to the
 perag walking code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:07:02 -0800
Message-ID: <157784082215.1360343.9575394838862742771.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
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
index c3964af55979..d74f426a0293 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -787,6 +787,10 @@ xfs_inode_ag_walk_grab(
 	return false;
 }
 
+/*
+ * For a given per-AG structure @pag, @grab, @execute, and @rele all incore
+ * inodes with the given radix tree @tag.
+ */
 STATIC int
 xfs_inode_ag_walk(
 	struct xfs_mount	*mp,
@@ -892,6 +896,50 @@ xfs_inode_ag_walk(
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
@@ -945,46 +993,6 @@ xfs_cowblocks_worker(
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

