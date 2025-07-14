Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E68C17B50F;
	Mon, 14 Jul 2025 06:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752472861; cv=none; b=qfHize+e7f2E3VDW54ZLcHyVQlGHXuKW+oBM5uLy5lm9NSv+zEmEshXLtlaefk1Ifc7WgCVvM/0Cy9F6nzFyg09ONwzeLkKCTD5AWGf/l78A3sBPRWMJJG+4hxkQdiDGTvMjUYWT/sxWvZDmh2wHEOfiOeCX8mYdPl46wyM8HzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752472861; c=relaxed/simple;
	bh=kz8KEBKaTADqX8pyaKdMIgOxofcFmPKPOzLjzYl830s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfTLWz3Oxt+aL0BJKFwgUAWwX70C8ZJIDI5iPK6zpvCJvdePW+AGsHkAKLdr28aeEDk1BxPeawmG+cydaDUB7FufGKVjqgDpSmNEqKR/EcEwIHIYhodrWduQlj4KP3okwz8AO4FtMtyo8g1R6CsmGD2OfsmUV82L0ZTbTL1/3UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHHcNaRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHHcNaRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CE2C4CEED;
	Mon, 14 Jul 2025 06:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752472860;
	bh=kz8KEBKaTADqX8pyaKdMIgOxofcFmPKPOzLjzYl830s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BHHcNaRrqwmxcZ1VKfIUcsuZ380u82ru/uaXdmGX113nT53L2CrZ+ah5GeKRs4EZh
	 x0UfjHP121iOiQ5j6K6/u4JqVWoO4RSmJurwDuwCcMgVmg5xFxAb92BYyRFY/YGRIs
	 JJZ6/b2KmFVZRoZrtDnsqO/9E3TenaIfAzx0vycKomQ3mhlMn3MMt4REr7/sFbwvKW
	 h/PaCHHnjIOYkMtmD2jvSDXDMiYG5bV2n30LGC0GJGZCtPbmY7pfQf0nCT6eZJIqap
	 BNF+xw9QXwxjuZDHLvV8pZ41vQ3s6gh2Z7EdeVv2/Dfpzn6DSq2GfVqUbsSyzBLPJq
	 SZCLma0v1F7iw==
Message-ID: <c71ce330-d7b5-45ea-ba46-97598516e9fc@kernel.org>
Date: Mon, 14 Jul 2025 15:00:57 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com,
 nilay@linux.ibm.com, axboe@kernel.dk, cem@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
 ojaswin@linux.ibm.com, martin.petersen@oracle.com,
 akpm@linux-foundation.org, linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
 <20250714055338.GA13470@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250714055338.GA13470@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/07/14 14:53, Christoph Hellwig wrote:
> On Fri, Jul 11, 2025 at 05:44:26PM +0900, Damien Le Moal wrote:
>> On 7/11/25 5:09 PM, John Garry wrote:
>>> This value in io_min is used to configure any atomic write limit for the
>>> stacked device. The idea is that the atomic write unit max is a
>>> power-of-2 factor of the stripe size, and the stripe size is available
>>> in io_min.
>>>
>>> Using io_min causes issues, as:
>>> a. it may be mutated
>>> b. the check for io_min being set for determining if we are dealing with
>>> a striped device is hard to get right, as reported in [0].
>>>
>>> This series now sets chunk_sectors limit to share stripe size.
>>
>> Hmm... chunk_sectors for a zoned device is the zone size. So is this all safe
>> if we are dealing with a zoned block device that also supports atomic writes ?
> 
> Btw, I wonder if it's time to decouple the zone size from the chunk
> size eventually.  It seems like a nice little hack, but with things
> like parity raid for zoned devices now showing up at least in academia,
> and nvme devices reporting chunk sizes the overload might not be that
> good any more.

Agreed, it would be nice to clean that up. BUT, the chunk_sectors sysfs
attribute file is reporting the zone size today. Changing that may break
applications. So I am not sure if we can actually do that, unless the sysfs
interface is considered as "unstable" ?

> 
>> Not that I know of any such device, but better be safe, so maybe for now
>> do not enable atomic write support on zoned devices ?
> 
> How would atomic writes make sense for zone devices?  Because all writes
> up to the reported write pointer must be valid, there usual checks for
> partial updates a lacking, so the only use would be to figure out if a
> write got truncated.  At least for file systems we detects this using the
> fs metadata that must be written on I/O completion anyway, so the only
> user would be an application with some sort of speculative writes that
> can't detect partial writes. Which sounds rather fringe and dangerous.

The only thing I can think of which would make sense is to avoid torn writes
with SAS drives. But in itself, that is extremely niche.

> 
> Now we should be able to implement the software atomic writes pretty
> easily for zoned XFS, and funnily they might actually be slightly faster
> than normal writes due to the transaction batching.  Now that we're
> getting reasonable test coverage we should be able to give it a spin, but
> I have a few too many things on my plate at the moment.


-- 
Damien Le Moal
Western Digital Research
