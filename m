Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC66199A2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 22:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717714283; cv=none; b=AYE3ZHRwXmXJqXu74BgHtRYdXi/Y0zGm7eWqtfJicAwu3LGJYWnMJ+AyZ9kgfKI/PCPBE6MKfq7hRvsiNLclGJdoK4BgohByqrh9YujFgfIhUpeqmTFx64prBBeuX/F2zKHWwsLgSF+o1a9feXIOkJFbbttgufmpS8q1+ADWlNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717714283; c=relaxed/simple;
	bh=Npm8mg4frdJ5h/j3+kg0uDnaom8mOzLVNOL16q4gA+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIzV1IYHIPhVj/fnMHuGmTz93wG357AWPcLJmdWM5kGo8QELVn/8+dseG74WSD9r7Ad82ZNfSVKaNzaTMYunkuqJaDtj53y3n07vA+TqtxpXlt73Mm+oViHkJSIHL45YsWSbmNaJ+q7GanzW5ikxrjdtkcj3Xw4hg4lhLzf2UYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XClUPi2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XClUPi2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BB4C2BD10;
	Thu,  6 Jun 2024 22:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717714283;
	bh=Npm8mg4frdJ5h/j3+kg0uDnaom8mOzLVNOL16q4gA+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XClUPi2A4Bf54TxKx51h9NEyFmVAqIYfBwAFGNSKj+CJbXYwlNB8MirrehGlprjus
	 t1k3F6YnTQX3Wha5dwTbCTlR4PSz4j8eDm6UGHJRK32ZTHHQHctp02uW4JrGCxHZUI
	 EG1983qX+sih2dgi/6xs6KdnSpCnAgtrKIWsqxE2mcLdcFJrUTHu74vcdzQnORge95
	 G3M9tfEs1411bi4DhrhpFy5UlKdrR118kz3Q2i7a6Qq5lU++lnuij3wGlOOJdvLE8Q
	 NW1tzO+Hiq1N2VoIHksm5UUu88LM5nTcaJ8TvaMfsE/IZHZL6rB3AEI4Pm3QooQs5f
	 ghh+bhbVlak7Q==
Date: Thu, 6 Jun 2024 15:51:22 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Zorro Lang <zlang@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfsprogs: remove platform_zero_range wrapper
Message-ID: <20240606225122.GO52987@frogsfrogsfrogs>
References: <a216140e-1c8a-4d04-ba46-670646498622@redhat.com>
 <20240606152859.GL52987@frogsfrogsfrogs>
 <31e32825-cad7-479d-9ef6-9a086fce1689@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31e32825-cad7-479d-9ef6-9a086fce1689@sandeen.net>

