Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707EA17AE1C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734072545; cv=none; b=Q6VMpGeRjWDGFfmMKAkV5zhctXLTiD0mBFaxkip1YTfsHCkWY6qIqrQxQ7SudMfaRmhBRTwNrhTWwxupB9odYUWbmyD392PxK/q03xSPH/tH+NOC544gL3xEy/PFiTfJ9K09G8SnJw7+7A/R+ORHKR9fH2GkvyBbTts2r7O8zAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734072545; c=relaxed/simple;
	bh=RjQ/lA/YV/Rqj0lsBci7lhYeMs8fwY3wAjPZunbXHww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8WgIS8HPS9W6Bi3Z9JbqB/3My6cedcnWnqRk4sDAanq406Z4Y7ONUhvEubNgorY1OzfRYXD0xrZLJqAHsQAcKp1Sbz0uQHZNlgpSQ02EBdvkW+DTrQVW67OG2nrD743rN8EC+NeO4groweaGdIqUxDWJ6SDJ7MYazOiq0pt5yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dTHqTIrL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dTHqTIrL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yyKNYj8Yusjc219gdNa32EhBpGa4Ve/K/2UsAJ3StDI=; b=dTHqTIrLTuNj/Nlhypl2NfB24k
	LUr0+k7NU2INIIbGelsTQl51f1pPPOx0pWf7PNPgTdZKKsXVYMF9BMw1xDYxCWhptIRXidzEgIzNf
	ygpg7jsscCkcJ1Dh2lnagXEHgf3jyUxU/xNbhLsfN3QV0ng62ZhQ8r3REDwlr+7c2w7xFfZy3+2HS
	v9XHhesaMkDL/ekIcAmvYgwKr0qMCd31MKZ7u7GbsGpFDJJrR+z3ZTdSqp4ZQQTaifJyW5y7Lh8fP
	RWyHfM6aBUP9MZ2bavKl26kRXTtQvdIJrR9139nCb4eQCR+dY0AQZbsVmqCSifS/SnASuit2kxQZH
	1vvWMWEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLzTz-00000002tus-42Dc;
	Fri, 13 Dec 2024 06:49:03 +0000
Date: Thu, 12 Dec 2024 22:49:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/37] xfs: support file data forks containing metadata
 btrees
Message-ID: <Z1vY30of5629iaRP@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123501.1181370.9693980966695147034.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123501.1181370.9693980966695147034.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

>  	if (unlikely(S_ISREG(ldip->di_mode))) {
>  		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
> -		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
> +		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
> +		    (ldip->di_format != XFS_DINODE_FMT_META_BTREE)) {

Maybe drop the pointless inner braces here instead of adding more?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

