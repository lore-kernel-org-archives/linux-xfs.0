Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0E73A8F8;
	Mon, 22 Jan 2024 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705922607; cv=none; b=hvuEG/8WXHOZkBEynFM04zFGRuUoJ/ya/eWJ6yp4fNC27XpPzMfPgrz6Wb+5o9x1QNeaaFuMIm2J20wF+1k6W9KenwbjLdfTb8VgJfXYcclKwXowSvfVeQijNpKMvdw5rOvlEzFX9MfmD9nivo6DgDiHZiGLYB69TyEEFqId3NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705922607; c=relaxed/simple;
	bh=PiUmTtv2IoF65WRKvnZQqdzdx384PUXh7bL5OeVPJXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBkGcN5xbBWvPg2Q6itFf2pwN3XDieWahE7BHkqZ/cmdtnTokdeIGoYxddvfvCDimqaXDuvb7u/WzWDxprudrwfARd4Z65xIn++81FuCrxYEMzOCj7oUg3G+ASpaEp8eRfFlgE12F8OsrWVLVl2qwt6Knfg1X9mWWLQd+65H9RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=NlkjaG/j; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="NlkjaG/j"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4TJSPf5D0Pz9srx;
	Mon, 22 Jan 2024 12:17:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1705922278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=huwGaMaY18xKBkOb1PiQY/4FgecT6Di7SqBOr/x/ZPg=;
	b=NlkjaG/jPoF+kH+HhqM5SH2zptGxJHz8/LIc67vGeyu8D2EgdcGIsS121GvRWeIj6fdBHE
	WDwbBVnynwrjagXjP5oWYNtdRo84tLMRp8+Bl9gTz9kOB2qoMc5O4d+LGwfwU8tELegS3i
	vAqNj/y2nLU5MQ/eO2WD78KDOMhrdIDnySfG8QOYhDylT/MtxyclNqfPNZwajwQPeA4NMV
	IQYUGi5IqriBW7SbE6o2fD/ES2ibHik58AJbjV6OmL7HPNj5Itp7QS7c6oC5z0Sm7fjF3j
	WR34Mr2n/RG7t1X1Kb3gr5e4tzzbey+0cwboLmuuAPJYhI30j5fdxuBDxGcXxw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: zlang@redhat.com,
	fstests@vger.kernel.org
Cc: p.raghav@samsung.com,
	djwong@kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs/558: scale blk IO size based on the filesystem blksz
Date: Mon, 22 Jan 2024 12:17:50 +0100
Message-ID: <20240122111751.449762-2-kernel@pankajraghav.com>
In-Reply-To: <20240122111751.449762-1-kernel@pankajraghav.com>
References: <20240122111751.449762-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4TJSPf5D0Pz9srx

From: Pankaj Raghav <p.raghav@samsung.com>

This test fails for >= 64k filesystem block size on a 4k PAGE_SIZE
system(see LBS efforts[1]). Scale the `blksz` based on the filesystem
block size instead of fixing it as 64k so that we do get some iomap
invalidations while doing concurrent writes.

Cap the blksz to be at least 64k to retain the same behaviour as before
for smaller filesystem blocksizes.

[1] LBS effort: https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 tests/xfs/558 | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/558 b/tests/xfs/558
index 9e9b3be8..270f458c 100755
--- a/tests/xfs/558
+++ b/tests/xfs/558
@@ -127,7 +127,12 @@ _scratch_mount >> $seqres.full
 $XFS_IO_PROG -c 'chattr -x' $SCRATCH_MNT &> $seqres.full
 _require_pagecache_access $SCRATCH_MNT
 
-blksz=65536
+min_blksz=65536
+file_blksz=$(_get_file_block_size "$SCRATCH_MNT")
+blksz=$(( 8 * $file_blksz ))
+
+blksz=$(( blksz > min_blksz ? blksz : min_blksz ))
+
 _require_congruent_file_oplen $SCRATCH_MNT $blksz
 
 # Make sure we have sufficient extent size to create speculative CoW
-- 
2.43.0

