Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ve1eur01on0135.outbound.protection.outlook.com ([104.47.1.135]:6383
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751010AbeCZLQ7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Mar 2018 07:16:59 -0400
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
References: <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
 <20180320001827.GB1150@dastard>
 <ec116ce6-c22b-66e1-0e01-55f895997c7d@virtuozzo.com>
 <20180320143452.GT18129@dastard>
 <5eb88165-c108-5989-3cb5-1f260cec5e53@virtuozzo.com>
 <20180322050152.GA18129@dastard>
 <3320c962-35c5-c5ed-2a9f-0acb2b875579@virtuozzo.com>
 <20180322234613.GD18129@dastard>
 <c1fc50fe-25e7-a92a-a2a8-3e40e7de9b0a@virtuozzo.com>
 <20180326023709.GK18129@dastard>
From: Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <d7c95f86-d883-45c4-ac20-fa56e7f39a54@virtuozzo.com>
Date: Mon, 26 Mar 2018 14:16:51 +0300
MIME-Version: 1.0
In-Reply-To: <20180326023709.GK18129@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On 26.03.2018 05:37, Dave Chinner wrote:
> On Fri, Mar 23, 2018 at 03:39:53PM +0300, Kirill Tkhai wrote:
>> On 23.03.2018 02:46, Dave Chinner wrote:
>>> On Thu, Mar 22, 2018 at 07:52:37PM +0300, Kirill Tkhai wrote:
>>>> Here is the problem I'm solving: https://lkml.org/lkml/2018/3/21/365.
>>>
>>> Oh, finally you tell me what the problem is that you're trying to
>>> solve. I *asked this several times* and got no response. Thank you
>>> for wasting so much of my time.
>>>
>>>> Current shrinker is not scalable. Then there are many memcg and mounts,
>>>> the time of iteration shrink_slab() in case of global reclaim can
>>>> take much time. There is times of shrink_slab() by the link. A node
>>>> with 200 containers may waste 4 seconds on global reclaim just to
>>>> iterate over all shrinkers for all cgroups, call shrinker::count_objects()
>>>> and receive 0 zero objects.
>>>
>>> So, your problem is the way the memcgs were tacked onto the side
>>> of the list_lru infrastructure and are iterated, which has basically
>>> nothing to do with the way the low level XFS inode shrinker behaves.
>>>
>>> /me looks at the patches
>>>
>>> /me shudders at the thought of external "cache has freeable items"
>>> control for the shrinking of vfs caches.
>>>
>>> Biggest problem I see with this is the scope for coherency bugs ini
>>> the "memcg shrinker has freeable items" tracking. If that happens,
>>> there's no way of getting that memcg to run it's shrinker ever
>>> again. That seems very, very fragile and likely to be an endless
>>> source of OOM bugs. The whole point of the shrinker polling
>>> infrastructure is that it is not susceptible to this sort of bug.
>>>
>>> Really, the problem is that there's no separate list of memcg aware
>>> shrinkers, so every registered shrinker has to be iterated just to
>>> find the one shrinker that is memcg aware.
>>
>> I don't think the logic is difficult. There are generic rules,
>> and the only task is to teach them memcg-aware shrinkers. Currently,
>> they are only super block and workingsets shrinkers, and both of
>> them are based on generic list_lru infrastructure. Shrinker-related
>> bit is also cleared in generic code (shrink_slab()) only, and
>> the algorhythm doesn't allow to clear it without double check.
>> The only principle modification I'm thinking about is we should
>> clear the bit only when the shrinker is called with maximum
>> parameters: priority and GFP.
> 
> Lots of "simple logic" combined together makes for a complex mass of
> difficult to understand and debug code.
> 
> And, really, you're not suffering from a memcg problem - you're
> suffering from a "there are thousands of shrinkers" scalability
> issue because superblocks have per-superblock shrinker contexts and
> you have thousands of mounted filesystems.

Yes, but it's the way of how the containers are arranged. There are several
FS_USERNS_MOUNT tagged filesystems in kernel, and these filesystems are tagged
this flag, because they are safe and widely used in containers. It's impossible
to unite all of them as the only partition.

Also, separate ext4/xfs/etc partitions may be useful for some systems. You just
can't know all the workloads, people use it.

>> There are a lot of performance improving synchronizations in kernel,
>> and they had been refused, the kernel would have remained in the age
>> of big kernel lock.
> 
> That's false equivalence and hyperbole. The shrinkers are not
> limiting what every Linux user can do with their hardware. It's not
> a fundamental architectural limitation.  These sorts of arguments
> are not convincing - this is the second time I've told you this, so
> please stick to technical arguments and drop the dramatic
> "anti-progress" conspiracy theory bullshit.

Your view is limited by XFS, but the fact you don't use this doesn't
mean nobody is need such functionality. 
 
>>> So why not just do the simple thing which is create a separate
>>> "memcg-aware" shrinker list (i.e. create shrinker_list_memcg
>>> alongside shrinker_list) and only iterate the shrinker_list_memcg
>>> when a memcg is passed to shrink_slab()?
>>>
>>> That means we'll only run 2 shrinkers per memcg at most (sueprblock
>>> and working set) per memcg reclaim call. That's a simple 10-20 line
>>> change, not a whole mess of new code and issues...
>>
>> It was the first optimization, which came to my head, by there is no
>> almost a performance profit, since memcg-aware shrinkers still be called
>> per every memcg, and they are the biggest part of shrinkers in the system.
> 
> Sure, but a polling algorithm is not a fundamental performance
> limitation.
> 
> The problem here is that the memcg infrastructure has caused an
> exponential explosion in shrinker scanning.

