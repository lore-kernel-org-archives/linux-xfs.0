Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E7146588;
	Fri,  3 Jul 2026 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093820; cv=none; b=oi8ghzgKUWYVIrgxZDgDfGUtwSKXe9e94fh96vw8Mcm5+F3JkJp0rhxWRUjiMenbEcYw2hVakHgorfnxrcufP8JMcG//49n8ex3IPY3w2gIdLKhpfCs6S0G9FVh3RxCFm6bR7dto1hAwDUUBLqdLNs6onKFsWtVSmQtLasRBQ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093820; c=relaxed/simple;
	bh=2diKGbWyA/BZAV6oHrtBt8/JtkLVuPiQgkVkpmINydw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UA75sr3sjEHAiFSy55qlHWhFQ5Bm0AO9/4xC20YE6ETpP3GBGsqdGj/FRsQgxp3MQrYe5ICzC7myqBzueVMjO5nP8Fgk0GQl8dqmNhaF/1+uTwWA9yFZB8b9WVsTXAlB17Ycw9jXTes6np21TfvGSg6n+vlwJ1AD0AUi3rat/go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2WAliqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2WAliqF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E4991F000E9;
	Fri,  3 Jul 2026 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783093819;
	bh=UVUyVklTsq1sfhF6yM/Q6F0+MAV6Eqzi8rV2Y7Lbzyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a2WAliqFDxSW4KgDkfmGHxyTL0cMpEQmos9nm/EWIYdK36HGJn9ixjRNXdV+XNPR9
	 Mq3JBeODANgcwG/11dnR6OY+99Cvuuz5k7ANH/j0N9vMaXTU/LtmNRzlTFcY8ce7Gj
	 eTqpHynS2musu5kz8/mq7lQy3PlyUbCuwnKUMUOS4DJTe7FAxOLbsst3Pt6VEhKZzu
	 hVglCEI6tuTdfEX9UKJSyQ/Jgi9V3dVBVxbploWI2EzQmIa9fNLF/cNsie2ZGP5jHU
	 8hbjj39XUBtwvo94dkAj3qOR+4aJ3+W1JxZ2eOyTr9QmUsyWXOzGvDwCdVW265Xr2y
	 M7vuH1MZyPO3g==
Date: Fri, 3 Jul 2026 08:50:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260703155019.GV9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com>
 <20260702140301.GB21339@lst.de>
 <20260702164806.GJ9392@frogsfrogsfrogs>
 <20260703123340.GB25849@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703123340.GB25849@lst.de>

On Fri, Jul 03, 2026 at 02:33:40PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 02, 2026 at 09:48:06AM -0700, Darrick J. Wong wrote:
> > You /could/ use a bunch of fugly macros to simulate a default NULL
> > iomap_end_fn parameter.
> > 
> > #define __default_iomap_end(a,b,...) b
> > #define default_iomap_end(...) __default_iomap_end(,##__VA_ARGS,NULL)
> > 
> > #define iomap_process(iter, iomap, srcmap, iomap_begin, ...) \
> > 	__iomap_process((iter), (iomap), (srcmap), (iomap_begin),
> > 			default_iomap_end(__VA_ARGS__))
> 
> Don't go there.  These variable number or argument macros are a
> complete pain to undestand and generate horrible compiler warnings
> whenever someone messes up their first attempt at writing some
> code (guess who never gets the first pass right? :))

I /did/ label that as 'fugly'; I barely understand the subtlety that
goes on in __define_iomap_end. :)

--D
