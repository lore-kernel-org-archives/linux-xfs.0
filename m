Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943C155330;
	Fri, 21 Mar 2025 07:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541738; cv=none; b=t3fW4CThvECCCWuDecPSyfaUqCLTBYXDniu7594UjNNXFEZ/2aH3pRFkgem/GHnMx+x/Tz6odrAvNMZjTCrlep+yFBqwYmhEbZgnST2thi/PTxV1HM7xsABJ93CREFVkEyK5Y7b/GHymkcBb/cQYcwCy44eHRTxeBYCmVq7LmzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541738; c=relaxed/simple;
	bh=PRaUocvBneQoZ3CEqjrO86YcgJlFKEN0ETfA9TeeJvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rN6HsZ+o4wWGNm9AFyho7WQbk/mv4JZf3VKpYOXWu5k3f4UPkzc+EVUC6Ivc2naQc+EzlchogFTr55WCBvIfPuXJNCzQYisHuHLtoIC8lhZnZhVnGpoFR4NYw50dAdu6oQutcMBxkves1h7lD+fScVDn5JLqD4F41uZb4+TfK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B1/b43u9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1/b43u9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DWT4a9sY90ntfuGNW1hk7oQu9RIzm2alMhRW3WHtTbc=; b=B1/b43u9s1WGCZlvXo7h4iqp1g
	M+8DrJxf4UpKnS0dDrSIDdwlGD/zt3JIUH0R4ZBgze7lcWYhZRyKzlL1nx0FbMaEXdsHje+uaItww
	XYjs3//8Kpy+0+oRoNWp0ec+klm8J7sFhrAQSVE7vLrezynj0dWGGwwFZC8F1DpcnsyVFc94mAdpS
	FyHxzvPfCNPyel30Hj8mO5xtrieKCS/xN84bLoqqhYY9LhmRkf/yk0zfk1b2IhT1EU5LWsFBDAizE
	PrbC5AsJVuuRPvxgyyNnHpfAuJg5jOjxIVp1V/0jmPiDwYAu30GZXo9PviXUR9jprKcMx2zvAIs4V
	5PEh97lA==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhs-0000000E5Kd-42Bk;
	Fri, 21 Mar 2025 07:22:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/13] xfs/049: skip on zoned devices
Date: Fri, 21 Mar 2025 08:21:41 +0100
Message-ID: <20250321072145.1675257-13-hch@lst.de>
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

This tes creates an ext2 file system, which doesn't support zoned
devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/049 | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/xfs/049 b/tests/xfs/049
index cdcddf76498c..07feb58c9ad6 100755
--- a/tests/xfs/049
+++ b/tests/xfs/049
@@ -40,6 +40,8 @@ _require_scratch_nocheck
 _require_no_large_scratch_dev
 _require_loop
 _require_extra_fs ext2
+# this test actually runs ext2 on the scratch device
+_require_non_zoned_device $SCRATCH_DEV
 
 echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
 echo "" >> $seqres.full
-- 
2.45.2

