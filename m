Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2279923ED62
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777578; cv=none; b=oMB6NPtGTdiVkSnMH8LVq972Yr56e3aXFCs363Y7qn6leOpiGrdB1TKqP5Gwt0Cg/zyFLxS0lTyWf407J+BQko7cmV/YF9t5gi6Rdu0MXVZ2l65DQIbLcfuASIf/dC8IZuCOR79aU7twBN+O1JaCB7rdggR+W6RhQ4XNYM66nyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777578; c=relaxed/simple;
	bh=SAWF+y0IQi51v3kAXJwZaq62XzRcpSmhziwM5ianJ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pmyil+kvZZLuPSHrk9egQj7lo+pkXS9R690RscnXOFoFLrpT06zr/fvYpalOcBKPQV+hIijoaW/fqMiwJY/keYU3crZyeWJXiIcvvJWzDAYmfYKjXLtqWHGcyLZz1r87l5ZpvlXwCW+JTcJw4HEXgSkWgfsEUXuU09zpEYD7Xjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IuHS+zMh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IuHS+zMh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EXRWfW7+0M05mpxzz2QoNtso4WwI+WM3Q0bsmHX/wc0=; b=IuHS+zMhAfkd0RDBEUi7p9pTH9
	zrYuahwl5EK0U+fJOexm2hKnH/voDV6cUyKORUANosVtFrk+/eN5Y5FQuW/S62NMmaMI1708ZSr5G
	vc9zzsxJ2ptt5fY9PfIEDXiWI1ZgDyLJU/NEYQWqeEOR9lr2pVDB81aZ4Zvn1UxRpFGS0M1J8UtVN
	3sqi06V9HfCgwmROQ4DFqEvYLQ94MF/jp7A/GzLqMbHA9QNvKn2HfemgMfABHo1zcrL+tATLQwKws
	E8PWiY0fb7H4BZWl+Hbhl0F/HpS3kps0Uhh6rWRO0Qe7bH9gtY+y3o/KMFTwHe6NLBzUacpNxWBTV
	8SVlXURg==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBY-00000005Mq9-1KoH;
	Mon, 13 Jan 2025 14:12:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/15] xfs: move in-memory buftarg handling out of _xfs_buf_ioapply
Date: Mon, 13 Jan 2025 15:12:12 +0100
Message-ID: <20250113141228.113714-9-hch@lst.de>
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

No I/O to apply for in-memory buffers, so skip the function call
entirely.  Clean up the b_io_error initialization logic to allow
for this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 02df4fde35b5..1e98fa812ba9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1604,12 +1604,6 @@ _xfs_buf_ioapply(
 	int		size;
 	int		i;
 
-	/*
-	 * Make sure we capture only current IO errors rather than stale errors
-	 * left over from previous use of the buffer (e.g. failed readahead).
-	 */
-	bp->b_error = 0;
-
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
 	} else {
@@ -1621,10 +1615,6 @@ _xfs_buf_ioapply(
 	/* we only use the buffer cache for meta-data */
 	op |= REQ_META;
 
-	/* in-memory targets are directly mapped, no IO required. */
-	if (xfs_buftarg_is_mem(bp->b_target))
-		return;
-
 	/*
 	 * Walk all the vectors issuing IO on them. Set up the initial offset
 	 * into the buffer and the desired IO size before we start -
@@ -1734,7 +1724,11 @@ xfs_buf_submit(
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
 
-	/* clear the internal error state to avoid spurious errors */
+	/*
+	 * Make sure we capture only current IO errors rather than stale errors
+	 * left over from previous use of the buffer (e.g. failed readahead).
+	 */
+	bp->b_error = 0;
 	bp->b_io_error = 0;
 
 	/*
@@ -1751,6 +1745,10 @@ xfs_buf_submit(
 		goto done;
 	}
 
+	/* In-memory targets are directly mapped, no I/O required. */
+	if (xfs_buftarg_is_mem(bp->b_target))
+		goto done;
+
 	_xfs_buf_ioapply(bp);
 
 done:
-- 
2.45.2

