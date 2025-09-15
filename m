Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE66313539
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 13:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757942834; cv=none; b=B0w4BRnewaBk0ivclc4u93Pi72fb9Tz+8LbOBK0wIJm+DLOnw+GCOAmSBc9J+w6CcU9bhjdgNNXWTSW6lSk9UneOoY/sOBROqr3qja4viYOlQ33iFE+wqGaDgRE0wOlKjF0i2P+WHtxfFYny9hyndZRUrXAJIWve3yGkRA47TD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757942834; c=relaxed/simple;
	bh=IqpDv0GLjbRXsjjyoriYx+warz4oUIxQLqQqdlo8rOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2WsAeUaZAZj5hwo4boU5GpyDT97VqidEmATKEo64wEZx0BeYwue8G7GnUClo0Qqj/wIblUeQiXcutqLsxwUKsup+BCMPCmOGIWBZwjdaGSY+7GzSKbHH+g1Mdv+5dvSBfk5P7/tAyKwNEoJw9782EpQvoAi9SHXOEz3c2zlF7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3zBvZ66G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3zBvZ66G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T8JLxA2U7kuHXZ1vfjzijMzb33SZUYm/HymkX5AFjkc=; b=3zBvZ66GJO5/TaR4AHMwZ3Z28a
	R+B1OeHlpBQgY2xN0b4Pxa0frPEqIRZ1OejP9aMr7cNpZNyq3k7KkdSxZCZZWXj6lRpDtsdlZCtms
	CWLqhpLd6ghvPxlY07VAHidKkhpAcCw5HDVBwZRNu+IgJPZOUU9PLJNgARPZ2zu3KUeZs+2hi6B0F
	gs5U6Mtcqer1iuXW/DrSpsBOFL3hnUr82jcxqbaf4WdHqGU08SCQBkDYgdoJLX6BZwQFCYa8DqyTF
	m+9PHQoKvwPGpuEdRdL3fObG31OYorTdG9xQ6Wmazfy/ywmCRbMyniA8TirkyA82bN5F2wtopC/K9
	r1u/VHJA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy9Ed-00000004JbT-3xMt;
	Mon, 15 Sep 2025 13:27:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/15] xfs: remove the unused xfs_efd_log_format_32_t typedef
Date: Mon, 15 Sep 2025 06:27:00 -0700
Message-ID: <20250915132709.160247-11-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915132709.160247-1-hch@lst.de>
References: <20250915132709.160247-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index bb06c48e0513..214c3a6d9683 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -693,13 +693,13 @@ xfs_efd_log_format_sizeof(
 			nr * sizeof(struct xfs_extent);
 }
 
-typedef struct xfs_efd_log_format_32 {
+struct xfs_efd_log_format_32 {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent_32	efd_extents[];	/* array of extents freed */
-} __attribute__((packed)) xfs_efd_log_format_32_t;
+} __attribute__((packed));
 
 static inline size_t
 xfs_efd_log_format32_sizeof(
-- 
2.47.2

