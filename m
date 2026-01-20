Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A980A26158C;
	Tue, 20 Jan 2026 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920385; cv=none; b=u8D1Zjmj3ksfi3Tei9xwnoXI9PNKQD5gu1nGvv+IHkjJmlLZ44pss01WTJCOqkd95yEau5++z4puXw09VdZoYT6J+4NY4CX1uAKZipuQxFEurZ4lEJEwPNOAaGi9el8cGZ+lhv2q+Q8U38agnSFbHltt70cYiKBRBdmx8q6q6C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920385; c=relaxed/simple;
	bh=fZ5BDlbsrcOtNdtnCPOAUECbflqzsxpExs7rvu2zbRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tAPMk0nqGMQLZJCjoj5qlLr3XoQW1QWlmkU5vVMuFSrV5QDQyAgAhxGkQ6x6buNnu+0N2nQEt9cII5ON30bq3pcUQW/WnFbjjbC9PmMt01MvAKDD706ZSFICEqg+825GjRMq54Y1UxByEMEPQjFnfbf2erlr/iubWxgwuUs7jJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QalHLqLP; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QalHLqLP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768920384; x=1800456384;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fZ5BDlbsrcOtNdtnCPOAUECbflqzsxpExs7rvu2zbRQ=;
  b=QalHLqLPF1ZHhVPhsoGVkiKVMbB6HUdxejr3KldSp8QJMkaX89rraViT
   JIY9Gl7SF69uwFc536XtLyz6TJBkBMcHF7Vb5yKHBGfN/SZcXpIx2G4Sl
   ufsgrEWLQSRkBVrwtdDkIqembuetJvejJwwMh2yHJKBSjvym+fUETOpyW
   k7S+oQusXjP7bOGmy3pwX4lBsL/1CCMGsJog/HsWKJZNNjdZJmymspnL+
   bZ6a6wxllm8nIA6irmrW4N3a+jbfG6oc3KZaF/520UGuEh3rJThBgdDeO
   p3YEgtpkHUdgYz8KsrQJmqVlo4BRpXFp555rEZ+7moS7zummtipL/tmLe
   w==;
X-CSE-ConnectionGUID: oA26+ghrSMyooPWtWQiYJg==
X-CSE-MsgGUID: nw25/DoiT3G+YiYS40EVGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70034836"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="70034836"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:46:23 -0800
X-CSE-ConnectionGUID: g4vb0DYRS6e2rXppykHI/Q==
X-CSE-MsgGUID: wJ4VOXNKQJekOn+jVA71Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="206558066"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:46:21 -0800
Date: Tue, 20 Jan 2026 16:46:18 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 1/3] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aW-VOtHVHh-2RLHd@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <aW-VDu4aPV6kZv80@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW-VDu4aPV6kZv80@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jan 20, 2026 at 04:45:39PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 20, 2026 at 05:12:27PM +0300, Dmitry Antipov wrote:
> > Introduce 'memvalue()' which uses 'memparse()' to parse a string
> > with optional memory suffix into a non-negative number. If parsing
> > has succeeded, returns 0 and stores the result at the location
> > specified by the second argument. Otherwise returns -EINVAL and
> > leaves the location untouched.

Also this misses the cover letter to explain the motivation, changelog, etc.

-- 
With Best Regards,
Andy Shevchenko


