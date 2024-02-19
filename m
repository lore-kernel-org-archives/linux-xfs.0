Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3237200AB
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324096; cv=none; b=d9IirEbf/WEbBuKQx61jz0rweB2zT5Y0ED13BWylg/5Ynmhp29ikdefYt1Ht2f1kd8sCvxZekznMbitu07yk2cNnRj4mY5a4kjunrb9JVSVexhex5f5FTn/xWAnsGknHZK5TvSqpC5hD9oZlDraHIpc6yXoi04btYnN2tfnZdLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324096; c=relaxed/simple;
	bh=fW3amsgJ72Pk0AZUtNdUzvZkBYDdmK4uYJv1DDYZyW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HBzTEdxv4JvJlg6cQKxTn3my8WdaXfv6YVcJGaF+aV+JJ5++3pcDbPr7rb5YGX3T1gN+LbyoZU0hXr1keCCsvvt8QmPMocQUBs8kHe4MrPeUChble7W4zVkZJZAgvqLIJq/RDN77gpUQZ0UhEya3lbBg2I0tELkeKvBPYBJyDlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o+Gm8DCz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o+Gm8DCz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YwCZytasSWWNAnywFhe0IpFtb/e1jDVoRPLD3Ievb94=; b=o+Gm8DCzOqtOIMlnlZaWx5DX2/
	gP41wxs2zHwXQvYLkhZzxFYkT/0dNYjnWGNp28ysgK2FfUm6CDOQheVeZTCjfyTkEa27UuTCPl4fH
	qT0jQvGScWH6Ru5uylqx2IptuLIaOa5jhmQ02BXvkUAsPWue2a01IztRuk+Ujq9hSGe0kdA1J1ute
	s7PTOXU2qhIJuyE/ODerqw90G3UVHsqRVE7hkMu6lrOiuutIBIbj5v1OOvSJT5500TZR6hfflADpM
	ZuzmgF4QFjiDKkcxgwrEc6yN651dX+tUeHWTDkzNtH98zMFGvMyoxebCqPOZgd52O0LqWKLjhkKJ7
	Ua+6RXtw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx8P-00000009FOL-34gs;
	Mon, 19 Feb 2024 06:28:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 20/22] xfs: fix a comment in xfarray.c
Date: Mon, 19 Feb 2024 07:27:28 +0100
Message-Id: <20240219062730.3031391-21-hch@lst.de>
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

xfiles are shmem files, not memfds.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index 82b2a35a8e8630..379e1db22269c7 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -16,7 +16,7 @@
  * Large Arrays of Fixed-Size Records
  * ==================================
  *
- * This memory array uses an xfile (which itself is a memfd "file") to store
+ * This memory array uses an xfile (which itself is a shmem file) to store
  * large numbers of fixed-size records in memory that can be paged out.  This
  * puts less stress on the memory reclaim algorithms during an online repair
  * because we don't have to pin so much memory.  However, array access is less
-- 
2.39.2

