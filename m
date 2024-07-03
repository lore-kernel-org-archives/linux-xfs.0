Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0901190694
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043309; cv=none; b=N2bGK0Aqec8cSNS1Q8+kUcMU2SSiwBs3L6LZQnhIeB5Q/MriFnTOSGeaU8CiPIrFMLKR3JcVfMHMYItaAdvAZo7xcACxC6+KSFzatSc1Qv7vULBdyfInh6o/GNR4qLVzZT6C7GOBjLY/P2umopja9x/2p3atV2nTivmioJe+S7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043309; c=relaxed/simple;
	bh=SBk22z2HqR7DerN7yX2z/B4o2E4EP0PyurJ3xHaNzkI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SdDIwueDV9Nim5cEtfJg2+uYqRWSwljEwN0U1qGKtAg/+cwe8A+geF7xkdHlHi4lc55X8OWJxCbnidpr8EmC5CPkAdaNCQibDwUF4T18pox4sPYKOVyaxQKU4mr3thU9gR+SxqWIDQGRpzHGNq/2aDSTmmJeinl/abrezxSkvPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKJEokv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKJEokv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFB6C4AF07;
	Wed,  3 Jul 2024 21:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043309;
	bh=SBk22z2HqR7DerN7yX2z/B4o2E4EP0PyurJ3xHaNzkI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pKJEokv4HgMBxpd5TgK1eeFo5mW8rn8Ik/rGBy3Vcb9QyIDtL+UlIrkFfTVE5eqqV
	 B59qDErab1fQgiGRiJaNpMiu8Kgzsha9I7vQDAEYO1qE25mD0y2+rFz6pPuIpE8sKo
	 x0hbxg3YyZQ5ZYi7qbNi2A5oAy3cIihNnozK/8Crxoq+tdktZKqii3auAyDLV6/0pv
	 UVTDW/wahTITBtlpVuJgLNr6B554aO8r5QbhVo9OceyGd2EcSdKzamnflo/D8pTj4s
	 MWz6N/zbJA8bMCMQlFaOwN2FhzvW1yE0I6huyB2kVTh1xWnz5X/P1vYOQcvlqHE+a0
	 e5r4uHgNeDSSg==
Date: Wed, 03 Jul 2024 14:48:28 -0700
Subject: [PATCH 6/7] xfs_scrub: collect free space histograms during phase 7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320091.3392477.7286407282890658866.stgit@frogsfrogsfrogs>
In-Reply-To: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/histogram.c |   38 ++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h |    3 +++
 scrub/phase7.c      |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 scrub/xfs_scrub.c   |    5 +++++
 scrub/xfs_scrub.h   |    4 ++++
 5 files changed, 95 insertions(+), 2 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 59d46363c1da..543c8a636462 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -230,3 +230,41 @@ hist_summarize(
 	printf("%s %g\n", hstr->averages,
 			(double)hs->tot_sum / (double)hs->tot_obs);
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
+	dest->tot_sum += src->tot_sum;
+	dest->tot_obs += src->tot_obs;
+
+	for (i = 0; i < dest->nr_buckets; i++) {
+		ASSERT(dest->buckets[i].low == src->buckets[i].low);
+		ASSERT(dest->buckets[i].high == src->buckets[i].high);
+
+		dest->buckets[i].nr_obs += src->buckets[i].nr_obs;
+		dest->buckets[i].sum += src->buckets[i].sum;
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
+	ASSERT(dest->tot_obs == 0);
+
+	memcpy(dest, src, sizeof(struct histogram));
+	hist_init(src);
+}
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
index 967698774b0c..654de86b96e6 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -69,4 +69,7 @@ static inline unsigned int hist_buckets(const struct histogram *hs)
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

