Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32792AD16
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758287678; cv=none; b=jfVEsHlJXrd2jRxyzI61EHZ8YWc6jjoHDOHIr7UCFeEbYNPD6uoGZ3fFEC1SYlJK+8mvDoa+KGJgd53YW7NPeF6PUpIkdZV5O042blbRQRBCRlgjUKLL9Zyc5knHRipDbPK/DRIn0tEA+fWTgCG+JbPyzwFYzkKf228sgyH7C2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758287678; c=relaxed/simple;
	bh=yQdTgp0zIppt59EWvdssHYWSl6GhL+Y+3GBxkrlCCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qMapeWwpqd92B27m7MlRq1tyzjBaYSeQVtioI6KKm+JF/CeYWjy3ErdN4Atwke9ZPPUvlX7cZA42tfL3C03sLoMWp6XKP9/xrmyv4nt/eQ2nTC1eHN/AKKEO3487uTmFkPrMENHxqJqcHAb/ZHPbfGiBDiVbMcKutQSXk8qJl/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rFVHZ/2x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rFVHZ/2x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=kAOBAvd1fpWtbHfw6LDVDtkfMLHUqoieiynJokLUeVA=; b=rFVHZ/2xRwQiOaQe3CSKhfZy18
	dbchgw+KxF645aiYn7+hqtLqw1WSungAZ7oJqoCWzTtopbaMSVTQQAQZL1WhZJoM5hlLpXWg3+2A/
	/Izz9kBGagIRNxVN7wgHjTLcjsHHb3Fkvvm7gIOf6eVkpM87+02x1zl1OJ7x+Or7iJbSXslPfw6hK
	gptHov/Hs1YdZ6aVkPI9FQrELl0RdKzZk4yyLa/mIWJuDs0boYgk3OnWP688J3w1ifFncXXMsYbpC
	qZd7qeskqAsN7LAZcvECGWVo0f/ftT9KwhZlHrLhpp6XOn+5OZppVO+b3jyR66SI4u23R26v/W9ex
	vdJfENXw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzawe-00000002xC5-1Yel;
	Fri, 19 Sep 2025 13:14:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: constify xfs_errortag_random_default
Date: Fri, 19 Sep 2025 06:14:11 -0700
Message-ID: <20250919131435.802981-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This table is never modified, so mark it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Resending standalone because it got lost in the errtag cleanup
series for the last resend that now is in the next-merge branch.

 fs/xfs/xfs_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ac895cd2bc0a..39830b252ac8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -19,7 +19,7 @@
 #define XFS_ERRTAG(_tag, _name, _default) \
 	[XFS_ERRTAG_##_tag]	= (_default),
 #include "xfs_errortag.h"
-static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
+static const unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
 #undef XFS_ERRTAG
 
 struct xfs_errortag_attr {
-- 
2.47.2

