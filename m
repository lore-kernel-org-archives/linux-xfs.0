Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B426A2904
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585168; cv=none; b=iVlM8eXVyu/GQZqXWsJIEuSI8D9hRILf5UpquQP+T3iotFsKwIgmWMiBIW5wlSAUziVKIvWe5wMBmObElbPWDt8Y/u7qh1JmpLIVdC+sJBSXJumCxLVbgsH2xKeDx6Ew+DH8HrgSjWhwZgJrXwYrNzBjRogwBgXA6+iTA8UgNns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585168; c=relaxed/simple;
	bh=g5ZUMDPL8d2nAHuRJu4E/1Rkyt2Oa79ZeWrJFDh4irk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnuJf2u3CJJH2u4nOtt/ilbRZTuXOWxJscOJKDoEQzZF2ZLjdornbeM8p8Z6xPlSc2713FhZ+K68nXPI/5FDqck294O4fCb9VsXmBmHlVwOZtpvZk7NtDVx6MJutqv1k3JvIA1Zbi2kvoc11pebwQaTH3+aKva39gFZpkzdIBd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w8NbQxG4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w8NbQxG4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m2gYjj+3U9OXtS4ZNoUQ7oKb5ux5M58U4foc4dj6K6o=; b=w8NbQxG4bLKPah7qBAP5X7ofjG
	Peqko5WVDdUdZVwyBhqnaLHlRyuGKxpKJBWosY3YhsVSyzdkpN4pXJl69AbScV2IdGxeRT2AQFNPy
	gMOP8VnPGZuF9y/hC8wWO1V7GSUrsr9wuq0NmAJCFdD5r3fqenDoYE98zmEKJMlRdt/WUbORHL5Ve
	QSF/z7Vb2HtecpZ7apoitTXVtSmR+FFloPj8WmsgxL9USiyb6Ch4xcW25K9BkCGmyHFvj4CPaDZpf
	kfmK5EYzti50gUAplXEboKhCrVRIuz2BWyPQilTwgTP/5t6PsU9bSMi5KTq4uQGuXU2rY8tyAncEN
	V5HeCfKw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PLk-0xKi;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: remove xfs_buf.b_offset
Date: Wed, 26 Feb 2025 07:51:31 -0800
Message-ID: <20250226155245.513494-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

b_offset is only set for slab backed buffers and always set to
offset_in_page(bp->b_addr), which can be done just as easily in the only
user of b_offset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 3 +--
 fs/xfs/xfs_buf.h | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9e0c64511936..ee678e13d9bd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -336,7 +336,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_offset = offset_in_page(bp->b_addr);
 	bp->b_pages = bp->b_page_array;
 	bp->b_pages[0] = kmem_to_page(bp->b_addr);
 	bp->b_page_count = 1;
@@ -1528,7 +1527,7 @@ xfs_buf_submit_bio(
 
 	if (bp->b_flags & _XBF_KMEM) {
 		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
-				bp->b_offset);
+				offset_in_page(bp->b_addr));
 	} else {
 		for (p = 0; p < bp->b_page_count; p++)
 			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 3b4ed42e11c0..dc41b617b067 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -197,8 +197,6 @@ struct xfs_buf {
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
 	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset of b_addr,
-						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
 	void			(*b_iodone)(struct xfs_buf *bp);
 
-- 
2.45.2

