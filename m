Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E24311588;
	Fri,  9 Jan 2026 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978697; cv=none; b=FwmxlY5VzBjNasbIAeJYa1JgnJLi90nRFU52HUr1wh1JAB7v5bOtIi0Q3J9IgGpVg3gRbUdcdpvLdCbKlK5RPhu7qubuJI/A3WTm/ByrwTTE2WeYr97KpWLSaNCB7eDXzf/p9e8C+oMU03zj2j3Y6sHTnnqi/7wAz64WwMeDda8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978697; c=relaxed/simple;
	bh=e3oY6JfwDOLBMDRhJKRYKwjLmCy0nzggqP/Z29Lo854=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih/FxrdOl8cZ9rd0Pee3X45Tl3j9Nn7U8t3QVn/3wJXja9za/xfuY7ewPqDGI2LFuDYl1nOuF7qutlfL5jzO1SHLfubm6pniLi168wHY+YqVixzE12hOXl/KWX3ftynqWIwZrWCACJ1XZm4b0IPP5HaTNjProfZFF6llqeDjhUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Abna4UaH; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Abna4UaH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767978696; x=1799514696;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e3oY6JfwDOLBMDRhJKRYKwjLmCy0nzggqP/Z29Lo854=;
  b=Abna4UaHpEeJgeTjUUkKKXaa410rDBIAu/mKRxdOI/vo8ixIEo7gdy00
   cQOv+OdOPWQM7SWMroGfIjea6Lzb3PrrpjBBmhMAbjqRwv3NsYW11iyQ1
   ZKNrR+g7ORXFGG7FuFLYHqae/geP/9ZJE6H/G+n8I2Dzz6r2Ae+qL1Sqk
   fNcRrPzHgmY0Eh1xl/0FPbVn1oAPMtHQkUFn2PIwwRyzN8NKFBSkDPHF7
   kT76iT2cbP3YoBiXe9bI0uCesfynngiFiPbPHb3W0GTsxb6QcQEoqTMWT
   rg13wKuh4TbBx/bUF/yfTacpQfu+thGzB6398m8GQFiJrdyU9pgmcAGgL
   Q==;
X-CSE-ConnectionGUID: AgKqQ9I/QOSpJJG5ekbWgQ==
X-CSE-MsgGUID: l2zUY9JiQPGuQBetekkZRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69347067"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="69347067"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:11:35 -0800
X-CSE-ConnectionGUID: 3KSIUQcAQoCqsq4VtHqVDw==
X-CSE-MsgGUID: fgJgn7UsTpCVnJDvmx3Pww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="202636200"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:11:33 -0800
Date: Fri, 9 Jan 2026 19:11:31 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWE2w-zUnq3FPANJ@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
 <aWAOJwMURdOl_lqG@smile.fi.intel.com>
 <a0fb5777b167803debb2c6b77f41e82967fba3b7.camel@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0fb5777b167803debb2c6b77f41e82967fba3b7.camel@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Jan 09, 2026 at 02:41:55PM +0300, Dmitry Antipov wrote:
> On Thu, 2026-01-08 at 22:05 +0200, Andy Shevchenko wrote:

...

> > 2) missing Return section (run kernel-doc validator with -Wreturn,
> > for example).
> 
> Good point. Should checkpatch.pl call kernel-doc (always or perhaps
> if requested using command-line option)?
> 
> OTOH 1) lib/cmdline.c violates kernel-doc -Wreturn almost everywhere
> :-( and 2) IIUC this patch is already queued by Andrew.

Andrew's workflow allows folding / squashing patches.

> I would
> prefer to fix kernel-doc glitches immediately after memvalue() and
> its first real use case (presumably XFS) both reaches an upstream.

Logically we should fix existing problems first and then do not add more
(technical debt).


-- 
With Best Regards,
Andy Shevchenko


