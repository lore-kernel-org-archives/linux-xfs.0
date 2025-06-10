Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958827083C
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 05:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749532652; cv=none; b=qFyIDaS52zFrhyj66o4wcRW+ok/TaIeNoFhQ6NGh7g7zajACkcsuGwXgWHCkVF3MM88eSQPZNSNx7XXyNseNKn9bbbHithGOkCkYK7tV4QY1Oo+yCSzaw85Mqrh8/SG4Uk5Xq4YEUJncmKxLvHADNbQWGBg+xYIpsYtnL22CC34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749532652; c=relaxed/simple;
	bh=NbgHECgSJjXfmbDnv1A1abLocX16ElWPJ4BQWBmPZEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAj/9GSVVZnrCohS3sxIZBm29i2d2+dIYo/ZG9EtJ0VEgPDmRZHZykMl4Y6y0NOhEncQWrNJHVvV6Y96SCUHbM/go3n5P9FFuc9tpK7l8KYfV/5U807GjHTFLfOO8alfLLJU/vYaz6AM/NGTzrXbB+/39mVsMSYORcz0LhdycZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mQen6ngC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mQen6ngC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PXY5IZJYISbtx9tjNVUWZtq1uUswMc+J8TNc5AUOI5s=; b=mQen6ngCBqTSF5LBSVRrg8dFAU
	L9Q5iQLmS3ele1SJKI3fa+PkybTyXCduPmgG/3Qj4TS+mDNyYqq4cpE9PymLokYUwXGkL2fOFFDYR
	p4qZwu+Cl8tZcer5ReJ4TnEtm3+xDY5Yniy7QWiajpcJn5GJ6Lz0VsHXK1hN053gyeoGQftrllh1G
	Ts2mwfpvdBZAk2qeMZswuLbzTBNJwRec7T+4KvXmojL/aI7m6sMd+LrPv1VeWKvCkSHMAt03Jxy/m
	k6c6/xqzxJPFrseifregacO+DWOn2PahYHmwGnFWaSpCGd9JT2pV74aQyu/gnvEuO5I0HLuEC7Bgp
	X49enbdg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOrMY-00000005pNo-2gAu;
	Tue, 10 Jun 2025 05:17:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/17] xfs: remove the xfs_trans_header_t typedef
Date: Tue, 10 Jun 2025 07:15:12 +0200
Message-ID: <20250610051644.2052814-16-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250610051644.2052814-1-hch@lst.de>
References: <20250610051644.2052814-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Almost no users of the typedef left, kill it and switch the remaining
users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h  | 4 ++--
 fs/xfs/libxfs/xfs_log_recover.h | 2 +-
 fs/xfs/xfs_log.c                | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 6cdcc6eef539..e5e6f8c0408f 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -204,12 +204,12 @@ typedef union xlog_in_core2 {
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
index 601edfd7f33c..88b74091096f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3041,7 +3041,7 @@ xlog_calc_unit_res(
 
 	/* for trans header */
 	unit_bytes += sizeof(struct xlog_op_header);
-	unit_bytes += sizeof(xfs_trans_header_t);
+	unit_bytes += sizeof(struct xfs_trans_header);
 
 	/* for start-rec */
 	unit_bytes += sizeof(struct xlog_op_header);
-- 
2.47.2

