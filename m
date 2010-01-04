Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04Nx2Kq157804 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 17:59:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AC5C13F0F9
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 15:59:52 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	zcRoNCg6hj7acNGN for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 15:59:52 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] sort: Introduce generic list_sort function
Date: Tue,  5 Jan 2010 10:54:55 +1100
Message-Id: <1262649295-28427-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8271689421944053400=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Artem Bityutskiy <dedekind@infradead.org>, Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>

--===============8271689421944053400==
Content-Type: text/plain

There are two copies of list_sort() in the tree already, one in the DRM code,
another in ubifs. Now XFS needs this as well. Create a generic list_sort()
function from the ubifs version and convert existing users to it so we
don't end up with yet another copy in the tree.

CC: Dave Airlie <airlied@redhat.com>
CC: Artem Bityutskiy <dedekind@infradead.org>
CC: Adrian Hunter <adrian.hunter@nokia.com>

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 drivers/gpu/drm/drm_modes.c |   90 ++--------------------------------------
 fs/ubifs/gc.c               |   95 ------------------------------------------
 include/linux/sort.h        |    5 ++
 lib/sort.c                  |   97 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+), 181 deletions(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 51f6772..3846ed4 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -1,9 +1,4 @@
 /*
- * The list_sort function is (presumably) licensed under the GPL (see the
- * top level "COPYING" file for details).
- *
- * The remainder of this file is:
- *
  * Copyright © 1997-2003 by The XFree86 Project, Inc.
  * Copyright © 2007 Dave Airlie
  * Copyright © 2007-2008 Intel Corporation
@@ -36,6 +31,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/sort.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -829,6 +825,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
 
 /**
  * drm_mode_compare - compare modes for favorability
+ * @priv: unused
  * @lh_a: list_head for first mode
  * @lh_b: list_head for second mode
  *
@@ -842,7 +839,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
  * Negative if @lh_a is better than @lh_b, zero if they're equivalent, or
  * positive if @lh_b is better than @lh_a.
  */
-static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
+static int drm_mode_compare(void *priv, struct list_head *lh_a, struct list_head *lh_b)
 {
 	struct drm_display_mode *a = list_entry(lh_a, struct drm_display_mode, head);
 	struct drm_display_mode *b = list_entry(lh_b, struct drm_display_mode, head);
@@ -859,85 +856,6 @@ static int drm_mode_compare(struct list_head *lh_a, struct list_head *lh_b)
 	return diff;
 }
 
-/* FIXME: what we don't have a list sort function? */
-/* list sort from Mark J Roberts (mjr@znex.org) */
-void list_sort(struct list_head *head,
-	       int (*cmp)(struct list_head *a, struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
-			}
-			p = q;
-		}
-
-		tail->next = list;
-		list->prev = tail;
-
-		if (nmerges <= 1)
-			break;
-
-		insize *= 2;
-	}
-
-	head->next = list;
-	head->prev = list->prev;
-	list->prev->next = head;
-	list->prev = head;
-}
-
 /**
  * drm_mode_sort - sort mode list
  * @mode_list: list to sort
@@ -949,7 +867,7 @@ void list_sort(struct list_head *head,
  */
 void drm_mode_sort(struct list_head *mode_list)
 {
-	list_sort(mode_list, drm_mode_compare);
+	list_sort(NULL, mode_list, drm_mode_compare);
 }
 EXPORT_SYMBOL(drm_mode_sort);
 
diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 618c270..4976e07 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -108,101 +108,6 @@ static int switch_gc_head(struct ubifs_info *c)
 }
 
 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
- * @head: the list to sort
- * @cmp: the elements comparison function
- *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
- * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
- * in ascending order.
- *
- * The comparison function @cmp is supposed to return a negative value if @a is
- * than @b, and a positive value if @a is greater than @b. If @a and @b are
- * equivalent, then it does not matter what this function returns.
- */
-static void list_sort(void *priv, struct list_head *head,
-		      int (*cmp)(void *priv, struct list_head *a,
-				 struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	if (list_empty(head))
-		return;
-
-	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(priv, p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
-			}
-			p = q;
-		}
-
-		tail->next = list;
-		list->prev = tail;
-
-		if (nmerges <= 1)
-			break;
-
-		insize *= 2;
-	}
-
-	head->next = list;
-	head->prev = list->prev;
-	list->prev->next = head;
-	list->prev = head;
-}
-
-/**
  * data_nodes_cmp - compare 2 data nodes.
  * @priv: UBIFS file-system description object
  * @a: first data node
diff --git a/include/linux/sort.h b/include/linux/sort.h
index d534da2..99a2ed5 100644
--- a/include/linux/sort.h
+++ b/include/linux/sort.h
@@ -3,8 +3,13 @@
 
 #include <linux/types.h>
 
+struct list_head;
+
 void sort(void *base, size_t num, size_t size,
 	  int (*cmp)(const void *, const void *),
 	  void (*swap)(void *, void *, int));
 
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index 926d004..1772c45 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 
 static void u32_swap(void *a, void *b, int size)
 {
@@ -121,3 +122,99 @@ static int sort_test(void)
 
 module_init(sort_test);
 #endif
+
+/**
+ * list_sort - sort a list.
+ * @priv: private data, passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
+ * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
+ * in ascending order.
+ *
+ * The comparison function @cmp is supposed to return a negative value if @a is
+ * than @b, and a positive value if @a is greater than @b. If @a and @b are
+ * equivalent, then it does not matter what this function returns.
+ */
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b))
+{
+	struct list_head *p, *q, *e, *list, *tail, *oldhead;
+	int insize, nmerges, psize, qsize, i;
+
+	if (list_empty(head))
+		return;
+
+	list = head->next;
+	list_del(head);
+	insize = 1;
+	for (;;) {
+		p = oldhead = list;
+		list = tail = NULL;
+		nmerges = 0;
+
+		while (p) {
+			nmerges++;
+			q = p;
+			psize = 0;
+			for (i = 0; i < insize; i++) {
+				psize++;
+				q = q->next == oldhead ? NULL : q->next;
+				if (!q)
+					break;
+			}
+
+			qsize = insize;
+			while (psize > 0 || (qsize > 0 && q)) {
+				if (!psize) {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				} else if (!qsize || !q) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else if (cmp(priv, p, q) <= 0) {
+					e = p;
+					p = p->next;
+					psize--;
+					if (p == oldhead)
+						p = NULL;
+				} else {
+					e = q;
+					q = q->next;
+					qsize--;
+					if (q == oldhead)
+						q = NULL;
+				}
+				if (tail)
+					tail->next = e;
+				else
+					list = e;
+				e->prev = tail;
+				tail = e;
+			}
+			p = q;
+		}
+
+		tail->next = list;
+		list->prev = tail;
+
+		if (nmerges <= 1)
+			break;
+
+		insize *= 2;
+	}
+
+	head->next = list;
+	head->prev = list->prev;
+	list->prev->next = head;
+	list->prev = head;
+}
+
-- 
1.6.5


--===============8271689421944053400==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8271689421944053400==--
