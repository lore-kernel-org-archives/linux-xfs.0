Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30D834E751
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771605841; cv=none; b=fKUO5+PSMzci/rx1Mrcf+620SG+H6HM6s0LzuHrtoV7ucWXP/cwLIxaEhOzn3y8JCgtXTbCAaPvFCAzIc/JtomK8ucbNJ9f0fvM+eQMeCYlJBc+luN9JGRatyflCMp7da1hg9+cmVLPdbAuEPsg6LcRAaOMKhi49QjhwG5ahejs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771605841; c=relaxed/simple;
	bh=X9jd6sfUovU0eY+RUbQrkjGipQwv4aXwZJLhlAwApoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDo9I8NCQJeiidj3QWwxKwot0rNPOEfn3GOzU/jnnhDKbcPPa3JBRBfuw226l+6+Iz4KnSytMxPfO/xYAbDr5jJHjzRngrOaSNDuAGlxf2zXuy9F/tACRE34SdCnyt1jue2J4gc8BGxwLc1y19JFvs1zekO0hiE69BnE61fRw0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKHUC1UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKHUC1UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D6EC116C6;
	Fri, 20 Feb 2026 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771605840;
	bh=X9jd6sfUovU0eY+RUbQrkjGipQwv4aXwZJLhlAwApoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CKHUC1UCf7S2lc7PM/Sy5iL+LAzQcaRxDfzb0CG4AGUsJ8Omc5rwRWTmrh8l2tSgr
	 stwRvzEd5tsxqL+hduyVVf2K9E+uEbVb4Mcl6i904YI4y5zCBMtPVEA/5M+Q8MffY0
	 y9k4nuD8EeLrAqnJ8UFW4YFOuvGPjhI2eLPgyDfrDlN54OwdBCjDndsP4CaVZKoOxT
	 HV5CjJqdHuLYfsrWVbA9umYD63W65uLkNya4UMaCuxrHgw23xgETW4TrH49wwO4TyX
	 BmhDd/PLx0/UUr3FwTEeceiAcXm2Y2QBFDgO3dFkmExZhmkR/rr8PeUBnp4r2dw4WY
	 V1vttCOpRlldA==
Date: Fri, 20 Feb 2026 08:44:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.19
Message-ID: <20260220164400.GZ6490@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
 <aZh_Rb7fGsXek6GE@infradead.org>
 <20260220162755.GX6490@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220162755.GX6490@frogsfrogsfrogs>

On Fri, Feb 20, 2026 at 08:27:55AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 20, 2026 at 07:35:33AM -0800, Christoph Hellwig wrote:
> > This all (or at least mostly?) seems to be in xfsprogs for-next already.
> 
> Oh, I must've missed the announcement.  And then I also missed that
> gitweb shifted because that stupid Anubis thing usually won't load due
> to its 300K of web artifacts also 503'ing due to excess load.
> 
> Will rebase and resend whatever's necessary.  Sorry about the noise.

Indeed this whole patchset is already merged, everyone please disregard
it.

--D
