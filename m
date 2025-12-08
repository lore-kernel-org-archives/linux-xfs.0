Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD878329E42;
	Mon,  8 Dec 2025 06:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765176551; cv=none; b=E6wyeoXmGndBtsQZiDzLi+mDZujbRPsL8UsL5yrzc7vgbJjxHkYdEzWyTXhpmyg3KRGUVMtO1EQ5PkJM12K6dLAF0s1Afa4CyqfbvZ37Hc8T48piP9koelhU1wb4UOtu1CsPsxSfYi117awMyuNC3SsRT9epXrBWOBhan49gGYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765176551; c=relaxed/simple;
	bh=ni+xpN6vI7eaHWgM94QFm+nb7PhwIl2kui+d0zWLEJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1zGfczm9q9eWK99pOZWGhD7C9cZKpq+WT8Cro2XZ4xJcEQNmfkWJY3ArBorz3PkPJlr75eWyjyUTiMfENGYXEGDYTnd1e7TRN0yJU9fUIEBxKyxWjT8i3Eq1etfZHwNKuz2wy9WrKvb8mJA3D+xwOHkICvpDJACpCZqplqNoMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dmug1xI/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dmug1xI/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ni+xpN6vI7eaHWgM94QFm+nb7PhwIl2kui+d0zWLEJk=; b=dmug1xI/FXvurxidDo3KY57ivA
	qvnwNXsXn/a9hUbJ7ohk1NMn1x/U/X6jinu84VEvK6ORVEbcE1wkEeOTOMdKEcJeOTkJfPoczrbMF
	d07QnRHpoz6cRUziMGm5NVyrSJVQzlZokiDCk6miJbNji7A3LTIUnldUPKcpRJPWCm3Sw/O8ahEB/
	sPoxqLL9jMVIBIrO7weUC/tEM2dEcqKLBX0MHP7sms7SD4fNpVxqlozsQHLBZJ6Md2dez68Izzoc8
	Z+W5U6JTyzSq+h+6K807vU4nuL+h+c27M0e8dWIeZp/1KQwB4RLu1cnYXa1wxEXaM054FsDxKO4Xi
	yNKhqByw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vSV3R-0000000CiNt-3id1;
	Mon, 08 Dec 2025 06:49:05 +0000
Date: Sun, 7 Dec 2025 22:49:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: cem@kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix a memory leak bug in xfs_buf_item_init()
Message-ID: <aTZ04X0QDytJm6uq@infradead.org>
References: <20251206121552.212455-1-lihaoxiang@isrc.iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251206121552.212455-1-lihaoxiang@isrc.iscas.ac.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

s/memory leak bug/memory leak/ in the subject.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

