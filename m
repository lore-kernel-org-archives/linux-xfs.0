Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E045D91C;
	Thu, 24 Sep 2026 10:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244113; cv=none; b=FkgYVGkWMEWU/OJa26sImvAc18AZ43FfLI3+obBS8pPTSO0ebHNS2i7+ZcrwTecYC77zqzpzA3afWEsqrFKpR3pXXaIxcT7PhRJs+YVlhqOk50Se7C1JPEj1G3pqH818m0f5LZw45wFLQJU8Tj5qGmI76Z6fr91AvYEUTXQFH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244113; c=relaxed/simple;
	bh=9YZdIEYi7Bjb1LiFWfJS/mO28GEJcxSgDZqi5iGbq1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUEi4b2mN/Eg7BFFHxVWIf/WP2kBpc19XM5ZmvoMXShgEzOQarwaG1mQwdtRtkh3nFzDGpdqXdDXW9FbhybtxeHztzkdBe0k6E6zKZEeOEdaOCLBOAeSvLHZSZ1TAYzT5QUl7qfVRPZbfEYL8t8JsKG/UR1ZHd8+FF/rFeQ85Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CRgtZ8xr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CRgtZ8xr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+o4iaDZWKV4nmgNqPTbUeAZMo0alTw3VvIFgNrYnanQ=; b=CRgtZ8xrpqW3oOluvKeX8GR420
	phliWmDnIopI5xfHeHr3/JI97ZTmYaO/LHQy030g/4K3/Ou2wV7WU7a3IO3Rpu1WeOF/DjwgEEyVX
	hIzXZ7IuxEwh3+M2Rsv6zas/BnO5STlUF/so/hW8upZvZPocjU2Eyo4DnpO+oU+id/dFsKVQRtL8e
	wDozmbdJYYCe2YFzXQ9am2ml7CKzaE7VSPXAcWEFCoasokYrn07pGuJhc7nUELY8KqL+7PhtL8hN9
	l9qVb3+rO+PxF2WyUSbXbBjj4XUOqynEh73XVBhpzvSfTNftk+hmVGb5N011EbDSjXub+opmcbZr+
	vo/EhqZA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gGv-0000000AebU-3vRA;
	Thu, 24 Sep 2026 10:01:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 12/21] xfs: data checksums require stable writes
Date: Thu, 24 Sep 2026 11:59:44 +0200
Message-ID: <20260924100032.2733101-13-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Call mapping_set_stable_writes based on the data checksum flag
so that the page cache doesn't change data in-flight as that could
corrupt the checksum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9ed2fbfe86ff..72582ea9afcc 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -619,7 +619,8 @@ int	xfs_break_layouts(struct inode *inode, uint *iolock,
 
 static inline void xfs_update_stable_writes(struct xfs_inode *ip)
 {
-	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+	if (xfs_is_rtcsum_inode(ip) ||
+	    bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
 		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
 	else
 		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
-- 
2.53.0

