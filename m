Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86124DF5C
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366165; cv=none; b=nWFyuwQGtTzNvYlp2Gty7CFAug002cmXPCNOH/ykK5GZNieyhj3JxgpYdpDEdjYCkqFnUaOz/FC7Hqz/EMfnIZa/EhX5p2votxrMU+9wpPokJrMNlhZSnVgr4897Rp/iRlU2FD4CkKMMN/tWf0bBiXjrLovhaXjsCIxzWGPJ/T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366165; c=relaxed/simple;
	bh=hyqwHFHbv86aG7TC/mM7tiQGCYS78er9rosLv0r/UqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nYhB+XyWVeB73vTrKhVbu33Hf6xpWgWRQy1YN50q8Tiqr34/nsRz7tGdtrMy9UpwmV3wsWIzypINxzAneeQFOOLQbYwtWoO+mrPUTOvqyvpzog4T6vRTgGCiAi8QJZEM/lVFXcNR7hNcJ6RCHUNxXn7vQu7R4K1BpAxMO9sVjDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1fdq7nfN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1fdq7nfN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MvWGRRV8TV81ke+USUJL1Mv4KapVSNa6T5Jei/iZjhQ=; b=1fdq7nfNYYIvz691NQ+eleQPm8
	Ln+rPrm0ip+IyC2pLD8zI5if9KTIM64SGO8k3S+mGaFhddKvQXkulhzsq7UdV6OYRgsHZ0NB5OavZ
	qLGu2B+qwJJ3hvpeHctC8ZeS6rSA1mxI+8XiAoQ+5ZH7nBztZlF5zRYCEDwtBaX8qr7JENioYtWAb
	vI7ZbL74Nj8ZK7Ulg8aMlTJ7dKmSo9VGGfwuOd9twJY6XxmFjjROrgBcEe8ZBRPl4JMGvyn3vR1KD
	dFPzx9W+Jo7937oK+RH75woRO9fmGiVj1Q8had5luSNqA2AsJmlg7yUObSwGximcUoDzflsBywGam
	RK02+OOQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1Ix9-00000001S4j-2oeS;
	Mon, 29 Apr 2024 04:49:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: upgrade the extent counters in xfs_reflink_end_cow_extent later
Date: Mon, 29 Apr 2024 06:49:10 +0200
Message-Id: <20240429044917.1504566-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Defer the extent counter size upgrade until we know we're going to
modify the extent mapping.  This also defers dirtying the transaction
and will allow us safely back out later in the function in later
changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 7da0e8f961d351..9ce37d366534c3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -751,14 +751,6 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
-			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error)
-		goto out_cancel;
-
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
@@ -787,6 +779,14 @@ xfs_reflink_end_cow_extent(
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error == -EFBIG)
+		error = xfs_iext_count_upgrade(tp, ip,
+				XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
 	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
-- 
2.39.2

