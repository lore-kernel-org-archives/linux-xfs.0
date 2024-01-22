Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E59A3D0C2
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705930457; cv=none; b=HNF67tahSuydiSON43KUNfim8HcyXmPtzEqGjoWNH+Ea+k6ELpMxARuJqwqjfYcWhIvHKiAL3qRpttDvRHX3JOiQhgWrZ6B3jmQ2WelbW49VXVA3ayrW6jOglRzlyRRCKpfAhS7lkwYcG5xTnl8chZbOWhvlndPvAsZysIYSOZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705930457; c=relaxed/simple;
	bh=58hk3EGgivAqnjEyYxsUglKu29GyzAljTRDcz4+mJzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kWG01tW8DO1hSyPgIfsRXZDIIA5lRZ+TpdDJXlTvozB/yu1/+2tPXMSUF5h2BzRB3ocIaQYu/bQtgA3IPE00Fail73vsFeT/bN/S/E3wsyEVyu3GxC4HVjnLhbgEejDasJZIC1x+FXjPxZ+ONJ2ha60lsG3gzZdn67/glgIKZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LCj3iWGX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LCj3iWGX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705930455; x=1737466455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=58hk3EGgivAqnjEyYxsUglKu29GyzAljTRDcz4+mJzs=;
  b=LCj3iWGX1pEyc5WwL4J4L74qXp2SDZpYQ6IiljC2Paq4n3UiJQF8bUYU
   S40Fppuc/iOP6CPMTSCgdS56UXfZTpYGs83TGuJRgMYIsS7CWLMQk6sEh
   s5oj2x7MSvqhPSzHxULLAaTQHsuV4lbVWH5J8qguD5Ya0UjEbJP3zs2UB
   DvbbiyVYQ+e9GeNb5k1aYBvI1i9Q0K2yEw/BZUuw0g8JUkXepNReHKcPH
   0dSMg2swMp0oYmOts0feZ/CPadX7iORTrUC8BpILGLM1dSd17WBPRMcFm
   dBTCGkGnwq+7OLxychbgAK8T8kd+2ha9FyzIbjN1hKeb/2bqE7LfMga9/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="1091137"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="1091137"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 05:34:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="928993791"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="928993791"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 05:34:14 -0800
Date: Mon, 22 Jan 2024 05:34:12 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Using Folios for XFS metadata
Message-ID: <Za5u1CsKnrWflMOR@tassilo>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <87zfwxk75o.fsf@linux.intel.com>
 <Za5XQDOutk93L5w1@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za5XQDOutk93L5w1@dread.disaster.area>

[fixed the subject, not sure what happened there]

FWIW I'm not sure fail-fail is always the right strategy here,
in many cases even with some reclaim, compaction may win. Just not if you're
on a tight budget for the latencies.

> I stress test and measure XFS metadata performance under sustained
> memory pressure all the time. This change has not caused any
> obvious regressions in the short time I've been testing it.

Did you test for tail latencies?

There are some relatively simple ways to trigger memory fragmentation,
the standard way is to allocate a very large THP backed file and then
punch a lot of holes.

> 
> I still need to do perf testing on large directory block sizes. That
> is where high-order allocations will get stressed - that's where
> xlog_kvmalloc() starts dominating the profiles as it trips over
> vmalloc scalability issues...

Yes that's true. vmalloc has many issues, although with the recent
patches to split the rbtrees with separate locks it may now look
quite different than before.

> 
> > I would in any case add a tunable for it in case people run into this.
> 
> No tunables. It either works or it doesn't. If we can't make
> it work reliably by default, we throw it in the dumpster, light it
> on fire and walk away.

I'm not sure there is a single definition of "reliably" here -- for
many workloads tail latencies don't matter, so it's always reliable,
as long as you have good aggregate throughput.

Others have very high expectations for them.

Forcing the high expectations on everyone is probably not a good
general strategy though, as there are general trade offs.

I could see that having lots of small tunables for every use might not be a
good idea. Perhaps there would be a case for a single general tunable
that controls higher order folios for everyone.

> 
> > Tail latencies are a common concern on many IO workloads.
> 
> Yes, for user data operations it's a common concern. For metadata,
> not so much - there's so many far worse long tail latencies in
> metadata operations (like waiting for journal space) that memory
> allocation latencies in the metadata IO path are largely noise....

I've seen pretty long stalls in the past.

The difference to the journal is also that it is local the file system, while
the memory is normally shared with everyone on the node or system. So the
scope of noisy neighbour impact can be quite different, especially on a large
machine. 

-Andi

