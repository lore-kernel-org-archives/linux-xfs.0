Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2121837DEB5
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 02:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783995015; cv=none; b=Pac0pKSPaBEasZ6m0n2FWnbiv0QZg2O0sa2TA3IlcGaIimsh9NNvlPb4krhF7RPo5bWsN3KR8Yzy5tRu5r7cMzIi/mxkfTbufu7b2WlbW3xcCXqfDsduLksHQakNIJEyqJFDTloa0CDngGWB0shxI+ySanTOQ72Ph2L7GanDxrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783995015; c=relaxed/simple;
	bh=b1VaFDW/vJ6wqPMInCCKdkHSqzW6apkl8NBOxKd9a6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feWExf1IDKNW0gOSnK0C5m5gJx0cTeRzZwOx3bY92f0KOXWvg9n5eLUqOGhKyRQ6vVpfzLaOkZ34W5HgKZNezB7TlNZ74TmMuzg+QQ+Vkk58EZGpmPiB/u3/Xt9RtdIbEy2+PC/nLbHV/RRX5CpeIZMUZn4V8qa8Di93tgX78V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pOTIrFDv; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pOTIrFDv"
Message-ID: <d39f8258-66d5-4ce3-8080-69dc4e2ab197@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783994996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe29OFRdQWxJG3Qa1xsqDVWRullOweBuH8zwQOt47ZU=;
	b=pOTIrFDv42shfz0GqiuCI0/zTy5N++vrqD4K3ff7oohYi86VnOG9XBajIscXw1p+JVsfbO
	0X1+teKSyDwqVoKUvlT4KGfdQHHrzM7cMtJy5FntL1v+23Hjb491lk9x1zAlbb6iHwMMl5
	mAiHSfrz4kFTtflqlSt/VVu2EBvFe+g=
Date: Tue, 14 Jul 2026 10:09:26 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
 <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Usama,

On 7/13/26 11:34 PM, Usama Arif wrote:
> 
> 
> On 13/07/2026 14:12, Qi Zheng wrote:
>> Hi Usama,
>>
>> On 6/9/26 8:30 PM, Usama Arif wrote:
>>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>>> None of them filter by sc->memcg.
>>
>> This makes sense for now, but how should we handle this if these
>> shrinkers are made memcg-aware in the future?
>>
>> I've recently been working on making the shmem huge shrinker
>> memcg-aware, but noticed my changes broke after rebasing onto the latest
>> tree, which led me to this patch.
>>
>> As for the shmem huge shrinker, I can work around this limitation by
>> making it a separate shrinker. But this feels more like an overall
>> design decision, effectively meaning that all nr_cached_objects are
>> precluded from being memcg-aware.
>>
>> Thanks,
>> Qi
>>
> 
> 
> Hi Qi,
> 
> Thanks for raising this. I think the alternative is what I mentioned in
> https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
> move this down to the fs own callbacks instead of here. Would that
> be better?

Yes, I think this is a better approach.

Later on, shrinkers that are converted to be memcg-aware can lift this 
restriction themselves.

Thanks,
Qi

> 
> Thanks,
> Usama

