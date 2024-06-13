Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C4B7E1
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 05:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718255178; cv=none; b=jWsyUQVu8PEJ7NckD32txAhDYyjjTwQzx/z6s3YnAZaLVTcpWFn0coUj7ZpHo8qsV3wJTHRJDVJSKtXkFE5+7UrfBHEhSxN1oNL/qRfl0kQyAqWuSnHr0/MseqZEnKV85yQ+1ILZDYZoUFuak9vOOto5QrUZboRjNua4+NkF7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718255178; c=relaxed/simple;
	bh=7BPzZgI6I2jh8Y1UG2BT4aO222nx3Z1vt5s9UATZxmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WMF2ahUeIf1CVmXn1TtZHJPEwDYTRRqtBMg7Vmo/gRXOPDMbt8e/9RLwX/0rbb1p3bkEWmYSwxcFIhA97WjhjuTP7voHDZULPwQ/sKZ6B+JjATAINPHZVv67nr7hK3ifA5riTeuz3WZ+zBgTjTcdbg4p4sPX4AmYYXzjXIF2mQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7DF1768AFE; Thu, 13 Jun 2024 07:06:13 +0200 (CEST)
Date: Thu, 13 Jun 2024 07:06:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: restrict when we try to align cow fork
 delalloc to cowextsz hints
Message-ID: <20240613050613.GC17048@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 12, 2024 at 10:47:19AM -0700, Darrick J. Wong wrote:
>  	xfs_filblks_t		prealloc,
>  	struct xfs_bmbt_irec	*got,
>  	struct xfs_iext_cursor	*icur,
> -	int			eof)
> +	int			eof,
> +	bool			use_cowextszhint)

Looking at the caller below I don't think we need the use_cowextszhint
flag here, we can just locally check for prealloc beeing non-0 in
the branch below:

> +	/*
> +	 * If the caller wants us to do so, try to expand the range of the
> +	 * delalloc reservation up and down so that it's aligned with the CoW
> +	 * extent size hint.  Unlike the data fork, the CoW cancellation
> +	 * functions will free all the reservations at inactivation, so we
> +	 * don't require that every delalloc reservation have a dirty
> +	 * pagecache.
> +	 */
> +	if (whichfork == XFS_COW_FORK && use_cowextszhint) {

Which keeps all the logic and the comments in one single place.

