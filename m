Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E839223775
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 07:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635243; cv=none; b=GYL60FEqL5cBM6Yz3isH9suPXfJJcmDgj0lxy8gUmZkSW5VcYhGNGiKux1P+xEW34vfbx6zMy6GkbqVacgUQqoRJNiEuqCdOPUN0GN3xGTIk/SbQLAWGp/7q/i6LHazb5Kn0UDCxtlLHM11UdFRY79/DVjAMCnnGm659i3besuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635243; c=relaxed/simple;
	bh=elGDpsFuBd5GfWsYmyTdfv9aCfYEl7y4wDuedxMOAl0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b2lDBJ0JviT1PkjAirToRdjTRHhYzO76PAW405JUhO1kGooDAMvsKXohVMhXV0n7fnG5km0LtZrvh6/E7hq+mI39irVEamCqf9kK03Pm4B2WgQSM28+gNOp8Sr6ZQFM21cmSzt5Usf83k6qUAP8EyJ9HXk5KtVvBnr+pBWUG4gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FkkgeTfn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FkkgeTfn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AzC4lwQFSJg2ROfYV9Wev0klJgyaEoXsxWv7t2ljo9g=; b=FkkgeTfn8iWjhgxb86Hzl0VvTy
	WCBPLE3ZCpqVD3b5qAKglVaD8aC6HHFArHZUUSbTIwzfmQRmd+CGHkuQPp41Gji1gd9/FY4tKUTfy
	qfGwhD+MEMtkpZ4ENbft/CBbim29ZvvMEotpfcYlPA9nT6P84MGsKEgrvu9f9fhDDPOvMALha/D7Y
	zlD+tcops6ROwrFzvMF5sdN0ntlabeTY4YMZ432FCE90nOwV1ie2axqwT07YFx65Bx26SLXFIzIPK
	zoUEiGT31pwv7XC/OqCI98jWy34vqMfmETpnSsR7e5avqQ20F50P+YcbXofRyup39jnfHNuXYrCAp
	j/QSs43Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2Qx7-0000000BojD-04hS;
	Thu, 02 May 2024 07:34:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: upgrade the extent counters in xfs_reflink_end_cow_extent later
Date: Thu,  2 May 2024 09:33:53 +0200
Message-Id: <20240502073355.1893587-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502073355.1893587-1-hch@lst.de>
References: <20240502073355.1893587-1-hch@lst.de>
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

Fixes: 4f86bb4b66c9 ("xfs: Conditionally upgrade existing inodes to use large extent counters")
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5ecb52a234becc..d6d5b65eb07fca 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -737,14 +737,6 @@ xfs_reflink_end_cow_extent(
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
@@ -773,6 +765,14 @@ xfs_reflink_end_cow_extent(
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

