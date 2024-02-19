Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D0200AE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324067; cv=none; b=swoci94Qr5HbO4Tm/WwcFmyrB5O/8fLUx7QX+mSj3+6ISUMxUhBqLUSToRgftYiGU0BUzI0slAmmtPWx0jCaHOtAFexpWg/YUhmA6S338JPK2pSuAyKUDcqbNQQKRlAuzafSWj6gjoo08ZntFyr8Bl/ndb0s4QYABdXKQlStbBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324067; c=relaxed/simple;
	bh=ZvNomL/XDlPXXgaYR+p2unmgsJ2T69280bz/Qw2xZZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fYtvwR6eBCD6JOSufgefiU00Z9FGslwPx2QsL72icHKvdyqg8ot2ihC63GUteW3jHJo8FMd86UIiK0aHelCUMvSwRYpbD6h0cVolSL5cqtbAhveY93uoVPo5sccM1Zz2S+uTlnOS+6WGy8bLyA/nVgXYdw4nMYYhFF4CGGgwang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JbpnhUX6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JbpnhUX6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ftDKzMVuY3mh1JqnX/Rx8Xv83eufPBpMko9jspRah50=; b=JbpnhUX69LwoqeuzXRfVNOyxr3
	VLnvzgUo9Ypk0zo8238UgQ6vfICjH4vDNnQCpwQRefMvGp0uDAXGaWAHAbZC+1WEuO2a6k2fanKSd
	jL8+gYpKnqRlDZC5HwiGiFa3uuieJZfufrOk7SkLxxoUVAO7ELa4Y+XbY6pD5ixXJZCFD1XvZ3zAW
	eE47JO9lmXug91a4BwMnepqo8+BX4SIzHTNLBzIoK7bq9vylGBHYN4rOINFERo0JxIWeGdo0gd8MW
	0C6GHu8TPjJd8k6U4r5Hz3Vm473yuSTPZOn9cLCnYbE0VDYyfkea/9qu6uoLdNoaLlahxrRtBLMbB
	9c7rvJgg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7w-00000009FB3-3GK2;
	Mon, 19 Feb 2024 06:27:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/22] xfs: use VM_NORESERVE in xfile_create
Date: Mon, 19 Feb 2024 07:27:16 +0100
Message-Id: <20240219062730.3031391-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfile_create creates a (potentially large) sparse file.  Pass
VM_NORESERVE to shmem_file_setup to not account for the entire file size
at file creation time.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/xfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 090c3ead43fdf1..1cf4b239bdbbd7 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -68,7 +68,7 @@ xfile_create(
 	if (!xf)
 		return -ENOMEM;
 
-	xf->file = shmem_file_setup(description, isize, 0);
+	xf->file = shmem_file_setup(description, isize, VM_NORESERVE);
 	if (!xf->file)
 		goto out_xfile;
 	if (IS_ERR(xf->file)) {
-- 
2.39.2

