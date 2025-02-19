Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0C1B6D0F;
	Wed, 19 Feb 2025 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949296; cv=none; b=Be+WSsr9hzUeas6csAhGakLt2IPRE3LKSbn/xvnxsKbzcp/nvLT/Y3uLcGPih3vnd6LmGI3YP5IChjs6K0W37fD8E103gzGnMsM2kwt6yFDnDMjFgmgrALpeJMjZwTBe/MO7TALV2aAWgluJ4gb7B336SZrhaNDWo6GT1UnsO2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949296; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teuK8aJ33JhBg7qicu/3ruetHrQU/yyV05o9uo83uP9+7v1avvmvu4EglKD2bN1Yq3kiHOjoN2Z/yLNqsVh2GA2xyUC6EqRdwWr90+VCxEANInp54T2+XSAEznHHXK/FsAESEqgQiLmK7/KPloxOemuD4ETdEo5nWBBaHcwLNBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uvMkqtYV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uvMkqtYV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uvMkqtYVNxapghY8H4U42J3+Lu
	R6WGR+CBP/2cLKEahik7t0N0priRj8Cva25Y4VkUdLtD0qDib76jl+tlNWKn1gjZca4DHUnkahpkf
	4VOsbPzGnzEe4dHpoj9SZcCYstJ4vsNqg2vGTteHS1bvWzTfY+4e+ikU6m6FZnFL7kOJTBloG7Vgi
	hck1GHFcvq3pxDhDFtmFUCAjKeUAZk5bK/mR+loGFV4Pzc1yEz53yvxHpEPxxXo7N2ceDYNw44vYi
	iy/ZGgnHiJlj08hq9ZKqIDMCrcOTD4XWQgNOLgtVBaE5P+3e48fAjs/mZhyqKoaR132JO4VubKTnj
	013w9GTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeII-0000000BBb3-4B2P;
	Wed, 19 Feb 2025 07:14:54 +0000
Date: Tue, 18 Feb 2025 23:14:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 07/15] punch-alternating: detect xfs realtime files with
 large allocation units
Message-ID: <Z7WE7r3sW3OvPaHr@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589308.4079457.15370995926162762676.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589308.4079457.15370995926162762676.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

