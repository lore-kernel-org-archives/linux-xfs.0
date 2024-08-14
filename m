Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB0E365;
	Wed, 14 Aug 2024 04:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611164; cv=none; b=dxsYZalFuSeWbWASax5U/+DtEcU/ZgVf/oXcKo/ggOUXt9MSPlIn/uJf+8bhoPDJnzaD7MmjTQOcEnth/3GtdeyeFLgKSmJBW7OgYUM9PFN6oA9z5Shg+yVj5dw9DK6F+NuHc5t4Qkd7Pnx1OFWPzTIpsG97f3vw9qvYYjy4W0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611164; c=relaxed/simple;
	bh=qURh4udtWLx2eWmooYHUzlJr3khUAMBzMrBdrjSWslc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BShSWfU8IdrEQ4b7wtkNxuYMcQT9VLw1dYl5pGrPG6x8jehsU79cKUclJKh1hhNM3zJ+arUT4Oka+gmz89tgvOd+K/rdi7Cv7u4Nofokh8MgDgrXaNfxMyVeuUJ/zG23IbMQ0nFt4OgI20ZAVWXxH1gxOIc5wrJQ9EtZSXxQaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RnVTWoG6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RnVTWoG6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hlLMrK+oNVnxSLbS4HRtVzrPilh6/SH3BRRUajstIug=; b=RnVTWoG6s1Y7qwwTF1Xgzica7X
	I5KRbO34qp4nnEiXaxoIQ2CFbWdW3aTsEviDVJb+tQe1LHb3CVAHA87bT+GwK0wOmVo7o62/yYJgd
	oznmF5r7aY93RntouuRVCHmVc69DEhxLWcXnE/r/1NOx/J63mG2IC+R0KaFdFWacRstz2I0DoHUOT
	uzi/83W1KWZWDfd7Q6vByRoWSEAy1OiT/0VA08iwrTlKBlrSC4DWC8ykOd994otYrbBkcUZsbsZ6A
	lQE0D0Vz2a8AwLm/1XvT6dRQwjTzNhNlwNsXqk7HxQ/8k7utP0Hoh2P6lqfhBIBR/RiLH395kvtvX
	I/qZj3dQ==;
Received: from 2a02-8389-2341-5b80-fd16-64b9-63e2-2d30.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fd16:64b9:63e2:2d30] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1se602-00000005jMc-0KZy;
	Wed, 14 Aug 2024 04:52:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs/424: don't use _min_dio_alignment
Date: Wed, 14 Aug 2024 06:52:12 +0200
Message-ID: <20240814045232.21189-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240814045232.21189-1-hch@lst.de>
References: <20240814045232.21189-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

