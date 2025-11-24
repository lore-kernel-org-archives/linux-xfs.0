Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728C027603F
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 06:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763964819; cv=none; b=ZJY/E3bezqexmWJy6WL1MN8ZD6lmTEQ0ari9yRAqC6ViXxTp1hq+cKFo4L66yAlmOX3VdNa7HD9TPcK4WHxbkKNhBUEZn79wvqTAFicGKDP+a0WX2Tuxf5UkaY+stzblBdSMcNjq2QfPFqeqT0IUYMJTnou3qSaGsjuKBbSOf9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763964819; c=relaxed/simple;
	bh=g98Z7/Ex1waZXX918zMPETrhYCjsJ9Gv76y8AObmwhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M8cUZ0ZzinQaL6RpGSANGgjDwdMbkRyyZQOIdFnJycItAGKSKn5wVuZ2kU3gGw7jJlF1WqdF1Paa5mAIM2J6hVdAGkPMGoCFShcwgPQM3BzDyBXC7rJ02qZ5LlRUo0gfTdMQr0kbPoLcf8Qg37Dnb5NZ3RA9Ls2fN5bWZ6bK93E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=muwC5zD6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="muwC5zD6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FPRb8qkSqfpID+yn0jkRVC68AxMxVWijlHOSg3xIZQI=; b=muwC5zD62GxkQ3HPBkzZQzQ1av
	Gc30ROFVBlluA3L2CsicM1LS4qTAPiT+NdwIcgg8kEBKChtLJWzDbR+uVezwu2XXi5CpDjOs0RAOG
	8vBZxZhL3L7crHnaPkLgYxkP7cAZ1jbWsDhOCd09qdxb3fB+ot4Xbj1e730rHCAXaNE4NYbVrL577
	+nAsi5UUNqZwI0zCBJNifehN3yue7To/U4aK0i6NUv2oWt7c7tOulg46Lf0wU1Ei/TNMkMXDsu84Y
	d9NdgWj1SvzMvm2LxS9AVOAkYoyaPPUi3lYv55NPLO/rgg7IE/kiw0BAM22PPmEPVZ5Rm3SK8gXvk
	tNjpteEw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNPpP-0000000B8LY-2TSw;
	Mon, 24 Nov 2025 06:13:35 +0000
Date: Sun, 23 Nov 2025 22:13:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, djwong@kernel.org
Subject: Re: [PATCH v2] libxfs: support reproducible filesystems using
 deterministic time/seed
Message-ID: <aSP3jzYTU8KkY2vs@infradead.org>
References: <20251108143953.4189618-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251108143953.4189618-1-luca.dimaio1@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Btw, any chance you could submit a testcase for xfstests that uses
these options to create fully reproducible images and tests that
they never change?  Having this functionality exercised in the test
suite would be really helpful.  This could be as simple as creating
a file system using the various file types and then checking the
hash never changes.

