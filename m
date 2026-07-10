Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6212D7DCF;
	Fri, 10 Jul 2026 05:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783661278; cv=none; b=PJvQ5JirA7jlUcoykm0SCWm0FcR0LUqEitWLMScHw+TpcTM0KEiQCp43RyUkCUOJh3IDJMAjHcWrbdNf/CooEVQVpuU2rKiWUJg4gu30J67Y6LRyGQ+up46oHqvAvq6AU3GCfm5BsuSCs5vAtVjILSGLR9YR9UKhEHM0fBY/Pso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783661278; c=relaxed/simple;
	bh=AHAemdJVOd6xUIkzh7PFKTNItsSZEc0IHbO2/06firA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIhHIIkM6Bx58kNSlJbQ+bdxD2w24Vd/7SeheqcKGltzuA8R8p2eR+b337t60MdfNiWKA2RFs6rhrmsf0HTKQKMiOQsuNPrRwzNlHBohkBvWs+nm22sS369XZVKdUzbR+9C95Kl8oiZHaIFYVFcg2HQQHj4iQXaKB/CKMWZBXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1xKP/qZX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1xKP/qZX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YiLX8aOIL3h0EoHUyvC0clj4NMCbF9LBCWI4dZkRaw4=; b=1xKP/qZXBcQBTt9Ky9oW81Eyvn
	iD7zhScUFvHr/JKNXpOp0lEbpU9JZtkKwfCl072Bz3izI43x7UK9SKW47+V5KemKQxNZ2yoSQySEN
	WhquZh+vu3fZ8B03wj7TC421k1+SXmsV0fn7AvsK4OcWrV5a+qiGKNlS6tsk8iAh+E4hmOYPViaz8
	CIWzihEaLHEucY+269sp8eWkvrVMSU++7s08fhB0wqQB2eRyUwJY/xbgzpF+9WdKoyWieCYZozhJL
	Q4r2FPVCmXo6TR0BBQBtMFsamYEgT6nXJC6dQdHfqe9yPDI0c4aC/pQKnUK6B9zlsAZpWZISD18Fi
	Etue+JoQ==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi3mF-00000004CId-2iyJ;
	Fri, 10 Jul 2026 05:27:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs/656: rearrange directio pread/pwrite for zoned filesystems
Date: Fri, 10 Jul 2026 07:27:33 +0200
Message-ID: <20260710052747.1841555-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710052747.1841555-1-hch@lst.de>
References: <20260710052747.1841555-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: "Darrick J. Wong" <djwong@kernel.org>

On zoned filesystems, a write failure shuts down the filesystem, which
makes this test fail with:

 --- /run/fstests/bin/tests/xfs/656.out	2026-03-13 16:19:08.152939212 -0700
 +++ /run/fstests/logs/xfs/656.out.bad	2026-06-30 18:16:43.847849604 -0700
 @@ -1,10 +1,9 @@
  QA output created by 656
  Format and mount
  pwrite: Input/output error
 -pread: Input/output error
 +stat: Input/output error
  pread: Input/output error
  fsync: Input/output error
  VICTIM pos NUM len NUM: directio_write: Input/output error
 -VICTIM pos NUM len NUM: directio_read: Input/output error
  VICTIM pos NUM len NUM: buffered_read: Input/output error
  VICTIM pos NUM len NUM: buffered_write: Input/output error

Reorder the directio pread and pwrite to avoid this unnecessary failure.
Note that we cycle the mount between the direct and buffered io tests,
which is why we only need to fix the directio test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/656     | 2 +-
 tests/xfs/656.out | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/656 b/tests/xfs/656
index 3830d7193fcb..c01276eb384b 100755
--- a/tests/xfs/656
+++ b/tests/xfs/656
@@ -66,8 +66,8 @@ $XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &
 healer_pid=$!
 sleep 1	# wait for program to start up
 _dmerror_load_error_table
-$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
 $XFS_IO_PROG -d -c 'pread -b 256k 10g 16k' $testfile >> $seqres.full
+$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
 _dmerror_load_working_table
 
 _dmerror_unmount
diff --git a/tests/xfs/656.out b/tests/xfs/656.out
index 83b2f5948a77..4d6633060acd 100644
--- a/tests/xfs/656.out
+++ b/tests/xfs/656.out
@@ -1,10 +1,10 @@
 QA output created by 656
 Format and mount
-pwrite: Input/output error
 pread: Input/output error
+pwrite: Input/output error
 pread: Input/output error
 fsync: Input/output error
-VICTIM pos NUM len NUM: directio_write: Input/output error
 VICTIM pos NUM len NUM: directio_read: Input/output error
+VICTIM pos NUM len NUM: directio_write: Input/output error
 VICTIM pos NUM len NUM: buffered_read: Input/output error
 VICTIM pos NUM len NUM: buffered_write: Input/output error
-- 
2.53.0

