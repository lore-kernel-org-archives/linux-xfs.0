Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfGVJuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 05:50:32 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/12] list.h: add list_pop and list_pop_entry helpers
Date: Mon, 22 Jul 2019 11:50:13 +0200
Message-Id: <20190722095024.19075-2-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

We have a very common pattern where we want to delete the first entry
from a list and return it as the properly typed container structure.

Add two helpers to implement this behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/list.h | 33 +++++++++++++++++++++++++++++++++
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
-- 
2.20.1
