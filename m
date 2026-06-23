Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C67390239;
	Tue, 23 Jun 2026 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782238155; cv=none; b=sbwSOZZ4W4ukmNOSaEVx8gOK+zUYamp9A4qUICdJ/YB77LWCwRTc9KLEMt4pc3l+zPikzfJj6bI3aOiSLK/Z5ijzQ9OJIOFrFQDlHOiTh/jEa5jd9sw7GOQeugRClIA59ieORTBco0BtapOlWEOEeWr9fQGqiFq7bl0o+iZvts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782238155; c=relaxed/simple;
	bh=kqDPClqo2z/9ixFPp9oOYj+gB1CHXlyJ/G4mQYdFFoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gDgfrqQsdxEUe5cjnujWiw3NxHtFsWYq6w2IwIQGvJWuOep9er4JbTiDpLW6yjdzY/icSnFGumXnBmCwSpioO52SgDixxRQQgTj0NXsMNE6pnki066uyERPNWgeoWR9211pidhUkZJW2JFeO1rRCnpHLFcFshXMpj/H/7ZRDm2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wgEd/U9D; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wgEd/U9D"
Date: Tue, 23 Jun 2026 11:08:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782238141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zXfEiM4jkm920RVfEhKOk9S2wafZQEGin844HPcRxZE=;
	b=wgEd/U9Db0WHWapZ+mfVWppaS6KYtdPfphaKlnqjcR3/jlMe6efMFDfyrXFopmBzVtfzze
	4g02EQ2WT0HLbzgAJ5gMNq6kl9MDi0XtctBvx2/SBjTKm0kHOf//4LFdgcqI1hQSiyhTc4
	qJbinVk9+MLAmzDUedlX/VWn9UAgI5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, 
	hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
	linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-ID: <ajrHa_JGxQvCMf8t@linux.dev>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 09, 2026 at 05:30:47AM -0700, Usama Arif wrote:
> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
> btrfs extent maps and xfs inode reclaim operate on filesystem-global
> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
> None of them filter by sc->memcg.

I see the underlying objects whose count is returned by ->nr_cached_objects()
hook is memcg charged for shmem and xfs but not for btrfs. Do you envision
there might be a rare scenario where we have a lot of memory charged to a memcg
consumed by objects which ->nr_cached_objects() tracks and that memory becomes
unreclaimable due to this patch?

> 
> The mismatch shows up under memcg-heavy slab reclaim. shrink_slab_memcg()
> calls do_shrink_slab() once per (memcg, NUMA node) pair for every memcg
> whose bit is set in the per-superblock shrinker bitmap, which on a busy
> host means hundreds of calls per reclaim pass. Each scan queues the same
> global shrinker work item that's already kicked from the root path.
> 
> Because btrfs/xfs global count is typically non-zero on any in-use filesystem,
> the returned total stays positive even if a memcg's own dentry/inode LRUs
> are empty. shrink_slab_memcg() therefore never clears the SB shrinker bit
> in the memcg bitmap, so subsequent reclaim passes from the same memcg
> re-enter super_cache_count() and pay for the global counter walk again.

What is the main concern? Is it the amount of CPU wasted or are we over
reclaiming or reclaiming from unrelated memcgs?

> 
> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
> or root). The memcg-aware dentry/inode LRUs keep being counted and
> scanned per memcg as before; only the global fs-specific hooks are skipped.
> The root/global shrink path still drives those hooks; only their
> invocation from non-root memcg slab reclaim is removed.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I am fine with the stopgap but it would be nice to have proper memcg awareness
in xfs and shmem callbacks. For btrfs, I am not sure if it makes sense to memcg
charge btrfs_extent_map objects but at least to decision to skip memcg reclaim
will be inside the fs callbacks i.e. nr_cached_objects.

