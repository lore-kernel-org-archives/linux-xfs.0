Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FE4AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbiATARt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344835AbiATARr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:17:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C63C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40257B81B2B
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0857DC004E1;
        Thu, 20 Jan 2022 00:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637865;
        bh=o18SNfpxKXEHRwHWCvQ1qgCmdrG4xUlE29/n49hnEKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sq8/c/xZMmDKFp3pm0x0htfqPzjEtB5/5RI+0Y2/jCo1R8Kqd6ZigNcle2roVLcd1
         DcLzWz/Ukcjzy59DGZFtFgUCOSQUViYtq9puWZkMWMX8rtJHS1GscS9B7OqQdcrK1A
         lzqwRAITTY/RSAA0pXpZdyU1Vcs39Faaj+VCcT0JLjBiO9ni8ESI0FSGn/qoYbgC1Q
         QBIzYTQJWtWRRwvA4cONfuI6uGLa0+ZqLNdI6fI1e2NYy65rnwiz7vyWTnRAz1Opz3
         kOBWlEknphKJm4TFVKrLiIgrJ511hbSMMNlN7zDSOQs+QKIcyMDEP78Y5hkOfkABd2
         J6UyUvCAgC49w==
Subject: [PATCH 04/45] xfs: remove the active vs running quota differentiation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:17:44 -0800
Message-ID: <164263786471.860211.1103707590827124880.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 149e53afc851713a70b6a06ebfaf2ebf25975454

These only made a difference when quotaoff supported disabling quota
accounting on a mounted file system, so we can switch everyone to use
a single set of flags and helpers now. Note that the *QUOTA_ON naming
for the helpers is kept as it was the much more commonly used one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_quota_defs.h |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)


diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index 0f0af4e3..a02c5062 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -60,36 +60,14 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQUOT_LOGRES(mp)	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
-#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
-#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
-#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
-#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
+#define XFS_IS_UQUOTA_ON(mp)		((mp)->m_qflags & XFS_UQUOTA_ACCT)
+#define XFS_IS_PQUOTA_ON(mp)		((mp)->m_qflags & XFS_PQUOTA_ACCT)
+#define XFS_IS_GQUOTA_ON(mp)		((mp)->m_qflags & XFS_GQUOTA_ACCT)
 #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
 #define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
 #define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
 
-/*
- * Incore only flags for quotaoff - these bits get cleared when quota(s)
- * are in the process of getting turned off. These flags are in m_qflags but
- * never in sb_qflags.
- */
-#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x2000  /* gquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x4000  /* pquotas are being turned off */
-#define XFS_ALL_QUOTA_ACTIVE	\
-	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
-
-/*
- * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
- * quota will be not be switched off as long as that inode lock is held.
- */
-#define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
-						   XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
-#define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
-#define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
-
 /*
  * Flags to tell various functions what to do. Not all of these are meaningful
  * to a single function. None of these XFS_QMOPT_* flags are meant to have

