Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80E73806CA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363230; cv=none; b=S3/UyVApgRUiI5c35bKaFkR+6dD+nBUBGvWwxNEJ72zM1QE7B8LPERbMwEsjRvoRwo20UQghMCMPTMqfvnST97eJ+NwHoyLS5f2svqdbccM8Zc6qD/Wd0lxVSD3EC62kM4yBooPt0kGnE4+/5c/ZH504n9tI2d+nJhgni5I8xF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363230; c=relaxed/simple;
	bh=vbue5OyW55xGQwmYa8CPdbdplvj7VE/wOjx7vybY0CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEbqC1UIFx/4xjNJgduSrkTjFgBwxAb8abilMLE9nI3APuWBllAQPqJxHNDXr8FjWXcuHG8BhhzsHo8GQWracreAeRDMMH9g3+hL6gQX+G1HvqMYy3bJdWg3p3h4fd3gHMD1a6nP71W2I2gHbc12+0MQtWJM+fy0X16hsp+CIVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eG9ZZd+o; arc=none smtp.client-ip=91.218.175.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eG9ZZd+o"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=vbue5OyW55xGQwmYa8CPdbdplvj7VE/wOjx7vybY0CY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363225; v=1; x=1788968025;
 b=eG9ZZd+ocdwWvXP0bufWDzDPW6gl+Y/nkYvanXXmhQ7YciNhsBmIG076vqFPpryeKsMyOSVw
 gMxtmpihWEjLrIYNWrtL7w/lHcIGLs24bpPHmI2ryqIX0/u0V39j0z5MUhuLjRkp3TB15B+Hj2M
 wnHmeiC4916zqo40OLGQHR78=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9ae62829dd25829f;
	Wed, 02 Sep 2026 15:33:45 +0000
X-Mizu-Trace-ID: 9ae62829dd25829f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:33:43 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree
 split worker
Message-ID: <aphBvsGX1op31Nwp@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>

On Wed, Sep 02, 2026 at 09:16:50PM +0800, Kefeng Wang wrote:
> Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
> aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
> xfs_btree_split_worker() so that block allocation offloaded from
> kswapd to a workqueue thread could access emergency memory reserves
> and avoid reclaim throttling.
> 
> pageout() no longer calls ->writepage() for filesystem folios -- it
> returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
> never enters XFS writeback and cannot reach btree split.  The only
> path that offloads btree splits is unwritten extent conversion at IO
> completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
> a workqueue context where current_is_kswapd() is always false.
> 
> Let's remove the dead kswapd flag and related codes.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
