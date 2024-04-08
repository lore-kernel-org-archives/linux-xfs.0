Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5F74438;
	Mon,  8 Apr 2024 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583184; cv=none; b=ZOct0Nc8/OqMi7EhU7hSzAnbJKXpbv8rDf5CbpC4AZhV9pGdjur8XSNxxqM0Ou5IOrMfg/saXosCA+ONl+Ht6B2075MU6+mI+GHmCPrqGbxUHf+zXBbqNh7IjIVaSI5EOuzNqPonR7/0t6egJMiW8SOiU/SFwz0am2GJBUIW3RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583184; c=relaxed/simple;
	bh=hj3soi/5coOdkwW20UsWavzW0qEo31tdFfeqZJfDlrs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UKXqV0p/9gq1vg98akcXnwf94ViKkU/Z+1QmeuqZ27yQU7laKU2lXED2hEfosh6wEK6YX+KPd8pQ6J8EIebSnM7/34a9xayslzUNAkeZ5X9tRbxguF/K8uQMyOQIk8ZWbd6qXjxbkVEgYohwQhv2eAh5yAGrKQMzVF2iRsGPv1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OcHIm6uN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OcHIm6uN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g0gaBHJE9MHYo7oSkm6i9GOx5F9FEkqRT039LF9T8NU=; b=OcHIm6uNR+0IA+PVZC4oes+kB3
	TluDMT8HqNou8vo8u/quHcAo1z1oBHaBwBO3wyGOYJxv0NeM+4XB4aDN/6/2XpMafSVdiF1Mynwjd
	lLea/+haPtrrBRdiAdbSkOKodzxYGqcsmmZbN8DLV6jJw+Ic0zEjas+bpKgJspv8Qzls1YnqhE2ce
	s7P6l7Hop25l7vAGuVwtHc5kXlaFdo13ygoy8sFLepFqbNt867xrV/JYzBdpjlmJXfzKffzdz868i
	wREa3mLLkcMUC514RF8aCCauWlJT8H9pkv9GxMgtrFSVK/YLqRT2Yse3GyaFYYEWHQUV8odfnQU3r
	CrDahq3Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp7N-0000000FjSh-0yWz;
	Mon, 08 Apr 2024 13:33:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 3/6] xfs/078: remove the 512 byte block size sub-case
Date: Mon,  8 Apr 2024 15:32:40 +0200
Message-Id: <20240408133243.694134-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408133243.694134-1-hch@lst.de>
References: <20240408133243.694134-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

512 byte block sizes are only supported for v4 file systems, and
xfs/078 crudely forces use of v4 file systems for it.  This doesn't
work if the kernel is built without v4 support.  Given that v4
support is slowly being phased out and 512 byte block sizes have never
been common, drop this part of the test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/078     |  9 ++-------
 tests/xfs/078.out | 18 ------------------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/tests/xfs/078 b/tests/xfs/078
index 1f475c963..501551e5e 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -69,12 +69,8 @@ _grow_loop()
 	echo
 
 	echo "*** mkfs loop file (size=$original)"
-	mkfs_crc_opts=""
-	if [ $bsize -lt 1024 -a -z "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-		mkfs_crc_opts="-m crc=0"
-	fi
-	$MKFS_XFS_PROG $mkfs_crc_opts -b size=$bsize $dparam $LOOP_DEV \
-		| _filter_mkfs 2>/dev/null
+	$MKFS_XFS_PROG -b size=$bsize $dparam $LOOP_DEV | \
+		_filter_mkfs 2>/dev/null
 
 	echo "*** extend loop file"
 	_destroy_loop_device $LOOP_DEV
@@ -104,7 +100,6 @@ _grow_loop $((168024*4096)) 1376452608 4096 1
 
 # Some other blocksize cases...
 _grow_loop $((168024*2048)) 1376452608 2048 1
-_grow_loop $((168024*512)) 1376452608 512 1 16m
 _grow_loop $((168024*1024)) 688230400 1024 1
 
 # Other corner cases suggested by dgc
diff --git a/tests/xfs/078.out b/tests/xfs/078.out
index cc3c47d13..7bf5ed03e 100644
--- a/tests/xfs/078.out
+++ b/tests/xfs/078.out
@@ -37,24 +37,6 @@ data blocks changed from 168024 to 672096
 *** unmount
 *** check
 
-=== GROWFS (from 86028288 to 1376452608, 512 blocksize)
-
-*** mkfs loop file (size=86028288)
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-*** extend loop file
-wrote 512/512 bytes at offset 1376452608
-*** mount loop filesystem
-*** grow loop filesystem
-xfs_growfs --BlockSize=512 --Blocks=163840
-data blocks changed from 163840 to 2688384
-*** unmount
-*** check
-
 === GROWFS (from 172056576 to 688230400, 1024 blocksize)
 
 *** mkfs loop file (size=172056576)
-- 
2.39.2

