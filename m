Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A1A79B9D;
	Wed,  7 Aug 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041322; cv=none; b=X6lxtVPzVM0Wm1hrmjSgxeCxTTASKKsZAGL+SkIiRtIeMpGqsmVqtPFLxlHHyg2pqIxNInbguiAH8brRFBi5TGwPKT0uejt0qC0i1qZb6Sa75zEXzNjGr+7WFF7gg8loykie+fVsS1tZDx0ipF5Iq3xHa2MKLl0y9uLEDkfQOv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041322; c=relaxed/simple;
	bh=h17+/WJGLJV5/wULG7PkHBc7ruCwd2PqY2JMmCMgx8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXoD9JlwoTW0iTjnp489trM7zF11JiWOFXEamQmI4d2whPCy2q4zTPES6M9U4FamdSnqidxBnk/cANdMC5tOGnrZShsBZpsx+tu5oRLzQ+TD9K9e8/vkjfB+ikXOG+ZPXSOBmiZPC3PmWXf/NVhSZ/Qry+gac2RPtNrquNffJ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u4RWQu1m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u4RWQu1m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iv6T2kM1Wtp/uR60PSAIr4Hx1JTleDiPuiKZ1vf/0n8=; b=u4RWQu1my8W0al9eHmTSlTjule
	HQzGD2VbfCVaOdaTOObtcAFx3byKpInvrb9lg95DV5057VHc9Ycd2pNt9np+D67+0+r/+MiLc+3gx
	pisoz6H5+RByzJ/xYENd2EMjNrK1blr3OkpsG9/xPC3z6uox37UpKTEzziLHwSAOgxWWh5KooYT+e
	xQ4ACorUDfSCqwWiZFPY012yYymCDQGTZVDtwOIwRS3IDwCDFsurovhvN2ky16l4uxMdIBs0IeGLx
	9pOtT+0cfWLtuDGQdjBaztjmZkKlW0OmJ2O9zBjy6ttKa/nLjk4VyXU7gWTpzQFIlcJxGsVzQne43
	1q+IXj6A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sbhl2-00000005M0X-0egx;
	Wed, 07 Aug 2024 14:35:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs/432: use _scratch_mkfs_xfs
Date: Wed,  7 Aug 2024 07:35:09 -0700
Message-ID: <20240807143519.2900711-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240807143519.2900711-1-hch@lst.de>
References: <20240807143519.2900711-1-hch@lst.de>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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

