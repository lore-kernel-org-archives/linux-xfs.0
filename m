Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06ED07F4E
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 15:12:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C488830404E
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:36 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id kZJpRtpbdDDgEWIe for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 13:12:35 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC 07/11] mm: add find_get_entries_tag()
Date: Thu, 29 Oct 2015 14:12:11 -0600
Message-Id: <1446149535-16200-8-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1446149535-16200-1-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Jeff Layton <jlayton@poochiereds.net>, x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>

Add find_get_entries_tag() to the family of functions that include
find_get_entries(), find_get_pages() and find_get_pages_tag().  This is
needed for DAX dirty page handling because we need a list of both page
offsets and radix tree entries ('indices' and 'entries' in this function)
that are marked with the PAGECACHE_TAG_TOWRITE tag.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/pagemap.h |  3 +++
 mm/filemap.c            | 61 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a6c78e0..6fea3be 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -354,6 +354,9 @@ unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
 			       unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 			int tag, unsigned int nr_pages, struct page **pages);
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+			int tag, unsigned int nr_entries,
+			struct page **entries, pgoff_t *indices);
 
 struct page *grab_cache_page_write_begin(struct address_space *mapping,
 			pgoff_t index, unsigned flags);
diff --git a/mm/filemap.c b/mm/filemap.c
index c3a9e4f..992cf84 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1454,6 +1454,67 @@ repeat:
 }
 EXPORT_SYMBOL(find_get_pages_tag);
 
+/**
+ * find_get_entries_tag - find and return entries that match @tag
+ * @mapping:	the address_space to search
+ * @start:	the starting page cache index
+ * @tag:	the tag index
+ * @nr_entries:	the maximum number of entries
+ * @entries:	where the resulting entries are placed
+ * @indices:	the cache indices corresponding to the entries in @entries
+ *
+ * Like find_get_entries, except we only return entries which are tagged with
+ * @tag.
+ */
+unsigned find_get_entries_tag(struct address_space *mapping, pgoff_t start,
+			int tag, unsigned int nr_entries,
+			struct page **entries, pgoff_t *indices)
+{
+	void **slot;
+	unsigned int ret = 0;
+	struct radix_tree_iter iter;
+
+	if (!nr_entries)
+		return 0;
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_tagged(slot, &mapping->page_tree,
+				   &iter, start, tag) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			continue;
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page))
+				goto restart;
+			/*
+			 * A shadow entry of a recently evicted page, a swap
+			 * entry from shmem/tmpfs or a DAX entry.  Return it
+			 * without attempting to raise page count.
+			 */
+			goto export;
+		}
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		/* Has the page moved? */
+		if (unlikely(page != *slot)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+export:
+		indices[ret] = iter.index;
+		entries[ret] = page;
+		if (++ret == nr_entries)
+			break;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(find_get_entries_tag);
+
 /*
  * CD/DVDs are error prone. When a medium error occurs, the driver may fail
  * a _large_ part of the i/o request. Imagine the worst scenario:
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
