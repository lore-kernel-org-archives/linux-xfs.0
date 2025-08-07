Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF79F248F57
	for <linux-xfs@vger.kernel.org>; Thu,  7 Aug 2025 07:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754552440; cv=none; b=WlamJUgGCMEvXus0h352qqvOZe5TLSkjvouU87ktp6xlRO0FHpFwZtoS3AGwhE6ISn7uMTaO0YXzClaa7RaVMs0E4tqiIijBEPrDNdQ58BTzLXzN3avuMxa4q4pqjlIoK1aWwizcWyWFyBLQUv7f/ZOPtN5VOIRJ3M9AUF+hODY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754552440; c=relaxed/simple;
	bh=RRHHptz9bB+3mpLjYsAMa1hIpjHUleB85Zz2r6NOj6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QwZ/KX2gLSNC7ETd1Wn14AZvbB7LvvAIOW69IUH6KOLPnOK++HisBTjq4Pr20yQ2ZsAQ9FSRfuwuCrY3nEsKZwbwH+o4Nt1oM3rwybN5f34PUIKwecNoqjRJghKOF4EUWRvpRgvBWNPocj9o1/Kut+5Yrk9OFqrNr+3wK01KE54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gR9F2hZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gR9F2hZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D368BC4CEED;
	Thu,  7 Aug 2025 07:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754552440;
	bh=RRHHptz9bB+3mpLjYsAMa1hIpjHUleB85Zz2r6NOj6w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gR9F2hZL52b/ajDrqsKoe3ukT+I/gvZl3G+0SGMNgLVKzsHFY55awN6veL7seNn53
	 8jdfPfUO2LUUzYov0IKM6tR3dgnhp2HfvmsgfdiYqVwacRaVrIvv0MpZYe4Gy+bWmp
	 UI9n6ldjcswRAbtUbxG0uegUM6ZIXv0WhHVXYOvpeC8NXiGCOUzcgcnDpxEdn7SN/L
	 oY+lh9+ysfQJdcnSFxlXTV0hmELrl06df3+RP30J6T9IuyF6pWOn3Ay5ZLy12HSNzA
	 qqgS52ZOEcVgY/eOBshI1DwRmI6t+ZkmO1bpozuOyLPlFieXzRE2KC+QqYn2dW4cLc
	 xzXst59BmrTSw==
Message-ID: <055a1f0e-75da-4907-98eb-56e12dbbb687@kernel.org>
Date: Thu, 7 Aug 2025 16:40:38 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
 <IFqtoM3P4UP6lDAVnaetg8PD6iHVwJagb5GWUDGNyKYfziLc4ww2iM-CgpCoxACHecTMWYZridqsB1Tewz_EAQ==@protonmail.internalid>
 <756f897c-37d3-47ea-8026-14e21ec3bb1a@kernel.org>
 <h2rtuedwnlr6qawsrx3uz4gtkpfvvlijutv7w3pdtfbvord7cu@cm2zjbu3iir5>
 <AtIY9HhAD-nEQAt0SR5iEoz5rK-63Wlfp8zr4MqXLeJWOmgDPopFP741ObEfCY7epfu86-UCyQRHwZ6rNAIq_w==@protonmail.internalid>
 <20caa496-4ae5-4c56-98dd-bdf56684acd1@kernel.org>
 <rmg7ftcpgh3nqpw4ljpiyawivgl4bg5bz2n7bhxswaafaqcmqw@rvfajjqxpvl2>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <rmg7ftcpgh3nqpw4ljpiyawivgl4bg5bz2n7bhxswaafaqcmqw@rvfajjqxpvl2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/7/25 16:33, Carlos Maiolino wrote:
>>> The problem I want to raise is not about code size increase, but about
>>> having XFS_RT tied with BLK_DEV_ZONED.
>>> I know it doesn't force users to use XFS_RT, but there are distros out
>>> there which purposely disables XFS_RT, but at the same time might want
>>> BLK_DEV_ZONED enabled to use, for example with btrfs.
>>
>> Yes. Fedora is one. With it, we can use btrfs on zoned devices (and zonefs too)
>> but not XFS because they do not enable XFS_RT.
> 
> $ grep XFS_RT /boot/config-6.15.8-200.fc42.x86_64
> CONFIG_XFS_RT=y
> 
> Fedora do Enable XFS_RT :-)

Weird. Checked on my end and yes, it is enabled. Last time I checked, it was
not... Maybe I made a mistake when checking.

>> So I can send a patch for their
>> kernel config to see if they would accept it. And do the same for many other
>> distros that have a similar config.
>>
>> Or this patch to solve this in one go...
> 
> I don't think this is a solution. Offloading distributions
> responsibility to the upstream projects is almost never a good idea.
> While you fix a problem for one distro, you cause a problem in another.

OK.

> 
>>
>>>>> Forcing enabling a filesystem configuration because a specific block
>>>>> feature is enabled doesn't sound the right thing to do IMHO.
>>>>
>>>> Well, it is nicer for the average user who may not be aware that this feature
>>>> is needed for zoned block devices.
>>>
>>> But for the average user, wouldn't be the distribution's responsibility
>>> to actually properly enable/disable the correct configuration?
>>> I don't see average users building their own kernel, even more actually
>>> using host-managed/host-aware disks.
>>
>> Yes, getting XFS_RT enabled through distros is the other solution. A lot more
>> painful though.
> 
> I consider removing the freedom of distributions to choose what they
> want/not want to enable painful. With this patch, any distribution that
> wants to not enable XFS_RT with zoned devices will need to custom patch
> their kernels, and this create a lot of technical debt, specially for
> non-mainstream distributions which don't have enough people working on
> them.
> 
> Maintaining a kernel config file is way less complicated than keeping a
> stack of custom patches, and ensuring the same patches will be available
> on the next releases.
> 
> Yes, might not be the best scenario to go and convince your distro of
> choice to enable this or that kernel option, but then offloading this to
> kernel maintainers just because your distro doesn't do it is not the
> right thing to do.

Understood.

>> So is it a hard no for the XFS_RT automatic select ?
> 
> I'm always fine changing my mind (even if I need to knock my head on
> the desk a few times before). But unless we have a good reason to remove
> distributions the possibility to have zoned devices enabled without
> XFS_RT, in lieu of distributions that don't want to bother maintaining
> their configuration files, this is a hard no from me.
> 
> And I don't consider "changing the config file of a distribution is
> painful" as a good reason.

I understand.

-- 
Damien Le Moal
Western Digital Research