On Sat, Nov 08, 2025 at 03:39:53PM +0100, Luca Di Maio wrote:
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
> When DETERMINISTIC_SEED=1 is set, return a fixed seed value (0x53454544 =
> "SEED") from get_random_u32() instead of reading from /dev/urandom.
> 
> get_random_u32() seems to be used mostly to set inode generation number, being
> fixed should not be create collision issues at mkfs time.
> 
> The implementation introduces two helper functions to minimize changes
> to existing code:
> 
> - current_fixed_time(): Parses and caches SOURCE_DATE_EPOCH on first
>   call. Returns fixed timestamp when set, falls back to gettimeofday() on
>   parse errors or when unset.
> - get_deterministic_seed(): Checks for DETERMINISTIC_SEED=1 environment
>   variable on first call, and returns a fixed seed value (0x53454544).
>   Falls back to getrandom() when unset.
> - Both helpers use one-time initialization to avoid repeated getenv() calls.
> - Both quickly exit and noop if environment is not set or has invalid
>   variables, falling back to original behaviour.
> 
> Example usage:
>   SOURCE_DATE_EPOCH=1234567890 \
>   DETERMINISTIC_SEED=1 \
>   mkfs.xfs \
> 	-m uuid=$EXAMPLE_UUID \
> 	-p file=./rootfs \
> 	disk1.img
> 
> This enables distributions and build systems to create bit-for-bit
> identical XFS filesystems when needed for verification and debugging.
> 
> v1 -> v2:
> - simplify deterministic seed by returning a fixed value instead
>   of using Middle Square Weyl Sequence PRNG
> - fix timestamp type time_t -> time64_t
> - fix timestamp initialization flag to allow negative epochs
> - fix timestamp conversion type using strtoll
> - fix timestamp conversion check to be sure the whole string was parsed
> - print warning message when SOURCE_DATE_EPOCH is invalid
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  libxfs/util.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 3597850d..f6af4531 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -137,12 +137,76 @@ xfs_log_calc_unit_res(
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
> +	static bool		enabled = false;
> +	static bool		read_env = false;
> +	static time64_t		epoch;
> +	char			*endp;
> +	char			*source_date_epoch;
> +
> +	if (!read_env) {
> +		read_env = true;
> +		source_date_epoch = getenv("SOURCE_DATE_EPOCH");
> +		if (source_date_epoch && source_date_epoch[0] != '\0') {
> +			errno = 0;
> +			epoch = strtoll(source_date_epoch, &endp, 10);
> +			if (errno != 0 || *endp != '\0') {
> +				fprintf(stderr,
> +			"%s: SOURCE_DATE_EPOCH '%s' invalid timestamp, ignoring.\n",
> +				progname, source_date_epoch);
> +
> +				return false;
> +			}
> +
> +			enabled = true;
> +		}
> +	}
> +
> +	/*
> +	 * This will happen only if we successfully read a valid
> +	 * SOURCE_DATE_EPOCH and properly initiated the epoch value.
> +	 */
> +	if (read_env && enabled) {
> +		tv->tv_sec = epoch;
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
> @@ -515,6 +579,49 @@ void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
>  void xfs_da_mark_sick(struct xfs_da_args *args) { }
>  void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask) { }
>  
> +/*
> + * get_deterministic_seed() tries to detect if DETERMINISTIC_SEED=1 is in our
> + * environment, and set our result to 0x53454544 (SEED) instead of
> + * extracting from getrandom().
> + *
> + * Returns true on success, fail otherwise.
> + */
> +bool
> +get_deterministic_seed(
> +	uint32_t	*result)
> +{
> +	/*
> +	 * To avoid many getenv() we'll use an initialization static flag, so
> +	 * we only read once.
> +	 */
> +	static bool	enabled = false;
> +	static bool	read_env = false;
> +	static uint32_t	deterministic_seed = 0x53454544; /* SEED */
> +	char		*seed_env;
> +
> +	if (!read_env) {
> +		read_env = true;
> +		seed_env = getenv("DETERMINISTIC_SEED");
> +		if (seed_env && strcmp(seed_env, "1") == 0)
> +			enabled = true;
> +	}
> +
> +	/*
> +	 * This will happen only if we successfully read DETERMINISTIC_SEED=1.
> +	 */
> +	if (read_env && enabled) {
> +		*result = deterministic_seed;
> +
> +		return true;
> +	}
> +
> +	/*
> +	 * We initialized but had no DETERMINISTIC_SEED=1 in env so we fall
> +	 * back to regular behaviour.
> +	 */
> +	return false;
> +}
> +
>  #ifdef HAVE_GETRANDOM_NONBLOCK
>  uint32_t
>  get_random_u32(void)
> @@ -522,6 +629,13 @@ get_random_u32(void)
>  	uint32_t	ret;
>  	ssize_t		sz;
>  
> +	/*
> +	 * Check for DETERMINISTIC_SEED in environment, it means we're
> +	 * creating a reproducible filesystem.
> +	 * If it fails, fall back to returning getrandom() like we used to do.
> +	 */
> +	if (get_deterministic_seed(&ret))
> +		return ret;
>  	/*
>  	 * Try to extract a u32 of randomness from /dev/urandom.  If that
>  	 * fails, fall back to returning zero like we used to do.
> -- 
> 2.51.2
> 
> 
---end quoted text---
