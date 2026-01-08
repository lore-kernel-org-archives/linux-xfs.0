Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539D51D435F;
	Thu,  8 Jan 2026 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902765; cv=none; b=ej0QSRbXSm2PZpEp0M1W1vBux6IPwStE1K6ee1dk0oxP+KRUUlYKaV8sf3HYmmVOtweDxXxvQQ67t9WLxjl11scb/hsKKezIZX4PnAAb3rQhSouqDS4AwuBKqtWPj7+CLU1P8pvUZEAAcqdd4hrQTcFAQ9MmAco/9v+JIksj6ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902765; c=relaxed/simple;
	bh=arPICBOG+9/tKiPt1TxgG0AzofrOJSgQNrsZ+ltcH/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uG5L3Nfv/PXo16pooMakUNPg1UbnHJPMZaXX8cV87GE7IwzAtxH7a44E6UhOFyn8FA8xw5F6LIH33CyqG3QJWOE99SU6P5Y97qy+Dpoim5MWRJOIGXOKa93+vxR+IQXzpQjZeHHfoka5Ph5SpjU9l45XShuY9EJRC3ZCixrQE8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwg/gHA4; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwg/gHA4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767902764; x=1799438764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=arPICBOG+9/tKiPt1TxgG0AzofrOJSgQNrsZ+ltcH/Y=;
  b=lwg/gHA4biQwTLeJXp0RvBPgzFMfBZKq2/HSCCbphWmeFsB4esoVTzCY
   dcGA/PaWSkhO9iNI1Ppy0RwIHIGTr3f0jk/Ha7txpH8ZjxClL7D7/Dijf
   W7XfPagKe26Fm8CdBY7rzddkc5jVh/tno6Kg43X7+hlYfyWVzOZpBFwtl
   UL9PIMqOD1yzF96360A+L9huzcNX8x/1eo+GOLwjPrDMVQ30GH5f/cq4J
   HCM8VHvYlJy2sMIuM8C8+HnofrOCCLWYwHpXzmPoXKoN4FDLwGT3zQp4X
   XfCTWZm9uBG3+RiSFNk5K4GGekBOtwZEEYQP7NWZXwOtZ0LfKB1IJG10n
   g==;
X-CSE-ConnectionGUID: 7WPj5YOLRnezw9jp5oWiqg==
X-CSE-MsgGUID: 8tK9Bx2tSTekiyf1fLPPxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="91951079"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="91951079"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:06:03 -0800
X-CSE-ConnectionGUID: P/3WzMKxQ0ipyUgDkSmzHg==
X-CSE-MsgGUID: JEjS/aVeQnO3QAwzrt2AOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="208131523"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.60])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 12:06:01 -0800
Date: Thu, 8 Jan 2026 22:05:59 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWAOJwMURdOl_lqG@smile.fi.intel.com>
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

> +/**
> + *	memvalue -  Wrap memparse() with simple error detection
> + *	@ptr: Where parse begins
> + *	@valptr: Where to store result
> + *
> + *	Unconditionally returns -EINVAL for a presumably negative value.
> + *	Otherwise uses memparse() to parse a string into a number stored
> + *	at @valptr and returns 0 or -EINVAL if an unrecognized character
> + *	was encountered. For a non-zero return value, memory at @valptr
> + *	is left untouched.
> + */

There are two problems with this kernel-doc:
1) inherited one with strange indentation;
2) missing Return section (run kernel-doc validator with -Wreturn, for example).

-- 
With Best Regards,
Andy Shevchenko


