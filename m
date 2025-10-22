Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA7D3064BB
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123162; cv=none; b=F3rXSLiUE3Vk89Oj1ifxJ6aj9ZkUtvrSJfCbsiBywdFmHa+LbO+fMMDHAwspKiTSvhKOlQ30I+8kFEcpphJN19rfzCes/pJNH8DJBRsey9UPQ5Ik7X3l9o1OiZO5a8qAieE3XDtoh29FnzhmJxLmWNscuGgaRLcj/4C7JZnkrwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123162; c=relaxed/simple;
	bh=dQtiooYjfIvw3bEhZqyWi+GSs58mV/bZ20xkhV3Ub0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxQOwgdU4e1YPIRKLbJgQy/fnQchJEinRxXRo5MDIXYK+OG7/JppDdAofgq+29lvUbU+WkPx92UYHtLr6UWhW0xiSwEQlhsUNt2Qwk7A4uR6yuXO4wEiuUVNdWrnszmYmf8JLFK5soTUcsQ6WBJywrd/y/QNiqF0ut6xtv1gjXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PceG/gk8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PceG/gk8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1gxFdTpfGjuhyjLlNGrfr8WYOrmx3GH3HC82ma2Ydj4=; b=PceG/gk84dghxE/LFCH8xImLS9
	BKxloMk4jqtarUWiye93M8Xkv+wVihpyRgMpbTk+9yNMd5jw794CHQOHtaQcmp0PXtPHTBk3qIUGW
	xnTMBVyOTZoIfl63LQvesScJr5AzKz06g7+AdpXPaUnje9DCnGxf3GfojXBxzXLRVCLpmrEgzPO42
	jvIND02SbB6PqTwa761wJw3dE8RcKASs//1nYkFICx0HohJygokfq7mXBnCq3O1A9RSR+8gL1oNJw
	fpc5/wJojrWugRo+PgcQZGLnGt8i741HWIxqvWBk5mXzr1tDiFmV7RkRkbwE8NCH4I0nNeEqSZRm6
	dQFvGXCw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBUaF-000000029Rs-34YB;
	Wed, 22 Oct 2025 08:52:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs_copy: improve the error message when mkfs is in progress
Date: Wed, 22 Oct 2025 10:52:03 +0200
Message-ID: <20251022085232.2151491-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022085232.2151491-1-hch@lst.de>
References: <20251022085232.2151491-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Indicate the correct reason for the failure instead of the same
message as for the generic error condition just above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 07957e007812..3ba9a07e4469 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -759,7 +759,7 @@ main(int argc, char **argv)
 			"%s: Aborting.\n"), progname, source_name, progname);
 		exit(1);
 	} else if (mp->m_sb.sb_inprogress)  {
-		do_log(_("%s %s filesystem failed to initialize\n"
+		do_log(_("%s mkfs for %s filesystem still in progress\n"
 			"%s: Aborting.\n"), progname, source_name, progname);
 		exit(1);
 	} else if (mp->m_sb.sb_logstart == 0)  {
-- 
2.47.3

