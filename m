Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC4E5B5BD;
	Fri, 12 Jan 2024 05:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cEDaoDEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+FJ5dChg4aaYW1holosb+rE8x7KgAbLfS0EMDgSKfEQ=; b=cEDaoDEfs7d6UcbmbZSeO1hDA9
	yKal7AgF0ELr4s73hb3BKuMgGoqFF1GPur9Qg2ROQGzyWAN90Ut4W1yDV9bfXxWG+b51u4/UDcAkV
	kJdZvib8lNds6FN+FHhyq9EFdiT8mDKHJwE/qsUntuh7ykrjjlFl55wDKC6A80LlSUau81u97RPtR
	RH/C0oFRzxZc2Dwx7AgOU7lvwd/Ars1MiKvh4hrsOFBDvKoMT2QNlChU9Nwy5nrZZrKori+CyAjR6
	fpXbMzeEyFkBQMCdiRqWvLeb3o8q2b4KTiP5Uf6PdommRtSBLOXC/dbDscTaa2qea7SyVYW5FnD/X
	SG4PqBYg==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9mh-001uk4-0f;
	Fri, 12 Jan 2024 05:08:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs/506: call _scratch_require_xfs_scrub
Date: Fri, 12 Jan 2024 06:08:33 +0100
Message-Id: <20240112050833.2255899-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240112050833.2255899-1-hch@lst.de>
References: <20240112050833.2255899-1-hch@lst.de>
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
 tests/xfs/506 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/506 b/tests/xfs/506
index 157dac293..b6ef484a5 100755
--- a/tests/xfs/506
+++ b/tests/xfs/506
@@ -21,6 +21,9 @@ _require_xfs_spaceman_command "health"
 
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount
+
+_scratch_require_xfs_scrub
+
 _scratch_cycle_mount	# make sure we haven't run quotacheck on this mount
 
 # Haven't checked anything, it should tell us to run scrub
-- 
2.39.2

