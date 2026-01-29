Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768ED2C028C
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769677062; cv=none; b=L0tt4kAzss5DOB3tSHf7nxQCRVEZkQFKYtyTSlztSiHRk72ZuLAvn8ZW32cBDBZ0BfzJxaH4MqnfiHwcyaJrDrFAcm9Sva5xTPAWuNYz52MA26QcjrVjKGmuDsq/S9+wFlzEtxEbPsqcsS95ojIasBoZtC6a++RHdXaFV/D/a98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769677062; c=relaxed/simple;
	bh=1yD3T2/dFcrwm/yTNMx++8fvvVUai50KxcpxHYjPpOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=six3ACzetY9U16alGvDpIRIl//2qeZHingHOH6+m/01bcILUjdqiHobVw6wRpjyHkrEK87BSfuORQaW93dYeIRmzbCSEh6YID0Iktoy29KqtgomgypCeOqeI4PFftUHFSqI5p5yM1vaAFrOojDw9jVj3aAl7eRp5CSwlfzIjd2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/GolThz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/GolThz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2D4C4CEF7;
	Thu, 29 Jan 2026 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769677062;
	bh=1yD3T2/dFcrwm/yTNMx++8fvvVUai50KxcpxHYjPpOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u/GolThz2daaAJvyrjsdDxOoP0eNGcwwnd30xoSnNQArFNC00yi+5ZGJt7RKW8or+
	 Qoj9PKIfgyvn7MbTBKnbuTU3W6yqG4o88KVlNTxjJBXJRDnSXVBGqK1EvnBVTAKbS7
	 VycVy53DVtdxa2NBjh7NYywS8F0vinaft6+cTqflNkxwDAXdeGU+ZFCf/bFiFNCaLx
	 EyaiNuEkxXv3aSnNOGjBDxzJ36/UT99YCOEmtJ4lW4aBE5X2fuhTRHcBkaOsIwz0re
	 Kl6EuVZeh1i3IoSyv2S/HP4KKvfgN606HXp6yBYJ94EcIW8CTpv8+c0ToK+MtHjWlR
	 Q82spOTo0u54Q==
Date: Thu, 29 Jan 2026 09:57:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>

On Thu, Jan 29, 2026 at 09:52:02AM +0100, Carlos Maiolino wrote:
> On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
> > We should ASSERT on a variable before using it, so that we
> > don't end up using an illegal value.
> > 
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > ---
> >  fs/xfs/xfs_rtalloc.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index a12ffed12391..9fb975171bf8 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
> >  			error = xfs_rtget_summary(oargs, log, bbno, &sum);
> >  			if (error)
> >  				goto out;
> > +			if (sum < 0) {
> > +				ASSERT(sum >= 0);
> > +				error = -EFSCORRUPTED;
> > +				goto out;
> > +			}
> 
> What am I missing here? This looks weird...
> We execute the block if sum is lower than 0, and then we assert it's
> greater or equal than zero? This looks the assert will never fire as it
> will only be checked when sum is always negative.

Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
confusing, it would be better if we just ASSERT(0) there.

> 
> What am I missing from this patch?
> 
> >  			if (sum == 0)
> >  				continue;
> >  			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> > @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
> >  			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
> >  			if (error)
> >  				goto out;
> > -			ASSERT(sum > 0);
> >  		}
> >  	}
> >  	error = 0;
> > -- 
> > 2.43.5
> > 
> > 
> 
