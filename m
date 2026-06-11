Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB462DC767
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 10:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173121; cv=none; b=qhvW0ReUBZ+Q5gLxopxdNUUW3uPqDiTB0OzEfGeXcT829YEXJfp5lODUuUj8T04e1FZm/ghDlaanqVWpT1+mr1mlpeNPZbXSpaQaOmBVINGayUZ3ItJOFWRY6H8OyhCLKCRk1AL4b/XrlfMdReQNorObpjLkYj2fn4qA49Q7jJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173121; c=relaxed/simple;
	bh=NL/8YnlxidLgF6bd5FRVM90hHA/RpGzN1HXDssP7fNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OsjKME8Dd1OKtBsSpEqC3/VABaxcY+1pomKbHYHW4c0i8+XiOf4yky2839IEvtv6jNWu9/fbnng+5VtuIY1AtKejMXuxmXtV42/3gPHy+pAYWmd7y7oWIneyQMYtoIqcJ4IBSo/LZmyQ0xHcSz/cuU0b+dJQb1s2C3jbOZ5ge4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/+4YZqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/+4YZqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE501F00893;
	Thu, 11 Jun 2026 10:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781173120;
	bh=kepuyj6qqbnxK/ob14Oq96NZ5gADSz1vyo57ySS1luI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l/+4YZqERZgFmC7lfycQaZnZa1kNQrvux4rCumbyswimvZuMVlTdq0Ispti92boom
	 gUWV+/xexwwJQz3bJjYSbVyGUegnRVKj++NgOfmKGZlp1rVtI3k0HCbynqGcB21bYC
	 wB+pp9n50EiXEEk4hTgR7gGRXms6zRe2VJk4cBtGeatDd4OZAbZ2ZpvM8iNW6+0JR7
	 KTLBlafZ/oAMazUXDqPeiqGY17Y2tKJxJLJHi+0kCcAgkIJrsEhKjdx+rYfunvwkaP
	 loDJsuZPOgW0UBnQ1SkHseOJDMbzyEdXfT/JjfcOF2Q75TvIZffEkAcOt0ih481JVY
	 nh9d/p76Ar2lQ==
Date: Thu, 11 Jun 2026 12:18:37 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Romain Naour <romain.naour@smile.fr>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfsprogs: include/buildrules: fix ltdep
Message-ID: <aiqGr4ZwkBbfW_U9@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260531194553.1378795-1-romain.naour@smile.fr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531194553.1378795-1-romain.naour@smile.fr>

On 2026-05-31 21:45:53, Romain Naour wrote:
> Our CI uses "/builds/buildroot.org/buildroot" as build directory.
> Unlikely the xfsprogs build system misbehave when a directory in
> the path contain ".o".
> 
> While generating .ltdep, the sed command used to convert object file
> (.o) to libtool object (.lo) replace buildroot.org by buildroot.lorg.
> 
>   .ltdep: $(CFILES) $(HFILES)
>     $(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
> 
> Building libfrog
>     [CC]     gen_crc32table
>     [GENERATE] crc32table.h
> gmake[4]: *** No rule to make target '/builds/buildroot.lorg/buildroot/test-output/TestXfs/host/include/urcu.h', needed by 'avl64.lo'.  Stop.
> 
> Update the sed command to avoid this effect.
> 
> Fixes:
> https://gitlab.com/buildroot.org/buildroot/-/jobs/14607335648
> 
> Signed-off-by: Romain Naour <romain.naour@smile.fr>
> ---
>  include/buildrules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/buildrules b/include/buildrules
> index 871e92db..3fabbe5a 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -140,7 +140,7 @@ rmltdep:
>  	$(Q)rm -f .ltdep
>  
>  .ltdep: $(CFILES) $(HFILES)
> -	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
> +	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o:,\1.lo:,' > .ltdep
>  
>  depend: rmdep .dep
>  
> -- 
> 2.54.0
> 
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

I will pull this and update the sentence Christoph pointed out to:
> xfsprogs build system misbehave when a file path contains ".o".


-- 
- Andrey
