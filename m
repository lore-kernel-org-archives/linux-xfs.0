Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43E3161BA;
	Fri, 21 Nov 2025 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709029; cv=none; b=OEp3mxxAbacWmXaPouGLBn3J3CVYjpScBdUOvipp/7p70Sm3bZ5o0RAVcI6wV6PPOqUohwY9lzgYmmJTOAVMNkL0sQXwJ+QuqmJT2isKrEOJtuCp+v8q6tEtEo/YY+bOBBKDOfV0zTj9XbBY05yLY/ULfgqm/5xT7eT6S9XaYFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709029; c=relaxed/simple;
	bh=q+7B8/ZY1QF2GvNCoB+S/KqFfxhmjLYDViIHnU8JB7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkOlHgJQAKzAYMtNR9IMIYaxiHTxj5REHKdznEa7VAlLWOuvftFZVZj/S63cu9JsOFaZgqHFc2LhsbPRDw+STP01YKQRBjWJ1filYZHDsKZzUmEsit4ARQwdipOav9ebTEfl+XCIJWGs3ybD3XA5f7jrmT7FpuP/TzoIYSQ8PLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=egcESuxz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egcESuxz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6Y1l6b5oJg80YwnMgYgMW3EKzUKgb4ktngEGSEX7aoQ=; b=egcESuxzLifU09bfS6E1I6ituc
	tONqiKpGJjiUPl3IvBu7Jr2TsLFntT7Y363da3kzyM1RgsokSaZ4htiMY8qANmMOGSmdxwJpxyGF0
	mcYMVFvWevSoq2MhmXyf41hO4mb6WC+GIx5rqpkdRfnua66lGY0idVa+shDKvZWd4DhBge3dHtGp+
	oh6lLy+Uoekss20Fp9+QGJafMFurMK+j0fgkNxzf4fOKfSqjqByGLQmW35sh++TMJ92cnnUScgrM4
	ckcUdHrpD0YNlEwTGuEdECDZxg5nyCVmO7VpOW9+72ECiYEisNV8oHLZIOJPmZRC9vIIorqu6K0eb
	N8FlF53A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMLHn-00000007xCy-37YH;
	Fri, 21 Nov 2025 07:10:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs/049: create the nested XFS file systems on the loop device
Date: Fri, 21 Nov 2025 08:10:06 +0100
Message-ID: <20251121071013.93927-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251121071013.93927-1-hch@lst.de>
References: <20251121071013.93927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Without this I see failures on 4k sector size RT devices, as mkfs.xfs
can't pick up the logical block size on files.  Note that the test
already does this for the nested ext2 image as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/049 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/049 b/tests/xfs/049
index 07feb58c9ad6..a3f478fa9351 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -58,7 +58,9 @@ mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seqres.full 2>&1 \
     || _fail "!!! failed to mount"
 
 _log "Create xfs fs in file on scratch"
-${MKFS_XFS_PROG} -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
+truncate -s 40m $SCRATCH_MNT/test.xfs
+loop_dev1=$(_create_loop_device $SCRATCH_MNT/test.xfs)
+${MKFS_XFS_PROG} -f $loop_dev1 \
     >> $seqres.full 2>&1 \
     || _fail "!!! failed to mkfs xfs"
 
@@ -67,7 +69,6 @@ mkdir $SCRATCH_MNT/test $SCRATCH_MNT/test2 >> $seqres.full 2>&1 \
     || _fail "!!! failed to make mount points"
 
 _log "Mount xfs via loop"
-loop_dev1=$(_create_loop_device $SCRATCH_MNT/test.xfs)
 _mount $loop_dev1 $SCRATCH_MNT/test >> $seqres.full 2>&1 \
     || _fail "!!! failed to loop mount xfs"
 
-- 
2.47.3

