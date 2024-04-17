Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4A374D2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 20:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713384927; cv=none; b=l9vvjO/9qvaeQctk7b+S0dczd70yQtLMq3qu103RE8es5ZZ9iOFoSFPLwEVe2SFULDjawBhdobHmQYx8M9ZOluWSR5x9DWZy43izvSdfOBazx3RHIcy5xKl60C+Ymy6YCMY4DrveIFJ9pp4/vTj6QXrXEOq3rJvc3WG/DYjoeEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713384927; c=relaxed/simple;
	bh=xdRqJsITuCiO+siGsWAV2pIC9T09Tdp5oXWZy4Uie8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/XfbwTd8BU8ipFznsc1KlPrCTxBtB1TfTuHNa2hLsbQ9ONJys6wilZGTiQ9eIf8nrPAruTBD00bDnx6pYWc8vhVMudunJS1FCBBGKa7gctdw/MutJteDNS1EAVMb2/gZTUwLhDs/gy/JPV0BmixwH7Eq1kLOv1mN5M+kznNzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBs4U265; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBs4U265"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216A8C072AA;
	Wed, 17 Apr 2024 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713384926;
	bh=xdRqJsITuCiO+siGsWAV2pIC9T09Tdp5oXWZy4Uie8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EBs4U265uRzcdwrRLQAHnKrEtAMzcFQ850nKS2n2o5kGxeoqVAnAioz2Loguhvk0D
	 3EwzwjD+R7NsW9DkpMudssB7tEojVZMomIum6rsEneF8VgQBj7hwNJjKSTHrF0VoUD
	 RSoK/dhUVQ4cw3y/ToV5LGKTRUaH+Eydbo4Tbk97ubCnbJzkYjwU8N3yBBjYh/bdzF
	 69xdyzCEZjcl0V/bcvL3LCj6pAa4aFjZXCqoLqsbMKocDs/T3NC5zU8bIQ/xfa+1ka
	 F4NXNRvfIx6dif+K3ER1PFnbeQ03swJtGmBXVNzTNBJgv2qkJ+WN90BCW83n1TUHK4
	 RV67cqQh6chfA==
Date: Wed, 17 Apr 2024 22:15:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs v6.7.0 released
Message-ID: <ftqfopwvmyponcod6miad2ammahmwddkfjel2wodwchfi32eeh@znsirj6nta3m>
References: <fcm36zohx5vbvsd2houwjsmln4kc4grkazbgn6qlsjjglyozep@knvfxshr2bmy>
 <mMHk0yaj9LgGgzujpBfn8GpG3uZmXbQHUrGp5m_ZJWUAwpcEcZWzMa0KUUcZ8_oQ5T6lDTu0CcOl-hYmW7z-MA==@protonmail.internalid>
 <20240417151834.GR11948@frogsfrogsfrogs>
 <pvsrakeforclh6cg576qn4u3ifgtzl6iwebzyjvxtvxqh2ph55@muhndh3a536k>
 <MASg3WtFBO8yxKI_iUg-XIIjHa7KXB3dZRiFGPBg3TywDZmCQi9z5oyGITFX3D2IXnc0vSvUL_3uzVMWtMZQYA==@protonmail.internalid>
 <20240417153456.GZ11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417153456.GZ11948@frogsfrogsfrogs>

On Wed, Apr 17, 2024 at 08:34:56AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 17, 2024 at 05:32:15PM +0200, Carlos Maiolino wrote:
> > On Wed, Apr 17, 2024 at 08:18:34AM -0700, Darrick J. Wong wrote:
> > > On Wed, Apr 17, 2024 at 10:13:52AM +0200, Carlos Maiolino wrote:
> > > > Hi folks,
> > > >
> > > > The xfsprogs repository at:
> > > >
> > > > 	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > >
> > > > has just been updated.
> > > >
> > > > Patches often get missed, so if your outstanding patches are properly reviewed
> > > > on the list and not included in this update, please let me know.
> > >
> > > Ah well, I was hoping to get
> > > https://lore.kernel.org/linux-xfs/171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs/
> > > and
> > > https://lore.kernel.org/linux-xfs/20240326192448.GI6414@frogsfrogsfrogs/
> > > in for 6.7.
> >
> > To be honest, one of the reasons I decided to release 6.7 today, was because these patches were
> > cooking for too long on the list, and I wanted to pull them this week, but not delay 6.7 because of
> > them as I want to also not delay 6.8 for too long, mostly libxfs-sync and what we already have on
> > the list. The debian one I totally missed it btw
> >
> > Also, I was assuming you were going to send PRs for these series according to our previous talks,
> > will you still submit PRs or shall I pull them from the list?
> >
> > I'll try to pull those patches you meant asap.
> >
> > I could do a 6.7.1 release with the debian patch if this is really required, but I don't think it
> > will change anything if I simply postpone it for 6.8.
> 
> Well if we get a 6.8 release out fairly fast then it might not matter --
> Debian are busy rebuilding the world with 64-bit time_t and altered
> package names.

We are getting close to kernel 6.9 release, and I don't want to keep xfsprogs and I want to try to
keep xfsprogs just behind kernel, so, I do plan to release 6.8 on the following couple weeks.

Carlos

> 
> --D
> 
> >
> > >
> > > --D
> > >
> > > >
> > > > The for-next branch has also been updated to match the state of master.
> > > >
> > > > The new head of the master branch is commit:
> > > >
> > > > 09ba6420a1ee2ca4bfc763e498b4ee6be415b131
> > > >
> > > > --
> > > > Carlos
> > > >
> > >
> >
> 
