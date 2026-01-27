Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ECE2FE598
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769529993; cv=none; b=cr7QlCm4pSx30yZe8WIx55XoPu+jVb1mNI5r6tsvOsmrVS6rdUiernZVxsl1i8ZgpDa6R5ov2BsTkUf/MPWUAtTyBUqVFybZCbkEQCl+zD/ByxKoswU6UWUdANSxjBR0B/LvUjBkcjXwF2n1LSxT+B9NSbJT/Ep/zITOdfmx3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769529993; c=relaxed/simple;
	bh=QVo8plLk25BC3KEx/qpEyxtyvgE/PyMMIUdlAUBZj/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbcWrXa8+pg5ToWacv5nKi5NQty5rp/whRVsdyUwLzp2Gp6GLAFXdudbovUF7xooQVKY3QP1xZZMhLbnO1/S+578GKNrbzpY18gDek1DyuN2/q7OQw2zvzg4+1dsycqK5lIeU555ncw7g34Nzc/RWttItcqkkHeVkFSC+Pr4If8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=5F73RvKT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="5F73RvKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UUmwp0n/E34T+BAX2W1JyqeSkGHAtSqnR4Z2rK37tx8=; b=5F73RvKTyl++QRVNpnAxXIkpsj
	X9QDtnlLH2IMapJ2sfW6wRPskk6dlT6w6l4QliNb25P8I5KHoCO+m7/Ecpasv58d6uP93xLgldu7e
	YZ0FlYAiX0sytxDxlJLnVbKqja8K8w4NVEBddJbUVduF8QTq3CT0tTXr2m4Ol+fOwaI9vlrdyvy6c
	3MXdXH/fcdC7fO0k6HTZLESHEfORYbGY3Pk9uSvK9I2YeeI3hxiDWfXhyBTuZpi6W+cqzmuaz4HDg
	mdmYn1GmgdbihVu4dU0/29GxNvMQ71w6F0nDL+PceZsCZr4YawRymcf4IdHIivMy3Jos3D8BS5Oql
	H9hym4gw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vklaH-0000000Ebjv-0sVi;
	Tue, 27 Jan 2026 16:06:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: fix the errno sign for the xfs_errortag_{add,clearall} stubs
Date: Tue, 27 Jan 2026 17:05:41 +0100
Message-ID: <20260127160619.330250-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260127160619.330250-1-hch@lst.de>
References: <20260127160619.330250-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All errno values should be negative in the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_error.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index fe6a71bbe9cd..3a78c8dfaec8 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -60,8 +60,8 @@ int xfs_errortag_clearall(struct xfs_mount *mp);
 #define xfs_errortag_del(mp)
 #define XFS_TEST_ERROR(mp, tag)			(false)
 #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
-#define xfs_errortag_add(mp, tag)		(ENOSYS)
-#define xfs_errortag_clearall(mp)		(ENOSYS)
+#define xfs_errortag_add(mp, tag)		(-ENOSYS)
+#define xfs_errortag_clearall(mp)		(-ENOSYS)
 #endif /* DEBUG */
 
 /*
-- 
2.47.3

