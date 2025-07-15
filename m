Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666FB219E8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582724; cv=none; b=PnPeiuHpmGkAlDC5kdajELa91cL8W64m3OvN+StCxEMjmHoB5FIn2MX+dF4nEadLawdsJGAT8fzfDxlYoHDes5Ckzv0uOqQCfdWFinbV/HSjDiLs3OfWLeIdeBqh7a8SK9I5fM4OzSXoKWVBibsF7UpM0waXq8LOk39xDr8jU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582724; c=relaxed/simple;
	bh=WnCuzoKXYHUni8ZnSgdC2A8RlKCdagtQuLyblQ8RstI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJn1FgtTCnt+U0vSU68wAl9ROgbi+Y6p29V5UhBYS3vUS3zGlom5q0KGpdF06GOerEi5GfKmc+GMnqN9/ojmRS2R4F74GF4wysxKsb8qi2PCD23OZqJlBCdQOendwK8XuNERpdNaxf0jTNyCwz1HtBd75G7MF/aSyPpShl49fqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GbgyY9EL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GbgyY9EL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e8anE0kosdQ0qyuPk1zAODzNChNWXBHiRrnZDRqonUE=; b=GbgyY9ELEPunjZ8gxWhuFXNtCI
	iChqjpnBLnLwJ3MNex6a8J3dx1L0oJI3jCRc29U+gt0mbOY2ByE65LGp600Ik3vl333pxnY6Hzk4G
	RA8u8nGJls+JT40OMDGRADwnBcKeDZAr9S4708OkssnlAheojYYva5ZnRINXxHI31sMEu60dlieqL
	eEA0Ze9aCOuOFi6yO5dHiUIYXtNu47SiyogVQ6wn45q8HqXPorj53wdDwQDsvkZtscZpXb5cuVAUU
	ov3XVmB078vRHbSsXXqv1Vjy7OngOKIbLXYkBdc/wc3J/9VeldDXiBlf1cKeIu5ceHSIgQkYmRBym
	FjsfYAcw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubepG-000000054tk-27gt;
	Tue, 15 Jul 2025 12:32:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/18] xfs: remove the xfs_trans_header_t typedef
Date: Tue, 15 Jul 2025 14:30:17 +0200
Message-ID: <20250715123125.1945534-13-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
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
index aa7a4c7ae49b..15fc7cac6da3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3107,7 +3107,7 @@ xlog_calc_unit_res(
 
 	/* for trans header */
 	unit_bytes += sizeof(struct xlog_op_header);
-	unit_bytes += sizeof(xfs_trans_header_t);
+	unit_bytes += sizeof(struct xfs_trans_header);
 
 	/* for start-rec */
 	unit_bytes += sizeof(struct xlog_op_header);
-- 
2.47.2

