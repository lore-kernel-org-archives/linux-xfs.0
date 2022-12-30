Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F252C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiLaA2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiLaA2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:28:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621FE1E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0304EB81EAC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C31C433EF;
        Sat, 31 Dec 2022 00:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446513;
        bh=WYucsrfUj/a/i1rEGxY0w8reWZASbJ5VvVvHcldRpxE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OLzKIjlXSv69Zy1XDRYZVoEurBWenWm6b3Bzi2zbkiwJFNzipnVh5Q5SUh2SgoVHM
         wCzWZhRmh8Jctf3cCeCai+/GAc6AXs92Iys3SB3E5lankMDCuXdI65QXn+cpbsvPI/
         fYTPcy3s+NPdeQjWZ8fbAf0URwW4n4t27KlPoyp8TWKc+V4mavW82FxOtsCn2oKk0U
         VSDOAeKcQ9fZUf25PSjSCp7bdaCTVzamZATqZ96vMXZJyOF+RUiZLik0bToOpwfUaa
         bDPzdc4RFMxrOGYdQXfEtI7qrxmAqATQ8QaH0bAZtdlyISR4quHszh4PCtJhlfi0QW
         5Nbswx4QZWo8g==
Subject: [PATCH 5/9] xfs_scrub: boost the repair priority of dependencies of
 damaged items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869779.715746.14845159623486485344.stgit@magnolia>
In-Reply-To: <167243869711.715746.14725730988345960302.stgit@magnolia>
References: <167243869711.715746.14725730988345960302.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In XFS, certain types of metadata objects depend on the correctness of
lower level metadata objects.  For example, directory blocks are stored
in the data fork of directory files, which means that any issues with
the inode core and the data fork should be dealt with before we try to
repair a directory.

xfs_scrub prioritises repairs by the severity of what the kernel scrub
function reports -- anything directly observed to be corrupt get
repaired first, then anything that had trouble with cross referencing,
and finally anything that was correct but could be further optimised.
Returning to the above example, if a directory data fork mapping offset
is off by a bit flip, scrub will mark that as failing cross referencing,
but it'll mark the directory as corrupt.  Repair should check out the
mapping problem before it tackles the directory.

Do this by embedding a dependency table and using it to boost the
priority of the repair_item fields as needed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c       |    1 +
 scrub/repair.c        |   98 ++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h         |   12 ++++++
 scrub/scrub_private.h |    8 ++++
 4 files changed, 116 insertions(+), 3 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 7cd241d9bce..3e322b4717d 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -150,6 +150,7 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.group	= XFROG_SCRUB_GROUP_NONE,
 	},
 };
+#undef DEP
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
 int
diff --git a/scrub/repair.c b/scrub/repair.c
index cadd2c20627..16acb0a0f10 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -22,6 +22,28 @@
 
 /* General repair routines. */
 
