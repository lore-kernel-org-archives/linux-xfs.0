Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942083064A0;
	Fri,  9 Jan 2026 11:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767957516; cv=none; b=mw01ZDYPLr84n4+m9vBV6Lvzj+bKtHQzi5NipRQupyTkIAQzM5zBILyNDlN9+9NSWo9xsordjMPGCMusaXANZs4e/o2BLQSEr8dh6n5977qfbrnxVPoXoraLlU/lA6mvHfHRF/LBZa58hYKGQhfj237pYsrbmY3h5di6vQ3ZbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767957516; c=relaxed/simple;
	bh=4/lc83qxAkVLYxiIGuX+LsZ/QHlhERKyuCDn58h7lcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqy4B0Xa9k42CwtSBSCHuscdfg3/35nsF+j4qi/8UN6P0HbNmrQznben0xlTxnilfs73ENZ0elrNXhEluVqtXizUn0N5xVgAP+uDPJRTUBKAiFEHWmSPmVf8ci4+qw20NNqzjufPnC58wmJ7o5xjGznQngR2l+OhzFrMWM1sq5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEnGiEGZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEnGiEGZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767957515; x=1799493515;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4/lc83qxAkVLYxiIGuX+LsZ/QHlhERKyuCDn58h7lcM=;
  b=dEnGiEGZ49D50qEeRbQ3m83fibOHovD9jvqsM7nsO6/8NWgSOQV/TJL2
   CzmSZkBqTt0ciMcJhZ1LiZ7cID0P/LxZsPtudjvXvI0EZFMWPxXTRr3N7
   i5VC+RilGzrP3lpm5DXHD1tdkBVICqtARMdSULyMwJJJ9/LxasmKDOatN
   eY1E3v6i9z5E1jqxFdo6yZklSUR2vQ2bAP73LxdEvCun6HtIl9ArRbDpf
   83EWSR8bjsZ6yPNXlW6KUuZEIs10TILQY/UDjwd0oa2S2x7dmrsiOzEbd
   YfxH9t2LDniACdNhmp3Ay8TBR6O1XKCeQQGarNYChgg08ag8UwbnGsN2x
   A==;
X-CSE-ConnectionGUID: 3djP5VXgR1mBgKtBFZdHbg==
X-CSE-MsgGUID: JpfzstWFQCqxJlZa9p+dsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="68536240"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="68536240"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:18:34 -0800
X-CSE-ConnectionGUID: Ztc0uIr6SnWnGtUG/PUiQw==
X-CSE-MsgGUID: ik644AYnTPanoo+R8LsQtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="208503873"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.157])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 03:18:31 -0800
Date: Fri, 9 Jan 2026 13:18:29 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aWDkBUss5o0FerOv@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
 <aWAPOyJwhpfKpqPy@smile.fi.intel.com>
 <89207e33051803a21b0703987bf2a91208e8cf70.camel@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89207e33051803a21b0703987bf2a91208e8cf70.camel@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Jan 09, 2026 at 02:05:41PM +0300, Dmitry Antipov wrote:
> On Thu, 2026-01-08 at 22:10 +0200, Andy Shevchenko wrote:
> 
> > Hmm... Why not -ERANGE (IIRC this what kstrto*() returns when it doesn't match
> > the given range).
> 
> Well, I've always treated -ERANGE closer to formal math, i.e. "return -ERANGE
> if X is not in [A:B)", rather than using it to denote something which makes
> no practical sense in some particular context, like negative amount of memory
> or negative string length.

Well, I'm not talking about your preferences, I'm talking about the change you
made. First of all,

	        if (rv & KSTRTOX_OVERFLOW)
                return -ERANGE;

is in the original kstrtox implementation that suggests that the code is
already established for the purpose. Second, the bigger issue, the two
semantically different error paths return the same error code when it can
be easily avoided.

-- 
With Best Regards,
Andy Shevchenko


