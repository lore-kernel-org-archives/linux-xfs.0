Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D646192585
	for <linux-xfs@vger.kernel.org>; Mon, 28 Oct 2024 08:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730104487; cv=none; b=USsHpu24xuLnTvQZAQvaeiyGjrDSxxxfk91yThEkd5o7qPty/key+09DiAmWz4iFjOEy+1AiMUlZZmUrALYd6OMZ+KKucgWwO+TaSulH5fRYL8FsxHrI9cWchfsCGOyYlYftOKZgds5twn1Q55kQyDC51lxi3e0SMU2ppY4gODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730104487; c=relaxed/simple;
	bh=yLeHkavtJ3rKePjd2BlMguUR8E3np4gU1cz10p7Sxr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+gFn+Oh4rCL3n0zYHDyURUa+6sh4MviKK5LgT65PtoeWa07ps7eg40syz3lakOoj0QHci2vDpiIpsvt0v+/79C7oI8opAgu0son4y3Z0524/898v4DtQ0/Q8satHpQVYVfeqBd1zRCT3WJYYrCAgbjMYT7XwU6MvlcTNaBy+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cj0eMTUj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cj0eMTUj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c11ikNWk79IQq+aL/laDxp4ZOqZtSL3yrhBHsai1Dcc=; b=Cj0eMTUjIRJnvXO69m8VQ/cPrC
	me9eTIjg+a+D1YU1rmC9d+f/uh/5FeoiIIPZTpmaKU4wkyyf7+DbmZ7c0jPS17TgO58/08Smg5WJp
	Hc/HsUHSsepBvqMFi7fz8f0dvJJEVeXl8K4mc2Qyp82pB/JcxYnAWYnt3I5uPVJswpQxbW2W2ZCht
	84S2ipwQp9RruwSMpG4L3ubqA7HpxU30JcsxTJOW1aUCiArDwCylFyeivGDCRuEXx4NfjgmCgg6ep
	AVl3ngEvZTupgT1eH81c7UR/ZowRn4W0If0l6rKPLgbfNFi+glxEjtfv0B+OX4anSMsd6oEDLUAiE
	qJu5V5/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t5LD3-0000000A71H-0Bbz;
	Mon, 28 Oct 2024 08:34:45 +0000
Date: Mon, 28 Oct 2024 01:34:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs_db: support passing the realtime device to the
 debugger
Message-ID: <Zx9MpcBrWWpTib_O@infradead.org>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
 <172983773744.3041229.13980914566378223145.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172983773744.3041229.13980914566378223145.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> --- a/db/io.h
> +++ b/db/io.h
> @@ -51,6 +51,8 @@ extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
>  			int len, int ring_add, bbmap_t *bbmap);
>  extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
>  			int len, int ring_add, bbmap_t *bbmap);
> +extern int	set_rt_cur(const struct typ *type, xfs_daddr_t blknum,
> +			int len, int ring_add, bbmap_t *bbmap);

Nit: No need for the extern here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

