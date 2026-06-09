Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C377A401A08
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781012357; cv=none; b=TjtIv2EtlK8p7vqsqM8qqcWJ9SVIhGzUZFnrZ2S+QlGPBfFzey1WwRvljqwLkFatADjMyPHyWU8LG3qCxsSRpCIOF/xetOEbeCx7JyxJCKD8nFCa7+FKxY4fyqmnhNfJ0OI/ROQkOusKN74AB7uT3PbXyVWS2ZEvMRoO13wF4YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781012357; c=relaxed/simple;
	bh=Ld0mtuWHZDKcfGoVtJaBqvRcMPaJlO6FFUPg+tsjemA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1nzY8iAicAtcBhx3YNCOY58hLP9nMiipCzN711v5Q/iioaafnwF1i/yR+dr8s9WiY2o9nNjy5uF/L59DUZ6K6ifGjKVJ1bbK9kHCgX+ag9JoOHOFqG9KidSydIkrtWpASQ90GkF/bqc9P9Skom8BqLNh9zj53g2o+OtiiHueCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DHA5pvdG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DHA5pvdG"
Message-ID: <86575450-1d56-43be-a4fd-6f451e5be4e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781012343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YJV2I1pYWH8I5eTLLlBTFWiw8BNl9+kPEFYXmmxRFA0=;
	b=DHA5pvdG52Z8Irgr/MLUCeE3l55DgnRt1kYMY2LtcWTgvjyHXVXQzZmJRQoBDdVBAzJEN4
	Rqo+Pc3l9/iqRCZMu3i2P2MnJItVE+ySpQCrTGcA4wmxKkIqwdSPoVVHf8MV1e7lKqzy7O
	z3+XUebaAMcRd6oZZlVWxxJQ1nu+Jgw=
Date: Tue, 9 Jun 2026 14:38:58 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Jan Kara <jack@suse.cz>
Cc: brauner@kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, hughd@google.com, boris@bur.io, clm@fb.com,
 dsterba@suse.com, linux-btrfs@vger.kernel.org, cem@kernel.org,
 linux-xfs@vger.kernel.org, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <5exadtggg276xp5tayiqbbomnms4hjyaopmgu3chfpl2ug56dq@vyhswy2afzmo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 09/06/2026 13:52, Jan Kara wrote:
> On Tue 09-06-26 05:30:47, Usama Arif wrote:
>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>> None of them filter by sc->memcg.
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
>>
>> Restrict ->nr_cached_objects() to the global shrink path (sc->memcg NULL
>> or root). The memcg-aware dentry/inode LRUs keep being counted and
>> scanned per memcg as before; only the global fs-specific hooks are skipped.
>> The root/global shrink path still drives those hooks; only their
>> invocation from non-root memcg slab reclaim is removed.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> To me this makes sense. However I'm bit surprised that XFS inode shrinker
> (which is what gets counted in nr_cached_objects for XFS) isn't memcg
> aware. I guess since these inodes are on their way to a relatively quick
> destruction, nobody really bothered. So I'm fine with the change, just
> I'd like to make sure XFS folks are aware and don't plan anything in this
> area.
> 

Thanks for the review!

Yes I am hoping that if there are any objections from xfs or btrfs, it gets
raised. Have cc'ed the btrfs and xfs maintainers and reviewers.

Thanks!
Usama


> 								Honza
> 
>> ---
>>  fs/super.c | 19 +++++++++++++++++--
>>  1 file changed, 17 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/super.c b/fs/super.c
>> index 378e81efe643..5216c5dbd4c4 100644
>> --- a/fs/super.c
>> +++ b/fs/super.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/export.h>
>>  #include <linux/slab.h>
>>  #include <linux/blkdev.h>
>> +#include <linux/memcontrol.h>
>>  #include <linux/mount.h>
>>  #include <linux/security.h>
>>  #include <linux/writeback.h>		/* for the emergency remount stuff */
>> @@ -169,6 +170,19 @@ static void super_wake(struct super_block *sb, unsigned int flag)
>>  	wake_up_var(&sb->s_flags);
>>  }
>>  
>> +/*
>> + * The s_op->nr_cached_objects hooks (used for example by btrfs and xfs)
>> + * operate on filesystem-global state and ignore sc->memcg. Driving them
>> + * from per-memcg shrink_slab_memcg() invocations only burns CPU walking
>> + * per-cpu counters and queueing duplicate work: the actual reclaim happens on
>> + * the global path (kswapd or root direct reclaim) regardless. Restrict them
>> + * to that path.
>> + */
>> +static inline bool super_fs_objects_eligible(struct shrink_control *sc)
>> +{
>> +	return !sc->memcg || mem_cgroup_is_root(sc->memcg);
>> +}
>> +
>>  /*
>>   * One thing we have to be careful of with a per-sb shrinker is that we don't
>>   * drop the last active reference to the superblock from within the shrinker.
>> @@ -198,7 +212,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>>  	if (!super_trylock_shared(sb))
>>  		return SHRINK_STOP;
>>  
>> -	if (sb->s_op->nr_cached_objects)
>> +	if (sb->s_op->nr_cached_objects && super_fs_objects_eligible(sc))
>>  		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>>  
>>  	inodes = list_lru_shrink_count(&sb->s_inode_lru, sc);
>> @@ -259,7 +273,8 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>>  		return 0;
>>  	smp_rmb();
>>  
>> -	if (sb->s_op && sb->s_op->nr_cached_objects)
>> +	if (sb->s_op && sb->s_op->nr_cached_objects &&
>> +	    super_fs_objects_eligible(sc))
>>  		total_objects = sb->s_op->nr_cached_objects(sb, sc);
>>  
>>  	total_objects += list_lru_shrink_count(&sb->s_dentry_lru, sc);
>> -- 
>> 2.52.0
>>

