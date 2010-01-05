Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o05CL4ca204513 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 06:21:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8F834CA814
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2010 04:21:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	mSbtBfUsCePipXUG for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2010 04:21:53 -0800 (PST)
Date: Tue, 5 Jan 2010 23:21:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V3] sort: Introduce generic list_sort function
Message-ID: <20100105122101.GR13802@discord.disaster>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
	<87eim4dbzw.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87eim4dbzw.fsf@basil.nowhere.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Dave Airlie <airlied@redhat.com>, Adrian Hunter <adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jan 05, 2010 at 12:31:15PM +0100, Andi Kleen wrote:
> Dave Chinner <david@fromorbit.com> writes:
> > +
> > +/**
> > + * list_sort - sort a list.
> > + * @priv: private data, passed to @cmp
> > + * @head: the list to sort
> > + * @cmp: the elements comparison function
> > + *
> > + * This function has been implemented by Mark J Roberts <mjr@znex.org>=
. It
> > + * implements "merge sort" which has O(nlog(n)) complexity. The list i=
s sorted
> > + * in ascending order.
> > + *
> > + * The comparison function @cmp is supposed to return a negative value=
 if @a is
> > + * than @b, and a positive value if @a is greater than @b. If @a and @=
b are
> > + * equivalent, then it does not matter what this function returns.
> > + */
> > +void list_sort(void *priv, struct list_head *head,
> > +	       int (*cmp)(void *priv, struct list_head *a,
> > +			  struct list_head *b))
> =

> No EXPORT_SYMBOL? =


Bah, who uses modules? :P

Fixed. Updated patch below.

> Also it would seem cleaner to have it in a own file.

That might make sense if we had a large number of generic sort
functions and it was difficult to tell the code apart, but we've
only got 2 right now....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

sort: Introduce generic list_sort function

There are two copies of list_sort() in the tree already, one in the DRM cod=
e,
another in ubifs. Now XFS needs this as well. Create a generic list_sort()
function from the ubifs version and convert existing users to it so we
don't end up with yet another copy in the tree.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Acked-by: Dave Airlie <airlied@redhat.com>
Acked-by: Artem Bityutskiy <dedekind@infradead.org>
---
V3: Export list_sort()
V2: fix a typo

 drivers/gpu/drm/drm_modes.c |   90 ++-------------------------------------
 fs/ubifs/gc.c               |   95 ---------------------------------------=
--
 include/linux/sort.h        |    5 ++
 lib/sort.c                  |   98 +++++++++++++++++++++++++++++++++++++++=
++++
 4 files changed, 107 insertions(+), 181 deletions(-)

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
  * Copyright =A9 1997-2003 by The XFree86 Project, Inc.
  * Copyright =A9 2007 Dave Airlie
  * Copyright =A9 2007-2008 Intel Corporation
@@ -36,6 +31,7 @@
  */
 =

 #include <linux/list.h>
+#include <linux/sort.h>
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc.h"
@@ -829,6 +825,7 @@ EXPORT_SYMBOL(drm_mode_prune_invalid);
 =

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
+static int drm_mode_compare(void *priv, struct list_head *lh_a, struct lis=
t_head *lh_b)
 {
 	struct drm_display_mode *a =3D list_entry(lh_a, struct drm_display_mode, =
head);
 	struct drm_display_mode *b =3D list_entry(lh_b, struct drm_display_mode, =
head);
@@ -859,85 +856,6 @@ static int drm_mode_compare(struct list_head *lh_a, st=
ruct list_head *lh_b)
 	return diff;
 }
 =

-/* FIXME: what we don't have a list sort function? */
-/* list sort from Mark J Roberts (mjr@znex.org) */
-void list_sort(struct list_head *head,
-	       int (*cmp)(struct list_head *a, struct list_head *b))
-{
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
-
-	list =3D head->next;
-	list_del(head);
-	insize =3D 1;
-	for (;;) {
-		p =3D oldhead =3D list;
-		list =3D tail =3D NULL;
-		nmerges =3D 0;
-
-		while (p) {
-			nmerges++;
-			q =3D p;
-			psize =3D 0;
-			for (i =3D 0; i < insize; i++) {
-				psize++;
-				q =3D q->next =3D=3D oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize =3D insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				} else if (!qsize || !q) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else if (cmp(p, q) <=3D 0) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				}
-				if (tail)
-					tail->next =3D e;
-				else
-					list =3D e;
-				e->prev =3D tail;
-				tail =3D e;
-			}
-			p =3D q;
-		}
-
-		tail->next =3D list;
-		list->prev =3D tail;
-
-		if (nmerges <=3D 1)
-			break;
-
-		insize *=3D 2;
-	}
-
-	head->next =3D list;
-	head->prev =3D list->prev;
-	list->prev->next =3D head;
-	list->prev =3D head;
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
 =

