Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3126C132
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882266; cv=none; b=EA7dRQOPNmV/dG2h4jRIOyzM6R9WAro0BiZwfqMHg1WzVayYJpTEIqH7OKBzbVmpWzSBCDsoWRu+fCcL9Rws31En/J4Zq8qp9MLjY6IVjyMGQysmfXw/+uyGrLQhJmXhZb6BSL2FlRCefoQMFuyonmHQTI6IplJNIEnVHvydVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882266; c=relaxed/simple;
	bh=hjkG/USXRFx/5t0h03PoZbLvABYaepk/rLn196qHK6w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYDjuXWTKt8w7x533HXKtYpPSxU5QwOlJbcmiwWl20jfMCaGBfaX7ABRql1yBC8BzmClQgPL8fNwZgPoLzIirixS0vy2g8Mdj4s2lYJLjsuhFLJnyVQei1lJp8diLOP628l15dCXpb72ehWYTD4P8CO35p31rP8vHraR5WOh5j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GNX+azM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GNX+azM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79386C116B1;
	Tue,  2 Jul 2024 01:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882266;
	bh=hjkG/USXRFx/5t0h03PoZbLvABYaepk/rLn196qHK6w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GNX+azM/rwHyBa+qTO9aApL5qxAgNy/HTSnrVO07S/PvpT4Sx0TF1JVk+w61H/WHc
	 K8uMlBY+fmytcmhenTCVAM1CxNRUTmqmpzZLkiewAcOg+n9yDYBqj7qdsFzXEIlzxQ
	 kgYkbcmM51LZZlpQUczvqEJ7DOg8AlMcMpueN18lZVRzmi3cIWLGZVHgxCHpiU+omH
	 PsxEsUkxjpBRueMfM0jJT+JZ8Hbct5nccXPS5F3faYawdKEgshXI25UpFdm2bO8Nf2
	 L6oOb7iiXvWaQdO/jWZVJjBASpqUTUVknLOuyFghGKBquftOznjZ8yzejYHeLx9q5q
	 rvLGGGDoV+fxQ==
Date: Mon, 01 Jul 2024 18:04:26 -0700
Subject: [PATCH 6/7] xfs_scrub: collect free space histograms during phase 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118672.2007921.6461553875020192436.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs>
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

Collect a histogram of free space observed during phase 7.  We'll put
this information to use in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c |   38 ++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h |    3 +++
 scrub/phase7.c      |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 scrub/xfs_scrub.c   |    5 +++++
 scrub/xfs_scrub.h   |    4 ++++
 5 files changed, 95 insertions(+), 2 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index bed79e35b021..54e2bac0f731 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -212,3 +212,41 @@ hist_summarize(
 	printf(_("average free extent size %g\n"),
 			(double)hs->totblocks / (double)hs->totexts);
 }
+
+/* Copy the contents of src to dest. */
+void
+hist_import(
+	struct histogram	*dest,
+	const struct histogram	*src)
+{
+	unsigned int		i;
+
+	ASSERT(dest->nr_buckets == src->nr_buckets);
+
+	dest->totblocks += src->totblocks;
+	dest->totexts += src->totexts;
+
+	for (i = 0; i < dest->nr_buckets; i++) {
+		ASSERT(dest->buckets[i].low == src->buckets[i].low);
+		ASSERT(dest->buckets[i].high == src->buckets[i].high);
+
+		dest->buckets[i].count += src->buckets[i].count;
+		dest->buckets[i].blocks += src->buckets[i].blocks;
+	}
+}
+
+/*
+ * Move the contents of src to dest and reinitialize src.  dst must not
+ * contain any observations or buckets.
+ */
+void
+hist_move(
+	struct histogram	*dest,
+	struct histogram	*src)
+{
+	ASSERT(dest->nr_buckets == 0);
+	ASSERT(dest->totexts == 0);
+
+	memcpy(dest, src, sizeof(struct histogram));
+	hist_init(src);
+}
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
index 2e2b169a79b0..ec788344d4c2 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -47,4 +47,7 @@ static inline unsigned int hist_buckets(const struct histogram *hs)
 	return hs->nr_buckets;
 }
 
+void hist_import(struct histogram *dest, const struct histogram *src);
+void hist_move(struct histogram *dest, struct histogram *src);
+
 #endif /* __LIBFROG_HISTOGRAM_H__ */
diff --git a/scrub/phase7.c b/scrub/phase7.c
index cce5ede00122..475d8f157eec 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -12,6 +12,7 @@
 #include "libfrog/ptvar.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/scrub.h"
