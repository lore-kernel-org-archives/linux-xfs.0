Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA181D094F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031413; cv=none; b=hjSRmUbIDqX4rWvifBMEXNVsE3ekx67h7lmn9ysC1mLSOz99OrHXdUBPbsPIZEcsgBHZ2hjrewjIi9R1UjpfCz9BGPERTa2iTuaoVQflkXWtnU4n7P4CjVWZc0dtwBKY7+9rQXvmPoNYFRARavRdDDAUsAeXPRTEVUGoUVoO1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031413; c=relaxed/simple;
	bh=6Rt7PZAvQiNXomYBaonnHcUBiWa8F8nkqfm4o4kPkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXdyVTFgCEJnOyp29wiIoePYJtH/VhUKn/I5xy56xglJzuDYEk1svK09Hpe2HIfVnE0gogrc20JWmu0myQfKcOyVOVpG7QQJGJTCJ7Ck08037DghI2A3Dg6gSGxH9smxwNoePrSXn0vLfvSHh30PcpIVUN26Ymbh+vVfAxmfsuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lqGj9lyr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lqGj9lyr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Jy0Bbc3Wjnh53NxE1H/n57FoMYwWI+PoahicBAr5DwQ=; b=lqGj9lyrYmKLRN6I6wletr1jeK
	IwKES88ZYPNfE8daO9XxatB5vOVWOhR/KOzwMNxoY5WzBq2F5YGOkURi6t8poAHh7b+VyyByvdBx4
	ZcSfy3Q72EllJf7AD2Zbu4OmSQDhiUJYoTwRzkb+ytv+IVAVAuDcC/kwCvLZSVDpc9QKZI/CZt+FS
	tIZ9xYITCwKKe7PukULRPBxUNVO8lvbB3OWZ/2OnYC3/2l1zquKPqcb1UlDT0V3QqSi6iYc2Z6zAA
	v3fg6t5VsUhYG52M32KxW1mtp0GhZDy2vByM9pPzqJs71XHMmqBN2U4uk9UgK0spwwDfdflX55fAB
	pTsRzH7w==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDQUV-0000000CvfX-0qJg;
	Tue, 19 Nov 2024 15:50:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
Date: Tue, 19 Nov 2024 16:49:49 +0100
Message-ID: <20241119154959.1302744-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119154959.1302744-1-hch@lst.de>
References: <20241119154959.1302744-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
which xfs_bmap_same_rtgroup doesn't make sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9052839305e2..5255f93bae31 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2620,8 +2620,7 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
@@ -2629,8 +2628,7 @@ xfs_bmap_add_extent_hole_delay(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
-- 
2.45.2

