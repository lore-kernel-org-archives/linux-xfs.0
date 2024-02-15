Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B4ABA37
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 06:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707980087; cv=none; b=tysE3GNJyqwuJ10BRvDd1LLsoYvyrusSjaA6FhnbQ6uq/aFM6IYH1HaxPfOCBjsJ86ALfMWb/rtvn/x2r0JAm56t5oZU/ofloL4nA8GCjjB2bppCt60rQLUwdusGcF0HL0dHxH4g3UTHprpQs2XwtZjYL0wWbjSGKUGDsA2Hed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707980087; c=relaxed/simple;
	bh=P6OgehdUI+4lS/3fA9nBYedwWvFBWq6plZ73fGjkSdo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q3Ptbxhl/uydl+6g15UWAsPzBjshHrtd02yW17UWlGqS9GwWqUEC5Y0Fu7/1K42razrPz10cmQPpqxa3SOix+UtX5Exyw3dpsRKlmnfLpPdPKwsYiRVIZVWs8m8Xt+Btotjo02vkx9GXIwWo4QxaIGDhxDRQFwVVolrMwJGGkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t/dMUHUh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t/dMUHUh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eYgGNz3XojwVZjySq6MEJLT0ZG7yP94WqXuA+PDih34=; b=t/dMUHUhP/zgl++SgPgS4vOcmC
	4Q2SyRdyhEePtF0uUzPyxVdZlDuCUaO2giW7SrWFSJ6S87X5olMr7EhJYEYD1gph6W17+4I8FYkuO
	WEikPxuA6Fy8qL2ycBLLWsSLTVcTaDqcT1m5HOvNC+MbTl+1FRtlHfvpV75UfO9sJ5B4fU8bEvVBG
	Ule5ueY+OEnGooFkuTnjIobXnHlwiiIGDvbo8BxZi1g4l1vQc98dJ2XFKEiYcYhGwWxhwtGA5c9bY
	yO1L6Pw0gL1Dd/KycEY6wyi4/GCIM9r4ytBh5yGbJElNr3kgk8PTZ2OWYRiiJX9x5K49cLdNJ5PHs
	lWn+7NNA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVdt-0000000F9Cp-1dFF;
	Thu, 15 Feb 2024 06:54:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 06/26] io: don't redefine SEEK_DATA and SEEK_HOLE
Date: Thu, 15 Feb 2024 07:54:04 +0100
Message-Id: <20240215065424.2193735-7-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215065424.2193735-1-hch@lst.de>
References: <20240215065424.2193735-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

HAVE_SEEK_DATA is never defined, so the code in xfs_io just
unconditionally redefines SEEK_DATA and SEEK_HOLE.  Switch to the
system version instead, which has been around since Linux 3.1 and
glibc of similar vintage.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 io/seek.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/io/seek.c b/io/seek.c
index 6734ecb56..61d352660 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -35,11 +35,6 @@ seek_help(void)
 "\n"));
 }
 
-#ifndef HAVE_SEEK_DATA
-#define	SEEK_DATA	3	/* seek to the next data */
-#define	SEEK_HOLE	4	/* seek to the next hole */
-#endif
-
 /* values for flag variable */
 #define	SEEK_DFLAG	(1 << 0)
 #define	SEEK_HFLAG	(1 << 1)
-- 
2.39.2