+#include "libfrog/histogram.h"
 #include "list.h"
 #include "xfs_scrub.h"
 #include "common.h"
@@ -27,8 +28,36 @@ struct summary_counts {
 	unsigned long long	rbytes;		/* rt dev bytes */
 	unsigned long long	next_phys;	/* next phys bytes we see? */
 	unsigned long long	agbytes;	/* freespace bytes */
+
+	/* Free space histogram, in fsb */
+	struct histogram	datadev_hist;
 };
 
+/*
+ * Initialize a free space histogram.  Unsharded realtime volumes can be up to
+ * 2^52 blocks long, so we allocate enough buckets to handle that.
+ */
+static inline void
+init_freesp_hist(
+	struct histogram	*hs)
+{
+	unsigned int		i;
+
+	hist_init(hs);
+	for (i = 0; i < 53; i++)
+		hist_add_bucket(hs, 1ULL << i);
+	hist_prepare(hs, 1ULL << 53);
+}
+
+static void
+summary_count_init(
+	void			*data)
+{
+	struct summary_counts	*counts = data;
+
+	init_freesp_hist(&counts->datadev_hist);
+}
+
 /* Record block usage. */
 static int
 count_block_summary(
@@ -48,8 +77,14 @@ count_block_summary(
 	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
 		return 0;
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
-	    fsmap->fmr_owner == XFS_FMR_OWN_FREE)
+	    fsmap->fmr_owner == XFS_FMR_OWN_FREE) {
+		uint64_t	blocks;
+
+		blocks = cvt_b_to_off_fsbt(&ctx->mnt, fsmap->fmr_length);
+		if (fsmap->fmr_device == ctx->fsinfo.fs_datadev)
+			hist_add(&counts->datadev_hist, blocks);
 		return 0;
+	}
 
 	len = fsmap->fmr_length;
 
@@ -87,6 +122,9 @@ add_summaries(
 	total->dbytes += item->dbytes;
 	total->rbytes += item->rbytes;
 	total->agbytes += item->agbytes;
+
+	hist_import(&total->datadev_hist, &item->datadev_hist);
+	hist_free(&item->datadev_hist);
 	return 0;
 }
 
@@ -118,6 +156,8 @@ phase7_func(
 	int			ip;
 	int			error;
 
+	summary_count_init(&totalcount);
+
 	/* Check and fix the summary metadata. */
 	scrub_item_init_fs(&sri);
 	scrub_item_schedule_group(&sri, XFROG_SCRUB_GROUP_SUMMARY);
@@ -136,7 +176,7 @@ phase7_func(
 	}
 
 	error = -ptvar_alloc(scrub_nproc(ctx), sizeof(struct summary_counts),
-			NULL, &ptvar);
+			summary_count_init, &ptvar);
 	if (error) {
 		str_liberror(ctx, error, _("setting up block counter"));
 		return error;
@@ -153,6 +193,9 @@ phase7_func(
 	}
 	ptvar_free(ptvar);
 
+	/* Preserve free space histograms for phase 8. */
+	hist_move(&ctx->datadev_hist, &totalcount.datadev_hist);
+
 	/* Scan the whole fs. */
 	error = scrub_count_all_inodes(ctx, &counted_inodes);
 	if (error) {
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index adf9d13e5090..2894f6148e10 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -18,6 +18,7 @@
 #include "descr.h"
 #include "unicrash.h"
 #include "progress.h"
+#include "libfrog/histogram.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -669,6 +670,8 @@ main(
 	int			ret = SCRUB_RET_SUCCESS;
 	int			error;
 
+	hist_init(&ctx.datadev_hist);
+
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
 	fflush(stdout);
 
@@ -883,6 +886,8 @@ main(
 out_unicrash:
 	unicrash_unload();
 
+	hist_free(&ctx.datadev_hist);
+
 	/*
 	 * If we're being run as a service, the return code must fit the LSB
 	 * init script action error guidelines, which is to say that we
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 6272a36879e7..1a28f0cc847e 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -7,6 +7,7 @@
 #define XFS_SCRUB_XFS_SCRUB_H_
 
 #include "libfrog/fsgeom.h"
+#include "libfrog/histogram.h"
 
 extern char *progname;
 
@@ -86,6 +87,9 @@ struct scrub_ctx {
 	unsigned long long	preens;
 	bool			scrub_setup_succeeded;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
+
+	/* Free space histograms, in fsb */
+	struct histogram	datadev_hist;
 };
 
 /* Phase helper functions */

