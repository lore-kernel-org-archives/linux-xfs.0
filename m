Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E81D187332
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043231; cv=none; b=dTVltuccm/8NiOeT0uEDkpfbxGa7XfqVH4VYUsNOcFFSX8kgsghDg54Cn+xM+x+HGe6TIDyZdP7u5too8JipEBHmu1coBH6BK4WlHdFEyplxtBk7HkGJhggsDCyP64kscBjbgAD/3fEVHFgBQdP4DZYIJQ9dkZiXKDQ8Pq1pB8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043231; c=relaxed/simple;
	bh=I5L0OeXFs/xWKn5yEdzANgLpgNGwyP+r620t6rxxHyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iB2Y3b6jouccG1zPsVllYl0bhlQ3W2OG2vHd8laDCBfbXA1n8rY5uoz8nvUtYQgfCksjLreJJ3JAG25z27UEYjY5C8G4Jw518xZvbIisyQfKF7n0Ll6Ys8NL0OUf0B6lxX9RhmVrbkH357CymOxPeqhIy1ET73qJtMckmQkf7uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBGm6lTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBGm6lTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DD2C2BD10;
	Wed,  3 Jul 2024 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043231;
	bh=I5L0OeXFs/xWKn5yEdzANgLpgNGwyP+r620t6rxxHyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kBGm6lTSywmc80vhhsTGQEUa+6Q3z7alS/sYzHKIs0HxoJXMz96+6tM2SthIO75tJ
	 NMC3c9+Dm61eMLE1Wb376O7wmN4tiO/ghk87IyigzxhHjZ7cP+LAe/h97puTghyBPh
	 EApFMfcfCBiD3wbRqZycom8rCkqRSMEWnjvoIuAbS4/0upgYiESTWyhv3gWx+oDbby
	 1FSZn6/d9QI2vOX6ihJjQm/2hbH0ZnIXol8NoKDA+NpyiwyP307A9LzJALQXtIan9K
	 mkLSLtnQYcY6BI9UxOBmVhGWf66bshouhgX3C/B2rUX5HFzde2743fwPARTwecFwhG
	 ltVKRQxLUCgYA==
Date: Wed, 03 Jul 2024 14:47:10 -0700
Subject: [PATCH 1/7] libfrog: hoist free space histogram code
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320027.3392477.14495882444654849509.stgit@frogsfrogsfrogs>
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

Combine the two free space histograms in xfs_db and xfs_spaceman into a
single implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/freesp.c         |   89 ++++++++------------------------
 libfrog/Makefile    |    2 +
 libfrog/histogram.c |  143 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h |   64 +++++++++++++++++++++++
 spaceman/freesp.c   |   99 ++++++++++++-----------------------
 5 files changed, 265 insertions(+), 132 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h


diff --git a/db/freesp.c b/db/freesp.c
index 883741e66fee..43520481d5e0 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -12,14 +12,7 @@
 #include "output.h"
 #include "init.h"
 #include "malloc.h"
