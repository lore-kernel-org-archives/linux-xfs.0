Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D575711704
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnzKGD/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E1DC433C8;
	Sun, 31 Dec 2023 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059841;
	bh=2p5a3yxnr9HTGuBjAk30UqelWBu9sZ+ILLpyRkjs1Js=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KnzKGD/Gm5ptuisy7GWtDlhKky4IL2fEwePzl9wNiyfW6DrXtRbl1shjTIDxBGEti
	 vRHyI60kuMk2e14bTCWUIzdNPGtJqMj0i0aL1KznJPzfSM2YnbLnl4ovFNzsk1TwXN
	 cfkLoqT03wdQ62coxEI/Z0CG9O3YoFfay1BN8plVSEyUlvUIqLnpuscWAlG6Makdgl
	 6v+tugt3xNOReocRDXB6zMoFVlhGS9lkdeGgFxW/OmIW46GxTUYaWqiW631gb8g9ZJ
	 9gCbZsNW3nYpGHADi27ZXPo5kuEXS4b8eqLwnb7o88TwfEp53H03/xLsyq+EfzqcI8
	 cYxDOaPGj1O1w==
Date: Sun, 31 Dec 2023 13:57:20 -0800
Subject: [PATCH 5/9] xfs: extend writeback requests to handle rt cow correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852751.1767395.2816430586609993508.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |   38 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h |    1 +
 2 files changed, 39 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1217ce197ad98..b6ef76ee65f5e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -495,6 +495,38 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
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
@@ -512,6 +544,9 @@ xfs_vm_writepages(
 
 	trace_xfs_vm_writepages(ip, wbc);
 
+	if (xfs_inode_needs_cow_around(ip))
+		xfs_vm_writepages_extend(ip, wbc);
+
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
@@ -525,6 +560,9 @@ xfs_dax_writepages(
 
 	trace_xfs_dax_writepages(ip, wbc);
 
+	if (xfs_inode_needs_cow_around(ip))
+		xfs_vm_writepages_extend(ip, wbc);
+
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return dax_writeback_mapping_range(mapping,
 			xfs_inode_buftarg(ip)->bt_daxdev, wbc);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 39df20ae702c8..4767fc49c4641 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1584,6 +1584,7 @@ DEFINE_EVENT(xfs_writeback_class, name,	\
 	TP_PROTO(struct xfs_inode *ip, const struct writeback_control *wbc), \
 	TP_ARGS(ip, wbc))
 DEFINE_WRITEBACK_EVENT(xfs_vm_writepages);
+DEFINE_WRITEBACK_EVENT(xfs_vm_writepages_extend);
 DEFINE_WRITEBACK_EVENT(xfs_dax_writepages);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,

