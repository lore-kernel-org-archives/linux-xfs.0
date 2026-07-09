Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD6E3DD526
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783583779; cv=none; b=cfQWSbnsM6lkR3hgSjtlYUx1JXKR5F5DQJor5UdJX7zgKz4GJmEpTJjmvwcQs/fbOMcrzUitT6N3u7rcO4T+uxflnHzonRwvBzypWTxKP/1Z335h9qxf94Ot3Gs45tcd30xKCyuvPw9xCpB/0QLxtSKpNDEO0AO3GHJ1F5lItfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783583779; c=relaxed/simple;
	bh=ZyPkeEjAPTZKBAM2+pdZUg0hudEnqsBm0FoXOORISNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGQy8CmcxHeqT4odthNJcuFiN7rxlhXOeH2CBtk5vgKhWs8ECs0/pibOOsgzTF630yA1sACUntz1hC4Nt0b4EisANlos2PeJY0zsZycNFRNTA41bsBei+OPmEdp3l6xfGYK9EgFIX6+GWoukGLKQQKpZB62VFsFlTox1TVSLKbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XWV/3fjI; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XWV/3fjI"
Message-ID: <3bec72fe-c096-4db8-b33c-50846de16f42@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783583775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dxjNhaSxR077DomcJkxIfl4/gzaGKkc6ytKBIS5SPmw=;
	b=XWV/3fjIqN2XHVXej6xwmxBYJZxJGGhuzilD7lIsPi4i3KFUht2X45k74WToi1+AO2ZTbM
	JPXY8d+aGdYPngnqFPHZcJNZnYFoXdTnDCdriH2xp1Iub9kTkKqWVU1L7qnl0q/UZB799y
	94kzwgCir3XBZd6Uik5VQervFkAYB9s=
Date: Thu, 9 Jul 2026 09:55:53 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>, zlang@redhat.com,
 fstests@vger.kernel.org, djwong@kernel.org, yi.zhang@huawei.com,
 linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20260703125422.3110429-1-p.raghav@samsung.com>
 <ca21b3c4-e1df-4ba7-8e9c-5d221337c86b@huaweicloud.com>
 <20260707051015.GA13010@lst.de>
 <e52af771-da66-48e3-a6a0-b0c31dc8b3a9@huaweicloud.com>
 <aafea4b8-8e52-421f-92d6-e15bd7767168@linux.dev>
 <82e2b175-7961-4133-94f6-209f97cbafe7@huaweicloud.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <82e2b175-7961-4133-94f6-209f97cbafe7@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


>>
>> I had a similar question as Christoph. But I will include dirty unwritten
>> test case as well, as ext4 impl may slightly differ.
>>
>> Thanks for the point about the FIEMAP. I will change it to use filefrag.
>>
>> I will send the patches soon.
> 
> Thank you!
> 
>>
>> Btw, I tested ext4 and it failed the test. I assume there is a fix on the way for ext4? And did you
>> also test this for bigalloc configuration? I ran into some issues with bigrtalloc (alloc size >
>> block size). I am wondering if you hit a similar issue in ext4 for biglloc configs.
>>
> 
> Yes, there are issues in the current ext4 that need to be fixed, and I
> have already sent out the fixed patch set [1]. I have run several
> rounds of this test on my machine, including bigalloc scenarios, and
> everything looks fine by now.
> 
> After applying this patch set, does the issue you encountered still
> exist?
> 

I still haven't tried your patchset. I tried running this test on upstream 
kernel and noticed a failure. Then when I saw the ext4 mailing list and there 
were some discussion already ongoing regarding this issue.

I can give your patchset a try as well :)

--
Pankaj

