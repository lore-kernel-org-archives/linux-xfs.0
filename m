Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E93CCFBD
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403513; cv=none; b=ghT1fb5u2OR9bLQNefBXbCsrxJ2/J7UTTszIEgX+kroJ49+X6LC6iq8b42LvWUPsppHRhST/MlvZgeqMN8hDzE05OAO/CN1mW1zgclQItmDTqxQV/TCOByR+ToZDcj6tFawRwBLT1fbUr5Ji/mePT9hs0FkKutNjqyjKHswEO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403513; c=relaxed/simple;
	bh=Y0DO3nu5iFIjCc+uYTBpYR05TGSOsCI2XjcOMx5/vFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2xqPz2ZZHhid1DTzgm8chpp4kHmDTmWSuL4zUBE9zDRrk3BE6t41w1pJQgwasXzyYv4RQ+qKGqTFAsUjMe1yZDkBfJOhYh2iiKmVdrRwos+XAVadRKKD3s4xRkgECfAHReSx2o5J+QdAtl9oGcR0yT8E28HvrV9ZZJadVYwe1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLeAQrVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLeAQrVF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E2CC1F00A3D;
	Thu, 25 Jun 2026 16:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782403509;
	bh=ku/H0fOxOeXUXrI8ZzZeOyKPBySQr99HRU5/FMp9V0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SLeAQrVFddwYkKVg/GMq70NU2x76tSyYtBkis5cjgGA7scPTcZ+Mg9um6aypzlyYa
	 /GpqiZGrUIRsuAjppzzsm3uzJag70MiUhLO1s+1VRjUp0Qxiuclei4YI+ZEVdrwjYr
	 ly6jTozLoOcYLkdzXZBCJfOKq0wJfL27EITKijUjXNzMNG9XX02PnjvtRkUaOdaxK/
	 XzlCRR27FYkNxhgTS93TQjSxrZfw/c3IA72zj7gpLsNBeWG4mK6ISAHIoeEVqGtw/x
	 tNO4/zAYRTQKNguA7E55MhCBRYXgjo8BCmk9pTOiNoFBN80g2o0p0t9uhRS0SaR59D
	 F39RiHisigPzw==
Date: Thu, 25 Jun 2026 09:05:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: liuh <liuhuan01@kylinos.cn>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] mkfs: simplify setup_proto file status checks
Message-ID: <20260625160509.GZ6078@frogsfrogsfrogs>
References: <20260625054445.28751-2-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625054445.28751-2-liuhuan01@kylinos.cn>

On Thu, Jun 25, 2026 at 01:44:46PM +0800, liuh wrote:
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
>  mkfs/proto.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index a460aebd..72fefb6e 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -82,14 +82,17 @@ setup_proto(
>  		return result;
>  	}
>  
> -	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +	if ((fd = open(fname, O_RDONLY|O_NONBLOCK|O_CLOEXEC)) < 0) {

Why is there a random unrelated change here that wasn't in v1?  And
isn't even mentioned in the commit message?

--D

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
