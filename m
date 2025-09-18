Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14379262FDD
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758212865; cv=none; b=F/dWUv83zsL/+K0fQecgM3zrf+k3RLt9UDUxxGcfZD87Vlzasve4ccmHXYct0PYZC74gcQ416cfgZCoIf5WRnUqj6IsNe9UvKiShYWgKbh2c+/9CPV3tTv2jd4MnSbdirlx8az3NZ+tuqtpSb6R/5PyBtApZQPYYWsBmnddzI44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758212865; c=relaxed/simple;
	bh=fWI9l1wBoITawk8z+S7Yy4S5K0QiKsEqPjgcYVNl30E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dn3NLHStan2kr5YJadWcZfoOLoKLZxGJ7f4KCXeqPmM1BllgNsGnbxWHi7NYMReYWfUAIyqar/RFCKCSqhetv2z66Ndzkd+SUYtKji1PnQ5ef2S9UX6s9XU7YZXIEcTmAFzomJ8bsF+fpBPgyU2YhNOhxj3F7TNUrMdSzfPQ7n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KemAheOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KemAheOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE4AC4CEFB;
	Thu, 18 Sep 2025 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758212864;
	bh=fWI9l1wBoITawk8z+S7Yy4S5K0QiKsEqPjgcYVNl30E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KemAheOb3pttLxMkU0xU97XzVwjsqwxhf9BLqQq/FR3davmUgsd41D9NDCMr9TbwU
	 izO/xKdf3wtlZh8KSNYsfquGYMkTUq0oZRd4UjuFZnX4o/HbCsIxYjeyVkhASPQwe6
	 rbgtkYU/JBjN9f0Obp2QGPOVstDLxcAXmuL7VQnVKu5NLJlMERuStvIm/jeDhDzrWz
	 7rVTGTiCk+D5FsFptnVM0yEetyuPzeBDNDThSifJT5EOJEcjzqnI4qJwGkfOAd/sbj
	 tUtQcPlxS3wBiZdmq50IKwSlvS6jWPj9elchzm3uu/hWliG6hoQcWLWKHOZUkga0hG
	 OplRM7YT6DyGA==
Date: Thu, 18 Sep 2025 09:27:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>
Subject: Re: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <20250918162744.GI8096@frogsfrogsfrogs>
References: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
 <20250912150044.GN8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250912150044.GN8096@frogsfrogsfrogs>

On Fri, Sep 12, 2025 at 08:00:44AM -0700, Darrick J. Wong wrote:
> On Sat, Sep 06, 2025 at 03:12:07AM -0500, A. Wilcox wrote:
> > When building xfsprogs with musl libc, strerror_r returns int as
> > specified in POSIX.  This differs from the glibc extension that returns
> > char*.  Successful calls will return 0, which will be dereferenced as a
> > NULL pointer by (v)fprintf.
> > 
> > Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>
> 
> Isn't C fun?
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Ohh yes it is, this patch broke the build for me:

common.c: In function ‘__str_out’:
common.c:129:17: error: ignoring return value of ‘strerror_r’ declared with attribute ‘warn_unused_result’ [-Werror=unused-result]
  129 |                 strerror_r(error, buf, DESCR_BUFSZ);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

<sigh> xfsprogs can't get the XSI version because it defines GNU_SOURCE,
and you can't shut up gcc by casting the whole expression to void.

Do you folks remove the -D_GNU_SOURCE from builddefs.in when building
against musl?  Or do you leave the definition alone, taking advantage of
the fact that #define'ing a symbol is not a guarantee of functionality?

--D

> --D
> 
> > ---
> >  scrub/common.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/scrub/common.c b/scrub/common.c
> > index 14cd677b..9437d0ab 100644
> > --- a/scrub/common.c
> > +++ b/scrub/common.c
> > @@ -126,7 +126,8 @@ __str_out(
> >  	fprintf(stream, "%s%s: %s: ", stream_start(stream),
> >  			_(err_levels[level].string), descr);
> >  	if (error) {
> > -		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> > +		strerror_r(error, buf, DESCR_BUFSZ);
> > +		fprintf(stream, _("%s."), buf);
> >  	} else {
> >  		va_start(args, format);
> >  		vfprintf(stream, format, args);
> > -- 
> > 2.49.0
> > 
> > 
> 
