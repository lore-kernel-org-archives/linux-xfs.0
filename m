Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF6817BEC6
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409909; cv=none; b=D3qyObowWMx+r1CwINPw2GtnZ2pIlZH0sghWUvMzdUdq3Xz+qLv2m+1RuxV/IDLMn3UKPe+TlfxN6pfa1LCRrVjaucpLA3hT6Wa/D+ZgASjUXhyJuPrhfnbcVjCamT4bmv4wBUGZuEWqHcsdp9XPOBsyORhc0ift4MzayLVbpBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409909; c=relaxed/simple;
	bh=16xJ+WGOXCx8IjEdszCekZ3zQDlr+sc1l1+5thcagjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR31cNSDcpLzfbk/KS9Mg9gUpDvzvb8uLS5KsGNx5SOMUS3fmF/n3/eCu5jKP+OTZi1q3uua6gKmT/e3/H4dHLbE+gYZvaz4geMDr3cTTw6NfGJ+5xhjxyTYd52/KnFjk5Zek+/UEsH17KmCz1K5r8QCs2Cj19EkQO6S+g+ocbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UfXCTCXf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UfXCTCXf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QVGajRmqmN+B9NOxicSVFCtx9HYVMzqFm4LN71THXP8=; b=UfXCTCXfH9DdirGt5eGRXnI3pD
	k5OS2CeTEJlvt+gCSvhFnmFAEigIvdufKQPqyVkwHMn3cesmeXtXw25VwGpcRopOnGVyaPKUGo3Ut
	7tYBcVWM2yQtPiTSPu6HhZPYCyZGoLyfSHZX0D3w7ZKQpyVkc0JOLgSgBfsWfoWu4OKTFnu/k/wSd
	5wF4JtN8Ga1vDn0WUZEMoS7Koov8/O72LloAssXUrAgzrmqzYFBLHU1ZRP3zs74fOci7+ipYWXtUb
	llG20Gnr/ScO9c5H3O1Vr9CyENlDgcYkAqWw2JwjKNVZ5XTxV8s0RXB6KqMe2iFaX1P8NhSENamJd
	ON23yF9Q==;
Received: from syn-035-131-028-085.biz.spectrum.com ([35.131.28.85] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tma7X-0000000EEg3-3Ovj;
	Mon, 24 Feb 2025 15:11:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: remove the XBF_STALE check from xfs_buf_rele_cached
Date: Mon, 24 Feb 2025 07:11:38 -0800
Message-ID: <20250224151144.342859-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250224151144.342859-1-hch@lst.de>
References: <20250224151144.342859-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buf_stale already set b_lru_ref to 0, and thus prevents the buffer
from moving to the LRU.  Remove the duplicate check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cde8707b9892..882800a008bf 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -99,12 +99,6 @@ xfs_buf_stale(
 	 */
 	bp->b_flags &= ~_XBF_DELWRI_Q;
 
-	/*
-	 * Once the buffer is marked stale and unlocked, a subsequent lookup
-	 * could reset b_flags. There is no guarantee that the buffer is
-	 * unaccounted (released to LRU) before that occurs. Drop in-flight
-	 * status now to preserve accounting consistency.
-	 */
 	spin_lock(&bp->b_lock);
 	atomic_set(&bp->b_lru_ref, 0);
 	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
@@ -1033,7 +1027,7 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
+	if (atomic_read(&bp->b_lru_ref)) {
 		/*
 		 * If the buffer is added to the LRU, keep the reference to the
 		 * buffer for the LRU and clear the (now stale) dispose list
-- 
2.45.2

