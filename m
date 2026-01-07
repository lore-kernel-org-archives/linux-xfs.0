Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1832D8379;
	Wed,  7 Jan 2026 19:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813847; cv=none; b=LmJiu93fOsjsQobOcsg6/ritEC3BvyxyXMGZe2jUMIlW0Sg+ud0+JKKofikuKRQM8JVN2XmWg7bjE4leR7tZYfdlWoFH5Rb2svzESHdhB/CTpPd2Qto4lwzEGnBkCoSjMhAe0ovXTwBDMh5aa/qWtXGg2r2QSebbpSMsdywYLgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813847; c=relaxed/simple;
	bh=nkvcnuEz7LgQCkeM4N08MVDybDHuaWJOttOWf6ddTwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhUdQD1lqPx4llX9E8WUxDz59asJsy5mL27WY+7cJW3egsXCc9FaRycCPirq9RlOINbM7b3WIbHX9v8uw/RBWG3MPuPn8v8siCMBK9bhM6CflY2RdvKVxJsfQsgCO5jW5FspIVBtTwXvYE9rdsQfMFJ2nZQHoGzTg4wn71HV8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KF1EN0K2; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KF1EN0K2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767813846; x=1799349846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nkvcnuEz7LgQCkeM4N08MVDybDHuaWJOttOWf6ddTwk=;
  b=KF1EN0K2ozPc8Xpd2OyaitJFoMv/LSsybAUlQpqx7QLi1lbR012FO/Tw
   vs8uSzwJDBfBW7mFotwhWJlmoowH9zXvHzasHZpN+dQI3W+OaBApU0JcD
   4+/9Fsr6gGUYics81DN3uXTDOgqpn/wpCjJhhpCFWvseibOSBiL/p10HU
   XyBN9ztZCI6xWCUjsoOiSH0RL35HjIfMJa6/sfvTRfAd8eUZs5ShDde3O
   dOnpf4kV6RN0wMD1OFeu6wm3TOzZD9j2T4f4ATz3nd3G3Qx6tVraIEC1l
   TvFbFQ5PvpSzP1dUBog0dXX1+dCssSGe36xiy+9gpIRgwffHEdhcVlivd
   Q==;
X-CSE-ConnectionGUID: 4o173SpSQruAM/aoxLQN4w==
X-CSE-MsgGUID: 8fyMTuPiTPy7kOMJdXsj1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="73040033"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="73040033"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:24:05 -0800
X-CSE-ConnectionGUID: 5DR1U/byTiWKayPogs1Xng==
X-CSE-MsgGUID: UrDP6L4jRCGx26ARfpnN7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="207150799"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.245.168])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:24:04 -0800
Date: Wed, 7 Jan 2026 21:24:01 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aV6y0VTYbQKnHMqk@smile.fi.intel.com>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
 <aV6ye_vv_0N-SsLu@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV6ye_vv_0N-SsLu@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jan 07, 2026 at 09:22:39PM +0200, Andy Shevchenko wrote:
> On Wed, Jan 07, 2026 at 09:36:13PM +0300, Dmitry Antipov wrote:
> > Introduce 'memvalue()' which uses 'memparse()' to parse a string with
> > optional memory suffix into a number and returns this number or ULLONG_MAX
> > if the number is negative or an unrecognized character was encountered.
> 
> Reading the second patch in the series I do not think this one even needed. The
> problem in the original code is that
> 
> 	int *res, _res;
> 	...
> 	*res = _res << something;
> 
> This is a UB for _res < 0. So, the code should never handle negative numbers to
> begin with. That said the existing memparse() can be used directly.
> 
> If I missed something, it's because the commit message here is poorly written
> in regard to negative number parsing.

Also note, when do a series, make sure you have the same version for all
patches and the cover letter provided. You can use `b4` tool for that or
supply `git format-patch -v<X> --cover-letter ...`, where <X> is the desired
version number.

-- 
With Best Regards,
Andy Shevchenko


