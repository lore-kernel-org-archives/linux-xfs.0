Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358617BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052997; cv=none; b=C3f3XRKsnupjUw2xXLl4AJRtdudDvbU5VJozkJKwR5JmGjJteef+klLxqYUknq75pmk3jqfWUQ3XZ2oaIz4lbDM3/oeO7mBzSmudxHY2OMlRELjqM7ntQ8buina0SyjYRJRa8CXvSRarc/eO9gQp7ypcF5rp1rqgestPFWnkEYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052997; c=relaxed/simple;
	bh=kKz9K3F+lPeE+yIdMEqt89LUeSNml2IE66ly0hGswGI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=syPpqrO67u8fjH9OtPer1sPpRkRNg6/9XOgs/vXR7ykEqPXV+05ROiTfklgTK7dd0CZ6EidG9FUEYbyKEE23lSvYZ+c6WAfyWMZZlfVrdrGQ8ZMNqmLG1MzuU6JI2zdkZ4OjPbgG6G7zP/Zd3i79faXFlTWq+YfK+4Zfefn6OW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rghH5f8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rghH5f8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3FEC4CECE;
	Fri, 13 Dec 2024 01:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052997;
	bh=kKz9K3F+lPeE+yIdMEqt89LUeSNml2IE66ly0hGswGI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rghH5f8XGlNltI8pMyG3CWuva7IRzHkq4MHmbG4J5lrsbgn5Ilbdz/q3ISV9vDL/o
	 1XkKNrciyR1cPFUkJKBKPpGD52dyXwiVOHl+h5XlgQqFp1HPwT8cEZYSXremH5y7pZ
	 xSZ+vkVTSEhmS4zvY73dZUBFXYBGvImXOn+r2FvO9svM5HpbU2cLb1AXncfyz+PKyu
	 c6QOU1hsmkFCs07K7sMrv6L9V1IgqgBfKX8kOXsZky3/Z+NpxsJ2SEpkJ99iDFgljy
	 AvahV+QQbxII9nwtW+DfRaU02ghn+UwOidMV4qGS4q2UcKPXRhlWIRp7qH4qWVQ41t
	 qpzZgtJdKtEUA==
Date: Thu, 12 Dec 2024 17:23:17 -0800
Subject: [PATCH 07/11] xfs: extend writeback requests to handle rt cow
 correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125863.1184063.8842755288883819617.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we have shared realtime files and the rt extent size is larger than a
single fs block, we need to extend writeback requests to be aligned to
rt extent size granularity because we cannot share partial rt extents.
The front end should have set us up for this by dirtying the relevant
ranges.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |   38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h |    1 +
 2 files changed, 39 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f51f2f5f76d0f6..9bc2d7d92e4c46 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -466,6 +466,38 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 	.discard_folio		= xfs_discard_folio,
 };
 
+/*
+ * Extend the writeback range to allocation unit granularity and alignment.
+ * This is a requirement for blocksize > pagesize scenarios such as realtime
+ * copy on write, since we can only share full rt extents.
+ */
+static inline void
+xfs_vm_writepages_extend(
+	struct xfs_inode		*ip,
+	struct writeback_control	*wbc)
+{
+	unsigned int			bsize = xfs_inode_alloc_unitsize(ip);
+	long long int			pages_to_write;
+	loff_t				next = wbc->range_end + 1;
+
+	wbc->range_start = rounddown_64(wbc->range_start, bsize);
+	if (wbc->range_end != LLONG_MAX)
+		wbc->range_end = roundup_64(next, bsize) - 1;
+
+	if (wbc->nr_to_write != LONG_MAX) {
+		pgoff_t		pg_start = wbc->range_start >> PAGE_SHIFT;
+		pgoff_t		pg_next = (wbc->range_end + 1) >> PAGE_SHIFT;
+
+		pages_to_write = pg_next - pg_start;
+		if (pages_to_write >= LONG_MAX)
+			pages_to_write = LONG_MAX;
+		if (wbc->nr_to_write < pages_to_write)
+			wbc->nr_to_write = pages_to_write;
+	}
+
+	trace_xfs_vm_writepages_extend(ip, wbc);
+}
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space		*mapping,
@@ -476,6 +508,9 @@ xfs_vm_writepages(
 
 	trace_xfs_vm_writepages(ip, wbc);
 
+	if (xfs_inode_needs_cow_around(ip))
+		xfs_vm_writepages_extend(ip, wbc);
+
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
@@ -489,6 +524,9 @@ xfs_dax_writepages(
 
 	trace_xfs_dax_writepages(ip, wbc);
 
+	if (xfs_inode_needs_cow_around(ip))
+		xfs_vm_writepages_extend(ip, wbc);
+
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return dax_writeback_mapping_range(mapping,
 			xfs_inode_buftarg(ip)->bt_daxdev, wbc);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0234af78cea9a1..021ea65909c915 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1586,6 +1586,7 @@ DEFINE_EVENT(xfs_writeback_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, const struct writeback_control *wbc), \
 	TP_ARGS(ip, wbc))
 DEFINE_WRITEBACK_EVENT(xfs_vm_writepages);
+DEFINE_WRITEBACK_EVENT(xfs_vm_writepages_extend);
 DEFINE_WRITEBACK_EVENT(xfs_dax_writepages);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,

