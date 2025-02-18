Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE7B1EB1A6
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866405; cv=none; b=cS614yR6iHOJQJStf7p1YPTlKcnzY6CIOYn6e/P7zGX1FUDWopstI3Hnl5QctmzOx+L94lL56CTcAFziUjiUCzZj/TTrr/uLX00qa1AdG8WQpLQSQYMnnePg6PXN3VhYU9Imp3BUDYKkrcaRanIklleZpR2+g+bo90wXOugxVr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866405; c=relaxed/simple;
	bh=PGWouvOc+gNSjvkA/eobUYaxS0puzpHDHCbA9qqc37M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGw4+neiYL9bwOmxT7UGgfSWxFJGcmMhb63DqUd4sgGiVp6A+gsI7jmih2HFMw1SVjN9HIR2Xshl3d0KlnXtRsTnyENCxdahqAkgpP+ctf289eqBNv9/6WNNbdy80S9rHFyuiVoxJnZFpwLsBbzF9oCHa7gXwxFhr2CpcciS/rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FJ9OBmN9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FJ9OBmN9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X0r8qJOozTQt+ER+SF3X9ToR28Keovm1zv4WwyV2nho=; b=FJ9OBmN9W9HKt/q3YZ+6rru2EI
	AEkrWgjuCCCCLamOS5CDXeaLIs2AfQyPfx5LzDuJBa4ITcW04REAhKETZ94p9PHerpFvMAF/+jnb7
	KxvXcgW/wrlzWYeC4Ie+TkKTbh8VGgZJRnno3C/rPTKtE0JgCl0Ix8uXsCTy8eUo0FbXPgFgqPQIK
	vJPWQ3xUC14uIcwwLiOIlOWbt0BDRA8LwT7wK18kwNzoUYv2LcMpH9Od8eZa/d4b0+0mNzAop7Kgc
	5ipWK2ARnUSOJodUf750ZFcAbLFKI5VQDfAdbfpIxNxqhPJJFdKJ7B6nNKfIOR/akG8R/CQ6gKKIk
	Q9xDUp7A==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIjL-00000007Chn-3vpA;
	Tue, 18 Feb 2025 08:13:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/45] xfs: hide reserved RT blocks from statfs
Date: Tue, 18 Feb 2025 09:10:33 +0100
Message-ID: <20250218081153.3889537-31-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File systems with a zoned RT device have a large number of reserved
blocks that are required for garbage collection, and which can't be
filled with user data.  Exclude them from the available blocks reported
through stat(v)fs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 39b2bad67fcd..b6426f5c8b51 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -869,7 +869,8 @@ xfs_statfs_rt(
 {
 	st->f_bfree = xfs_rtbxlen_to_blen(mp,
 			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
-	st->f_blocks = mp->m_sb.sb_rblocks;
+	st->f_blocks = mp->m_sb.sb_rblocks - xfs_rtbxlen_to_blen(mp,
+			mp->m_free[XC_FREE_RTEXTENTS].res_total);
 }
 
 static void
-- 
2.45.2

