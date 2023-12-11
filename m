Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2DXywiAa"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE798E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xfYS5IAAb5Z9BjR80UWwcw5amyUIpbEXaDiP826X58c=; b=2DXywiAajXRrxwpvYGXQZxbsQA
	NPBT7zAZIjd50Txddn6JA0YBVStv85OReofKs10ukXvVXk4qTiNl2zV4KUGv96/Ae+34HERNPuhbV
	fYHOaVj27p4pPHSAGPtPV7CIJj+hvEP68JZlH2Ap1v27L0BkgoQ2f/kXV86XxqYV/xdLP3fmg8ltF
	58dIak1O+oceoTVhzeZrA+cui/0XBLIKpKH+CJEKpJApj7JFAkazl5dK5S+e92y2i/+aUyltQow45
	DDS3wWxXac6y5w7A6JQvtYgfAiOsqNngXDqld+CDsiOFhyBHXrX0ZNT3t88hQAzWTqXoLw8DrudF1
	MCaBmxrw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIo-005tO0-2p;
	Mon, 11 Dec 2023 16:38:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 20/23] libxfs: pass the device fd to discard_blocks
Date: Mon, 11 Dec 2023 17:37:39 +0100
Message-Id: <20231211163742.837427-21-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No need to do a dev_t to fd lookup when the caller already has the fd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd5f4c8b6..01c6ce33b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1325,19 +1325,15 @@ done:
 }
 
 static void
-discard_blocks(dev_t dev, uint64_t nsectors, int quiet)
+discard_blocks(int fd, uint64_t nsectors, int quiet)
 {
-	int		fd;
 	uint64_t	offset = 0;
 	/* Discard the device 2G at a time */
 	const uint64_t	step = 2ULL << 30;
 	const uint64_t	count = BBTOB(nsectors);
 
-	fd = libxfs_device_to_fd(dev);
-	if (fd <= 0)
-		return;
-
-	/* The block discarding happens in smaller batches so it can be
+	/*
+	 * The block discarding happens in smaller batches so it can be
 	 * interrupted prematurely
 	 */
 	while (offset < count) {
@@ -2875,11 +2871,11 @@ discard_devices(
 	 */
 
 	if (!xi->disfile)
-		discard_blocks(xi->ddev, xi->dsize, quiet);
+		discard_blocks(xi->dfd, xi->dsize, quiet);
 	if (xi->rtdev && !xi->risfile)
-		discard_blocks(xi->rtdev, xi->rtsize, quiet);
+		discard_blocks(xi->rtfd, xi->rtsize, quiet);
 	if (xi->logdev && xi->logdev != xi->ddev && !xi->lisfile)
-		discard_blocks(xi->logdev, xi->logBBsize, quiet);
+		discard_blocks(xi->logfd, xi->logBBsize, quiet);
 }
 
 static void
-- 
2.39.2

