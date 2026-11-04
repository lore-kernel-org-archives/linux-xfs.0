Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782813;
	b=diRTv2fEFj+eHselg+hKpE6w250TtVuuOzdrIFPGz4Y3kLCMas9ajtIZDmqZ2herGP7X
	 Qj9Lwwpvp+jEt1rZcijFNuy+Znk39NcKCang6VfcXRzYKyzI3Jj5LB8EfZOGpZWW2QJ4v
	 QI1Fh3nhPIZp8G2785GXlN/xAF+RYrW1fGvg9SKrHofk2fracpIs+T6QjjoubJbtaFvox
	 a3ma12uax7ejApBKMkW7NVsBfyS00LsGBRkhUT3pjY+yR48OugRFnk29tK7N9ibaKyYOh
	 cfAVWfGwR/rv8xIsniBkVmMvOdlQUqmqXlKrO0R8YAZ7WnIZyHGMGTWB3cOMfucfvQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782813;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=WbqJwU0qT6GMO96nsNcz3a3Er6iKi/Md014r9CMaIow=;
	b=3hpjye1zXvv8CnDdvawsgy1L2gFL+O5mv9ps35OPnXz5qajEJ7pGHJWzQWSODmF3nGQq
	 kK3FaEDpXxFQCJrnIriQLzvRpE//H+kRotcKI27ddZiiaPhWBs10dDsHXhE+BnB9pPtDA
	 3IhChRabFD5gMzlxlFlHSsfMVQmwKw8o9ZOZ6FIZE3dcnmFAYFGBMq2jeU9zf4c/o04lD
	 mt/9jHtYGD4cLl30tGWavBHfyb4h7kD+HbL7uMMv8pOjM+ktAo4W69gMavgFqRdrYMb4i
	 CuEvzY/td1rDIbMXiUFLZYisQNN4qCBwFFnl1IF8N6XCAXfcX9/2yJPXUxvz7Pn3jUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="S/l7Iz0v";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C3606A330;
	Wed,  4 Nov 2026 09:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A7C3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=S/l7Iz0v
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WbqJwU0qT6GMO96nsNcz3a3Er6iKi/Md014r9CMaIow=; b=S/l7Iz0vOdOg/094MnJIh09uau
	iNVQnR82Ybz7KGxVOR5DZKI7jGghAnXV3WT3DaNmvC91plxFfj5huOErovr93pejnE/rL71kSPe0z
	G+WFHKMEWQIBkupNYcJsgbdwPGVzFU4M0VWIN63InvEAEwvT6QERdeE7GE7GbKxoq0+/JHQkLL8bw
	RHQga1i/G3Scjd8Bs8vyRqeoi9plZo8XU11+ei1o+C0w3q6eIUKhQgKT16rpFfjIYBPfF7xmLvlV3
	7qQdbhQ7bEhbqbxkzl7THCfil8FWD2+5+xYd88z+sIRnrBu5FjDhdDoL+iTP4ENT7glkBRsa1M8KW
	luIqc2aQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOWqq-00000004oQP-2gb1;
	Wed, 04 Nov 2026 09:00:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 14/25] xfs: data checksums require stable writes
Date: Wed,  4 Nov 2026 09:57:18 +0100
Message-ID: <20261104085929.317544-15-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104085929.317544-1-hch@lst.de>
References: <20261104085929.317544-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Call mapping_set_stable_writes based on the data checksum flag
so that the page cache doesn't change data in-flight as that could
corrupt the checksum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_inode.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 56d5a670ba75..169208e1c7da 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -628,7 +628,8 @@ int	xfs_break_layouts(struct inode *inode, uint *iolock,
 
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

