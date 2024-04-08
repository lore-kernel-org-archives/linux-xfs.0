Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C877B81219;
	Mon,  8 Apr 2024 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583188; cv=none; b=TW49LS7Gl06gXrXn2MYJOwJFyTn+k8l5dfQBHxt/cqPkTSjIYYrYEpCpUzJnfshuikFRoxQPFTz3RvUPlewRKRDtP94b89SWPzo1/qXBM0BljRi2bX/MRr6s4NEyglmHYBnuj8gxYBgHV/GRYYg7/rLHopWxpS0HPCQCfUyWysc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583188; c=relaxed/simple;
	bh=d/AWhra2gVUPWRTvuUj0g6eXbJw+VHgXMC//1JX2DxU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dCAFys0dOISKzDNH4ed9Pmy8FPQkfdlmQAcNRwjVF+GEEPNOYq5z4UYtoWKdtxY8xn/zn6DK5MIBXGli5O5dm5OCqX2BdTa+1YSC6HnzVDVX/PDrGfFYPrkIheIicbrGVexOsXYeMIZQQysjE7dxuPf9ODOjsFUWEKYZ1/K3uuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aVzoBi/8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aVzoBi/8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E/MZ6N3EAqX5+mntOfEd9+Od3FjPzqMnwMpwHQvkqQ0=; b=aVzoBi/8+adY0psnMLbmoJttzJ
	NUHT1FDhJDis0e4ENROG7n+REERlLqIxPGgLG5yaI5Zq/LqUA0d04ndm8r+kA9EWkwalyCjjwbx3s
	CNGq+z9/XZOXqdjWLLZHmNdjjPaeJI0FaM+Tx2W0Ci+9fzFIQ6+qrOAPJkOBaeIh6XwUBRFWTJz4n
	XnU2fVxrYiTYhOuoqD2N96kj14M3Mqa43WjR06Q+S42tE4izPb5c3u3kdLwpCO1Fet5smkHt5Tzyd
	7WMegAsxowydu4uJUBtllGd0N/yfgwJeFChTCiNRQhL6ZeI3XCknjC08lDvKk4Jzh61p0yJ65Hw13
	aoVTCMkQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtp7R-0000000FjTJ-0wkO;
	Mon, 08 Apr 2024 13:33:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH 4/6] xfs/263: remove the nocrc sub-test
Date: Mon,  8 Apr 2024 15:32:41 +0200
Message-Id: <20240408133243.694134-5-hch@lst.de>
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

Remove the test on nocrc file systems as v5 has been the default for 10
years and the kernel has made v4 support optional, which would fail this
sub-case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/263     |  5 ---
 tests/xfs/263.out | 85 -----------------------------------------------
 2 files changed, 90 deletions(-)

diff --git a/tests/xfs/263 b/tests/xfs/263
index bd30dab11..54e9355aa 100755
--- a/tests/xfs/263
+++ b/tests/xfs/263
@@ -66,11 +66,6 @@ function test_all_state()
 	done
 }
 
-echo "==== NO CRC ===="
-_scratch_mkfs_xfs "-m crc=0 -n ftype=0" >> $seqres.full
-test_all_state
-
-echo "==== CRC ===="
 _scratch_mkfs_xfs "-m crc=1" >>$seqres.full
 test_all_state
 
diff --git a/tests/xfs/263.out b/tests/xfs/263.out
index 531d45de5..64c1a5876 100644
--- a/tests/xfs/263.out
+++ b/tests/xfs/263.out
@@ -1,89 +1,4 @@
 QA output created by 263
-==== NO CRC ====
-== Options: rw ==
-== Options: usrquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: grpquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: usrquota,grpquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: prjquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: usrquota,prjquota,rw ==
-User quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Group quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: OFF
-  Enforcement: OFF
-  Inode: N/A
-Project quota state on SCRATCH_MNT (SCRATCH_DEV)
-  Accounting: ON
-  Enforcement: ON
-  Inode #XXX (1 blocks, 1 extents)
-Blocks grace time: [7 days]
-Inodes grace time: [7 days]
-Realtime Blocks grace time: [7 days]
-== Options: grpquota,prjquota,rw ==
-== Options: usrquota,grpquota,prjquota,rw ==
-==== CRC ====
 == Options: rw ==
 == Options: usrquota,rw ==
 User quota state on SCRATCH_MNT (SCRATCH_DEV)
-- 
2.39.2

