Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756699AbdLOWFb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:31 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 16/78] xarray: Add xa_get_entries, xa_get_tagged and xa_get_maybe_tag
Date: Fri, 15 Dec 2017 14:03:48 -0800
Message-Id: <20171215220450.7899-17-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

These functions allow a range of xarray entries to be extracted into a
compact normal array.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h | 27 ++++++++++++++++
 lib/xarray.c           | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 85a319463e46..1367d694eebd 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -140,6 +140,33 @@ void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
 
 void *xa_find(struct xarray *xa, unsigned long *index, unsigned long max);
 void *xa_find_after(struct xarray *xa, unsigned long *index, unsigned long max);
+int xa_get_entries(struct xarray *, void **dst, unsigned long start,
+			unsigned long max, unsigned int n);
+int xa_get_tagged(struct xarray *, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t);
+
+/**
+ * xa_get_maybe_tag() - Copy entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from.
+ * @n: The maximum number of entries to copy.
+ * @tag: Tag number.
+ *
+ * If you specify %XA_NO_TAG as the tag number, this is the same as
+ * xa_get_entries().  Otherwise, it is the same as xa_get_tagged().
+ *
+ * Return: The number of entries copied.
+ */
+static inline int xa_get_maybe_tag(struct xarray *xa, void **dst,
+			unsigned long start, unsigned long max,
+			unsigned int n, xa_tag_t tag)
+{
+	if (tag == XA_NO_TAG)
+		return xa_get_entries(xa, dst, start, max, n);
+	return xa_get_tagged(xa, dst, start, max, n, tag);
+}
 
 /**
  * xa_for_each() - Iterate over a portion of an XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 9ac1e9730c24..e73ae7b57fc9 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1330,6 +1330,94 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp, unsigned long max)
 }
 EXPORT_SYMBOL(xa_find_after);
 
+/**
+ * xa_get_entries() - Copy entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from.
+ * @n: The maximum number of entries to copy.
+ *
+ * Copies up to @n non-NULL entries from the XArray.  The copied entries will
+ * have indices between @start and @max, inclusive.
+ *
+ * This function uses the RCU lock to protect itself.  That means that the
+ * entries returned may not represent a snapshot of the XArray at a moment
+ * in time.  For example, if index 5 is stored to, then index 10 is stored to,
+ * calling xa_get_entries() may return the old contents of index 5 and the
+ * new contents of index 10.  Indices not modified while this function is
+ * running will not be skipped.
+ *
+ * If you need stronger guarantees, holding the xa_lock across calls to this
+ * function will prevent concurrent modification.
+ *
+ * Return: The number of entries copied.
+ */
+int xa_get_entries(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n)
+{
+	XA_STATE(xas, xa, start);
+	void *entry;
+	unsigned int i = 0;
+
+	if (!n)
+		return 0;
+
+	rcu_read_lock();
+	xas_for_each(&xas, entry, max) {
+		if (xas_retry(&xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+EXPORT_SYMBOL(xa_get_entries);
+
+/**
+ * xa_get_tagged() - Copy tagged entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy pointers into.
+ * @start: The first index in the XArray eligible to be copied from.
+ * @max: The last index in the XArray eligible to be copied from
+ * @n: The maximum number of entries to copy.
+ * @tag: Tag number.
+ *
+ * Copies up to @n non-NULL entries that have @tag set from the XArray.  The
+ * copied entries will have indices between @start and @max, inclusive.
+ *
+ * See the xa_get_entries() documentation for the consistency guarantees
+ * provided.
+ *
+ * Return: The number of entries copied.
+ */
+int xa_get_tagged(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t tag)
+{
+	XA_STATE(xas, xa, start);
+	void *entry;
+	unsigned int i = 0;
+
+	if (!n)
+		return 0;
+
+	rcu_read_lock();
+	xas_for_each_tag(&xas, entry, max, tag) {
+		if (xas_retry(&xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+EXPORT_SYMBOL(xa_get_tagged);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.15.1

