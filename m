Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27324A9D72
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363417; cv=none; b=Rlvly1rUZvdl4pqMEAYyIavrgJTZJy5WMJNgXzIauVvdDZjaHeM4O2mBWLzaEqjGa67Yrd+Fa20BAr2UlZwfVO5U9WbvHTai0N3w/VkqM5BKwGZHz6K0xUZz95YlatwgkEndE0iO+X0DK+nwflSkIavhJMiZDnE+Ms8x77mBxZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363417; c=relaxed/simple;
	bh=nQsYSlZTDghUio3blhbx1zI+jv+vMKfhKPaFPZydeaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2GteyeQasUcL0qqb9XyFy9BWPFy8xZSEi1ICPfnQLrpGYMc0alxsQ20sfkFrjz1hZ1CWwWMN/foJl0c5tPTmIjyP+W6mrbN/s2HOftsCT53fywK75bqIBKrEClaNBxGBMNXv2hZEC/+DMpMttmaB32tzh8xQxdyxnQ+VUZhWpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oc+mui4m; arc=none smtp.client-ip=95.215.58.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oc+mui4m"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nQsYSlZTDghUio3blhbx1zI+jv+vMKfhKPaFPZydeaw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363395; v=1; x=1788968195;
 b=oc+mui4mfm5rkivU1QIe2HncQpjw+MEoitTI9PcMQigNEVtPvlvaXTCZbyyw54KEovPfWuYr
 FMDVbSteUoEMvG6UyNNT9oZ0023l36gQ0Epc/YKy4GNGpHBUuwoIHtX5Cou73RvtqEADC0Z3sC+
 bmevzRE8s1I8UoJK1O4hDGvo=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0dc618aa284fdb5a;
	Wed, 02 Sep 2026 15:36:35 +0000
X-Mizu-Trace-ID: 0dc618aa284fdb5a
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:36:30 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
Message-ID: <aphCZEkORT4GFkle@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>

On Wed, Sep 02, 2026 at 09:16:52PM +0800, Kefeng Wang wrote:
> The preceding commits removed the last consumer that propagated
> PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
> The only remaining setter of PF_KSWAPD is kswapd(), and every
> current_is_kswapd() caller only needs to check whether the current
> task *is* the kswapd thread, not whether it inherited the flag.
> 
> Replace the flag-based test with kthread_func(current) == kswapd,
> freeing the 0x00020000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
