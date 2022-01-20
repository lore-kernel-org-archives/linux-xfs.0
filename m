Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B4D1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiATAWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:22:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47380 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345173AbiATAWi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:22:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC08B81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DDDC004E1;
        Thu, 20 Jan 2022 00:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638155;
        bh=R1Rx2+iQ6XrpOI8SOHT/JGhOlpGkf988lEro3txJs7s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oxPtp5LFOoSsP25rlCouRG4u7JDLDlrIP46a5qdaA4IgjnYl8XMUqST7V5wr4ti2E
         sfZwc8EYegPPxVlayqZjo0HIqJkk9gjSgNdzWR4tSoafsy3JHNZJi8yk+aE6FBClIZ
         9hgADg6/hpc9bra8vGdos9cx/24Iz7o+8rGKhEk9nvpjS7vzn2yBxXdEfLyXa1V2cN
         TO425lTd/UagLtC+HVmSRtQsZzJ240yHI5eQTcDLQzhD44Qlx8aia8QNsaJVYNHkkp
         iNJtBIF8blhsaok05Z+E1idcQ1Nrk9RXzdy3pO8B/73oeTXX48dmt4X94ZtRsyirxn
         Z/nxK4Xu/aVoA==
Subject: [PATCH 11/17] xfs_repair: update secondary superblocks after changing
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:22:35 -0800
Message-ID: <164263815537.863810.4471213125068205110.stgit@magnolia>
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we add features to an existing filesystem, make sure we update the
secondary superblocks to reflect the new geometry so that if we lose the
primary super in the future, repair will recover correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 ++
 repair/globals.c         |    1 +
 repair/globals.h         |    1 +
 repair/phase2.c          |    1 +
 repair/xfs_repair.c      |   15 +++++++++++++++
 5 files changed, 20 insertions(+)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a086fca2..0862d4b0 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -196,6 +196,8 @@
 #define xfs_trans_roll			libxfs_trans_roll
 #define xfs_trim_extent			libxfs_trim_extent
 
+#define xfs_update_secondary_sbs	libxfs_update_secondary_sbs
+
 #define xfs_validate_stripe_geometry	libxfs_validate_stripe_geometry
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agino		libxfs_verify_agino
diff --git a/repair/globals.c b/repair/globals.c
index 506a4e72..f8d4f1e4 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -48,6 +48,7 @@ char	*rt_name;		/* Name of realtime device */
 int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
+bool	features_changed;	/* did we change superblock feature bits? */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
 bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
diff --git a/repair/globals.h b/repair/globals.h
index 929b82be..0f98bd2b 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -89,6 +89,7 @@ extern char	*rt_name;		/* Name of realtime device */
 extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
+extern bool	features_changed;	/* did we change superblock feature bits? */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
 extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index cfba649a..13832701 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -218,6 +218,7 @@ upgrade_filesystem(
 				error);
 
 	libxfs_buf_relse(bp);
+	features_changed = true;
 }
 
 /*
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 4769c130..de8617ba 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1297,6 +1297,21 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_buf_mark_dirty(sbp);
 	libxfs_buf_relse(sbp);
 
+	/*
+	 * If we upgraded V5 filesystem features, we need to update the
+	 * secondary superblocks to include the new feature bits.  Don't set
+	 * NEEDSREPAIR on the secondaries.
+	 */
+	if (features_changed) {
+		mp->m_sb.sb_features_incompat &=
+				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		error = -libxfs_update_secondary_sbs(mp);
+		if (error)
+			do_error(_("upgrading features of secondary supers"));
+		mp->m_sb.sb_features_incompat |=
+				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+	}
+
 	/*
 	 * Done. Flush all cached buffers and inodes first to ensure all
 	 * verifiers are run (where we discover the max metadata LSN), reformat

