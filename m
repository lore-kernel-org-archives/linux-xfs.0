Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CE51885A5
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 13:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769693380; cv=none; b=bpDX8mtQMCJ27VdxxQROpT/m2ckAAGXiGRhr8l7BZl6Jtf8vhmbsg1ttYjAbNkaTDeJRid61SJg1klxoeuG6QG4qS4jF/sPp4rHjs+fSgxVLQbfEQIeRgBR0E5y7lUS1caL37WR7tWyRtnX0hWT7omqjGLnj7M1eZvYuituDkE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769693380; c=relaxed/simple;
	bh=cV4SD11w6T7d8lOr0O1zgcojQqso6pjptsvpa+lrcXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7b/m/F6shSYNpK69Wy29HIMnUVQ9orlmhKxcKQn/zvP3jZeis9s3IO5DWmRcDnBkOOP3pbb8WrHfRJDMuSBZi4pVTwg4+I19xFmJBncKBO6Xrv6ChIIRM7gmFQqKITzeVq26Z3UWOFaR98U7Cl8MEtXl2DDqW6GUfX3kahujnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLqjcctd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLqjcctd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09879C4CEF7;
	Thu, 29 Jan 2026 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769693379;
	bh=cV4SD11w6T7d8lOr0O1zgcojQqso6pjptsvpa+lrcXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tLqjcctdPWUieUpe0FKybnVBMk8cc1rBxMX+9+dBmP654jT+UPS1sFZ17j+U+5VD5
	 NojWxIDmKYnGCoX75MFN23AvdrXQ4BOq/sgTDvMv3jfv90shSLeBvuvHjisMXP0Egz
	 PlY90vNbacs5w6pAtMpyjJw7b//ORvar588tD7sKS2MR0YFw3w6w0EWRCYpNeTM5kf
	 hyfPYN7k82pl3ipeXoUd9Rqqv3kbZ7MNMN1L6eJhs2UaTSbfbUApnn9ARJJBJ0y4E5
	 yJ1Dzp6c4BDj6PjdSrdVXDF7sLGXB2oViZTr0022wx50PsHkDoWKmUAns7Uk0iclzS
	 yfboIYt4c/mjQ==
Date: Thu, 29 Jan 2026 14:29:35 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
 <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>

On Thu, Jan 29, 2026 at 06:04:20PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 1/29/26 14:27, Carlos Maiolino wrote:
> > On Thu, Jan 29, 2026 at 09:52:02AM +0100, Carlos Maiolino wrote:
> > > On Thu, Jan 29, 2026 at 12:14:41AM +0530, Nirjhar Roy (IBM) wrote:
> > > > We should ASSERT on a variable before using it, so that we
> > > > don't end up using an illegal value.
> > > > 
> > > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > > > ---
> > > >   fs/xfs/xfs_rtalloc.c | 6 +++++-
> > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > > > index a12ffed12391..9fb975171bf8 100644
> > > > --- a/fs/xfs/xfs_rtalloc.c
> > > > +++ b/fs/xfs/xfs_rtalloc.c
> > > > @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
> > > >   			error = xfs_rtget_summary(oargs, log, bbno, &sum);
> > > >   			if (error)
> > > >   				goto out;
> > > > +			if (sum < 0) {
> > > > +				ASSERT(sum >= 0);
> > > > +				error = -EFSCORRUPTED;
> > > > +				goto out;
> > > > +			}
> > > What am I missing here? This looks weird...
> > > We execute the block if sum is lower than 0, and then we assert it's
> > > greater or equal than zero? This looks the assert will never fire as it
> > > will only be checked when sum is always negative.
> > Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
> > confusing, it would be better if we just ASSERT(0) there.
> 
> Well, the idea (as discussed in [1] and [2]) was that we should log that sum
> has been assigned an illegal negative value (using an ASSERT) and then bail
> out.

> 
> [1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/
> 
> [2] https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/

I see. I honestly think this is really ugly, pointless, and confusing at
a first glance (at least for me). The assert location is logged anyway
when it fire.

If I'm the only one who finds this confusing, then fine, otherwise I'd
rather see ASSERT(0) in there.

Darrick, hch, thoughts?

> 
> --NR
> 
> > 
> > > What am I missing from this patch?
> > > 
> > > >   			if (sum == 0)
> > > >   				continue;
> > > >   			error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> > > > @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
> > > >   			error = xfs_rtmodify_summary(nargs, log, bbno, sum);
> > > >   			if (error)
> > > >   				goto out;
> > > > -			ASSERT(sum > 0);
> > > >   		}
> > > >   	}
> > > >   	error = 0;
> > > > -- 
> > > > 2.43.5
> > > > 
> > > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