Yeah, so this is the reason I seeking for the solution.

>>>> Can't we call shrink of shared objects only for top memcg? Something like
>>>> this:
>>>
>>> What's a "shared object", and how is it any different to a normal
>>> slab cache object?
>>
>> Sorry, it's erratum. I'm speaking about cached objects. I mean something like
>> the below. The patch makes cached objects be cleared outside the memcg iteration
>> cycle (it has not sense to call them for every memcg since cached object logic
>> just ignores memcg).
> 
> The cached flag seems like a hack to me. It does nothing to address
> the number of shrinker callout calls (it actually increases them!),
> just tries to hack around something you want a specific shrinker to
> avoid doing.

This is a prototype, and this is not difficult to teach the code to differ
shrinkers which need such the call, and the rest of them, and to implement
some generic way for that.

Since shrinkers will call nr_cached_objects() and free_cached_objects()
only for top memcg of reclaim, it will decrease the number of calls
for every system, which has more that 1 memcg. I.e., almost for everyone.

> I've asked *repeatedly* for a description of the actual workload
> problems the XFS shrinker behaviour is causing you. In the absence
> of any workload description, I'm simply going to NACK any changes
> that try to work around this behaviour. The rest of this reply is
> about shrinker infrastructure and (the lack of) memcg integration.

I've already pointed the problem. And the patchset I referred needs some
preparations around nr_cached_objects() and free_cached_objects()
to differ really populated memcg shrinkers and not.

Fortunately, this problem ends on the level of generic fs shrinker,
and it doesn't touch specific-fs level. So, I have no patches for
XFS and its shrinkers.

I just reported xfs guys there is a problem, they may be interested in.
But since nobody deploys many containers on XFS, and nobody is interested,
this discussion really has no sense.

