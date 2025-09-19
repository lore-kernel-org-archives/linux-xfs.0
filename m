Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F3223DE7
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758299106; cv=none; b=NgwFRpukmsmkpZfEmn0UF3PPeuHZXZRVOGgQclae8yLftaR6t031GdpSlVZsbgO5uNWKrLteXu0rOzjGXNPzYBeyOrkj5u7F959SMw2UJ6HcV2h7ZwKZaz/WPSx/Jw7tWTIfaZjXgLX3cNatRnf0b/gOVcWhtNWO+20yEi8EpFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758299106; c=relaxed/simple;
	bh=09V0g4NLoeb1DFmo++HYddAzMfpP8gAmuJFVHu43qcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjytGiMnXqtd8V5w47Ip1hWAHQSg9ZObtHNjEqu6Xb1qYKZeCsgc7euIg3lfIVQwAMOIeaz5rnJ0imLn/XcCZfc+f/dwW7xwjw794qN1F7/Pr/wpJ2FV2m3lLaxTX4V6TBGhCNu6PNcQ+UZ401BGw7ZPcogiChtsauYlavt4XFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSWGIBpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSWGIBpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02F3C4CEF0;
	Fri, 19 Sep 2025 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758299105;
	bh=09V0g4NLoeb1DFmo++HYddAzMfpP8gAmuJFVHu43qcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XSWGIBpUnQJictfKuijNtFxEl64OI9PGwV4XLdIzm1t4+W8/dfy3nFo+FfW73y91Y
	 7/dkqvDZ12BLfjpxyIPLjZONr+OlG94kHZ9ezciMEXZ9b1Z+2Ze82/i6g1cmNSAzue
	 p5Oda+Vxd0AnOzM5mgU88WmBZrhaANOseUIhtaWJKxFOKttlynhkAkmPFKVcbgKcpv
	 /kDagF2+b2d04WIw9zUDFG1SJdiJd75+xnABvgfKpVYJeAZbfDgt01aYY1izUgI8/u
	 C4apboF9ueZKZqAUey0oohtRb1ISXH4CcYd9/91byP4B0RNlP/ArJTevwmFj455BSr
	 0yp7kZDY2gI9w==
Date: Fri, 19 Sep 2025 09:25:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: "A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <20250919162505.GP8096@frogsfrogsfrogs>
References: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
 <20250912150044.GN8096@frogsfrogsfrogs>
 <20250918162744.GI8096@frogsfrogsfrogs>
 <sgkgqvif3vdcmgd357pvupw7uqiyirtpp55gq6t2adb2csbltm@5tbqs6ilgmvn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sgkgqvif3vdcmgd357pvupw7uqiyirtpp55gq6t2adb2csbltm@5tbqs6ilgmvn>

On Fri, Sep 19, 2025 at 12:52:46PM +0200, Andrey Albershteyn wrote:
> On 2025-09-18 09:27:44, Darrick J. Wong wrote:
> > On Fri, Sep 12, 2025 at 08:00:44AM -0700, Darrick J. Wong wrote:
> > > On Sat, Sep 06, 2025 at 03:12:07AM -0500, A. Wilcox wrote:
> > > > When building xfsprogs with musl libc, strerror_r returns int as
> > > > specified in POSIX.  This differs from the glibc extension that returns
> > > > char*.  Successful calls will return 0, which will be dereferenced as a
> > > > NULL pointer by (v)fprintf.
> > > > 
> > > > Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>
> > > 
> > > Isn't C fun?
> > > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > Ohh yes it is, this patch broke the build for me:
> 
> do you build gcc + musl?

I don't even know /how/ to do that, even on Debian.

--D

> - Andrey
> 
> > 
> > common.c: In function ‘__str_out’:
> > common.c:129:17: error: ignoring return value of ‘strerror_r’ declared with attribute ‘warn_unused_result’ [-Werror=unused-result]
> >   129 |                 strerror_r(error, buf, DESCR_BUFSZ);
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > <sigh> xfsprogs can't get the XSI version because it defines GNU_SOURCE,
> > and you can't shut up gcc by casting the whole expression to void.
> > 
> > Do you folks remove the -D_GNU_SOURCE from builddefs.in when building
> > against musl?  Or do you leave the definition alone, taking advantage of
> > the fact that #define'ing a symbol is not a guarantee of functionality?
> > 
> > --D
> > 
> > > --D
> > > 
> > > > ---
> > > >  scrub/common.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/scrub/common.c b/scrub/common.c
> > > > index 14cd677b..9437d0ab 100644
> > > > --- a/scrub/common.c
> > > > +++ b/scrub/common.c
> > > > @@ -126,7 +126,8 @@ __str_out(
> > > >  	fprintf(stream, "%s%s: %s: ", stream_start(stream),
> > > >  			_(err_levels[level].string), descr);
> > > >  	if (error) {
> > > > -		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> > > > +		strerror_r(error, buf, DESCR_BUFSZ);
> > > > +		fprintf(stream, _("%s."), buf);
> > > >  	} else {
> > > >  		va_start(args, format);
> > > >  		vfprintf(stream, format, args);
> > > > -- 
> > > > 2.49.0
> > > > 
> > > > 
> > > 
> > 
> 
> 
