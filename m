Received: from mta1.migadu.com (out-77.mta1.migadu.com [95.215.58.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5139A2D94B5
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363307; cv=none; b=lc/T52biN5d3LHlT+x0kb0h0QfnyUYCLlBgq+vT7ilX0FLFyc09tdfzRbFxIwNs3/poSbDpynu485MEY3tqpte9qzmLHrkcb8H6WQwkx8ATegec3LFh98g9HHKWO/9p7Lr0YKIILJtPw2ZFTgVYJ3iiKPeyhgSIUvXsxwu9PMDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363307; c=relaxed/simple;
	bh=YcWOLss1tLHPyUMwSuqRHic7aNDGFCFnwIVK2MaoRw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmB9wW1afAIw78MgusxkDnWmjYodSTSPWUV3n8UBjUogukrhergSY1fQxwYe4hd2ODkM8BTOC6BJqijd0bnakpGGra3zjSe2l/37UN9q3ry/4ephnP/SUTBY8MYxiee/1oj5Yh9H84B3HuW6g1lP/NeQQE5BxK4VYGwJm+VNscw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ge+HIIGq; arc=none smtp.client-ip=95.215.58.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ge+HIIGq"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YcWOLss1tLHPyUMwSuqRHic7aNDGFCFnwIVK2MaoRw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363295; v=1; x=1788968095;
 b=ge+HIIGqk+eTvCGIGbneI0yIx5epzInrh3ZNwgw3LwBijyGv0B0kwELBGw8VH5kln9Jkk6FI
 aWEYb8YQEP0IGHtkGyIjJ0RP5xwxWA0S7AUPaW1PlqeX07fdGCHuiOMwAD+VmQmfw7BHNMcP8WC
 RLN7oPYevk8U1ZE32pe30PT0=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id efcc2935034d3f1b;
	Wed, 02 Sep 2026 15:34:54 +0000
X-Mizu-Trace-ID: efcc2935034d3f1b
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:34:53 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
Message-ID: <aphCBeqTnKEpTCuF@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>

On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
> Now that kswapd can no longer reach filesystem writeback (pageout()
> returns PAGE_ACTIVATE for non-shmem, non-anon folios), any PF_MEMALLOC
> context in iomap_writepages() indicates a VM regression, simplify
> the check by removing PF_KSWAPD.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
