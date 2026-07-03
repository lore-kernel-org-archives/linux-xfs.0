Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA5F2C326F
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 15:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093948; cv=none; b=ftLP0bu1Uct4R3dJ/wq9fHXWbCx74U9hyGAEzjFnzIAOZqSZN7hUumK7f8ylHCHd2UeODkedfCukmkPBDQmcIiF1D2bk28dbG39qHEeHIvSs5PbYC41ix0K5G/SFoc/y3NSar1mGhDZo9iJUruI0WWVrcHc843a5u/+BQtLV+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093948; c=relaxed/simple;
	bh=8TYPOPh07ljTjoyWcTt8Rf+669+yiucf9wrnglKpEW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ApQto3bJsLIyaQITeISf97FdLzGLCsDWY46g0DLEfr4v+LOQXL2Ga+uZDGGtzS9zITEHudp5QWZyQgIPaK5Pf1Nl8TNTRTnAiuSb69lxKFtdIWALmxRA3aPj+uu6vz1k5LdNeiZ9Q7a3JfEur1BjShqvcG/3wlEKNIQaagqgKzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klZtfmey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klZtfmey"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B67691F000E9;
	Fri,  3 Jul 2026 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783093946;
	bh=HWtaY3nWw69mD0Xz+e59SRLKzvfNyedu/j/pzgvWt88=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=klZtfmeyXVvf+mGKfINNJ1Ki1Usf40ya5tSscMwJF7hkcVsx1W84lqwAiWybvEpxw
	 zwB0rUymd2NPeZN1UrmGXmlG3crOWSDsPCJ2SV+RgyeHkc8c41fIYHhOfwsymUTd4p
	 EKcZcQclpP3+UpR/8E/ljlXBdU4MmewkR5LEYhbfwDkMZGwuuJrnLOFcpbhXdYiQ+H
	 o41ya+40TrFopqZK+hJySfLLB5W312Djy+q8j+DdHKwj1aklMz/TIrjum0ji7OMSaZ
	 EWMmTm+RRQo5ADbpyQI0BT8xeSMPX4e6UxLz4jz/pUKCccf3Ii/SzQGOiV2zNReB6K
	 GuxDlz1H6LgUg==
Date: Fri, 3 Jul 2026 08:52:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] mkfs: simplify setup_proto file status checks
Message-ID: <20260703155226.GW9392@frogsfrogsfrogs>
References: <20260703084004.9811-2-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703084004.9811-2-liuhuan01@kylinos.cn>

On Fri, Jul 03, 2026 at 04:40:05PM +0800, liuh wrote:
> setup_proto() calls filesize() before validating the source type with
> fstat(), even though both operations ultimately require the same file
> status information.
> 
> Perform a single fstat() immediately after opening the source path and
> reuse the resulting metadata for both source type validation and file
> size retrieval. This simplifies the setup logic and eliminates a
> redundant metadata lookup.
> 
> Signed-off-by: liuh <liuhuan01@kylinos.cn>

Much better now.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/proto.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..5f7a9b15 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -82,14 +82,17 @@ setup_proto(
>  		return result;
>  	}
>  
> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +	if ((fd = open(fname, O_RDONLY)) < 0) {
>  		fprintf(stderr, _("%s: failed to open %s: %s\n"),
>  			progname, fname, strerror(errno));
>  		goto out_fail;
>  	}
>  
> -	if (fstat(fd, &statbuf) < 0)
> -		fail(_("invalid or unreadable source path"), errno);
> +	if (fstat(fd, &statbuf) < 0) {
> +		fprintf(stderr, _("%s: failed to fstat %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		goto out_fail;
> +	}
>  
>  	/*
>  	 * Handle directory inputs.
> @@ -101,6 +104,14 @@ setup_proto(
>  		return result;
>  	}
>  
> +	if (!S_ISREG(statbuf.st_mode)) {
> +		fprintf(stderr, _("%s: %s not a regular file\n"),
> +			progname, fname);
> +		goto out_fail;
> +	}
> +
> +	size = statbuf.st_size;
> +
>  	/*
>  	 * Else this is a protofile, let's handle traditionally.
>  	 */
> -- 
> 2.43.0
> 
> 
