Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADAE632;
	Tue, 23 Jul 2024 00:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721692847; cv=none; b=gXifj1oNsLJUgu4DiwX3TB+AG0QE8PWlEXV/JGy0ln70Qjf4bHck4hAq0OA5ZJOz1Ccmvq2pA05F5BT82M3/oBz9pUWriZwOqGCIzfsdatAaC1F3B7+M13Gd2deHYpIB3SeqV2gx8rmjINsw4/H8O4zKEuWToDUC19VSOsk000k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721692847; c=relaxed/simple;
	bh=/Yko/ql4N1fsMBhF0kzrRIWWl1hlSzvU9/LkCUbe200=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXFf3lpB/+vWXMr4DwRDcs3/PERUTXAnvqgZNteLcsoLI1aeYXkaqrCHSbEvJbegXC38XJkXgoMUt1XEeogImMWC4ENDeDoT+qLQ6XoUBduNywTuOwKVYJNWWUwbwshLzR6PMmkEbYoqvR/t7QsNurJopVhW76rrhed6f+j9kr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1ZHaCGSZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1ZHaCGSZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GhUm3ZKmg75RN+A4QnHjLza+V7z3j21ecH6S3Qm30e4=; b=1ZHaCGSZfC9tKfdGQrLEkRjjTZ
	zBfOnp34MizI4P6cZsR15ZENGuQSLIzNIVZbB6tip6Sr0oWMpQ2v3qnorcVwzmqu7WUDWO7LyZQZ6
	KsgeNnnRgZZ/A502bWixIw+8N01N0050o6gIgP6ZQsy9PrJ/hSUVNYiAfNLnhZya8D0MgJmRnObBu
	OVbc1xw6jICRfXPR5C3r5Q/CEU6rtGakrvOj+oboDwB/tSoF7p7E2lt4Z4nFvCgw1hfyAA7ZLhfMm
	KAq5Tz4NOjoHFLtTJx5RTsMJV2vk1z/1ezCXIPt27UEIC716fwfzdymRcU9l5DVrwiI/RqQUabO1/
	rxc6mdmw==;
Received: from [64.141.80.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sW2xR-0000000Aums-0zmu;
	Tue, 23 Jul 2024 00:00:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs/432: use _scratch_mkfs_xfs
Date: Mon, 22 Jul 2024 17:00:34 -0700
Message-ID: <20240723000042.240981-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240723000042.240981-1-hch@lst.de>
References: <20240723000042.240981-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use _scratch_mkfs_xfs instead of _scratch_mkfs to get _notrun handling
for unsupported option combinations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/432 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/432 b/tests/xfs/432
index 0e531e963..52aeecf2b 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -52,7 +52,7 @@ echo "Format and mount"
 # dablock.  33 dirblocks * 64k mean that we can expand a directory by
 # 2112k before we have to allocate another da btree block.
 
-_scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
+_scratch_mkfs_xfs -b size=1k -n size=64k > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
-- 
2.43.0

