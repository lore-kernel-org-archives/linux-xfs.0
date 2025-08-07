Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2A2AD32
	for <linux-xfs@vger.kernel.org>; Thu,  7 Aug 2025 07:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754552023; cv=none; b=Yq6SxQZq+JWvsG8tsearHui2ZbvKHL556sD/elF3dSWv7XISGrpZi8+SusrTEfl8BV0rlck5tZN0TH2ua4RZZ5nujygK5byG6UNSKN89M+dLyHtpPn/xTOb6/YlPe/IQSyWNMzOxxIJAzOrTDGFu31RtvchVqqLSPt6A1ZCtd6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754552023; c=relaxed/simple;
	bh=bDP5p2/LyDqEjFbh/+6xWGutt0Mv54I90RfiFsprd+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlJCfoBCC8ec46ysT6zshUv7fcakks0i9aYNu4kGH5uCM6vzakrRhM7TxlUPhGDPEy2ICjgDwNLEZ8+uv+u/WgBxP0n3lQfNE7OuKjxVSJSXjAA4+DnocWvwtzU8HW/Lk0zhUizToW3M2DHqmeuLJ5eOEUIkUaCsF7y4ynQLJjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LX32cHYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LX32cHYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D125CC4CEEB;
	Thu,  7 Aug 2025 07:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754552022;
	bh=bDP5p2/LyDqEjFbh/+6xWGutt0Mv54I90RfiFsprd+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LX32cHYqZPWSoF2W7SKLP3sv8yki+4vtp8fs2PL5RNz7tdtQARicoTopXmQX25ysG
	 ihMFUIeH+1c4rG8hT5qonfDn88cHuUBoilP+Ja/Jvk8wRHyDztm0Sy96nMe2ED7WgT
	 Pa5Yg+9nZzdd9PaxfdY2hSS3NN+tZckzSN0qP2orMAPfqGbfAUvx3mpEDbEQAYsh6F
	 nCRmUCXSwal2MGTneMdGervkwsy7YHMXsEAZdUmR0lGWINOwR6wltvwtIQQjcyFRl5
	 2/rPd1moMe3lwoiEBtFJ9M5sNbHFcdW0F8UgkQDtv5LsNc6ksd75kOxfAV07Bj0Sa0
	 shlGD4BTM46xg==
Date: Thu, 7 Aug 2025 09:33:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Message-ID: <rmg7ftcpgh3nqpw4ljpiyawivgl4bg5bz2n7bhxswaafaqcmqw@rvfajjqxpvl2>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
 <IFqtoM3P4UP6lDAVnaetg8PD6iHVwJagb5GWUDGNyKYfziLc4ww2iM-CgpCoxACHecTMWYZridqsB1Tewz_EAQ==@protonmail.internalid>
 <756f897c-37d3-47ea-8026-14e21ec3bb1a@kernel.org>
 <h2rtuedwnlr6qawsrx3uz4gtkpfvvlijutv7w3pdtfbvord7cu@cm2zjbu3iir5>
 <AtIY9HhAD-nEQAt0SR5iEoz5rK-63Wlfp8zr4MqXLeJWOmgDPopFP741ObEfCY7epfu86-UCyQRHwZ6rNAIq_w==@protonmail.internalid>
 <20caa496-4ae5-4c56-98dd-bdf56684acd1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20caa496-4ae5-4c56-98dd-bdf56684acd1@kernel.org>


Hi Damien.

On Wed, Aug 06, 2025 at 06:35:17PM +0900, Damien Le Moal wrote:
> On 8/6/25 5:45 PM, Carlos Maiolino wrote:
> >> This does not force the user to use XFS_RT, it only makes that feature
> >> available for someone wanting to format e.g. an SMR HDD with XFS.
> >> I am not sure how "costly" enabling XFS_RT is if it is not used. There is for
> >> sure some xfs code size increase, but beside that, is it really an issue ?
> >
> > The problem I want to raise is not about code size increase, but about
> > having XFS_RT tied with BLK_DEV_ZONED.
> > I know it doesn't force users to use XFS_RT, but there are distros out
> > there which purposely disables XFS_RT, but at the same time might want
> > BLK_DEV_ZONED enabled to use, for example with btrfs.
> 
> Yes. Fedora is one. With it, we can use btrfs on zoned devices (and zonefs too)
> but not XFS because they do not enable XFS_RT.

