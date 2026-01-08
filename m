Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A272EC0B5;
	Thu,  8 Jan 2026 20:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767903041; cv=none; b=U+UhF2qNFILsWbI73pTl2YhG4I/Vf7ek1mzVWhoj/eMoQT9Wu+uDNC9vWbBZS++RZH5dxpdAGexKBDTtV3tKDQEpjEEY6x9DxrhyLQqHslCIh9S5ZIhzZ3RCG1QCHsXV/B+6hfC3x1Q8kycZjE36gl+UDeNa/JxzPbbTBpqZEOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767903041; c=relaxed/simple;
	bh=xzrAd3JaP9XwxrzniHGiKv1TyecTNJ3c+MOLnmdydtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTuLbgWXWzcU+cbWCqo89O134z30do7t4bZu33T56w23r4yEWpEo6E7Ex0/Xvj5TR4z+PbEGlNYvsAb7qrYONskk6SXa+OmTIDGlNhfxz6V51ECb3BdCAlqy6y9xzl2WzYWhrBnbe053jtox3//mB+6MacEIv/LJ2GnO961aoeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACaiqn9J; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACaiqn9J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767903039; x=1799439039;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xzrAd3JaP9XwxrzniHGiKv1TyecTNJ3c+MOLnmdydtg=;
  b=ACaiqn9JqVI2qSK2c3M+5CZoRupOvgPBiUbRj3x/ysx4arUYUVa7RV24
   n30ogtt/OgrYyCvR8n7yBuM1kpGNaF+9cgPmGMXsgLqhceWjoB5DHfdHR
   Rk5+EiV/YHIlfX+XSeU5wiCOYyW+vMGBZI9fIziV/PYiB7kHKzteVf6S6
   M1vHXFzWLCyf1ka1C0k7JkFo0XH7ZlnTp0oU/QOG6gscWaQk0pysaeBUl
   IxD97sBfG5++6SpCFBIykjtKvB1ciX0uxOaRZW1/iLA1nDQOF23UU5g1l
   bZ19kQssmJU/J26npcw9rvYRKN0pb5tPKFGJ9ie8BPeC05QUpfXoO3BM/
   A==;
X-CSE-ConnectionGUID: 98B9asiNRwiEIoCVzdC2mw==
X-CSE-MsgGUID: PZPVRWB9SFupMf+C0f3OKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="91951264"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="91951264"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:10:39 -0800
X-CSE-ConnectionGUID: qFct2FWaR0y0oolvZ9sBeg==
X-CSE-MsgGUID: MmAKrT7FQVW0OVENg8yOHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="208132785"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.60])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:10:37 -0800
Date: Thu, 8 Jan 2026 22:10:35 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWAPOyJwhpfKpqPy@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108165216.1054625-1-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Jan 08, 2026 at 07:52:15PM +0300, Dmitry Antipov wrote:
> Introduce 'memvalue()' which uses 'memparse()' to parse a string
> with optional memory suffix into a non-negative number. If parsing
> has succeeded, returns 0 and stores the result at the location
> specified by the second argument. Otherwise returns -EINVAL and
> leaves the location untouched.

...

> +int __must_check memvalue(const char *ptr, unsigned long long *valptr)
> +{
> +	unsigned long long ret;
> +	char *end;
> +
> +	if (*ptr == '-')
> +		return -EINVAL;

Hmm... Why not -ERANGE (IIRC this what kstrto*() returns when it doesn't match
the given range).

> +	ret = memparse(ptr, &end);
> +	if (*end)
> +		return -EINVAL;
> +	*valptr = ret;
> +	return 0;
> +}

-- 
With Best Regards,
Andy Shevchenko


