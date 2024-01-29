Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AC9153516
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538933; cv=none; b=WQ3qKeZaGm+25V/EjrUmFZUZssxL7dkY4abyLgNIX6SwXWIYWO5c+5ra7wnNLmy9rzEESJzekkIxWqKYmYoH0eepjR81DZ6zNeCP4oFkIQAw0CSJmULw8r2x4uTL2H2GRQTbpn6FhoDOKtZpnRcyMvCihBthW8N6u/l3Rg83KkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538933; c=relaxed/simple;
	bh=bEfsami9TvDj8R2JE6Jx/h17vh4vmuxRzPP9e77CI3U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AQn6wOTREQQKBTi6e8WzuZisERzkW3nMc3iSKpOyxgSNPB8HxUu2EkE2OUCWIkN1dmTsriVc0FFelw8rwDRg84MWROICdMPwStPRFBU7wQPt7Rw1D4uEIDhpwjiwL382VWO04AiIbHfjIk9O3KoQeFdyQ0XPxqeow92PUHpFOTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NAc8SZQ/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NAc8SZQ/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5+G//0oCp4joBCMNmSMB9VbToHmHFLOf7sf0e46phAg=; b=NAc8SZQ/n7VJjolfOO3ePhisGj
	W70pOrthIiUlTiGlJCc2choYOwhhXwIshN0f7q4Z4noncpkTT00521IukXLRtVMT6myqdaAOTkG4d
	10CzhEmZfzz6BSkWaZEoMpd7QtKZ4zNHLWiwHygIzzTj455ggTnkJVLHSyopIoiEzUYwm+ozPYih0
	1Gy3I5e0OYzhajFy+sG7wgnZ48jemInmyzfozXbJYILhbxo3dQUz0gSwrqflOPt7ez6HoC/AhekC9
	KHM8nm/Zs4nAGzT+dIAZumEbinj3Okbq0UKD2t2BWIxHhzQR4S/8ZfJsSREftO0p+Ou3ZVmdVwJse
	r9wxbILA==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjS-0000000D6D0-2Gci;
	Mon, 29 Jan 2024 14:35:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/20] shmem: document how to "persist" data when using shmem_*file_setup
Date: Mon, 29 Jan 2024 15:34:49 +0100
Message-Id: <20240129143502.189370-8-hch@lst.de>
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

Add a blurb that simply dirtying the folio will persist data for in-kernel
shmem files.  This is what most of the callers already do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 mm/shmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e89fb5eccb0c0a..f73dead491b11d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2148,6 +2148,10 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
  *
  * If this function returns a folio, it is returned with an increased refcount.
  *
+ * If the caller modifies data in the folio, it must call folio_mark_dirty()
+ * before unlocking the folio to ensure that the folio is not reclaimed.
+ * These is no need to reserve space before calling folio_mark_dirty().
+ *
  * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
  * and no folio was found at @index, or an ERR_PTR() otherwise.
  */
-- 
2.39.2

