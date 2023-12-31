Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBCCD512
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOHPSfvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3C5C433C8;
	Sun, 31 Dec 2023 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062500;
	bh=ZEpHer0TNuXDO9XH3Wyvi0fpZgxrprmgPhjXvMD29+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BOHPSfvhu/ec9hvK1c6bvnvTqRnyGM8K8dpBI9qUjz59GXeDoEtI+xpXIpCtyguoj
	 lUO9u682qFZvSWSjxTbwc91aGH4sEXfHUaePqWo2YcYmt4P5ULSuT45KGuxZwPedX0
	 s0FVRecMITf/1EQIrisVzdlgcSIggmXtms5R7/E/foxGy0iubKdQpeVnws6ALHLRAN
	 dYlJtwNsa1NCCpP9WK82SEZsbmQPI5yDw+RrN0RvQaQDACrAqbLeXXxmxQZL9BIMdu
	 Ai2lsW201fd9wSLjFDziRD53xmAKAWZC0bb5aIvbpPqvvMruviy1xn8TXuB9jne7lt
	 TkNfApUIAnHJQ==
Date: Sun, 31 Dec 2023 14:41:39 -0800
Subject: [PATCH 5/9] xfs_scrub: boost the repair priority of dependencies of
 damaged items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999513.1797790.8882968878143930752.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 libfrog/scrub.c       |    1 
 scrub/repair.c        |   99 ++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h         |   12 ++++++
 scrub/scrub_private.h |    8 ++++
 4 files changed, 117 insertions(+), 3 deletions(-)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 1df2965fe2d..baaa4b4d940 100644
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
index 6e09c592ed4..5f13f3c7a5f 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -22,6 +22,29 @@
 
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
+	[XFS_SCRUB_TYPE_PARENT]		= DEP(XFS_SCRUB_TYPE_DIR) |
+					  DEP(XFS_SCRUB_TYPE_XATTR),
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
@@ -34,8 +57,16 @@ xfs_repair_metadata(
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
@@ -55,7 +86,7 @@ xfs_repair_metadata(
 		break;
 	}
 
-	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
+	if (!is_corrupt(&meta) && repair_only)
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
@@ -223,6 +254,60 @@ struct action_item {
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
@@ -235,17 +320,21 @@ repair_item_mustfix(
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
@@ -479,6 +568,8 @@ repair_file_corruption(
 	struct scrub_item	*sri,
 	int			override_fd)
 {
+	repair_item_boost_priorities(sri);
+
 	return repair_item_class(ctx, sri, override_fd, SCRUB_ITEM_CORRUPT,
 			XRM_REPAIR_ONLY | XRM_NOPROGRESS);
 }
@@ -495,6 +586,8 @@ repair_item(
 {
 	int			ret;
 
+	repair_item_boost_priorities(sri);
+
 	ret = repair_item_class(ctx, sri, -1, SCRUB_ITEM_CORRUPT, flags);
 	if (ret)
 		return ret;
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 874e1fe1319..f22a952629e 100644
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
index 090efb54c0a..08b9130cbc9 100644
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

