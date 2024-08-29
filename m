Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314A71C2A3
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724895004; cv=none; b=qn1s339fCGtRHlJVDOU+lXg/tQ1OhdIEUdAut5L1ISqR81DpytTEuu11N/RPz234vRP6usidc1AptVV7KfrZFz7iBaWc6ZdvoFmJQuocoZ9K7W9mm5kfzcf4wNdUv8IJiZO5WE/XoiRMlzapFrH/O7/K4voZGprSUTd3YI0Ex0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724895004; c=relaxed/simple;
	bh=oDlAsD4UZcE//zZbBF32WzkygTNqKluZ8dLHc+Np7Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SxyelSSDbmjMU92ub5dfr8LWVF6EBJHDnEGljCUGQPiJWlHIIIzhsfU+2toHI7QHIrvx3VaHIEIEQxWKKTXoN18pM9UOjuQOMVuuEo91hEij33YSGDmiWaKQch1zN4mXaIJrYxf3gGU3O7V1wIOG2eZZ8pQvyi8rEM+AS4qEFgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wxlucq56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wxlucq56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969A9C4CEC0;
	Thu, 29 Aug 2024 01:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724895003;
	bh=oDlAsD4UZcE//zZbBF32WzkygTNqKluZ8dLHc+Np7Q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wxlucq566D8qxcGX6XXrt7T9mBL8kRO6jXrOA12GhGYxec3UlE1FAPpafKzOkcn5Q
	 EjYQr5T6YyTkjgdVgWj1Vx36ZhutXTohnVJpYGnTLEeNpnALOfMd8Jt2kPM4yLuqQ6
	 6KOny4L0WXClUv02vprViwfONeZjF49BMEqndQmD6Vw9t5BA1NK48bp0RUwn4G6X+f
	 R5R/6zQ4uIhWl1tvaG+2wiofBlCMRMJl/yP6qlEaWkdg8fpL86SFuR2xacVSCdUaRT
	 JwioOZPK0VITmYGUJ/Ru9m0oGMPHNQ7zo9MYqF8F2/dpUNDVOiq9r/Ieb7FatmpWrt
	 YBUc+27mARKvw==
Date: Wed, 28 Aug 2024 18:30:03 -0700
From: Kees Cook <kees@kernel.org>
To: Sam James <sam@gentoo.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, kernel@mattwhitlock.name,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [RFC PATCH] libxfs: compile with a C++ compiler
Message-ID: <202408281827.14F35138B@keescook>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <20240827234533.GE1977952@frogsfrogsfrogs>
 <87le0hbjms.fsf@gentoo.org>
 <20240828235341.GD6224@frogsfrogsfrogs>
 <87y14g9o7i.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y14g9o7i.fsf@gentoo.org>

On Thu, Aug 29, 2024 at 01:17:53AM +0100, Sam James wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
> > On Wed, Aug 28, 2024 at 01:01:31AM +0100, Sam James wrote:
> >> "Darrick J. Wong" <djwong@kernel.org> writes:
> >> 
> >> > From: Darrick J. Wong <djwong@kernel.org>
> >> >
> >> > Apparently C++ compilers don't like the implicit void* casts that go on
> >> > in the system headers.  Compile a dummy program with the C++ compiler to
> >> > make sure this works, so Darrick has /some/ chance of figuring these
> >> > things out before the users do.
> >> 
> >> Thanks, this is a good idea. Double thanks for the quick fix.
> >> 
> >> 1) yes, it finds the breakage:
> >> Tested-by: Sam James <sam@gentoo.org>
> >> 
> >> 2) with the fix below (CC -> CXX):
> >> Reviewed-by: Sam James <sam@gentoo.org>
> >> 
> >> 3) another thing to think about is:
> >> * -pedantic?
> >
> > -pedantic won't build because C++ doesn't support flexarrays:
> >
> > In file included from ../include/xfs.h:61:
> > ../include/xfs/xfs_fs.h:523:33: error: ISO C++ forbids flexible array member ‘bulkstat’ [-Werror=pedantic]
> >   523 |         struct xfs_bulkstat     bulkstat[];
> >       |                                 ^~~~~~~~
> >
> > even if you wrap it in extern "C" { ... };
> 
> Doh. So the ship has kind of sailed already anyway.
> 
> >
> >> * maybe do one for a bunch of standards? (I think systemd does every
> >> possible value [1])
> >
> > That might be overkill since xfsprogs' build system doesn't have a good
> > mechanism for detecting if a compiler supports a particular standard.
> > I'm not even sure there's a good "reference" C++ standard to pick here,
> > since the kernel doesn't require a C++ compiler.
> >
> >> * doing the above for C as well
> >
> > Hmm, that's a good idea.
> >
> > I think the only relevant standard here is C11 (well really gnu11),
> > because that's what the kernel compiles with since 5.18.  xfsprogs
> > doesn't specify any particular version of C, but perhaps we should match
> > the kernel every time they bump that up?
> 
> Projects are often (IMO far too) conservative with the features they use
> in their headers and I don't think it's unreasonable to match the kernel
> here.
> 
> >
> > IOWs, should we build xfsprogs with -std=gnu11?  The commit changing the
> > kernel to gnu11 (e8c07082a810) remarks that gcc 5.1 supports it just
> > fine.  IIRC RHEL 7 only has 4.8.5 but it's now in extended support so
> > ... who cares?  The oldest supported Debian stable has gcc 8.
> 
> so, I think we should match whatever linux-headers / the uapi rules are,
> and given I've seen flexible array members in there, it's at least C99.
> 
> I did some quick greps and am not sure if we're using any C11 features
> in uapi at least.

-std=gnu11 seems like the correct choice, yes.

> Just don't blame me if someone yells ;)
> 
> (kees, any idea if I'm talking rubbish?)
> 
> tl;dr: let's try gnu11?
> 
> > [...]
> 
> sam

In really ugly cases (i.e. MSVC importing headers into a C++ project in
ACPICA) we did things like:

#if defined(__cplusplus)
# define __FLEX_SIZE	0
#else
# define __FLEX_SIZE	/**/
#endif

...
struct ... {
	...
	struct xfs_bulkstat     bulkstat[__FLEX_SIZE];
	...
};

-- 
Kees Cook
