Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B775CC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 04:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70FE723138
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 04:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbhATEbE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 23:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbhATEas (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D4823131;
        Wed, 20 Jan 2021 04:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611117006;
        bh=4a0svEf+xUr1p3dhcWpLruZFTzJPRPdPn7NUE9z351w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FzATBwcewnyJZDCYG2LF8pcejXdRotYPvwjrCiZlYR3nBLQ0y/03WSdrB1bfBnq/S
         HRGmNfFK95UTL/IlQGABkcV9JJTgO4Bl5HAi3lneUf4ab1nEhI6uoSr2s/z/TzKNyw
         XKcjiRv2eoqvOFXHmFQYyHshz91RjB1ZKF1sG0QeZ8/CInNHYI6WvB4P+hKN9tk7ZK
         5IylKyS8an/BHPT23t17xqFKXO8uQ2vvtuHoQiEm0JGTZS9o9w+YokHXj/XmgsySxJ
         JZNKHV8X3izZM/woRNOMdPd7eLAjI8eCNN0ia2ERcnOlUEVitwO+fQMpaN+nf4tYB9
         rufGM43UYWNBA==
Date:   Tue, 19 Jan 2021 20:30:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5.1/10] xfs: create mount option to override metadata threads
Message-ID: <20210120043005.GW3134581@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100800882.90204.6003697594198832699.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100800882.90204.6003697594198832699.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a mount option so that sysadmins can override the estimated
parallelism of the filesystem, which in turn controls the number of
active work items in background threads.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_pwork.c |    5 +++++
 fs/xfs/xfs_super.c |   22 ++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..884a49972789 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -209,6 +209,9 @@ typedef struct xfs_mount {
 	struct mutex		m_growlock;	/* growfs mutex */
 
 #ifdef DEBUG
+	/* Desired parallelism of threaded tasks and background workers. */
+	unsigned int		m_metadata_threads;
+
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
 	 * value stored in here is the inverse of the frequency with which the
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index 53606397ff54..e89fb47bdfd6 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -162,6 +162,11 @@ xfs_pwork_guess_metadata_threads(
 {
 	unsigned int		threads;
 
+#ifdef DEBUG
+	if (mp->m_metadata_threads > 0)
+		return mp->m_metadata_threads;
+#endif
+
 	/*
 	 * Estimate the amount of parallelism for metadata operations from the
 	 * least capable of the two devices that handle metadata.  Cap that
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d17fbdb2a656..2f8c512fca10 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -93,6 +93,9 @@ enum {
 	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
 	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
 	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum,
+#ifdef DEBUG
+	Opt_metadata_threads,
+#endif
 };
 
 static const struct fs_parameter_spec xfs_fs_parameters[] = {
@@ -137,6 +140,9 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
 	fsparam_flag("nodiscard",	Opt_nodiscard),
 	fsparam_flag("dax",		Opt_dax),
 	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
+#ifdef DEBUG
+	fsparam_u32("metadata_threads",	Opt_metadata_threads),
+#endif
 	{}
 };
 
@@ -222,6 +228,11 @@ xfs_fs_show_options(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
 
+#ifdef DEBUG
+	if (mp->m_metadata_threads > 0)
+		seq_printf(m, ",metadata_threads=%u", mp->m_metadata_threads);
+#endif
+
 	return 0;
 }
 
@@ -1291,6 +1302,12 @@ xfs_fs_parse_param(
 	case Opt_dax_enum:
 		xfs_mount_set_dax_mode(mp, result.uint_32);
 		return 0;
+#endif
+#ifdef DEBUG
+	case Opt_metadata_threads:
+		xfs_warn(mp, "%s set to %u", param->key, result.uint_32);
+		mp->m_metadata_threads = result.uint_32;
+		return 0;
 #endif
 	/* Following mount options will be removed in September 2025 */
 	case Opt_ikeep:
@@ -1831,6 +1848,11 @@ xfs_fs_reconfigure(
 			return error;
 	}
 
+#ifdef DEBUG
+	mp->m_metadata_threads = new_mp->m_metadata_threads;
+	xfs_configure_background_workqueues(mp);
+#endif
+
 	return 0;
 }
 
