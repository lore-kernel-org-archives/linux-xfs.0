Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D91B3A1A1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705918406; cv=none; b=ML2jWuBY8+TlBnmfPJ5EEhPEOddBs2z86nCg7lBD2g0CdOVZIYJCPb4/y9qqhQVIxP8yLGPiZWKiSadzaFtywWKt22PfBch5Yusa3T0oD1CPSoIXcZDGySyAWo7AR5HD2T2BueMne8valEHSdbWiS9xvAOyxIpJ31A0Mj7nB6R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705918406; c=relaxed/simple;
	bh=9P+U30bR7kdblG2AxhM1pHhlDtODws/tQ2P3oU5CvNA=;
	h=From:To:References:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Ah7N0FnXw2+a/nD1EFJSRdhXDWBOPUYgtlh5Tuk996uxHgk24mDFFNM0OvQlp2ntFCOaEZfwP0Hq/K7ZMiNrsGMiBzaczQwjpFdKYTSD5D3JmU/jMrl+Gg8nA+wW+IFFYqw2CTrx67buWwYMqWIaBeMvAHnxSkQRSo1MUfvuHGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIb6DBm3; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIb6DBm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705918405; x=1737454405;
  h=from:to:references:date:in-reply-to:message-id:
   mime-version;
  bh=9P+U30bR7kdblG2AxhM1pHhlDtODws/tQ2P3oU5CvNA=;
  b=JIb6DBm3r0MNvAc78cYzMpuzqtB+nAixCNR1MUyxwiAvI05gV8HKAyRt
   ci8sYQTHgrnc+2D4FiH56Snw7ciRWmZnkDk5refiLCBO6Nk9Ntjsq28wm
   JvQiNfnZ5YX05cy15yVGXTJa5ZU0lGKprQUSkOXqGTBBEBCqrlsEz0jAY
   6aoH1UsdnlLhPVp9zHMbwzwv3rhfh64YVlrx1oTUxDLMGuM4aE2FIeogS
   VMKmx37SPltLNVch5vHOD2CImggbQWWAYXpVxfzRS9JRDu89tkbL315OK
   NkpkeWet3bgpHmQToZEl5zB3uXyht3rHQXN6x4RK72/a5ojqjQ3eW//Ir
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="61405"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="61405"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 02:13:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1164931"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.38.190])
  by orviesa005.jf.intel.com with ESMTP; 22 Jan 2024 02:13:24 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
	id 9563F301BE1; Mon, 22 Jan 2024 02:13:23 -0800 (PST)
From: Andi Kleen <ak@linux.intel.com>
To: linux-xfs@vger.kernel.org, david@fromorbit.com, linux-mm@kvack.org
References: <20240118222216.4131379-1-david@fromorbit.com>
Date: Mon, 22 Jan 2024 02:13:23 -0800
In-Reply-To: <20240118222216.4131379-1-david@fromorbit.com> (Dave Chinner's
	message of "Fri, 19 Jan 2024 09:19:38 +1100")
Message-ID: <87zfwxk75o.fsf@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dave Chinner <david@fromorbit.com> writes:

> Thoughts, comments, etc?

The interesting part is if it will cause additional tail latencies
allocating under fragmentation with direct reclaim, compaction
etc. being triggered before it falls back to the base page path.

In fact it is highly likely it will, the question is just how bad it is.

Unfortunately benchmarking for that isn't that easy, it needs artificial
memory fragmentation and then some high stress workload, and then
instrumenting the transactions for individual latencies. 

I would in any case add a tunable for it in case people run into this.
Tail latencies are a common concern on many IO workloads.

-Andi
