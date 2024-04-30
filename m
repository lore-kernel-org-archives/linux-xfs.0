Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57B017109A
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481770; cv=none; b=hn6Mk3AGomJO/dkPUw7HLfZlsRsWZU4qe84DKvunoyaEFkXItnmQN59+X4GQeirUni+5Ce2Ru1H+2qv7op1YVNeyjnH/TWNEwh6XlwxVVJc+jClkuJ97C1QCkBMxXDLApVWtqvUFK+aSmyIdZsbliXokFSX6cM/iUtZEOSz/hQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481770; c=relaxed/simple;
	bh=u9jN2T2UmKIhVxk0IIY6JFnSHPeAIMbdBhQiCcZvpf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sE1BD8I3U28H8ZmtPwyIk6juJ54upkwODQkHAa6YB8Ax8M/HqpVGQK12r58hsamSpJxgmPyQ/6eOjUO16Baoacud6aheSiVILNkVwhpanok0nIIBZxb7lcIA5QBPNXiiuwwVaFmmMX7IoQSrHOLTN4pa97ko8RDtTu0f5fTw25Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WVU0mnZ7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WVU0mnZ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nDwzJg3C8OKHOxtNVCKkVR2HE1MqYvQ10xvM4HfE/Es=; b=WVU0mnZ7ZbyYsi5Zd+zm/mx5CN
	SnhFes9KHgxjr6oc7Hd6qbsNEb5ntQVfqwtNIoTeQOc+lJk1M9ToJxD388dZytudkbetGc479Zpzs
	GgC/TgqnVpe0cPKO1O7b67zwFUnVq8dVZ8nMeb/6fA6n4Rg1UmVNni/RXqYI766lqTzbrtG6e3jOh
	S3/GrCUu1r+qmUhteaWanIA+8tHekFCjX38bCz2Vl3pUk+T09opTMVF0+U98v9nvdaEb4u01L7DWO
	9biugDw5qbvS06BSfc9cCelvhSWQVzN66eRYgHz4SS2m8Jj0Ipt0YvZL+UrTWORcZj7SGUqVOK9uu
	BEvJFG4g==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n1k-00000006P4r-0Hz9;
	Tue, 30 Apr 2024 12:56:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: upgrade the extent counters in xfs_reflink_end_cow_extent later
Date: Tue, 30 Apr 2024 14:56:00 +0200
Message-Id: <20240430125602.1776108-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430125602.1776108-1-hch@lst.de>
References: <20240430125602.1776108-1-hch@lst.de>
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

