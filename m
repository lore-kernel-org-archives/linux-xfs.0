Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179313DFC85;
	Fri, 10 Apr 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775840186; cv=none; b=vBc+ws6n+1TVNfrFpT7AW9plXR7tXQ5+WH/WpID863OY6o5QOBD73NKIHIdABEmCbs48c1yP6rLH5r1VQdAORMhgwjoLvM5C3jgivy4PhGGaDN9um+SvbgnmG1tSiTOk17KRW0rQXL68b4c29geL8U7R+z8u4shAAZ68sk5xBVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775840186; c=relaxed/simple;
	bh=166ue4NEJQB54wlLBbgI14YwVOhmSYRnmKkaKDjRdE4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icrPq0uyzvDnvwUMjmXQLi/4UtTmmVdw9fz6eyBO37fZcr4qGEr+d2MDBKSVTsGhA381Sv7ADhHf3Gmwh10bfucn2Sfajat9Ewsbesz00SnDN5/AE8UqLciDwXVBhfx22koRkgTda9H0aYGZoK/TM3Jq6A6pbgOaFZBO64L7ffQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=W7VCJDNn; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="W7VCJDNn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775840184; x=1807376184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xFpXE3465A+Ppkm9PuRxGkyZZnYrgUqAjpeo+2rmocw=;
  b=W7VCJDNnJY3LpGRd8u9BF5uS5au6CCDrOFsPXL6z/VwuNj+OXGb74QVo
   +P7sB9tmggJl+dZSd05qsaxePIVUT0ne+MGpS60z3AVNDiJ2FtSRunuzp
   h5uvHPhNse8ySNhuem1urVfJVWyBCMcN8M/EwQEtIIUR5CIGtu3VaS4ux
   ZK3hCKY5atlXdalFRdjsWPB6DpAmvbAmQ4LZcg13QfRxO2if+XNZgRFMt
   ywpac2PWUNybSVz8Gc2lIkaFb3CaNsX45DldWqOHDS5XZ8yTJN3xWjPz5
   66HhwdliZ3UQqgJ1hy/7ar+h1nlkaMcc5QsUsHBpZUeztBEzmWCXK60oy
   w==;
X-CSE-ConnectionGUID: dypPgQxxSumX+LR4INZErA==
X-CSE-MsgGUID: 4oLnA8VSTVi9ZVVRvE4UEw==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="16801416"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:56:20 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:23697]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.68:2525] with esmtp (Farcaster)
 id 6daccc48-94be-4a8a-bfca-2d255c6fe652; Fri, 10 Apr 2026 16:56:20 +0000 (UTC)
X-Farcaster-Flow-ID: 6daccc48-94be-4a8a-bfca-2d255c6fe652
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 16:56:19 +0000
Received: from c889f3b07a0a.ant.amazon.com (10.106.83.15) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 16:56:18 +0000
Date: Fri, 10 Apr 2026 17:56:15 +0100
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: Dave Chinner <dgc@kernel.org>
CC: Carlos Maiolino <cem@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: check da node block pad field during scrub
Message-ID: <adkrr508BIwuCVYd@c889f3b07a0a.ant.amazon.com>
References: <20260408174033.4165-2-ytohnuki@amazon.com>
 <adbLQXN3g5XChaJL@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <adbLQXN3g5XChaJL@dread>
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Thu, Apr 09, 2026 at 07:40:17AM +1000, Dave Chinner wrote:
> Endian conversion not necessary on comaprison to zero.
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

Understood. I'll send v3 without endian conversion.

Thank you for the review.
Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



