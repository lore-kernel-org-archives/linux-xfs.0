Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0CB257459
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199592; cv=none; b=iHDqd2nwDXgyXL2RIj8R6TZuH3PoVI9APDlk5UcVe87Rg1de/unkEWistdZFOluvH7Vi6cO7ltw/dq210R88gNFj45Zmgyl09hEoAdr53a00qI2RuXRLL8CN966dWLTaQ0z6i/tD52iR8jaHpg/vgIlk8T++tY8Ezhy4vhatRHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199592; c=relaxed/simple;
	bh=yonR0CRx6Byj3JUwH8rvGYF40XkAVmSGIzX4bCxiZ28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KPloo3tyz4j9mAO+90Eg+ZABR/jYbrADSJTNluguZyqU43GPl/0Xzt41vC1gYmWAagBTYfqgO+1Slq6WeFnpUwBstDYBUuY+LYUHd4jw7qO+rQwBcOVFNsFP3qRFtGot5Xi/mH+CDZj1nisOiUtX+e6vnuyDJoboZkijmG+e0Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pRJ9hRrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pRJ9hRrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F8FC116C6;
	Sat, 20 Dec 2025 02:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199590;
	bh=yonR0CRx6Byj3JUwH8rvGYF40XkAVmSGIzX4bCxiZ28=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pRJ9hRrO6rGvvQYI8zx+rKQ0drGVISyL16MnJgbBDne8sBXNXRFrjeZhmCd0PTTfP
	 2TtPUETCHmRfv38OYq96KHkS1f0sGd/ckWaZ85JDbxKsH9oGtnPGhA8Y4mJa68QqhN
	 exgwvQCOePAvuQ2Uj8EDF9xu9u97R8XqVUJoa30Gm4hJdrALVPAQB3GSWV9QzrUPVo
	 ZV0yClHx3f38LP6sSGipmUljqN36uKAOVCwCMUtXgoKlyrqGeedo5NyOlU493dXku8
	 lcr1GLGMSlF3P83e1TYl8y0Wdmgi3nPQWDIo6ZsY33ovLcYQFnK6QB0amABmJzcDQx
	 ezDWAVCdQPCMA==
Message-ID: <a2f5f0ff-6fe8-44c6-813b-ebc162b4f025@kernel.org>
Date: Sat, 20 Dec 2025 11:59:48 +0900
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

I addressed this in the v3 series I just posted. Much cleaner I think with the
common xfrog_report_zones() helper.

I am not used to xfsprogs code style though, so please review !

Cheers.

-- 
Damien Le Moal
Western Digital Research
