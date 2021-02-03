Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E9C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0965264F60
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhBCToj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhBCTog (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E2064F91;
        Wed,  3 Feb 2021 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381429;
        bh=9cPDIM0mqw4NUPB0uXdNX3wWKfns+rLHw66WMjMX89U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j5wPhS9xheOJ+swZKArCPRuzKaQqgWdYHV5NgKl97t+F52+mCSnUG9jpbONHrly95
         /Dw5HSrfALnw0RLGANLcci9dOh37GnI9pGTrbiXdGqwiZD2iHoUBUWpRiC0PlNbqlk
         kRvw69NKaPBZ6/+CYlzkGudzyWoSvxU6pwBB+DIkmDK+vafW/zisBkX5++RdEZxV2C
         5g7ela+LkeNiuS/Ar/HRUkoomCpFckCfgKtQZgf4C0AsavBwX8++AQFiXK318/TgCS
         vNokVQdXmMVv6QyljxvxdKtGkjQ6TApgPyLb7FP9GqMVgt22L2wnlc9UwBVtNKcKmG
         HEJTPHhqwL/LQ==
Subject: [PATCH 1/2] xfs_db: add inobtcnt upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Date:   Wed, 03 Feb 2021 11:43:48 -0800
Message-ID: <161238142844.1278478.2875360961680710314.stgit@magnolia>
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

Enable users to upgrade their filesystems to support inode btree block
counters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c              |   21 +++++++++++++++++++++
 man/man8/xfs_admin.8 |    7 +++++++
 man/man8/xfs_db.8    |    3 +++
 3 files changed, 31 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 223b84fe..c303c321 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -596,6 +596,7 @@ version_help(void)
 " 'version attr2'    - enable v2 inline extended attributes\n"
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
+" 'version inobtcount' - enable inode btree counters\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -856,6 +857,26 @@ version_f(
 			}
 
 			v5features.incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		} else if (!strcasecmp(argv[1], "inobtcount")) {
+			if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
+				dbprintf(
+		_("inode btree counter feature is already enabled\n"));
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
index d8a0125c..8421e28f 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -131,6 +131,13 @@ Flag the filesystem as needing repairs.
 Until
 .BR xfs_repair (8)
 is run, the filesystem will not be mountable.
+.TP
+.B inobtcount
+Keep a count the number of blocks in each inode btree in the AGI.
+This reduces mount time by speeding up metadata space reservation calculations.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be writable by older kernels.
+This feature was added to Linux 5.10.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 792d98c8..0335317e 100644
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

