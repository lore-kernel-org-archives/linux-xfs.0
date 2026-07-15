Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CB744103F
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784111189; cv=none; b=nt/P/yy/3+B39tKjRKhqVK5YSwjqFKr/lCW4aiQPLYicvxIAqThTzEfFoekQDzrCZ66GCJaF7XrwJX1T9PxhM6DNUp6Lf7sqrbVayemcVsDnK/Ow+DIxl/VQzOQ+GzyucH6ClE20LHLtkvJ9WGuD6gfRRJraXB0K4iaZF0V1qjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784111189; c=relaxed/simple;
	bh=30lXEo8O7BemTusr8v0D5eoMcScD7uUKzh8Lgs/1WSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o53m11j+yavcF8CHqFsly3zR0yD2pKwPGp51GruSCrtjta008ahinYUpDzfv69t13rBATkb2aMM8NHN1zRDm3p0SvqPM07T4TXoLc/ZFr03vfO0zGhsSy8PCr+5rhNJY1qQa5vnhGbi0EfK0x1lSBHwBFtRF1afzYQ22YTTsJCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hx4OibK1; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hx4OibK1"
Message-ID: <44bf7cd3-8083-454c-9419-d377061e31c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784111174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEd62YpRlYzH7ddXxgaLtMBL/oT0lPJiUJAY2FiEygY=;
	b=hx4OibK1fXVjDH6lWemesdKXKAAp8ftOERwPW2o9fu+hyp2uu+GzE3hSdBoXrCoRdTdWtf
	AVHlJUwVDD5uhg+HbwYA6G70/DEf8VD+cV4zliNOWad5kMQ1pCHY0BnbWdEMFYlu4O6nRA
	pIYP/tCPGwtoKeOapGthO5rvafaKxRI=
Date: Wed, 15 Jul 2026 11:26:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
To: Dave Chinner <dgc@kernel.org>
Cc: brauner@kernel.org, qi.zheng@linux.dev, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, hughd@google.com,
 boris@bur.io, clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
 cem@kernel.org, linux-xfs@vger.kernel.org, shakeel.butt@linux.dev,
 hannes@cmpxchg.org, riel@surriel.com, kernel-team@meta.com
References: <20260714101454.1202449-1-usama.arif@linux.dev>
 <ala2rDHrFDjql3Qg@dread>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ala2rDHrFDjql3Qg@dread>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 14/07/2026 23:22, Dave Chinner wrote:
> On Tue, Jul 14, 2026 at 03:14:54AM -0700, Usama Arif wrote:
>> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
>> in memcg slab shrink") added a check in fs/super.c that skips the
>> ->nr_cached_objects() hook whenever the shrinker is invoked for a
>> non-root memcg, because none of the current implementations (btrfs,
>> xfs, shmem huge) honour sc->memcg.
> 
> I don't see that commit in an upstream tree. I'm guessing I wasn't
> cc'd on it, either, because I don't recall seeing that as a patch,
> either.

Ah sorry about this, I just ran get_maintainers.pl on the patch, plus added
shmem, btrfs and xfs maintainers on it. get_maintainers.pl didn't report
shrinker maintainers (likely because the change was in fs/) and it didn't
come to my mind as well :(

The patch is here: https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/> 
> However, if anything is gating the fs_objects callouts to the fs
> when memcg is being srhunk, then it is fundamentally broken and you
> are correct to fix it.
> 
>>
>> That policy is really a filesystem-owned property: fs/super.c should
>> not encode the assumption that these hooks are never memcg-aware,
>> since a future implementation might legitimately filter by sc->memcg.
>> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
>> and shmem_unused_huge_count() so each filesystem can lift the
>> restriction independently once its underlying counters/scans become
>> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> However, your assumptions here are incorrect.
> 
> That is, the XFS fs_objects implementation is intended to be called
> even when memcg shrinking is occurring. I architected it that way
> all those years ago when I introduced the fs_objects shrinker
> callout. i.e. XFS is not aging reclaimable inodes via this call - it
> is purely an expedite freeing of recently reclaimed VFS inodes when
> there is memory pressure of any kind.
> 
> Reclaimable XFS inodes are still charged to memcgs, but we don't
> track them per-memcg because it is extremely inefficient when their
> lifetime after being released by the VFS is usually less than 5
> seconds. Indeed, this low level cache is not for working set
> retention; the VFS inode cache does that. The XFS inodes need to
> through a GC state before they can be freed, this takes a little bit
> of time, so we don't hold up the VFS inode cache shrinker for that.
> 
> The VFS inode cache shrinker is memcg aware, so it only pushes
> inodes that are being reclaimed by memcg reclaim into the the
> reclaimable state at the XFS level. Hence we don't need to track
> reclaimable inodes by memcg - we know that memcg owned inodes that
> are to be freed have already been pushed into reclaim by the VFS
> shrinker doing memcg reclaim. Hence all we need to do is sweep them
> and free them.
> 
> This is what the XFS fs objects shrinker does.  It needs to run in
> conjunction with -any- shrinker context to immediately free the
> clean inodes that the VFS shrinker released that pass, and to
> release any of the recently released VFS inodes that needed GC and
> are now clean and can be freed.
> 
> IOWs, the XFS fs_objects callout is not "memcg-aware" in the classic
> sense of "it tracks objects by their owner memcg". However, the
> -combined superblock shrinker algorithm- is memcg aware and that
> results in XFS only seeing objects from the memcg being reclaimed
> transitioning to RECLAIMABLE state which it then immediately sweeps
> away.
> 
> i.e. the architecture of the VFS and XFS inode cache reclaim is
> entirely memcg aware, and that is why I implemented the fs_objects
> callout for XFS all those years ago. It works efficiently, it works
> correctly with memcg based reclaim, and XFS doesn't need to care
> about memcgs in it's low level reclaim code. Win, win, win.

Ack on above, and Thanks for explaining this!> 
>> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> 
> Behaviour was broken by the above commit, it needs to change.

Ack.> 
>> still early-return 0 for non-root memcg contexts, keeping the shrinker
>> bit clearable in each memcg's bitmap; the global (kswapd or root
>> direct reclaim) path still drives them as before.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>
>> @@ -170,19 +169,6 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>>  	wake_up_var(&sb->s_flags);
>>  }
>>  
>> -/*
>> - * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
>> - * operate on filesystem-global state and ignore sc->memcg. Driving them
>> - * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
>> - * per-cpu counters and queueing duplicate work: the actual reclaim happens on
>> - * the global path (kswapd or root direct reclaim) regardless. Restrict them
>> - * to that path.
>> - */
>> -static inline bool super_fs_objects_eligible(struct shrink_control *sc)
>> -{
>> -	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
>> -}
> 
> This wrapper should still exist (with a better name) so filesystems
> don't need to open code memcg cruft.

Ack,

I am going to send a v2, which will include Fixes tag and follow above.> 
> -Dave.

