Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828082D613;
	Wed, 12 Jun 2024 18:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215319; cv=none; b=R89/xri1IDgnqooNNP6EK+Qq6yHvWDU1vNgRu+G5ch2b7OSeI6l7xI66TCVYYryqxtgttgL2x11P5LKTJNB3buuMVTc7XgPTbF22FTQ7To7M4CpHKpeVpCn3UJYBlAIOfmp87vEjvlIhSiCpulvRNsrbOeRWzO9rRTpb0yClptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215319; c=relaxed/simple;
	bh=748dMYk3pOMzwhIULCk1Kyw9IH/mDj341VZv5pizKbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JkTM6x20pdZZWyDgnPIZj/EmGF9fhe2IKSDLMvyFTqiCt39lMzXqAsd4Z3aDewxDyVWYfikoXVWvx/bvWnte8PuClwSiw92gEJwKz/lFMnlSeGtonSN6Bp5prqkDODKnCWZ5fJwHLnAww5nxbZ33gaqNhgLa5oIIbcxgBQbxRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pfa252sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pfa252sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E98C116B1;
	Wed, 12 Jun 2024 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718215319;
	bh=748dMYk3pOMzwhIULCk1Kyw9IH/mDj341VZv5pizKbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pfa252sbHboMcy+YJFw7Hug8epOxhlQHNAZA+kgTc3XUwGTzh3p1bPTP25sSNA9s4
	 O4P4OnszV2pP8h7fzKjF5hTMZ+ICmwUgKstsnOIZ7LmRCJhhLuU9bUpxyeSGNYMfqB
	 5tH9xlUHmzxFLmqBs62iEWZ1wxiouRY3UeQoEjtRyL9/YhRFibGwPGGT4X1ZXkUyd/
	 Lcnc8x/6QiZQwFaDvkx2FBJkBdcuFGlzsHiJVNeiFzicbqx0THwhNzwSJ9F4vyhjdE
	 8uIVWdfsGV1wEIsRHXL/peKnrtbtj4m/HiwQWlStB9hv5TOGpDZUBzt7qdIomBpuVD
	 Q9oO9htujMv8A==
Date: Wed, 12 Jun 2024 11:01:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io: fix mread with length 1 mod page size
Message-ID: <20240612180158.GD2764752@frogsfrogsfrogs>
References: <20240611182928.12813-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240611182928.12813-1-ebiggers@kernel.org>

On Tue, Jun 11, 2024 at 11:29:28AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix a weird bug in mread where if you passed it a length that was 1
> modulo the page size, for example
> 
>         xfs_io -r file -c "mmap -r 0 8192" -c "mread -v 0 4097"
> 
> ... it never reset its pointer into the buffer into which it copies the
> data from the memory map.  This caused an out-of-bounds write, which
> depending on the length passed could be very large and reliably
> segfault.  Also nothing was printed, despite the use of -v option.
> 
> (I don't know if this case gets reached by any existing xfstest, but
> presumably not.  I noticed it while working on a patch to an xfstest.)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Yeah, the current logic doesn't make much sense to me either.
This new stuff reads much more straightforwardly.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  io/mmap.c | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/io/mmap.c b/io/mmap.c
> index 85087f57..4c03e3d5 100644
> --- a/io/mmap.c
> +++ b/io/mmap.c
> @@ -469,38 +469,30 @@ mread_f(
>  	dumplen = length % pagesize;
>  	if (!dumplen)
>  		dumplen = pagesize;
>  
>  	if (rflag) {
> -		for (tmp = length - 1, c = 0; tmp >= 0; tmp--, c = 1) {
> -			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
> -			cnt++;
> -			if (c && cnt == dumplen) {
> +		for (tmp = length - 1; tmp >= 0; tmp--) {
> +			bp[cnt++] = ((char *)mapping->addr)[dumpoffset + tmp];
> +			if (cnt == dumplen) {
>  				if (dump) {
>  					dump_buffer(printoffset, dumplen);
>  					printoffset += dumplen;
>  				}
> -				bp = (char *)io_buffer;
>  				dumplen = pagesize;
>  				cnt = 0;
> -			} else {
> -				bp++;
>  			}
>  		}
>  	} else {
> -		for (tmp = 0, c = 0; tmp < length; tmp++, c = 1) {
> -			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
> -			cnt++;
> -			if (c && cnt == dumplen) {
> +		for (tmp = 0; tmp < length; tmp++) {
> +			bp[cnt++] = ((char *)mapping->addr)[dumpoffset + tmp];
> +			if (cnt == dumplen) {
>  				if (dump)
>  					dump_buffer(printoffset + tmp -
>  						(dumplen - 1), dumplen);
> -				bp = (char *)io_buffer;
>  				dumplen = pagesize;
>  				cnt = 0;
> -			} else {
> -				bp++;
>  			}
>  		}
>  	}
>  	return 0;
>  }
> 
> base-commit: df4bd2d27189a98711fd35965c18bee25a25a9ea
> -- 
> 2.45.1
> 
> 
