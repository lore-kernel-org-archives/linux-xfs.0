Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9123ED5F
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777561; cv=none; b=qnXdmr92zQ3IBuzpCz8aD21Z2+i79SYIuCKGjm+Br3uKUdbMLa5/Mo8zQevWf3ckNE/TY6IR3wXU5xH5KWuWIMxoxeUhCuQ+FdScOEopU/cp650wTnFk1I2az0Id5wk6gj7Gdi1zgLYJXXVTMZgPU5ofW6j8nYhmkEsgNUz4GII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777561; c=relaxed/simple;
	bh=40J7BwS8IpjdFTj7AOP/rIb8F0IYDMNbusbJ/vTjxyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCkG8rhPwKrnjHg2YMEC4kjpHDg4Mj4wy7Ars1NvqWPPLQPgeBXtjnk6g8msYsJRfMmSh5xxbkcbqk0ilYri3JqysfpPdCjZH3iADaGO5HBpk0iTLTRTQOpYwTX2I0sxWEbrkvPe5q38aJKmuvLTM8CTFs0N6sXt4Y53Z1VHjX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fdu+EkUm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fdu+EkUm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2Skz5ovWZd+ScbpWddIn4Mtcx1iLz+cv9gvfRULsvwM=; b=fdu+EkUmxpQZZ6zax5RfOeKBFW
	MXSXHPQxYYCRQwL99nI6gRET2br27uN7k7Dj2MUa1SIXOrqGxfpNrcpsC7rnVfboHNPoQzHevO9Bd
	q/UuvUL8ZerXCKCE2QDp3z47CDvcEtrCtUMyeamUSD6XbwzToRRXzn8HTYY49M/fTo9lzLRlWAIfq
	HO5UIZBl8lXXqLi+CWkgl1Ia7NcFahQOvEqc0yZ3nlL+cqOJjTLJYfgnLBwVj2J4RUeOPn4Z3TweM
	ojxUDnNO9835wRbVVPZzV99aYzW5Qfm0DFEPT4YanPSXoTIdVOSnBGEDbhtbiyNAS7P/TJU0ci0fY
	mf5iGlEg==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBH-00000005Ml6-1RbG;
	Mon, 13 Jan 2025 14:12:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/15] xfs: remove the incorrect comment about the b_pag field
Date: Mon, 13 Jan 2025 15:12:07 +0100
Message-ID: <20250113141228.113714-4-hch@lst.de>
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

The rbtree root is long gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3d56bc7a35cc..da80399c7457 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -187,7 +187,7 @@ struct xfs_buf {
 	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
-	struct xfs_perag	*b_pag;		/* contains rbtree root */
+	struct xfs_perag	*b_pag;
 	struct xfs_mount	*b_mount;
 	struct xfs_buftarg	*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
-- 
2.45.2

