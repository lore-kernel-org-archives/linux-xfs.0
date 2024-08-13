Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3F94963A;
	Tue, 13 Aug 2024 07:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534544; cv=none; b=UHtXoLqWsp1bxY3LnCMgXx2e5nQ2u7pHpd+OPvgiI7CfUn9gmECi8C3D6WeB9HT+beiE027Jj21mMdtKRMZ+P6daw/OlioNA/geZQi8evMtfNw2rAsXPE/Kivi5foSt6Sjsp9MxcKZ8vOCHQI84z27tGCEhCqziGP082sqZr/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534544; c=relaxed/simple;
	bh=2FZde+pUZgBeHZwaoH2zsOHP9Q/hy3y9AnPMHkP+Mm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvx428ve44Mn2MlBH+h9vtW35khAfDS1tp/cqmcuTV6/gtcjmGt0UhTySNUUfAgz4bz48w/LNV5ROZ4eHqcibdvy20lXGYapr68Dxfut9dedD0/Kl6l9uEAmGzJ7iYEnnWsmjbYP3Ku1TNiE/TvCDRhjx7QVciXYn+N57+cBRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PsQSc0Aa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PsQSc0Aa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X350blmbc117t9IwCTo6bZmZ616hrE18F1tAipccmm0=; b=PsQSc0Aa/xkaEgjABx8PFfpeP2
	iYLePXN5vl/1fqbLiaJnIKjCRrUbleK31XJXqqCLyCUzHUD02j9xgUGtdcrsKIjOhrIESyOTS8r9m
	OepH5Mxgnmiz+Q0Nn2pOvuQa2r/NeEjT1hAJ7uGwku2HtP9B1NFUBm5hIdxgw9WEfZolpWZc3LLHv
	HvGinSgHc2Me62lLdHc6Z0qrsJb3A6xCEKEB1lpUyOb/hvTRc64o9ShwAlcGaWPx62aqHDu45iIM5
	F0q9RTLEd2IIF8nBjVpOTfBgCW3hA9NJ7tV01BhV5m7hm8PA9JkwVJwX1nQ8KuJEMsb0n91gPr8Jf
	jeMg3yIA==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm4E-00000002kXY-0UfB;
	Tue, 13 Aug 2024 07:35:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs/424: don't use _min_dio_alignment
Date: Tue, 13 Aug 2024 09:35:02 +0200
Message-ID: <20240813073527.81072-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073527.81072-1-hch@lst.de>
References: <20240813073527.81072-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs/424 tests xfs_db and not the kernel xfs code, and really wants
the device sector size and not the minimum direct I/O alignment.

Switch to a direct call of the blockdev utility.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/424 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/424 b/tests/xfs/424
index 71d48bec1..6078d3489 100755
--- a/tests/xfs/424
+++ b/tests/xfs/424
@@ -50,7 +50,7 @@ echo "Silence is golden."
 # NOTE: skip attr3, bmapbta, bmapbtd, dir3, dqblk, inodata, symlink
 # rtbitmap, rtsummary, log
 #
-sec_sz=`_min_dio_alignment $SCRATCH_DEV`
+sec_sz=`blockdev --getss $SCRATCH_DEV`
 while [ $sec_sz -le 4096 ]; do
 	sector_sizes="$sector_sizes $sec_sz"
 	sec_sz=$((sec_sz * 2))
-- 
2.43.0

