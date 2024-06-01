Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DC46FBE
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 05:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717218193; cv=none; b=cVoiA8IXaH+TfG3eEnQ1LFZnIUvL0DYD4xnZlLADf1Qy5JqiU58n7YmUDr0CjFcipIJ6qmi8WdkBJmlQeLdY4qzhpmDS/fctOon4ZNA8B4/wgxyYUCHIPQbXc2B3cgNam0+gm2OWq9sDm8eHdfOrNqGbRTMqZ32bzuaDi6/iUTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717218193; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVlZqCb92zCqbDAwpAtE6k2BjqHc6gCaV8Cpf3YW3dH5GI/pdPewg2xw2JkSMAWAJn7pH515LIPKWV0PyCkz3wx+xC4RHzJECBw9qBoaOLpifMneZvhoApMhHnZfIpxF1IQAwFvG+SyBoHgCk9CAVpKC77e37dk/iDa4fpuD0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aI6gWVgb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aI6gWVgb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=aI6gWVgbmzw9b61mQGEHKw/i2O
	kinHWdUxGBXssSdmG0TKL6c+sm1bV1b/qdlm/OZihqW3SRISA09ew5W6Grt0+gugj7/qUsTby2K8e
	emK1p8S5uuHslB383cFkmW6ZZ9e/NfoZI4Gayr6IFxd29B3gZxHeGV7YFuawyvtdZs1xmb21npReE
	bDEUUrrJAjXRMnmo/PWu61sq4Z0azs34TKf5wwB1e6lZE27W3GT13TQHXUEeOUcqSMwcNc9FHmB8l
	g9dj5n9bvJz6o5rGu/1Jo4g7vjde4hGxMoso79+3jnMqmWbIKKX/l+TB47kGSJFiiYbo4QeGzvpI1
	6v5lTIpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDGtb-0000000BzEQ-3uZy;
	Sat, 01 Jun 2024 05:03:11 +0000
Date: Fri, 31 May 2024 22:03:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: log when buffers fail CRC checks even if we
 just recompute it
Message-ID: <Zlqrj9zSpi3YOE4w@infradead.org>
References: <20240531201326.GT52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531201326.GT52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
