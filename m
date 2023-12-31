Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA76111704
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQM578Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F1DC433C8;
	Sun, 31 Dec 2023 21:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059825;
	bh=vg76k9acyABRI+YhTu1zMJQdFknTjOSlaq0rncKsg04=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iQM578BoCxjmo6MCYdVbSW+bmBV4K+Y7uhk7SFl4i/ZcrshJdTz6aX2H7Cy973qPS
	 mr+n5fdnftj0r+v0skDDpO29QChKnDt4hJXJvZ0imdk68FMQQLs/qNbYUtvFNgEAEf
	 w0CyLCtkkJvckDGyWFCgtKO1ZfXiyHDWlHC7jhQiuxO/RIR9qzeTCeLbCr81w6RTXD
	 U8H5iuWyBitB6PIaNPGpguj3E4gCL5dxR6PTEpUQKftFZ8DRXXO3yY7A0eQUnK4idI
	 /fHIjKvLOK2XIsuQYPPmBuNr23s4Q9gl7TtKbM1tX6AYQrD5Gp5ywRJsSLuDsIFxUI
	 y6lA3qH0/OR1A==
Date: Sun, 31 Dec 2023 13:57:05 -0800
Subject: [PATCH 4/9] xfs: add some tracepoints for writeback
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852735.1767395.8058627554300848243.stgit@frogsfrogsfrogs>
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

Add a tracepoint so I can see where writeback is initiated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |   19 ++++++++++++-------
 fs/xfs/xfs_trace.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3001ddf48d6c6..1217ce197ad98 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -497,10 +497,11 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 
 STATIC int
 xfs_vm_writepages(
-	struct address_space	*mapping,
-	struct writeback_control *wbc)
+	struct address_space		*mapping,
+	struct writeback_control	*wbc)
 {
-	struct xfs_writepage_ctx wpc = { };
+	struct xfs_writepage_ctx	wpc = { };
+	struct xfs_inode		*ip = XFS_I(mapping->host);
 
 	/*
 	 * Writing back data in a transaction context can result in recursive
@@ -509,16 +510,20 @@ xfs_vm_writepages(
 	if (WARN_ON_ONCE(current->journal_info))
 		return 0;
 
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	trace_xfs_vm_writepages(ip, wbc);
+
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
 STATIC int
 xfs_dax_writepages(
-	struct address_space	*mapping,
-	struct writeback_control *wbc)
+	struct address_space		*mapping,
+	struct writeback_control	*wbc)
 {
-	struct xfs_inode	*ip = XFS_I(mapping->host);
+	struct xfs_inode		*ip = XFS_I(mapping->host);
+
+	trace_xfs_dax_writepages(ip, wbc);
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 	return dax_writeback_mapping_range(mapping,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 643cffaf3add2..39df20ae702c8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1552,6 +1552,40 @@ DEFINE_IMAP_EVENT(xfs_map_blocks_alloc);
 DEFINE_IMAP_EVENT(xfs_iomap_alloc);
 DEFINE_IMAP_EVENT(xfs_iomap_found);
 
+DECLARE_EVENT_CLASS(xfs_writeback_class,
+	TP_PROTO(struct xfs_inode *ip, const struct writeback_control *wbc),
+	TP_ARGS(ip, wbc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(loff_t, range_start)
+		__field(loff_t, range_end)
+		__field(long, nr_to_write)
+		__field(enum writeback_sync_modes, sync_mode)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->range_start = wbc->range_start;
+		__entry->range_end = wbc->range_end;
+		__entry->nr_to_write = wbc->nr_to_write;
+		__entry->sync_mode = wbc->sync_mode;
+	),
+	TP_printk("dev %d:%d ino 0x%llx range_start 0x%llx range_end 0x%llx nr_to_write %ld sync_mode %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->ino,
+		   __entry->range_start,
+		   __entry->range_end,
+		   __entry->nr_to_write,
+		   __entry->sync_mode)
+);
+#define DEFINE_WRITEBACK_EVENT(name)	\
+DEFINE_EVENT(xfs_writeback_class, name,	\
+	TP_PROTO(struct xfs_inode *ip, const struct writeback_control *wbc), \
+	TP_ARGS(ip, wbc))
+DEFINE_WRITEBACK_EVENT(xfs_vm_writepages);
+DEFINE_WRITEBACK_EVENT(xfs_dax_writepages);
+
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, u64 count),
 	TP_ARGS(ip, offset, count),

