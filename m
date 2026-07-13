Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAF741CB4B
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948385; cv=none; b=Rl3nE9Kb6x+32aqwuKOXvvSvLYRd3ra92ZKU8Db9jZ08Lbqkc06aqu4IpKMt7dhMMTPMtH37hnmyBzBi2i+j8iNcQp/dCFYL2uGNHxJeHRxlKJocgBis0swtdLS3lp+77/+xdsaLzrAdaE4qNWa5VoEY9maF+MHZdtTxlequ5eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948385; c=relaxed/simple;
	bh=BgJBPkZ5skj/gjGlTheMmG+N99+EZQjf1oVIDsBj5d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgh75n+6yk51UEyzjFO0AAy4rSSlUL1pSso4UK1NYemhToZAvkfGWvKFY/t/x2QESHy7+pxhMJE6Kd90kn0qiWZs2g5ts3ugDl0SbkogIwR+j9qm/sePhT94YcEGvQWzmYp8ftHihcgIRl7X2KWEAuyD8zBPr8Iah1eSXmQDBGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fM+mafjp; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fM+mafjp"
Message-ID: <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783948371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BgJBPkZ5skj/gjGlTheMmG+N99+EZQjf1oVIDsBj5d8=;
	b=fM+mafjpFjm2q6euqpTOUH9LBCGN2HTwkh1zBOC+/9y7KBmXmgV17ArNOvAO6G6YmjYHgO
	Jwwvr/aJHS5zV0U9Zutr3M7/9j4zoA0CcmISGvtC4uhCqDYWybCjWX+bfKh5IYeNdSuJ6I
	dls6V2uYq0RaU21yrr4lRHFpoe4Oa7Y=
Date: Mon, 13 Jul 2026 21:12:38 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Usama,

On 6/9/26 8:30 PM, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.

This makes sense for now, but how should we handle this if these
shrinkers are made memcg-aware in the future?

I've recently been working on making the shmem huge shrinker
memcg-aware, but noticed my changes broke after rebasing onto the latest
tree, which led me to this patch.

As for the shmem huge shrinker, I can work around this limitation by
making it a separate shrinker. But this feels more like an overall
design decision, effectively meaning that all nr_cached_objects are
precluded from being memcg-aware.

Thanks,
Qi

