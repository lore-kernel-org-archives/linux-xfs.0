Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B7182D6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782836834; cv=none; b=Mr2/5qC85VAuSjqNSlMVnGWG+dphNQZDDFLWm+Yboru+/UdjVoz6OYYT+lLj0G7DXdaTXtkSm7gd32XdQPw6fpUQpIlchBCwXBjh5/q9tE3nWsq36g66EimmP+3HwUOM2kxM22u1c9GALIf43h0M95xEKpPN+afK5J7WFm4GIV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782836834; c=relaxed/simple;
	bh=yoBVt0ErQugKsRPJk0z9dXkMpMXYG0DkMg8IIv8mh9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqXi+DJPKuJYctYoo8gSGWNRiu8Vs7rTMIhPDMXCUykmRoXP92ARw7mkMmOq4K0O97jwbjq65NDfUK1ujxxv8U2zQAmuiBJwwopPkDHsY4K3SNle/Yv8GNyUkswnu0k5JskE2hC5FmhOhVF4gxu4cm6Zu80sajp8SdR5UN5C7n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOJUsJZO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOJUsJZO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6CE4B1F000E9;
	Tue, 30 Jun 2026 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782836832;
	bh=pVj3Z6+tjQhEuU9lG2M4YABNnFvhXns3CcjyctgtlD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HOJUsJZOZAzpCQAf+ykr992MBJcT4fcMbktpbIWKx01H4NMndPYwIO7TocT33sD65
	 ofvgGSGpHJSD9iCXxN2cspf8kv0Rng8v+ZboE77pakkD6Mz0pcx4RvmXgzP7Uf257D
	 mKIAR/MFBJvhG/6wD7niwLu4JB6pH2yT1kMZdl0yofmcB5Pu8Tt3ejD1SiMMjPM3vU
	 fFKvg7fBUDo666AOH9LchEaN9FzqoFmYKoKVWT/GUKhnWLaz1joiiihZ9BzrdMYeWl
	 CYfLp+d9q2Z9cp0Pj74sYf8rRU82cxKYGyHNo3atmmweBn4z/X8q3jJ2tkkfVY2Mw2
	 Sn7WILLS1zyRg==
Date: Tue, 30 Jun 2026 09:27:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
Message-ID: <20260630162712.GC6526@frogsfrogsfrogs>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
 <178278129898.858323.347624126934023375.stgit@frogsfrogsfrogs>
 <20260630054122.GE21007@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630054122.GE21007@lst.de>

On Tue, Jun 30, 2026 at 07:41:22AM +0200, Christoph Hellwig wrote:
> On Mon, Jun 29, 2026 at 06:03:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Codex points out that project quota isn't incompatible with
> > non-enforcing group quota in the kernel, so those shouldn't be
> > incompatible in mkfs either.
> 
> For file systems with XFS_SB_VERSION_QUOTABIT there is no incompatibility
> at all, enforcing or not.
> 
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v6.13.0
> > Fixes: 525f826429a868 ("mkfs: add quota flags when setting up filesystem")
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 3da11c664255b1..a4864c37a8821b 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -976,7 +976,7 @@ static struct opt_params mopts = {
> >  		  .defaultval = 1,
> >  		},
> >  		{ .index = M_PQUOTA,
> > -		  .conflicts = { { &mopts, M_GQNOENFORCE },
> > +		  .conflicts = { { &mopts, M_PQNOENFORCE },
> >  				 { NULL, LAST_CONFLICT } },
> 
> But I think this is just fat-fingering anyway, as it wants to
> conflict the pquota vs pquota no enforce options.  So I think
> the commit log could use some rewording for clarify, but the
> change looks good.

Ok, how about:

"Codex points out that project quota isn't incompatible with
non-enforcing group quota in the kernel, so those shouldn't be
incompatible in mkfs either.

"Furthermore, project and group quotas are never incompatible on
QUOTABIT and V5 filesystems, so this is clearly a fat-finger error."

--D
