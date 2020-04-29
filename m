Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE399C83001
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61CA20737
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KddiyfpY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD2CqY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 22:46:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgD2CqX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 22:46:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2hRRk121494
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cwUApK/iK31e4iQ0bCEMVW7nbyu+IUnSotUEO3XpJjI=;
 b=KddiyfpYGYe8DRs3XXwpYH0lPOv4ZWPkIZiLedq2sZqFhrU368Bkg1mr5tezlUuXLE5q
 qmcJGUikSMRSPtTus4mbA27lt5I8FMn/stFCQmYgC3Q93sXOQkRP4fjCFuTDyNXgmB63
 VTpkFimo3ch+InQwTUKDzQg+okpXjvkzNkcgSWRlLpItAcYlhFz3jjtUQKyUIZDlwNKA
 zko+zJ3OAimkpjFm+0RXS1fYU/Bi6s7lex8/j6ZFw1g9vpS+OPKiP7MQ9GEhsWmuWIHb
 rXwoNFSbmYz6DTcFP36R6VDRhjbHdeBA3OOhGM9kl/i750qZYiK/h4+NHvJ5uWTlp54v aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p08p4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2ft87096169
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30pvcytenc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03T2kLSU004199
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 19:46:21 -0700
Subject: [PATCH 1/5] xfs: parent repair should try the dcache first
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Apr 2020 19:46:20 -0700
Message-ID: <158812838045.169849.14057774270874259846.stgit@magnolia>
In-Reply-To: <158812837421.169849.625434931406278072.stgit@magnolia>
References: <158812837421.169849.625434931406278072.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004290020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we need to find a directory's parent, try the dcache first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dir_repair.c    |    7 +++++-
 fs/xfs/scrub/parent.h        |    1 +
 fs/xfs/scrub/parent_repair.c |   47 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 49 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 33e98e4172db..b299f8b35ce4 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -728,11 +728,16 @@ xrep_dir_validate_parent(
 
 	/*
 	 * If the directory salvage scan found no parent or found an obviously
-	 * incorrect parent, jump to the filesystem scan.
+	 * incorrect parent, try asking the dcache for the parent.
+	 *
+	 * If the dcache doesn't know about a parent or the parent seems
+	 * obviously incorrect, jump to the filesystem scan.
 	 *
 	 * Otherwise, if the alleged parent seems plausible, scan the directory
 	 * to make sure it really points to us.
 	 */
+	if (!xrep_parent_acceptable(sc, rd->parent_ino))
+		rd->parent_ino = xrep_parent_check_dcache(sc->ip);
 	if (!xrep_parent_acceptable(sc, rd->parent_ino))
 		goto scan;
 
diff --git a/fs/xfs/scrub/parent.h b/fs/xfs/scrub/parent.h
index 6c79f7f99e9e..62db392b19a5 100644
--- a/fs/xfs/scrub/parent.h
+++ b/fs/xfs/scrub/parent.h
@@ -14,5 +14,6 @@ typedef int (*xrep_parents_iter_fn)(struct xfs_inode *dp, struct xfs_name *name,
 int xrep_scan_for_parents(struct xfs_scrub *sc, xfs_ino_t target_ino,
 		xrep_parents_iter_fn fn, void *data);
 bool xrep_parent_acceptable(struct xfs_scrub *sc, xfs_ino_t ino);
+xfs_ino_t xrep_parent_check_dcache(struct xfs_inode *dp);
 
 #endif /* __XFS_SCRUB_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 3d3993ba920d..44cd7da405e5 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -174,6 +174,37 @@ xrep_parents_scan_inode(
 	return error;
 }
 
+/* Does the dcache have a parent for this directory? */
+xfs_ino_t
+xrep_parent_check_dcache(
+	struct xfs_inode	*dp)
+{
+	struct inode		*pip = NULL;
+	struct dentry		*dentry, *parent;
+	xfs_ino_t		ret = NULLFSINO;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	dentry = d_find_alias(VFS_I(dp));
+	if (!dentry)
+		goto out;
+
+	parent = dget_parent(dentry);
+	if (!parent)
+		goto out_dput;
+
+	pip = igrab(d_inode(parent));
+	dput(parent);
+
+	ret = pip->i_ino;
+	xfs_irele(XFS_I(pip));
+
+out_dput:
+	dput(dentry);
+out:
+	return ret;
+}
+
 /* Is this an acceptable parent for the inode we're scrubbing? */
 bool
 xrep_parent_acceptable(
@@ -271,11 +302,17 @@ xrep_parent(
 	if (sick & XFS_SICK_INO_DIR)
 		return -EFSCORRUPTED;
 
-	/* Scan the entire directory tree for the directory's parent. */
-	error = xrep_scan_for_parents(sc, sc->ip->i_ino, xrep_parent_absorb,
-			&rp);
-	if (error)
-		return error;
+	/*
+	 * Ask the dcache who it thinks the parent might be.  If that doesn't
+	 * pass muster, scan the entire filesystem for the directory's parent.
+	 */
+	rp.parent_ino = xrep_parent_check_dcache(sc->ip);
+	if (!xrep_parent_acceptable(sc, rp.parent_ino)) {
+		error = xrep_scan_for_parents(sc, sc->ip->i_ino,
+				xrep_parent_absorb, &rp);
+		if (error)
+			return error;
+	}
 
 	/* If we still don't have a parent, bail out. */
 	if (!xrep_parent_acceptable(sc, rp.parent_ino))

