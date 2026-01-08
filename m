Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AEB2BDC04;
	Thu,  8 Jan 2026 17:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894928; cv=none; b=aAsP8GJwp3xRqY5sml8VTG3RaX66FErzFDZI6UN352oL8T/+sS19mNYvR0stVcUiXehM8fB+jP/2v+n+QhQZaR5iCYch+6em+nP/v6GJ/adWS2Ra+9UkkHGf3lFSpUn1FETkre7dVUHRI484kw/onbDyc8pFuNkNx/eZ2K8ixWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894928; c=relaxed/simple;
	bh=Hh9h7MLmOeTE/hEFEJdERoNwH6y6sxyuuWb1WD3x5dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P0s0tJ6TT31A2M50DotQ2YafjU9WkX329AHGQ1M4hLhtWF+PeqKGZbaD7VQBYl3QbCrba8VkLwif/SunDc02ksu9gpA4+F2S00r0qJqGSuyMYCocQYXElu9AW2BIDS+PZhVNNob1XUU7ZA70OSD/LOHSfB47ZOV2DS/bIaVQnXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJ4d7Nr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJ4d7Nr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B438C116C6;
	Thu,  8 Jan 2026 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767894927;
	bh=Hh9h7MLmOeTE/hEFEJdERoNwH6y6sxyuuWb1WD3x5dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lJ4d7Nr6QxaapI2ZPUUAv0Gk2unDD8L+GZ6OnOF2Jhtgl/Vd/y2FJ1szKNHa9i7F8
	 C2nem8fgJwwEDRkkmcwSs6EhatQZAOZeAjvYODKAxeuwLNKl4Rfc3s3bFjHouv5DUF
	 sMaOjh1djCWidxMrOEAeunKUUyCs17nZ12PqxQ/gNQR9S76UEaYbKCDX/NWwohH8t/
	 QJz4QsmPOADFPvXMIotIj3JJoWXfmxH9tPz/lTC9uqK/qZVai//ae8KT45avaq14VN
	 aQnn3CSOTgWroOi4RbZvezAyPUHfArm7C3fBkT2UmbCdjfMdOOIz3OGNYBwvTX8ZbS
	 5RjhhSX2+Hp4w==
Date: Thu, 8 Jan 2026 09:55:27 -0800
From: Kees Cook <kees@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Shevchenko <andy@kernel.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <202601080954.272AAE6217@keescook>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
 <202601080905.D1CC8CC@keescook>
 <20260108094242.8b043d248e7877235f606416@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108094242.8b043d248e7877235f606416@linux-foundation.org>

On Thu, Jan 08, 2026 at 09:42:42AM -0800, Andrew Morton wrote:
> On Thu, 8 Jan 2026 09:06:49 -0800 Kees Cook <kees@kernel.org> wrote:
> 
> > On Thu, Jan 08, 2026 at 07:52:15PM +0300, Dmitry Antipov wrote:
> > > Introduce 'memvalue()' which uses 'memparse()' to parse a string
> > > with optional memory suffix into a non-negative number. If parsing
> > > has succeeded, returns 0 and stores the result at the location
> > > specified by the second argument. Otherwise returns -EINVAL and
> > > leaves the location untouched.
> > > 
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > Suggested-by: Kees Cook <kees@kernel.org>
> > > Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> > 
> > LGTM, thanks!
> > 
> > Reviewed-by: Kees Cook <kees@kernel.org>
> 
> Thanks, I'll add both these to mm.git's mm-nonmm-unstable branch for
> testing.
> 
> If XFS people would prefer to take [2/2] via the xfs tree then please
> lmk and I'll send it over when [1/2] is upstreamed.  Or we can take
> both patches via the xfs tree.  Or something.  Sending out an acked-by:
> would be simplest!

I assumed this would go via xfs tree, but I'm happy to do whatever.

-- 
Kees Cook
