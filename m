Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D03D3CE3
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876573; cv=none; b=a93re1jxQkqyqiwvtgT9SeDOCPRp/Nex8m/WdKA6CRUtcjNUsW9O2BFmz9FmQ+a79QQWXc0QeySqI64AQlgDBap70N1F+KSMbx3WBSbXA/6SX+rC/v+msAJxxJgUGrIe4XaQsNOYRhZCICh7M05lmJ/DhTbiwKlZB98e7u+dKXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876573; c=relaxed/simple;
	bh=X2zC1GsFUvQMweCgK6Y1RZaHFhhc7BVdf3mCuLHM0Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gcEEcq/Q2lVu6sHCcTgztHQBhQMWAFuksGs9GFGHVzbo1henx19OHkJWdcDgldWUqjWUF0V1hQICbhQRDnooExRCotZRVKKaHGHf9MOSeqr8Sd5eZekWmMjEsfHTK0e82AQatp51J8aKrYd06WY89S20i96m2BNm51ki67mmYzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=np3heKA7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="np3heKA7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X2zC1GsFUvQMweCgK6Y1RZaHFhhc7BVdf3mCuLHM0Sc=; b=np3heKA7VBWfTv+ufJOK8jGdki
	2TXvgfJcC3wtWwy4gOkY+54u/kWDLAkcXumqq1ireIySd5T5BRppxwbbq/KT3P75xF7/0l6hMHcpt
	B1t1Gv2rdvErm7m+ta/g+OhQwhMed30zqtHykbYNDnXQOQm/5XN+yGAkh3smGIcb27jrTqh1u0jpr
	GsIIlxtidE3oLDtR02VRu7arbwUL7mXfQWPPk+in8I2OI+En/e7WT6GvIVax0WC6moreWJd3aeaow
	QfGA4llZJyfWqfmdF39pxiZl/T/tc5t+ldbkJzA476HymCO1i96s2WsdnOKqaR2sLZQ6/92lRI2Qg
	Khc0/7Aw==;
Received: from [94.154.173.90] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7CTR-0000000BKRT-1KpX;
	Mon, 30 Mar 2026 13:16:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: small cleanups for ->setattr
Date: Mon, 30 Mar 2026 15:15:58 +0200
Message-ID: <20260330131607.3904269-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series has two trivial cleanups for ->setattr.

