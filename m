Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E11A9FBD;
	Mon, 20 Apr 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707654; cv=none; b=pVyq47ItHoZa/OzBMSjkkO+z3dETI6IKHz2tN3lLV++i7GaX1ItC+Pa/K+fVxW0F7aTGVfhwPXicgjHle3oPX1HA1/Wfu5CI1SCBGxHn+UWsCxPEZ8Sf52Unjuq9MDLrRey9NscAEynKeGxwtaecpGWHFpdSoEEQms+zfoGCYs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707654; c=relaxed/simple;
	bh=AMvN39ZxnYx1hNXKx8u5sVakkcM0T/247EqfI30Dwy8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLXQgy0hoC6IF2jyrUcDU3R6L59oYD2rBjHPs2Qs7ZrhZFSy3fKRjjApSLLaclrGqFP9UdFKgi84QpYoDkXglgpykdhaMFpbngG0tTMTsrStrEYa4T+ZsF25hV6ecbtjqt2q7UKhCB5qtiM0h8FdESa7RkfVAtQ/9ttYIhYrdXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=aa7qaVb3; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="aa7qaVb3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776707653; x=1808243653;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9BiVhewQqTl8zTVq2h7srlQbqDLJtvkxzCZHf7aCiUQ=;
  b=aa7qaVb3lSueuJ/6wxwsYdHXmS9Azwt/2ZeGWdRtm2i5AralUgx9E3MY
   x9Y4a8ND0B7fuDC7xBVJEkmezZm91VtNSGw3k7nNHGC6swbzvXub/QRHX
   qLuFoHZ95PbeMjmIE2w7CI2a5ouCE91LoKzpks8O3YzLrdbBFeSjHcY7f
   uFGDPq8eisq4IDLl0RuzaVYmbyzBEEZ6T1Cke0ThWAorYgDwKNehpEryq
   EbROW6+LnMo0DAiAyqyru3aoL27+c35hDWRSqchFaYHbh55v6dPA2KjGD
   2txwv/AZKUfXTuIzWNGS0FNFGz8ao7HGVD638mm+Qy0mxTDwbQc4+cJrJ
   w==;
X-CSE-ConnectionGUID: VCJAGgCxTJeprsZZCmLD1Q==
X-CSE-MsgGUID: lDHWmZH5Rmmcl3XCjXAITw==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17739003"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 17:54:10 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:8269]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.89:2525] with esmtp (Farcaster)
 id 85f9c062-da45-4674-bbdf-de86a6486c2b; Mon, 20 Apr 2026 17:54:09 +0000 (UTC)
X-Farcaster-Flow-ID: 85f9c062-da45-4674-bbdf-de86a6486c2b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 17:54:08 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.23) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 17:54:06 +0000
Date: Mon, 20 Apr 2026 18:54:03 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Dave Chinner <dgc@kernel.org>
CC: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: check hash ordering in xfs_da3_node_verify
Message-ID: <aeZoO9dP5ATSdVux@c889f3b07a0a.ant.amazon.com>
References: <20260415071223.48609-2-ytohnuki@amazon.com>
 <20260415151625.GB114209@frogsfrogsfrogs>
 <aeAvumXnznX55MAb@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aeAvumXnznX55MAb@dread>
X-ClientProxiedBy: EX19D036UWB002.ant.amazon.com (10.13.139.139) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Apr 16, 2026 at 10:39:22AM +1000, Dave Chinner wrote:
> There were good reasons why this wasn't implemented originally but
> marked with an 'XXX: <question>' comment. It's not because it is
> hard to implement, but because it is an -expensive- check and it is
> has never been clear that the check would ever actually find
> corruptions in production systems.
> 
> That is, any media level error that could corrupt a hash value will
> be caught by the CRCs, hence the only vector for a production system
> to experience an out of order hash value is a bug in the XFS kernel
> code.
> 
> This situation has not changed in the past 12-13 years, so....
> 
> ... what's the CPU cost of doing this check? How much performance
> does this cost for cold cache directory traversal?

I confirmed that the hash order check does detect misordered entries
as expected, but I have not measured the performance cost yet.
Thank you for pointing that out.

> What if we have 64kB directory blocks and a full dabtree node? i.e.
> this will iterate 64kB of 4 byte hash values one at time, so how
> much does that cost?
> 
> What is the possible impacts of an out of order has entry? Lookups
> may not find the entry they are looking for, so files might be
> missing from directories. Even modifications will simply result in
> more out of order hash values or trip over out of order keys in path
> traversal which will trigger corruption reports and maybe shutdowns.
> I'm not sure there is anything else that can go wrong at runtime.
> 
> Hence even fuzzers like syzbot creating out of order hash entries
> shouldn't result in crashes or other sorts of serious failures.
> 
> In which case, how much extra protection against corruption based
> failures does runtime detection in production systems actually gain
> us? Is it worth the cost of running this verification on every
> directory node read and write?
> 
> If the only real issue we need to defend against is software bugs,
> then we should be modelling the verification on
> xfs_dir3_data_check().  That's runtime dir3 data block check
> function that is only run on DEBUG kernels. It is placed in the data
> block modification code to catch corruptions immediately after the
> broken modification code has created them. This seems like a similar
> situation to me.
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

That makes sense. I'll rework this as a DEBUG-only check modelled on
xfs_dir3_data_check(), and adopt Darrick's style suggestions as well.

Thanks for the review.

Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