-
-typedef struct histent
-{
-	int		low;
-	int		high;
-	long long	count;
-	long long	blocks;
-} histent_t;
+#include "libfrog/histogram.h"
 
 static void	addhistent(int h);
 static void	addtohist(xfs_agnumber_t agno, xfs_agblock_t agbno,
@@ -46,13 +39,10 @@ static int		alignment;
 static int		countflag;
 static int		dumpflag;
 static int		equalsize;
-static histent_t	*hist;
-static int		histcount;
+static struct histogram	freesp_hist;
 static int		multsize;
 static int		seen1;
 static int		summaryflag;
-static long long	totblocks;
-static long long	totexts;
 
 static const cmdinfo_t	freesp_cmd =
 	{ "freesp", NULL, freesp_f, 0, -1, 0,
@@ -93,18 +83,20 @@ freesp_f(
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
-	if (histcount)
+	if (hist_buckets(&freesp_hist))
 		printhist();
 	if (summaryflag) {
-		dbprintf(_("total free extents %lld\n"), totexts);
-		dbprintf(_("total free blocks %lld\n"), totblocks);
-		dbprintf(_("average free extent size %g\n"),
-			(double)totblocks / (double)totexts);
+		struct histogram_strings hstr = {
+			.sum		= _("total free blocks"),
+			.observations	= _("total free extents"),
+			.averages	= _("average free extent size"),
+		};
+
+		hist_summarize(&freesp_hist, &hstr);
 	}
 	if (aglist)
 		xfree(aglist);
-	if (hist)
-		xfree(hist);
+	hist_free(&freesp_hist);
 	return 0;
 }
 
@@ -132,10 +124,9 @@ init(
 	int		speced = 0;
 
 	agcount = countflag = dumpflag = equalsize = multsize = optind = 0;
-	histcount = seen1 = summaryflag = 0;
-	totblocks = totexts = 0;
+	seen1 = summaryflag = 0;
 	aglist = NULL;
-	hist = NULL;
+
 	while ((c = getopt(argc, argv, "A:a:bcde:h:m:s")) != EOF) {
 		switch (c) {
 		case 'A':
@@ -163,7 +154,7 @@ init(
 			speced = 1;
 			break;
 		case 'h':
-			if (speced && !histcount)
+			if (speced && hist_buckets(&freesp_hist) == 0)
 				return usage();
 			addhistent(atoi(optarg));
 			speced = 1;
@@ -339,14 +330,7 @@ static void
 addhistent(
 	int	h)
 {
-	hist = xrealloc(hist, (histcount + 1) * sizeof(*hist));
-	if (h == 0)
-		h = 1;
-	hist[histcount].low = h;
-	hist[histcount].count = hist[histcount].blocks = 0;
-	histcount++;
-	if (h == 1)
-		seen1 = 1;
+	hist_add_bucket(&freesp_hist, h);
 }
 
 static void
@@ -355,30 +339,12 @@ addtohist(
 	xfs_agblock_t	agbno,
 	xfs_extlen_t	len)
 {
-	int		i;
-
 	if (alignment && (XFS_AGB_TO_FSB(mp,agno,agbno) % alignment))
 		return;
 
 	if (dumpflag)
 		dbprintf("%8d %8d %8d\n", agno, agbno, len);
-	totexts++;
-	totblocks += len;
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].high >= len) {
-			hist[i].count++;
-			hist[i].blocks += len;
-			break;
-		}
-	}
-}
-
-static int
-hcmp(
-	const void	*a,
-	const void	*b)
-{
-	return ((histent_t *)a)->low - ((histent_t *)b)->low;
+	hist_add(&freesp_hist, len);
 }
 
 static void
@@ -387,6 +353,7 @@ histinit(
 {
 	int	i;
 
+	hist_init(&freesp_hist);
 	if (equalsize) {
 		for (i = 1; i < maxlen; i += equalsize)
 			addhistent(i);
@@ -396,27 +363,17 @@ histinit(
 	} else {
 		if (!seen1)
 			addhistent(1);
-		qsort(hist, histcount, sizeof(*hist), hcmp);
-	}
-	for (i = 0; i < histcount; i++) {
-		if (i < histcount - 1)
-			hist[i].high = hist[i + 1].low - 1;
-		else
-			hist[i].high = maxlen;
 	}
+	hist_prepare(&freesp_hist, maxlen);
 }
 
 static void
 printhist(void)
 {
-	int	i;
+	struct histogram_strings hstr = {
+		.sum		= _("blocks"),
+		.observations	= _("extents"),
+	};
 
-	dbprintf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].count)
-			dbprintf("%7d %7d %7lld %7lld %6.2f\n", hist[i].low,
-				hist[i].high, hist[i].count, hist[i].blocks,
-				hist[i].blocks * 100.0 / totblocks);
-	}
+	hist_print(&freesp_hist, &hstr);
 }
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 53e3c3492377..acfa228bc8ec 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -20,6 +20,7 @@ convert.c \
 crc32.c \
 file_exchange.c \
 fsgeom.c \
+histogram.c \
 list_sort.c \
 linux.c \
 logging.c \
@@ -45,6 +46,7 @@ dahashselftest.h \
 div64.h \
 file_exchange.h \
 fsgeom.h \
+histogram.h \
 logging.h \
 paths.h \
 projects.h \
diff --git a/libfrog/histogram.c b/libfrog/histogram.c
new file mode 100644
index 000000000000..c2f344a88eb6
--- /dev/null
+++ b/libfrog/histogram.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
+ * Copyright (c) 2017-2024 Oracle.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include <stdlib.h>
+#include <string.h>
+#include "platform_defs.h"
+#include "libfrog/histogram.h"
+
+/* Create a new bucket with the given low value. */
+int
+hist_add_bucket(
+	struct histogram	*hs,
+	long long		bucket_low)
+{
+	struct histbucket	*buckets;
+
+	if (hs->nr_buckets == INT_MAX)
+		return EFBIG;
+
+	buckets = realloc(hs->buckets,
+			(hs->nr_buckets + 1) * sizeof(struct histbucket));
+	if (!buckets)
+		return errno;
+
+	hs->buckets = buckets;
+	hs->buckets[hs->nr_buckets].low = bucket_low;
+	hs->buckets[hs->nr_buckets].nr_obs = 0;
+	hs->buckets[hs->nr_buckets].sum = 0;
+	hs->nr_buckets++;
+	return 0;
+}
+
+/* Add an observation to the histogram. */
+void
+hist_add(
+	struct histogram	*hs,
+	long long		len)
+{
+	unsigned int		i;
+
+	hs->tot_obs++;
+	hs->tot_sum += len;
+	for (i = 0; i < hs->nr_buckets; i++) {
+		if (hs->buckets[i].high >= len) {
+			hs->buckets[i].nr_obs++;
+			hs->buckets[i].sum += len;
+			break;
+		}
+	}
+}
+
+static int
+histbucket_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct histbucket	*ha = a;
+	const struct histbucket	*hb = b;
+
+	if (ha->low < hb->low)
+		return -1;
+	if (ha->low > hb->low)
+		return 1;
+	return 0;
+}
+
+/* Prepare a histogram for bucket configuration. */
+void
+hist_init(
+	struct histogram	*hs)
+{
+	memset(hs, 0, sizeof(struct histogram));
+}
+
+/* Prepare a histogram to receive data observations. */
+void
+hist_prepare(
+	struct histogram	*hs,
+	long long		maxlen)
+{
+	unsigned int		i;
+
+	qsort(hs->buckets, hs->nr_buckets, sizeof(struct histbucket),
+			histbucket_cmp);
+
+	for (i = 0; i < hs->nr_buckets - 1; i++)
+		hs->buckets[i].high = hs->buckets[i + 1].low - 1;
+	hs->buckets[hs->nr_buckets - 1].high = maxlen;
+}
+
+/* Free all data associated with a histogram. */
+void
+hist_free(
+	struct histogram	*hs)
+{
+	free(hs->buckets);
+	memset(hs, 0, sizeof(struct histogram));
+}
+
+/* Dump a histogram to stdout. */
+void
+hist_print(
+	const struct histogram		*hs,
+	const struct histogram_strings	*hstr)
+{
+	unsigned int			obs_w = strlen(hstr->observations);
+	unsigned int			sum_w = strlen(hstr->sum);
+	unsigned int			i;
+
+	printf("%7s %7s %*s %*s %6s\n",
+			_("from"), _("to"),
+			obs_w, hstr->observations,
+			sum_w, hstr->sum,
+			_("pct"));
+
+	for (i = 0; i < hs->nr_buckets; i++) {
+		if (hs->buckets[i].nr_obs == 0)
+			continue;
+
+		printf("%7lld %7lld %*lld %*lld %6.2f\n",
+				hs->buckets[i].low, hs->buckets[i].high,
+				obs_w, hs->buckets[i].nr_obs,
+				sum_w, hs->buckets[i].sum,
+				hs->buckets[i].sum * 100.0 / hs->tot_sum);
+	}
+}
+
+/* Summarize the contents of the histogram. */
+void
+hist_summarize(
+	const struct histogram		*hs,
+	const struct histogram_strings	*hstr)
+{
+	printf("%s %lld\n", hstr->observations, hs->tot_obs);
+	printf("%s %lld\n", hstr->sum, hs->tot_sum);
+	printf("%s %g\n", hstr->averages,
+			(double)hs->tot_sum / (double)hs->tot_obs);
+}
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
new file mode 100644
index 000000000000..d85f8edb8752
--- /dev/null
+++ b/libfrog/histogram.h
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
+ * Copyright (c) 2017-2024 Oracle.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_HISTOGRAM_H__
+#define __LIBFROG_HISTOGRAM_H__
+
+struct histbucket
+{
+	/* Low and high size of this bucket */
+	long long		low;
+	long long		high;
+
+	/* Count of observations recorded */
+	long long		nr_obs;
+
+	/* Sum of values recorded */
+	long long		sum;
+};
+
+struct histogram {
+	/* Sum of all values recorded */
+	long long		tot_sum;
+
+	/* Count of all observations recorded */
+	long long		tot_obs;
+
+	struct histbucket	*buckets;
+
+	/* Number of buckets */
+	unsigned int		nr_buckets;
+};
+
+int hist_add_bucket(struct histogram *hs, long long bucket_low);
+void hist_add(struct histogram *hs, long long value);
+void hist_init(struct histogram *hs);
+void hist_prepare(struct histogram *hs, long long maxvalue);
+void hist_free(struct histogram *hs);
+
+struct histogram_strings {
+	/* What does each sum represent? ("free blocks") */
+	const char		*sum;
+
+	/* What does each observation represent? ("free extents") */
+	const char		*observations;
+
+	/* What does sum / observation represent? ("average extent length") */
+	const char		*averages;
+};
+
+void hist_print(const struct histogram *hs,
+		const struct histogram_strings *hstr);
+void hist_summarize(const struct histogram *hs,
+		const struct histogram_strings *hstr);
+
+static inline unsigned int hist_buckets(const struct histogram *hs)
+{
+	return hs->nr_buckets;
+}
+
+#endif /* __LIBFROG_HISTOGRAM_H__ */
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index f5177cb4ee5d..dfbec52a7160 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -15,76 +15,52 @@
 #include "libfrog/paths.h"
 #include "space.h"
 #include "input.h"
-
-struct histent
-{
-	long long	low;
-	long long	high;
-	long long	count;
-	long long	blocks;
-};
+#include "libfrog/histogram.h"
 
 static int		agcount;
 static xfs_agnumber_t	*aglist;
-static struct histent	*hist;
+static struct histogram	freesp_hist;
 static int		dumpflag;
 static long long	equalsize;
 static long long	multsize;
-static int		histcount;
 static int		seen1;
 static int		summaryflag;
 static int		gflag;
 static bool		rtflag;
-static long long	totblocks;
-static long long	totexts;
 
 static cmdinfo_t freesp_cmd;
 
-static void
+static inline void
 addhistent(
 	long long	h)
 {
-	if (histcount == INT_MAX) {
+	int		error;
+
+	error = hist_add_bucket(&freesp_hist, h);
+	if (error == EFBIG) {
 		printf(_("Too many histogram buckets.\n"));
 		return;
 	}
-	hist = realloc(hist, (histcount + 1) * sizeof(*hist));
+	if (error) {
+		printf("%s\n", strerror(error));
+		return;
+	}
+
 	if (h == 0)
 		h = 1;
-	hist[histcount].low = h;
-	hist[histcount].count = hist[histcount].blocks = 0;
-	histcount++;
 	if (h == 1)
 		seen1 = 1;
 }
 
-static void
+static inline void
 addtohist(
 	xfs_agnumber_t	agno,
 	xfs_agblock_t	agbno,
 	off_t		len)
 {
-	long		i;
-
 	if (dumpflag)
 		printf("%8d %8d %8"PRId64"\n", agno, agbno, len);
-	totexts++;
-	totblocks += len;
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].high >= len) {
-			hist[i].count++;
-			hist[i].blocks += len;
-			break;
-		}
-	}
-}
-
-static int
-hcmp(
-	const void	*a,
-	const void	*b)
-{
-	return ((struct histent *)a)->low - ((struct histent *)b)->low;
+	hist_add(&freesp_hist, len);
 }
 
 static void
