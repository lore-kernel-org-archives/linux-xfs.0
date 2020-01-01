Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E55C2D0DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6242064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:09:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="izaQarDL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABJK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:09:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48756 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgAABJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:09:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190j1091263
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+05yX1vqhyr3tBXE68f5jvu7CUA2x7DycxpASCpqq7A=;
 b=izaQarDLuu1O4tiGSWnHEfn5ietAIwWXsKHJsDSG6NSTNHXmRaPgTyCt6B+iUUSi3bxf
 B3OxkUETuRHVq/mu/GR0KK0i/zmE5owYbi5CRuriQVNM1Oab3qKWIbGDfVZL8iafmcAU
 Ic6gACYoEz18WAO8usE6tKcm8PQJtBWBcLJRdGtG4e8ZUfzUlPqx8lJJMzn3IcvSpZJf
 10ePQaxucom0wiQrQIBdyAcwtdWRthoTZRR9GvsKvi62pj7l15GpN92QeBLML4Q5Yg0K
 VjpBV30uvjzvc/XMGKQMFXpPweFsyLCsrzVz6bTxpP8l00H2pjTidn+CAhn/q+5rL/nw 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118uXZ045261
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medfb4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:09:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 001197em011027
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:09:07 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:09:07 -0800
Subject: [PATCH 04/10] xfs: pass per-ag structure to the xfs_ici_walk
 execute function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:09:05 -0800
Message-ID: <157784094496.1362752.10290761414347952592.stgit@magnolia>
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

Pass the per-AG structure to the xfs_ici_walk execute function.  This
isn't needed now, but deferred inactivation will need it to modify some
per-ag data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |   24 ++++++++++++++++--------
 fs/xfs/xfs_icache.h      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |    1 +
 3 files changed, 18 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1a09d4854266..d9bfc78a1b85 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,8 +26,10 @@
 
 #include <linux/iversion.h>
 
-STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, void *args);
-STATIC int xfs_inode_free_cowblocks(struct xfs_inode *ip, void *args);
+STATIC int xfs_inode_free_eofblocks(struct xfs_inode *ip, struct xfs_perag *pag,
+		void *args);
+STATIC int xfs_inode_free_cowblocks(struct xfs_inode *ip, struct xfs_perag *pag,
+		void *args);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -798,7 +800,8 @@ STATIC int
 xfs_ici_walk_ag(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	int			(*execute)(struct xfs_inode *ip, void *args),
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, void *args),
 	void			*args,
 	int			tag,
 	int			iter_flags)
@@ -874,7 +877,7 @@ xfs_ici_walk_ag(
 			if ((iter_flags & XFS_ICI_WALK_INEW_WAIT) &&
 			    xfs_iflags_test(batch[i], XFS_INEW))
 				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], args);
+			error = execute(batch[i], pag, args);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -919,7 +922,8 @@ STATIC int
 xfs_ici_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, void *args),
 	void			*args,
 	int			tag)
 {
@@ -950,7 +954,8 @@ xfs_ici_walk(
 int
 xfs_ici_walk_all(
 	struct xfs_mount	*mp,
-	int			(*execute)(struct xfs_inode *ip, void *args),
+	int			(*execute)(struct xfs_inode *ip,
+					   struct xfs_perag *pag, void *args),
 	void			*args)
 {
 	return xfs_ici_walk(mp, XFS_ICI_WALK_INEW_WAIT, execute, args,
@@ -977,15 +982,16 @@ xfs_queue_blockgc(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
 	void			*args)
 {
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, args);
+	error = xfs_inode_free_eofblocks(ip, pag, args);
 	if (error && error != -EAGAIN)
 		return error;
 
-	return xfs_inode_free_cowblocks(ip, args);
+	return xfs_inode_free_cowblocks(ip, pag, args);
 }
 
 /* Scan an AG's inodes for block preallocations that we can remove. */
@@ -1528,6 +1534,7 @@ xfs_inode_matches_eofb(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
@@ -1806,6 +1813,7 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
 	void			*args)
 {
 	struct xfs_eofblocks	*eofb = args;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index ee4e05b59afb..d7713eb0734d 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -70,7 +70,7 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
 
 int xfs_ici_walk_all(struct xfs_mount *mp,
-	int (*execute)(struct xfs_inode *ip, void *args),
+	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, void *args),
 	void *args);
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index d93bf0c39d3d..fa0db72f8d0d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -733,6 +733,7 @@ struct xfs_dqrele {
 STATIC int
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
 	void			*args)
 {
 	struct xfs_dqrele	*dqr = args;

