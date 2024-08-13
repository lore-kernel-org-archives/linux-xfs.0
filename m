Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF94963A;
	Tue, 13 Aug 2024 07:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534547; cv=none; b=ZppUnMBO+m9fy0EkMNYMRxLeeco2bvW6BS3r0AlKh5SL4z3L5/zopHCH3j6vTUqxcs9VTgW4seclmzhgKjQLqmGSN4EhEAEhdyL7j8iEpVF08DNkG+ZOnuYsAEuwJAgiqYZEICnbhTwJYIct2ooT03ZWf4NS7vh34HoyR17bnG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534547; c=relaxed/simple;
	bh=XZt5rC9uT8JgujVOIE0CGZ6qzdqlnCI4Daa0kppKPTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhWcM2FblRQkBhSOzbJRQ2gdf8CGictEE9NKc4fuxZ60gS2nzA17DAublSAhhxUM6Lg6q2a1HIcqF5NOIzwA5yAeEAe3EozTVB18svWGwckX2XX67ZOzlKskGGRPCQf+6SSQvhxrR1juLUuvZlWqC/tkQeKu0LCpjg4lWWjkzvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u40E+80k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u40E+80k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ndVXm3PIVZgjnF0dZn8SFIlk/M35XvDx40I/A2ZkiMc=; b=u40E+80kmRbdNiV+5nwx9WxYMv
	DDW12DGvfqNOJcpqbQYA24yGaEts8wF6WHTXY/aYWjF+/1GKOGJc4fP4hs0/TQfSnBlInP7ZqDstb
	YCMyQlZZpCQcoo78Da2DNucmzgAomvnY6Mb+JOx3Ni9EiXxmSILizINBWFc/m1WpC5fRGeaJyCBKn
	lflIBRNyUr5/kAaxI4HET9eaSBef66+SWSlgTRRKeLYjgGFj6jOtYE199oS/738qS0hJwxuJtXwjA
	1qhwNXQpFX6lbnp2OrLSg6phjKKxYG2Oa7BnSLIKQx8CMoBf2sljeXX9VVIinMeoaGrOS8Scg+7h2
	Y2p4UgQQ==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm4G-00000002kZV-47Fy;
	Tue, 13 Aug 2024 07:35:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] generic: don't use _min_dio_alignment without a device argument
Date: Tue, 13 Aug 2024 09:35:03 +0200
Message-ID: <20240813073527.81072-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073527.81072-1-hch@lst.de>
References: <20240813073527.81072-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace calls to _min_dio_alignment that do not provide a device to
check with calls to the feature utility to query the page size, as that
is what these calls actually do.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/521 | 2 +-
 tests/generic/617 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/521 b/tests/generic/521
index 24eab8342..5f3aac570 100755
--- a/tests/generic/521
+++ b/tests/generic/521
@@ -22,7 +22,7 @@ nr_ops=$((1000000 * TIME_FACTOR))
 op_sz=$((128000 * LOAD_FACTOR))
 file_sz=$((600000 * LOAD_FACTOR))
 fsx_file=$TEST_DIR/fsx.$seq
-min_dio_sz=$(_min_dio_alignment)
+min_dio_sz=$($here/src/feature -s)
 
 fsx_args=(-q)
 fsx_args+=(-N $nr_ops)
diff --git a/tests/generic/617 b/tests/generic/617
index eb50a2da3..297d75538 100755
--- a/tests/generic/617
+++ b/tests/generic/617
@@ -24,7 +24,7 @@ nr_ops=$((20000 * TIME_FACTOR))
 op_sz=$((128000 * LOAD_FACTOR))
 file_sz=$((600000 * LOAD_FACTOR))
 fsx_file=$TEST_DIR/fsx.$seq
-min_dio_sz=$(_min_dio_alignment)
+min_dio_sz=$($here/src/feature -s)
 
 fsx_args=(-S 0)
 fsx_args+=(-U)
-- 
2.43.0

