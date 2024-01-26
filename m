Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CE1BA29
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706286825; cv=none; b=WU2PW0QGGS5ty1RA6XBG4AyjrN68Yec1axsuoDqWWYdqCapO/MuAY0pe9rhzArYASSvl3YC2zNOGL/MFY/5mDpiI+vWt0UH4t8yl3V00MO0eIrvlv/Gm+A0QReE/OqT67bbc1uxHzjI/wMfHnBJV/sZMWEVsJVnkn7xMiqI0qJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706286825; c=relaxed/simple;
	bh=0RZ1mGg78Cg15oiSQIWMjHx3BLchs532kQlj1l4mi04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbNtSOMA1tlsht1a/r+qN189jnwHd0PHSO8AsyE+i8w/x1M30v2Yia44YTZ/xHqoatzBTWwLdmt7qHAsfaR6bv0Hm5sILsBpE74zsVSg56YLEHPnp5FYTwMjgj0EQhL3ip+UC+og5nKXUUZIEu/r6DkQFDMPijj6NNjtuKE/tpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PPlDH2h3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PPlDH2h3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T2FEK9DaSYNLvAf9tDBZboB/NTfQJJZt6JciDg2qLws=; b=PPlDH2h39TrvZdVurqByVwdPEn
	yMq50gCimBfF4AtswLNd/BnFi9lvROVNuRxc+v08KGTaRWmppzMn29f/jPgA9iM3uITPJz3gRUsaC
	eF+Ug4zr4l5JsUCmVyjixBSgtYv4yFIOTp3gaON4Y+VSOf+2slX+yig0tgY10q23cyrd6VxJy9+7J
	1EoNqzTmkxcEJkW4qljhmBXxUDhy4k/2+XuNnGTA1DqqzCvjjJy5gTOFoPlaXbvLDf1SmBeifUblE
	wokzTLqMqYmAf0k9CibWccPHY/4t1/iJsK9r8YN8amO9Y+5DfCw2vOcKU95zgMmmK1WIENVkD7JAj
	ZHivi1Rw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTP9A-0000000EBDQ-1bM5;
	Fri, 26 Jan 2024 16:33:40 +0000
Date: Fri, 26 Jan 2024 16:33:40 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 16/21] xfs: improve detection of lost xfile contents
Message-ID: <ZbPe5FjDaQp1v8En@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-17-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:58PM +0100, Christoph Hellwig wrote:
> +/* Has this file lost any of the data stored in it? */
> +static inline bool
> +xfile_has_lost_data(
> +	struct inode		*inode,
> +	struct folio		*folio)
> +{
> +	struct address_space	*mapping = inode->i_mapping;
> +
> +	/* This folio itself has been poisoned. */
> +	if (folio_test_hwpoison(folio))
> +		return true;
> +
> +	/* A base page under this large folio has been poisoned. */
> +	if (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))
> +		return true;
> +
> +	/* Data loss has occurred anywhere in this shmem file. */
> +	if (test_bit(AS_EIO, &mapping->flags))
> +		return true;
> +	if (filemap_check_wb_err(mapping, 0))
> +		return true;
> +
> +	return false;
> +}

This is too much.  filemap_check_wb_err() will do just fine for your
needs unless you really want to get fine-grained and perhaps try to
reconstruct the contents of the file.