diff --git a/fs/ubifs/gc.c b/fs/ubifs/gc.c
index 618c270..4976e07 100644
--- a/fs/ubifs/gc.c
+++ b/fs/ubifs/gc.c
@@ -108,101 +108,6 @@ static int switch_gc_head(struct ubifs_info *c)
 }
 =

 /**
- * list_sort - sort a list.
- * @priv: private data, passed to @cmp
- * @head: the list to sort
- * @cmp: the elements comparison function
- *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
- * implements "merge sort" which has O(nlog(n)) complexity. The list is so=
rted
- * in ascending order.
- *
- * The comparison function @cmp is supposed to return a negative value if =
@a is
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
-	list =3D head->next;
-	list_del(head);
-	insize =3D 1;
-	for (;;) {
-		p =3D oldhead =3D list;
-		list =3D tail =3D NULL;
-		nmerges =3D 0;
-
-		while (p) {
-			nmerges++;
-			q =3D p;
-			psize =3D 0;
-			for (i =3D 0; i < insize; i++) {
-				psize++;
-				q =3D q->next =3D=3D oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
-
-			qsize =3D insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				} else if (!qsize || !q) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else if (cmp(priv, p, q) <=3D 0) {
-					e =3D p;
-					p =3D p->next;
-					psize--;
-					if (p =3D=3D oldhead)
-						p =3D NULL;
-				} else {
-					e =3D q;
-					q =3D q->next;
-					qsize--;
-					if (q =3D=3D oldhead)
-						q =3D NULL;
-				}
-				if (tail)
-					tail->next =3D e;
-				else
-					list =3D e;
-				e->prev =3D tail;
-				tail =3D e;
-			}
-			p =3D q;
-		}
-
-		tail->next =3D list;
-		list->prev =3D tail;
-
-		if (nmerges <=3D 1)
-			break;
-
-		insize *=3D 2;
-	}
-
-	head->next =3D list;
-	head->prev =3D list->prev;
-	list->prev->next =3D head;
-	list->prev =3D head;
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
 =

 #include <linux/types.h>
 =

+struct list_head;
+
 void sort(void *base, size_t num, size_t size,
 	  int (*cmp)(const void *, const void *),
 	  void (*swap)(void *, void *, int));
 =

+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
 #endif
diff --git a/lib/sort.c b/lib/sort.c
index 926d004..a9ce544 100644
--- a/lib/sort.c
+++ b/lib/sort.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
+#include <linux/list.h>
 =

 static void u32_swap(void *a, void *b, int size)
 {
@@ -121,3 +122,100 @@ static int sort_test(void)
 =

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
+ * implements "merge sort" which has O(nlog(n)) complexity. The list is so=
rted
+ * in ascending order.
+ *
+ * The comparison function @cmp is supposed to return a negative value if =
@a is
+ * less than @b, and a positive value if @a is greater than @b. If @a and =
@b
+ * are equivalent, then it does not matter what this function returns.
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
+	list =3D head->next;
+	list_del(head);
+	insize =3D 1;
+	for (;;) {
+		p =3D oldhead =3D list;
+		list =3D tail =3D NULL;
+		nmerges =3D 0;
+
+		while (p) {
+			nmerges++;
+			q =3D p;
+			psize =3D 0;
+			for (i =3D 0; i < insize; i++) {
+				psize++;
+				q =3D q->next =3D=3D oldhead ? NULL : q->next;
+				if (!q)
+					break;
+			}
+
+			qsize =3D insize;
+			while (psize > 0 || (qsize > 0 && q)) {
+				if (!psize) {
+					e =3D q;
+					q =3D q->next;
+					qsize--;
+					if (q =3D=3D oldhead)
+						q =3D NULL;
+				} else if (!qsize || !q) {
+					e =3D p;
+					p =3D p->next;
+					psize--;
+					if (p =3D=3D oldhead)
+						p =3D NULL;
+				} else if (cmp(priv, p, q) <=3D 0) {
+					e =3D p;
+					p =3D p->next;
+					psize--;
+					if (p =3D=3D oldhead)
+						p =3D NULL;
+				} else {
+					e =3D q;
+					q =3D q->next;
+					qsize--;
+					if (q =3D=3D oldhead)
+						q =3D NULL;
+				}
+				if (tail)
+					tail->next =3D e;
+				else
+					list =3D e;
+				e->prev =3D tail;
+				tail =3D e;
+			}
+			p =3D q;
+		}
+
+		tail->next =3D list;
+		list->prev =3D tail;
+
+		if (nmerges <=3D 1)
+			break;
+
+		insize *=3D 2;
+	}
+
+	head->next =3D list;
+	head->prev =3D list->prev;
+	list->prev->next =3D head;
+	list->prev =3D head;
+}
+
+EXPORT_SYMBOL(list_sort);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
