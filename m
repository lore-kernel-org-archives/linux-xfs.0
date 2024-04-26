Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD0F37707
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168556; cv=none; b=BAu4xPv/GhgLv2Q9VO2ytA+v6rdnXbx/qvL99CseFB/lgzFnukgq1IpyYcyU0IinGtqh3tNPjN9oOf56F+lzC/T5kRXj8Zz3HQ9UlZS9eKO9DvxegiSgu/iDqhxaZeTTJrbTS3HeonxZjEUxdNb73VgPItVPX43L0GJvg0H+DL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168556; c=relaxed/simple;
	bh=LSuztRn2Mh5e54GmtyO1Njz2lcIATbt/aEwr/6iyBO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RViKY9UKsyZ+hc4oAZJ4FyWCPaLJJ+17TdaeVep2Fw6PP+4b3KhXRUTJMnSD8D/GndpbDKeyHSSS5Ql0eolpcAN++ZdQ4K7OWk29Usbglz8yqznOUzG6nLNsqJCAUlKWLwZn+S4tXytchwKXz2JhP/Ek+4ZLR3ARh/Bsivsepqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ky27Jj06; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ky27Jj06"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e5c7d087e1so24210265ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168554; x=1714773354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIX8Dc9Jk7ZUW90SF+BIyxKwrUycFVc4zJBTZhEK4OI=;
        b=ky27Jj06aIlGIBVu5bbYPi9DsRbyTVQwJYoyPqj8WfRGuz37SOIJLzOeF85nLbQ059
         xw8OpCqEyQ0VFDSGbH8fzIAkZhBkjijZ/xJ4rgj5qe2HsbkQN2yONFD0aTaqzGgnZ5lQ
         RXx+jlKOo1jrg7qE3C7/UNXoHRfMBg4DlXDWEzcTQC6s7EE/d8Uz9RlKaehDbTfIfcIw
         wph4fWScCS5nEiFdOgovEsqGjxK2VwqUfJ6bvGmm9sKbF2CaD5yTbxnYvBoDBe/0VMPE
         K5EKUEp7YKNqLuYvMjlnopJrsjJ2NxWLXUTY3nlCTKx4iS24sSxTlSh+yXGwHm2CSzCd
         Vv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168554; x=1714773354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIX8Dc9Jk7ZUW90SF+BIyxKwrUycFVc4zJBTZhEK4OI=;
        b=jj7i3XOWoHIKrfxEd9DR4qGJt7d+JC7HLywpNtB2W3XPXgHbVQKrfxuiC5JEgZFHSK
         z4+CS9LI9kPL0VFTYKNGVmBQIOpENnaycSY159xF9I/0vDhdsnCSKVh9Zu8391pSexhh
         XjY87qT3xIhuEho2FZQ9zKpgw4PtKgKgF9PXakgNma8zOcytG8SwTYOlG2+osmE1IMB4
         6bFJiiLljyIYVk6l0zA22lk/a0ftcAB9/0ySoln42Ux64Qa7M+FfQMX8ba5NqN51eJuw
         QMnlJEZiFSjhVWEJTD1WkILmUjDxVwIJfDYDS7VEYq+/ctfPhF5+Dr/qNtJzgg8wJJxV
         bngg==
X-Gm-Message-State: AOJu0Yy6Y/5ujJ9Yq9bOtRk7uPlEKSVWi94DGF6hzeiuBm5jLVSXXOxJ
	VXAjrYvML0RVPtP/9bzE43cfXPoTWefJTfpXHACKYtb/lts6kr11NOEw0ZwX
X-Google-Smtp-Source: AGHT+IHoxbmGri2fC3Mg5p+VqmPNDZhXeaGFSV9goLMVcoyjSgfAwL6j4sDtpEYpgnbQ+Uk2oHCIXQ==
X-Received: by 2002:a17:902:ec8a:b0:1e4:203d:ab80 with SMTP id x10-20020a170902ec8a00b001e4203dab80mr4681972plg.57.1714168554038;
        Fri, 26 Apr 2024 14:55:54 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:53 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 05/24] iomap: buffered write failure should not truncate the page cache
Date: Fri, 26 Apr 2024 14:54:52 -0700
Message-ID: <20240426215512.2673806-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f43dc4dc3eff028b5ddddd99f3a66c5a6bdd4e78 ]

iomap_file_buffered_write_punch_delalloc() currently invalidates the
page cache over the unused range of the delalloc extent that was
allocated. While the write allocated the delalloc extent, it does
not own it exclusively as the write does not hold any locks that
prevent either writeback or mmap page faults from changing the state
of either the page cache or the extent state backing this range.

Whilst xfs_bmap_punch_delalloc_range() already handles races in
extent conversion - it will only punch out delalloc extents and it
ignores any other type of extent - the page cache truncate does not
discriminate between data written by this write or some other task.
As a result, truncating the page cache can result in data corruption
if the write races with mmap modifications to the file over the same
range.