On Thu, Jun 06, 2024 at 02:27:34PM -0500, Eric Sandeen wrote:
> On 6/6/24 10:28 AM, Darrick J. Wong wrote:
> > On Wed, Jun 05, 2024 at 10:38:20PM -0500, Eric Sandeen wrote:
> >> Now that the guard around including <linux/falloc.h> in
> >> linux/xfs.h has been removed via
> >> 15fb447f ("configure: don't check for fallocate"),
> >> bad things can happen because we reference fallocate in
> >> <xfs/linux.h> without defining _GNU_SOURCE:
> >>
> >> $ cat test.c
> >> #include <xfs/linux.h>
> >>
> >> int main(void)
> >> {
> >> 	return 0;
> >> }
> >>
> >> $ gcc -o test test.c
> >> In file included from test.c:1:
> >> /usr/include/xfs/linux.h: In function ‘platform_zero_range’:
> >> /usr/include/xfs/linux.h:186:15: error: implicit declaration of function ‘fallocate’ [-Wimplicit-function-declaration]
> >>   186 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> >>       |               ^~~~~~~~~
> >>
> >> i.e. xfs/linux.h includes fcntl.h without _GNU_SOURCE, so we
> >> don't get an fallocate prototype.
> >>
> >> Rather than playing games with header files, just remove the
> >> platform_zero_range() wrapper - we have only one platform, and
> >> only one caller after all - and simply call fallocate directly
> >> if we have the FALLOC_FL_ZERO_RANGE flag defined.
> >>
> >> (LTP also runs into this sort of problem at configure time ...)
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> NOTE: compile tested only
> >>
> >> diff --git a/include/linux.h b/include/linux.h
> >> index 95a0deee..a13072d2 100644
> >> --- a/include/linux.h
> >> +++ b/include/linux.h
> >> @@ -174,24 +174,6 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
> >>  	endmntent(cursor->mtabp);
> >>  }
> >>  
> >> -#if defined(FALLOC_FL_ZERO_RANGE)
> >> -static inline int
> >> -platform_zero_range(
> >> -	int		fd,
> >> -	xfs_off_t	start,
> >> -	size_t		len)
> >> -{
> >> -	int ret;
> >> -
> >> -	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
> >> -	if (!ret)
> >> -		return 0;
> >> -	return -errno;
> >> -}
> >> -#else
> >> -#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
> >> -#endif
> > 
> > Technically speaking, this is an abi change in the xfs library headers
> > so you can't just yank this without a deprecation period.  That said,
> > debian codesearch doesn't show any users ... so if there's nothing in
> > RHEL/Fedora then perhaps it's ok to do that?
> > 
> > Fedora magazine pointed me at "sourcegraph" so I tried:
> > https://sourcegraph.com/search?q=context:global+repo:%5Esrc.fedoraproject.org/+platform_zero_range&patternType=regexp&sm=0
> > 
> > It shows no callers, but it doesn't show the definition either.
> 
> Uh, yeah, I suppose so. It probably never should have been here, as it's
> only there for mkfs log discard fun.
> 
> I don't see any good way around this. We could #define _GNU_SOURCE at the
> top, but if anyone else does:
> 
> #include <fcntl.h>
> #include <xfs/linux.h> // <- #defines _GNU_SOURCE before fcntl.h
> 
> we'd already have the fcntl.h guards and still not enable fallocate.
> 
> The only thing that saved us in the past was the guard around including
> <falloc.h> because nobody (*) #defined HAVE_FALLOCATE

HAH.  You're right, nobody did taht.

> so arguably removing that guard was an "abi change" because now it's exposed
> by default.
> 
> (I guess that also means that nobody got platform_zero_range() without
> first defining HAVE_FALLOCATE which would be ... unexpected?)
> 
> * except LTP at configure time, LOLZ

Heh.  Ok, this is fine with me then.

> >> -
> >>  /*
> >>   * Use SIGKILL to simulate an immediate program crash, without a chance to run
> >>   * atexit handlers.
> >> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> >> index 153007d5..e5b6b5de 100644
> >> --- a/libxfs/rdwr.c
> >> +++ b/libxfs/rdwr.c
> >> @@ -67,17 +67,19 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
> >>  	ssize_t		zsize, bytes;
> >>  	size_t		len_bytes;
> >>  	char		*z;
> >> -	int		error;
> >> +	int		error = 0;
> > 
> > Is this declaration going to cause build warnings about unused variables
> > if built on a system that doesn't have FALLOC_FL_ZERO_RANGE?
> 
> I suppose.
> 
> > (Maybe we don't care?)
> 
> Maybe not!
> 
> Maybe I should have omitted the initialization so you didn't notice :P

Oh I'd have noticed anyway. :P

> I could #ifdef around the variable declaration, or I could drop the
> error variable altogether and do:
> 
> 	if (!fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes)) {
> 		xfs_buftarg_trip_write(btp);
> 		return 0;
> 	}
> 
> if that's better?

Yeah I guess so.  Better than more #ifdef around the declarations.

--D

> Thanks,
> -Eric
> 
> > --D
> > 
> >>  
> >>  	start_offset = LIBXFS_BBTOOFF64(start);
> >>  
> >>  	/* try to use special zeroing methods, fall back to writes if needed */
> >>  	len_bytes = LIBXFS_BBTOOFF64(len);
> >> -	error = platform_zero_range(fd, start_offset, len_bytes);
> >> +#if defined(FALLOC_FL_ZERO_RANGE)
> >> +	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
> >>  	if (!error) {
> >>  		xfs_buftarg_trip_write(btp);
> >>  		return 0;
> >>  	}
> >> +#endif
> >>  
> >>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
> >>  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
> >>
> >>
> > 
> 
> 
