Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CD23A6F0D;
	Mon, 20 Apr 2026 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706941; cv=none; b=nyJOrE1rv7esZmADcvUomJDmoIBz+11dQcxMrW/+WdTMikE49mWCZsZPtb20uJh0luATq9nIFFZn7G3LrrpyArZZTgJsW1+JEL17tdaPH3OSQYCvh/yoHzXYk9a1dzK4EpuDY0+Y0vSFCm9ujrnMloBr9Ffl9sZQ9Q880USBawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706941; c=relaxed/simple;
	bh=ewS8XayXTT+brpSlf2I9gcA6npEGyfxc1SohLWZW+dY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBukW+yUD4EEuyTlvuv7Yq19oH/9yWtyQuzgnbkC5hOaMjIKxWK8HodRuX0N8vBDHUYBdIGqRGo4TN1KF6Yfq4uZvG7hLGKBC8fDngDCcmzMQu1tk7QSTZ1fG30DSuCpm1CsmuyFgLT++9JUH89wH84rNh6XRJg5q+cRtwcbHvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=iEBbnuxd; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="iEBbnuxd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1776706940; x=1808242940;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4ygSSPkBkWYWeDHa/9OYHjRfNeT3UN89c1p1ILcsprA=;
  b=iEBbnuxdF520TInXqfR2u+zgQdScOB6i4K7+owYXm/jhaBXlpz+wpfP0
   jYAwhnVkusyo844q2WNEBBxKIaKoqaBZJ3Rx/Xo8e4cCV3g9piAaF6zU7
   GOgkrVT29/7tFgJ0/Axaeuu4VDub4H0SRvPdIOfNDQoW265ZxAeLySICx
   fBTHTKFe2b0YWa6ZGGplrmia7WWmxmhoDElm+bvNvlDbkjPWT5RvlbXF6
   n2RgjHSbzsFciAnkvFZalzT6HIn4ySBUUld199rUW2YSjTMGMbCBZ3Da5
   ezLYlRSVcvF7VVULh1egXL637QVEHiuLyOMkMsBumSsgoICTlH8JGa0sO
   g==;
X-CSE-ConnectionGUID: U2oDcrnXQn6orCqR6ksaqw==
X-CSE-MsgGUID: FbBWJTMxTUWBvG+lzp1/qA==
X-IronPort-AV: E=Sophos;i="6.23,190,1770595200"; 
   d="scan'208";a="17764093"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2026 17:42:17 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:27129]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.29.81:2525] with esmtp (Farcaster)
 id 2904113e-6686-4a61-81ba-1e65339b6778; Mon, 20 Apr 2026 17:42:17 +0000 (UTC)
X-Farcaster-Flow-ID: 2904113e-6686-4a61-81ba-1e65339b6778
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 17:42:17 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.23) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 20 Apr 2026 17:42:15 +0000
Date: Mon, 20 Apr 2026 18:42:12 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: check da node block pad field during scrub
Message-ID: <aeZldBLyOx7HXX3u@c889f3b07a0a.ant.amazon.com>
References: <20260410170614.8075-2-ytohnuki@amazon.com>
 <20260415152035.GC114209@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260415152035.GC114209@frogsfrogsfrogs>
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Wed, Apr 15, 2026 at 08:20:35AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 10, 2026 at 06:06:15PM +0100, Yuto Ohnuki wrote:
> > The da node block header (xfs_da3_node_hdr) contains a __pad32 field
> > that should always be zero. Add a check for this during directory and
> > attribute btree scrubbing.
> > 
> > Since old kernels may have written non-zero padding without issues, flag
> > this as an optimization opportunity (preen) rather than corruption.
> > 
> > Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> 
> Should the dabtree write verifier also set __pad32 to zero, in case the
> kernel encounters a dabtree block writen out before the memset was added
> to xfs_da3_node_create in commit a45086e27dfa21 ("xfs: validate metadata
> LSNs against log on v5 superblocks")?
> 
> This change on its own is correct though, so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D

Thank you for the suggestion and review. I'll investigate and send a 
follow-up patch to zero __pad32 in xfs_da3_node_write_verify().



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



