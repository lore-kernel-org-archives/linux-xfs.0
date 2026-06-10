Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C888B3644CF;
	Wed, 10 Jun 2026 05:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068012; cv=none; b=sW2NCmnbuVO0Nojhq0jS+szE4wluAhpOCsp3aqHudWHpbCHf9rta5b0MEqh2NDPYIOU8YYYl0ZgAYpD3u3Y6mbemnmTenwUXXjPpWNyEJ3PBXGB/FJK4nKNjIqQa6ipxLKb25Pa8ATec7u0KmfI+WnWjwn/Z7RtYl8NTbqomCJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068012; c=relaxed/simple;
	bh=c8ovQH4aHy9vKB9NqBpiCjK2G6mBcBJh1WABdh00AZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IuC4ZxU8bI/tteiHYj2FrGZY1JLTH1uYc328xbHAg67QXw0o6X2jloQbrmLWbBkFa7YySX6S3EfuuMiEdjdoDGxRPR4Hbw67X4Xc0DUdl9DkjG9Z7XLHSj6ZG50N4kSqZ+IBbegfHnKOOB0hGuozFAbB1BVD08dEWgSuF3zh7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FyHSTQ0f; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FyHSTQ0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qKT7cBZl24itlaRMk0gx2b8KhJCqdbYRIr2TNHxsnvQ=; b=FyHSTQ0fYcOVvMC+TVT57ueGhn
	Nv9SveejGcmVxAaLtRDzZ1IJVPj+0a/HrMcCw7+HltgGX4JX+sTOVwulwDHdqkeuuXg2L1KqyCw5H
	6QRQ9k29vMjOdqLbEvjVL6Nk3sx4izhYh7UR/iUVR2xSEWs0t2V47Cw8SNXCA450Xm/HyHVajHirc
	KP7Fk9PjbzPJRnhZs6BFGgK8D/cdcCW1FbUxYbGSjak+lqGR9xRdR1TNmhLjkDLjx4KnbwVuabmhT
	3M48EfTrbYU70uWXOzmgPadXdu6GXBnrEWcNBKc2pYqt1jpC4yZx2u2KojeBe2y3Ylh7/M9BtLdxV
	7LhTe/pg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXB9K-00000006nvU-46gP;
	Wed, 10 Jun 2026 05:06:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: brauner@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] iomap: pass the correct len to fserror_report_io in __iomap_write_begin
Date: Wed, 10 Jun 2026 07:06:42 +0200
Message-ID: <20260610050642.1906695-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

len is size of the (larger) write request, plen is the range for which
the read failed here.

Fixes: a9d573ee88af ("iomap: report file I/O errors to the VFS")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d7b648421a70..bcf4559e9aa7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -850,7 +850,7 @@ static int __iomap_write_begin(const struct iomap_iter *iter,
 			if (status < 0)
 				fserror_report_io(iter->inode,
 						  FSERR_BUFFERED_READ, pos,
-						  len, status, GFP_NOFS);
+						  plen, status, GFP_NOFS);
 			if (status)
 				return status;
 		}
-- 
2.53.0

