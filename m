Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914DA363C6F
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 10:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026420; cv=none; b=jCPr3nObbu5UiJBL/9AsNYlj/0ZwohzIhqK52ani5yWPeREnLshMA9RXnfl6glyOW4ZWJzGu2z75wEKYjGEJYBRRkET3qV+4zU70YW6QAsx1lRdibKYobo3peOtyqTMqbAajpSxHqoMAysw4x6fjbWDTmz7Hjtv87TusdOkrGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026420; c=relaxed/simple;
	bh=yk2woOizaCDdz0CV/MS5s+HZL/VFzG7Il8H5yT1RHgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F3fBliuoE/w3rvZinvoYZZ8b0VriPtTHDDJIpjguO3PJz+cmi2D84vcyOo3ZZI5uFKM0Cg8ESCVHRxSeNhRDjWPbBobL/tOhw6AUpEyBnuuxvy8bGB4M+FxfRxezo7NsTBl5VQwiq1Eu/KwTvlMrrz/pwnOZHlcxHV5E7WLYOxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hr8CWtXv; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hr8CWtXv"
Message-ID: <3f87f6af-3952-4c16-83fa-9fb77085a285@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784026406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/LDmA+4RVpARa99Ab+t/25jrDC9AwuxQ6Gu81nLkhgA=;
	b=Hr8CWtXvQzP2VMAmcJlnKckqOOTkk3iGdGQicebeUy0g3l/oGG59Ca4fqkEdungTTaa/3y
	baGS7gF9L5q6kyZ1BETnjjODc9EtUAVdVkjDAmOhhK8BYUUSrIPf3OPRXSMx5QH7UdyR7s
	rr088010fIg34Lex3w5OKYga2sdvUUo=
Date: Tue, 14 Jul 2026 18:52:49 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
References: <20260714101740.1270419-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260714101740.1270419-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/14/26 6:17 PM, Usama Arif wrote:
> On Tue, 14 Jul 2026 10:09:26 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Hi Usama,
>>
>> On 7/13/26 11:34 PM, Usama Arif wrote:
>>>
>>>
>>> On 13/07/2026 14:12, Qi Zheng wrote:
>>>> Hi Usama,
>>>>
>>>> On 6/9/26 8:30 PM, Usama Arif wrote:
>>>>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>>>>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>>>>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>>>>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>>>>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>>>>> None of them filter by sc->memcg.
>>>>
>>>> This makes sense for now, but how should we handle this if these
>>>> shrinkers are made memcg-aware in the future?
>>>>
>>>> I've recently been working on making the shmem huge shrinker
>>>> memcg-aware, but noticed my changes broke after rebasing onto the latest
>>>> tree, which led me to this patch.
>>>>
>>>> As for the shmem huge shrinker, I can work around this limitation by
>>>> making it a separate shrinker. But this feels more like an overall
>>>> design decision, effectively meaning that all nr_cached_objects are
>>>> precluded from being memcg-aware.
>>>>
>>>> Thanks,
>>>> Qi
>>>>
>>>
>>>
>>> Hi Qi,
>>>
>>> Thanks for raising this. I think the alternative is what I mentioned in
>>> https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
>>> move this down to the fs own callbacks instead of here. Would that
>>> be better?
>>
>> Yes, I think this is a better approach.
>>
>> Later on, shrinkers that are converted to be memcg-aware can lift this
>> restriction themselves.
>>
>> Thanks,
>> Qi
> 
> Thanks Qi, I have sent a patch to push it down to filesystems in [1].
> No functional change inteneded in there. You would have to rebase your
> patch on top of that one and remove my code in shmem specifically.

Thanks! I will rebase my patch once your patch is merged into
linux-next.

> 
> [1] https://lore.kernel.org/all/20260714101454.1202449-1-usama.arif@linux.dev/
> 
>>
>>>
>>> Thanks,
>>> Usama
>>
>>

