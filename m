Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D0126F05;
	Mon, 29 Apr 2024 17:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410356; cv=none; b=PEDL24EdBYZg3ziSIcnSGQ8hNBJOumxaYhFbJnORQf4NFdICl9VRmphIUy+IrRNVbzu3RaZdE/zQfWFmH2kBiRgCt+w5zuU89X26d8fnoxnkVMI3Iw4A+96lArCqUC+QpAkxHboymGo1sDGBPbE6l0yjL+VNyHKikktVobkc+jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410356; c=relaxed/simple;
	bh=nRAlkUn9tdDoKGncbYFHI+p49s3ZqvElDUc5vC0PyuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U+GXj6fa33eToJ/Hd9TBAQtbI/Pxzd0AQECIJKsRrQqNXlYztL16nElm1zM9AQTdwKjiL8sqxXE06qKkG78ioMGMa4/LkXCOf9qCejdfrPnQjWgNGKmnjZ41V3e52wSBQBirb10MFAp+VRTaxxFAnkzjHGQuVhMq7BpMphwdmOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uQUmSATZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uQUmSATZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KSMOY4fVBarWT/23NhwJ/QmyFvaSRO0ynneF1qXWXRE=; b=uQUmSATZpemHy+pVVXjyYRA64+
	CImTjh+dfKdMPmln6gAxp1xToKzGX0i8l9ud/F4aYv5oqh9hmmR4Ff9wrTzHBCY9fTlbqspjl9Qtl
	P4xCuxJttIdU7dR+q/AI2Djjt3K3krF4BS8MBWVGQaleBv6H6rmWUrfEv7yLB0XFWoS8X5V6ZhNk+
	5Rafrn6t9R5atUaIhAHd+QbLpcQK60U8vSlyL98x3fextSYseC4OHn5mSQwBk3dJ/Q/0uvrmdnhwr
	21qQCMANlAO8xvpvWpt91P1Q6Mar6EEOsuUjS5WGzmDH98PbrZ0xBVHCPQrRL8ZQyZqQv4tTFIgIE
	Sr+5B+dg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1URs-00000003fXY-30Im;
	Mon, 29 Apr 2024 17:05:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	chandanbabu@kernel.org
Subject: [PATCH] xfs/077: remove _require_meta_uuid
Date: Mon, 29 Apr 2024 19:05:48 +0200
Message-Id: <20240429170548.1629224-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

_require_meta_uuid tries to check if the configuration supports the
metauuid feature.  It assumes a scratch fs has already been created,
which in the part was accidentally true to do a _require_xfs_crc call
that was removed in commit 39afc0aa237d ("xfs: remove support for tools
and kernels without v5 support").

As v5 file systems always support meta uuids, and xfs/077 forces a v5
file systems we can just remove the check.

Reported-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs    | 15 ---------------
 tests/xfs/077 |  1 -
 2 files changed, 16 deletions(-)

diff --git a/common/xfs b/common/xfs
index 733c3a5be..11481180b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1232,21 +1232,6 @@ _require_scratch_xfs_shrink()
 	_scratch_unmount
 }
 
-# XFS ability to change UUIDs on V5/CRC filesystems
-#
-_require_meta_uuid()
-{
-	_scratch_xfs_db -x -c "uuid restore" 2>&1 \
-	   | grep -q "invalid UUID\|supported on V5 fs" \
-	   && _notrun "Userspace doesn't support meta_uuid feature"
-
-	_scratch_xfs_db -x -c "uuid generate" >/dev/null 2>&1
-
-	_try_scratch_mount >/dev/null 2>&1 \
-	   || _notrun "Kernel doesn't support meta_uuid feature"
-	_scratch_unmount
-}
-
 # this test requires mkfs.xfs have case-insensitive naming support
 _require_xfs_mkfs_ciname()
 {
diff --git a/tests/xfs/077 b/tests/xfs/077
index 37ea931f1..4c597fddd 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -24,7 +24,6 @@ _supported_fs xfs
 _require_xfs_copy
 _require_scratch
 _require_no_large_scratch_dev
-_require_meta_uuid
 
 # Takes 2 args, 2nd optional:
 #  1: generate, rewrite, or restore
-- 
2.39.2

