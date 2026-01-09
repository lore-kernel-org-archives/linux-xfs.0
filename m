Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E224122B5A3
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975822; cv=none; b=U+IHLOdsjsBOGJfvoUBoiyAR3BaX/PlB18aYDDb1J/8IMQCr3k0yA83AIfaJuSnFmIWewqI82SVkVrIuRq14/kcFZG2O4Yc8dgi1KhZBkjauVoSbdfjv5+AGkwFk+k3KXKhYmYLODQlOQ+ELBFd9IRlX6Pu5h5rtx5JBlovHums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975822; c=relaxed/simple;
	bh=wZDh/scA1OkLMSeRCwI6jl3S+2j0qqG32D2lArtRD7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuRQVHhyv8PMoegq63QNZwJ0uNJwTIKMlSN1VfF7bQRQuLsFZe6c5ODm7IqQX9RbgLP38QBp7JtddXFEYF6f6OzRQmXKqyWVXecxTKoC5zyFHxc3ppX/AY87tmT9BOqndcPlhDl9pBDjFLSjjxgyMYEZwxSD8LZu7/HfjdJOz4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ca0JUlHR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ca0JUlHR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=dck1fQXwJqdHi0+ryCl4d4Iwd9EaC2WTtfxKRFX6K80=; b=Ca0JUlHRXmGHGHQMWMHUS3Zx1K
	E3zF2pPeIg/cqdfbKW3WKvfswbaNrxqPD1UtWNEAJohEphNcP94SkOYxFjwCder70yEYg6bHXtsXQ
	fI8+Q6f61fsDcb02LDnGrtSTsT1vHmsC5BX7nSiUG9yqbYCV/4Y4ZppaLSDztXXj+q98+BYRiHVOZ
	Y4FddTdDzzquMKQdRHzoM4ptgzVZWixX5zon+daTtf56abAMf0uNbngXH4VbfjCA4gfTepkbce9ED
	tBIkHv57OGOqYZJinmH9ItLopMlhNCRWVgFs9uLVUE4AlNUjgOdhamomDOQ83oLcr2NZDx6kF0CvQ
	/SUtGpbw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veFH1-00000002cBO-42nM;
	Fri, 09 Jan 2026 16:23:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] mkfs: remove unnecessary return value affectation
Date: Fri,  9 Jan 2026 17:22:53 +0100
Message-ID: <20260109162324.2386829-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260109162324.2386829-1-hch@lst.de>
References: <20260109162324.2386829-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

The function report_zones() in mkfs/xfs_mkfs.c is a void function. So
there is no need to set the variable ret to -EIO before returning if
fstat() fails.

Fixes: 2e5a737a61d3 ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76..215cff8db7b1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2587,10 +2587,8 @@ report_zones(
 		exit(1);
 	}
 
-	if (fstat(fd, &st) < 0) {
-		ret = -EIO;
+	if (fstat(fd, &st) < 0)
 		goto out_close;
-	}
 	if (!S_ISBLK(st.st_mode))
 		goto out_close;
 
-- 
2.47.3

