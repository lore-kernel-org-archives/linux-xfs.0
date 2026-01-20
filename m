Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B7722126D;
	Tue, 20 Jan 2026 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920341; cv=none; b=iFP5RQPrbH3mmo0omf+5VRL2Y5yjZXqvDqPPrhpVCw5ebNkXjvIbmW0G17x/GV0y8sHJGC7Vgbvnyg7VvFBxTlDl4MXTDQ9ysuhmRh+t5uWwhpDnWThbEDha1tgBY+G1OG0y9jLxQIOtq1CZ5RkV+hO0NaRPwSVdG65lLiRuHJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920341; c=relaxed/simple;
	bh=QBfEP+C/xISMlaE8DYcsjQ9gGkagm0k0iRvZF6AwllQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CrCaraY+vg5eJNV+PmzQ9Qkjd+lY/DJnB73D6MvuaXs3rDv01VWFWj3/ML93Hmiggf3kTSnXjHWbjkjwB8PNq2q9kwYa05cOby/t9mYFv0CF0FQDdFmJLBD/YgrC7ysiohxK4QKdj7OCUYNyS/hqUvZva+i41taSchMSxbHRKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a6bEg6il; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a6bEg6il"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768920341; x=1800456341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QBfEP+C/xISMlaE8DYcsjQ9gGkagm0k0iRvZF6AwllQ=;
  b=a6bEg6il3cFOAdxubEJ5hD2npBdV+H+K4c5Zf+weGoj9OzgwfCY0TcFM
   1ljNrWEX35FW83zCOD2UkrXWpeijHBEy2I3Ux9zk4kiOYVEIh32R09+kl
   MVSPFSW8IemR1TGi26WnTsSnDRBJ7r4qeMJaSf6FrqjZ6+IH31q/sgw64
   33XR1Dsah5sKSZWRV+Ykz+lnTSPnXcto0YwxmfPnKXzzYF6OctUKm3RjG
   qtYYs24kCEf3+hskoe4KX68HrBBG3+pf3BScHJIk+vZv8PeISjcdD+Inx
   6WqTS0S9/nC2tU9xm/AlIDkb6531/frWrHBfr8WnOXqqYwjGbPMezbU8s
   w==;
X-CSE-ConnectionGUID: RR/gHNgGSoekRHTdv/V+6g==
X-CSE-MsgGUID: shkIkzGiROmrnLa4IVvuxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="72716102"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="72716102"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:45:40 -0800
X-CSE-ConnectionGUID: /TPYZZGVT+iFV68oPoEvyQ==
X-CSE-MsgGUID: HA53ymmbQvSiQEtiA0e9Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210628230"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:45:37 -0800
Date: Tue, 20 Jan 2026 16:45:34 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 1/3] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aW-VDu4aPV6kZv80@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120141229.356513-1-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jan 20, 2026 at 05:12:27PM +0300, Dmitry Antipov wrote:
> Introduce 'memvalue()' which uses 'memparse()' to parse a string
> with optional memory suffix into a non-negative number. If parsing
> has succeeded, returns 0 and stores the result at the location
> specified by the second argument. Otherwise returns -EINVAL and
> leaves the location untouched.

...

> +/**
> + *	memvalue -  Wrap memparse() with simple error detection
> + *	@ptr: Where parse begins
> + *	@valptr: Where to store result
> + *
> + *	Uses memparse() to parse a string into a number stored at
> + *	@valptr, leaving memory at @valptr untouched in case of error.
> + *
> + *	Return: -EINVAL for a presumably negative value or if an
> + *	unrecognized character was encountered, and 0 otherwise.
> + */
> +int __must_check memvalue(const char *ptr, unsigned long long *valptr)
> +{
> +	unsigned long long ret;
> +	char *end;
> +
> +	if (*ptr == '-')
> +		return -EINVAL;
> +	ret = memparse(ptr, &end);
> +	if (*end)
> +		return -EINVAL;
> +	*valptr = ret;
> +	return 0;
> +}

My questions seem left unsettled:
- why -EINVAL in the first place and not -ERANGE in the first place;
- why do we need this patch _at all_ based on the how callers are
doing now (w.o. this change), i.o.w. why the memparse() can't be
used directly.


-- 
With Best Regards,
Andy Shevchenko


