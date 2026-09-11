Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10B5373BF6
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139697; cv=none; b=jKAD/oBMmpvopHn8asM1W1OcJrvbwrvnp7D/+cp3DXwBFosmHqqr8rawb713bCFZyCIsl+eYCGctjXTATNDL8ZSXMxZPmshCSzokAYhcLxJaAqldh2LVyGQAXaD+jnmKf6ka7SkK3Ao6D28ezaOFuyChKo9RRvcj+x+WN7jjRO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139697; c=relaxed/simple;
	bh=LA6OrkGXTbrnJWZRQYH+RuxOGNA0TEArCdueit99DOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aj5THcowuaoYl3RHD+KuMkVAbphjsUn+pMT41f1jdJyhbBrESsVNcO4iPZaQsgfeHZBg6rovXJTvjmwBQ2iI64uLEX8jb95mfiTCf7lHvNp8krbngdYCt71RU6t42QX4w2yKphZRbiqpn9tWo8m//LXa+Ug+SooTe1kKpeqAy/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i1+n1Nmj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i1+n1Nmj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LA6OrkGXTbrnJWZRQYH+RuxOGNA0TEArCdueit99DOA=; b=i1+n1NmjLrjSoSo4wesHJtFgYo
	UD4gG9G4E/5Hj7wb8S5a2wcfFsFWbae8Q9ETlPf4d0a4Ztc4j+gu045HoMbD0zeifk7WCHR2KQ7ud
	BAzanCDzzQ5M0fRpvkxa9pKD60CiAoL2L9tPaiMNqDRIa+oM76oWYHtTM3T8jcU27rBQhk2Wp85HX
	UkdI9thh4OiPYpDlFeJVnnDe1pxmjnye8QXkCxKWNmVd3MF5ewl1qwNfNWa5fCBt9+kxrnrIN0WQK
	R2lUg8oeRpPWFx3xlXbdzcUcumDFMtGTdVFYx8B2ppkMT3VDXYgN1QcWPD9glUXLvlt6n6xN2e5FE
	Sc6jwoIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x52xq-0000000H1Cz-1zvh;
	Fri, 11 Sep 2026 15:14:55 +0000
Date: Fri, 11 Sep 2026 08:14:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs_db: print configuration file for mounted
 filesystems
Message-ID: <aqQa7nA89FOHZfor@infradead.org>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910584.4047311.15010657722532410043.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910584.4047311.15010657722532410043.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same manpage nit as for mkfs, otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