+/*
+ * Bitmap showing the correctness dependencies between scrub types for repairs.
+ * There are no edges between AG btrees and AG headers because we can't mount
+ * the filesystem if the btree root pointers in the AG headers are wrong.
+ * Dependencies cannot cross scrub groups.
+ */
+#define DEP(x) (1U << (x))
+static const unsigned int repair_deps[XFS_SCRUB_TYPE_NR] = {
+	[XFS_SCRUB_TYPE_BMBTD]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_BMBTA]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_BMBTC]		= DEP(XFS_SCRUB_TYPE_INODE),
+	[XFS_SCRUB_TYPE_DIR]		= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_XATTR]		= DEP(XFS_SCRUB_TYPE_BMBTA),
+	[XFS_SCRUB_TYPE_SYMLINK]	= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_PARENT]		= DEP(XFS_SCRUB_TYPE_BMBTD),
+	[XFS_SCRUB_TYPE_QUOTACHECK]	= DEP(XFS_SCRUB_TYPE_UQUOTA) |
+					  DEP(XFS_SCRUB_TYPE_GQUOTA) |
+					  DEP(XFS_SCRUB_TYPE_PQUOTA),
+	[XFS_SCRUB_TYPE_RTSUM]		= DEP(XFS_SCRUB_TYPE_RTBITMAP),
+};
+#undef DEP
+
 /* Repair some metadata. */
 static enum check_outcome
 xfs_repair_metadata(
@@ -34,8 +56,16 @@ xfs_repair_metadata(
 	struct xfs_scrub_metadata	meta = { 0 };
 	struct xfs_scrub_metadata	oldm;
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
+	bool				repair_only;
 	int				error;
 
+	/*
+	 * If the caller boosted the priority of this scrub type on behalf of a
+	 * higher level repair by setting IFLAG_REPAIR, turn off REPAIR_ONLY.
+	 */
+	repair_only = (repair_flags & XRM_REPAIR_ONLY) &&
+			scrub_item_type_boosted(sri, scrub_type);
+
 	assert(scrub_type < XFS_SCRUB_TYPE_NR);
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	meta.sm_type = scrub_type;
@@ -55,7 +85,7 @@ xfs_repair_metadata(
 		break;
 	}
 
-	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
+	if (!is_corrupt(&meta) && repair_only)
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
@@ -215,6 +245,60 @@ struct action_item {
 	struct scrub_item	sri;
 };
 
+/*
+ * The operation of higher level metadata objects depends on the correctness of
+ * lower level metadata objects.  This means that if X depends on Y, we must
+ * investigate and correct all the observed issues with Y before we try to make
+ * a correction to X.  For all scheduled repair activity on X, boost the
+ * priority of repairs on all the Ys to ensure this correctness.
+ */
+static void
+repair_item_boost_priorities(
+	struct scrub_item		*sri)
+{
+	unsigned int			scrub_type;
+
+	foreach_scrub_type(scrub_type) {
+		unsigned int		dep_mask = repair_deps[scrub_type];
+		unsigned int		b;
+
+		if (repair_item_count_needsrepair(sri) == 0 || !dep_mask)
+			continue;
+
+		/*
+		 * Check if the repairs for this scrub type depend on any other
+		 * scrub types that have been flagged with cross-referencing
+		 * errors and are not already tagged for the highest priority
+		 * repair (SCRUB_ITEM_CORRUPT).  If so, boost the priority of
+		 * that scrub type (via SCRUB_ITEM_BOOST_REPAIR) so that any
+		 * problems with the dependencies will (hopefully) be fixed
+		 * before we start repairs on this scrub type.
+		 *
+		 * So far in the history of xfs_scrub we have maintained that
+		 * lower numbered scrub types do not depend on higher numbered
+		 * scrub types, so we need only process the bit mask once.
+		 */
+		for (b = 0; b < XFS_SCRUB_TYPE_NR; b++, dep_mask >>= 1) {
+			if (!dep_mask)
+				break;
+			if (!(dep_mask & 1))
+				continue;
+			if (!(sri->sri_state[b] & SCRUB_ITEM_REPAIR_XREF))
+				continue;
+			if (sri->sri_state[b] & SCRUB_ITEM_CORRUPT)
+				continue;
+			sri->sri_state[b] |= SCRUB_ITEM_BOOST_REPAIR;
+		}
+	}
+}
+
+/*
+ * These are the scrub item state bits that must be copied when scheduling
+ * a (per-AG) scrub type for immediate repairs.  The original state tracking
+ * bits are left untouched to force a rescan in phase 4.
+ */
+#define MUSTFIX_STATES	(SCRUB_ITEM_CORRUPT | \
+			 SCRUB_ITEM_BOOST_REPAIR)
 /*
  * Figure out which AG metadata must be fixed before we can move on
  * to the inode scan.
@@ -227,17 +311,21 @@ repair_item_mustfix(
 	unsigned int		scrub_type;
 
 	assert(sri->sri_agno != -1U);
+	repair_item_boost_priorities(sri);
 	scrub_item_init_ag(fix_now, sri->sri_agno);
 
 	foreach_scrub_type(scrub_type) {
-		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_CORRUPT))
+		unsigned int	state;
+
+		state = sri->sri_state[scrub_type] & MUSTFIX_STATES;
+		if (!state)
 			continue;
 
 		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
-			fix_now->sri_state[scrub_type] |= SCRUB_ITEM_CORRUPT;
+			fix_now->sri_state[scrub_type] = state;
 			break;
 		}
 	}
@@ -471,6 +559,8 @@ repair_file_corruption(
 	struct scrub_item	*sri,
 	int			override_fd)
 {
+	repair_item_boost_priorities(sri);
+
 	return repair_item_class(ctx, sri, override_fd, SCRUB_ITEM_CORRUPT,
 			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
 }
@@ -487,6 +577,8 @@ repair_item(
 {
 	int			ret;
 
+	repair_item_boost_priorities(sri);
+
 	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_CORRUPT, flags);
 	if (ret)
 		return ret;
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 6e34ca2d7b3..0d5738dc692 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -14,6 +14,14 @@ enum check_outcome {
 	CHECK_RETRY,	/* repair failed, try again later */
 };
 
+/*
+ * This flag boosts the repair priority of a scrub item when a dependent scrub
+ * item is scheduled for repair.  Use a separate flag to preserve the
+ * corruption state that we got from the kernel.  Priority boost is cleared the
+ * next time xfs_repair_metadata is called.
+ */
+#define SCRUB_ITEM_BOOST_REPAIR	(1 << 0)
+
 /*
  * These flags record the metadata object state that the kernel returned.
  * We want to remember if the object was corrupt, if the cross-referencing
@@ -31,6 +39,10 @@ enum check_outcome {
 				 SCRUB_ITEM_XFAIL | \
 				 SCRUB_ITEM_XCORRUPT)
 
+/* Cross-referencing failures only. */
+#define SCRUB_ITEM_REPAIR_XREF	(SCRUB_ITEM_XFAIL | \
+				 SCRUB_ITEM_XCORRUPT)
+
 struct scrub_item {
 	/*
 	 * Information we need to call the scrub and repair ioctls.  Per-AG
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index f91c65383d1..eafb750b0d1 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -71,4 +71,12 @@ scrub_item_clean_state(
 	sri->sri_state[scrub_type] = 0;
 }
 
+static inline bool
+scrub_item_type_boosted(
+	struct scrub_item		*sri,
+	unsigned  int			scrub_type)
+{
+	return sri->sri_state[scrub_type] & SCRUB_ITEM_BOOST_REPAIR;
+}
+
 #endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

