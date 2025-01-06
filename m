Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8583D1A00EC
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157060; cv=none; b=B+8LUV2T4UAt3IMKw1eDGVZ5VUoEhX6jhsfDeyrhO59x2Qf9A7ah8dAfxWZxhYaq0z828oGMPNzY5zL77jARO7hvoBO2Ik7DVX0aVey5QX+0qjRfThwJ24aiJETTkSQl0CjtmtsTto6fIWi+n++Ao33vvZb48/+9eI74ddls798=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157060; c=relaxed/simple;
	bh=FSsBfgpxxJ8RmDdjdOmaC5G4h3bFB2fWmFzVEsXsXJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5ZqmjLuLWwcgeuy4nyR/zK4f8PziWNrTSLrbtqeHSFlpdCGqFVDEozMnUselpo0tiouESzGrXs1odMQ1oV0spuuQMWBqHYetlO6cGoyXH9Ir9wiHU6ypZEOJ75dmgT6kufGZDalD0oGCBqRSqRmWNV4g9x71zraPeQRNihSKYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FUpRWMQC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FUpRWMQC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uQimQhHmZqQzi/rAxZnrrvBfbS3kH/cawwK23gkD32M=; b=FUpRWMQCGtlTwd6paW/az1Ff0c
	ovUlQ+ZKZoEnM0at6oTHhK8iNVCBpjxxOC/xQ7CWygnTyT+cRS5hFwwmd2e1UpDjA0ANimtCfE1HR
	2WXJOiZp4V+7FdGCmxe3UbOLh8Ka2Hdy5KnEImX6X3BtJwwY5aKiI8z9A/LDJCJ4sg+/DOsOFtKBX
	hA8HfonOB5bM+IMVeh3Vk4k9mxYH86udxFuOufmdRrubzaSwk/doTQIFgFoQapJ5lSmGsXHW/QgaJ
	nNsSWl6AjOjgqjowfp4SP6jRyxqPfP6KMyyvQaantUcyzcbXD79krMVavX/dVPZCFcDZQRa97FTlJ
	bOot8/WA==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjlC-00000000kDg-2MZg;
	Mon, 06 Jan 2025 09:50:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: remove the t_magic field in struct xfs_trans
Date: Mon,  6 Jan 2025 10:50:31 +0100
Message-ID: <20250106095044.847334-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095044.847334-1-hch@lst.de>
References: <20250106095044.847334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The t_magic field is only ever assigned to, but never read.  Remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 2 --
 fs/xfs/xfs_trans.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 4cd25717c9d1..786fb659ee3f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -100,7 +100,6 @@ xfs_trans_dup(
 	/*
 	 * Initialize the new transaction structure.
 	 */
-	ntp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	ntp->t_mountp = tp->t_mountp;
 	INIT_LIST_HEAD(&ntp->t_items);
 	INIT_LIST_HEAD(&ntp->t_busy);
@@ -275,7 +274,6 @@ xfs_trans_alloc(
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
 	       xfs_has_lazysbcount(mp));
 
-	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
 	INIT_LIST_HEAD(&tp->t_items);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 71c2e82e4dad..2b366851e9a4 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -122,7 +122,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
  * This is the structure maintained for every active transaction.
  */
 typedef struct xfs_trans {
-	unsigned int		t_magic;	/* magic number */
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
 	unsigned int		t_blk_res;	/* # of blocks resvd */
-- 
2.45.2

