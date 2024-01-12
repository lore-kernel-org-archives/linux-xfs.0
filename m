Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C545B5BA;
	Fri, 12 Jan 2024 05:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wn68BemF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MMsxL+lG0fd4vltJu5jNvm/dso6+vr/5nljjlH4LhFk=; b=Wn68BemF0lWzmoTU7DAn6A2Fka
	HUM6y3ROIaUwwFrqm/gLzVPLfsJbOOZPKOoKXJ5ob82E+iTaIG2MQruXDUyV7F8/UPu/CPrvTig1J
	ije107EqJYHwNabalC/gLWH36dl1vYmCazYsE0UlXs7mNWcTNtdX7hA2/kZzUC6nUAhv2ghy8ew0Q
	C7HXJJN4iGxB3SW5ED+TEJmTogTeJqyoz+8ZtODf82JDNaclXeZe7DsRR57zYNX6stPWAFXXa0v1S
	C3uVrwKoUjg6+hnv5s4VJFFztM9gA7r7tWhVmuZ5zg0TQdIJ8RCEUckiT0ZA/9G4LXuk+OpZkAlWe
	qi+PM3yg==;
Received: from [2001:4bb8:191:2f6b:85c6:d242:5819:3c29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rO9me-001uju-2Q;
	Fri, 12 Jan 2024 05:08:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs/262: call _scratch_require_xfs_scrub
Date: Fri, 12 Jan 2024 06:08:32 +0100
Message-Id: <20240112050833.2255899-4-hch@lst.de>
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

