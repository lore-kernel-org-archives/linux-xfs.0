Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE151D0E28
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811275; cv=none; b=rq93i16BhNj7uS3OuCjnbfRWo1hJJ33uS8jNL8mWH6gj386qrcM5EMQz38C1kDsXS8iuLFp+18GK6ghcNXD8F8vvSgXR27J+ycSmda217i7prRlgih8S+QJsECS1g10miwZmzZR8qn2b6UC3yIp4ysN0vMRq/cqH1bjDgtDuH0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811275; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkuo3DNBMy5gdj02n9AujcHPP7iBOzRJs+vYNPfFfCSo8z27hDMIsqH8H5KmCZpBjB//VSitsB+n2mUxvcf57uLJEAhrAXOFfqUd/PuI2wQcRQ61UQEyyRukjGGxXufqRKQu9GCr08rnmQ6gRqXReOUX3ypCB9sh6Ug/PVqzwMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ubw0+LDO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ubw0+LDO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Ubw0+LDOcDdx+SOc5qEcQvljlF
	EVk5qNJzqvfnn0HN0l0hnWM1WdNoyd/FCslSTcAgDipPY+3QOqqNIFG5JyzRGUYe8ihYHzV1EsN8J
	zfWDQ8yCe2rSctH7KiLGASPxzgalDFNOAYCXPa3sc03aHjeKRJKYb1OeZmoNqEOvItCcrn4uD1FpJ
	nRPcbymRIGxjhGaZZZzmdXcMlwAYehsCaf9vKokhUGH4PztKLN9YdxebWBDqpmtYsiEbpCbx+yd8f
	zuE9P8phtUVOZcRvS/fjyouCVfH76Qk96UWl8MaMchv7cBqI/2ZCnXz6M0/rdCzSx2LxTSzAckcig
	9STLS+bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtVx-0000000ANsb-1zO0;
	Tue, 10 Dec 2024 06:14:33 +0000
Date: Mon, 9 Dec 2024 22:14:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: scrub quota file metapaths
Message-ID: <Z1fcSe5sKqyJ2Umb@infradead.org>
References: <173352753222.129683.17995064282877591283.stgit@frogsfrogsfrogs>
 <173352753248.129683.11231628303317171036.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753248.129683.11231628303317171036.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

