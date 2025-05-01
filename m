Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071351D95B3;
	Thu,  1 May 2025 13:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106995; cv=none; b=KL8PTH/24fJTVrPSmVO2R3j+Jv5qfX7Y7M3Qofo/MP/nhi1dfGgJzDUqhIh1q41BitpAT6lyaebMFALfj/Z/VI7S8ZGgVqoHA8684V0Sez7HxDlLsmzpEj/fwmiqhOIYck2+JiyG7FollJ/nj4oFoxadRSOMneAiD8DH0Y5lIAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106995; c=relaxed/simple;
	bh=lmkdFV9UBRdtL/vWBf8kzxCUeXZbcATXCnR+w7GYJbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0pEeDQp1kzatQBdQibZ2xpv4RO0J9jr7IjCX47ABfqJvcjEHP8KUxVTn5Gkymx1j55Xohoqwt1YCIwEg1xp41KBVeZaPbQ5h+L5wp8mDGHcX+rU93fhXlCWlxxt5H3UmnBNOwouWY2mKu1ikXp4SMBD7Rg+BpHXeK4edM6zdUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2rpnTpX0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2rpnTpX0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NkKvPPlxNJvbMAjDGdsw/8pypK0w4Hw3a2ftzuaePfU=; b=2rpnTpX0oCf53lKNYo3twKt3Hx
	SeMNA2wnS2scRnyzbxMyFZebFf9p30RyapYjuNnHT7A35eY6LbUNNr1B0+adNDbqgCRC/Y0OfnKEM
	Jymnkod6h9pcSpnVEmAFa2AFQ0hGUfzypamrqgZqU07XARH8CNa3uf2cOzf/YjKgOQVWrayg5saMb
	wjd1HoFgvCKiyTgWzbz/Ad1gFtVLBa1MNMqYzZpRV8XvZnmd1kCuORY1dGYi1TzGZv8G5cD6XjOSg
	Li6h3v8ol2o1T1sPe0xhoSyIwY6NCpnSzFwu7JuWuVOhgfoFMpvjMNaqoGpoeDlKzaDhS6/FdXETf
	/Upo2xZg==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUC1-0000000FrTA-2KDS;
	Thu, 01 May 2025 13:43:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/15] xfs: test that xfs_repair does not mess up the zone used counter
Date: Thu,  1 May 2025 08:42:50 -0500
Message-ID: <20250501134302.2881773-14-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501134302.2881773-1-hch@lst.de>
References: <20250501134302.2881773-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Check that xfs_repair actually rebuilds the used counter after blowing
away the rmap inode and recreating it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/4212     | 32 ++++++++++++++++++++++++++++++++
 tests/xfs/4212.out |  5 +++++
 2 files changed, 37 insertions(+)
 create mode 100755 tests/xfs/4212
 create mode 100644 tests/xfs/4212.out

diff --git a/tests/xfs/4212 b/tests/xfs/4212
new file mode 100755
index 000000000000..f392a978c7a6
--- /dev/null
+++ b/tests/xfs/4212
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Christoph Hellwig.
+#
+# FS QA Test No. 4212
+#
+# Regression test for xfs_repair messing up the per-zone used counter.
+#
+
+. ./common/preamble
+_begin_fstest auto quick zone repair
+
+_require_scratch
+_require_odirect
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/test1 oflag=direct bs=1M count=64
+
+_scratch_unmount
+
+echo "Repairing"
+_scratch_xfs_repair 2>> $seqres.full
+
+echo "Removing file after repair"
+_scratch_mount
+rm -f $SCRATCH_MNT/test1
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/xfs/4212.out b/tests/xfs/4212.out
new file mode 100644
index 000000000000..70a45a381f2d
--- /dev/null
+++ b/tests/xfs/4212.out
@@ -0,0 +1,5 @@
+QA output created by 4212
+64+0 records in
+64+0 records out
+Repairing
+Removing file after repair
-- 
2.47.2

