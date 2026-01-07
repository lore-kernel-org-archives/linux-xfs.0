Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C03222A4FE;
	Wed,  7 Jan 2026 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813761; cv=none; b=qG3jI3ZHZz1JIbmE8PBlUBFfqD22CXXi73b/fmGXxvD0khMoZSvWyiGHuVz2Skc8n9LqlsVPPcnMeQeVEsy5btEUgm921aRF06yQuCULw5vH4D3KFhNg1kB2wZghCIZwlSkNkATg8lEW+WgwNExKTMdHIhOWnjBQbxItLJq7esc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813761; c=relaxed/simple;
	bh=UECcd6kD6jccAmK07OrjbHIU3C36VyEkzhkK1mHVBY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opNfemVSy0LmHtSw3M33R3G5FF0kEIbnoQhLTa7v7snFbLhnq6tO7+l0c96d1m40Y6+482zYeWABaQh48KRtoJwk13pHwXLFehBmO6b0U52LCmLuaLEuckVm8CWEYQ+xK//+SUgzn5D82MDXDOR+Xd3yTzOd1LWYofMwa63YGeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=chgyKBPc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="chgyKBPc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767813760; x=1799349760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UECcd6kD6jccAmK07OrjbHIU3C36VyEkzhkK1mHVBY0=;
  b=chgyKBPcJ56TwfYAcxsqYeApQJsESUwvsGH2NJ9QxS1kXhHIKfbEfxyj
   7BxBP2wcZ/j2Nj37ncudl2ZCROlaYNi3ydqzTkGul6RMoOdbF6kwbw+Vp
   sNR/hgxB9pq/Xp410Qv+ro3kLzJw/fz9+7vP2YEanj9aZEF4JbxPs8zG8
   AY6EzJbHIxt70C0BvRBMospZCmMJZAUt13BpvDo29mSY8qrx2LTMgNV6m
   7UD5Fb4zFdRlNhKCNW93xKSKcbDaAU3U9VS9XPQPmOUN/666fNA4GahYT
   KeJYD6PF3Nmz8ysnp6u8zniS5R5mxDxjTGQwGdxzzCgjHFe5U/IkavoOz
   w==;
X-CSE-ConnectionGUID: FFE7+1d3RjWzx0BAaj6ucA==
X-CSE-MsgGUID: dlOAh+TESEOi1U4nvzQ0zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="71768462"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="71768462"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:22:39 -0800
X-CSE-ConnectionGUID: dpYVokWITJ2O9ASVXHN6tw==
X-CSE-MsgGUID: vXN03HpdQSaOvJm9BtTsEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="202913645"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO localhost) ([10.245.245.168])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:22:37 -0800
Date: Wed, 7 Jan 2026 21:22:35 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aV6ye_vv_0N-SsLu@smile.fi.intel.com>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107183614.782245-1-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jan 07, 2026 at 09:36:13PM +0300, Dmitry Antipov wrote:
> Introduce 'memvalue()' which uses 'memparse()' to parse a string with
> optional memory suffix into a number and returns this number or ULLONG_MAX
> if the number is negative or an unrecognized character was encountered.

Reading the second patch in the series I do not think this one even needed. The
problem in the original code is that

	int *res, _res;
	...
	*res = _res << something;

This is a UB for _res < 0. So, the code should never handle negative numbers to
begin with. That said the existing memparse() can be used directly.

If I missed something, it's because the commit message here is poorly written
in regard to negative number parsing.

-- 
With Best Regards,
Andy Shevchenko


