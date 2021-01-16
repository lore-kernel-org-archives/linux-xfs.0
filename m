Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3543C43217
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03B623A55
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 01:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbhAPBZy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbhAPBZy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8394207B6;
        Sat, 16 Jan 2021 01:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760309;
        bh=bz3X85Q+3OlxTcmA5FLHTqj46DWB2ibH1B5ptm3y8xo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bZjGbkRD5AlZYIISyb2KnwSFxey1sqISVeGCWpy/yZLvZBGzSPCVP70zPdadofx3S
         f16LgkiLMGbsth658VWv9qsBLxpHMkbtmWw1d3Y60qsLWst44+rbaiT7z1FJBc0i0A
         dK+IVcUPCGMakyjsvpKxXn7guMjth5qIXYRrAMVo6zdx8/ioPLXEHCyP/0woiGYgsQ
         SXLFZtldfdEbAKLlGMP0K5Wdkh7DWlm6g9vI6dYRGYNl+qY6Z3v+duIqkACgbrJqS0
         HkcpfQqVmk2XF69KzVGdASTnjXBnvRxM8WcisPBuqjk0aGqwn0Qt5PB//ReSV+KuBq
         7JpDPS8wtBRAA==
Subject: [PATCH 2/2] xfs_db: add bigtime upgrade path
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:25:08 -0800
Message-ID: <161076030825.3386576.13001418188822105448.stgit@magnolia>
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

Enable users to upgrade their filesystems to bigtime support.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/sb.c              |   16 ++++++++++++++++
 man/man8/xfs_admin.8 |    5 +++++
 man/man8/xfs_db.8    |    4 ++++
 3 files changed, 25 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index 767bc858..2ab07533 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -598,6 +598,7 @@ version_help(void)
 " 'version log2'     - enable v2 log format\n"
 " 'version needsrepair' - flag filesystem as requiring repair\n"
 " 'version inobtcount' - enable inode btree counters\n"
+" 'version bigtime'  - enable timestamps beyond year 2038\n"
 "\n"
 "The version function prints currently enabled features for a filesystem\n"
 "according to the version field of its primary superblock.\n"
@@ -874,6 +875,21 @@ version_f(
 			}
 
 			v5features.ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
+		} else if (!strcasecmp(argv[1], "bigtime")) {
+			if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+				dbprintf(
+		_("bigtime feature is already enabled\n"));
+				exitcode = 2;
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
index a776b375..a5ef9f84 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -123,6 +123,11 @@ This reduces mount time by caching the size of the inode btrees in the
 allocation group metadata.
 Once enabled, the filesystem will not be writable by older kernels.
 The filesystem cannot be downgraded after this feature is enabled.
+.TP
+.B bigtime
+Upgrade a V5 filesystem to support larger timestamps up to the year 2486.
+Once enabled, the filesystem will not be readable by older kernels.
+The filesystem cannot be downgraded.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 1b826e5d..cd2ace12 100644
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

