Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE46C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D5F0610F9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237737AbhINCld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCld (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD536610D1;
        Tue, 14 Sep 2021 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587216;
        bh=o18SNfpxKXEHRwHWCvQ1qgCmdrG4xUlE29/n49hnEKU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=brflDvSkOSFUTor6a1a5+zbOUO+Oy/ZvW2ZhLSEheImCMWdREZ+bwxlEyUO2YfLDk
         vrTBD98kF1DqwXtZ6LFpgqitD+COIwys6fsj9rkVpKNWLFn/feVOUPEy6BxF2Mu5di
         6JITZ42KTeKxsGjYPwvousX/rZuldhkcONRxIf4pPTjzrenPxR68TMxv4XQL+rx4lx
         oFlO5GK+6VOV7JzdOF236NLcOlE+9xDB16QlEzHVNc+nK0LCze7vK4SbPkZqqtfnr5
         SyGimu2FP5Ekce1W36efmxxXaVYsxVYn2aWlnmKpZCpclgRvJxR8hfjyILM9zBFaJN
         X74RVlPMuGQ6w==
Subject: [PATCH 03/43] xfs: remove the active vs running quota differentiation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:16 -0700
Message-ID: <163158721644.1604118.9350600009342205792.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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

