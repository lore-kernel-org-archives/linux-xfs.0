Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61193253B42
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990860; cv=none; b=pGxVM+vwS+PdFESO4XiLg/rP4PANUTcjXKkt/SkO3ocax+iGfVNTmagZhrA7pAj69w/rJo5O0FI5ycCjEfjwgX9+QR6eMkalOf3pMkOYIkQtMiV6AZC/Y3cpO/IO1r2+Yw8yDMLpsm4aqK1UqRdoz54xpTanjxmD7mSaWtVNwq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990860; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWbIggYI9s5KHdhQSXMfJg/777QKyaSNY43o6uYYAAl+TA7QYvhtQYv+QobI8UehgO2DCGpyQnIcUxlJP7scBncwAHstEhUIe9GgAiULYPS3GqRlh5C1g/675nmnIvJAOKZKhfLuUBMjRMEeAuVKwKXXn+UWSGJKxnoob7TYvXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xIpe6KBA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xIpe6KBA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xIpe6KBAlxi5RO3WR26iSADKaP
	7/TCUYxY8F5oVFNUKAZGyjlEhWU3Cnbcy4Hj6UYmZt+AevMe/oUJni1wjAqGh2of5ZnLycZTW6lSj
	z78bujGGhxMj97hULwfm5lSkKoS9i0FjMwELMfGyzxTYDisgwcbBCHtaXDSKBBwVpBrL3fOfsK3h/
	0nXdow8OpdcOP+NU5wAF1/3/bAIPz74SRTWZqOO82p7YZtRy1e+lXDwhIEvcH7BQ1qV3bUYzz9LWw
	G163kFz7B+GL3ap3V7w49SQ6ZEn4nd/DYT5cRLZq+fGZoox0JZ4XyKDSb5P//ax9xrS5IYxcOvNZ3
	APzi01/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U3n-0000000CDTK-07BE;
	Fri, 20 Mar 2026 07:14:19 +0000
Date: Fri, 20 Mar 2026 00:14:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/22] xfs_scrub: don't pass the io_end_arg around
 everywhere
Message-ID: <abzzy_NWiVZW8vmS@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507105.3681140.8365829305308981282.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507105.3681140.8365829305308981282.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

