Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A11DDC2B
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766197362; cv=none; b=gxG9RdR3oXoVQDBpx4RN9CxESpSuMoAe1MrwclyihlrkLD4IqTwJT1urgfcQ8zBxjb4HaZJx86pX24FbIdifzpXwXfSQdL99NnDVwXCc2S+Z9lJ5z5bEO+pE0EbJrngfu2+Eru5CB8w4LXS3WWKhTpW4d95wRmaTXgkijyLnabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766197362; c=relaxed/simple;
	bh=0CIH+imkM8o5LL7CjMAj664ZKBlbqhexc0tFE/bViPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G0C3RCdTbSvhtDYxCDqQ5IfhJM8G5OFVkuPMnezkjQV9j56HRhd5dHpXJxT5xP7d5f4PGIYnjc3bzmY7w+mUFSgFIrgAAfHXfg60pLS13QaLmLuV5DUp8tMH2lOG23VVMl+AYu6bqUxw240YepaompYtkPyWxqpoE3+VlwM4Wrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1/WCCSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1/WCCSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91EFC4CEF1;
	Sat, 20 Dec 2025 02:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766197361;
	bh=0CIH+imkM8o5LL7CjMAj664ZKBlbqhexc0tFE/bViPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P1/WCCSQ8ch0w3ToBGM2W7LPY3MtoFFEFa+KW2/PK5DRkMT33wQFuuhCRSWiZWsOY
	 +ztcEl/fyCtkcgdjRkEy/V9vr6gndIioJGSrf7X7xdxqx8Po1NTI+lGKbBVb1l5Vpt
	 d5yWA0OsVpieyPRWyDFAHln1o7FV3P9Bw0jNFg5lUFNgrhuRQLwzOBkc3Ao6u8CU5E
	 zIFZ4Gt5GVOQ46hbdQEiZtxkzKc+S6USwbMGU+3BdOKMoZoHUG6fbm50CERH6h0EgK
	 zy45PfErnmKDdmv4GFWsWdtIGZfeBnWCN5Bg3K+gw1SDuQj78Jm35S0G66DVNUgJNc
	 oNTNMrR1CoITg==
Message-ID: <6ad1f5c5-ef36-4125-8a4b-61f7b7b8c1d9@kernel.org>
Date: Sat, 20 Dec 2025 11:22:34 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Enable cached zone report
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
References: <20251219093810.540437-1-dlemoal@kernel.org>
 <20251219235602.GG7725@frogsfrogsfrogs>
 <1f635a17-adf3-424f-b504-71a97562d226@kernel.org>
 <20251220015404.GB1390736@frogsfrogsfrogs>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251220015404.GB1390736@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/20/25 10:54, Darrick J. Wong wrote:
> On Sat, Dec 20, 2025 at 09:00:10AM +0900, Damien Le Moal wrote:
>> On 12/20/25 08:56, Darrick J. Wong wrote:
>>> On Fri, Dec 19, 2025 at 06:38:07PM +0900, Damien Le Moal wrote:
>>>> Enable cached zone report to speed up mkfs and repair on a zoned block
>>>> device (e.g. an SMR disk). Cached zone report support was introduced in
>>>> the kernel with version 6.19-rc1.  This was co-developped with
>>>> Christoph.
>>>
>>> Just out of curiosity, do you see any xfsprogs build problems with
>>> BLK_ZONE_COND_ACTIVE if the kernel headers are from 6.18?
>>
>> Nope, I do not, at least not with my Fedora 6.17.12 headers (which do not have
>> BLK_ZONE_COND_ACTIVE defined). Do you see any problem ?
> 
> I see it, but only if I ./tools/libxfs-apply the 6.19-rc libxfs/ changes
> to the xfsprogs codebase first.  I came up with an ugly workaround:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=libxfs-6.19-sync&id=a448911c20ec0d3482361b2287266abd76d9f979
> 
> that sloppily #defines it if it doesn't exist.

Arg. Of course ! I do not see the issue because cached zone report is not
supported on my setup where it is not defined.

OK. Adding that definition to libfrog/zones.h (new file). This defines the new
helper xfrog_report_zones(). Or should that go into libxfs ?
Or maybe libxfs/xfs_zones.h should include libfrog/zones.h.

> 
>>>
>>>> Darrick,
>>>>
>>>> It may be cleaner to have a common report zones helper instead of
>>>> repating the same ioctl pattern in mkfs/xfs_mkfs.c and repair/zoned.c.
>>>> However, I am not sure where to place such helper. In libxfs/ or in
>>>> libfrog/ ? Please advise.
>>>
>>> libfrog/, please.
>>
>> OK. Will add a helper there then. libfrog/zone.c is OK ?
> 
> Yep.
> 
> --D
> 
>> -- 
>> Damien Le Moal
>> Western Digital Research


-- 
Damien Le Moal
Western Digital Research
