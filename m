Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D44B2EB876
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762533463; cv=none; b=fUoJhuPOKgN/0SjSrDDFDUhCJoAngl7RyWNoRLk7dScoOVtHo64Rsw1hStjgVhCvB+EXKxkLyLlSKj+cgSOKCGRDbAK6PmIL7D9F2T4LV9QFUZaPseyFN9+flCFG0reXG6DgUr/q69lerxjXdlE15m/8jn9Dg44QlxuoSV44+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762533463; c=relaxed/simple;
	bh=ud7tnY0RzGPuRr0SZYCBwZXO8u4nNJPKUtqiRRitaOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ni4lU7kzOc/zEouDWRhbdj3T/6ny2jJOU4VKXNlYUdsxRV7XDlnelgTLODjw2E+L23chA9gurgvL8oMyEOw/QnjhXKzTJSX7HNyIHJRw0BglJswvH7hxw+IOjtzuSTqPAfkMZOGaVMHUNUIX9Sq0gneuz31rni1Z3BO+bsfO/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QM1oM5Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QM1oM5Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DBDC4CEF7;
	Fri,  7 Nov 2025 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762533462;
	bh=ud7tnY0RzGPuRr0SZYCBwZXO8u4nNJPKUtqiRRitaOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QM1oM5JsRQcFfuenVEoV0LPgYVu2WVzpl3X8ZogjBeqgMVjtYCBZeaX7nqGnWeBf1
	 2xVAV2NdV7NG5bf7l+oKQ8sO6MoVefPrpqvXGvcAMKGcDnkP9sZPlcY7pRx6w+RLYg
	 rZwsTa1KgZel2CWwfUpUc0Dlzve3t3ysrJ640Nm5t9taUWu2IPqp3j2yemZDfqLpL9
	 33zDWxbJTJJB2gwOJTymxKxc5D9fUCmMi93p2rw5ZH6MBOGGJJx9q4hrTJ9++KITtp
	 E6xHTfZ2RAOri1m3S1Cuh3cp/rKRVeBhrQp4NFrzPT/tiE8rPkchr0pjEyat1gYia4
	 lwl3p0EPpx/RA==
Date: Fri, 7 Nov 2025 08:37:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev
Subject: Re: [PATCH v1] libxfs: support reproducible filesystems using
 deterministic time/seed
Message-ID: <20251107163741.GJ196391@frogsfrogsfrogs>
References: <20251107161242.3659615-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107161242.3659615-1-luca.dimaio1@gmail.com>

