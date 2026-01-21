Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65C6270552;
	Wed, 21 Jan 2026 13:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769001916; cv=none; b=nqs2xAi3oGO1tMsTrn3fNauIrMC35+yWiIDHU9WVeJjCMBeJK644H5TPtwaj0sLhFytGetb69JWLPrHzUWPKWhjDFvUz+E6rEQXhPZvi/r5Vc7u5U/hjQFlm9YRWB8mH5uYHj1rhV2g0Db/Vh8tNoka0ILILaQpwDiLDVRnZuPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769001916; c=relaxed/simple;
	bh=XeBlPKQ/bIh9f3wuYnUYoVfOpIarFk4q4JKbWHS6GSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c54oxxHpUmErT+Rz3oxcVaHJjuLOpkwSOjTCd7EibXLCeBqndSthpNCIr5Tuk1dtFCcvaVBBKR7nAjX7VTY9+RwzSTmWb7H+Bgv6GSwgBjVoVXvj1Gs+nwfuyTmFDMEKpkQPcCknj9KRb8MJxktBliyr1dyxQiq/om73LaB1HbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RIqhPIdK; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RIqhPIdK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769001915; x=1800537915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XeBlPKQ/bIh9f3wuYnUYoVfOpIarFk4q4JKbWHS6GSI=;
  b=RIqhPIdKe4VSPBpZUZC+dlnoCNLYJ6yTa1aspeY5Rl7iz+C3e8XMdszo
   AE2RuHOS+z1zWG21yJsSw0HezaznFgtn9v2P1KjgbCyoo+cSfg/1Q1QSB
   UOLe/YXGQe001nP8GHg4UtNirLPYr915q+QrrPANmIrXAS90JU3geKxO3
   ECRStMn2voxhzXHnrfG549iK2Rb+FyldLNmHl3T3DbD0f/UyHxRbRirYp
   8cQDHiyhzWwBa8uNLBLCXuwJyvdUKHnrKqx83wQHG/QEjrhydCelAY0o7
   o8CNYLzXOnkSaSABS+uNUR2SkR+Ra4EaphtZ2uHVm9dsJeFBOd6dGmETx
   w==;
X-CSE-ConnectionGUID: KsgkR2SHQies5leNCRyg4w==
X-CSE-MsgGUID: 3R9nzVnPRsKZZNKW5ohVag==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70138723"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="70138723"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 05:25:14 -0800
X-CSE-ConnectionGUID: rxwxT1iLR/iYeJ7B5rrJXQ==
X-CSE-MsgGUID: y3TQR7Q5TAyQehJvamb3SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206506760"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.73])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 05:25:12 -0800
Date: Wed, 21 Jan 2026 15:25:09 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
Message-ID: <aXDTtenD9sRp3rUm@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-3-dmantipov@yandex.ru>
 <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
 <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
 <aW_4bxkLe4-g9teu@smile.fi.intel.com>
 <20260120225531.GZ15551@frogsfrogsfrogs>
 <db2897f9a625e7e9a6797fe32cc9364bde56d605.camel@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db2897f9a625e7e9a6797fe32cc9364bde56d605.camel@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Jan 21, 2026 at 08:21:42AM +0300, Dmitry Antipov wrote:
> On Tue, 2026-01-20 at 14:55 -0800, Darrick J. Wong wrote:
> 
> > Yes.  Common code needs to have a rigorous self test suite, because I
> > see no point in replacing inadequately tested bespoke parsing code with
> > inadequately tested common parsing code.
> 
> Nothing to disagree but:
> 
> 1) My experience clearly shows that it takes a few patch submission
> iterations and a bunch of e-mails just to notice that the tests are
> mandatory for lib/ stuff. If it is really a requirement, it is worth
> to be mentioned somewhere under Documentation/process at least.

Feel free to submit an update! :-)

Sorry that I mentioned it one or two versions later than I should have.

> 2) I've traced memparse() back to 2006 at least, and (if I didn't miss
> something) there is no actual tests for it since them. And it's hard to
> see a point in testing memvalue() prior to testing its actual workhorse.

Yes, the historical code needs test cases. I added a few for get_option*()
for example before touching that code. So you're welcome to start test
cases for memparse(), I will appreciate that!

-- 
With Best Regards,
Andy Shevchenko


