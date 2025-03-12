Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352061E25EF;
	Wed, 12 Mar 2025 06:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761994; cv=none; b=P+SLgo9hudgmM90S4g9JcEzYRF3+AlEa8/RcutyzRHVt50hwCoBmfeR30r1lZyU7qe2k8b1Gp1f3fRWyzb3LY87hNhoTT+RuwT9zlBAg6geQnYxImzaGDJTT76zE32KhLogvqUSMZAIV6QOpk6hrHscXSUCZ4S/QRFKoPwyaRyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761994; c=relaxed/simple;
	bh=LGcMO4L5SjAqR4JL+byLtIvA9eFwqrCO7ivh9CUt/M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRoXFbH4HtimMyG7pbNJmqtyUY+Wyyk+xUupG8UwvZwiTE89IBrFAgeIYjLvPANoPxBXiMzezEZa8UWVABLHk7GV9MYbycxZJmPqK83Y86/vCWMgeZMlnizEeISrvMV98b0Oj+4I8dhIPFyTxiDST/Wjz7MvL/0iP6BbFsVx7BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DcUZJ0eQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DcUZJ0eQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mg4jF/elO0L6V3QDR+jzf12z+53XfQM3w4/bfLcOl0w=; b=DcUZJ0eQeIAULugcBa3fBYujDC
	veI78+7+JBn2uRC/483ncWXY2MvVPRkD4LJkOfmxVtTDs06SqcA5gvT8+3mv+kervdv3iYxJpCOya
	Y4gcZzGzMbilh2z5B7zaeSN46+6C1LkLh5Snkry2w85Zq6h65G6XVVSdDuu9RsoQy2yXro00yRIsM
	Xc7+7tqMp+2Gkt6sIzAjGcZCEsq1WHw+Vxu98B8XYfXm/VY8JYkOgJCiYC71JuLNlYl+ulqNiEzaP
	NUTiu14oWLG7irJiV2I0SiHJAMugVV84dmVXmS7kOjaxMP1mzXY00TauE2PpwcPyg78Uj8DrXXAjA
	za/g0uiA==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFrM-00000007cxD-1E0v;
	Wed, 12 Mar 2025 06:46:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/17] xfs/206: filter out the zoned line from mkfs output
Date: Wed, 12 Mar 2025 07:45:09 +0100
Message-ID: <20250312064541.664334-18-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

So that the test still passes with a zone enabled mkfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/206 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/206 b/tests/xfs/206
index 01531e1f08c3..bfd2dee939dd 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -66,6 +66,7 @@ mkfs_filter()
 	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
 	    -e '/rgcount=/d' \
+	    -e '/zoned=/d' \
 	    -e "/^Default configuration/d"
 }
 
-- 
2.45.2

