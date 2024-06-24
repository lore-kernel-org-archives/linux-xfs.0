Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1662A1CFBC
	for <linux-xfs@vger.kernel.org>; Mon, 24 Jun 2024 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719210396; cv=none; b=H55UZIvoYOFoal/YN3XiYN9iRkF7Uvx4C9Md4A6zgitRR90dH/uQ42DgPTKY+2IW4j+GLrLFDX8HKrSOYm6Lkg+NeWHxZwx1RSFZv6AoFHtb4IhWI+pe1iiyhPmVOpnXwM6fzct/ziwie4401KHArKotimgWIF38AY1gIVSCQ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719210396; c=relaxed/simple;
	bh=PC4j4wKtzdlsmHk9ZAtmFNpLNxP+mqFvCjLPK8Sh37s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZl9UBlOq3D8c9MgqcpAy3v/y6tNme5LCKaMYyVe+O/SK9vzEcrISfqFxdPG4f8mO9rIzWPsUBecz8LjankObIemQ+uvubeWfKpk04i4DClu62mek0G/CePMHyqr7cgGmYA11T32E+tFwN8yVs+ztFN1FMk3e7xOvbB4wNFxn1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxnSon3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxnSon3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF1CC2BBFC;
	Mon, 24 Jun 2024 06:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719210395;
	bh=PC4j4wKtzdlsmHk9ZAtmFNpLNxP+mqFvCjLPK8Sh37s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hxnSon3J4sHNgZIKmUeNzNT72ZU/wLGuFiKhQyzzkYvnCkmbc+l7iDprRmUGBG1KK
	 dPJCCrukKO9hBYWwXK4u1mnlTzvjeAcL6DFSaFaQkBZs6jjjEyaAaq+ucWpP5C0U0W
	 f3frX3Ro2wLXyxemopW0x4rzGbl34hFYjCiVyI40WGxhsmlLTNzX/byqcZS34GHgqk
	 axCVSGPK9TI9iBefrLjms33dlP3x5wmcn9dVw8S+7Sj2eaRHA2PdlSm2DOXTZlBjWG
	 qUx+mx6OpeXIUBROMPHwQcH83h7I8z721A+WDh09ohvtwF5Y+uIHZMDpa80YKoihVV
	 ItZHK+8AkZ5tQ==
Date: Sun, 23 Jun 2024 23:26:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: random fixes for 6.10
Message-ID: <20240624062634.GB3058325@frogsfrogsfrogs>
References: <None>
 <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
 <8734p34uyp.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87ikxyooew.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ikxyooew.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, Jun 24, 2024 at 11:45:50AM +0530, Chandan Babu R wrote:
> On Sun, Jun 23, 2024 at 07:18:19 PM +0530, Chandan Babu R wrote:
> > On Sat, Jun 22, 2024 at 08:59:00 AM -0700, Darrick J. Wong wrote:
> >> Hi Chandan,
> >>
> >> Please pull this branch with changes for xfs for 6.10-rc5.
> >
> > The new patches mentioned in the PR will have to be queued for 6.10-rc6 as I
> > have already sent a XFS PR for 6.10-rc5. Can you please rebase the patchset on
> > 6.10-rc5 and resend?
> 
> Darrick, I have cherry picked the patches from your branch and applied them on
> 6.10-rc5. The resultant git tree is at
> https://git.kernel.org/pub/scm/linux/kernel/git/chandanbabu/linux.git/log/?h=xfs-6.10-fixesD

Looks identical to my branch.  Feel free to start testing on that; I've
already started it on my own fleet.

--D

> -- 
> Chandan
> 