>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -482,6 +482,33 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>>  	return freed;
>>  }
>>  
>> +static void shrink_cached_slab(gfp_t gfp_mask, int nid, int priority)
>> +{
>> +	struct shrinker *shrinker;
>> +
>> +	if (!down_read_trylock(&shrinker_rwsem))
>> +		return;
>> +
>> +	list_for_each_entry(shrinker, &shrinker_list, list) {
>> +		struct shrink_control sc = {
>> +			.gfp_mask = gfp_mask,
>> +			.nid = nid,
>> +			.cached = 1,
>> +		};
>> +
>> +		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
>> +			continue;
>> +		if (!(shrinker->flags & SHRINKER_NUMA_AWARE))
>> +			sc.nid = 0;
>> +		if (rwsem_is_contended(&shrinker_rwsem))
>> +			break;
>> +
>> +		do_shrink_slab(&sc, shrinker, priority);
>> +	}
>> +
>> +	up_read(&shrinker_rwsem);
> 
> Ok, so this shrinks /only/ non-memcg slabs. It's identical to
> calling shrink_slab() with a null memcg. We already do this in all
> the relevant memory reclaim paths when necessary....

No, it's not so. We call shrink_slab() with null memcg to iterate
!memcg-aware shrinkers only. While the new function is used to
shrink cached objects of memcg-aware shrinkers. There is a difference.

>> +}
>> +
>>  void drop_slab_node(int nid)
>>  {
>>  	unsigned long freed;
>> @@ -493,6 +520,8 @@ void drop_slab_node(int nid)
>>  		do {
>>  			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
>>  		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>> +
>> +		shrink_cached_slab(GFP_KERNEL, nid, 0);
>>  	} while (freed > 10);
> 
> ... like here, where the inner loop always calls shrink_slab() with
> a NULL memcg as it's first iteration. So your addition here is
> basically a no-op - we've already run non-memcg cache reclaim by the
> time your addition to run non-memcg cache reclaim is called. And
> here:

As I pointed below, shrink_cached_slab() works with memcg-aware shrinkers.

>> @@ -2573,6 +2602,8 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>>  			shrink_slab(sc->gfp_mask, pgdat->node_id, NULL,
>>  				    sc->priority);
>>  
>> +		shrink_cached_slab(sc->gfp_mask, pgdat->node_id, sc->priority);
>> +
> 
> You're adding unconditional global slab cache reclaim to a path that
> already does this but only in the calling contexts where it global
> slab reclaim is actually necessary. Doing unconditional global slab
> reclaim here will cause regressions.

It's not a global reclaim. We only shrink cached objects there.
The flag ".cached = 1" in the functions indicates the shrinkers,
what they have to shrink.

> So, let's address the number of shrinker callouts from
> drop_caches(). You're original example from here:
> 
> https://lkml.org/lkml/2018/3/21/365
> 
> | In case of global reclaim, a task has to iterate all over the memcgs
> | and to call all the memcg-aware shrinkers for all of them. This means,
> | the task has to visit 200 * 10 = 2000 shrinkers for every memcg,
> | and since there are 2000 memcgs, the total calls of do_shrink_slab()
> | are 2000 * 2000 = 4000000.
> 
> The loop is:
> 
> drop_slab()
>   for_each_online_node(nid)
>     drop_slab_node(nid);
>       for each memcg including NULL
>         shrink_slab(nid, memcg)
> 
> With 200 containers w/ 10 mounts X 10 memcgs each. That means we
> have 2000 mounts and hence 2000 memcg aware superblock shrinkers.
> we have 2000 memcgs, so each superblock has 2000 memcgs attached to
> it. And then we have N nodes in the machine.
> 
> So drop_slab() will call drop_slab_node() N times, and drop_slab
> node will iterate all the memcgs until there's no more to free.
> Each memcg with then iterate all shrinkers to find the memcg aware
> shrinkers, then do work.  IOWs, we actually have a minimum scan of N
> * 2000 * 2000 calls to shrink_slab(), not just 2000 * 2000.
> 
> The thing is, memcg shrinker contexts are not NUMA aware. They use
> the list array that was implemented for memory nodes and instead use
> it for a memcg list array, indexed by memcg ID rather than node ID.
> IOWs, memcgs are not numa aware, so they do not need to be called
> for every single node in the system. Only shrinkers in a global
> context (i.e. no memcg) that are NUMA aware need to be called for
> every node.
> 
> The patchset you posted implemented that mapping by adding a bitmap
> of memcg-internal shrinker dirty state and a global array that
> points directly to the struct shrinker that the bitmap index is
> associated with. This externalises the dirty tracking into the memcg
> code, which as I've already said I don't like.
> 
> The real problem here is that the shrinker itself is supposed to
> keep context specific call-to-call information. In the case of
> NUMA-aware shrinkers, that's kept in the shrinker->nr_deferred[nid]
> array.  That's dynamically allocated for numa aware shrinkers, but
> all memcg's that are called for the given shrinker all smash their
> state into shrinker->nr_deferred[nid] - they don't have their own
> nr_deferred state.
>
> This actually screws up the nr_deferred state for global reclaim,
> and causes unexpected unfairness to memcg reclaim. i.e. Global,
> non-memcg reclaim can defer pressure to all memcgs that shrinker is
> called on for that node because the nr_deferred count is shared
> based on nid. That means work we defer from one call to a memcg on
> nid=0 will be applied to the next memcg recalim call on nid=0,
> regardless of what it is. And if that first shrinker is then called
> next on nid=1, it won't get it's nr_deferred from it's last call on
> nid=0, it will get whatever is currently stored on nid=1.
> 
> IOWs, the memcg shrinker infrastructure itself violates the
> principles of memcg isolation and fairness by completely screwing up
> the call-to-call deferred work counts for individual memcgs and
> global shrinker reclaim.

Yes, it may be a problem, and I've already seen that. But since
I've never meet the real bug reports about that, and nobody complained
on that, I prioritized the problem with scalability is the first.

> If you're interested in fairness and memcg
> isolation in reclaim, then this is the first problem you need to
> solve.
> 
> IMO, What we should be doing here is something like this:
> 
> drop_slab()
> {
>   do {
>     freed = shrink_slab_memcg()
>     freed += shrink_slab_numa()
>     freed += shrink_slab_simple()
>   } while (freed < 10)
> }
> 
> i.e. we set up a distinct separation of shrinker roles according to
> the contexts in which they are called. e.g.

Drop slab is just and interface for /proc. It may be useful to measure
the performance (what I actually do in the patchset), but this interface
is not frequently used in real life.

shrink_node() is the real-life reclaim hero.

> 
> shrink_slab_memcg()
> {
>   for_each_memcg(memcg)
>     for_each_shrinker(&memcg_shrinker_list) {
>       nr_deferred = shrinker_get_memcg_deferred(shrinker, memcg)
>       do_shrink_slab(shrinker, 0, memcg, &nr_deferred))
>       shrinker_store_memcg_deferred(shrinker, memcg, nr_deferred)
>     }
> }
> 
> shrink_slab_numa()
> {
>   for_each_online_node(nid)
>     for_each_shrinker(&numa_shrinker_list) {
>       nr_deferred = shrinker_get_node_deferred(shrinker, nid)
>       do_shrink_slab(shrinker, nid, NULL, &nr_deferred)
>       shrinker_store_node_deferred(shrinker, nid, nr_deferred)
>     }
> }
> 
> shrink_slab_simple()
> {
>     for_each_shrinker(&simple_shrinker_list) {
>       nr_deferred = shrinker_get_node_deferred(shrinker, 0)
>       do_shrink_slab(shrinker, 0, NULL, &nr_deferred)
>       shrinker_store_node_deferred(shrinker, 0, nr_deferred)
>     }
> }
> 
> [ Note: This implies a shrinker can be on multiple lists. That's
> fine, we can already do concurrent calls into a shrinker from
> different reclaim contexts. But in doing this, the "iterate shrinker
> list to find memcg aware shrinkers" goes aware. Similarly with the
> basic shrinkers - we stop hitting them for every node we scan in
> global reclaim and hence putting lots more pressure on them because
> they are being treated as "one cache per node" instead of a single
> cache. ]
> 
> The simple and numa cases can share nr_deferred[0] as they currently
> do because a shrinker will only ever be one or the other, but we
> still need shrink_slab_memcg() to have per-memcg nr_deferred values
> because simple shrinkers can still be MEMCG_AWARE.
> 
> This makes it simpler to see the different calling contexts of
> shrinkers, and easier for the calling code to call the correct
> shrinker context with the correct state.  It also makes it easier to
> pull memcg-awareness into the struct shrinker.
> 
> Further, it allows us to solve the dirty/clean shrinker skip
> optimisations in a generic manner, because that can now be stored on
> a per-node or per-memcg basis inside the struct shrinker. It's
> available to all shrinkers, rather than being just a memcg-specific
> optimisation, and it's easy to implement as part of a shrinker list
> walk (i.e. for_each_dirty_shrinker()).

nr_defered has a sense as a problem, but this is another problem, and
its solution doesn't help the problem I'm solving and see in real worloads
(these are just two different problems).

Implementing of shrink_slab_numa() will help /proc/sys/vm/drop_caches
only, which is mostly a debug tool. Not used in real life.

While separating memcg and !memcg -aware shrinkers I've already done
in the patchset.
 
> We can also add simple wrappers like super_mark_shrinker_dirty(sb)
> when we add an item to the LRU in the appropriate places to do the
> work of activating the shrinker.

Yeah, we may do that, if this improves readability for a user. The name
sounds good for me too.
 
> This seems much more appropriate to me, because it fixes the problem
> of scanning/polling too many shrinkers at the shrinker state/context
> level. That makes it generic and not memcg specific so helps
> non-memcg system/workloads, too. It also fixes existing call-to-call
> shrinker state problems that memcg reclaim currently causes and so
> there's multiple levels of win here. Once this is all sorted out,
> then we can deal with the subsystem shrinker behaviour knowing it
> doesn't have to work around imbalance and fairness problems in the
> infrastructure....

Currently, all memcg-aware shrinkers are numa-aware too. So, separating
them won't help. While, I've already separated memcg-aware and !memcg-aware
in the patchset.

Kirill
