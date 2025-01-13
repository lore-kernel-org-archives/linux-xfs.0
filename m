Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428A623ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777557; cv=none; b=nc1HUxLLFjGCd9XYgx1XM5POc/BUy+dqz8cql9q4AWCayjDtJ+wD1mmDG+ef/lvLjl57ougHNe4wjHrC7vU56XsE44dsxWCBbSofpfZGfy7GIfr8fBRLGpMX2I6dCSZ7e63056rI/nw/8Yq02GO48MVWkt/GMps5AjSMXDHuL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777557; c=relaxed/simple;
	bh=wC4jd7jeWFg6+old2mT71mnQoHpNnbggYf+uHXwPT70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM+JVUGH60SnY2HNfPBlD7hsdC/cCE+RNQKenmtPVixUyUS8TIVk6+kb5LrEW/bja1WvIj3pEMFAK8zUGKgSt2bZeaU8pFg2RtDZhn/aM0U0bl5v1Due/tV/LeWkihFCGVNCUC5L0qTptbecd/I6eUpFiO32eP1xdJQScDLAfiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rk0C/SHD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rk0C/SHD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4xumS3hlo3qHgZM8ODq3d34d5fNviX4Li7P0fLeORxs=; b=rk0C/SHDfYMNhEjcA5JFKpO0Ze
	13q07+tsoIFBC32OZ/o3J4NSG/8BN2zehe2SDKvOE9A/9SQCoiGpuoUugPwQC4cCW8OJ6clxRwv2Y
	hwTPVgh/AZlUzVTubVySROWSFvin0Y1lSAcgwyZ5OCaNS0Jaqf3sAo1oe9JPMGtp8AQ4hmDY/xX7D
	TqtEPRmtHczoYodqotNG78bXrjbzvqnnc2ZZ7IXAbQG91jizqy9c3KFOkj2ADG44ed1q/0dOLryQJ
	XuG2kZd8BZiSFQY9FJ0L/dzL+nddkRro8dyCjSB3i77gAFGkK4fmVvjf58Omb5IdN/UTk0Bp13L6W
	5NVJadTg==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBC-00000005Mjw-0NrR;
	Mon, 13 Jan 2025 14:12:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/15] xfs: fix a double completion for buffers on in-memory targets
Date: Mon, 13 Jan 2025 15:12:05 +0100
Message-ID: <20250113141228.113714-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__xfs_buf_submit calls xfs_buf_ioend when b_io_remaining hits zero.  For
in-memory buftargs b_io_remaining is never incremented from it's initial
value of 1, so this always happens.  Thus the extra call to xfs_buf_ioend
in _xfs_buf_ioapply causes a double completion.  Fortunately
__xfs_buf_submit is only used for synchronous reads on in-memory buftargs
due to the peculiarities of how they work, so this is mostly harmless and
just causes a little extra work to be done.

Fixes: 5076a6040ca1 ("xfs: support in-memory buffer cache targets")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6f313fbf7669..da38c18acbba 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1657,10 +1657,8 @@ _xfs_buf_ioapply(
 	op |= REQ_META;
 
 	/* in-memory targets are directly mapped, no IO required. */
-	if (xfs_buftarg_is_mem(bp->b_target)) {
-		xfs_buf_ioend(bp);
+	if (xfs_buftarg_is_mem(bp->b_target))
 		return;
-	}
 
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
-- 
2.45.2

