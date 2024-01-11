Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9C63E49B;
	Thu, 11 Jan 2024 14:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trtCMAtf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MMsxL+lG0fd4vltJu5jNvm/dso6+vr/5nljjlH4LhFk=; b=trtCMAtfxb4yKgu1hhe0SI55Jg
	cgwADwZkwmdU1JT5/sLovQJR0vNR3JNXpqnTJ9yZ9HZf0HCNhY5PiZsBWh5OgYXpp0ezMB/NDV9qY
	cZ33O11yYOU0qo3tC2ARDpPRwRL20xq67VZcvDtA2vT+2Y9JsnOSDp6a1CxMaVnXPX6Bb3hSRxt04
	WIpYDtEH/kEYmZcfDJHDID99Eeq02RjvTl1+dS0RD7dQ65c9JYvFNlKOeBN72X88qx1zk7n21FYML
	j8AU2e6dhcnzqlrohfKJbpINMNJ/7cQAFow4H4zg8C5VYErA83/vYUcEX2q3KKwZ6r2/mZOI19jCs
	5vnTpdOA==;
Received: from [2001:4bb8:191:2f6b:63ff:a340:8ed1:7cd5] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rNvyt-000HHu-1U;
	Thu, 11 Jan 2024 14:24:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs/262: call _scratch_require_xfs_scrub
Date: Thu, 11 Jan 2024 15:24:07 +0100
Message-Id: <20240111142407.2163578-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240111142407.2163578-1-hch@lst.de>
References: <20240111142407.2163578-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Call _scratch_require_xfs_scrub so that the test is _notrun on kernels
without online scrub support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/262 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/262 b/tests/xfs/262
index b28a6c88b..0d1fd779d 100755
--- a/tests/xfs/262
+++ b/tests/xfs/262
@@ -29,6 +29,9 @@ _require_xfs_io_error_injection "force_repair"
 echo "Format and populate"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
+
+_scratch_require_xfs_scrub
+
 cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
 $LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
 	cp $lib $SCRATCH_MNT/
-- 
2.39.2

