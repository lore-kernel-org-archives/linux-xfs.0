Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF131DF261
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506960; cv=none; b=pijePghKrceeAvbvv20nq1+cdlf/AlLR5DfaDurVgRRi7jyZSBGzBxT8oP89wj6i14NSVIeqQqHIbk+g/8XgaLsGR1BwAOhYzQvI6XAX3p8JEAC0lA/fqKKX6v606PY8Hi962nOxAb20uEjwSKZ6KRIhTU+ZlLSFcCZNI65hv0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506960; c=relaxed/simple;
	bh=IuKcDRmNJjOX0Gu7WLWpJfPMCTPA3wSdz6nVNsrH0Ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ctjxWqIeUqTdO5A/aY1cZMIfYQr0Jd72Vs3ywo2ikuE9fVC216pu5tWmLklm/rqlsVQ85l7InREzNfXbhrxBb8NSOlN7wP0oLy0+qabxln0659yB014ldkAFwOx57DabCbv3cu04h/+iO9/jE6IFP4ZyLjm8F97rHeLltd4GGYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wglAwgLV; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wglAwgLV"
Message-ID: <0ca84d35-ed3e-4387-9b38-a85d62afa1c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771506956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XH5fl7iX+3zxGYiW2NIAWUiOwf9QcSJJ8gjNCAIjZEM=;
	b=wglAwgLV7Jx9nzN8sg37Pp70S6ukaS23E3AY0d/PUPGCFIkPH+AJsZnQNd3uyGJj4Gm1ll
	x7kmVMG6G2/jMALCfWQGbwYn6FmlCmiBBiybzR22sL+UvSyPOEPTBKy9yyfusDn8P//KK+
	RBeqqJUy2vfVmUZOEF9H1A/jT37RjB8=
Date: Thu, 19 Feb 2026 14:15:54 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: fix potential pointer access race in
 xfs_healthmon_get
To: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, p.raghav@samsung.com
References: <177145925377.401799.10773940743454980308.stgit@frogsfrogsfrogs>
 <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <177145925494.401799.17980890890269795712.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2/19/2026 7:01 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Pankaj Raghav asks about this code in xfs_healthmon_get:
> 
>    hm = mp->m_healthmon;
>    if (hm && !refcount_inc_not_zero(&hm->ref))
>      hm = NULL;
>    rcu_read_unlock();
>    return hm;
> 
> (slightly edited to compress a mailing list thread)
> 
> "Nit: Should we do a READ_ONCE(mp->m_healthmon) here to avoid any
> compiler tricks that can result in an undefined behaviour? I am not sure
> if I am being paranoid here.
> 
> "So this is my understanding: RCU guarantees that we get a valid object
> (actual data of m_healthmon) but does not guarantee the compiler will
> not reread the pointer between checking if hm is !NULL and accessing the
> pointer as we are doing it lockless.
> 
> "So just a barrier() call in rcu_read_lock is enough to make sure this
> doesn't happen and probably adding a READ_ONCE() is not needed?"
> 
> After some initial confusion I concluded that he's correct.  The
> compiler could very well eliminate the hm variable in favor of walking
> the pointers twice, turning the code into:
> 
>    if (mp->m_healthmon && !refcount_inc_not_zero(&mp->m_healthmon->ref))
> 
> If this happens, then xfs_healthmon_detach can sneak in between the
> two sides of the && expression and set mp->m_healthmon to NULL, and
> thereby cause a null pointer dereference crash.  Fix this by using the
> rcu pointer assignment and dereference functions, which ensure that the
> proper reordering barriers are in place.
> 
> Practically speaking, gcc seems to allocate an actual variable for hm
> and only reads mp->m_healthmon once (as intended), but we ought to be
> more explicit about requiring this.
> 
> Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
> Fixes: a48373e7d35a89f6f ("xfs: start creating infrastructure for health monitoring")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Looks good,

Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
Pankaj
