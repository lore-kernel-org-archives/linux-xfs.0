Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622EB1B811
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 13:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706275802; cv=none; b=ntwq6anCeiUdrQf7PyBixyTdQHiYmscz6CUNeWO1bz8tMeBgfDwUWwtk+xgD9E/AXmL658sy5R4/wFNNqWIGl0tSAouBChu7PNN1Bd65Ro/LEvHNxds4Q9Dx0wZOwrzSUc8+FAXTWe7iJekwz8WJNDBifl5BUm0Kq6DubyIYyxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706275802; c=relaxed/simple;
	bh=gIM6UqsPpyVgE21NLi+MJWJ0av/j6HR+V0fU06QKbDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UMAGkAFW4DHeEY0DNyx1zz5v/ztYfyxXbqpDJ+h0ITZ4OPLwAgf/Y16TAXf9AxJbUzq9iWyDmQPCuN06ANIRGURV7TgnZ0UKD9ZXKU/lapHeJ1JBKxPUUXmvuWweRnEH7yiWmgUoGbzryB/JUqgn5UiDfMQoVpfM/lysLQvW3LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AW558L4X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AW558L4X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qe83DfTex1z7zqi4GxksjarNQRXeRN9ZyszbsgkFHtk=; b=AW558L4XK6tfao0hRtcKkesnKc
	1+cmXOPvdPSPSsWcDFZDhVYrJ4UbLVK+R1/TdWjTp3uU4x3N+G+ltc0EhC6Gq7wICZl1Z1QeKgGn1
	hj5vj/hQDdaD3WpT3CZl1U1au1iLqG8Y/g2jdB94h8SA9nrTRRWAzFgii9GNfFm9rAYA0kuNG6bZN
	Lpm1NgKVP0N6twIVeBtYP4xvgUyFTWP0VNSM6SEKKRl2MIObXbgMZmhoPm+twLDxH3wzjXlyWwWL3
	vkbkkSKgvbnZtLm7wQeXpfFSsH0YQFA/OLb3cNDWViJSDSMeE/IZG4mYYaVNTjohdHkKxuSydMRYl
	l7daPa9Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMHI-00000004Cnt-3lRH;
	Fri, 26 Jan 2024 13:30:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/21] xfs: shmem_file_setup can't return NULL
Date: Fri, 26 Jan 2024 14:28:53 +0100
Message-Id: <20240126132903.2700077-12-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240126132903.2700077-1-hch@lst.de>
References: <20240126132903.2700077-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_file_setup always returns a struct file pointer or an ERR_PTR,
so remove the code to check for a NULL return.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 71c4102f3305fe..7785afacf21809 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -62,15 +62,13 @@ xfile_create(
 {
 	struct inode		*inode;
 	struct xfile		*xf;
-	int			error = -ENOMEM;
+	int			error;
 
 	xf = kmalloc(sizeof(struct xfile), XCHK_GFP_FLAGS);
 	if (!xf)
 		return -ENOMEM;
 
 	xf->file = shmem_file_setup(description, isize, 0);
-	if (!xf->file)
-		goto out_xfile;
 	if (IS_ERR(xf->file)) {
 		error = PTR_ERR(xf->file);
 		goto out_xfile;
-- 
2.39.2

