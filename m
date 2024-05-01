Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E131474A7;
	Wed,  1 May 2024 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588882; cv=none; b=YjGvG9C7uXcT4vYZ6SYLWDj6wSfFAL2wBIz3/Doq1Sr7jZE9KMEOy7ujIpNFtN+6gUah3NVcEzNUbt/NFD5B9UYNXCa1McZA2PbLMBp43eA6KjSMZJbUKwf7o5qQi5vAg2EOIFic0pNQxyGDskJRo5UFsj42pr+H9DTaXg3Ao5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588882; c=relaxed/simple;
	bh=htE3PKhtgQqjkh12iTZVSmytK++exxWFa5QFD/mt7ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxu1u1wW6VZUxHjc7ob1ti9pyMmnC2gSsp6RsSWhmb3Ji9gw3v37VWg7TTORXsOR/lABRjUYxnWooFbqi6ieb4trKjmY6xFPoLkY3cKQFxMyVFAOWSzXHqHCWT4aDxfooY+EFzWoL6K9zqdrHCvFHWBGwvbnFkpem4DOyoNo9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2WkO8qt; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2WkO8qt"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso6299628b3a.0;
        Wed, 01 May 2024 11:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588880; x=1715193680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7y9aWFpWTWXc5OoRsR0E7OG8iNnqgmrDrO4s8Q+TTAA=;
        b=j2WkO8qtorKYOvYZBTqVp/BR5do+qtNhbF4iVlUjYpNvjTGyGZyUsrQHUlY7D/f1RS
         JsWMUs76bsf7ib1zl6+u60q7QuWN9XL820U5JIFb4Vzm/rMdnwYOmWOpsH/XnaU77aZg
         QPnzSPbWLE+8ZLQ8+hQ/RIH59ljGdpwaGsFF1Fl82jinDPEO+Bc5K3Zn02g76tB6+5NM
         Hf0O3HQlT+bXHx1eIQRf0oHOPq/7AgenJcogPPH4PghujyKkpX6XH7UCDiPvWrc4gggt
         NO7HHXOGmU557OGJi9UWDGcrFSHONzURT8RZ5LFO/UN71+3cZlKAr40S/PmQxGyj8/gz
         2TAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588880; x=1715193680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7y9aWFpWTWXc5OoRsR0E7OG8iNnqgmrDrO4s8Q+TTAA=;
        b=jRm9/V4muqeW8oPOuzQEA5y8Cpph3d02kwMgElWvQbvP/0l8xjt6/mlG/izhCH9A8t
         TjDCiFo6E1yFfLonfm9YepERNKSAdBX/LabUjQLod0WrXBPHJuzzJnvg3tAdTKXYffP1
         Zusw2yd8NhwzjpFjbo6AGKs5I1GYD1MjuUTfSRK3Il41nymNq/xemSIKQZRJZO6gSXAr
         7AHEIdQXOCZq0grfrwjf80rJ/CfNNccTFfesOukvwSdbYjtmUDY0RmBPTOrarGSUTdOR
         4iwL4ir/dufsyG8XqucbrVkTSNB1ur3eWj9l7E57OyF8yDyWUNWCxqMzO8+5oYY1Ksn+
         Rbvw==
X-Gm-Message-State: AOJu0YwKcg968tqWOy5A2kr5EySi7avIO0b2ZUxA7dS+auMPjfgnBp3h
	YyJW8qHMy9TkOOzMX5jYCMFU8HuZDnHByRnIYieNa9nj+KLsjU/xWQOSTpvh
X-Google-Smtp-Source: AGHT+IHvbC3P04CdHFs2UCx1xh2hyn1eZhDsLNZFcTERL4FejkOESY5lmtMDii5kQdf7ZfzRhXFBOw==
X-Received: by 2002:a05:6a20:2d0b:b0:1a9:b4ed:a with SMTP id g11-20020a056a202d0b00b001a9b4ed000amr5656795pzl.20.1714588879754;
        Wed, 01 May 2024 11:41:19 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:19 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 04/24] xfs,iomap: move delalloc punching to iomap
