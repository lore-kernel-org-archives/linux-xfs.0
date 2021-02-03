Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808A5C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EEBB64F8D
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBCTon (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231153AbhBCToh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC4F864F93;
        Wed,  3 Feb 2021 19:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381434;
        bh=ZUpAQYI1TBt/lULUtGTnMdIuF9w5lxxqT6Rc8h4naKI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KBUu+jmQ+cLaZsYvV/8m21K5nmyhSTl1q1gR/uh56g8b5aZJair8HX6Crlqabnh2L
         w6PRB+9ucG7x1ltVyRCQxPtfnk0JNhQvp13z8Kwvcc9ye24be9r99ltfDy+VdVrgmb
         GqLg62A07Zr5oiQSx6565p1BkDmV8H9qr8OdhdDyL0HsPE0WmnbAOh7uqtn+EBwtVI
         y6YXMg+nNZtq0Y6KawnjJkeFCyPUhbe/fky1QeRcL+z64bwltJfJRe9B5JQRwAiQkI
         uOgUCrIgdda6qzqNAhoYVjAfzgG0AHJE08ix4EmOfay4rt+c59lBxsRdOPBaixruh4
         O7gCOwsFxO90A==
Subject: [PATCH 2/2] xfs_db: add bigtime upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de
Date:   Wed, 03 Feb 2021 11:43:54 -0800
Message-ID: <161238143420.1278478.12499496658916932300.stgit@magnolia>
In-Reply-To: <161238142268.1278478.11531156340909081942.stgit@magnolia>
References: <161238142268.1278478.11531156340909081942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c              |   15 +++++++++++++++
 man/man8/xfs_admin.8 |    6 ++++++
 man/man8/xfs_db.8    |    4 ++++
 3 files changed, 25 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index c303c321..2e94bed1 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -597,6 +597,7 @@ version_help(void)
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
 " 'version inobtcount' - enable inode btree counters\n"
+" 'version bigtime'  - enable timestamps beyond year 2038\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -877,6 +878,20 @@ version_f(
 			}
 
 			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "bigtime")) {
+			if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature is already enabled\n"));
+				return 1;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 2;
+				return 1;
+			}
+
+			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_BIGTIME;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8421e28f..f3b97b02 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -138,6 +138,12 @@ This reduces mount time by speeding up metadata space reservation calculations.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be writable by older kernels.
 This feature was added to Linux 5.10.
+.TP
+.B bigtime
+Upgrade a filesystem to support larger timestamps up to the year 2486.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.10.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 0335317e..ca959d16 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -979,6 +979,10 @@ option is specified and the filesystem is formatted with the V5 format.
 Support for the inode btree counters feature can be enabled by using the
 .B inobtcount
 option if the filesystem is formatted with the V5 format.
+Support for timestamps between the years 2038 and 2486 can be enabled by
+using the
+.B bigtime
+option if the filesystem is formatted with the V5 format.
 .IP
 If no argument is given, the current version and feature bits are printed.
 With one argument, this command will write the updated version number

