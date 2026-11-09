Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219919;
	b=QRZE8vG4KKcfb2Aoby0n9/RDsVCQFahLv8KjFJW+2UzdHw4qVJCZyIt1y1htxxmNaqPA
	 No8+4epxW9gGEOzO18mDq1oUb1ar6+ztPrMCjOipBBsHZf4AJbug6imswJ7jt2FCwKyXf
	 oSJutg2n7Ni66loj0Gor7LUpkP9FrkZZD5NzzJfQInld9QovnDjcWGKZjeKyCwSXZH4xf
	 0iL42nLnK7R1mEpt86Ugbx5MkmgXnZkbyJeTgRNHO1r5XdkQ6/zjk67ssCL7+cnOV7eqk
	 mmaix2dPgMEaqyrA3iWOJu83GCwuTWZ+lDKbuZV/i6nT0b1d2NYbGBjkQ79wvKH1gyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tjrSbzr6BWFTGpfzCm3oT2gbuNz6OTHoqKNmzC/G+NY=;
	b=BnXg+sP1GmtDT5pP52CQTQY7+G5wknJFGlJjzCbC/DOD/oRs6Lpv5yaIO1NHdai8vooN
	 jdrJ8xvRfhTgDEZTZVKdMW5HLN+0yVcDNiGy4E29Dkt7qjZ1CGRkAxIdc1LWo/+p3z3qD
	 a2asUmbFr/aomsgHxoTWievutEtUIp3wvuFPa9/1clTYeFwmdalwckonlqHqiVvUuK5If
	 XxGJrmVRAserecZfuqeDPUP32IvwUR5mBtFvt49WmQqkWQ60z0PeiG9DKK5Dgvbdk8bPa
	 O+03YpjyH+BbgiIDvsw2mRmOnoTrhjyTJ1jQFjubOWVpK3IW6f4pYPFurXj+SYbfefA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKrxgv7H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B7D606A31C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKrxgv7H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780021F0089F;
	Mon,  9 Nov 2026 10:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794219918;
	bh=tjrSbzr6BWFTGpfzCm3oT2gbuNz6OTHoqKNmzC/G+NY=;
	h=From:To:Cc:Subject:Date;
	b=mKrxgv7HH7DA1xnRowxqaSB2M1U7j6tpkyyzREB229iHmXhCnrnRztcfVvYW9HGHL
	 +vxF7mZvSCc2NJEJ3sH1Uu8MhHOVE3Gcy11CH75S8PzZTLEGm/qywuB0u9z778We5D
	 Ce6WwOOLTUGwTnPHmtA/BZ6noTkCnR5hqFQbsv/OTRXXzGEVJmwEFsmpIN7OWfLsyY
	 ae2a8xYEQueB7AdD2DViZu/ZyuWZG3wiHCc6PWUrRbhbgAyaj7D/Q0wOmYF4TV+8+B
	 +RnzvkvrOFqd1Ct9uZ6ZwVIzPgx5rYKWaUYEjIIzEosZGoW1WAackm00LabLOObQqw
	 zMpzhNkeGf/fw==
From: cem@kernel.org
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: [PATCH] xfs: remove redundant extra assert from xfs_zone_gc_query
Date: Mon,  9 Nov 2026 11:25:01 +0100
Message-ID: <20261109102507.262283-1-cem@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

We initially assert that iter->next_startblock is lower or equal
than the total blocks in the rtg.  If we are in the later case
(next_startblock being equal to blocks in rtg) the conditional
right after the first assert, will jump out of the function.
After the conditional, the only remaining case is next_startblock
being lower than the rtg block count.  So the second assert seems
redundant to me.

Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index cea5447a886d..00644d997963 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -337,7 +337,6 @@ xfs_zone_gc_query(
 	if (iter->next_startblock == rtg_blocks(rtg))
 		goto done;
 
-	ASSERT(iter->next_startblock < rtg_blocks(rtg));
 	ri_low.rm_startblock = iter->next_startblock;
 	memset(&ri_high, 0xFF, sizeof(ri_high));
 
-- 
2.56.0

