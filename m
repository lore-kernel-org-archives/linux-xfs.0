Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D07430E859
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783956915; cv=none; b=a+gxS+dWVxLiPwqWCy4Vyq6GCqNJwzby+Rrh7PzEdWVADEX+RrDKn7fkr3Znuh2KYkugBKun/OO4hf8cAUdTMUq4RaWnuoI0tpyFFQNod4sqIjGAWJ38Nmf+m/yLRDO9EU+MhpTxwW2d8Cc0bn9ajlO6mCO2aV9xiqXVKXdplpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783956915; c=relaxed/simple;
	bh=QhWbD0mpdRPVffuWg/7EtF1BbJoD3q+2pC44Nk7TpzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pedm+SVgiJA04r1XRl+s6ETZovNOvLT7rWTC+R+bfEq9vbNmMjDzG+Sf8f0UfM7OeefZ05nOqnuKoU1cuUyczLU/XsACvKvYv7uTlHEPVRisXuJrseJ0W0ncpXvM9q2iHzpsYmPLfWZK/XRAi4ytL183GLrFzG9FLWV22uCnEH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Wx3B/cbR; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Wx3B/cbR"
Message-ID: <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783956898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b84zbAj0IOT/rrLgo+xScwsyz3Svgs2ZwEIPB28c6z4=;
	b=Wx3B/cbRzN05smJAh6GSYPpBR4jesd05hADHLSXO/xF0g529OR0897flkhNFWq4Y2Vd3av
	gjh3BfX3OYXR3quWsagN0aQy3VM21xnbUubOHy/lCfIwLxLDA1S5Yl6ng0j9DToARLgiF3
	Voq/CzzM0ypaW293o8LK/soo29WJzOM=
Date: Mon, 13 Jul 2026 16:34:52 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Qi Zheng <qi.zheng@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 13/07/2026 14:12, Qi Zheng wrote:
> Hi Usama,
> 
> On 6/9/26 8:30 PM, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
> 
> This makes sense for now, but how should we handle this if these
> shrinkers are made memcg-aware in the future?
> 
> I've recently been working on making the shmem huge shrinker
> memcg-aware, but noticed my changes broke after rebasing onto the latest
> tree, which led me to this patch.
> 
> As for the shmem huge shrinker, I can work around this limitation by
> making it a separate shrinker. But this feels more like an overall
> design decision, effectively meaning that all nr_cached_objects are
> precluded from being memcg-aware.
> 
> Thanks,
> Qi
> 


Hi Qi,

Thanks for raising this. I think the alternative is what I mentioned in
https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
move this down to the fs own callbacks instead of here. Would that
be better?

Thanks,
Usama
