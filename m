Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68261D31B5
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953714; cv=none; b=ds7CtgdCUAb+8IHWwAbGkhT/IAYmVOMSKYCFyYcBxN5at95UcqHg3QSyY6/m33XTDu2e5VTdtUtRHwZ6rBcXZLW0o/jz8n6ntpjDeZpKen0ojxQK9OyC0VBPYuyFxsiyF4gdUXlXVO7xVkT1BvOSoVKEfqtVwPubxurh+GKv5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953714; c=relaxed/simple;
	bh=YVSD3bCd2/k4rX5ektlt4U1Bn4gGjNejSK1eEd+F6QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqEv0lLhDY4Cf+FPy61DgWblMlCxguErrcr9EXyTkWiabIqv/H/sFP0hiDI7Vgp477pEUNOQyL3MkGo6xWlCBxjzz4CVgTru+SocwD4VPx7kLAWegpMBvUlt337JhnhxMc2PtTPiNt+kt7+WY2IzdoM0KqEAdCbPBWeEIJBRLG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwOwECCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwOwECCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30861C4CED2;
	Wed, 11 Dec 2024 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733953714;
	bh=YVSD3bCd2/k4rX5ektlt4U1Bn4gGjNejSK1eEd+F6QM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwOwECCm/7rBtDVltXTAvTWcY6IlGPWU5VuorPMCMmMOU9PGL6TqlZljfwciVZ9UG
	 tM3ydbz63OTBx4u956Usof7DGNoF6cUyutIYpd624iAuvEt8+uRHFQR1UfARq4abT1
	 p9T8XmdJip/STGrBk35IqRoP6pNOXEV44iKWO1TZokD09mKunB8OdlfMTsvy0ump4e
	 bmALzk8jHxPygNBQflJdmpeHIWM3PhaemYBh6XjWJC76ObwUP1ofTUCq7jWLsTzJnw
	 HkwnxXE4+uP2H4S/+o9UW32MQllVagiYizC2lS59Bbod+QqNy5oBqEJxWobpDwY8VL
	 EZ22fVd8j8p7A==
Date: Wed, 11 Dec 2024 13:48:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/50] xfs_db: report rt group and block number in the
 bmap command
Message-ID: <20241211214833.GW6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752480.126362.14408954135415554700.stgit@frogsfrogsfrogs>
 <Z1fWZ1_LZoJIW2X2@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fWZ1_LZoJIW2X2@infradead.org>

On Mon, Dec 09, 2024 at 09:49:27PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 04:14:05PM -0800, Darrick J. Wong wrote:
> > +static void
> > +print_group_bmbt(
> > +	bool			isrt,
> > +	int			whichfork,
> > +	const struct bmap_ext	*be)
> > +{
> > +	unsigned int		gno;
> > +	unsigned long long	gbno;
> > +
> > +	if (whichfork == XFS_DATA_FORK && isrt) {
> > +		gno = xfs_rtb_to_rgno(mp, be->startblock);
> > +		gbno = xfs_rtb_to_rgbno(mp, be->startblock);
> > +	} else {
> > +		gno = XFS_FSB_TO_AGNO(mp, be->startblock);
> > +		gbno = XFS_FSB_TO_AGBNO(mp, be->startblock);
> 
> Maybe use xfs_fsb_to_gno and xfs_fsb_to_gbno here?

Will do.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
