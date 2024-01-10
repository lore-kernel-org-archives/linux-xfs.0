Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286CD4D106;
	Wed, 10 Jan 2024 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DgTA/Fvl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8F54mSZB6KqJBeKTxONc90pk45yQAknFDeRqNyNuM9w=; b=DgTA/Fvl6QPj8Xhzjl5usrcpS7
	zOjPUQ/NKBtaTdgzrXEk4pdqo0pnbQxsLSX+TEOjxhBPqpNU9RXF+1XL0r9ReQ2AdkVOspbSiegsh
	HP6DvZHKtON231Lojb7XAtF5OuFbI8eDy0Y2XLHy//FTwR/wJO2gwVh0Wx7rw+gNdOEF6owzJX9A6
	qF7yyRaFRu0ohNxfS3+lvNLJMBS7eWak79a5HU114PYamZWLNQZJr+VwLM0jaYBXgMKTePc1BcnW9
	WbHK493jP75p72a2nkp52fsXkgpD6lNidOYXk1mTYoQRxbAPAzz59ObL2kFZ/OTFW8puhpFglKUVo
	L26xkrSA==;
Received: from [2001:4bb8:191:2f6b:6c64:f589:bc06:1618] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rNceD-00DFZq-1N;
	Wed, 10 Jan 2024 17:45:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs/262: call _supports_xfs_scrub
Date: Wed, 10 Jan 2024 18:45:44 +0100
Message-Id: <20240110174544.2007727-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Call _supports_xfs_scrub so that the test is _notrun on kernels
without online scrub support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/262 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/262 b/tests/xfs/262
index b28a6c88b..6df3c79f3 100755
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -29,6 +29,9 @@ _require_xfs_io_error_injection "force_repair"
 echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
+
+_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+
 cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
 $LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
 	cp $lib $SCRATCH_MNT/
-- 
2.39.2

