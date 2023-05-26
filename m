Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA73C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjEZBwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjEZBwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7A4E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C2A64C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46A0C433EF;
        Fri, 26 May 2023 01:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065931;
        bh=/Evkk1YJw1NkzcLGKVy6nVDT8c/7UfOLcn82fITsUxs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=A36vTiQnRN0uVL+/YOoW0z4gr66hHLFUu1k4r1jB2C8KA7CCFXPfcDfWRg13XNy0r
         uayYHauWcbAXfR8g8eI2iiWswiFqpaUfOdC8zUMEWjOHVlrEvfadxJVZzE9JiwiFh7
         vaMIiuE2GGzaHshtgUxbjRA+5i/b6IEwNQaRrWUkw73GizHtnFl+bu/+DfqL6WTu8T
         sHY2P5YXpozG1YhrlsQJvwjzYxapXuMhnqU5N/SAXUlqqV7zr7LLWQdCCVUWviWoGE
         zdjUrRbwNwRtu3cG61TZYgEhVb4YtbLQKEsCy7733C0zmVrJBg93OW46RhHBbzW3tL
         NLiCBwZ4fFlcA==
Date:   Thu, 25 May 2023 18:52:11 -0700
Subject: [PATCH 6/7] xfs_scrub: collect free space histograms during phase 7
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073547.3745433.10565461223123845594.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
References: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index ff780606011..1f6c490b66e 100644
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
index c215bdaa98c..0cda747bc98 100644
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
index ad9cba92bfd..77e9574f4f8 100644
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
index f07a1960e57..e59e478a674 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -18,6 +18,7 @@
 #include "descr.h"
 #include "unicrash.h"
 #include "progress.h"
+#include "libfrog/histogram.h"
 
 /*
  * XFS Online Metadata Scrub (and Repair)
@@ -629,6 +630,8 @@ main(
 	int			ret = SCRUB_RET_SUCCESS;
 	int			error;
 
+	hist_init(&ctx.datadev_hist);
+
 	fprintf(stdout, "EXPERIMENTAL xfs_scrub program in use! Use at your own risk!\n");
 	fflush(stdout);
 
@@ -839,6 +842,8 @@ main(
 		fclose(progress_fp);
 	unicrash_unload();
 
+	hist_free(&ctx.datadev_hist);
+
 	/*
 	 * If we're being run as a service, the return code must fit the LSB
 	 * init script action error guidelines, which is to say that we
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 4f1e7e02d87..b001a074a8f 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -7,6 +7,7 @@
 #define XFS_SCRUB_XFS_SCRUB_H_
 
 #include "libfrog/fsgeom.h"
+#include "libfrog/histogram.h"
 
 extern char *progname;
 
@@ -85,6 +86,9 @@ struct scrub_ctx {
 	unsigned long long	preens;
 	bool			scrub_setup_succeeded;
 	bool			preen_triggers[XFS_SCRUB_TYPE_NR];
+
+	/* Free space histograms, in fsb */
+	struct histogram	datadev_hist;
 };
 
 /* Phase helper functions */

