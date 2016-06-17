Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 816018053
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50D818F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IwGkGDww2qyAL5Mq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:39 -0700 (PDT)
Subject: [PATCH 008/145] libxfs: add more list operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:35 -0700
Message-ID: <146612709549.16048.6522744362673808871.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Add some list operations that the deferred rmap code requires.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/list.h |   76 ++++++++++++++++++++++++++++---
 libxfs/rdwr.c  |    2 -
 libxfs/util.c  |  137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+), 9 deletions(-)


diff --git a/include/list.h b/include/list.h
index f92faed..372cf06 100644
--- a/include/list.h
+++ b/include/list.h
@@ -111,30 +111,30 @@ static inline int list_empty(const struct list_head *head)
 }
 
 static inline void __list_splice(struct list_head *list,
-				 struct list_head *head)
+				 struct list_head *prev,
+				 struct list_head *next)
 {
 	struct list_head *first = list->next;
 	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
 
-	first->prev = head;
-	head->next = first;
+	first->prev = prev;
+	prev->next = first;
 
-	last->next = at;
-	at->prev = last;
+	last->next = next;
+	next->prev = last;
 }
 
 static inline void list_splice(struct list_head *list, struct list_head *head)
 {
 	if (!list_empty(list))
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
 }
 
 static inline void list_splice_init(struct list_head *list,
 				    struct list_head *head)
 {
 	if (!list_empty(list)) {
-		__list_splice(list, head);
+		__list_splice(list, head, head->next);
 		list_head_init(list);
 	}
 }
@@ -161,4 +161,64 @@ static inline void list_splice_init(struct list_head *list,
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.next, typeof(*n), member))
 
+#define list_first_entry(ptr, type, member) \
+	list_entry((ptr)->next, type, member)
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+void list_sort(void *priv, struct list_head *head,
+	       int (*cmp)(void *priv, struct list_head *a,
+			  struct list_head *b));
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+/**
+ * list_splice_tail_init - join two lists and reinitialise the emptied list
+ * @list: the new list to add.
+ * @head: the place to add it in the first list.
+ *
+ * Each of the lists is a queue.
+ * The list at @list is reinitialised
+ */
+static inline void list_splice_tail_init(struct list_head *list,
+					 struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice(list, head->prev, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
+/**
+ * list_last_entry - get the last element from a list
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note, that list is expected to be not empty.
+ */
+#define list_last_entry(ptr, type, member) \
+	list_entry((ptr)->prev, type, member)
+
+/**
+ * list_prev_entry - get the prev element in list
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_prev_entry(pos, member) \
+	list_entry((pos)->member.prev, typeof(*(pos)), member)
+
+/**
+ * list_for_each_entry_reverse - iterate backwards over list of given type.
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_reverse(pos, head, member)			\
+	for (pos = list_last_entry(head, typeof(*pos), member);		\
+	     &pos->member != (head); 					\
+	     pos = list_prev_entry(pos, member))
+
 #endif	/* __LIST_H__ */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0ec38c5..aa30522 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1260,7 +1260,7 @@ libxfs_bulkrelse(
 	}
 
 	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
-	__list_splice(list, &xfs_buf_freelist.cm_list);
+	list_splice(list, &xfs_buf_freelist.cm_list);
 	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
 
 	return count;
diff --git a/libxfs/util.c b/libxfs/util.c
index b992ad0..2e826c9 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -35,6 +35,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bit.h"
+#include "list.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock
@@ -781,3 +782,139 @@ libxfs_zero_extent(
 
 	return libxfs_device_zero(xfs_find_bdev_for_inode(ip), sector, size);
 }
+
+/* List sorting code from Linux. */
+#define MAX_LIST_LENGTH_BITS 20
+
+/*
+ * Returns a list organized in an intermediate format suited
+ * to chaining of merge() calls: null-terminated, no reserved or
+ * sentinel head node, "prev" links not maintained.
+ */
+static struct list_head *merge(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+/*
+ * Combine final list merge with restoration of standard doubly-linked
+ * list structure.  This approach duplicates code from merge(), but
+ * runs faster than the tidier alternatives of either a separate final
+ * prev-link restoration pass, or maintaining the prev links
+ * throughout.
+ */
+static void merge_and_restore_back_links(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *head,
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head *tail = head;
+	unsigned count = 0;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a->prev = tail;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b->prev = tail;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a ? : b;
+
+	do {
+		/*
+		 * In worst cases this loop may run many iterations.
+		 * Continue callbacks to the client even though no
+		 * element comparison is needed, so the client's cmp()
+		 * routine can invoke cond_resched() periodically.
+		 */
+		if (unlikely(!(++count)))
+			(*cmp)(priv, tail->next, tail->next);
+
+		tail->next->prev = tail;
+		tail = tail->next;
+	} while (tail->next);
+
+	tail->next = head;
+	head->prev = tail;
+}
+
+/**
+ * list_sort - sort a list
+ * @priv: private data, opaque to list_sort(), passed to @cmp
+ * @head: the list to sort
+ * @cmp: the elements comparison function
+ *
+ * This function implements "merge sort", which has O(nlog(n))
+ * complexity.
+ *
+ * The comparison function @cmp must return a negative value if @a
+ * should sort before @b, and a positive value if @a should sort after
+ * @b. If @a and @b are equivalent, and their original relative
+ * ordering is to be preserved, @cmp must return 0.
+ */
+void list_sort(void *priv, struct list_head *head,
+		int (*cmp)(void *priv, struct list_head *a,
+			struct list_head *b))
+{
+	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
+						-- last slot is a sentinel */
+	int lev;  /* index into part[] */
+	int max_lev = 0;
+	struct list_head *list;
+
+	if (list_empty(head))
+		return;
+
+	memset(part, 0, sizeof(part));
+
+	head->prev->next = NULL;
+	list = head->next;
+
+	while (list) {
+		struct list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
+				lev--;
+			}
+			max_lev = lev;
+		}
+		part[lev] = cur;
+	}
+
+	for (lev = 0; lev < max_lev; lev++)
+		if (part[lev])
+			list = merge(priv, cmp, part[lev], list);
+
+	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
