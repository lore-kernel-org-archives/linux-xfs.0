Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4861386C2
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440723; cv=none; b=Tr4aK4qd1ORAyj8VwjGDB1QZay//9ldEb80t+/ERdCXvToJeoiOcwUzecOCZwnlXJcBoi4sGGGYVBSPDEQN3hGxyY4YefvSGG6YP87K0Bik2sRcEfy5XFw8gRsDH80S0BkqNt2WXqishG5Y4zViHrSJJ06hfuvTlrJI22KHVfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440723; c=relaxed/simple;
	bh=JVcBgYBeK7kQWbg0X1MZq0XDXyBoLIn9wgEiIqHhk+s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PnbewvzoDwILUcQ0Opha28Ydf+ORo/QZcpMOcrhtA6shcFyRMf6UQFAil+3HTVe3wUEddnxF6WXjIjBXIR127I/9GembR1bJ/Q/7IitQZvH7RAEW6aUXLf0dJ6E8Kq3uvqLvW0UNDRYYvmIuoPz0+6+aL+MG6cHWPbEP99LLBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/bLIsN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/bLIsN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D514C2BD10;
	Mon,  3 Jun 2024 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440723;
	bh=JVcBgYBeK7kQWbg0X1MZq0XDXyBoLIn9wgEiIqHhk+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I/bLIsN1uMrCFavav9PTw7+OS9nm3FZ40j0J0FW+qmM0LVlDAlTiqLViIL+YnClHb
	 6wfYpvXou+ZNOy+TK3g2/lGzYy8iMiKDZxpOVbvf4pRsSXpLV8hOU7QWz6lS84uxz9
	 DKb6P8Rx/arVPkBbNhFiaOPzuOx6gE9lcxuNi23mjzmrn5KpQqGPZFh2Y7ZUb0Yko2
	 8QHZiSexp0awxfdPxg5SRf0EeYXqmbosNNeoRIIz4ZkONP7aq6cDSqX1S98h2vb74+
	 dn7UonHpJ4QBZ4JKfi3pPeCUdK6/4muPm/bSSJL3WvDomUZE8J0Hg44e0lppW1+61s
	 ZpFTg23fshkIQ==
Date: Mon, 03 Jun 2024 11:52:03 -0700
Subject: [PATCH 3/3] libfrog: create a new scrub group for things requiring
 full inode scans
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744038833.1443816.9637216068767241485.stgit@frogsfrogsfrogs>
In-Reply-To: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
References: <171744038785.1443816.16653837642691924792.stgit@frogsfrogsfrogs>
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

Subsequent patches will add online fsck types (quotacheck, link counts)
that require us to walk every inode in the entire filesystem.  This
requires the AG metadata and the inodes to be in good enough shape to
complete the scan without hitting corruption errors.  As such, they
ought to run after phases 2-4 and before phase 7, which summarizes what
we've found.

Phase 5 seems like a reasonable place to do this, since it already walks
every xattr and directory entry in the filesystem to look for suspicious
looking names.  Add a new XFROG_SCRUB_GROUP, and add it to phase 5.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/scrub.c        |    1 +
 libfrog/scrub.h   |    1 +
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 6 files changed, 57 insertions(+), 2 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 70301c067..a77cd872f 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -184,6 +184,7 @@ parse_args(
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		if (!parse_none(argc, optind)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 68f1a9681..27230c62f 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -13,6 +13,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
 	XFROG_SCRUB_GROUP_FS,		/* per-FS metadata */
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
+	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 };
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 7e0eaca90..0a91e4f06 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -16,6 +16,8 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -23,8 +25,9 @@
 #include "scrub.h"
 #include "descr.h"
 #include "unicrash.h"
+#include "repair.h"
 
-/* Phase 5: Check directory connectivity. */
+/* Phase 5: Full inode scans and check directory connectivity. */
 
 /*
  * Warn about problematic bytes in a directory/attribute name.  That means
@@ -386,9 +389,24 @@ int
 phase5_func(
 	struct scrub_ctx	*ctx)
 {
+	struct action_list	alist;
 	bool			aborted = false;
 	int			ret;
 
+	/*
+	 * Check and fix anything that requires a full inode scan.  We do this
+	 * after we've checked all inodes and repaired anything that could get
+	 * in the way of a scan.
+	 */
+	action_list_init(&alist);
+	ret = scrub_iscan_metadata(ctx, &alist);
+	if (ret)
+		return ret;
+	ret = action_list_process(ctx, ctx->mnt.fd, &alist,
+			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (ret)
+		return ret;
+
 	if (ctx->corruptions_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
@@ -417,7 +435,7 @@ phase5_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*items = scrub_estimate_iscan_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1c53260cc..023cc2c2c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -47,6 +47,7 @@ format_scrub_descr(
 		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
@@ -421,6 +422,15 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
+/* Scrub all metadata requiring a full inode scan. */
+int
+scrub_iscan_metadata(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_ISCAN, 0, alist);
+}
+
 /* Scrub /only/ the superblock summary counters. */
 int
 scrub_fs_counters(
@@ -456,6 +466,29 @@ scrub_estimate_ag_work(
 	return estimate;
 }
 
+/*
+ * How many kernel calls will we make to scrub everything requiring a full
+ * inode scan?
+ */
+unsigned int
+scrub_estimate_iscan_work(
+	struct scrub_ctx		*ctx)
+{
+	const struct xfrog_scrub_descr	*sc;
+	int				type;
+	unsigned int			estimate;
+
+	estimate = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+
+	sc = xfrog_scrubbers;
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->group == XFROG_SCRUB_GROUP_ISCAN)
+			estimate++;
+	}
+
+	return estimate;
+}
+
 /*
  * Scrub file metadata of some sort.  If errors occur, this function will log
  * them and return nonzero.
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 8a999da6a..0033fe7ed 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -24,6 +24,7 @@ int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
+int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 7aea79d95..34d850d8d 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -99,6 +99,7 @@ int phase7_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_iscan_work(struct scrub_ctx *ctx);
 int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
 int phase3_estimate(struct scrub_ctx *ctx, uint64_t *items,

