Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76680200C7
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287263; cv=none; b=a5fKFt/B7/Yee23hlCbF+1eDJfag/TbstuNjnZ8GNyKvqjDrSsYpfG3AOwB/E5qz3IpzytBwZdsmxrfSlQZfsHe1jfxf0NlGYhZ+4cr9nfEFeZn760sj4/KVhntS/zQ4C+irtk3p+AB678MEE0/OOipSlhtFRpjQd8/AkNd2Xq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287263; c=relaxed/simple;
	bh=FpEoIxUdpFnLq6o/0v0keuu1G4ILlOaXcoL9vmm0vnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNa5TWZ1IzOkIKACY7Hk6saRP9Nwr6EKr9txgFrflthMei6B5AFcRWm01j/BMq1GS/z54pknNW0B3FtScgCFX+u94mGNZeAymxKhHWhCMKWCk2tzbGhCR//XAKO8wg5dY7zZ+2s1N/07RWgEtvG7pw1caWTcATeMEmclIOLV8JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JmFQDTqK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JmFQDTqK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9e5wKxEjraETE54fr2R/8FQJEBN+YlpNRgDqH691Hhg=; b=JmFQDTqKnsewIiYyKzTVdLKMEU
	nZDays14WGsmy1rw2Nx7noHSgPneNfwt6UwmZA1LT+ntC+s7XBxtMZhYfUphPpa8ZYnJhnlJw0o1t
	4vgLj9LO84tkJqWcXIzOrjlnjyKRmyAc7oUflqc2kmjGDuU4DH384YnegCkfoWr6zqESynwquEpd5
	EjrXgKIthVirdeRoE/0WKWrsETCYKMZThuzxERGzupNwrhjtbcrg9ihPY8l4SFT3c/U6zhIUt9/jB
	BkbeyGRnO6QULaJdPgryUsZ6dGb9V5pnRsEryy//4gMCW3ZBfsJMLQlsdIlRqdzYO61joj2T01P83
	I2nUgxXg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTPGD-0000000ECPG-1ju5;
	Fri, 26 Jan 2024 16:40:57 +0000
Date: Fri, 26 Jan 2024 16:40:57 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 17/21] xfs: add file_{get,put}_folio
Message-ID: <ZbPgme3NpN3F-y6v@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-18-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:59PM +0100, Christoph Hellwig wrote:
> +	/*
> +	 * Mark the folio dirty so that it won't be reclaimed once we drop the
> +	 * (potentially last) reference in xfile_put_folio.
> +	 */
> +	if (flags & XFILE_ALLOC)
> +		folio_set_dirty(folio);

What I can't tell from skimming the code is whether we ever get the folio
and don't modify it.  If we do, it might make sense to not set dirty here,
but instead pass a bool to xfile_put_folio().  Or have the caller dirty
the folio if they actually modify it.  But perhaps that never happens
in practice and this is simple and works every time.