Date: Wed,  1 May 2024 11:40:52 -0700
Message-ID: <20240501184112.3799035-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 9c7babf94a0d686b552e53aded8d4703d1b8b92b ]

Because that's what Christoph wants for this error handling path
only XFS uses.

It requires a new iomap export for handling errors over delalloc
ranges. This is basically the XFS code as is stands, but even though
Christoph wants this as iomap funcitonality, we still have
to call it from the filesystem specific ->iomap_end callback, and
call into the iomap code with yet another filesystem specific
callback to punch the delalloc extent within the defined ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c     | 47 ++++++---------------------------
 include/linux/iomap.h  |  4 +++
 3 files changed, 72 insertions(+), 39 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a0a4d8de82ca..24be3297822b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -827,6 +827,66 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+/*
+ * When a short write occurs, the filesystem may need to remove reserved space
+ * that was allocated in ->iomap_begin from it's ->iomap_end method. For
+ * filesystems that use delayed allocation, we need to punch out delalloc
+ * extents from the range that are not dirty in the page cache. As the write can
+ * race with page faults, there can be dirty pages over the delalloc extent
+ * outside the range of a short write but still within the delalloc extent
+ * allocated for this iomap.
+ *
+ * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
+ * simplify range iterations, but converts them back to {offset,len} tuples for
+ * the punch callback.
+ */
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length,
+		ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length))
+{
+	loff_t			start_byte;
+	loff_t			end_byte;
+	int			blocksize = i_blocksize(inode);
+	int			error = 0;
+
+	if (iomap->type != IOMAP_DELALLOC)
+		return 0;
+
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
+	/*
+	 * start_byte refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_byte = round_down(pos, blocksize);
+	else
+		start_byte = round_up(pos + written, blocksize);
+	end_byte = round_up(pos + length, blocksize);
+
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_byte >= end_byte)
+		return 0;
+
+	/*
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = punch(inode, start_byte, end_byte - start_byte);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
+
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7bb55dbc19d3..ea96e8a34868 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1123,12 +1123,12 @@ xfs_buffered_write_iomap_begin(
 static int
 xfs_buffered_write_delalloc_punch(
 	struct inode		*inode,
-	loff_t			start_byte,
-	loff_t			end_byte)
+	loff_t			offset,
+	loff_t			length)
 {
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
 				end_fsb - start_fsb);
@@ -1143,13 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	loff_t			start_byte;
-	loff_t			end_byte;
-	int			error = 0;
 
-	if (iomap->type != IOMAP_DELALLOC)
-		return 0;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	int			error;
 
 	/*
 	 * Behave as if the write failed if drop writes is enabled. Set the NEW
@@ -1160,35 +1156,8 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
-	/* If we didn't reserve the blocks, we're not allowed to punch them. */
-	if (!(iomap->flags & IOMAP_F_NEW))
-		return 0;
-
-	/*
-	 * start_fsb refers to the first unused block after a short write. If
-	 * nothing was written, round offset down to point at the first block in
-	 * the range.
-	 */
-	if (unlikely(!written))
-		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
-	else
-		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
-	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
-
-	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_byte >= end_byte)
-		return 0;
-
-	/*
-	 * Lock the mapping to avoid races with page faults re-instantiating
-	 * folios and dirtying them via ->page_mkwrite between the page cache
-	 * truncation and the delalloc extent removal. Failing to do this can
-	 * leave dirty pages with no space reservation in the cache.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(inode, start_byte, end_byte - 1);
-	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
-	filemap_invalidate_unlock(inode->i_mapping);
+	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
+			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {
 		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
 			__func__, XFS_I(inode)->i_ino);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..0698c4b8ce0e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -226,6 +226,10 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
+
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

