Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEA3CB570
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538214; cv=none; b=Z9SFDsMdM28FtYV1VGENaqyVZ4XFoLOJ8T92U5H1sI4xQ678HAo4ivpvgZU3iHisUSnsCC4jubWcN3Dj+FwUIKDUhKXywwI+bztU86nnSnUzVlgdjl7VogHKhxAjXpphger5aybgC3zFeHwHfKD/KvVXoS18n2G3sk5P81uP33Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538214; c=relaxed/simple;
	bh=P2rW3hKxGUs4nS+9TbwXfR4YDLmtL/y0lG03tWYudJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2CjuhPPfZN/O49nY9+LSf6TSHv/OGNsh6Qk/dGNi/GFVOqsbUEQiFLUmX6ncZXJq9y0c8pXvSHk9zusyikgL+KGe+TEkBxLJpOI25WvSJwqK7YP5HP5FsIdAhatov/G2iHHYQjlKcAvxg+9LeRkwvx7A8YjoqdYSFofiPD8Qic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=DmCaI5xL; arc=none smtp.client-ip=209.85.222.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="DmCaI5xL"
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-936623c6dd3so274288485a.0
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2026 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788538210; x=1789143010; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O/dj2tdiAd1cTUZz8ylHlEPfPG8XqvRkzCQtnk9erCM=;
        b=DmCaI5xLdtgImeWjLVgsIqsmgPQ4DAXHguOCh3zd/vPzYByUzl19eHDfSvAfYCZ6LF
         Niefw1NlDOt8u7MIOa6OoivV1099PVfu4ujXzr2fpF5HwRj9Z5UXbk7XN0Jeo605tTyn
         mB8MVE1/8SXklDvMVQpDejmtBfSCH0PEblBti8TEJDhjaQt+OlShc7HGV4IISDBk8Ugs
         noNBLtB1seYRNGGZzXNfeQk0TQUs8IeNMs+Y+BUU+lN6vlEZAs12oWQy9qBNOO8wCOh+
         N7sw3gVmc3P2jgF9FcqJ0ydLuJcqXA4UXjV6LdUcSznBs/LFuw+7Q/3lbkCRM6b7VWTC
         zqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788538210; x=1789143010;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O/dj2tdiAd1cTUZz8ylHlEPfPG8XqvRkzCQtnk9erCM=;
        b=T/G0J4uBNAYxlcoNM1dumWLj4YrIBznxufiVPauUB1QSDas0jKSyaSDK4Fxsv+rdOA
         q7hNrTBCYDNr4lNV6J/YVwtQEiUyFOH6wpdGx160DDFuICmJrfK5dvQUaYr84vv2nOEm
         VygROsMFEfI2ARrGch9USkyUkx4aJ2dpDY1Ys0ad98ugb07QFrHIAKeJPNrrt/+U6Gzy
         c7RnEJicGnQ0Tm3Kg7Ozc5JY1Gwr+6atJ0Nl1K2YS621FIQUCMikYmw0YTLmiqxBNlkC
         4Ojij4tm5uLi95KfYEhqOQsYX0GdzNnWais3/9yZotOCs7g1cYou/LGnlMTR/on0vTZa
         ZJsQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8QZtMRzUok1L8WKHJlWqqGu7DOhCsJEWqYHVPGYmCTRG8h0t+wlTmIIOJ5dqearMQVD354y2vspE=@vger.kernel.org
X-Gm-Message-State: AFuF++mmT4mpOXJoYRrUVYgSOO+aR7oCn8hQ/0h3aZSJXjjlremxbVVG
	u6q62WafhEx81euhN8D5GB+CD/bpg8/fNZAjp2nqClGABCAYpI0bLFaDxYawXniIZow=
X-Gm-Gg: AYBFou2Nx+ejgIqra0Sn5up1PajcCzNYdtoG8pGWHDdyZQPIFJjZJqnjkvmeKAGkFYx
	KZncO6B1bP2bxKab3cgMwN9La0cnj4/dDbtzo4Rj539wm84jMhouaK3feyp+rAU1t43ab8duaK8
	6gkf/0TXBvQcBZzfXOZbqcgnZjL9aETUAwBgGau57nqQKZggI6n4sBXpr+zE6BUMpIQ1eRqM3/C
	5a5uUCW4kL8FIXoEZZoGhPWrHxG/14tdDIYMJAcnhWnfLgjPyaTL6A2uv7E2/WUZOpYh/FLll9S
	8WjVwa4jiwvS2ZBHYcOhs+VhGHPugZHdZdL2+Akaigc/gSMIcbJfzQ5RXabuKQHcmDIdNgQrC+O
	ZkOg6493cS7SHK3rrxcs+pycei9PVIqsE9RJlojz0/4Hr41W2R9cGZ1Qp9pDBSuLxt+FjDZ9fma
	SP+0K9GIk8vKidO2Ob/0ZJEpyZFpLHy5sIaFc6
X-Received: by 2002:a05:620a:6cc6:b0:930:f285:5ee9 with SMTP id af79cd13be357-9396e0b2fc3mr1194176885a.20.1788538206229;
        Fri, 04 Sep 2026 09:10:06 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104067b125sm23869576d6.29.2026.09.04.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:10:05 -0700 (PDT)
Date: Fri, 4 Sep 2026 12:10:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <20260904161000.GC6641@cmpxchg.org>
References: <20260904115629.3993331-1-dipiets@amazon.it>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>

On Fri, Sep 04, 2026 at 11:56:28AM +0000, Salvatore Dipietro wrote:
> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.
> 
> The root issue is that direct compaction is too expensive for hot
> allocation paths that have fallbacks to smaller allocations.
> __filemap_get_folio_mpol() already marks higher-order allocations with
> __GFP_NORETRY | __GFP_NOWARN, signalling that the caller can handle
> failure.  However, the page allocator still attempts full direct
> compaction for costly orders with __GFP_NORETRY, which is unnecessarily
> aggressive when the caller will simply retry at a lower order.
> 
> For costly-order allocations with __GFP_NORETRY, clear
> __GFP_DIRECT_RECLAIM at the very start of the slowpath, before
> can_direct_reclaim, can_compact and the nofail checks are evaluated.
> This makes the entire slowpath treat the request as non-blocking: no
> direct reclaim, no direct compaction and no drain_all_pages() IPI
> across every CPU. kswapd (and in turn kcompactd) is still woken further
> down for background defragmentation, so compaction keeps working for
> long-term system health while being removed from the latency-critical
> direct allocation path.
> 
> Allocations that also request __GFP_THISNODE are exempted.  That flag
> pairing identifies the local-node-first THP attempt issued by
> alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
> form transparent huge pages.
> 
> Test environment:
>   Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
>              12x 1TB IO2 32000 IOPS RAID0 XFS
>   OS:        AL2023
>   Kernel:    v7.3-rc1
>   Database:  PostgreSQL 18.4
>   Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s
> 
> Results (average of 3 runs, TPS):
> 
>   Config                   Avg TPS      % vs Baseline
>   baseline (no patch)       59,408       -
>   With this patch          155,409      +161.6%
> 
> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> Cc: stable@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <dgc@kernel.org>
> Cc: Ritesh Harjani <ritesh.list@gmail.com>
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-xfs@vger.kernel.org
> Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>

Looks good to me, thanks for keeping at it.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
