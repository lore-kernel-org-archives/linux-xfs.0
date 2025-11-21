Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785722F1FD1;
	Fri, 21 Nov 2025 07:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763709032; cv=none; b=sX4TGvZK/erlqNDM/xaHXtMjiMHdI2bP9GH2Z2dQQSqphrFMYh5lpM2CTXQyJ1BFkf8uFxUfWLGzdIEkfoVtn5ysasXSqOUVJPKJ6q+OxtrH/o77cFDOhG9HKNay4kJXRceY7uJXGyn5QZb97LgI2h0IquQIWKcpsqXoS5HCXIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763709032; c=relaxed/simple;
	bh=9mlWVr9MZWkFKQpy3Hx0V1OLd48azl/B2+CdQPIllfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmu5Xt13uB1pfuiKzI91vQ0bGymTKZbqPeWknnWFzUJ4KEPf4nQc4NVOiwTBTNQBUsqC6963bVtKM7m71Z9/7PqfFRE5Qp1LBVYkUpxbEu6RyNkjycX6xM3GUn51s7YVcKSpQl9c5NeOxYRBOsDaB4kV6+ulm19pJNJrMjxiMC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d4Ua8UOi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4Ua8UOi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mHt4j+BoecuBjCV3FqandbZnSNBLPTBJOZOf2lOKZns=; b=d4Ua8UOiGet+r1bobZECH+BU2h
	F7JsXEx2GzogUoFapFofBZPsymSmxAVBGOXCJwRuGUjSWFYF+5K0k24uiGkfrqY1lWoHosIZpbB2q
	kelrf0XUW4XuPtOQubdjlz27CN1QpfE4zWhN9n/kyNIIoSPbuLddA3f/GTb3ontu/28mIxxL0swu7
	aha+LV1bHeKHtgr83W7/4Z9itf90Gxq+yrrnfo/Au9cfIGaep1f3TnzZ3A8kNtl7iTFp3QnuV8VDV
	P0LgFl8jRb9CVsY6qvHLwagn2vOIXe3SLgVnYZrj9y8sXn0ZGg+MUMLMWlRlsg7jm2QernDuggZlc
	IKH7+StA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMLHq-00000007xD4-2ss3;
	Fri, 21 Nov 2025 07:10:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs/158: _notrun when the file system can't be created
Date: Fri, 21 Nov 2025 08:10:07 +0100
Message-ID: <20251121071013.93927-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251121071013.93927-1-hch@lst.de>
References: <20251121071013.93927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I get an "inode btree counters not supported without finobt support"
with some zoned setups with the latests xfsprogs.  Just _notrun the
test if we can't create the original file system feature combination
that we're trying to upgrade from.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/158 | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/158 b/tests/xfs/158
index 89bf8c851659..02ab39ffda0b 100755
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -22,12 +22,14 @@ _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
 	echo "Should not be able to format with inobtcount but not finobt."
 
 # Make sure we can't upgrade a filesystem to inobtcount without finobt.
-_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
+try_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 || \
+	_notrun "invalid feature combination" >> $seqres.full
 _scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
 _check_scratch_xfs_features INOBTCNT
 
 # Format V5 filesystem without inode btree counter support and populate it.
-_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
+_scratch_mkfs -m crc=1,inobtcount=0 || \
+	_notrun "invalid feature combination" >> $seqres.full
 _scratch_mount
 
 mkdir $SCRATCH_MNT/stress
-- 
2.47.3

