Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097584A8FFE
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363110; cv=none; b=BmeciBFCVnHyMsRB2WOq66PvOkx+ygH3MR4XzxLqkO6neRwkpel2WD0CQ2kHCuXk5/FbPC2tUxQMLum+p40kpxihr82j9B9VBPmH9nhVdOSIpAE8n72cNdp04jWD1mqowbuqPVyEVn4tVl2T6Zj9JMV8C4lLaywoP8Gyelc92sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363110; c=relaxed/simple;
	bh=Hiru+gE5U/tTPNwMNfjfi3EaG0xWxlNq2qi5LPCEe18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I09Vl8NPfgR/GwUB7AAS7VoSzM3ie0+cJOKvyhspEECLEgh/1m45VhaVyQzcvhW+ZjnIpFzzV+k5xxkibK0LO1lnXtGLkqgU3zwmdJ6L1HTzK8hcwNEH7fmBHtzuSozq2rXQTCYKk7SW0OjRkL0Ny5viFVNol75NdTYTfU43gxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=swoV9l9Y; arc=none smtp.client-ip=91.218.175.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="swoV9l9Y"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Hiru+gE5U/tTPNwMNfjfi3EaG0xWxlNq2qi5LPCEe18=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363105; v=1; x=1788967905;
 b=swoV9l9Yio1mlNL29YUx6wmKu5PnLWNdnzH/Pyo9VE5WsT0UyWPythPJxDzE8T3DwW4V7gZ0
 tmmdpF3ZSmv0wXWZDmQXC+Wfzl/zvYXgKkPQCCelh8UJo5T5terFKy9pZuWRuWaK6Glddb8VhfZ
 RmKfiL+CrtaP+FaoEGDjXdVk=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8935c3cd496893e1;
	Wed, 02 Sep 2026 15:31:45 +0000
X-Mizu-Trace-ID: 8935c3cd496893e1
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:31:44 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm: replace PF_KCOMPACTD/PF_KSWAPD with
 kthread_func()
Message-ID: <aphBHnm7ejNM3aNR@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>

On Wed, Sep 02, 2026 at 09:16:49PM +0800, Kefeng Wang wrote:
> The task_struct->flags field is a limited 32-bit resource. Two flag bits,
> PF_KCOMPACTD and PF_KSWAPD, are used to identify whether a kernel thread
> is kcompactd or kswapd. Converting these to use kthread_func() frees up
> two valuable flag bits for future use.

I wouldn't call it a limited resource. We can have more fields in task_struct
but I like the cleanups.

> 
> Kefeng Wang (4):
>   xfs: remove dead kswapd flag inheritance from btree split worker
>   iomap: simplify writepages reclaim guard
>   mm: replace PF_KSWAPD flag with kthread_func() check
>   mm: replace PF_KCOMPACTD flag with kthread_func() check
> 
>  fs/iomap/buffered-io.c                   |  3 +--
>  fs/xfs/libxfs/xfs_btree.c                | 18 +-----------------
>  fs/xfs/xfs_platform.h                    |  4 ----
>  include/linux/compaction.h               | 11 ++++++-----
>  include/linux/sched.h                    |  4 ++--
>  include/linux/swap.h                     |  7 +------
>  mm/compaction.c                          |  9 ++++++---
>  mm/vmscan.c                              | 10 ++++++++--
>  tools/sched_ext/include/scx/common.bpf.h |  2 --
>  9 files changed, 25 insertions(+), 43 deletions(-)
> 
> -- 
> 2.55.0
> 
