Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS8Jkve152205 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 02:19:46 -0600
Received: from mx2.parallels.com (mx2.parallels.com [64.131.90.16]) by
	cuda.sgi.com with ESMTP id 1IbbEfyHnztYGVsz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 00:22:02 -0800 (PST)
Message-ID: <50B5C9A2.6000408@parallels.com>
Date: Wed, 28 Nov 2012 12:21:54 +0400
From: Glauber Costa <glommer@parallels.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/19] drivers: convert shrinkers to new count/scan API
References: <1354058086-27937-1-git-send-email-david@fromorbit.com>
	<1354058086-27937-18-git-send-email-david@fromorbit.com>
	<b94cdc$7i2bv3@fmsmga001.fm.intel.com>
	<20121128031719.GR6434@dastard>
In-Reply-To: <20121128031719.GR6434@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>

On 11/28/2012 07:17 AM, Dave Chinner wrote:
> On Wed, Nov 28, 2012 at 01:13:11AM +0000, Chris Wilson wrote:
>> On Wed, 28 Nov 2012 10:14:44 +1100, Dave Chinner <david@fromorbit.com> wrote:
>>> +/*
>>> + * XXX: (dchinner) This is one of the worst cases of shrinker abuse I've seen.
>>> + *
>>> + * i915_gem_purge() expects a byte count to be passed, and the minimum object
>>> + * size is PAGE_SIZE.
>>
>> No, purge() expects a count of pages to be freed. Each pass of the
>> shrinker therefore tries to free a minimum of 128 pages.
> 
> Ah, I got the shifts mixed up. I'd been looking at way too much crap
> already when I saw this. But the fact this can be misunderstood says
> something about the level of documentation that the code has (i.e.
> none).
> 
>>> The shrinker doesn't work on bytes - it works on
>>> + * *objects*.
>>
>> And I thought you were reviewing the shrinker API to be useful where a
>> single object may range between 4K and 4G.
> 
> Which requires rewriting all the algorithms to not be dependent on
> the subsystems using a fixed size object. The shrinker control
> function is called shrink_slab() for a reason - it was expected to
> be used to shrink caches of fixed sized objects allocated from slab
> memory.
> 
> It has no concept of the amount of memory that each object consumes,
> just an idea of how much *IO* it takes to replace the object in
> memory once it's been reclaimed. The DEFAULT_SEEKS is design to
> encode the fact it generally takes 2 IOs to replace either a LRU
> page or a filesystem slab object, and so balances the scanning based
> on that value. i.e. the shrinker algorithms are solidly based around
> fixed sized objects that have some relationship to the cost of
> physical IO operations to replace them in the cache.

One nit: It shouldn't take 2IOs to replace a slab object, right? This
should be the cost of allocating a new page, that can contain, multiple
objects.

Once the page is in, a new object should be quite cheap to come up with.

This is a very wild thought, but now that I am diving deep in the
shrinker API, and seeing things like this:

if (reclaim_state) {
    sc->nr_reclaimed += reclaim_state->reclaimed_slab;
    reclaim_state->reclaimed_slab = 0;
}

I am becoming more convinced that we should have a page-based mechanism,
like the rest of vmscan.

Also, if we are seeing pressure from someone requesting user pages, what
good does it make to free, say, 35 Mb of memory, if this means we are
freeing objects across 5k different pages, without actually releasing
any of them? (still is TBD if this is a theoretical problem or a
practical one). It would maybe be better to free objects that are
moderately hot, but are on pages dominated by cold objects...


> 
> The API change is the first step in the path to removing these built
> in assumptions. The current API is just insane and any attempt to
> build on it is going to be futile. 

Amen, brother!

> The way I see this developing is
> this:
> 
> 	- make the shrink_slab count -> scan algorithm per node
> 
pages are per-node.

> 	- add information about size of objects in the cache for
> 	  fixed size object caches.
> 		- the shrinker now has some idea of how many objects
> 		  need to be freed to be able to free a page of
> 		  memory, as well as the relative penalty for
> 		  replacing them.
this is still guesswork, telling how many pages it should free, could
be a better idea.

> 		- tells the shrinker the size of the cache
> 		  in bytes so overall memory footprint of the caches
> 		  can be taken into account

> 	- add new count and scan operations for caches that are
> 	  based on memory used, not object counts
> 		- allows us to use the same count/scan algorithm for
> 		  calculating how much pressure to put on caches
> 		  with variable size objects.

IOW, pages.

> My care factor mostly ends here, as it will allow XFS to corectly
> balance the metadata buffer cache (variable size objects) against the
> inode, dentry and dquot caches which are object based. The next
> steps that I'm about to give you are based on some discussions with
> some MM people over bottles of red wine, so take it with a grain of
> salt...
> 
> 	- calculate a "pressure" value for each cache controlled by a
> 	  shrinker so that the relative memory pressure between
> 	  caches can be compared. This allows the shrinkers to bias
> 	  reclaim based on where the memory pressure is being
> 	  generated
> 

Ok, if a cache is using a lot of memory, this would indicate it has the
dominant workload, right? Should we free from it, or should we free from
the others, so this ones gets the pages it needs?

> 	- start grouping shrinkers into a heirarchy, allowing
> 	  related shrinkers (e.g. all the caches in a memcg) to be
> 	  shrunk according resource limits that can be placed on the
> 	  group. i.e. memory pressure is proportioned across
> 	  groups rather than many individual shrinkers.
> 
pages are already grouped like that!

> 	- comments have been made to the extent that with generic
> 	  per-node lists and a node aware shrinker, all of the page
> 	  scanning could be driven by the shrinker infrastructure,
> 	  rather than the shrinkers being driven by how many pages
> 	  in the page cache just got scanned for reclaim.
> 
> 	  IOWs, the main memory reclaim algorithm walks all the
> 	  shrinkers groups to calculate overall memory pressure,
> 	  calculate how much reclaim is necessary, and then
> 	  proportion reclaim across all the shrinker groups. i.e.
> 	  everything is a shrinker.
> 
> This patch set is really just the start of a long process. balance
> between the page cache and VFS/filesystem shrinkers is critical to
> the efficient operation of the OS under many, many workloads, so I'm
> not about to change more than oe little thing at a time. This API
> change is just one little step. You'll get what you want eventually,
> but you're not going to get it as a first step.
> 

I have to note again that this is my first *serious* look at the
problem... but this is a summary of what I got, that fits in the context
of this particular discussion =)

I still have to go through all your other patches...

But one thing we seem to agree is that we have quite a long road ahead

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
