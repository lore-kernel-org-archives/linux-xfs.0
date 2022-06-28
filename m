Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43660C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiF1UuF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiF1UuE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87473120C
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5998E61851
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47B9C341C8;
        Tue, 28 Jun 2022 20:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449402;
        bh=CJ8+xMk/sZNxsz99TvOnN96dgGBWy/45p4CyIP8u3lI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oNupVtIq/X+ulOSeV+i0XqtsE5HG5v8sInqBHC1twg8sjcJXioo9QcCtvU9CrUqwc
         89Pw8WbBbl9U/i0HxL7Tf9PnhopGDRF75+6RnK9xAj0qNH4f8Eey/0gxOplAhRTlqH
         IBen/7CpwUVK+N/oiL0gvVngwUr+QNOSosyO4Hg+5PjuRXT2uBF+rhH5ermzOgyBWF
         WOdp8c0XgIY5DZvDTlrLN9YKo+2Vl2w/hjP4wOyZaiNo46MJ8GnaoRkmVo5gqDAPR5
         17sx7dMM1eBpaUiW9YunshUAxDF45Eke62dqnKVuMxzKedAMw3486eAwDTjNWxzISv
         A/HEy2PNLOipw==
Subject: [PATCH 2/2] xfs_repair: Add support for upgrading to large extent
 counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:02 -0700
Message-ID: <165644940234.1091400.1634326441233386426.stgit@magnolia>
In-Reply-To: <165644939119.1091400.7396096341976707391.stgit@magnolia>
References: <165644939119.1091400.7396096341976707391.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Chandan Babu R <chandan.babu@oracle.com>

This commit adds support to xfs_repair to allow upgrading an existing
filesystem to support per-inode large extent counters.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 man/man8/xfs_admin.8 |    7 +++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   24 ++++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 44 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index ad28e0f6..4794d677 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -149,6 +149,13 @@ Upgrade a filesystem to support larger timestamps up to the year 2486.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be mountable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B nrext64
+Upgrade a filesystem to support large per-inode extent counters. The maximum
+data fork extent count will be 2^48 - 1, while the maximum attribute fork
+extent count will be 2^32 - 1. The filesystem cannot be downgraded after this
+feature is enabled. Once enabled, the filesystem will not be mountable by
+older kernels.  This feature was added to Linux 5.19.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index f8d4f1e4..c4084985 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -51,6 +51,7 @@ int	lazy_count;		/* What to set if to if converting */
 bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
+bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 0f98bd2b..b65e4a2d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -92,6 +92,7 @@ extern int	lazy_count;		/* What to set if to if converting */
 extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
+extern bool	add_nrext64;
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index a0fd1e9c..51567b19 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -181,6 +181,28 @@ set_bigtime(
 	return true;
 }
 
+static bool
+set_nrext64(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*new_sb)
+{
+	if (!xfs_has_crc(mp)) {
+		printf(
+	_("Nrext64 only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_has_large_extent_counts(mp)) {
+		printf(_("Filesystem already supports nrext64.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding nrext64 to filesystem.\n"));
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	return true;
+}
+
 struct check_state {
 	struct xfs_sb		sb;
 	uint64_t		features;
@@ -384,6 +406,8 @@ upgrade_filesystem(
 		dirty |= set_inobtcount(mp, &new_sb);
 	if (add_bigtime)
 		dirty |= set_bigtime(mp, &new_sb);
+	if (add_nrext64)
+		dirty |= set_nrext64(mp, &new_sb);
 	if (!dirty)
 		return;
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index d08b0cec..c94671d8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -67,6 +67,7 @@ enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
 	CONVERT_BIGTIME,
+	CONVERT_NREXT64,
 	C_MAX_OPTS,
 };
 
@@ -74,6 +75,7 @@ static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
 	[CONVERT_BIGTIME]	= "bigtime",
+	[CONVERT_NREXT64]	= "nrext64",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -324,6 +326,15 @@ process_args(int argc, char **argv)
 		_("-c bigtime only supports upgrades\n"));
 					add_bigtime = true;
 					break;
+				case CONVERT_NREXT64:
+					if (!val)
+						do_abort(
+		_("-c nrext64 requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c nrext64 only supports upgrades\n"));
+					add_nrext64 = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

