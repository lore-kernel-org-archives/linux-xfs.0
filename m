Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6CC1E9B1C;
	Fri, 21 Mar 2025 07:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541714; cv=none; b=mvhz9CBIoj1CVcERoABZB2cQtTecr5XSpRrpohx6DQJAFht+UeVKRwxL9cqOVEd6+gkAHKlRu56n5T60gGvK6P4c3bp/DwOKylJ4hKepuMdnW4R5rF/bQUjFe1X/NC3pvZjXETvVU/dxZq+sMEkxjXzt88wYLWMkIqdGpH7NHAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541714; c=relaxed/simple;
	bh=QoLKG4HJoTNYDYtiqinh04y3RzUrM/UWx2FU2/ku1pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVr6X/HOHJ6owP/cSqS4D55KS7qJliijC0C3MyvKcLh0R4w5Ia2Xm1iwBcIvi3amC8Sz4cRfEpM3I+ahj0Zw9q4DcZacgIeUBxd0ASASi/faWY1GLDTlunKG5VJTTiunX3rmE90N+9+2ViX3nKhfb4OrPMpfL0MP1LKmZsvUgu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DzzQ3EJ7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DzzQ3EJ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GFudg3xupFpSk820Mdao2PuErBaH67XXgplHHmlT81Y=; b=DzzQ3EJ7aau7grW7T97swCU+eD
	C2NMha1PaREkDJ7ZCZzCM5YdL2NjobBfs4aBrHH3tQo1Fsw5AsNqQjyikluGkKU3LzZUhpxwHDCmC
	oE2tBg9VUI1ap49pTsUw3qRHWNHvcdLjigDWWJBRawdi1rLm0UE7HfPmjjic5zXhlHxHmPny8OFiV
	01ghDjxeTD0+T5E/pQsmwdTxpOMIHbfgaNLp0GXOWkvj7NsDL3JXzOv/sF8a6BWXiL/+igJp2UrfY
	y1w0rokHKYOWkJc4bEcImpdGPCZLdDdKS5pK+26uE+/2dFB6h48aEwlOdNZx12Si81j+sYOhzPuNe
	xotz3tng==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhU-0000000E5BW-1rek;
	Fri, 21 Mar 2025 07:21:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 02/13] xfs/419: use _scratch_mkfs_xfs
Date: Fri, 21 Mar 2025 08:21:31 +0100
Message-ID: <20250321072145.1675257-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321072145.1675257-1-hch@lst.de>
References: <20250321072145.1675257-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So that the test is _notrun instead of failed for conflicting options
like -r zoned or specific RT group configurations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/419 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/419 b/tests/xfs/419
index b9cd21faf443..5e122a0b8763 100755
--- a/tests/xfs/419
+++ b/tests/xfs/419
@@ -39,7 +39,7 @@ $MKFS_XFS_PROG -d rtinherit=0 "${mkfs_args[@]}" &>> $seqres.full || \
 	echo "mkfs should succeed with uninheritable rtext-unaligned extent hint"
 
 # Move on to checking the kernel's behavior
-_scratch_mkfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 _scratch_mount
-- 
2.45.2

