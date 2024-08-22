Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1591E13AA2E;
	Thu, 22 Aug 2024 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724359821; cv=none; b=iLWh9wzQnu78gwOWTenHF2d2fUrOuurtQ3577Q8QOgDry4Mbpb/8m7i0fr2JtMoZl/7pVQbGuPd/QUZFgMXvQKowfv7Bra55Cnh/cWsUZcfqHc9hFANvX9ZfrDGkk8uHNZM+JoJYYASocH7nMeBX9tUlo547sF39S8wogj2syU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724359821; c=relaxed/simple;
	bh=gNl21Odq/uU9DDM+7OEsIHOMbNBGRzBhpFTgyc6Md60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNHAnuPktItFfBCDDH0muWlURmw13oq/ABL44gpqeiNnk72ehRrrXgQJBqTIWvzd5r1mmbBiPOPgmpRL2LwC4USKT3qiTao51jOWAKQ3zOI/EFTyfD9Uy2WvLpqrnpMSDCH3QVbWg+Bus6ngE7+nD8z+j/EnHFqgTp6WWvWLjr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rm6zMV6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rm6zMV6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CD7C32782;
	Thu, 22 Aug 2024 20:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724359820;
	bh=gNl21Odq/uU9DDM+7OEsIHOMbNBGRzBhpFTgyc6Md60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rm6zMV6gLzW0/L6tJ6g7YrvyCIayFTuJtQ/DfbZQBKP4xw+cGRouzwDR2ONT2X2Qq
	 5YDTfvB/tlGVMsMD3+VteuuYbGJFEyZ9H/l2Cmh5utmSNTG2D8t19x4hK9x063L+Yl
	 i88vtLTk1PVmUHGroGE+LY8hUGdDcQH/BQqtEJBSr/2lWXir0Oz7NBzqyNOB+bg4IW
	 HbCrVGyA4A2Yc2ZELMh4B1QSFLW+4NCzcDmOrt6ApEckJI/FFT0LUS7+j7O5CkkyyD
	 3TqFqbgAUcKjwyODi9YBEpQJkHj1IO5l3A3RPdf3V5pckHeiLRCKEbXk0L1QaM3qdz
	 jDSRVfBUSEmEA==
Date: Thu, 22 Aug 2024 13:50:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 1/3] fsx: factor out a file size update helper
Message-ID: <20240822205019.GV865349@frogsfrogsfrogs>
References: <20240822144422.188462-1-bfoster@redhat.com>
 <20240822144422.188462-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822144422.188462-2-bfoster@redhat.com>

