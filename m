Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CDC7E0E8;
	Fri,  9 Jan 2026 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767978594; cv=none; b=N/AtWFRFuJUd9XIlDIiso7N8or4DtQS2MWRbwWd1pWlABcqHBYztEQL4u9TgKByXenaAf/ioRkH0gTbHJmUg+q+Btrvv5X5Tttkl5TEISgRr39Y8IzI2pTGl8WQvHFigIQYLkhcb5iwYNqAq6iRV7QvDZ1J/S9r8fSP8w16EA/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767978594; c=relaxed/simple;
	bh=MvwACpTFJu57vsNGjYn4XJh1yUD/ap8AVrYYA/Vbv1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiCTmsjEWSXB0ETelvcIBJvUvlYnlAhxKLb3BsPVaNtQIhxFWBE0JeJQhh655TDXPwxH5BMSUMlyy1BhRq8xbEcpbwBWu6XTr/kr44LzQ1TEP4cmCX7hYnf5u16x5hBjPytSu8hp+TPMywnvvpyP10cTLkL06y69YD28dLytToo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fqh/uNXm; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fqh/uNXm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767978593; x=1799514593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MvwACpTFJu57vsNGjYn4XJh1yUD/ap8AVrYYA/Vbv1E=;
  b=Fqh/uNXmkt9OrP00NskbiEXSBuEQXQmR7kGyyn8ivUlPlvoMNsmlPIhu
   ka4RX1/Flfs/P0NG5IZn8VHuB9pSRjIBFdrKXaIPuR8ijmhkVAfpbw0GQ
   bXv3RtLZahv2FUQYUrO/WqdfgMgmDylC+VeogMrLmfq3mJkYGWW+Bn22z
   JEaBzrt/AMCxVsKrVM+AcGCju/nLb+s8bm+JoVz/3C5sHs+luGAEAG83m
   KzMr/YXo/mUq1k1PsAaQDYKq5TmFKd2Zk1Wns0dgrU0gAwCwB00B72coQ
   k0l9LY0RINGWuFlJ4bNA4bIUurSk0yhfttBd+nDJIWMlURlAYKHWsaaPw
   g==;
X-CSE-ConnectionGUID: Saaa0k9xQwSNiwOzL6DNEA==
X-CSE-MsgGUID: qOfhSowWRiyhCGaPxu+R5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="79998928"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="79998928"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:09:52 -0800
X-CSE-ConnectionGUID: l0uHdrCfT3y7OOcZOb4l6Q==
X-CSE-MsgGUID: z5356kS5Sjm7TTPAmyRFlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="203140989"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.157])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 09:09:50 -0800
Date: Fri, 9 Jan 2026 19:09:48 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWE2XPoJInL9aAZd@smile.fi.intel.com>
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
> 
> > 1) inherited one with strange indentation;
> 
> Hm...where? AFAICS everything is properly indented with TABs.

Should be with one space, and not one tab.

> > 2) missing Return section (run kernel-doc validator with -Wreturn,
> > for example).
> 
> Good point. Should checkpatch.pl call kernel-doc (always or perhaps
> if requested using command-line option)?
> 
> OTOH 1) lib/cmdline.c violates kernel-doc -Wreturn almost everywhere
> :-( and 2) IIUC this patch is already queued by Andrew. I would
> prefer to fix kernel-doc glitches immediately after memvalue() and
> its first real use case (presumably XFS) both reaches an upstream.

-- 
With Best Regards,
Andy Shevchenko


