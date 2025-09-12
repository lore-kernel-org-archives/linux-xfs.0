Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C9D84D02
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757689245; cv=none; b=c45Oc7PUNphTW6j/UE0ocpf13nP6sC4Uk7lXEYqYuQ0nimjRF83fzXGCuK5yhbGXID3hDrWJnl0tA4n+UbSWl+2m979yg3sFbSmlgtVIpuMLL8Zh7sffv4ZiWSWdVOCFi77OgLe4oKcjj/muVdIVBjUbeBDIpkxPR9qLibBAQUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757689245; c=relaxed/simple;
	bh=AGWRWz8PNpynsRDsutW1Jg2dNQqFV7FaDXvbI0oAC/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PE7P61opfga0kpMA5ZplYS4lqDnDmUI699eYaEP5jTM+lP7TjiyH+LB9Zm/F0CvD2VUTAsgSuH//WwEccxXx2TYoxoWFtIX0QOSE+dQY98brSgeneNMGGwSBJlA1Snu5GrFFU0bAEZaU6+/ufTwteLySi35Ki6Z2DNCPf7kPSI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eR6wFtI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR6wFtI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1249DC4CEF1;
	Fri, 12 Sep 2025 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757689245;
	bh=AGWRWz8PNpynsRDsutW1Jg2dNQqFV7FaDXvbI0oAC/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eR6wFtI4wJ8EROaoupcQ9QsSNkSZEqa7F1U19pZ96crIqeLfu2aY6I3LpqNegkzCz
	 zmlIqw1iqWQOm4jTTOPLk+LXAEja8j3eWon8a494WwqLbBWOcZvW/x2bgz02+WMAyU
	 GagS2F0jQRQUDc8agAQdZ4Hp0E1cGs0PJ3bctRrhsNpFEq63XEANUCcqE+V/vBPCe6
	 jE6deLEPUFgVxPKZ7IMMAO+oLWB7RXhnm30bJ0mSoFqbLECjkwyOBS9Q65AlRmVdMw
	 wV2Y0cABhI/Co3o/xhzIMdLzxYIVWeDbgNaoR0MNy6vI7aY0SzoE93CIXCBEuruuqX
	 a34TCKxRfVOLA==
Date: Fri, 12 Sep 2025 08:00:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: Use POSIX-conformant strerror_r
Message-ID: <20250912150044.GN8096@frogsfrogsfrogs>
References: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906081222.64798-1-AWilcox@Wilcox-Tech.com>

On Sat, Sep 06, 2025 at 03:12:07AM -0500, A. Wilcox wrote:
> When building xfsprogs with musl libc, strerror_r returns int as
> specified in POSIX.  This differs from the glibc extension that returns
> char*.  Successful calls will return 0, which will be dereferenced as a
> NULL pointer by (v)fprintf.
> 
> Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>

Isn't C fun?
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  scrub/common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 14cd677b..9437d0ab 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -126,7 +126,8 @@ __str_out(
>  	fprintf(stream, "%s%s: %s: ", stream_start(stream),
>  			_(err_levels[level].string), descr);
>  	if (error) {
> -		fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> +		strerror_r(error, buf, DESCR_BUFSZ);
> +		fprintf(stream, _("%s."), buf);
>  	} else {
>  		va_start(args, format);
>  		vfprintf(stream, format, args);
> -- 
> 2.49.0
> 
> 
