Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2B43D905F;
	Wed, 24 Jun 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782314335; cv=none; b=Ue6RFqWxc9xfa8fcw02K3jBFhY8vins58NBq6eAkZ1L1VTSjOgzhbBQGq7XIhQpAYw1QwkSGo/7avHN1FpC4BjOp3l0Sixm6Erqa4oEhUgE2/yd1bmbPbF8dJ3mo4HrLcNzVLAKA0Obe03/RWUuD3lHLhNfQCvX2dQGvOeSqSNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782314335; c=relaxed/simple;
	bh=RDOVrx8dKGDFgKMwpgDgmXF+JV66gRwWtkcpoJ9Ycq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZooq7nCj3IP8KyZaQF+3y5FOhJmkHsabhsWh5dGxpY5ZBFs5oa5YJ9OfOLmj1q2B9NffWKVsQyNYQ12v/LTBMhiaM9KSY2rx3VEhQAY9wvBTSRqRELBZnFbnlf9bMYEIlxJV3o1XS8kBBdcfC+SJH3lgTSaGwItL4mhLSQRKMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NyWSt8ap; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NyWSt8ap"
Message-ID: <cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782314322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCfveZ37ayRh458SUb8Vvs7csErWvvnNaK/RVVo+5fA=;
	b=NyWSt8apc46t06T04zMNhMchtk3k4ctFbVCiL9c2mP9xyextgm4eGNBGZRMVtokC/pbQ24
	vU3kdqTh4LXr1cjm4Jsn6oIw3SoC6+9ZfRZnNtDC+QkC0X8TGfqVxfmzeu+69fJRhGzIhQ
	iIJdk2xZx2BxIFCIz9q4ErwI9vRQK1o=
Date: Wed, 24 Jun 2026 16:18:38 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <ajrHa_JGxQvCMf8t@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ajrHa_JGxQvCMf8t@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 23/06/2026 19:08, Shakeel Butt wrote:
> On Tue, Jun 09, 2026 at 05:30:47AM -0700, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
> 
> I see the underlying objects whose count is returned by ->nr_cached_objects()
> hook is memcg charged for shmem and xfs but not for btrfs. Do you envision
> there might be a rare scenario where we have a lot of memory charged to a memcg
> consumed by objects which ->nr_cached_objects() tracks and that memory becomes
> unreclaimable due to this patch?

Hello!

Thanks for the review.

For XFS, xfs_inode is SLAB_ACCOUNT, so a memcg can have memory charged in
XFS inodes sitting in XFS' internal reclaim state. But the current callback
does not target that memcg: xfs_fs_free_cached_objects() calls
xfs_reclaim_inodes_nr(), which walks the mount and reclaims
XFS_ICI_RECLAIM_TAG inodes without checking sc->memcg. So non-root memcg
reclaim was only getting an opportunistic mount-wide reclaim pass here; it
could reclaim the target memcg's inodes by chance, but it could just as well
reclaim inodes charged to other memcgs. This patch removes that cross-memcg
side effect, not a correct memcg-targeted reclaim path.

Those XFS inodes are still reclaimed by XFS' own reclaim worker, which is
queued when reclaimable inodes are tagged and requeues while reclaimable
inodes remain. With the default xfssyncd_centisecs value, that is about every
5 seconds. The root/global superblock shrinker path also continues to call
the XFS callbacks. This will keep the memory reclaimable.

For shmem, shrinklist_len counts inodes whose tail large folio could be                                                                                                                                                                                                                                                                                                                                               
split — splitting itself doesn't free anything; it just lets normal page                                                                                                                                                                                                                                                                                                                                              
LRU reclaim the truncated tail. The folios are on the memcg-aware LRU and                                                                                                                                                                                                                                                                                
will be aged/reclaimed there independently, so skipping the split from                                                                                                                                                                                                                                                                                   
memcg context just delays the split?

or btrfs extent maps, as you note, these objects are not memcg-charged.
> 
>>
>> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
>> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
>> whose bit is set in the per-superblock shrinker bitmap, which on a busy
>> host means hundreds of calls per reclaim pass. Each scan queues the same
>> global shrinker work item that's already kicked from the root path.
>>
>> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
>> the returned total stays positive even if a memcg's own dentry/inode LRUs
>> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
>> in the memcg bitmap, so subsequent reclaim passes from the same memcg
>> re-enter super_cache_count() and pay for the global counter walk again.
> 
> What is the main concern? Is it the amount of CPU wasted or are we over
> reclaiming or reclaiming from unrelated memcgs?
> 

The primary concern is wasted CPU. On the busy hosts where I saw this,
hundreds of memcgs all repeating that walk per reclaim pass is what made
it visible in profiles.

Another concern is misattribution. Reclaim from memcg X ends up
reclaiming another memcg Y, which could have an affect on Y and
won't provide proper isolation.

>>
>> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
>> or root). The memcg-aware dentry/inode LRUs keep being counted and
>> scanned per memcg as before; only the global fs-specific hooks are skipped.
>> The root/global shrink path still drives those hooks; only their
>> invocation from non-root memcg slab reclaim is removed.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I am fine with the stopgap but it would be nice to have proper memcg awareness
> in xfs and shmem callbacks. For btrfs, I am not sure if it makes sense to memcg
> charge btrfs_extent_map objects but at least to decision to skip memcg reclaim
> will be inside the fs callbacks i.e. nr_cached_objects.
> 

Agreed that this is the right long term approach. If the preference is to move this down to
the fs own callbacks instead of fs/super.c, I can do that in the revision as well.
