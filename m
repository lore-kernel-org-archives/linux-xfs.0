Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C385336AB5D;
	Tue, 20 Jan 2026 21:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768945782; cv=none; b=W0maBPT5B9omuWIYwOrdY29yPKlCPjNq5+sHTW3AFI0OnStspajwzlEJ/ery+ltnITnIxsAy5FCLPT7Cfrj+XIJ9771tIr+CfUtisp2To5KOLROFDF11Mie5GWO2SgvwIpskyJpg/l/GSOhiWtuDz8Ut++T8SSTORIJb6gTpPP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768945782; c=relaxed/simple;
	bh=qtWMjt2CUAO7zZ1FhakG4Yg4AXA0OAD51V6crO1692s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZBrB0mPCdoNR4k9o327LB5mNym+4LIiYRFgcsTF8KcdK7P4OpTiRvp/Opt6v+z8Wr1upFuo6166oKZonXk9iWPPKDiTSzoScjhUufJqICDkUjbuL4h03r1TGCmEPuAQXxPFOg7gL5da11WEVzpIFeaGdU1sqlGSNxwbJslaQ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/6IhVQ5; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/6IhVQ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768945780; x=1800481780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qtWMjt2CUAO7zZ1FhakG4Yg4AXA0OAD51V6crO1692s=;
  b=j/6IhVQ54igch6Wcj4L43u4EZq9RASEhhze6WtnxyuQ50PSG/yMuSyv3
   q5vIJyf4uQnSySjy8jhAM/GXNdf7jCA2K3gS1/7BWTqmqLpLJGA6Hs8Bl
   Tm5e4QoKUIMgQt9o0iTzDk5tjGgLyOU7aE1jpJ8BS9YFSPtIcDNIJ2tWc
   ibWXjS2B8XGqyx7qgLq1yx+Lolcp69zDxG0BamL0cWJUifxbWymJTz5tB
   6PS60NhJlPrgq7oUQ2UCETOVQ/Q+tdxAkOLY7xR53dqDf5x3OxeDmOZVA
   BF68vUSI6N3CNSFjZnTaAulPz2tnb9V/Vc4P+MP5tbbXe7/MXHi6Lk4Nu
   Q==;
X-CSE-ConnectionGUID: MzlkUkVbQRO0KL0fwV3bkg==
X-CSE-MsgGUID: YjK6sHZGT+yKQPNuU6iX3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="70221007"
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="70221007"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 13:49:39 -0800
X-CSE-ConnectionGUID: uLru6fozRzqJCiIrYeGajQ==
X-CSE-MsgGUID: rzVwSywYQ6C0CRxh/LvfcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,241,1763452800"; 
   d="scan'208";a="206581546"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 13:49:37 -0800
Date: Tue, 20 Jan 2026 23:49:35 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
Message-ID: <aW_4bxkLe4-g9teu@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-3-dmantipov@yandex.ru>
 <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
 <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jan 20, 2026 at 07:57:50PM +0300, Dmitry Antipov wrote:
> On Tue, 2026-01-20 at 16:59 +0200, Andy Shevchenko wrote:
> 
> > With all this, I do not see the point of having a new API.
> > Also, where are the test cases for it?

> If there is no point, why worrying about tests?

I don't know yet if there is a point or not, I provided my view.
I think you know better than me the code in question. It might
be that I'm mistaken, and if so the good justification in the
(currently absent) cover letter may well help with that.

> Also, do you always communicate with the people
> just like they're your (well-) paid personnel?

What do you mean? Test cases is the requirement for the new APIs
added to the lib/. It's really should be regular practice for
the code development independently on the project. If you think
frustrated by this, I can tell you that I was more than once in
the past in the same situation until I learnt it very well and
now when I submit anything to the lib I always add test cases.

-- 
With Best Regards,
Andy Shevchenko


