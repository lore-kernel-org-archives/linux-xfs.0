Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F55B35949
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420940; cv=none; b=Ocg3EbAlQG3XJw9tUqH9ezFk+oqh+CzMD/RFF1icMbmv0K5Cdll+bkPKxhWUwo+5KG15G3VZYbXFQCaoHqE5bXLSW3ZGhdpAuzkPyyaeZjJuzerF+u8B75zYWCnp/Ii0X+3Mzh+ITnUWookdPIZ6iy2Xz/39mfGxV53IzcZs604=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420940; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hDzYCAOnoFxmao9DfIrsfzsaaCTeU456daSvM7HHx+jFPw+wcIfsI2XJLUxN+dd3+VNdROfS0+kJFi9bbQX+JRvOt6x2TETH6cSy9oXDft8aCoe/BC0vOM80DvTwjZOPUl0rUMwVps+mHUW1TyPuGDbRClyQBDD8VzbQZTSTIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HS8Jjaxl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HS8Jjaxl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HS8JjaxlesNW/BWB9RsfbZqVmH
	Nmmj1ig9nIwKZZWsERwtp65aN4T66yiHqsXzvsIgMtQZi6Y3DrnPLOf8JU0tBRIOyhvWDdwdmTRHX
	t/O0WfbFeVhwHEmq4ZOOB/sdJMyrVlP4+ebYoEZvulJ2Lb2iciei1+N/9XEFTajuzWp+ZqgmwSpkZ
	/KSDEzk0MoQrClBpgE4TN4RnWSlVpkWuHqhl76rFqqOoraPiCyQQO3sWDa9LK2YLgUmtfL0qBkTtq
	lFiIom9Ml6jsZ9Bha0/PHM0LfvaT7iW50RFOte+1WssKsTQOjYhrYFA+gbKZ17JDO1wpBlfnpgnQt
	qpW2UEhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQqR-00000009iZA-0AZL;
	Thu, 13 Feb 2025 04:28:59 +0000
Date: Wed, 12 Feb 2025 20:28:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/22] mkfs: enable reflink on the realtime device
Message-ID: <Z611C_w-336Tlp6G@infradead.org>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
 <173888089269.2741962.12417664592407560122.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089269.2741962.12417664592407560122.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