On Fri, Nov 07, 2025 at 05:12:41PM +0100, Luca Di Maio wrote:
> Add support for reproducible filesystem creation through two environment
> variables that enable deterministic behavior when building XFS filesystems.
> 
> SOURCE_DATE_EPOCH support:
> When SOURCE_DATE_EPOCH is set, use its value for all filesystem timestamps
> instead of the current time. This follows the reproducible builds
> specification (https://reproducible-builds.org/specs/source-date-epoch/)
> and ensures consistent inode timestamps across builds.
> 
> DETERMINISTIC_SEED support:
> When DETERMINISTIC_SEED is set, use it to generate deterministic values
> from get_random_u32() instead of reading from /dev/urandom. This ensures
> that UUIDs, and other randomly-selected values are consistent across builds.
> 
> The implementation introduces two helper functions to minimize changes
> to existing code:
> 
> - current_fixed_time(): Helper that parses and caches SOURCE_DATE_EPOCH.
>   Returns fixed timestamp when set, with fallback on parse errors.
> - get_msws_prng_32(): Helper implementing Middle Square Weyl Sequence PRNG.
>   Uses DETERMINISTIC_SEED to generate deterministic pseudo-random sequence.
>   Accepts decimal/hex/octal values via base-0 parsing.
> - Both helpers use one-time initialization to avoid repeated getenv() calls.
> - Both quickly exit and noop if environment is not set or has invalid
>   variables, falling back to original behaviour.
> 
> Example usage:
>   SOURCE_DATE_EPOCH=1234567890 \
>   DETERMINISTIC_SEED=0xDEADBEEF \
>   mkfs.xfs \
> 	-m uuid=$EXAMPLE_UUID \
> 	-p file=./rootfs \
> 	disk1.img
> 
> This enables distributions and build systems to create bit-for-bit
> identical XFS filesystems when needed for verification and debugging.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  libxfs/util.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 132 insertions(+)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 3597850d..676da81b 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -137,12 +137,69 @@ xfs_log_calc_unit_res(
>  	return unit_bytes;
>  }
>  
> +/*
> + * current_fixed_time() tries to detect if SOURCE_DATE_EPOCH is in our
> + * environment, and set input timespec's timestamp to that value.
> + *
> + * Returns true on success, fail otherwise.
> + */
> +bool
> +current_fixed_time(
> +	struct			timespec64 *tv)
> +{
> +	/*
> +	 * To avoid many getenv() we'll use an initialization static flag, so
> +	 * we only read once.
> +	 */
> +	static bool		read_env = false;
> +	static time64_t		epoch = -1;
> +	char			*source_date_epoch;
> +
> +	if (!read_env) {
> +		read_env = true;
> +		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
> +		if (source_date_epoch && source_date_epoch[0] != '\0') {
> +			errno = 0;
> +			epoch = strtoul(source_date_epoch, NULL, 10);

time64_t is an alias for long long int, I think you want strtoll here.

Also you ought to provide an endptr so that you can check that strtoll
consumed the entire $SOURCE_DATE_EPOCH string.  The
reproducible-builds.org spec you reference above says:

"The value MUST be an ASCII representation of an integer with no
fractional component, identical to the output format of date +%s."

which I interpret to mean that

# SOURCE_DATE_EPOCH=35hotdogs mkfs.xfs -f /dev/sda ...

shouldn't be allowed.

> +			if (errno != 0) {
> +				epoch = -1;
> +				return false;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * This will happen only if we successfully read a valid
> +	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
> +	 */
> +	if (read_env && epoch >= 0) {

Why disallow negative timestamps?  Suppose I want all the new files to
have a timestamp of November 5th, 1955?

> +		tv->tv_sec = (time_t)epoch;

time_t can be 32-bit; don't needlessly truncate epoch.

> +		tv->tv_nsec = 0;
> +		return true;
> +	}
> +
> +	/*
> +	 * We initialized but had no valid SOURCE_DATE_EPOCH so we fall back
> +	 * to regular behaviour.
> +	 */
> +	return false;
> +}
> +
>  struct timespec64
>  current_time(struct inode *inode)
>  {
>  	struct timespec64	tv;
>  	struct timeval		stv;
>  
> +	/*
> +	 * Check if we're creating a reproducible filesystem.
> +	 * In this case we try to parse our SOURCE_DATE_EPOCH from environment.
> +	 * If it fails, fall back to returning gettimeofday()
> +	 * like we used to do.
> +	 */
> +	if (current_fixed_time(&tv))
> +		return tv;
> +
>  	gettimeofday(&stv, (struct timezone *)0);
>  	tv.tv_sec = stv.tv_sec;
>  	tv.tv_nsec = stv.tv_usec * 1000;
> @@ -515,6 +572,72 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
>  void xfs_da_mark_sick(struct xfs_da_args *args) { }
>  void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
>  
> +/*
> + * get_msws_prng_32() tries to detect if DETERMINISTIC_SEED is in our
> + * environment, and set our result to a pseudo-random number instead of
> + * extracting from getrandom().

Why not return a fixed "random" value?  Wouldn't that be more obviously
deterministic?

	if (getenv("DETERMINISTIC_SEED"))
		return 0x53414d45;		/* "SAME" */

--D

> + *
> + * Returns true on success, fail otherwise.
> + *
> + * This function uses Middle Square Weyl Sequence to create pseudo-random
> + * numbers based on our DETERMINISTIC_SEED.
> + *    Ref: https://arxiv.org/pdf/1704.00358
> + */
> +bool
> +get_msws_prng_32(
> +	uint32_t	*result)
> +{
> +	/*
> +	 * To avoid many getenv() we'll use an initialization static flag, so
> +	 * we only read once.
> +	 */
> +	static bool	read_env = false;
> +	/* MSWS state variables */
> +	static uint64_t msws_c = 0;  /* increment (user seed) */
> +	static uint64_t msws_n = 0;  /* current value */
> +	static uint64_t msws_s = 0;  /* accumulator */
> +	char		*seed;
> +	unsigned long	deterministic_seed;
> +
> +	if (!read_env) {
> +		read_env = true;
> +		seed = getenv("DETERMINISTIC_SEED");
> +		if (seed && seed[0] != '\0') {
> +			errno = 0;
> +			deterministic_seed = strtoul(seed, NULL, 0);
> +			if (errno != 0)
> +				return false;
> +
> +			/*
> +			 * In this variation or MSWS we will use
> +			 * DETERMINISTIC_SEED as our odd number in the formula,
> +			 * so we will need to ensure it is odd.
> +			 */
> +			msws_c = deterministic_seed | 1;
> +		}
> +	}
> +
> +	/*
> +	 * This will happen only if we successfully read a valid
> +	 * DETERMINISTIC_SEED and properly initiated the sequence.
> +	 */
> +	if (read_env && msws_c != 0) {
> +		msws_n *= msws_n;
> +		msws_s += msws_c;
> +		msws_n += msws_s;
> +		msws_n = (msws_n >> 32) | (msws_n << 32);
> +		*result = (uint32_t)msws_n;
> +
> +		return true;
> +	}
> +
> +	/*
> +	 * We initialized but had no valid DETERMINISTIC_SEED so we fall back
> +	 * to regular behaviour.
> +	 */
> +	return false;
> +}
> +
>  #ifdef HAVE_GETRANDOM_NONBLOCK
>  uint32_t
>  get_random_u32(void)
> @@ -522,6 +645,15 @@ get_random_u32(void)
>  	uint32_t	ret;
>  	ssize_t		sz;
>  
> +	/*
> +	* Check if we're creating a reproducible filesystem.
> +	* In this case we try to parse our DETERMINISTIC_SEED from environment
> +	* and use a pseudorandom number generator.
> +	* If it fails, fall back to returning getrandom()
> +	* like we used to do.
> +	*/
> +	if (get_msws_prng_32(&ret))
> +		return ret;
>  	/*
>  	 * Try to extract a u32 of randomness from /dev/urandom.  If that
>  	 * fails, fall back to returning zero like we used to do.
> -- 
> 2.51.2
> 