$ grep XFS_RT /boot/config-6.15.8-200.fc42.x86_64
CONFIG_XFS_RT=y

Fedora do Enable XFS_RT :-)

> So I can send a patch for their
> kernel config to see if they would accept it. And do the same for many other
> distros that have a similar config.
> 
> Or this patch to solve this in one go...

I don't think this is a solution. Offloading distributions
responsibility to the upstream projects is almost never a good idea.
While you fix a problem for one distro, you cause a problem in another.

> 
> >>> Forcing enabling a filesystem configuration because a specific block
> >>> feature is enabled doesn't sound the right thing to do IMHO.
> >>
> >> Well, it is nicer for the average user who may not be aware that this feature
> >> is needed for zoned block devices.
> >
> > But for the average user, wouldn't be the distribution's responsibility
> > to actually properly enable/disable the correct configuration?
> > I don't see average users building their own kernel, even more actually
> > using host-managed/host-aware disks.
> 
> Yes, getting XFS_RT enabled through distros is the other solution. A lot more
> painful though.

I consider removing the freedom of distributions to choose what they
want/not want to enable painful. With this patch, any distribution that
wants to not enable XFS_RT with zoned devices will need to custom patch
their kernels, and this create a lot of technical debt, specially for
non-mainstream distributions which don't have enough people working on
them.

Maintaining a kernel config file is way less complicated than keeping a
stack of custom patches, and ensuring the same patches will be available
on the next releases.

Yes, might not be the best scenario to go and convince your distro of
choice to enable this or that kernel option, but then offloading this to
kernel maintainers just because your distro doesn't do it is not the
right thing to do.


> 
> >
> >> mkfs.xfs will not complain and format an SMR
> >> HDD even if XFS_RT is disabled.
> >
> > Well, sure, you can't tie the disk to a single machine/kernel.
> >
> >> But then mount will fail with a message that
> >> the average user will have a hard time understanding.
> >
> > Then perhaps the right thing to do is fix the message?
> 
> Sure, that can be done.
> 
> >> This is the goal of this
> >> patch: making life easier for the user by ensuring that features that are
> >> needed to use XFS on zoned storage are all present, if zoned storage is
> >> supported by the kernel.
> >
> > I see, but this is also tying XFS_RT with BLK_DEV_ZONED, which is my
> > concern here. Users (read Distros) might not actually want to have
> > XFS_RT enabled even if they do have BLK_DEV_ZONED.
> 
> Hmmm... which would be a problem. But I guess I have to take that to the distros ?
> 
> So is it a hard no for the XFS_RT automatic select ?

I'm always fine changing my mind (even if I need to knock my head on
the desk a few times before). But unless we have a good reason to remove
distributions the possibility to have zoned devices enabled without
XFS_RT, in lieu of distributions that don't want to bother maintaining
their configuration files, this is a hard no from me.

And I don't consider "changing the config file of a distribution is
painful" as a good reason.

Carlos

> 
> At the very least, I will send a v2 with the KConfig help update only to
> clarify the XFS_RT requirement for zoned devices.
> 
> >>>> For these
> >>>> +	  devices, the realtime subvolume must be backed by a zoned block
> >>>> +	  device and a regular block device used as the main device (for
> >>>> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
> >>>> +	  containing conventional zones at the beginning of its address space,
> >>>> +	  XFS will use the disk conventional zones as the main device and the
> >>>> +	  remaining sequential write required zones as the backing storage for
> >>>> +	  the realtime subvolume.
> >>>> +
> >>>>  	  See the xfs man page in section 5 for additional information.
> >>>
> >>> 		Does it? Only section I see mentions of zoned storage is
> >>> 		the mkfs man page. Am I missing something?
> >>
> >> I have not changed this line. It was there and I kept it as-is.
> >> Checking xfsprogs v6.15 man pages, at least mkfs.xfs page is a little light on
> >> comments about zoned block device support. Will improve that there.
> >
> > You didn't change, but the overall context that line referred to did so
> > it got misleading IMHO, reason I pointed it out.
> 
> OK. I can keep it in the same place it was and add the zoned device
> clarification after it.
> 
> 
> 
> --
> Damien Le Moal
> Western Digital Research
> 
