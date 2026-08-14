Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A015D45D1A7;
	Fri, 14 Aug 2026 09:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699575; cv=none; b=CMOy+K8mTgr+gk0dlSjDe5bjfoMR15wqCHxsmJGP14BRZZqU8x56FyoKdD6Q1xCIQs6Qvp91+GBKMPq74XLlRzs86JKtjQ1cHAfInVlnjs8FweCAIfncpKIxMu1JnhGWwKPFDihdqAzsltc/rtlRQGgT0FELfgu6QKjDalfJ+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699575; c=relaxed/simple;
	bh=hCJ8tfiXHMQmhDIXtIFt5IcQ04vnHmL88yoRYOBwd9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhOSUnxGTnMXZ05Y9kflvZojeX1bLmfrNC4iQHbn0HijFpSZ/w+hHnFXrncmz7cSZdzZCyxa3RIj/4W/pSrZxmDMGQzUrC1Y8P4DXaBTPIwgiILmi4iOx3t2Q66u7cGcAJz2wrinDp6irj1o8XXv/tlqbbnHh+ExMV6daq1WriQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N03TDZZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N03TDZZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBDA1F000E9;
	Fri, 14 Aug 2026 09:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699573;
	bh=thIo2/1hw+ojTe/xNPHRiyG1yeQkk5de3ZJFeVRsmoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N03TDZZjfpmiLarfDYDPPQ2E62dA1SuD9+t9GRO1owqNunKTQGbfV9BQUsXG0AM0E
	 bSEcfG+CsnhVqcoFHtwi3SCEhKa4QJWcN1px5Qv7yN0+P2DNyNK2yUcnNAW99MZI5N
	 5ZZl3zkncKliQNAq/IEun1j8zPYNrKDDovMxkd2+PKwpX1BklwvBqarRAdWmY1qANx
	 0RO0vC3qAHiHl43pFH41RqL6nDt5INwvFOrycEEVfm7mWul2se38jQL+gN58mxknCK
	 Aaz8SRNdG/wPeH9EOQKKcFeOUWygRYIaZ77oWkZQ5Dl/T9aKMflObVGt04xuMwux66
	 FySW+bq/tcBWg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: djwong@kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	david@fromorbit.com,
	Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v15 08/25] block: don't delay bio task completions
Date: Fri, 14 Aug 2026 11:24:25 +0200
Message-ID: <20260814092448.1818082-9-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260814092448.1818082-1-aalbersh@kernel.org>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

The delay causes a more than an order of magnitude slow down when using
it to defer the T10 PI processing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index f228940d6b42..79fb94f85a5f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1811,7 +1811,7 @@ void __bio_complete_in_task(struct bio *bio)
 
 	if (was_empty)
 		mod_delayed_work_on(batch->cpu, bio_complete_wq,
-				    &batch->work, 1);
+				    &batch->work, 0);
 }
 EXPORT_SYMBOL_GPL(__bio_complete_in_task);
 
-- 
2.54.0

