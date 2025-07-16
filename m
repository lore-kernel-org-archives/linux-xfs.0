Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1302F2734
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669860; cv=none; b=PMbnteM2Q/NzrVSwifOwbE9eHTbN4lRBBojNSy9+2gZRK2aapdG/HH+5v/oiO99Q1v27GFuI4oZt4arf5ktSGkBWcP8mtVHr00yhOYcwyEeg5HOOIJA+yPsFEDRyzno5fBNoh4uhKZAA9QVaS7fnU1fqnBWgb+DGJN099GBDwPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669860; c=relaxed/simple;
	bh=kIs/wH0XYtsxARgFWaxguIVeT7K/HRfive2RAOieVfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYxJaVQaLaIb3U5NNay/WaL9oAFRdFtUhfmZWL8mIwV+r2cvkXH++o12m7LaVii7HFU2Km1IJ9/9MEDoZNd0XxyQJosFrvmvMmVuyLFrOiJyK/rJ4u5K6Nx2vbhPoSofRL8Zj96ji9rCxKZzfgr53+/F6EGxFl+zYvfQcxAY5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j1cmJIgL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j1cmJIgL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UH7tdQGxcI1QEwc7lewnHsajc5nonhAY9HnHzKoM7e8=; b=j1cmJIgLxTlQzLG65XbQDpGzKL
	9zoN3KceCJKwCXyeGUKWPtF//Fyjtv8rEFXaPLN5hyGWNTYXia8Z5+GGohzsh8pvyVm5dxflOnzQ0
	PD0zNvZIYfIpdoLZVIJewf6BmZ0xZINJO8aPMdrH8TRoNUWD5d3S1PCYZD0q26Z/LamIPRPZhm5XM
	IyuePdntwpYseVHBzgnkdvkjyTH/Au5U0NQwN1UNOLDz0rM95JsaPhDXc8cfTrszGwaWgFpkRswxo
	NKwub4XwuxrrmM8x371EM/qzGTWzl7Po1Q9kpHVYdC74DaakpgIvvAG6HmfbYrYLXR1tPAspoaa2I
	MtpcURSQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1Ug-00000007guq-2glP;
	Wed, 16 Jul 2025 12:44:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 8/8] xfs: remove the xlog_ticket_t typedef
Date: Wed, 16 Jul 2025 14:43:18 +0200
Message-ID: <20250716124352.2146673-9-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716124352.2146673-1-hch@lst.de>
References: <20250716124352.2146673-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 6 +++---
 fs/xfs/xfs_log_priv.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 793468b4d30d..bc3297da2143 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3092,16 +3092,16 @@ xfs_log_force_seq(
  */
 void
 xfs_log_ticket_put(
-	xlog_ticket_t	*ticket)
+	struct xlog_ticket	*ticket)
 {
 	ASSERT(atomic_read(&ticket->t_ref) > 0);
 	if (atomic_dec_and_test(&ticket->t_ref))
 		kmem_cache_free(xfs_log_ticket_cache, ticket);
 }
 
-xlog_ticket_t *
+struct xlog_ticket *
 xfs_log_ticket_get(
-	xlog_ticket_t	*ticket)
+	struct xlog_ticket	*ticket)
 {
 	ASSERT(atomic_read(&ticket->t_ref) > 0);
 	atomic_inc(&ticket->t_ref);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 39a102cc1b43..a9a7a271c15b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -144,7 +144,7 @@ enum xlog_iclog_state {
 
 #define XLOG_COVER_OPS		5
 
-typedef struct xlog_ticket {
+struct xlog_ticket {
 	struct list_head	t_queue;	/* reserve/write queue */
 	struct task_struct	*t_task;	/* task that owns this ticket */
 	xlog_tid_t		t_tid;		/* transaction identifier */
@@ -155,7 +155,7 @@ typedef struct xlog_ticket {
 	char			t_cnt;		/* current unit count */
 	uint8_t			t_flags;	/* properties of reservation */
 	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
-} xlog_ticket_t;
+};
 
 /*
  * - A log record header is 512 bytes.  There is plenty of room to grow the
-- 
2.47.2

