Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C78C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbjEZBu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZBu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F065F19A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:50:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2D460B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C47C433D2;
        Fri, 26 May 2023 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065853;
        bh=5H/8WvOaADKzOns3FfWCMA7NIHimVxkNSYbfYfePZ+s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UzUaBObbyP+GGwXaTxmkBR+CNdaGpNL2NoBg8TBczp/xoca4zzjxRhR0tKXGpXitK
         zzOnW/N21q4U93+U3AtEeruFyFQmh+dA5fVLqxQqtBOqoxJeUCyBozHbu7ugjIyLqp
         z6DCsnE+d+QivUrg/YnBTFyK8o3yAzlextfcAs0fC2snJi69h5LYtMWKxv5q1iR/us
         dGHGceIxD1Dbgi9ttFZ0QlZvt66OQHA/bHTxNDuWC58z7k3EYJke7CMGhdMjQFjDgo
         YlZe3N5JoeXWdXTvzr0AxcmK+cFpPxOy+qhFZ3QTX3aJ0RON74MY2luQRHmn+JfOfc
         /tNN/2vzyHgxw==
Date:   Thu, 25 May 2023 18:50:53 -0700
Subject: [PATCH 1/7] libfrog: hoist free space histogram code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073481.3745433.8196427478440084323.stgit@frogsfrogsfrogs>
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

Combine the two free space histograms in xfs_db and xfs_spaceman into a
single implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/freesp.c         |   83 +++++--------------------------
 libfrog/Makefile    |    2 +
 libfrog/histogram.c |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/histogram.h |   50 +++++++++++++++++++
 spaceman/freesp.c   |   93 +++++++++--------------------------
 5 files changed, 225 insertions(+), 138 deletions(-)
 create mode 100644 libfrog/histogram.c
 create mode 100644 libfrog/histogram.h


diff --git a/db/freesp.c b/db/freesp.c
index 6f234666584..7e71bf47a16 100644
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
@@ -93,18 +83,13 @@ freesp_f(
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
-	if (histcount)
+	if (hist_buckets(&freesp_hist))
 		printhist();
-	if (summaryflag) {
-		dbprintf(_("total free extents %lld\n"), totexts);
-		dbprintf(_("total free blocks %lld\n"), totblocks);
-		dbprintf(_("average free extent size %g\n"),
-			(double)totblocks / (double)totexts);
-	}
+	if (summaryflag)
+		hist_summarize(&freesp_hist);
 	if (aglist)
 		xfree(aglist);
-	if (hist)
-		xfree(hist);
+	hist_free(&freesp_hist);
 	return 0;
 }
 
