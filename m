Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0694206F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713300551; cv=none; b=RcsymswbesdrmhejjMVPz1kPPxJvPl+7U+x/P1x3TPCA8v2R82Hjpk/2fdwOhknJ+zvpEgWEOZ/MJCOj/eOtrcP7DU1mHlWOEv1D6iyX8ih1fKnQadLP3nezcb25MpQi4CzvNN50kQTi9t0J2U1enp0Gm62q3m/BXqr9yE4GLwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713300551; c=relaxed/simple;
	bh=civA9FgZ0KnbZ9ewzmiEFm01m+MbFVWbuHsd45Jxgac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cjPFiRwVDCizNsSvtUA+rXu13pq6kn+FI/2groMNvrUUBUbInWBWRmH+hnjwpIvFtN2/Q3zanm2q4/pLk0TPKWQqrXotWqsw1mbCL9iwY5f2iKIOchRubeOjwPNSCzSpi3YxRausTDFnpulsV2wDi3d6WuzzVy4hXbha9XVL1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iS99d5+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iS99d5+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238D7C113CE;
	Tue, 16 Apr 2024 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713300551;
	bh=civA9FgZ0KnbZ9ewzmiEFm01m+MbFVWbuHsd45Jxgac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iS99d5+tsJZ1e6GREdHs4MnyiM5/GIklES175+dm0XRfgnLzIR7dDFAkVdmTgK4o7
	 Hat4+5mEL2SEeeV+MkCBgTBAClhjs1EjIp8lulEci7gEdgWxmzf+jns+cORXmPfPmi
	 y6yY0Lc36xLpCvSRT0onGk0N6JCArUkfppkBrRsJqE9Ul/AyMQ4WIwy9nLvTW2T8fc
	 h46iNMSEA4L+oVL+BdGlLgWVbgwi4iIPbJM47sOQTh8gsV1QhO+Rw+UBQm/98cnuTI
	 1yoiqM488SYsU4GIqCO1sXsST9Dpg1XsFKegb25DRfZPHbNBT33ePaqF3+xtN6BPV5
	 njSU0EeK7fgWw==
Date: Tue, 16 Apr 2024 13:49:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] xfs_fsr: replace atoi() with strtol()
Message-ID: <20240416204910.GD11948@frogsfrogsfrogs>
References: <20240416202841.725706-2-aalbersh@redhat.com>
 <20240416202841.725706-3-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416202841.725706-3-aalbersh@redhat.com>

On Tue, Apr 16, 2024 at 10:28:41PM +0200, Andrey Albershteyn wrote:
> Replace atoi() which silently fails with strtol() and report the
> error.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fsr/xfs_fsr.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 4e29a8a2c548..5fabc965183e 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -164,7 +164,12 @@ main(int argc, char **argv)
>  			usage(1);
>  			break;
>  		case 't':
> -			howlong = atoi(optarg);
> +			howlong = strtol(optarg, NULL, 10);

C library functions don't clear errno; they only set it after something
goes wrong.  For functions that don't return -1 to indicate that
something went wrong, you have to clear errno explicitly before calling
the function:

	errno = 0;
	howlong = strtol(optarg, NULL, 10);
	if (errno)
		fprintf(...);

If you don't clear it, you can then pick up an errno set by some past
library call, which can lead to strange error messages.

--D

> +			if (errno) {
> +				fprintf(stderr, _("%s: invalid interval: %s\n"),
> +					progname, strerror(errno));
> +				exit(1);
> +			}
>  			if (howlong > INT_MAX) {
>  				fprintf(stderr, _("%s: too long\n"), progname);
>  				exit(1);
> @@ -177,10 +182,22 @@ main(int argc, char **argv)
>  			mtab = optarg;
>  			break;
>  		case 'b':
> -			argv_blksz_dio = atoi(optarg);
> +			argv_blksz_dio = strtol(optarg, NULL, 10);
> +			if (errno) {
> +				fprintf(stderr,
> +					_("%s: invalid block size: %s\n"),
> +					progname, strerror(errno));
> +				exit(1);
> +			}
>  			break;
>  		case 'p':
> -			npasses = atoi(optarg);
> +			npasses = strtol(optarg, NULL, 10);
> +			if (errno) {
> +				fprintf(stderr,
> +					_("%s: invalid number of passes: %s\n"),
> +					progname, strerror(errno));
> +				exit(1);
> +			}
>  			break;
>  		case 'C':
>  			/* Testing opt: coerses frag count in result */
> -- 
> 2.42.0
> 
> 
