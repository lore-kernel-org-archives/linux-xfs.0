Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4CF3C1D;
	Wed, 21 Feb 2024 06:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708497330; cv=none; b=so9H3fEOcpStykcxBsHLwAI0ZdI+LMsYRVyFgKw5zfJehrA0B4ETb20fBSJEFZ7n9IvJzSHbX26gzcuf4mdwu7LozG5XuWzGvjzXaRnS3ZmVTXbhXJVJFr2BZQMiRv6u0TpumL0xpq5XBHcUxwMzfKOjxQm57ndIJXpAx3HFdwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708497330; c=relaxed/simple;
	bh=0yeTZ3OjETOFd8XemPOVecqMystiahoyul/JpImvp10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y110Ko7RIaGQRvlCgGXmA59sZoMCJsmyZbv4YlI1zpAgyaLXLRiniD6CyRo29bDIIJgG1ZeqX+6MyPO3i/+CTSh4W51FsPPdiZpFmVwhD4DGGCSwTe6L6CkbMPa4xMs2DasfNsqBTuqcMia9QT9TlnnoHRW8FSJA019eAR0pBJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wk6FgalT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wk6FgalT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vz1234MI/q1d572V2OGpLnsGE/tN67cbxSb0Sk41xns=; b=wk6FgalTxuIuoYY+lhIfHXBDoJ
	NyvxMzn/3IRtVvUm9EYOT72DKPk1G2RSjRye/2fdMMqdUtkshUYeJwIPNf9Q6/hG3DCS4UuTHhnQO
	pBK31/8FKR8hEbb/WXifnEXa2iZ1CQHkZv4NaabXydRTVWG4/T2Fjhp0bSVFw1d9l85dogdyiYpUo
	cs/QNdMYqL4Bnahv0I3NWdsBp1XctURh+t3q6FJ1ZzysvutUTaEs/Xy0hs+oiYRxAYzHm8vMgKrDe
	jsdSdeRZD8hNwM8bOAU07GXEqcAaVVHPggLAvpl4ZW/1z1dR5EjxEkG2DiQpBjU/J0HWZ0hIPwcNF
	63Hgfyzw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcgCV-0000000HM16-1MqP;
	Wed, 21 Feb 2024 06:35:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] generic/449: don't run with RT devices
Date: Wed, 21 Feb 2024 07:35:24 +0100
Message-Id: <20240221063524.3562890-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

generic/449 tests of xattr behavior when we run out of disk space for
xattrs which are on the main device, but _scratch_mkfs_sized will control
the size of the RT device.

Skip it when a RT device is in used, as otherwise it won't test what it
is supposed to while taking a long time to fill the unrestricted data
device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/449 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/generic/449 b/tests/generic/449
index 2b77a6a49..4269703f6 100755
--- a/tests/generic/449
+++ b/tests/generic/449
@@ -24,14 +24,15 @@ _require_test
 _require_acls
 _require_attrs trusted
 
+# This is a test of xattr behavior when we run out of disk space for xattrs,
+# but _scratch_mkfs_sized will control the size of the RT device.  Skip it
+# when a RT device is in used, as otherwise it won't test what it is supposed
+# to while taking a long time to fill the unrestricted data device
+_require_no_realtime
+
 _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount || _fail "mount failed"
 
-# This is a test of xattr behavior when we run out of disk space for xattrs,
-# so make sure the pwrite goes to the data device and not the rt volume.
-test "$FSTYP" = "xfs" && \
-	_xfs_force_bdev data $SCRATCH_MNT
-
 TFILE=$SCRATCH_MNT/testfile.$seq
 
 # Create the test file and choose its permissions
-- 
2.39.2

