Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F501E9B1C;
	Fri, 21 Mar 2025 07:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742541716; cv=none; b=XnudfnDiDwfjqt+2tJoEby5YcTDniRnhT2boPJIbRvvdZnthY/5vXyOXtsZUVVehjUxa74jtdb16nSXneHzJw+uiIn8+2m+YYJDEc6QYTeK2OIayjqy5BFCShFya4iEvig8sQBo1N849jDVlz40DcJOrRv0Su7CAw5/gXpBAxWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742541716; c=relaxed/simple;
	bh=h+h4s9In1zcp/QffhwuXozG1yWWSBONa8uVc0X2o49Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX/NDcdoY8ala627I8+zXAIex6nVRcn2F6vPGVBw/EjLcav9GT4675nPJeUInwsJLSEhH4xC4rn5g1eINFasqEoUE7ZEnh+ExJ2tMydeO7XMifrPhb+wF9fo3yWQzJVfor93EohW2n5F2mTVTZYTAcCN7cwwijvYxt3S7zcxNL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M6dmC0iW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M6dmC0iW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cLVc/L58oG2H44CDq5Wuh5Ukd25fBzB5gPMVDtD7VYE=; b=M6dmC0iWIBYRFfPRSfCFnVRZy0
	DI12g3JszVYqPnn2WfJ7DmYSz7f2hfnVDdtEwSdT/R6uZStgBZhc3iOQw27gTF2ru+4d4VsGZIe1z
	lTx5o9pgGhhpRoWu9pm2rJHcZChK0Rdet7JvyMMgxJdbYMrGkqKH3nLAVaj2ILoL7ZLx+J8/VhlAF
	OuVmE8ORfDRbv+5mm/sM82RVmPdg2OL+5s5FSzkSHZSxdGC5X53M2tgJnELAJxP/7KQHh35zcSyap
	EgS2/cq5YP623jIHW6l/JDozbljvoPSbo1ZMm1shIYFChoBqP3Hk3uY93j1HXzindVQ4cQvGsEEpJ
	Ybt7gdhQ==;
Received: from 2a02-8389-2341-5b80-85eb-1a17-b49a-7467.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85eb:1a17:b49a:7467] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvWhW-0000000E5Be-3I6I;
	Fri, 21 Mar 2025 07:21:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] xfs/540: use _scratch_mkfs_xfs
Date: Fri, 21 Mar 2025 08:21:32 +0100
Message-ID: <20250321072145.1675257-4-hch@lst.de>
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
 tests/xfs/540 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/540 b/tests/xfs/540
index 3acb20951a56..9c0fa3c6bb10 100755
--- a/tests/xfs/540
+++ b/tests/xfs/540
@@ -26,7 +26,7 @@ _begin_fstest auto repair fuzzers
 _require_scratch
 
 echo "Format and mount"
-_scratch_mkfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
+_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 
-- 
2.45.2

