Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbfFXFxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 01:53:00 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/12] list.h: add a list_pop helper
Date: Mon, 24 Jun 2019 07:52:42 +0200
Message-Id: <20190624055253.31183-2-hch@lst.de>
In-Reply-To: <20190624055253.31183-1-hch@lst.de>
References: <20190624055253.31183-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

We have a very common pattern where we want to delete the first entry
from a list and return it as the properly typed container structure.

Add a list_pop helper to implement this behavior.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/list.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index e951228db4b2..e07a5f54cc9d 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -500,6 +500,28 @@ static inline void list_splice_tail_init(struct list_head *list,
 	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
 
+/**
+ * list_pop - delete the first entry from a list and return it
+ * @list:	the list to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_pop(list, type, member) 				\
+({								\
+	struct list_head *head__ = (list);			\
+	struct list_head *pos__ = READ_ONCE(head__->next);	\
+	type *entry__ = NULL;					\
+								\
+	if (pos__ != head__) {					\
+		entry__ = list_entry(pos__, type, member);	\
+		list_del(pos__);				\
+	}							\
+								\
+	entry__;						\
+})
+
 /**
  * list_next_entry - get the next element in list
  * @pos:	the type * to cursor
-- 
2.20.1
