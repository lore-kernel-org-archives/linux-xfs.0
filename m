Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987021518A;
	Tue,  4 Feb 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738676836; cv=none; b=U1tpXt53WBCzH7gNkeAbnRgXNfOwbxxlN1+sFLyaN1CF/UKDG1cQ29OmSQ20D9cfkrTHsfgyIlz1/rEc3LGMwNReK/coYz3RdctotQP/Htyy5hT8XwqhWQ2AfJ/AqMcFsiDKe8DofkfhJtIiykgw766KKV/09yv/d+AlNcK44o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738676836; c=relaxed/simple;
	bh=EkMyI5nvOIEDttjQKfPJXwj//9RRz3E7JaDMaNSFNUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HefpDAGAGZGfXF0kBDDJ0yKLLyPf7wF2piJsuaVEEeXiUw9y97V8TTCpErd/R/ybK9R3UfvmBOoLfsQDDDSBM+5FeXVgMKDKjQHJHPiktaxTGlMnQSpN5Zt47ETX/FQO6vdBH75AEc1XfKeJq//fpEemd+qvA15fFJLUyPQCFvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IBiYewqi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IBiYewqi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5EobIW9T8WZQJr0tt0p9YlY+MRDsQTrn0Jc+dXrME0E=; b=IBiYewqiW10vQyC1IFgIVENWx6
	2hJkjaN09kQwy51S93y61kBnCG2cxWkJEM/5b6a5KnXcz1xLvUmXiWC169fkKSylPUw60LnGbATiu
	5uTRj22Tc5LQ5HR5iJ85tJfiMqpvQ3RJRbreExXvBlr2Lmi3udZ+7mDq1vLftmGC13f7nPzvQ5iVJ
	pRATqYDB0FhqJ8EoD2R+Sgg+9bqa1w7SXVlD7b5FZa7eUCpWDyImNefWaMIsbwGpm/21dbewB2SPT
	Uns31CRrgl8son5fRKmYWNi9DcSoqFsbCHCqEDu0Nr/gyHnDq50ENb45pzL31k1dpcJJU6/pXCJ8l
	/CMkYYlA==;
Received: from 2a02-8389-2341-5b80-c653-ac45-db09-df54.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:c653:ac45:db09:df54] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfJGj-00000000Zcv-1Nf8;
	Tue, 04 Feb 2025 13:47:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: zlang@kernel.org,
	djwong@kernel.org
Cc: fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs/614: remove the _require_loop call
Date: Tue,  4 Feb 2025 14:46:55 +0100
Message-ID: <20250204134707.2018526-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250204134707.2018526-1-hch@lst.de>
References: <20250204134707.2018526-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This test only creates file system images as regular files, but never
actually uses the kernel loop driver.  Remove the extra requirement.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/614 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/xfs/614 b/tests/xfs/614
index 06cc2384f38c..f2ea99edb342 100755
--- a/tests/xfs/614
+++ b/tests/xfs/614
@@ -22,7 +22,6 @@ _cleanup()
 
 
 _require_test
-_require_loop
 $MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
 	_notrun "mkfs does not support concurrency options"
 
-- 
2.45.2

