Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E4221578
	for <linux-xfs@vger.kernel.org>; Thu, 18 Dec 2025 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766034853; cv=none; b=Fu2ZIZLR9rPdqw7M9kzhATKl9do9Mc2swfOS0vSwYTx4+/0w01ppJBwlmOn174Hr/p8x55Sf2tVT06vWzCyKv5fBQa/GRR3l4Fcvi0h5EAEN7fUJEvTxRYD0wFXco4qvwFjst8A5iHudXs+Mey7h7nZO7BWcSejt3erC52zqjWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766034853; c=relaxed/simple;
	bh=SZEx1GB0ruAzEXkEypsfQwrodw5FoNHeIUe9I56AfU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrfbuFjG6FNi/kDflkpErvwjlFaGEicAAJpt9f7bSdvRlkiB8z+62BZYo8u3o9/9jkqwpQY178AtWrTb5iwfseZF9HlekNNj41EUFHdp+y9m76p7OEF9Hq9dCI4RGGffTcUvjbTHeKKCkl9VXo97t45MSOwrPO6wq1NygmDzHWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hcxXmcwl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hcxXmcwl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+NRFaOLSKhqMXAqRpH6SKX5cEYrg/XouDwbaPsg5O4Q=; b=hcxXmcwlT7Y1Jp8H6t9QlTLulJ
	P+EmC3X95qdI7/Nz2llU8eHslT9T52slEwCjEXSfKRwConYkZeiECO+N1JIZFn78ciTXm+YQuRhJc
	75KI9ncNvaoYp9WXBOyMQa1xP92KCNdI5+/JYYQB02kxHWsfFyZ88ouy1MvFWSyPjb0zDY3NgHsZv
	QfmtWxJH9Z7CdXt0RGICzosScFS4L5AGCsEqxcpTSiY/HYgbzClW2ucE3vo9VnVQGuiC3trcz38Id
	/9qVrT2IqWy03v4ti5G1RlyBw+kkXYEyFvTnO7z3ysVLOFLJ3VzWhlI0+i1paJVoNwNuRCJaUtLYI
	Pt+l+6Bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW6L2-00000007ooF-0Pc7;
	Thu, 18 Dec 2025 05:14:09 +0000
Date: Wed, 17 Dec 2025 21:14:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v3] xfs: Fix the return value of xfs_rtcopy_summary()
Message-ID: <aUONoL924Sw_su9J@infradead.org>
References: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83545465b4db39db08d669f9a0a736fdac473f4a.1765989198.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 17, 2025 at 10:04:32PM +0530, Nirjhar Roy (IBM) wrote:
> xfs_rtcopy_summary() should return the appropriate error code
> instead of always returning 0. The caller of this function which is
> xfs_growfs_rt_bmblock() is already handling the error.
> 
> Fixes: e94b53ff699c ("xfs: cache last bitmap block in realtime allocator")
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Cc: <stable@vger.kernel.org> # v6.7

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

