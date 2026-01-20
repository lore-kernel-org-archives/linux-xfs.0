Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0C343DA4B;
	Tue, 20 Jan 2026 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921159; cv=none; b=PM3I1aToRnzm/nOpbR4HXMzlUdP+aWtgZK7s4RbHFD25MF7d840ABOgV/lx17dlPTz57NkKn6tJN4mbmoQSgQbXk/8aoucxkVDuWbEJsQ7D9qHHMVSyx+Ktdm5CtmKNrqmWsb33POY5W5ybPzo0uu1ID2YQUfNP2L5x7DYJpqME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921159; c=relaxed/simple;
	bh=2ldYkMxiEJRC61/dpns8O88y8jpxGdodYgDxP3g17Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpns+aNxHLBeKhqfCcJohr6Ak4/H4EMhHTXgeN5naJeJpShLmiVUl99CEzLIclXTm+B42v2sCtC2qrMf6Ts5AZbia76DnrFpowAvQqXQEkaAXpvEWOopUafKqpGnn1CK6Q1V4vXZFjJLXC5GGYGT2eI9cVgQLECR0VdUXVRSNpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Avlk0NnZ; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Avlk0NnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768921157; x=1800457157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2ldYkMxiEJRC61/dpns8O88y8jpxGdodYgDxP3g17Q4=;
  b=Avlk0NnZCUuJ0vIUChOws8hzX31nGG/fVVSQzMhsgP+eqHIssuCx5Yrt
   +iEWgWq8Y/UNsKxpqlq6PI3vn1CwPhMLnZ5zB+QG9XVTjnbbzA/vywDyt
   YmQxa7ChiKHG+c0oOx+6Ezb6rUzaWIMqNnmMe6js8e6XULkemAF+hfpY/
   SjHPAp8TOqmrzAMl4qsZheJY2NsjRNsObDZ4wHnQK3OescWOOuRVs/Yh3
   df4pNv854XIstz+LkTRMFV1LC9cui92l2dCwhQDBaNlxcyQ/myCGIFCcs
   xEKDktD9o9NkwF3X6zs65K+DHtxZu40Fk4B2vaiQ7MKknyJIGwN/Mj7P2
   g==;
X-CSE-ConnectionGUID: pVk9iLgnRIe0GtHW4RZq8A==
X-CSE-MsgGUID: FaHnvhtZQHqa7pGIXvOGOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="69863786"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="69863786"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:59:17 -0800
X-CSE-ConnectionGUID: BY4M+HYSTVa/l1Nz/hHR4g==
X-CSE-MsgGUID: erUACityTTSFNiiHmWvK8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="210633075"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:59:14 -0800
Date: Tue, 20 Jan 2026 16:59:11 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
Message-ID: <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-3-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120141229.356513-3-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jan 20, 2026 at 05:12:29PM +0300, Dmitry Antipov wrote:
> Prefer recently introduced 'memvalue()' over an ad-hoc 'suffix_kstrtoint()'
> and 'suffix_kstrtoull()' to parse and basically validate the values passed
> via 'logbsize', 'allocsize', and 'max_atomic_write' mount options, and
> reject non-power-of-two values passed via the first and second one early
> in 'xfs_fs_parse_param()' rather than in 'xfs_fs_validate_params()'.

...

> -	if (kstrtoint(value, base, &_res))
> -		ret = -EINVAL;
> -	kfree(value);
> -	*res = _res << shift_left_factor;
> -	return ret;

_res is int, if negative the above is UB in accordance with C standard.
So, if ever this code runs to the shifting left negative numbers it goes
to a slippery slope (I think it works as intended, but...).

That said, I assume this code was never designed to get a negative value
to the _res.

With all this, I do not see the point of having a new API.
Also, where are the test cases for it?

-- 
With Best Regards,
Andy Shevchenko


