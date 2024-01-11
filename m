Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A383D3B1;
	Thu, 11 Jan 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L8kZfYm4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Iv9Bu0mE44RTz03zKEPAkNev9dNgiwi5T8VvNCAgyYk=; b=L8kZfYm4T3cUy+EF8oXIhruVrx
	Y3QVzvJKk/6zotUnGwjzfPJyM3jnD8/KumMdIG8Hf1RfN1lP5CZuqXS5HVnyTo6iCGNB2vfNHjcxY
	2n4VwcXxKeynvJr6zpe5YQxtmXV6Z7KTGER2EoWhygxVlZpYezY3vsLmyHiwNIyc0RgJdpmpypVFS
	e7QCwA4T80HV06q/J5a3MdeEd0+RaVRvVAWGDTBqNtpm4IGksoA3QEHOulptyY3um3uvWqk7cKCKN
	VzK/Bk+4Op9NhjGZ86y3LgmVy9j/hppB545bUNFBoRHkl7Bf+nLKCfPgYPwmjkuL3tHpFMSoEpyuL
	GNA17UBQ==;
Received: from [2001:4bb8:191:2f6b:63ff:a340:8ed1:7cd5] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rNvyo-000HGT-0u;
	Thu, 11 Jan 2024 14:24:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@redhat.com
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: add a _scratch_require_xfs_scrub helper
Date: Thu, 11 Jan 2024 15:24:06 +0100
Message-Id: <20240111142407.2163578-3-hch@lst.de>
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

Add a helper to call _supports_xfs_scrub with $SCRATCH_MNT and
$SCRATCH_DEV.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs    | 7 +++++++
 tests/xfs/556 | 2 +-
 tests/xfs/716 | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/common/xfs b/common/xfs
index 9db998837..bfe979dbb 100644
--- a/common/xfs
+++ b/common/xfs
@@ -661,6 +661,13 @@ _supports_xfs_scrub()
 	return 0
 }
 
+# Does the scratch file system support scrub?
+_scratch_require_xfs_scrub()
+{
+	_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || \
+		_notrun "Scrub not supported"
+}
+
 # Save a snapshot of a corrupt xfs filesystem for later debugging.
 _xfs_metadump() {
 	local metadump="$1"
diff --git a/tests/xfs/556 b/tests/xfs/556
index 061d8d572..6be993273 100755
--- a/tests/xfs/556
+++ b/tests/xfs/556
@@ -40,7 +40,7 @@ _scratch_mkfs >> $seqres.full
 _dmerror_init
 _dmerror_mount >> $seqres.full 2>&1
 
-_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+_scratch_require_xfs_scrub
 
 # Write a file with 4 file blocks worth of data
 victim=$SCRATCH_MNT/a
diff --git a/tests/xfs/716 b/tests/xfs/716
index 930a0ecbb..4cfb27f18 100755
--- a/tests/xfs/716
+++ b/tests/xfs/716
@@ -31,7 +31,7 @@ _require_test_program "punch-alternating"
 _scratch_mkfs > $tmp.mkfs
 _scratch_mount
 
-_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
+_scratch_require_xfs_scrub
 
 # Force data device extents so that we can create a file with the exact bmbt
 # that we need regardless of rt configuration.
-- 
2.39.2

