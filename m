Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCA1EFF9B;
	Tue, 20 Jan 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920458; cv=none; b=US2Cf7GmX4bV/39CanwE4R3Q4EqvUTceKnMdgvSGfKI0PsNnBbpm4w1f8tYbxF+Iyw9HTe0VFIE8itZUD3gBYIzqjbVk/29u/pFVnLlb0OWrNNcn5YKVDDoL5mCpfKEFg/RedvwEwa+rEjf9lyH7pcE22HY5g6jXbs+NRuNg+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920458; c=relaxed/simple;
	bh=OTPVc43NSkyIQGFcfIWoDfj2FBqKztTB/OGgKXzTYOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwhTD3Wwv2kqbx+55dExRUy/D9HYRzB508p9/s29FkEFXzJNgPsxkuoCotVH99P4QV1qemSurvocLP9OAlp4sJ7fy4/nnLd/P8nkOGKtX+b3YkdVCqlsN5hCq7pDwutUjf0eY2LA3EWNSMvY3kpHZ6Npw1KFxuq+qopx2wYDUrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gEOAGw+3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gEOAGw+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768920457; x=1800456457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OTPVc43NSkyIQGFcfIWoDfj2FBqKztTB/OGgKXzTYOU=;
  b=gEOAGw+30LXCicg5SFYl6rsmPaICZLHb7/EcILDj8wx5tHaqI1iv+dbU
   d6SK1m4m1mdPyYz9Xg1iyPQ1lPfcJVaXBQhYPMLfEPzP8BOFI/9qzOuN6
   WCAaUGf8YfhkBvUfHHel/++fv53nMD6wcvKiFeJe8pjteaZm0kT1PoyQN
   hTHeFpreVZRQr9zNDZssHb2YZnNRSjbdGRQb4VM6VHmtekiTv+HPTD0qQ
   yViEOqqFWCmSLfwiwmytnIeaMr5NVrE5Cq2V5kur7RkCpzJ38f4wWHN5L
   YSLaEqgjD7nrcF1TcwgeKCZ2pBd8Xe4MJfscHAVx3csWq19G+Ax9AJdZX
   w==;
X-CSE-ConnectionGUID: XKQD/LJCScehlu0xKiUrRQ==
X-CSE-MsgGUID: 28o5dFrkSYyt0Eumz3Fi9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81570502"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81570502"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:47:37 -0800
X-CSE-ConnectionGUID: Hh+MTS57QZ6ux+wrDw1A5w==
X-CSE-MsgGUID: I8scmMxeSKGUuTtWlnGWcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="205389130"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:47:34 -0800
Date: Tue, 20 Jan 2026 16:47:32 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 2/3] lib: fix a few comments to match kernel-doc
 -Wreturn style
Message-ID: <aW-VhE6usl7Mc63G@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-2-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120141229.356513-2-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jan 20, 2026 at 05:12:28PM +0300, Dmitry Antipov wrote:
> Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments
> to match the commonly used style as suggested by kernel-doc -Wreturn.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Thanks for doing this change, I think it should go first for the consistency's
sake.

-- 
With Best Regards,
Andy Shevchenko


