Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F9513F01A
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588104; cv=none; b=ZjP6QooaURjxUuMlDu1h0j54w/CbJaQ9YhtOIflzymcNJG0hc86u0vIUFbQGC66PW11LOX0F8KuniP1LnmdYVcZFJYi9RT1YTbkFDSC6icCMM5WyW/Gmnsy0oR0eJfWieX9ykBo0ud03PA1WIVfNQQ0SXNyFfUkRtKvzzMV2bgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588104; c=relaxed/simple;
	bh=TauXa86uZLWxPuwcRp5wpjsgk9/7GG7U7gsZBeJXuRk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIjBgyOpDj0/OXuYbQ7FeZQMe+X/BBhesz4GykuaR9ooyyABiluDuqhW140sN8XuViJW9wia9L5v6bUN4jMYvIS7KlpmygFkSeQeA8ANUa9kAWPp93CKtjLea/nEIb8YvMp+FJ3WdIuF/cjQQHWpitsxF627dXT25NT5W2Sty8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NhzgcjKA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NhzgcjKA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=e4joLzzfdARgA+Fc4J1YWeTmKYgr/iyw31dmwKomEKs=; b=NhzgcjKAPqjZrv3scyN6YtUn+Y
	l1g3WtlJt6j7Hl2Vk3PbsTUAaDKZWDd+//i9sQVxDYuwc+3KRvFDo6mtgve0D2tGosIHGwC+ZeqdF
	Ddsx22DhCPcYundhzNz550oRotzCQUxKfNSnUgxPO0ZDQtU5gJl4q6x8yhPEbidng2KjBrfqFBtsc
	4E8di7FrI4Htb0Zkn7rqHkyaixamOhR5m+unsvSutjEbuEKJ0tbVcJOE24r6ZC591i96RRA1iaDBP
	pkXNVAeNEY3W7xmhnkvEu9BsUoSTOUav0rbKKq4x0qzZQ6UPYi19gGtEWvC/3MVti1M9PXrasMFeG
	CbeXfzQQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOk-0000000FwXM-0xbR;
	Mon, 08 Apr 2024 14:55:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 2/8] xfs: remove the unusued tmp_logflags variable in xfs_bmapi_allocate
Date: Mon,  8 Apr 2024 16:54:48 +0200
Message-Id: <20240408145454.718047-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408145454.718047-1-hch@lst.de>
References: <20240408145454.718047-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

tmp_logflags is initialized to 0 and then ORed into bma->logflags, which
isn't actually doing anything.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 14196d918865ba..a847159302703a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4191,7 +4191,6 @@ xfs_bmapi_allocate(
 	struct xfs_mount	*mp = bma->ip->i_mount;
 	int			whichfork = xfs_bmapi_whichfork(bma->flags);
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(bma->ip, whichfork);
-	int			tmp_logflags = 0;
 	int			error;
 
 	ASSERT(bma->length > 0);
@@ -4262,8 +4261,6 @@ xfs_bmapi_allocate(
 		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip,
 				whichfork, &bma->icur, &bma->cur, &bma->got,
 				&bma->logflags, bma->flags);
-
-	bma->logflags |= tmp_logflags;
 	if (error)
 		return error;
 
-- 
2.39.2

