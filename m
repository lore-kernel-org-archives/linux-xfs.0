Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31278C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE03F2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HCqLqKGJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgAABJQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:16 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgAABJQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190E9089146
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OaG8tpL4qB6UWPwwfBYGMRrnahpGobE/W8ACWnKvmuw=;
 b=HCqLqKGJd/BQJBDuH1rDxdTrm5ph4drUJRLQuDXD77LAawPrYbiarjm4t68XG8zitVV4
 61YnMLEj6JyGQNiMOZIER88rnlpP8w2FxBECMAlTaNXj5cZ7oRSnEm03oHErqMOXgxcV
 D41sELt1AK87UZVPF3LHpXxbc4PT75MoVsYijUvSeV9NdvwfVep3X3hDIpiZD5szToj0
 5xbawHAqquJlvGJYWF/2GkUNRn/99tpBBUa9rHNg0W58I399nTKXuEESV6aqYOuh5GJc
 qPK72Bmd4bBfHHY0qDHC8qTVDjIbMEOriJfptlU8cn+UHr+2x3Mq0kllqDP8+3bOcVJF Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vOK190257
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x8bsrfyke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00119D8E011036
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:13 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:13 -0800
Subject: [PATCH 05/10] xfs: pass around xfs_inode_ag_walk iget/irele helper
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:11 -0800
Message-ID: <157784095105.1362752.6192279595180573182.stgit@magnolia>
In-Reply-To: <157784092020.1362752.15046503361741521784.stgit@magnolia>
References: <157784092020.1362752.15046503361741521784.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an alternative version of xfs_ici_walk() that allow a caller to
pass in custom inode grab and inode release helper functions.  Deferred
inode inactivation deals with xfs inodes that are still in memory but no
longer visible to the vfs, which means that it has to screen and process
those inodes differently.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |   82 +++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_icache.h |    6 ++--
 2 files changed, 65 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d9bfc78a1b85..01f5502d984a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -792,20 +792,38 @@ xfs_inode_ag_walk_grab(
 	return false;
 }
 
+struct xfs_ici_walk_ops {
+	/*
+	 * Examine the given inode to decide if we want to pass it to the
+	 * execute function.  If so, this function should do whatever is needed
+	 * to prevent others from grabbing it.  If not, this function should
+	 * release the inode.
+	 */
+	bool		(*igrab)(struct xfs_inode *ip, int iter_flags);
+
+	/* Do something with the given inode. */
+	xfs_ici_walk_fn	iwalk;
+
+	/*
+	 * Release an inode after the execution function runs.  This function
+	 * is optional.
+	 */
+	void		(*irele)(struct xfs_inode *ip);
+};
+
 /*
  * For a given per-AG structure @pag, @grab, @execute, and @rele all incore
  * inodes with the given radix tree @tag.
  */
 STATIC int
 xfs_ici_walk_ag(
-	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, void *args),
+	const struct xfs_ici_walk_ops *ops,
+	int			iter_flags,
 	void			*args,
-	int			tag,
-	int			iter_flags)
+	int			tag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
@@ -846,7 +864,7 @@ xfs_ici_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_inode_ag_walk_grab(ip, iter_flags))
+			if (done || !ops->igrab(ip, iter_flags))
 				batch[i] = NULL;
 
 			/*
@@ -877,8 +895,9 @@ xfs_ici_walk_ag(
 			if ((iter_flags & XFS_ICI_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], pag, args);
-			xfs_irele(batch[i]);
+			error = ops->iwalk(batch[i], pag, args);
+			if (ops->irele)
+				ops->irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -915,15 +934,14 @@ xfs_ici_walk_get_perag(
 }
 
 /*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
+ * Call the @grab, @execute, and @rele functions on all incore inodes matching
+ * the radix tree @tag.
  */
 STATIC int
-xfs_ici_walk(
+xfs_ici_walk_fns(
 	struct xfs_mount	*mp,
+	const struct xfs_ici_walk_ops *ops,
 	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, void *args),
 	void			*args,
 	int			tag)
 {
@@ -935,8 +953,7 @@ xfs_ici_walk(
 	ag = 0;
 	while ((pag = xfs_ici_walk_get_perag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_ici_walk_ag(mp, pag, execute, args, tag,
-				iter_flags);
+		error = xfs_ici_walk_ag(pag, ops, iter_flags, args, tag);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -947,6 +964,27 @@ xfs_ici_walk(
 	return last_error;
 }
 
+/*
+ * Call the @execute function on all incore inodes matching a given radix tree
+ * @tag.
+ */
+STATIC int
+xfs_ici_walk(
+	struct xfs_mount	*mp,
+	int			iter_flags,
+	xfs_ici_walk_fn		iwalk,
+	void			*args,
+	int			tag)
+{
+	struct xfs_ici_walk_ops	ops = {
+		.igrab		= xfs_inode_ag_walk_grab,
+		.iwalk		= iwalk,
+		.irele		= xfs_irele,
+	};
+
+	return xfs_ici_walk_fns(mp, &ops, iter_flags, args, tag);
+}
+
 /*
  * Walk all incore inodes in the filesystem.  Knowledge of radix tree tags
  * is hidden and we always wait for INEW inodes.
@@ -954,11 +992,10 @@ xfs_ici_walk(
 int
 xfs_ici_walk_all(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip,
-					   struct xfs_perag *pag, void *args),
+	xfs_ici_walk_fn		iwalk,
 	void			*args)
 {
-	return xfs_ici_walk(mp, XFS_ICI_WALK_INEW_WAIT, execute, args,
+	return xfs_ici_walk(mp, XFS_ICI_WALK_INEW_WAIT, iwalk, args,
 			XFS_ICI_NO_TAG);
 }
 
@@ -1000,8 +1037,13 @@ xfs_blockgc_scan_pag(
 	struct xfs_perag	*pag,
 	struct xfs_eofblocks	*eofb)
 {
-	return xfs_ici_walk_ag(pag->pag_mount, pag, xfs_blockgc_scan_inode,
-			eofb, XFS_ICI_BLOCK_GC_TAG, 0);
+	static const struct xfs_ici_walk_ops	ops = {
+		.igrab		= xfs_inode_ag_walk_grab,
+		.iwalk		= xfs_blockgc_scan_inode,
+		.irele		= xfs_irele,
+	};
+
+	return xfs_ici_walk_ag(pag, &ops, 0, eofb, XFS_ICI_BLOCK_GC_TAG);
 }
 
 /* Scan all incore inodes for block preallocations that we can remove. */
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d7713eb0734d..3c34c0e2e266 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -69,9 +69,9 @@ void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
 
-int xfs_ici_walk_all(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, void *args),
-	void *args);
+typedef int (*xfs_ici_walk_fn)(struct xfs_inode *ip, struct xfs_perag *pag,
+			       void *args);
+int xfs_ici_walk_all(struct xfs_mount *mp, xfs_ici_walk_fn iwalk, void *args);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);

