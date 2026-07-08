Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263D231355C
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 05:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487554; cv=none; b=tuhivm/V4q5RL/yaKODQTE7ppt5A98R4EfitGtDezIJpB7zz5jsGkAQ6K/qie32o7AHy0FdeO9kej8hl+c9uB4wYdWmHRm9mgCUTCNEbUpPwba4ltz4IeACVXe8q+5k42rj/uoKM07aItUQeDu9NAomp65WcfgUYfzP6Z4HS0fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487554; c=relaxed/simple;
	bh=vT1In1SOy7ZAOHzr3A5C9BHfljdqMHEsTuJ8JrdUxnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGbUDy4hb34k/RJUgdTSxoozZ6SXqlrG6ICtVSwG+RvV+3sRNpVbu6boLPvXlhuHtVHorNtYipbP9Clda2Uc0tg7u7FX0+j8weupVljUjBkpqfJJnM4vrBHyVvC4HNo1n7FCyZS0lxMFZvvvRBMn97kFPDmXWSJsGbkyzWIq9hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0wiNEKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0wiNEKJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BDBF91F00A3A;
	Wed,  8 Jul 2026 05:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783487552;
	bh=b6523iUcTi3H67GCSoCtXPmbyVzjO+eLSPTUS6NHkZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I0wiNEKJCCMp2dNMKBOENxwvKs4dQCutFYf1ShnQL3cC62TT20OpelLKBzeNY5JWE
	 FpKd8q9ZFqGEZreCeGQ/dF81rlfg3XPlt9w5WG0XHpemQUvB2LLIzFCSft5mAmK5ge
	 xUmz76ZuvFTyuce7lWTEtW9A0rO37sC3dr2LQOMFfrUjXwy2O+O7dYMtbGwGRTiaFY
	 5y4b/VXPTQ30fOhSjq/a1wMLfx15ajAhtfsfA7qV0mU0VlNlN8CnkEtrHLGcJTenpy
	 Qz+d10TneY1PP+lnDPEW8FOEi77F0FACjc8zyRZ8Vg/LykdoSvng1ZmxgAjY6vIFv8
	 jAYxw+3Jf0kRA==
Date: Tue, 7 Jul 2026 22:12:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5] mkfs: simplify setup_proto file status checks
Message-ID: <20260708051232.GE9392@frogsfrogsfrogs>
References: <20260708032301.11458-2-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708032301.11458-2-liuhuan01@kylinos.cn>

On Wed, Jul 08, 2026 at 11:23:02AM +0800, liuh wrote:
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
> ---
>  mkfs/proto.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..ff867afe 100644
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
> @@ -101,6 +104,20 @@ setup_proto(
>  		return result;
>  	}
>  
> +	if (!S_ISREG(statbuf.st_mode)) {
> +		fprintf(stderr, _("%s: %s not a regular file\n"),
> +			progname, fname);
> +		goto out_fail;
> +	}
> +
> +	if (statbuf.st_size < 0) {
> +		fprintf(stderr, _("%s: %s invalid file size\n"),
> +			progname, fname);
> +		goto out_fail;
> +	}
> +
> +	size = statbuf.st_size;

Hmm.  What type is @size, a long?  I imagine you need to fail if
statbuf.st_size >= LONG_MAX too, right?  Not that I expect there are
very many 32-bit systems (such that sizeof(statbuf.st_size) >
sizeof(long)) but we might end up there again with 128-bit off_t some
day.

--D

> +
>  	/*
>  	 * Else this is a protofile, let's handle traditionally.
>  	 */
> -- 
> 2.43.0
> 
> 
