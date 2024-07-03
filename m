Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE72194A6D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043325; cv=none; b=Dywi9DGzSxbY8M7ulrI5Qmp9opFDZZA+ESQuwB6cfmyhN4bkn9zphMPgv+LBwY5ch8VCsecNjiTkGgY41rVeLxQ8ECwi3k1OBNAFYdpfKyLxBuTxxnhsoj542D7mGK/72fBXlaf2V4fROaCyCpJTts0zN1HE0j+S664vYeLirS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043325; c=relaxed/simple;
	bh=Qw1vKNw0XQIWDw4eTgBSdbAabkHahEB+Pq/apg95aLc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eEmmnq9qZUIesnIpc2txWGTMcJWfIzznteAwgEzMTQPgoyKAs4E0T35bxjq1IViKclenVsqtwoq2ZdxHA2BSu20Hghy9bi1Fzza1+2KimqA8ppQETGW4ceFJunM0oIrJg8nKO4LQWzYmBMONKy+soAdihevf0GBgFC660lJTkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIgh04Ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIgh04Ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E187EC2BD10;
	Wed,  3 Jul 2024 21:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043325;
	bh=Qw1vKNw0XQIWDw4eTgBSdbAabkHahEB+Pq/apg95aLc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UIgh04Ye3NDLDxxLkTEaLkIFvjgDOQ6MELlJ41NTv6RefMhPu+ns6UuFYr8qcDObH
	 4/pK8k66gv77e2EtJQlF8yOrgDyUsv52lkS9z8SkrbkuInIFQzILtMvmew6unOu0Kq
	 bZJ5Zr+2jrJ/F0tSHPUBEyZXuVJbbHPEagdVcfX4EBXCcEZY566adg49vD1KsXiqNn
	 5hfPMD7+dWQK79D/876XszWkRv6R2XZNKFlDVHMCKU3GhrgLmLl3C0o3Yst2rXDSew
	 TnlWWmFqoGDMZjgq2uuWZHIuh39ZCVo6OY1VmvYqFlcQQdEmzGGIyGqWi07UVQmw95
	 3BBBgvNRBJWjA==
Date: Wed, 03 Jul 2024 14:48:44 -0700
Subject: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on free
 space histograms
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320104.3392477.8676191937750390114.stgit@frogsfrogsfrogs>
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

Currently, phase 8 runs very slowly on filesystems with a lot of small
free space extents.  To reduce the amount of time spent on fstrim
activities during phase 8, we want to balance estimated runtime against
completeness of the trim.  In short, the goal is to reduce runtime by
avoiding small trim requests.

At the start of phase 8, a CDF is computed in decreasing order of extent
length from the histogram buckets created during the fsmap scan in phase
7.  A point corresponding to the fstrim percentage target is chosen from
the CDF and mapped back to a histogram bucket, and free space extents
smaller than that amount are ommitted from fstrim.

On my aging /home filesystem, the free space histogram reported by
xfs_spaceman looks like this:

   from      to extents    blocks    pct blkcdf extcdf
      1       1  121953    121953   0.04 100.00 100.00
      2       3  124741    299694   0.09  99.96  81.16
      4       7  113492    593763   0.18  99.87  61.89
      8      15  109215   1179524   0.36  99.69  44.36
     16      31   76972   1695455   0.52  99.33  27.48
     32      63   48655   2219667   0.68  98.82  15.59
     64     127   31398   2876898   0.88  98.14   8.08
    128     255    8014   1447920   0.44  97.27   3.23
    256     511    4142   1501758   0.46  96.82   1.99
    512    1023    2433   1768732   0.54  96.37   1.35
   1024    2047    1795   2648460   0.81  95.83   0.97
   2048    4095    1429   4206103   1.28  95.02   0.69
   4096    8191    1045   6162111   1.88  93.74   0.47
   8192   16383     791   9242745   2.81  91.87   0.31
  16384   32767     473  10883977   3.31  89.06   0.19
  32768   65535     272  12385566   3.77  85.74   0.12
  65536  131071     192  18098739   5.51  81.98   0.07
 131072  262143     108  20675199   6.29  76.47   0.04
 262144  524287      80  29061285   8.84  70.18   0.03
 524288 1048575      39  29002829   8.83  61.33   0.02
