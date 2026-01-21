Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B510847A0AF
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768985878; cv=none; b=FKDCGyA/ZUxvRwAmLklzEsFj8RuYfn3gtApq9IUu+5RW1wLtrDwGI/cvRzsqcFK/J1BUn1Jr7RenSnXQmxrR86k0GYSMKlESM1i9QJ3AQCcBAHPpHNA3wBHzVhIogwPTYV8ShttN1txN1E/CifyJ6qVecQewa3KeKZ1Uyq5e/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768985878; c=relaxed/simple;
	bh=sde0n5HtN5NQVp1Ieexu+6v8toVs3cg+sj4uZjz6UuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oG8GRUY5c7B1rySbjIZguxfeOzjuykH1v4jvr97IQZ80/MhOrR43i5WWQ20oWSEPmi3YT2lz9xDjHaUOGCzMAsGTn/77CKwayAih/cdc2n3vryntA9eOAPIfGZNX1+Rjpd6XC6P9sMV6F3CpklTwnAYWYT1nBqW8avoYc79RKf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hb9Wr2uI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hb9Wr2uI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBA3C116D0;
	Wed, 21 Jan 2026 08:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768985878;
	bh=sde0n5HtN5NQVp1Ieexu+6v8toVs3cg+sj4uZjz6UuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hb9Wr2uImHt/UlpTW69fm7G3lnvDs52aF5zN483sND9OSa7iL5I/OccGWs/LGnNoY
	 +TDE/NJNkUkTCLJ0u0sQL3cW8Bq9COY9v1FVwbsXFW+J0zrn+J9liowq1uau2a/EiS
	 22zAos/uc2s/WlolBAfAFSsxrkLBFM0ZtKPQrzzRr5NkeE714n2S2JzuaR9SZtZO6n
	 FMtGv3Tg1o2XnBY95d8M7PZE43Hm5Sr6ZZH9VYazylFWGpx7dX3tlzQ0twkou3+Jmz
	 g/b/HSoce7TcdQHegVmEVihjwGKjZk8Fa6rrvqF/SX7tuB56ym3wRXravwFfAymX4n
	 d2/QWunKcYTlQ==
Date: Wed, 21 Jan 2026 09:57:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] libfrog: make xfrog_defragrange return a
 positive valued
Message-ID: <s3welc2n2qbdqdr4nuwgef4uwckjkq4lzzsnzp3vzxozpkoy6w@hym4evwdf63k>
References: <20260119142724.284933-1-cem@kernel.org>
 <20260119142724.284933-2-cem@kernel.org>
 <NqW0yjXmDmicRQzL8BBvI3zJRK8Qmhm9mhV6AsYNCDn2zFHjCElMSAXi-jDCnnq8-zvHN_5Q8qsmw24M-wpFtg==@protonmail.internalid>
 <20260120172039.GO15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120172039.GO15551@frogsfrogsfrogs>

On Tue, Jan 20, 2026 at 09:20:39AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 19, 2026 at 03:26:50PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Currently, the only user for xfrog_defragrange is xfs_fsr's packfile(),
> > which expects error to be a positive value.
> >
> > Whenever xfrog_defragrange fails, the switch case always falls into the
> > default clausule, making the error message pointless.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  libfrog/file_exchange.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
> > index e6c3f486b0ff..31bbc6da60c3 100644
> > --- a/libfrog/file_exchange.c
> > +++ b/libfrog/file_exchange.c
> > @@ -232,7 +232,7 @@ xfrog_defragrange(
> >  	if (ret) {
> >  		if (errno == EOPNOTSUPP || errno != ENOTTY)
> >  			goto legacy_fallback;
> > -		return -errno;
> > +		return errno;
> 
> Hrmm.  If you're going to change the polarity of the error numbers (e.g.
> negative to positive) then please update the comments.

Sorry, I did it quickly and didn't even pay attention there were
comments :)

> 
> That said, I'd prefer to keep the errno polarity the same at least
> within a .c file ... even though libfrog is a mess of different error
> number return strategies.  What if the callsite changed to:
> 
> 	/* Swap the extents */
> 	error = -xfrog_defragrange(...);

This looks to just add more confusion to it IMHO, it's not 'easy' for me
at least to notice the minus sign in front of it.

What about just changing the switch case to catch for -ERROR instead of
their positive counterparts? At least we stop playing the error sign
change and just catch what we already have.


> 
> and
> 
> 	/* Snapshot file_fd before we start copying data... */
> 	error = -xfrog_defragrange_prep(...);
> 
> (and I guess io/exchrange.c also needs a fix)
> 
> 	/* Snapshot the original file metadata in anticipation... */
> 	ret = -xfrog_commitrange_prep(...);
> 
> Hrm?
> 
> --D
> 
> >  	}
> >
> >  	return 0;
> > @@ -240,7 +240,7 @@ xfrog_defragrange(
> >  legacy_fallback:
> >  	ret = xfrog_ioc_swapext(file2_fd, xdf);
> >  	if (ret)
> > -		return -errno;
> > +		return errno;
> >
> >  	return 0;
> >  }
> > --
> > 2.52.0
> >
> >
> 