@@ -132,10 +117,9 @@ init(
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
@@ -163,7 +147,7 @@ init(
 			speced = 1;
 			break;
 		case 'h':
-			if (speced && !histcount)
+			if (speced && hist_buckets(&freesp_hist) == 0)
 				return usage();
 			addhistent(atoi(optarg));
 			speced = 1;
@@ -339,14 +323,7 @@ static void
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
@@ -355,30 +332,12 @@ addtohist(
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
@@ -387,6 +346,7 @@ histinit(
 {
 	int	i;
 
+	hist_init(&freesp_hist);
 	if (equalsize) {
 		for (i = 1; i < maxlen; i += equalsize)
 			addhistent(i);
@@ -396,27 +356,12 @@ histinit(
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
-
-	dbprintf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].count)
-			dbprintf("%7d %7d %7lld %7lld %6.2f\n", hist[i].low,
-				hist[i].high, hist[i].count, hist[i].blocks,
-				hist[i].blocks * 100.0 / totblocks);
-	}
+	hist_print(&freesp_hist);
 }
diff --git a/libfrog/Makefile b/libfrog/Makefile
index e14e62e4d1b..ad32b0674b2 100644
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
@@ -44,6 +45,7 @@ crc32table.h \
 dahashselftest.h \
 file_exchange.h \
 fsgeom.h \
+histogram.h \
 logging.h \
 paths.h \
 projects.h \
diff --git a/libfrog/histogram.c b/libfrog/histogram.c
new file mode 100644
index 00000000000..e854ac5e467
--- /dev/null
+++ b/libfrog/histogram.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
+ * Copyright (c) 2017-2023 Oracle.
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
+	struct histent		*buckets;
+
+	if (hs->nr_buckets == INT_MAX)
+		return EFBIG;
+
+	buckets = realloc(hs->buckets,
+			(hs->nr_buckets + 1) * sizeof(struct histent));
+	if (!buckets)
+		return errno;
+
+	hs->buckets = buckets;
+	hs->buckets[hs->nr_buckets].low = bucket_low;
+	hs->buckets[hs->nr_buckets].count = buckets[hs->nr_buckets].blocks = 0;
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
+	hs->totexts++;
+	hs->totblocks += len;
+	for (i = 0; i < hs->nr_buckets; i++) {
+		if (hs->buckets[i].high >= len) {
+			hs->buckets[i].count++;
+			hs->buckets[i].blocks += len;
+			break;
+		}
+	}
+}
+
+static int
+histent_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct histent	*ha = a;
+	const struct histent	*hb = b;
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
+	qsort(hs->buckets, hs->nr_buckets, sizeof(struct histent), histent_cmp);
+
+	for (i = 0; i < hs->nr_buckets; i++) {
+		if (i < hs->nr_buckets - 1)
+			hs->buckets[i].high = hs->buckets[i + 1].low - 1;
+		else
+			hs->buckets[i].high = maxlen;
+	}
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
+	const struct histogram	*hs)
+{
+	unsigned int		i;
+
+	printf("%7s %7s %7s %7s %6s\n",
+		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
+	for (i = 0; i < hs->nr_buckets; i++) {
+		if (hs->buckets[i].count == 0)
+			continue;
+
+		printf("%7lld %7lld %7lld %7lld %6.2f\n",
+				hs->buckets[i].low, hs->buckets[i].high,
+				hs->buckets[i].count, hs->buckets[i].blocks,
+				hs->buckets[i].blocks * 100.0 / hs->totblocks);
+	}
+}
+
+/* Summarize the contents of the histogram. */
+void
+hist_summarize(
+	const struct histogram	*hs)
+{
+	printf(_("total free extents %lld\n"), hs->totexts);
+	printf(_("total free blocks %lld\n"), hs->totblocks);
+	printf(_("average free extent size %g\n"),
+			(double)hs->totblocks / (double)hs->totexts);
+}
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
new file mode 100644
index 00000000000..c215bdaa98c
--- /dev/null
+++ b/libfrog/histogram.h
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2012 Red Hat, Inc.
+ * Copyright (c) 2017-2023 Oracle.
+ * All Rights Reserved.
+ */
+#ifndef __LIBFROG_HISTOGRAM_H__
+#define __LIBFROG_HISTOGRAM_H__
+
+struct histent
+{
+	/* Low and high size of this bucket */
+	long long	low;
+	long long	high;
+
+	/* Count of observations recorded */
+	long long	count;
+
+	/* Sum of blocks recorded */
+	long long	blocks;
+};
+
+struct histogram {
+	/* Sum of all blocks recorded */
+	long long	totblocks;
+
+	/* Count of all observations recorded */
+	long long	totexts;
+
+	struct histent	*buckets;
+
+	/* Number of buckets */
+	unsigned int	nr_buckets;
+};
+
+int hist_add_bucket(struct histogram *hs, long long bucket_low);
+void hist_add(struct histogram *hs, long long len);
+void hist_init(struct histogram *hs);
+void hist_prepare(struct histogram *hs, long long maxlen);
+void hist_free(struct histogram *hs);
+void hist_print(const struct histogram *hs);
+void hist_summarize(const struct histogram *hs);
+
+static inline unsigned int hist_buckets(const struct histogram *hs)
+{
+	return hs->nr_buckets;
+}
+
+#endif /* __LIBFROG_HISTOGRAM_H__ */
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 70dcdb5c923..996cbb7e2c0 100644
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
 	off64_t		len)
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
@@ -102,29 +79,14 @@ histinit(
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
-
-	printf("%7s %7s %7s %7s %6s\n",
-		_("from"), _("to"), _("extents"), _("blocks"), _("pct"));
-	for (i = 0; i < histcount; i++) {
-		if (hist[i].count)
-			printf("%7lld %7lld %7lld %7lld %6.2f\n", hist[i].low,
-				hist[i].high, hist[i].count, hist[i].blocks,
-				hist[i].blocks * 100.0 / totblocks);
-	}
+	hist_print(&freesp_hist);
 }
 
 static int
@@ -255,10 +217,8 @@ init(
 	int			speced = 0;	/* only one of -b -e -h or -m */
 
 	agcount = dumpflag = equalsize = multsize = optind = gflag = 0;
-	histcount = seen1 = summaryflag = 0;
-	totblocks = totexts = 0;
+	seen1 = summaryflag = 0;
 	aglist = NULL;
-	hist = NULL;
 	rtflag = false;
 
 	while ((c = getopt(argc, argv, "a:bde:gh:m:rs")) != EOF) {
@@ -287,7 +247,7 @@ init(
 			gflag++;
 			break;
 		case 'h':
-			if (speced && !histcount)
+			if (speced && hist_buckets(&freesp_hist) == 0)
 				goto many_spec;
 			/* addhistent increments histcount */
 			x = cvt_s64(optarg, 0);
@@ -345,18 +305,13 @@ freesp_f(
 		if (inaglist(agno))
 			scan_ag(agno);
 	}
-	if (histcount && !gflag)
+	if (hist_buckets(&freesp_hist) > 0 && !gflag)
 		printhist();
-	if (summaryflag) {
-		printf(_("total free extents %lld\n"), totexts);
-		printf(_("total free blocks %lld\n"), totblocks);
-		printf(_("average free extent size %g\n"),
-			(double)totblocks / (double)totexts);
-	}
+	if (summaryflag)
+		hist_summarize(&freesp_hist);
 	if (aglist)
 		free(aglist);
-	if (hist)
-		free(hist);
+	hist_free(&freesp_hist);
 	return 0;
 }
 