1048576 2097151      25  36824985  11.21  52.51   0.01
2097152 4194303      32 101727192  30.95  41.30   0.01
4194304 8388607       7  34007410  10.35  10.35   0.00

From this table, we see that free space extents that are 16 blocks or
longer constitute 99.3% of the free space in the filesystem but only
27.5% of the extents.  If we set the fstrim minlen parameter to 16
blocks, that means that we can trim over 99% of the space in one third
of the time it would take to trim everything.

Add a new -o fstrim_pct= option to xfs_scrub just in case there are
users out there who want a different percentage.  For example, accepting
a 95% trim would net us a speed increase of nearly two orders of
magnitude, ignoring system call overhead.  Setting it to 100% will trim
everything, just like fstrim(8).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/histogram.c  |    4 +-
 libfrog/histogram.h  |    3 ++
 man/man8/xfs_scrub.8 |   16 +++++++++
 scrub/phase8.c       |   91 +++++++++++++++++++++++++++++++++++++++++++++++---
 scrub/vfs.c          |    4 ++
 scrub/vfs.h          |    2 +
 scrub/xfs_scrub.c    |   38 ++++++++++++++++++++-
 scrub/xfs_scrub.h    |   12 +++++++
 8 files changed, 160 insertions(+), 10 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 543c8a636462..f6a749e3cc81 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -109,7 +109,7 @@ hist_free(
  * in the long tail of small extents, e.g. 98% of the free space extents are
  * larger than 31 blocks.
  */
-static struct histogram_cdf *
+struct histogram_cdf *
 hist_cdf(
 	const struct histogram	*hs)
 {
@@ -151,7 +151,7 @@ hist_cdf(
 }
 
 /* Free all data associated with a histogram cdf. */
-static void
+void
 histcdf_free(
 	struct histogram_cdf	*cdf)
 {
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
index 654de86b96e6..e4395870182d 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -69,6 +69,9 @@ static inline unsigned int hist_buckets(const struct histogram *hs)
 	return hs->nr_buckets;
 }
 
+struct histogram_cdf *hist_cdf(const struct histogram *hs);
+void histcdf_free(struct histogram_cdf *cdf);
+
 void hist_import(struct histogram *dest, const struct histogram *src);
 void hist_move(struct histogram *dest, struct histogram *src);
 
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 404baba696e1..b9f253e1b079 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -100,6 +100,22 @@ The
 supported are:
 .RS 1.0i
 .TP
+.BI fstrim_pct= percentage
+To constrain the amount of time spent on fstrim activities during phase 8,
+this program tries to balance estimated runtime against completeness of the
+trim.
+In short, the program avoids small trim requests to save time.
+
+During phase 7, a log-scale histogram of free space extents is constructed.
+At the start of phase 8, a CDF is computed in decreasing order of extent
+length from the histogram buckets.
+A point corresponding to the fstrim percentage target is chosen from the CDF
+and mapped back to a histogram bucket.
+Free space extents at least as long as the bucket size are trimmed.
+Smaller extents are ignored.
+
+By default, the percentage threshold is 99%.
+.TP
 .BI iwarn
 Treat informational messages as warnings.
 This will result in a nonzero return code, and a higher logging level.
diff --git a/scrub/phase8.c b/scrub/phase8.c
index e35bf11bf329..1c88460c3396 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -11,6 +11,7 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/histogram.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -57,10 +58,12 @@ static int
 fstrim_fsblocks(
 	struct scrub_ctx	*ctx,
 	uint64_t		start_fsb,
-	uint64_t		fsbcount)
+	uint64_t		fsbcount,
+	uint64_t		minlen_fsb)
 {
 	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
+	uint64_t		minlen = cvt_off_fsb_to_b(&ctx->mnt, minlen_fsb);
 	int			error;
 
 	while (len > 0) {
@@ -68,7 +71,7 @@ fstrim_fsblocks(
 
 		run = min(len, FSTRIM_MAX_BYTES);
 
-		error = fstrim(ctx, start, run);
+		error = fstrim(ctx, start, run, minlen);
 		if (error == EOPNOTSUPP) {
 			/* Pretend we finished all the work. */
 			progress_add(len);
@@ -78,9 +81,10 @@ fstrim_fsblocks(
 			char		descr[DESCR_BUFSZ];
 
 			snprintf(descr, sizeof(descr) - 1,
-					_("fstrim start 0x%llx run 0x%llx"),
+					_("fstrim start 0x%llx run 0x%llx minlen 0x%llx"),
 					(unsigned long long)start,
-					(unsigned long long)run);
+					(unsigned long long)run,
+					(unsigned long long)minlen);
 			str_liberror(ctx, error, descr);
 			return error;
 		}
@@ -93,6 +97,80 @@ fstrim_fsblocks(
 	return 0;
 }
 
+/*
+ * Return the smallest minlen that still enables us to discard the specified
+ * number of free blocks.  Returns 0 if something goes wrong, which means no
+ * minlen threshold for discard.
+ */
+static uint64_t
+minlen_for_threshold(
+	const struct histogram	*hs,
+	uint64_t		blk_threshold)
+{
+	struct histogram_cdf	*cdf;
+	unsigned int		i;
+	uint64_t		ret = 0;
+
+	/* Insufficient samples to make a meaningful histogram */
+	if (hs->tot_obs < hs->nr_buckets * 10)
+		return 0;
+
+	cdf = hist_cdf(hs);
+	if (!cdf)
+		return 0;
+
+	for (i = 1; i < hs->nr_buckets; i++) {
+		if (cdf->buckets[i].sum < blk_threshold) {
+			ret = hs->buckets[i - 1].low;
+			break;
+		}
+	}
+
+	histcdf_free(cdf);
+	return ret;
+}
+
+/* Compute a suitable minlen parameter for fstrim. */
+static uint64_t
+fstrim_compute_minlen(
+	const struct scrub_ctx	*ctx,
+	const struct histogram	*freesp_hist)
+{
+	uint64_t		ret;
+	double			blk_threshold = 0;
+	unsigned int		ag_max_usable;
+
+	/*
+	 * The kernel will reject a minlen that's larger than m_ag_max_usable.
+	 * We can't calculate or query that value directly, so we guesstimate
+	 * that it's 95% of the AG size.
+	 */
+	ag_max_usable = ctx->mnt.fsgeom.agblocks * 95 / 100;
+
+	if (debug > 1) {
+		struct histogram_strings hstr = {
+			.sum		= _("free space blocks"),
+			.observations	= _("free space extents"),
+		};
+
+		hist_print(freesp_hist, &hstr);
+	}
+
+	ret = minlen_for_threshold(freesp_hist,
+			freesp_hist->tot_sum * ctx->fstrim_block_pct);
+
+	if (debug > 1)
+		printf(_("fstrim minlen %lld threshold %lld ag_max_usable %u\n"),
+				(unsigned long long)ret,
+				(unsigned long long)blk_threshold,
+				ag_max_usable);
+	if (ret > ag_max_usable)
+		ret = ag_max_usable;
+	if (ret == 1)
+		ret = 0;
+	return ret;
+}
+
 /* Trim each AG on the data device. */
 static int
 fstrim_datadev(
@@ -100,8 +178,11 @@ fstrim_datadev(
 {
 	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
 	uint64_t		fsbno;
+	uint64_t		minlen_fsb;
 	int			error;
 
+	minlen_fsb = fstrim_compute_minlen(ctx, &ctx->datadev_hist);
+
 	for (fsbno = 0; fsbno < geo->datablocks; fsbno += geo->agblocks) {
 		uint64_t	fsbcount;
 
@@ -112,7 +193,7 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno, fsbcount);
+		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb);
 		if (error)
 			return error;
 	}
diff --git a/scrub/vfs.c b/scrub/vfs.c
index cc958ba9438e..22c19485a2da 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -300,11 +300,13 @@ int
 fstrim(
 	struct scrub_ctx	*ctx,
 	uint64_t		start,
-	uint64_t		len)
+	uint64_t		len,
+	uint64_t		minlen)
 {
 	struct fstrim_range	range = {
 		.start		= start,
 		.len		= len,
+		.minlen		= minlen,
 	};
 
 	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
diff --git a/scrub/vfs.h b/scrub/vfs.h
index 1af8d80d1de6..f0cfd53c27be 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len, uint64_t minlen);
 
 #endif /* XFS_SCRUB_VFS_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 2894f6148e10..296d814eceeb 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -622,11 +622,13 @@ report_outcome(
  */
 enum o_opt_nums {
 	IWARN = 0,
+	FSTRIM_PCT,
 	O_MAX_OPTS,
 };
 
 static char *o_opts[] = {
 	[IWARN]			= "iwarn",
+	[FSTRIM_PCT]		= "fstrim_pct",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -635,8 +637,11 @@ parse_o_opts(
 	struct scrub_ctx	*ctx,
 	char			*p)
 {
+	double			dval;
+
 	while (*p != '\0')  {
 		char		*val;
+		char		*endp;
 
 		switch (getsubopt(&p, o_opts, &val))  {
 		case IWARN:
@@ -647,6 +652,35 @@ parse_o_opts(
 			}
 			info_is_warning = true;
 			break;
+		case FSTRIM_PCT:
+			if (!val) {
+				fprintf(stderr,
+ _("-o fstrim_pct requires a parameter\n"));
+				usage();
+			}
+
+			errno = 0;
+			dval = strtod(val, &endp);
+
+			if (*endp) {
+				fprintf(stderr,
+ _("-o fstrim_pct must be a floating point number\n"));
+				usage();
+			}
+			if (errno) {
+				fprintf(stderr,
+ _("-o fstrim_pct: %s\n"),
+						strerror(errno));
+				usage();
+			}
+			if (dval <= 0 || dval > 100) {
+				fprintf(stderr,
+ _("-o fstrim_pct must be larger than 0 and less than 100\n"));
+				usage();
+			}
+
+			ctx->fstrim_block_pct = dval / 100.0;
+			break;
 		default:
 			usage();
 			break;
@@ -659,7 +693,9 @@ main(
 	int			argc,
 	char			**argv)
 {
-	struct scrub_ctx	ctx = {0};
+	struct scrub_ctx	ctx = {
+		.fstrim_block_pct = FSTRIM_BLOCK_PCT_DEFAULT,
+	};
 	struct phase_rusage	all_pi;
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 1a28f0cc847e..7d48f4bad9ce 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -90,8 +90,20 @@ struct scrub_ctx {
 
 	/* Free space histograms, in fsb */
 	struct histogram	datadev_hist;
+
+	/*
+	 * Pick the largest value for fstrim minlen such that we trim at least
+	 * this much space per volume.
+	 */
+	double			fstrim_block_pct;
 };
 
+/*
+ * Trim only enough free space extents (in order of decreasing length) to
+ * ensure that this percentage of the free space is trimmed.
+ */
+#define FSTRIM_BLOCK_PCT_DEFAULT	(99.0 / 100.0)
+
 /* Phase helper functions */
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
 int scrub_cleanup(struct scrub_ctx *ctx);

