Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E791818027;
	Fri, 19 Jun 2026 05:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845788; cv=none; b=GroeZvdTtiCdTe1u8r8j7T06QweHMVt6SDtTz8kk2bU3rLmqo8B466S43cTB5wba+GfEyAkFsX/38yF8sFCh/LupFuwe+QrC8OOO3xM2CpbWdb3qHccPVqvYoDiLC5u9Jjnmt5Xat6Pf8E6YzzHbotRm6Gjw+bpwAPxIr/JPhtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845788; c=relaxed/simple;
	bh=9+Z6EAwB0+w41vSYCT9OQmx+zTTS0BaHZRTVnbsfaVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqLzpkVzjjDnw1YvAQLRt4UAMVp2DFqRfgaq7vZ8PsuRExaoo906TzrvRdTvlZxuEO+L0f3NdGMSdjCzJMveSq5yZLb1/ObfYR4pZDZPugpoqKG5z42h1lR+FQAcRovgRca/pRDUeaC6aAeqHqF684CkyFUz3JwF1K2KZhxLSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z8Ss4Awn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z8Ss4Awn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5s2z/YW6O8ahTEso3yv5saqAx+YeBrGkJJcRNBAzJwI=; b=z8Ss4AwnhqMCfMVfftxbaIv/qx
	QrM2PtO8ixC07vHq8dSGXpvgnsWlRHBnIW0EYkhPb2S4imMhf5nlHA/sCj2CMILbxJ0JKUzTQQZ5z
	PAWsIIPxyM9X0J/yySUUuVr246i1Xal/hV92wwuGqNs9wOS0O/0dJTsPb2+bGu2KF1An4elUGxP/Z
	dek5TwnGHspV6Cy1q+8vt3iREMVhFi3ak57QAzDYE2SpLzFOYI7tcsZHxE9mR3MjNL9oQQXbt+Vr7
	APsmMpxp+SuDHjzssWvOmEnBmjYyuHDhkdid8xTD+4YHe1CW1nxp9fTJpvmI1KiLI3jF2Xa5z71L1
	cD4ueJBg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waRU8-00000001zqF-3tQM;
	Fri, 19 Jun 2026 05:09:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 1/2] xfs/078: disable all concurrency scaling
Date: Fri, 19 Jun 2026 07:09:28 +0200
Message-ID: <20260619050937.444488-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260619050937.444488-1-hch@lst.de>
References: <20260619050937.444488-1-hch@lst.de>
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
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 tests/xfs/078 | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/078 b/tests/xfs/078
index 6057aeea12ab..408170ae57f5 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -57,9 +57,16 @@ _grow_loop()
 	$XFS_IO_PROG -f -c "truncate $original" $LOOP_IMG
 	loop_dev=`_create_loop_device $LOOP_IMG $bsize`
 
-	dparam=""
+	# Disable concurrency scaling to avoid output differences due to large
+	# CPU counts.
+	if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
+		mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
+	else
+		mkfs_opts=""
+	fi
+
 	if [ -n "$agsize" ]; then
-		dparam="-d agsize=$agsize"
+		mkfs_opts="$mkfs_opts -d agsize=$agsize"
 	fi
 
 	echo
@@ -67,7 +74,7 @@ _grow_loop()
 	echo
 
 	echo "*** mkfs loop file (size=$original)"
-	$MKFS_XFS_PROG -b size=$bsize $dparam $loop_dev | \
+	$MKFS_XFS_PROG -b size=$bsize $mkfs_opts $loop_dev | \
 		_filter_mkfs 2>/dev/null
 
 	echo "*** extend loop file"
-- 
2.53.0

