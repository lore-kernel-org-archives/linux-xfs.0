Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20911E5716;
	Wed, 12 Mar 2025 06:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761986; cv=none; b=gj0lQ0g+Eo5m9CBYxoeqQ6oylhHxUvvssulgxfuyJqoman/cNH7CY/35XAd2eYHzNm6oXNxbSZzkjNSMYxNW/o9NUcHOGfn9qfBSIAqzl3MKzr4uwIkXP4ZG2Ey1RE/iePgAhjyKXNFV3a8iElbFD5T3jwEZyq7ZcPSbOt8nMF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761986; c=relaxed/simple;
	bh=CWi+Fa6r0ay8bZL2ZNxHmQkGQ1EoN6e9pNpSZtYSTfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXU700lzCqHPzRPH88m2WJgj5ieqifrnFVGTEVZ8MC9FOvBuHm0lGlcQptpm4CELjA+NYQZRoauW1TDbsgArQvuL5StLV6ANMDQFHVToF6mcgPcCmcUbdR2vMA812d5knr3gbVX7jwfViSpv6ZNZIS+ccoT9rL1u4uM/gYrixxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4IvAS9k5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4IvAS9k5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tt9gg9wMTMis5LZkSR9MQwPu5IDUyZBP2pyI5aCZdz0=; b=4IvAS9k5f2PbgEJoBMKMGHIeXI
	8x8AJIivIxw3OhJQi7nLGFtG+s1TATFtTiW1TSjeBUFmYtYADb7DOiASqCFeQE3jiN8w0P5rT0/GF
	K9vy7mXrE1fZw3GXgq9LhByH3cXTrPqNZSXsPbKjttaN7XCjxNJFb1ctbjKJquD3i/8MA327OQOJO
	8aW7iVG2he3QHX6O3v/CLwP2BAYFaqlrcy3rhhDe452a52mnNJoUQjzeJtaXWYi0/+QtPtgf+WCj+
	/ToBxG3vPY6uOwToDDoRtKqnLPLofyWt4FeLCGYLehyy6SgiKXgDitatPiOFJen8Mc2JF8utBewNv
	WGQqnAKA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFrE-00000007cvL-2g8o;
	Wed, 12 Mar 2025 06:46:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 15/17] xfs: skip various tests on zoned devices
Date: Wed, 12 Mar 2025 07:45:07 +0100
Message-ID: <20250312064541.664334-16-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Various tests don't work with underlying zoned devices because either the
device mapper maps don't align to zone boundaries, or in one case the test
creates an ext2 file system that doesn't support zoned devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/049 | 2 ++
 tests/xfs/311 | 3 +++
 tests/xfs/438 | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/tests/xfs/049 b/tests/xfs/049
index cdcddf76498c..07feb58c9ad6 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -40,6 +40,8 @@ _require_scratch_nocheck
 _require_no_large_scratch_dev
 _require_loop
 _require_extra_fs ext2
+# this test actually runs ext2 on the scratch device
+_require_non_zoned_device $SCRATCH_DEV
 
 echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
 echo "" >> $seqres.full
diff --git a/tests/xfs/311 b/tests/xfs/311
index 8b806fc29eb1..e8fc547cc4b4 100755
--- a/tests/xfs/311
+++ b/tests/xfs/311
@@ -30,6 +30,9 @@ _cleanup()
 _require_scratch
 _require_dm_target delay
 
+# The dm-delay map added by this test doesn't work on zoned devices
+_require_non_zoned_device $SCRATCH_DEV
+
 echo "Silence is golden."
 
 _scratch_mkfs_xfs >> $seqres.full 2>&1
diff --git a/tests/xfs/438 b/tests/xfs/438
index 6d1988c8b9b8..d436b583f9d1 100755
--- a/tests/xfs/438
+++ b/tests/xfs/438
@@ -96,6 +96,13 @@ _require_user
 _require_xfs_quota
 _require_freeze
 
+#
+# The dm-flakey map added by this test doesn't work on zoned devices
+# because table sizes need to be aligned to the zone size.
+#
+_require_non_zoned_device $SCRATCH_DEV
+_require_non_zoned_device $SCRATCH_RTDEV
+
 echo "Silence is golden"
 
 _scratch_mkfs > $seqres.full 2>&1
-- 
2.45.2

