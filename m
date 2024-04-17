Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F2513959C
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713367214; cv=none; b=F1hV/TFyCuvHSlrJTN6t/St8Duh8FEncHB9IIRiYi1xUixMxg2a09X0wrf59B0hPRO/XCK36OJrHKMVSgS1oyFO0tJVVLnI5elUXlNYXyKeD59MsQbakw8czfJEh8G6ZdF5Ww0JB/IxWsM/hkH/dHU2lXnMzdcYbznDNJGMLZrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713367214; c=relaxed/simple;
	bh=h6DrCZ9mgp3ydpFQ7tg93DRyu8eeacUQzA2W3ADO+NE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbqrOnM7jUbPxuqIhQcEWoCwP+AZfLPmRrOBD8cS6xa2Snj6YgBjtWAcEmF3k+NJSo6Vg7QXDAZr/pUd+l7AJSJsEGoP5xq+foAmMZEWKPIf4un4vA0xBKhB41nnUc0qSLy0NCq6KcQWeqBbMwN+3RGFm6ISclo0pCwzxWNY/GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYjZRdmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYjZRdmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1496C072AA;
	Wed, 17 Apr 2024 15:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713367214;
	bh=h6DrCZ9mgp3ydpFQ7tg93DRyu8eeacUQzA2W3ADO+NE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYjZRdmRvZcsUyQh7f+d5XvJUIYCYHSHf5AOe/hqTcRl3LGkjjm7hbhXilbM8JkyK
	 GRg2FVHyjlt9TcMeZZ9+bULWSowAikNS31DZFysLPMIIgef566b418ktjPU4vR5d1y
	 9f/vW1fikl9DD+lHW1eUTy6e1rVudp+i3p3kv/kdqqSdVIlxQIVjkPsJeJjDWn/9Xt
	 QMrjXXzlDrBM02RPNm9qiVE0GWo5Jw+qOLaLtZUMWRUOCBjx4N5ABpzsCxhXpQg3HS
	 3eLWxf+Wh3qIh9utxYdatYBDRbMzGQkDOh0OY2ZOT1ZoMm6oyulj/8hF3CYehPepr8
	 JmetqnyQ38Mig==
Date: Wed, 17 Apr 2024 08:20:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/3] xfs_fsr: replace atoi() with strtol()
Message-ID: <20240417152013.GT11948@frogsfrogsfrogs>
References: <20240417125937.917910-1-aalbersh@redhat.com>
 <20240417125937.917910-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417125937.917910-2-aalbersh@redhat.com>

On Wed, Apr 17, 2024 at 02:59:35PM +0200, Andrey Albershteyn wrote:
> Replace atoi() which silently fails with strtol() and report the
> error.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fsr/xfs_fsr.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 02d61ef9399a..cf764755288d 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -164,7 +164,13 @@ main(int argc, char **argv)
>  			usage(1);
>  			break;
>  		case 't':
> -			howlong = atoi(optarg);
> +			errno = 0;
> +			howlong = strtol(optarg, NULL, 10);
> +			if (errno) {
> +				fprintf(stderr, _("%s: invalid interval: %s\n"),

"invalid runtime"?

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +					optarg, strerror(errno));
> +				exit(1);
> +			}
>  			if (howlong > INT_MAX) {
>  				fprintf(stderr,
>  				_("%s: the maximum runtime is %d seconds.\n"),
> @@ -179,10 +185,24 @@ main(int argc, char **argv)
>  			mtab = optarg;
>  			break;
>  		case 'b':
> -			argv_blksz_dio = atoi(optarg);
> +			errno = 0;
> +			argv_blksz_dio = strtol(optarg, NULL, 10);
> +			if (errno) {
> +				fprintf(stderr,
> +					_("%s: invalid block size: %s\n"),
> +					optarg, strerror(errno));
> +				exit(1);
> +			}
>  			break;
>  		case 'p':
> -			npasses = atoi(optarg);
> +			errno = 0;
> +			npasses = strtol(optarg, NULL, 10);
> +			if (errno) {
> +				fprintf(stderr,
> +					_("%s: invalid number of passes: %s\n"),
> +					optarg, strerror(errno));
> +				exit(1);
> +			}
>  			break;
>  		case 'C':
>  			/* Testing opt: coerses frag count in result */
> -- 
> 2.42.0
> 
> 
