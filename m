Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0110.outbound.protection.outlook.com ([104.47.2.110]:11824
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932804AbeCSLZS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Mar 2018 07:25:18 -0400
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
From: Kirill Tkhai <ktkhai@virtuozzo.com>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
 <20180315230313.GM18129@dastard>
 <6628c551-f607-367b-1ee6-f458266c1d92@virtuozzo.com>
 <20180316213910.GF7000@dastard>
 <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
Message-ID: <435c3d64-7806-8a85-fdab-30d8bdabcd45@virtuozzo.com>
Date: Mon, 19 Mar 2018 14:25:11 +0300
MIME-Version: 1.0
In-Reply-To: <18a031f3-2136-4ef9-6ede-05f5b835661c@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On 19.03.2018 14:06, Kirill Tkhai wrote:
> On 17.03.2018 00:39, Dave Chinner wrote:
>> On Fri, Mar 16, 2018 at 11:55:30AM +0300, Kirill Tkhai wrote:
>>> On 16.03.2018 02:03, Dave Chinner wrote:
>>>> On Thu, Mar 15, 2018 at 10:28:43PM +0300, Kirill Tkhai wrote:
>>>>> On 15.03.2018 20:49, Michal Hocko wrote:
>>>>>> On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
>>>>>>> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
>>>>>>> So, it's called for memcg reclaim too, e.g. this list is shrinked
>>>>>>> disproportionality to another lists.
>>>>>>>
>>>>>>> This looks confusing, so I'm reporting about this.
>>>>>>> Consider this patch as RFC.
>>>>>>
>>>>>> Could you be more specific about the problem you are trying to solve?
>>>>>> Because we do skip shrinkers which are not memcg aware by
>>>>>> shrink_slab:
>>>>>> 		/*
>>>>>> 		 * If kernel memory accounting is disabled, we ignore
>>>>>> 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
>>>>>> 		 * passing NULL for memcg.
>>>>>> 		 */
>>>>>> 		if (memcg_kmem_enabled() &&
>>>>>> 		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
>>>>>> 			continue;
>>>>>>
>>>>>> Or am I missing something?
>>>>>
>>>>> sb->s_op->nr_cached_objects is a sub-method of generic super_cache_count().
>>>>> super_cache_count() is owned and only called by superblock's shrinker,
>>>>> which does have SHRINKER_MEMCG_AWARE flag.
>>>>
>>>> Xfs inodes are accounted to memcgs when they are allocated.  All the
>>>> memcg reclaim stuff is done at the VFS inode cache level - all the
>>>> XFS inode cache shrinker does is clean up inodes that are not
>>>> referenced by the VFS inode cache because the memcg aware reclaim
>>>> has already freed them.
>>>>
>>>> i.e. what the XFS inode cache is doing is perfectly reasonable -
>>>> memcg aware inode reclaim is occuring at the VFS level, but on XFS
>>>> that does not free the inodes as they are still referenced
>>>> internally by XFS. However, once the inode is removed from the VFS
>>>> LRU, all memcg information about the inode is destroyed, so there's
>>>> nothing in the XFS layers that cares about memcgs.
>>>
>>> So, after inode is removed from LRU, memory still remains accounted
>>> to memcg till the time they are actually freed. I personally don't
>>> care, just to mention.
>>>  
>>>> Hence when the XFS inode shrinker then called to run a
>>>> garbage collection pass on unreferenced inodes - the inodes that
>>>> are now unreferenced in the memcg due to the VFS inode shrinker pass
>>>> - it frees inodes regardless of the memcg context it was called from
>>>> because that information is no longer present in the inode cache.
>>>> Hence we just ignore memcgs at this level.
>>>
>>> But xfs_fs_free_cached_objects() returns number of these freed object
>>> as result to super_cache_scan(), so shrinker interprets them as related
>>> to a memcg, while they may be related to another memcg. This introduces
>>> a disproportion relatively to another shrinkers called to memcg.
>>
>> In what way? All memcgs see tha same values from the backing cache
>> and so try to do the same amount of scanning work. The shrinker
>> accounting simply doesn't care where the objects are scanned from,
>> as long as it comes from the same place as the calculation of the
>> number of objects in the cache it's about to scan.
> 
> shrinker->count_objects() result is used to count number of objects,
> do_shrink_slab() should shrink during the call:
> 
>         freeable = shrinker->count_objects(shrinker, shrinkctl);
> 
> Then shrinker takes part of this value:
> 
>         delta = freeable >> priority;
>         delta *= 4;
>         do_div(delta, shrinker->seeks);
> 
> This is a number, the shrinker tries to shrink during the call.
> Let the priority is DEF_PRIORITY. Then, shrinker try to shrink
> freeable*4/(shrinker->seeks * 2^DEF_PRIORITY) enteties from every
> shrinker. Equal percent of every memcg shrinker.
> 
> When XFS shows global number of cached objects in count_objects(),
> shrinker also tryes to shrink the same percent of global objects,
> as for other memcg shrinkers. So, when you have small memcg
> with 128Mb memory allowed and small number of tasks related to it,
> you may meet 1Gb of cached objects, which were queued by another
> big cgroup. So, the small cgroup may shrink number of objects of
> size more, then its own. It's not fair. That's all I'm worry in
> this message.
>  
>> The memcg accounting, OTOH, is completely divorced from the
>> shrinker, so if it's still got too much slab memory accounted to it,
>> it will simply run the shrinker again and do some more memory
>> reclaim.
> 
> This message is not about OOM, it's about imbalance. See above.
> 
>> XFS does this for IO efficiency purposes, not because it's ideal
>> behaviour for memcgs. If we start doing exact memcg-only inode
>> reclaim, we're going back to the bad old days where inode reclaim
>> causes really nasty small random write storms that essentially
>> starve the storage subsystem of all other IO for seconds at a time.
>> That is a *far worse problem* from a system performance POV than
>> having the memcg memory reclaim run a couple more shrinker passes
>> and do a little more work....
> 
> Ok, this is a point.
> 
>>> Is there a problem? This is what my patch about.
>>
>> You've described some theoretical issue, but not described any user
>> visible or performance impacting behaviour that users actually care
>> about. What reproducable, observable behaviour does it fix/change?
> 
> Strange question. Do you fix problems only when you meet a reproducable
> BUG()? This is the kernel, and many problem may be racy. But this
> does not mean, it's prohibited to discuss about them.
> 
>>>> So, is there a problem you are actually trying to fix, or is this
>>>> simply a "I don't understand how the superblock shrinkers work,
>>>> please explain" patch?
>>>
>>> I work on some shrinker changes, and just want to understand they don't
>>> touch anything. 
>>
>> Oh, goody, another person about to learn the hard way that shrinkers
>> are far more varied and complex than page reclaim :P
> 
> It may be a surprise, but I have to say, that all memcg-aware shrinkers
> are based on list_lrus. XFS is exception. So, your words are not about
> shrinkers in general, just about XFS.

Just to clarify. I personally do not care about this problem. Consider
this as RFC/possible error report. If you are not interested in this,
let's stop the discussion.

Kirill
