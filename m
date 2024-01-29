Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA17153BDA
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538944; cv=none; b=WNLcCC6OABAu/mC1tmNFVr2/LuoJuhhqqdyF2URZM0Wh+3rMT0U2naefAHMQmTIF+gQ4ON0a/HfkuHOsImZcSuWT5dX1uRma7TqKbEwXFUbB1NYTgvARqi3nJen/bNxQEGDypVKfix0+BL65AE9mnyQnAbCLg/hZzqzOHjwxv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538944; c=relaxed/simple;
	bh=uDNZvIO3ymmNh8KpM65aczzQJycZuG5g6Z/O2czi7YE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rt2qnmWPl0xlkN+l+LzA91ckNFJu1JXQeVEvEHyKeD0nhxKkHFKwPN2r7gaskTtqZAoBfV7VZQK8n9RLbPbR7zLOJ1Gf0mLtDJ/9SudgohW3kc8tD/iopwYsn2MVLXOFFIr7YWeySNMOS7+s9Q686UBICfAY+iwGhWabH1W+nRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Nzpvnqy2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nzpvnqy2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5C9VP1SaExA9uyPFl5WPVHE4cTMuqE1mtuEvKQxBCh0=; b=Nzpvnqy25fBuewAn8a4fPzk8TC
	GpboyE4dwrfTM4LUihBf4GKSMM5SXJ3aU1ksr79KJPbn/xfAu5ODCCRb+cqcQmI1u3Hp2m1MO1ik9
	MWBRQnZdHLJNiVNjLfr8pTwJKhKZwlMDtu3hIPJZEj/W/xDB/RHV6QUlrHo0PNhqd3FCxhRtEpLNE
	NcVY+9aBGRDx9WDU9meX66LEF7x7v+FbhqwxA4YrRQwts6qpO1n9fDuFUjGfV/H0nmm336P2CCyc0
	Tr1iC8yW5cdnonXAubc2ZY7TlR9VcqBCMAJIVhFElv68l8C5ljn+4SxEB1oQXXnhOCvMKaMJYYRui
	C7kC1kEQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjd-0000000D6Hw-2zun;
	Mon, 29 Jan 2024 14:35:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/20] xfs: don't try to handle non-update pages in xfile_obj_load
Date: Mon, 29 Jan 2024 15:34:52 +0100
Message-Id: <20240129143502.189370-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_read_mapping_page_gfp always returns an uptodate page or an
ERR_PTR.  Remove the code that tries to handle a non-uptodate page.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index d65681372a7458..71c4102f3305fe 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -166,18 +166,14 @@ xfile_load(
 			goto advance;
 		}
 
-		if (PageUptodate(page)) {
-			/*
-			 * xfile pages must never be mapped into userspace, so
-			 * we skip the dcache flush.
-			 */
-			kaddr = kmap_local_page(page);
-			p = kaddr + offset_in_page(pos);
-			memcpy(buf, p, len);
-			kunmap_local(kaddr);
-		} else {
-			memset(buf, 0, len);
-		}
+		/*
+		 * xfile pages must never be mapped into userspace, so
+		 * we skip the dcache flush.
+		 */
+		kaddr = kmap_local_page(page);
+		p = kaddr + offset_in_page(pos);
+		memcpy(buf, p, len);
+		kunmap_local(kaddr);
 		put_page(page);
 
 advance:
-- 
2.39.2

