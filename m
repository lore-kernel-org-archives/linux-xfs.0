Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9D1E2834;
	Wed, 10 Dec 2025 14:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765376617; cv=none; b=ishjLHB+ZFB7IZO3I+STplpz/Vfiav2oq1RtCiitmMhbH2OEaTDSJqLQL6RKuJWFk+09muWBckDTTzUeHBOqiWIfuyglLMXKmyLWh0O10TPWg6FAn3nxph1wnox8IoQrCvjU14Qp/9w4sS6sNJ7nqw6Rhs7QziGtanc+N3HO04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765376617; c=relaxed/simple;
	bh=uftJp0SjYVU3v4DhrLE7H7jZW0mCAFbN/VKtot8X/QU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s115leRIlA7AIr379xYNoYr6ZfdJ928eZdGbDGCVryEHlEB/qVgtERp1Hj13wNsVzhXPKx/eZtPOOnZmaZZDWknEsLIa5dyXGB+V4n+4EabZJrE3GQBz2dT7H17ADm7+h4F/P6+pZa/WqhiJHoLQaBrDMVKKIyXMe2CF+WVzTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hQLEoCZq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hQLEoCZq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=FOnByAd8/jO/QdpUaZu+xZQXTI3fn1aXPAt+vnDQ15s=; b=hQLEoCZqMjWUvnhPRooktW5gv4
	7cE336TqnmERMUllXwPU9P4EU0xfeitOjDbuWcDdmjmHE/8qm19wZSoWMxAe/KOQLd41KTGKokrZh
	G7uU90n7cdAjtNh2jO3Q6IcYmJiNkvNe4eaRAie+0HDy1CnnCxUVYM/uYWyeB61vqkSSEAYHsAqA8
	cyPnUCWwofJxuK43PHbltaZ8xBWOfekvbwkFUxJ2wWJBC7Hx+E21uF8kdWSkl5zSvDeEqeJVVCM2I
	hPGxDnRAS4RNtFxeWV4ieNkTJCXxtc5EVS1NP3eDHyzm4FMCPYh6vvtFkQSth8ZU5rJH0jZYxYg+i
	i+Mpg5qA==;
Received: from [2001:4bb8:2cc:a2a4:c4df:8bbe:2b62:c9f4] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTL6L-0000000FWEg-43W2;
	Wed, 10 Dec 2025 14:23:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org
Cc: djwong@kernel.org,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: add a test that zoned file systems with rump RTG can't be mounted
Date: Wed, 10 Dec 2025 15:23:30 +0100
Message-ID: <20251210142330.3660787-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but the kernel mount code did not
verify this.  Instead such a file system would eventually fail scrub.

Add a test to verify the new superblock verifier check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/651     | 27 +++++++++++++++++++++++++++
 tests/xfs/651.out |  2 ++
 2 files changed, 29 insertions(+)
 create mode 100755 tests/xfs/651
 create mode 100644 tests/xfs/651.out

diff --git a/tests/xfs/651 b/tests/xfs/651
new file mode 100755
index 000000000000..3aef7a1d016f
--- /dev/null
+++ b/tests/xfs/651
@@ -0,0 +1,27 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 Christoph Hellwig.
+#
+# FS QA Test No. 651
+#
+# Test that the sb verifier rejects zoned file system with rump RTGs.
+#
+. ./common/preamble
+_begin_fstest auto quick zone
+
+. ./common/zoned
+
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+blocks=$(_scratch_xfs_db -c 'sb 0' -c 'print rblocks' | awk '{print $3}')
+blocks=$((blocks - 4096))
+_scratch_xfs_db -x -c 'sb 0' -c "write -d rblocks $blocks" > /dev/null 2>&1
+_scratch_xfs_db -x -c 'sb 0' -c "write -d rextents $blocks" > /dev/null 2>&1
+_try_scratch_mount || _notrun "Can't mount rump RTG file system"
+
+# for non-zoned file systems this can succeed
+_require_xfs_scratch_zoned
+
+status=0
+exit
diff --git a/tests/xfs/651.out b/tests/xfs/651.out
new file mode 100644
index 000000000000..62617d172811
--- /dev/null
+++ b/tests/xfs/651.out
@@ -0,0 +1,2 @@
+QA output created by 651
+Can't mount rump RTG file system
-- 
2.47.3

