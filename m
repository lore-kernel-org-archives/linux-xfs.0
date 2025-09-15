Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E116B313291
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942832; cv=none; b=dvq+xzhrZqGPm+kr7zBTvdVvWwLqg/caKtWEtaSLNLcd6ZenQ+HxeEPpJOJxgIsbkJ7Ej0anR/SeBkicaMBTQ23iEsmgUSUkdO/RAQZnpV4eBrBzaPvM4ajbF+n9/ZT2MQeeo86mleSRPm3KOENFq0kE77p8SeeW94PYjRxxrPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942832; c=relaxed/simple;
	bh=0UevK9Iw1BNS/GjqhDOYnhCklcbuooBA5a3mBWYbdIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tzx+eo5Md+pcjKvaJJQb43NBQ85h/pQKijD4pZEKADeb5fQmuQOJwcHCw3wQ9zzaVDPZzOPJOLkPQTYf2ARjlgxLWd5usbzS0rEBjXhheWAVkLhlAZiZ38bvq6HHpHyvsgQDBkI+7E3b9Ba1aWsGRzJUt0jEN/YQ5vjnxUxlGvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TXRvE4b/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TXRvE4b/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ljcir2IbONMJnLWBLq3zSwvtByGxmRbfS26RKgF9Pec=; b=TXRvE4b/tc3YLEsD4Os46MHqWx
	BfzSjLSLgQ0GeAe8VVO3Yv5haADNXYYVeoOgGRMHDSfHiUM8gZlHq5D/ZzfVghKYk3+QjKat2rC1/
	vfqVxsZTv7AjuUUjFCNS0M4WmG83gXTksRpow4HzEfvmcBsf9u2X5Fae8vvI2F1a/PSKxUySa/H5b
	k8ZgCmvEmCQJ7sCbokRNASQ/RNu2DVi6j+gRxrfb32O7MzAst6/wppims37mCINCwTdbFzGFTsHZA
	zmS7kBIw5shbr6XqMyParUxHQer9B9g62WgDX87IObQT2rDE5KeB7gTmCpu4g1jEkO1mcMPaW87Qs
	G+CNy9+A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ec-00000004JZx-1wpS;
	Mon, 15 Sep 2025 13:27:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: remove the xfs_trans_header_t typedef
Date: Mon, 15 Sep 2025 06:26:52 -0700
Message-ID: <20250915132709.160247-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h  | 4 ++--
 fs/xfs/libxfs/xfs_log_recover.h | 2 +-
 fs/xfs/xfs_log.c                | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index e6070ad72af4..8f208e93ec3b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -203,12 +203,12 @@ typedef struct xfs_log_iovec {
  * Do not change the below structure without redoing the code in
  * xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans().
  */
-typedef struct xfs_trans_header {
+struct xfs_trans_header {
 	uint		th_magic;		/* magic number */
 	uint		th_type;		/* transaction type */
 	int32_t		th_tid;			/* transaction id (unused) */
 	uint		th_num_items;		/* num items logged by trans */
-} xfs_trans_header_t;
+};
 
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 95de23095030..9e712e62369c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -111,7 +111,7 @@ struct xlog_recover_item {
 struct xlog_recover {
 	struct hlist_node	r_list;
 	xlog_tid_t		r_log_tid;	/* log's transaction id */
-	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	struct xfs_trans_header	r_theader;	/* trans header for partial */
 	int			r_state;	/* not needed */
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 354e8e0114a6..2978de9da38e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3155,7 +3155,7 @@ xlog_calc_unit_res(
 
 	/* for trans header */
 	unit_bytes += sizeof(struct xlog_op_header);
-	unit_bytes += sizeof(xfs_trans_header_t);
+	unit_bytes += sizeof(struct xfs_trans_header);
 
 	/* for start-rec */
 	unit_bytes += sizeof(struct xlog_op_header);
-- 
2.47.2

