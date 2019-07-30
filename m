Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfG3BSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 21:18:04 -0400
Subject: [PATCH 1/6] list.h: add list_pop and list_pop_entry helpers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jul 2019 18:17:46 -0700
Message-ID: <156444946635.2682261.14776328020249327506.stgit@magnolia>
In-Reply-To: <156444945993.2682261.3926017251626679029.stgit@magnolia>
References: <156444945993.2682261.3926017251626679029.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, darrick.wong@oracle.com
Cc: Damien.LeMoal@wdc.com, agruenba@redhat.com, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

We have a very common pattern where we want to delete the first entry
from a list and return it as the properly typed container structure.

Add two helpers to implement this behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/linux/list.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)


diff --git a/include/linux/list.h b/include/linux/list.h
index 85c92555e31f..d3b00267446a 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -514,6 +514,39 @@ static inline void list_splice_tail_init(struct list_head *list,
 	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
 
+/**
+ * list_pop - delete the first entry from a list and return it
+ * @list:	the list to take the element from.
+ *
+ * Return the list entry after @list.  If @list is empty return NULL.
+ */
+static inline struct list_head *list_pop(struct list_head *list)
+{
+	struct list_head *pos = READ_ONCE(list->next);
+
+	if (pos == list)
+		return NULL;
+	list_del(pos);
+	return pos;
+}
+
+/**
+ * list_pop_entry - delete the first entry from a list and return the
+ *			containing structure
+ * @list:	the list to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Return the containing structure for the list entry after @list.  If @list
+ * is empty return NULL.
+ */
+#define list_pop_entry(list, type, member)			\
+({								\
+	struct list_head *pos__ = list_pop(list);		\
+								\
+	pos__ ? list_entry(pos__, type, member) : NULL;		\
+})
+
 /**
  * list_next_entry - get the next element in list
  * @pos:	the type * to cursor
