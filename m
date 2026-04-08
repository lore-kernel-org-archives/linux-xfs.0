Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF763BAD8F;
	Wed,  8 Apr 2026 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.162.73.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775668504; cv=none; b=U05xWBfPtBFwMt3bfIBHFtqUeBFH9B1rJWJEIp6QPmnzievnoj+Cfdrb7i0WmZnD81y0C/1Tb9iNxCuxMHY2dGKLP9LpMFC+Mo086PqbooPr0x7JrIy8Mw97iDolKJn/mtO6IqLacd5OXp7N+U5yMKyr2hhzncOVJNe8d/1bBnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775668504; c=relaxed/simple;
	bh=89ETmK3azvcY8S9Rjtp+eg1VdHnZk9h1BOB+yMXuMI8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bs2Gl3t19/NDrG/pfF4y/775Btt8YRFhz2E5HXLrwVBTa2US8w4ePZda1zY1Att4yWtiUoXSsQtHXsxLFn3/FO4fjL2y0ahxidnOwripyCtTDVOR7TaFyH2b6iacz+WB5Ek9j2bHXLFLqn8IyOlY/ei2+dwc3LlxcO9OO2JMxlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=TvD1OpbZ; arc=none smtp.client-ip=35.162.73.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="TvD1OpbZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775668503; x=1807204503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hdA6Be0uOCndd3uE/1CUaoV4Lfyc01ux8KYme/Sryn8=;
  b=TvD1OpbZUIQUuPtyt7/hG6cu0m4Z3PNZwEmZwQgAC35u9znzOpKsLdJo
   o9guO7ERkh2B+Q49BelWJLqgLM/Us5QUQobaX6c+hpyODLI/DfRvg6a85
   dL9XjBOO7JWlRw+qPjGhXEwBqQpTX4DJEyhCtGOYUOblp5R9QX4lYDkl8
   zR119ioeS4hPM1bfmXQbv8ny101qChDZj6XJOCYd3bhaLdMi1PzSQRu/t
   2IdztTPsxnqdZx7INhp2oyyiegL/mWgmfccwLjf1tze0iWivj+yVQXCPC
   DyHc6zIzBrUrUCN+3pBGCRy0qyab6wM9CLySyqNECQ0YAo1nWtzy7gYtF
   A==;
X-CSE-ConnectionGUID: fYAK8/n3S9meEo9gc+kxEQ==
X-CSE-MsgGUID: zFbrU7M9Q9OzmgFC61oKyQ==
X-IronPort-AV: E=Sophos;i="6.23,167,1770595200"; 
   d="scan'208";a="16655386"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 17:15:00 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:29743]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.3.82:2525] with esmtp (Farcaster)
 id d23ff382-d627-4458-a3e9-152157520483; Wed, 8 Apr 2026 17:14:59 +0000 (UTC)
X-Farcaster-Flow-ID: d23ff382-d627-4458-a3e9-152157520483
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:14:58 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.24) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 8 Apr 2026 17:14:57 +0000
Date: Wed, 8 Apr 2026 18:14:54 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: check da node block pad field during scrub
Message-ID: <adaNDr-BeEu04Px7@c889f3b07a0a.ant.amazon.com>
References: <20260404143043.65268-2-ytohnuki@amazon.com>
 <20260406152304.GB1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260406152304.GB1048989@frogsfrogsfrogs>
X-ClientProxiedBy: EX19D038UWB004.ant.amazon.com (10.13.139.177) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Apr 06, 2026 at 08:23:04AM -0700, Darrick J. Wong wrote:

Thank you for reviewing this patch as well.

> Same question as the previous patch -- does xfs_da3_node_create actually
> zero out the pad field?

Yes, xfs_da3_node_create already does
memset(hdr3, 0, sizeof(struct xfs_da3_node_hdr)) which covers __pad32.

> and same comment about how you can only set xchk_da_set_preen if old
> kernels were ok with nonzero __pad32.
> 
> --D
> 

Understood. I'll switch to xchk_da_set_preen as well.

I'll send a v2 with this change.

Thanks,
Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



