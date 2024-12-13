Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DF61078F
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052982; cv=none; b=Q5mae6TIkW4bVaQByTiYpDY4QJ2knTN/YwPB+ZGKL0cg8kw7KcjlIHEC/FkVbyQf0IlF2Dcf1H7t6aEeXDDWLFWUg9TC1iJf98HgqZbD8VDYRpSJnc741Jstk1TI8EPwolbFeWTDd770X/Ga9i4fiGrQOh6ZIFPz6CWDOobMtGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052982; c=relaxed/simple;
	bh=MGXPCPb2rp08r7BvOWJ0lcc715YkjlICeVLVxxChSww=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvDDHqwAVXk7Nla8z+xOP2Fm9i3Is3TFeumfXtbtp035V/jmEHo/8cWuSq5DYELLmSj7Acwnwb6aOE9AZZH6OCkeKDdYzNNoWVcnotdlWPfCsl31tFw034bk4w3ul7BytJ6oH5cokVvbDGoGE3BICAgQMnbYhtbbi5fd4iniP5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjYQ0loj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjYQ0loj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F12C4CECE;
	Fri, 13 Dec 2024 01:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052982;
	bh=MGXPCPb2rp08r7BvOWJ0lcc715YkjlICeVLVxxChSww=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QjYQ0lojW5tOzKcZx2JyBgH83gejwzKSZQNvypdmmeplPfRMwAYw4vNf9MSIL3HZ/
	 xgSjx14dNXjDJqEcw3KqKzEr4DMiYZiJXN8BMf3iJ2UwUT5oRyDD1+UrdcKvoSKrvA
	 gVIIifo2mAn9YA0g/D330VMwKCijO0uPwWH2WiRbhofK5OHiH0PDPstOOCKlE7e7pu
	 UlYvO/2srTUsoUZNv4+n/6SfwsPaPrAbUaadXqO/MWuyZK3p3q5c8LzxBGn/XGiJw3
	 j4gWd2vmCwIS++Q/+WMV5f5Sc5sQEPXnr7iEJalade/Jw0fbiKE7MtsSsXknUHsKsQ
	 MzSDPZnhgoQIw==
Date: Thu, 12 Dec 2024 17:23:01 -0800
Subject: [PATCH 06/11] xfs: add some tracepoints for writeback
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125846.1184063.6516078668233318926.stgit@frogsfrogsfrogs>
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

Add a tracepoint so I can see where writeback is initiated.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |   19 ++++++++++++-------
 fs/xfs/xfs_trace.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 559a3a57709748..f51f2f5f76d0f6 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -468,21 +468,26 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 
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
index e744f9435ff88d..0234af78cea9a1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1554,6 +1554,40 @@ DEFINE_IMAP_EVENT(xfs_map_blocks_alloc);
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

