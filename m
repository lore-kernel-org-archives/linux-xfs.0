Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB804C43333
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B9D23B1F
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbhAPBZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729032AbhAPBZy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECC9023A55;
        Sat, 16 Jan 2021 01:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760303;
        bh=qLhjX7dcH9E6W/FDB4O9RKYqyXNIvtPWeUvGMsnCiyY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g899SchBsNixUOJnykG6rijKQGfl/vTC4E4WElVjo6uXeUytKoAtDMxz5O8OwHU6v
         Jz4vB8WTOdhpysC+OvDBWjFmMI+1VIsSNtJrHjJdDCD1hDhFTnmD6oNoPn5sy2+2Dz
         e6gnrHuB/ubnVDvgnAC4XShfIZsnqTV5GvYMM6CHzhPmHmFkfR4i128AvmkEQTEm1a
         07168lh/v707dG4Jp9VxleZufTRzYedLSz7PgJQYbqin++obTWU4fh0MLjxuOPlIOz
         bTYoQQtbryTN/iLASJFz8AmaFrxTgtT+VgjTGc0M3es4iBJR80P6aUoWUocLufiGXC
         DtBFTysuBio9Q==
Subject: [PATCH 1/2] xfs_db: add inobtcnt upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:02 -0800
Message-ID: <161076030226.3386576.6554233553313283950.stgit@magnolia>
In-Reply-To: <161076029632.3386576.16317498856185564786.stgit@magnolia>
References: <161076029632.3386576.16317498856185564786.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable users to upgrade their filesystems to support inode btree block
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c              |   22 ++++++++++++++++++++++
 man/man8/xfs_admin.8 |    7 +++++++
 man/man8/xfs_db.8    |    3 +++
 3 files changed, 32 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index fcc2a0ed..767bc858 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -597,6 +597,7 @@ version_help(void)
 " 'version attr2'    - enable v2 inline extended attributes\n"
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
+" 'version inobtcount' - enable inode btree counters\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -852,6 +853,27 @@ version_f(
 			}
 
 			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		} else if (!strcasecmp(argv[1], "inobtcount")) {
+			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature is already enabled\n"));
+				exitcode = 2;
+				return 1;
+			}
+			if (!xfs_sb_version_hasfinobt(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on filesystems lacking free inode btrees\n"));
+				exitcode = 2;
+				return 1;
+			}
+			if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature cannot be enabled on pre-V5 filesystems\n"));
+				exitcode = 2;
+				return 1;
+			}
+
+			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
 		} else if (!strcasecmp(argv[1], "extflg")) {
 			switch (XFS_SB_VERSION_NUM(&mp->m_sb)) {
 			case XFS_SB_VERSION_1:
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index b423981d..a776b375 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -116,6 +116,13 @@ If this is a V5 filesystem, flag the filesystem as needing repairs.
 Until
 .BR xfs_repair (8)
 is run, the filesystem will not be mountable.
+.TP
+.B inobtcount
+Upgrade a V5 filesystem to support the inode btree counters feature.
+This reduces mount time by caching the size of the inode btrees in the
+allocation group metadata.
+Once enabled, the filesystem will not be writable by older kernels.
+The filesystem cannot be downgraded after this feature is enabled.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 7331cf19..1b826e5d 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -976,6 +976,9 @@ The filesystem can be flagged as requiring a run through
 if the
 .B needsrepair
 option is specified and the filesystem is formatted with the V5 format.
+Support for the inode btree counters feature can be enabled by using the
+.B inobtcount
+option if the filesystem is formatted with the V5 format.
 .IP
 If no argument is given, the current version and feature bits are printed.
 With one argument, this command will write the updated version number

