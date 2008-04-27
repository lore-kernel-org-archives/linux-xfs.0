Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Apr 2008 19:24:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3R2OWOF024700
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 19:24:33 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A238F6073
	for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 19:25:12 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159]) by cuda.sgi.com with ESMTP id sRQH29DvM7od0FlS for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 19:25:12 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so3714749fga.8
        for <xfs@oss.sgi.com>; Sat, 26 Apr 2008 19:25:11 -0700 (PDT)
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] vfs: reduce stack usage in write_cache_pages()
Date: Sun, 27 Apr 2008 04:24:10 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KP+EIUHH3dxBdol"
Message-Id: <200804270424.10343.vda.linux@googlemail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

--Boundary-00=_KP+EIUHH3dxBdol
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al, David,

vfs function write_cache_pages() appears on the xfs
writeout path. It's *the* path which causes 4k stack
overflows on i386 with xfs.

This function uses ~100 bytes of stack on 32-bit i386.

This patch transforms it a little so that it uses
a bit less stack - minus 8 bytes to be precise.

This isn't much, but it helps not only xfs,
but all filesystems.

Only compile tested.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_KP+EIUHH3dxBdol
Content-Type: text/x-diff;
  charset="us-ascii";
  name="stk3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="stk3.diff"

diff -urpN linux-2.6-xfs1/mm/page-writeback.c linux-2.6-xfs1.stk3/mm/page-writeback.c
--- linux-2.6-xfs1/mm/page-writeback.c	2008-03-30 03:27:55.000000000 +0200
+++ linux-2.6-xfs1.stk3/mm/page-writeback.c	2008-04-27 04:14:39.000000000 +0200
@@ -798,17 +798,14 @@ int write_cache_pages(struct address_spa
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	int ret = 0;
 	int done = 0;
 	struct pagevec pvec;
-	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
-	int range_whole = 0;
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+	if (wbc->nonblocking && bdi_write_congested(mapping->backing_dev_info)) {
 		wbc->encountered_congestion = 1;
 		return 0;
 	}
@@ -820,20 +817,30 @@ int write_cache_pages(struct address_spa
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
-		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
 		scanned = 1;
 	}
+
+	/* Minimizing stack use:
+	 * "nr_pages" hopefully won't require a stack slot -
+	 * we reuse "scanned" to keep its value.
+	 */
+
 retry:
-	while (!done && (index <= end) &&
-	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
+	while (!done && (index <= end)) {
 		unsigned i;
+		int nr_pages;
 
-		scanned = 1;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					      PAGECACHE_TAG_DIRTY,
+					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (!nr_pages)
+			break;
+		scanned = nr_pages;
+		/* "scanned" counts down to 1, and later acts as nonzero flag */
+
+		i = (unsigned)-1;
+		while (1) { /* for i in [0..nr_pages-1] */
+			struct page *page = pvec.pages[++i];
 
 			/*
 			 * At this point we hold neither mapping->tree_lock nor
@@ -872,10 +879,13 @@ retry:
 			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
-			if (wbc->nonblocking && bdi_write_congested(bdi)) {
+			if (wbc->nonblocking && bdi_write_congested(mapping->backing_dev_info)) {
 				wbc->encountered_congestion = 1;
 				done = 1;
 			}
+			if (scanned == 1)
+				break;
+			scanned--;
 		}
 		pagevec_release(&pvec);
 		cond_resched();
@@ -889,7 +899,8 @@ retry:
 		index = 0;
 		goto retry;
 	}
-	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
+	if (wbc->range_cyclic || (wbc->range_start == 0 && wbc->range_end == LLONG_MAX /* whole range */
+	                         && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 	return ret;
 }

--Boundary-00=_KP+EIUHH3dxBdol--
