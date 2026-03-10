Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8082C11FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 18:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773167702; cv=none; b=g5TL8NJAko209NcCDFHWGAyYqAe2bywZEFaA3bakeOYMpVSEUnKoCCDvdM7gA9dHtGJ4N6Bzxu0xpNZCTTJT1vByRv9KXmPQ9T+GmAjSRWP5KTwGUYQaS2EQUe4rUHto9BOgiIdmd707rzbdxspsZJRmbOUePPYOhhpIQzCNFkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773167702; c=relaxed/simple;
	bh=S+Slw4ViyRs3ylz1jkp5JUVKcnjsZZxHO87IixVh5WM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XDQlL3Zv9dmIT4qZ/d+2qi35RZ5LcCkZhNZp+b+iWGBZd4w73+ydSZlcphNCcMwovEQaUfv1r9HXn08z0mlRijQj3RyYIsXbgxEmTmbxfHRGskgW3iiUTiU+5AjFE+ih6GeujbAYM3MLD1ULp0EqJjgFiDlnWHtWWERvZpKDRSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUKaCYfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUKaCYfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF8AC19423;
	Tue, 10 Mar 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773167701;
	bh=S+Slw4ViyRs3ylz1jkp5JUVKcnjsZZxHO87IixVh5WM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MUKaCYfzjP2matlmKE+ppYWvtPDUG/6JZUsWW4BldXzqVWPzcdd6Ll/7vtZrKMnmp
	 sLHoMSsndMEkkb6BtMmzKtSryTlTbX0QkhV6Ilqc1D1fvjbmzIpcbPxrrQheBZZaT0
	 YcTtjovAUJiphXFIKqJbnMcCAlAUWhO+1CFCel+4juY3BibqAO2MCTdHN78gCnGVu4
	 NKRw1/telH51X1oHVwRD03jkBr+yGsONADleXF2Jd8w0OtQV1l76QOTjr3m/sfGXh/
	 ykRESZegFhSEwin9XF2vfjr7Aur1kg4MpdFpdmYiIm1G+6me2MdZcIfjLePBUqufW1
	 nJKj3RZSaqiwg==
Date: Tue, 10 Mar 2026 11:35:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/28] libfrog: add support code for starting systemd
 services programmatically
Message-ID: <20260310183500.GS1105363@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401522.1183235.13255430360161493359.stgit@frogsfrogsfrogs>
 <aa_jPHPfYM1wQwvW@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa_jPHPfYM1wQwvW@infradead.org>

On Tue, Mar 10, 2026 at 02:24:12AM -0700, Christoph Hellwig wrote:
> > +static void
> > +close_fds(void)
> > +{
> > +	int max_fd = sysconf(_SC_OPEN_MAX);
> > +	int fd;
> > +#ifdef HAVE_CLOSE_RANGE
> > +	int ret;
> > +#endif
> > +
> > +	if (max_fd < 1)
> > +		max_fd = 1024;
> > +
> > +#ifdef HAVE_CLOSE_RANGE
> > +	ret = close_range(STDERR_FILENO + 1, max_fd, 0);
> > +	if (!ret)
> > +		return;
> > +#endif
> 
> ret is only used to check that it is zero here, so maybe do away with
> it and avoid the extra ifdef?

Fixed, thanks for the feedback!

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
