Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C7B364927
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 10:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784026626; cv=none; b=JxBlOqToMslCb/EMfRA707AuR/BiWZnSbRnD88QSmE6yY1nmdXFtVz2vpadQfR/jQcLu45A9TETFplMfNpXH3w8ECiVNfC2eZ37Yt9X3i0JPtwnYnfcDUYvDN9KNK0l8u104S1wCak/h6U9QPPHAdVnG/Rq2YLQ0vQiFjIxlEq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784026626; c=relaxed/simple;
	bh=hxd7B9MjJEnZOm0pYk9ZPxfmGT7QqZp3HKCUwP+9NYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6U6JN+7T7ObVV1nHgqnEuNJ+cO6o8CwmlWWYYUa38+ZOeMgvjISqH2C4bsPMIzd+cfxPbJiePQzs281gHixkOY66q5CSTYatf7uiC6Xr9RA3gUGIOmK8Mal+LqMMp4pXbB+0+o5/Y5ZxvZfW1kpxAdPiC/0MDuntck+L6vsV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gc8GFZ+d; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gc8GFZ+d"
Message-ID: <3b85c8ec-f49a-45be-8e40-fe729c908e0f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784026622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b+/02nV5PKCig2GWCVlTdDIGXiyzApjtVUV59kIrcLM=;
	b=Gc8GFZ+d3zpJbug2thf9FF6OZIE897xwN3vzOQlKoLCTS9pePGJ+vnyvp/ZqCoaevVxpL0
	MABYh96Okw4r16h1lG84PA/X3/WsJLyqTYjIvO3ZWyboHtGV+FpE0REbcJaCFGqmtjZB8i
	U6IvaVO/osbGa73qzG0SU06B1xld1E0=
Date: Tue, 14 Jul 2026 18:56:29 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
To: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 7/14/26 6:14 PM, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   fs/btrfs/super.c   | 11 +++++++++++
>   fs/super.c         | 19 ++-----------------
>   fs/xfs/xfs_super.c | 12 ++++++++++++
>   mm/shmem.c         | 11 +++++++++++
>   4 files changed, 36 insertions(+), 17 deletions(-)

Looks reasonable to me. So

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

