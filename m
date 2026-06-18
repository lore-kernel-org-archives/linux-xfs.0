Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96862D9ECA;
	Thu, 18 Jun 2026 13:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790526; cv=none; b=Gg2iOFx0/+iBWDQgnOC2rDOpOcd6osKQgnegwxVbaUF9s/aShTeKXmCej5xQOmDPCoiGn2646jRBpO2Q5pKwNlJUlVp4g9TB5Ghxgjtm+wsuJ1mTY6hga77zzgb6clXZILxXAWIxssHgzqxPWjuqGlzvrZMP3ppQcNRJ5Za8m7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790526; c=relaxed/simple;
	bh=hR5LBek5OielQgfz3bnuNRskgjc5nIw4lQtPbrILECM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd2L7V9hRW5ZLtifOqtOUb2q/ktzKJrBrpNTugvi4HuUToYUz+wkzJdWX3orF8y3EmCRRJUU/oH+a3172AiOD+onJ8yErh/lj8bOZo4XLU7X4SS8M9sSMPs5s18/iA/RBR/GNJyt08+ZrDElLQTL/Zqsm9glI+GAAZb17beSuM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WaIS1F2S; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WaIS1F2S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4OtL2v/cYo5N0mNGsHspeXGVcgr8R9CSb/U9m5shlkY=; b=WaIS1F2SMrXX8PbJEYL3LedvRn
	otfARjJqM1azPcslYJa7wltyjX2IRHKmql4UXLFLF8WfE4YxuDXSgJxdoglQfmGTz0axW1j99Rbrm
	FFvnMxqs/gte4N3f5L4doCPXQ/y0bBaEIfkwzvW+VYS8e0nyTeCLx8fujYRMsut0d/bipMjxipNrV
	MR3N18Cqy3SZOhQVN3ApTYXff9qv6Q/tlbht+Ycz33mGg32hh4qAzynCFVXCCAkPgDEGoMExs0O5+
	uhSnM0nYkBBQbrVM+bGBIJiH29W31Q5ZpQzHElcXpEDkwEc/GxW6y2mfgd7H7LqV6IT3rI8CcvPXj
	SxmpcRuw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waD6p-00000001ODK-2Lg9;
	Thu, 18 Jun 2026 13:48:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/2] xfs/078: disable all concurrency scaling
Date: Thu, 18 Jun 2026 15:48:25 +0200
Message-ID: <20260618134834.237647-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260618134834.237647-1-hch@lst.de>
References: <20260618134834.237647-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Disable concurrency scaling to avoid mismatching output on systems with
a large CPU count.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/078 | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/078 b/tests/xfs/078
index 6057aeea12ab..8ef52614b125 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -57,9 +57,11 @@ _grow_loop()
 	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
 	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
 
-	dparam=""
+	# Disable concurrency scaling to avoid output differences due to large
+	# CPU counts.
+	mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
 	if [ -n "$agsize" ]; then
-		dparam="-d agsize=$agsize"
+		mkfs_opts="$mkfs_opts -d agsize=$agsize"
 	fi
 
 	echo
@@ -67,7 +69,7 @@ _grow_loop()
 	echo
 
 	echo "*** mkfs loop file (size=$original)"
-	$MKFS_XFS_PROG -b size=$bsize $dparam $loop_dev | \
+	$MKFS_XFS_PROG -b size=$bsize $mkfs_opts $loop_dev | \
 		_filter_mkfs 2>/dev/null
 
 	echo "*** extend loop file"
-- 
2.53.0