@@ -93,6 +69,7 @@ histinit(
 {
 	long long	i;
 
+	hist_init(&freesp_hist);
 	if (equalsize) {
 		for (i = 1; i < maxlen; i += equalsize)
 			addhistent(i);
@@ -102,29 +79,19 @@ histinit(
 	} else {
 		if (!seen1)
 			addhistent(1);
-		qsort(hist, histcount, sizeof(*hist), hcmp);
-	}
-	for (i = 0; i < histcount; i++) {
-		if (i < histcount - 1)
-			hist[i].high = hist[i + 1].low - 1;
-		else
-			hist[i].high = maxlen;
 	}
+	hist_prepare(&freesp_hist, maxlen);
 }
 
-static void
+static inline void
 printhist(void)
 {
-	int	i;
+	struct histogram_strings hstr = {
+		.sum		= _("blocks"),
+		.observations	= _("extents"),
+	};
 
-	printf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].count)
-			printf("%7lld %7lld %7lld %7lld %6.2f\n", hist[i].low,
-				hist[i].high, hist[i].count, hist[i].blocks,
-				hist[i].blocks * 100.0 / totblocks);
-	}
+	hist_print(&freesp_hist, &hstr);
 }
 
 static int
@@ -255,10 +222,8 @@ init(
 	int			speced = 0;	/* only one of -b -e -h or -m */
 
 	agcount = dumpflag = equalsize = multsize = optind = gflag = 0;
-	histcount = seen1 = summaryflag = 0;
-	totblocks = totexts = 0;
+	seen1 = summaryflag = 0;
 	aglist = NULL;
-	hist = NULL;
 	rtflag = false;
 
 	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
@@ -287,7 +252,7 @@ init(
 			gflag++;
 			break;
 		case 'h':
-			if (speced && !histcount)
+			if (speced && hist_buckets(&freesp_hist) == 0)
 				goto many_spec;
 			/* addhistent increments histcount */
 			x = cvt_s64(optarg, 0);
@@ -345,18 +310,20 @@ freesp_f(
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
-	if (histcount && !gflag)
+	if (hist_buckets(&freesp_hist) > 0 && !gflag)
 		printhist();
 	if (summaryflag) {
-		printf(_("total free extents %lld\n"), totexts);
-		printf(_("total free blocks %lld\n"), totblocks);
-		printf(_("average free extent size %g\n"),
-			(double)totblocks / (double)totexts);
+		struct histogram_strings hstr = {
+			.sum		= _("total free blocks"),
+			.observations	= _("total free extents"),
+			.averages	= _("average free extent size"),
+		};
+
+		hist_summarize(&freesp_hist, &hstr);
 	}
 	if (aglist)
 		free(aglist);
-	if (hist)
-		free(hist);
+	hist_free(&freesp_hist);
 	return 0;
 }
 

