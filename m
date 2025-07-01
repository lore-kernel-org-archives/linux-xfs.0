Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111C826D4D4
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366498; cv=none; b=g110zBQ9B7UJiFBPFIybpc+t1hGTWFX1wsMd+MYfU3UWUK3W73fSWi0bSzFtrwAFkgO34EUGCZB7DsLgITEFOqGrW77cXsHZyafE0X+SV/+135TYaYqWd1jJ2KCfqUDKjVWcVmydlk93qNOvE9Q4HnMi7WBfnEH0hiYru6hd6Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366498; c=relaxed/simple;
	bh=Gmr1qtromupbhoZmjAp5f/nqDI1P8IM7CongXS+L3EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBNjeX4UIsi2p/WkC4tZaQa+GJHFem9hKn5sYTMDUVyJUT1i8Xhb99pHJ3NRKJsRHFUFUZMrCPEssgGguT0S7Qti5VOusYfomBjFAcpBnaTMga8XNmvBdaxXkTaNqgARYeWpR7mnR4nroHVQ2EMhZnhsQ+2otLypyheg2JmCadY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lQVZkxuF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lQVZkxuF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dpegKz5Dk7F3JIFsqtGWirw1joASeWFKo7mHlQ0un98=; b=lQVZkxuFDdaeLUW9xGU0ps5/tE
	mxp6HKzzLGdNUb+3tkErGY1kMEr47egtjtI1ivWUBA5FDjxYbXBwAw3DY87xJyeFpOJSSbJHfuHpZ
	GUzBGZxB6NIdvK905Mvm17FFpIwm8yzQZsfEKJBsYxbUZ9A6fnvwfd6cquE6sXWpNg4m0bGwF/7E6
	fWS89XmtGGsUvQvBUZNIq7AW343U0l3XaYuP/GkWM4iNB/4H8p+swfMwm+o9ShhZBuuBpQqATr86f
	46w6wR+NwEIqjeTYyhZ9bLSjqGhfqXY7Bh0TpcDqNQYL/TP12AWPWlkvtYsmtrBEPNBRXYjVV1Lsh
	IA2kKXtA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQi-00000004lzD-0AnN;
	Tue, 01 Jul 2025 10:41:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: remove the call to sync_blockdev in xfs_configure_buftarg
Date: Tue,  1 Jul 2025 12:40:36 +0200
Message-ID: <20250701104125.1681798-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250701104125.1681798-1-hch@lst.de>
References: <20250701104125.1681798-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This extra call is no needed as xfs_alloc_buftarg already calls
sync_blockdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ba5bd6031ece..7a05310da895 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1744,8 +1744,7 @@ xfs_configure_buftarg(
 	 */
 	if (bdev_can_atomic_write(btp->bt_bdev))
 		xfs_configure_buftarg_atomic_writes(btp);
-
-	return sync_blockdev(btp->bt_bdev);
+	return 0;
 }
 
 int
-- 
2.47.2

