Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47362 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932328AbcJYXHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:07:49 -0400
Subject: [PATCH 38/39] xfs_repair: use thread pools to sort rmap data
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:07:43 -0700
Message-ID: <147743686365.11035.10049064734489474720.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Since each slab is a collection of independent mini-slabs, we can
fire up a bunch of threads to sort the mini-slabs in parallel.
This speeds up the sorting phase of the rmapbt rebuilding if we
have a large number of mini slabs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/slab.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/repair/slab.c b/repair/slab.c
index 97c13d3..8609270 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -201,6 +201,27 @@ slab_add(
 	return 0;
 }
 
+#include "threads.h"
+
+struct qsort_slab {
+	struct xfs_slab		*slab;
+	struct xfs_slab_hdr	*hdr;
+	int			(*compare_fn)(const void *, const void *);
+};
+
+static void
+qsort_slab_helper(
+	struct work_queue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	struct qsort_slab	*qs = arg;
+
+	qsort(slab_ptr(qs->slab, qs->hdr, 0), qs->hdr->sh_inuse,
+			qs->slab->s_item_sz, qs->compare_fn);
+	free(qs);
+}
+
 /*
  * Sort the items in the slab.  Do not run this method if there are any
  * cursors holding on to the slab.
@@ -210,14 +231,35 @@ qsort_slab(
 	struct xfs_slab		*slab,
 	int (*compare_fn)(const void *, const void *))
 {
+	struct work_queue	wq;
 	struct xfs_slab_hdr	*hdr;
+	struct qsort_slab	*qs;
+
+	/*
+	 * If we don't have that many slabs, we're probably better
+	 * off skipping all the thread overhead.
+	 */
+	if (slab->s_nr_slabs <= 4) {
+		hdr = slab->s_first;
+		while (hdr) {
+			qsort(slab_ptr(slab, hdr, 0), hdr->sh_inuse,
+					slab->s_item_sz, compare_fn);
+			hdr = hdr->sh_next;
+		}
+		return;
+	}
 
+	create_work_queue(&wq, NULL, libxfs_nproc());
 	hdr = slab->s_first;
 	while (hdr) {
-		qsort(slab_ptr(slab, hdr, 0), hdr->sh_inuse, slab->s_item_sz,
-		      compare_fn);
+		qs = malloc(sizeof(struct qsort_slab));
+		qs->slab = slab;
+		qs->hdr = hdr;
+		qs->compare_fn = compare_fn;
+		queue_work(&wq, qsort_slab_helper, 0, qs);
 		hdr = hdr->sh_next;
 	}
+	destroy_work_queue(&wq);
 }
 
 /*

