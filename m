Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517F43B6356;
	Wed,  1 Jul 2026 15:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782921156; cv=none; b=LWoPYvWAUD6jQ/71pxWqLXiP6NU/zTdpHc3XVRFXAdu8rbbr1R8y0v6WMyZGSpTfEjNxstLKR+7fr4JyQd55CzWfV88fuyLz+SUrkRcBBfkbXWXqZyqNmmqdcT+PfRCQ017pGYRykFLxLFS36a8zHAYrWWwNFfkJ12iDF4ZInOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782921156; c=relaxed/simple;
	bh=4AISVvGNVD7Py4fxm8YaMmRaiKflYO17OaCt9NVi5KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXJWZ8/vXNcmtMAHcPA2pSLeB0aS5LdRCjlgZMxspxjdrsczNAdiLiLJPhqMsOVVLw4sGQ1kp81fJdRvPtIKRwQsDI47HoiJTgxWigcy9k2rlDU6foJKpygvKCIxRpk9mdo+ljGti2j3fxqae+fQxFnf6nswbXm9UWhprtEWrAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BBvYyQE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BBvYyQE8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DC28E1F000E9;
	Wed,  1 Jul 2026 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782921155;
	bh=MPbs+nUnB4JFJqi4TLM8i756C6WNTxYSjp+9Hm2FFS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBvYyQE8RnCPAOq06ZVHGIDxJocYIWac5PtWQQcKcLpgJXkDh4D0YMcsI6BzYUZU1
	 EsUe55gN77XRZQkNo+EKt1wL9LGBDzwigAcTxmQnAMsEIwsJ+H8Q7G1KkyjSIyS5OQ
	 HiY4R6hcDanqacBwnGawh2ekV07dRT3ooqcwr/P8mikKYvfaVk0HM7DL8VcCTgLpH/
	 HGDf0X+QTU5mMuYAYms4FLhLm0qL45yghxm/+MuxA9Xs5wyOxpazlsniIVGa32Fi4O
	 TXOJ7vFELhdhj7w4n/xdkJsT2REZkpGumxpLBVKHBMomeRtHRFbgfRUAirD3DMB69I
	 RGF5fOOBN+gtw==
Date: Wed, 1 Jul 2026 08:52:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <20260701155234.GF6526@frogsfrogsfrogs>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akTyUXMN4_I1fOaM@infradead.org>

On Wed, Jul 01, 2026 at 03:56:17AM -0700, Christoph Hellwig wrote:
> On Tue, Jun 30, 2026 at 01:39:35PM -0700, Yousef Alhouseen wrote:
> > Yes. The KMSAN report traces the allocation through
> > xfs_bmap_extents_to_btree(), which calls xfs_bmap_broot_realloc(...,
> > 1). With no existing root, that reaches krealloc(NULL, new_size). The
> > conversion initializes the block header, first key, and end-anchored
> > pointer, but does not initialize the layout/alignment gap within the
> > full if_broot_bytes allocation. XFS_ILOG_DBROOT later copies that
> > complete byte count into the log.
> > 
> > So the observed bytes are root-layout slack from the extents-to-btree
> > conversion, rather than record storage that a later insertion should
> > have filled.
> 
> This almost sounds like we should explicitly zero this case just for that
> particular case.  Although Darrick was kinda heading in a different
> direction and I don't want to start a fight here.

I'm fine with either solution; I simply prefer the one that fixes all
the current and future "oops we forgot to zero a hidden padding" bugs in
one action.

Carlos? :D

--D
