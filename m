Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CF3189
	for <linux-xfs@vger.kernel.org>; Wed,  6 Aug 2025 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754473071; cv=none; b=qFtyeuPK0k1gU5w074hYfWG6WcyD2i+TTZnrseQ7hDJuTfx8mcuX8/6cHwASiZolHOByLGm/WYSryElVBKIsPT4aAOQilwJUk5SMPzMofGEl4S2Rv9LFr2QXUG7LafmDHOhOL/b8cIcQArcZh1uFl90wduxvsb3dMV4rcWarJJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754473071; c=relaxed/simple;
	bh=/QOMlPnbk6CLMhtA3BOpc4QLVnj99NjNC+RzzshwEd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HTLTlygfPFoYy1gfdC9s0tjniL+KD85Bb5yapA2bd/U14lw7PibccpEudDuaH1zobbKteQOiRWBQLR3wDNGKbaslzf7Uk5Mlv+Hu3w+KfvwPhT45oLCRTjAFgvUv4Zw6qDADnQOvYftxeTPIzLULOedjDEwZFDt5z45gobuZ3ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZ0o1Iob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZ0o1Iob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5FAC4CEE7;
	Wed,  6 Aug 2025 09:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754473070;
	bh=/QOMlPnbk6CLMhtA3BOpc4QLVnj99NjNC+RzzshwEd0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TZ0o1IobSHozWLrUSQHegVqGGHYBNnwregGyshkhwQOYYJdUSdktBJ5R6uq//V2vH
	 LZADLSVoomQslHgP5UlB20sarXYQTwiTfRtIDZwRFDjFp5iJh4LX5e4okd0g4vG8E4
	 6Vrm68sS0hQaPI+XV0znCEKPNt40MskPnAd67VzCSwJbAybnQtpEnUOc8qHg3m0bne
	 dZ1IlJN5JkQe84+NiJgRIstXzM+q132zXkPrkKOnvKR4vvYBigVUnrJcayTP22tyz4
	 VXenRblNVvF6upydGmBLiVSJsz2bnAViwj6kUQNOpf/OAvwnZOMEtWpGj1SOVXdw71
	 eBC+r5ZQ+8rBw==
Message-ID: <20caa496-4ae5-4c56-98dd-bdf56684acd1@kernel.org>
Date: Wed, 6 Aug 2025 18:35:17 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <h2rtuedwnlr6qawsrx3uz4gtkpfvvlijutv7w3pdtfbvord7cu@cm2zjbu3iir5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/6/25 5:45 PM, Carlos Maiolino wrote:
>> This does not force the user to use XFS_RT, it only makes that feature
>> available for someone wanting to format e.g. an SMR HDD with XFS.
>> I am not sure how "costly" enabling XFS_RT is if it is not used. There is for
>> sure some xfs code size increase, but beside that, is it really an issue ?
> 
> The problem I want to raise is not about code size increase, but about
> having XFS_RT tied with BLK_DEV_ZONED.
> I know it doesn't force users to use XFS_RT, but there are distros out
> there which purposely disables XFS_RT, but at the same time might want
> BLK_DEV_ZONED enabled to use, for example with btrfs.

Yes. Fedora is one. With it, we can use btrfs on zoned devices (and zonefs too)
but not XFS because they do not enable XFS_RT. So I can send a patch for their
kernel config to see if they would accept it. And do the same for many other
distros that have a similar config.

Or this patch to solve this in one go...

>>> Forcing enabling a filesystem configuration because a specific block
>>> feature is enabled doesn't sound the right thing to do IMHO.
>>
>> Well, it is nicer for the average user who may not be aware that this feature
>> is needed for zoned block devices.
> 
> But for the average user, wouldn't be the distribution's responsibility
> to actually properly enable/disable the correct configuration?
> I don't see average users building their own kernel, even more actually
> using host-managed/host-aware disks.

Yes, getting XFS_RT enabled through distros is the other solution. A lot more
painful though.

> 
>> mkfs.xfs will not complain and format an SMR
>> HDD even if XFS_RT is disabled.
> 
> Well, sure, you can't tie the disk to a single machine/kernel.
> 
>> But then mount will fail with a message that
>> the average user will have a hard time understanding.
> 
> Then perhaps the right thing to do is fix the message?

Sure, that can be done.

>> This is the goal of this
>> patch: making life easier for the user by ensuring that features that are
>> needed to use XFS on zoned storage are all present, if zoned storage is
>> supported by the kernel.
> 
> I see, but this is also tying XFS_RT with BLK_DEV_ZONED, which is my
> concern here. Users (read Distros) might not actually want to have
> XFS_RT enabled even if they do have BLK_DEV_ZONED.

Hmmm... which would be a problem. But I guess I have to take that to the distros ?

So is it a hard no for the XFS_RT automatic select ?

At the very least, I will send a v2 with the KConfig help update only to
clarify the XFS_RT requirement for zoned devices.

>>>> For these
>>>> +	  devices, the realtime subvolume must be backed by a zoned block
>>>> +	  device and a regular block device used as the main device (for
>>>> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
>>>> +	  containing conventional zones at the beginning of its address space,
>>>> +	  XFS will use the disk conventional zones as the main device and the
>>>> +	  remaining sequential write required zones as the backing storage for
>>>> +	  the realtime subvolume.
>>>> +
>>>>  	  See the xfs man page in section 5 for additional information.
>>>
>>> 		Does it? Only section I see mentions of zoned storage is
>>> 		the mkfs man page. Am I missing something?
>>
>> I have not changed this line. It was there and I kept it as-is.
>> Checking xfsprogs v6.15 man pages, at least mkfs.xfs page is a little light on
>> comments about zoned block device support. Will improve that there.
> 
> You didn't change, but the overall context that line referred to did so
> it got misleading IMHO, reason I pointed it out.

OK. I can keep it in the same place it was and add the zoned device
clarification after it.



-- 
Damien Le Moal
Western Digital Research