generic/346 exercises this workload, and if we randomly fail writes
(as will happen when iomap gets stale iomap detection later in the
patchset), it will randomly corrupt the file data because it removes
data written by mmap() in the same page as the write() that failed.

Hence we do not want to punch out the page cache over the range of
the extent we failed to write to - what we actually need to do is
detect the ranges that have dirty data in cache over them and *not
punch them out*.

To do this, we have to walk the page cache over the range of the
delalloc extent we want to remove. This is made complex by the fact
we have to handle partially up-to-date folios correctly and this can
happen even when the FSB size == PAGE_SIZE because we now support
multi-page folios in the page cache.

Because we are only interested in discovering the edges of data
ranges in the page cache (i.e. hole-data boundaries) we can make use
of mapping_seek_hole_data() to find those transitions in the page
cache. As we hold the invalidate_lock, we know that the boundaries
are not going to change while we walk the range. This interface is
also byte-based and is sub-page block aware, so we can find the data
ranges in the cache based on byte offsets rather than page, folio or
fs block sized chunks. This greatly simplifies the logic of finding
dirty cached ranges in the page cache.

Once we've identified a range that contains cached data, we can then
iterate the range folio by folio. This allows us to determine if the
data is dirty and hence perform the correct delalloc extent punching
operations. The seek interface we use to iterate data ranges will
give us sub-folio start/end granularity, so we may end up looking up
the same folio multiple times as the seek interface iterates across
each discontiguous data region in the folio.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/iomap/buffered-io.c | 195 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 180 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 24be3297822b..60bd16f1a23f 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -827,6 +827,165 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+/*
+ * Scan the data range passed to us for dirty page cache folios. If we find a
+ * dirty folio, punch out the preceeding range and update the offset from which
+ * the next punch will start from.
+ *
+ * We can punch out storage reservations under clean pages because they either
+ * contain data that has been written back - in which case the delalloc punch
+ * over that range is a no-op - or they have been read faults in which case they
+ * contain zeroes and we can remove the delalloc backing range and any new
+ * writes to those pages will do the normal hole filling operation...
+ *
+ * This makes the logic simple: we only need to keep the delalloc extents only
+ * over the dirty ranges of the page cache.
+ *
+ * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
+ * simplify range iterations.
+ */
+static int iomap_write_delalloc_scan(struct inode *inode,
+		loff_t *punch_start_byte, loff_t start_byte, loff_t end_byte,
+		int (*punch)(struct inode *inode, loff_t offset, loff_t length))
+{
+	while (start_byte < end_byte) {
+		struct folio	*folio;
+
+		/* grab locked page */
+		folio = filemap_lock_folio(inode->i_mapping,
+				start_byte >> PAGE_SHIFT);
+		if (!folio) {
+			start_byte = ALIGN_DOWN(start_byte, PAGE_SIZE) +
+					PAGE_SIZE;
+			continue;
+		}
+
+		/* if dirty, punch up to offset */
+		if (folio_test_dirty(folio)) {
+			if (start_byte > *punch_start_byte) {
+				int	error;
+
+				error = punch(inode, *punch_start_byte,
+						start_byte - *punch_start_byte);
+				if (error) {
+					folio_unlock(folio);
+					folio_put(folio);
+					return error;
+				}
+			}
+
+			/*
+			 * Make sure the next punch start is correctly bound to
+			 * the end of this data range, not the end of the folio.
+			 */
+			*punch_start_byte = min_t(loff_t, end_byte,
+					folio_next_index(folio) << PAGE_SHIFT);
+		}
+
+		/* move offset to start of next folio in range */
+		start_byte = folio_next_index(folio) << PAGE_SHIFT;
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+	return 0;
+}
+
+/*
+ * Punch out all the delalloc blocks in the range given except for those that
+ * have dirty data still pending in the page cache - those are going to be
+ * written and so must still retain the delalloc backing for writeback.
+ *
+ * As we are scanning the page cache for data, we don't need to reimplement the
+ * wheel - mapping_seek_hole_data() does exactly what we need to identify the
+ * start and end of data ranges correctly even for sub-folio block sizes. This
+ * byte range based iteration is especially convenient because it means we
+ * don't have to care about variable size folios, nor where the start or end of
+ * the data range lies within a folio, if they lie within the same folio or even
+ * if there are multiple discontiguous data ranges within the folio.
+ *
+ * It should be noted that mapping_seek_hole_data() is not aware of EOF, and so
+ * can return data ranges that exist in the cache beyond EOF. e.g. a page fault
+ * spanning EOF will initialise the post-EOF data to zeroes and mark it up to
+ * date. A write page fault can then mark it dirty. If we then fail a write()
+ * beyond EOF into that up to date cached range, we allocate a delalloc block
+ * beyond EOF and then have to punch it out. Because the range is up to date,
+ * mapping_seek_hole_data() will return it, and we will skip the punch because
+ * the folio is dirty. THis is incorrect - we always need to punch out delalloc
+ * beyond EOF in this case as writeback will never write back and covert that
+ * delalloc block beyond EOF. Hence we limit the cached data scan range to EOF,
+ * resulting in always punching out the range from the EOF to the end of the
+ * range the iomap spans.
+ *
+ * Intervals are of the form [start_byte, end_byte) (i.e. open ended) because it
+ * matches the intervals returned by mapping_seek_hole_data(). i.e. SEEK_DATA
+ * returns the start of a data range (start_byte), and SEEK_HOLE(start_byte)
+ * returns the end of the data range (data_end). Using closed intervals would
+ * require sprinkling this code with magic "+ 1" and "- 1" arithmetic and expose
+ * the code to subtle off-by-one bugs....
+ */
+static int iomap_write_delalloc_release(struct inode *inode,
+		loff_t start_byte, loff_t end_byte,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length))
+{
+	loff_t punch_start_byte = start_byte;
+	loff_t scan_end_byte = min(i_size_read(inode), end_byte);
+	int error = 0;
+
+	/*
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite whilst we walk the
+	 * cache and perform delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	while (start_byte < scan_end_byte) {
+		loff_t		data_end;
+
+		start_byte = mapping_seek_hole_data(inode->i_mapping,
+				start_byte, scan_end_byte, SEEK_DATA);
+		/*
+		 * If there is no more data to scan, all that is left is to
+		 * punch out the remaining range.
+		 */
+		if (start_byte == -ENXIO || start_byte == scan_end_byte)
+			break;
+		if (start_byte < 0) {
+			error = start_byte;
+			goto out_unlock;
+		}
+		WARN_ON_ONCE(start_byte < punch_start_byte);
+		WARN_ON_ONCE(start_byte > scan_end_byte);
+
+		/*
+		 * We find the end of this contiguous cached data range by
+		 * seeking from start_byte to the beginning of the next hole.
+		 */
+		data_end = mapping_seek_hole_data(inode->i_mapping, start_byte,
+				scan_end_byte, SEEK_HOLE);
+		if (data_end < 0) {
+			error = data_end;
+			goto out_unlock;
+		}
+		WARN_ON_ONCE(data_end <= start_byte);
+		WARN_ON_ONCE(data_end > scan_end_byte);
+
+		error = iomap_write_delalloc_scan(inode, &punch_start_byte,
+				start_byte, data_end, punch);
+		if (error)
+			goto out_unlock;
+
+		/* The next data search starts at the end of this one. */
+		start_byte = data_end;
+	}
+
+	if (punch_start_byte < end_byte)
+		error = punch(inode, punch_start_byte,
+				end_byte - punch_start_byte);
+out_unlock:
+	filemap_invalidate_unlock(inode->i_mapping);
+	return error;
+}
+
 /*
  * When a short write occurs, the filesystem may need to remove reserved space
  * that was allocated in ->iomap_begin from it's ->iomap_end method. For
@@ -837,8 +996,25 @@ EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
  * allocated for this iomap.
  *
  * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
- * simplify range iterations, but converts them back to {offset,len} tuples for
- * the punch callback.
+ * simplify range iterations.
+ *
+ * The punch() callback *must* only punch delalloc extents in the range passed
+ * to it. It must skip over all other types of extents in the range and leave
+ * them completely unchanged. It must do this punch atomically with respect to
+ * other extent modifications.
+ *
+ * The punch() callback may be called with a folio locked to prevent writeback
+ * extent allocation racing at the edge of the range we are currently punching.
+ * The locked folio may or may not cover the range being punched, so it is not
+ * safe for the punch() callback to lock folios itself.
+ *
+ * Lock order is:
+ *
+ * inode->i_rwsem (shared or exclusive)
+ *   inode->i_mapping->invalidate_lock (exclusive)
+ *     folio_lock()
+ *       ->punch
+ *         internal filesystem allocation lock
  */
 int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 		struct iomap *iomap, loff_t pos, loff_t length,
@@ -848,7 +1024,6 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 	loff_t			start_byte;
 	loff_t			end_byte;
 	int			blocksize = i_blocksize(inode);
-	int			error = 0;
 
 	if (iomap->type != IOMAP_DELALLOC)
 		return 0;
@@ -872,18 +1047,8 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 	if (start_byte >= end_byte)
 		return 0;
 
-	/*
-	 * Lock the mapping to avoid races with page faults re-instantiating
-	 * folios and dirtying them via ->page_mkwrite between the page cache
-	 * truncation and the delalloc extent removal. Failing to do this can
-	 * leave dirty pages with no space reservation in the cache.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(inode, start_byte, end_byte - 1);
-	error = punch(inode, start_byte, end_byte - start_byte);
-	filemap_invalidate_unlock(inode->i_mapping);
-
-	return error;
+	return iomap_write_delalloc_release(inode, start_byte, end_byte,
+					punch);
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
 
-- 
2.44.0.769.g3c40516874-goog