On Thu, Aug 22, 2024 at 10:44:20AM -0400, Brian Foster wrote:
> In preparation for support for eof page pollution, factor out a file
> size update helper. This updates the internally tracked file size
> based on the upcoming operation and zeroes the appropriate range in
> the good buffer for extending operations.
> 
> Note that a handful of callers currently make these updates after
> performing the associated operation. Order is not important to
> current behavior, but it will be for a follow on patch, so make
> those calls a bit earlier as well.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  ltp/fsx.c | 57 +++++++++++++++++++++++++------------------------------
>  1 file changed, 26 insertions(+), 31 deletions(-)
> 
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 2dc59b06..1389c51d 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -983,6 +983,17 @@ gendata(char *original_buf, char *good_buf, unsigned offset, unsigned size)
>  	}
>  }
>  
> +/*
> + * Helper to update the tracked file size. If the offset begins beyond current
> + * EOF, zero the range from EOF to offset in the good buffer.
> + */
> +void
> +update_file_size(unsigned offset, unsigned size)
> +{
> +	if (offset > file_size)
> +		memset(good_buf + file_size, '\0', offset - file_size);
> +	file_size = offset + size;
> +}
>  
>  void
>  dowrite(unsigned offset, unsigned size)
> @@ -1003,10 +1014,8 @@ dowrite(unsigned offset, unsigned size)
>  	log4(OP_WRITE, offset, size, FL_NONE);
>  
>  	gendata(original_buf, good_buf, offset, size);
> -	if (file_size < offset + size) {
> -		if (file_size < offset)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -		file_size = offset + size;
> +	if (offset + size > file_size) {
> +		update_file_size(offset, size);
>  		if (lite) {
>  			warn("Lite file size bug in fsx!");
>  			report_failure(149);
> @@ -1070,10 +1079,8 @@ domapwrite(unsigned offset, unsigned size)
>  	log4(OP_MAPWRITE, offset, size, FL_NONE);
>  
>  	gendata(original_buf, good_buf, offset, size);
> -	if (file_size < offset + size) {
> -		if (file_size < offset)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -		file_size = offset + size;
> +	if (offset + size > file_size) {
> +		update_file_size(offset, size);
>  		if (lite) {
>  			warn("Lite file size bug in fsx!");
>  			report_failure(200);
> @@ -1136,9 +1143,7 @@ dotruncate(unsigned size)
>  
>  	log4(OP_TRUNCATE, 0, size, FL_NONE);
>  
> -	if (size > file_size)
> -		memset(good_buf + file_size, '\0', size - file_size);
> -	file_size = size;
> +	update_file_size(size, 0);
>  
>  	if (testcalls <= simulatedopcount)
>  		return;
> @@ -1247,6 +1252,9 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	log4(OP_ZERO_RANGE, offset, length,
>  	     keep_size ? FL_KEEP_SIZE : FL_NONE);
>  
> +	if (end_offset > file_size)
> +		update_file_size(offset, length);
> +
>  	if (testcalls <= simulatedopcount)
>  		return;

Don't we only want to do the goodbuf zeroing if we don't bail out due to
the (testcalls <= simulatedopcount) logic?  Same question for
do_clone_range and do_copy_range.

/me reads the second patch but doesn't quite get it. :/

Are you doing this to mirror what the kernel does?  A comment here to
explain why we're doing this differently would help me.

--D

>  
> @@ -1263,17 +1271,6 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
>  	}
>  
>  	memset(good_buf + offset, '\0', length);
> -
> -	if (!keep_size && end_offset > file_size) {
> -		/*
> -		 * If there's a gap between the old file size and the offset of
> -		 * the zero range operation, fill the gap with zeroes.
> -		 */
> -		if (offset > file_size)
> -			memset(good_buf + file_size, '\0', offset - file_size);
> -
> -		file_size = end_offset;
> -	}
>  }
>  
>  #else
> @@ -1538,6 +1535,9 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_CLONE_RANGE, offset, length, dest, FL_NONE);
>  
> +	if (dest + length > file_size)
> +		update_file_size(dest, length);
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1556,10 +1556,6 @@ do_clone_range(unsigned offset, unsigned length, unsigned dest)
>  	}
>  
>  	memcpy(good_buf + dest, good_buf + offset, length);
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
> -	if (dest + length > file_size)
> -		file_size = dest + length;
>  }
>  
>  #else
> @@ -1756,6 +1752,9 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  
>  	log5(OP_COPY_RANGE, offset, length, dest, FL_NONE);
>  
> +	if (dest + length > file_size)
> +		update_file_size(dest, length);
> +
>  	if (testcalls <= simulatedopcount)
>  		return;
>  
> @@ -1792,10 +1791,6 @@ do_copy_range(unsigned offset, unsigned length, unsigned dest)
>  	}
>  
>  	memcpy(good_buf + dest, good_buf + offset, length);
> -	if (dest > file_size)
> -		memset(good_buf + file_size, '\0', dest - file_size);
> -	if (dest + length > file_size)
> -		file_size = dest + length;
>  }
>  
>  #else
> @@ -1846,7 +1841,7 @@ do_preallocate(unsigned offset, unsigned length, int keep_size)
>  
>  	if (end_offset > file_size) {
>  		memset(good_buf + file_size, '\0', end_offset - file_size);
> -		file_size = end_offset;
> +		update_file_size(offset, length);
>  	}
>  
>  	if (testcalls <= simulatedopcount)
> -- 
> 2.45.0
> 
> 
