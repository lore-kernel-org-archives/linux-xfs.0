Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527D2271449
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582353; cv=none; b=OJYyH2V8c66MILVDapX+7tgDfSZnt3IAQAdiwNXSFLUQ8Vgv0ndiziX/YiTMv5QIjd0ooESlYxyIz0pcz7u8Ax2vn9K2QLLB2L3EgvpBKcsJoloPc4liUBAG3x2J6SN+6WxlkiFpvqEIOtQUuUk8vxveUtShHp24eqbojkYImvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582353; c=relaxed/simple;
	bh=J6CmqcpLATlN9eTSb871btSCOxBEl9E6GfU6NA01syc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKxJXyV2nM/SYdere0TDPFl7LKct2G/7lItB20DE3NJ8xvk+UB02ShseHRRtUbF+rZb9RCG9dtWYktsu4A8IUJv1RRpIxlUlwQ1a+jgLtqRtZi8gsnMLq7bjTU58rD4XH3Flzw028TuRjHJEmhBqq9P1MyBGZ1MoPS/LKW8w4IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=y5cWVLDl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y5cWVLDl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8UHqYQHI9lViq5M5k6IeEVXkxfRrDS/gMDO7zvAdJ6M=; b=y5cWVLDlT4tzcxQ7P0OUx1CKTF
	ZxffhKALXeKSQ2la2UEZz+TChLINEnAkRtcer2WWyqgKIuzAAuApAeO8FQcA8Mo530un4obbNOljx
	XRmWUxRXkqb1aAcX/66iXQPYsdABPiIRYduDZRNvVl0+7rzQkjJc/8j02lhljNxm9Wygw0eTOa5jS
	siVq16+cMbmB9awUtFyRnqCavM4NqJDFiSKCtjMRG2xN72+8jJKHVfc/V5bJ1tfqMkScpNtyeqi5q
	3Q392dGMrCGFfTk0tmJ3XKkt55XnZoWjwbyHqnFpWYKjW+0N8AqWCQxar0h1WCKGfbPGvDF5L8iFo
	UVXTfYYg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejH-000000053xz-2k8j;
	Tue, 15 Jul 2025 12:25:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
Date: Tue, 15 Jul 2025 14:25:34 +0200
Message-ID: <20250715122544.1943403-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of duplicating the empty transacaction reservation
definition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b4a07af513ba..8b15bfe68774 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1163,14 +1163,13 @@ xfs_trans_reserve_more_inode(
 	unsigned int		rblocks,
 	bool			force_quota)
 {
-	struct xfs_trans_res	resv = { };
 	struct xfs_mount	*mp = ip->i_mount;
 	unsigned int		rtx = xfs_extlen_to_rtxlen(mp, rblocks);
 	int			error;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve(tp, &resv, dblocks, rtx);
+	error = xfs_trans_reserve_more(tp, dblocks, rtx);
 	if (error)
 		return error;
 
-- 
2.47.2

