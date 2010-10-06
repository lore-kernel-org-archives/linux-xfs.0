Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96Nl8iN130687 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 18:47:08 -0500
Message-ID: <4CAD0A5C.7030005@kernel.org>
Date: Wed, 06 Oct 2010 16:46:36 -0700
From: "J.H." <warthog9@kernel.org>
MIME-Version: 1.0
Subject: Re: [patch] xfs: properly account for reclaimed inodes
References: <20101001074354.GF2618@cmpxchg.org>
	<1285953443.2422.4.camel@doink> <20101004071904.GH4681@dastard>
	<20101004102213.GJ2618@cmpxchg.org>
	<20101006045349.GA13191@dastard>
In-Reply-To: <20101006045349.GA13191@dastard>
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
Cc: stable@kernel.org, xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

On 10/05/2010 09:53 PM, Dave Chinner wrote:
> On Mon, Oct 04, 2010 at 12:22:13PM +0200, Johannes Weiner wrote:
>> Hi,
>>
>> On Mon, Oct 04, 2010 at 06:19:04PM +1100, Dave Chinner wrote:
>>> On Fri, Oct 01, 2010 at 12:17:23PM -0500, Alex Elder wrote:
>>>> On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
>>>>> When marking an inode reclaimable, a per-AG counter is increased, the
>>>>> inode is tagged reclaimable in its per-AG tree, and, when this is the
>>>>> first reclaimable inode in the AG, the AG entry in the per-mount tree
>>>>> is also tagged.
>>>>>
>>>>> When an inode is finally reclaimed, however, it is only deleted from
>>>>> the per-AG tree.  Neither the counter is decreased, nor is the parent
>>>>> tree's AG entry untagged properly.
>>>>>
>>>>> Since the tags in the per-mount tree are not cleared, the inode
>>>>> shrinker iterates over all AGs that have had reclaimable inodes at one
>>>>> point in time.
>>>>>
>>>>> The counters on the other hand signal an increasing amount of slab
>>>>> objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
>>>>> per-filesystem context" this is not a real issue anymore because the
>>>>> shrinker bails out after one iteration.
>>>>>
>>>>> But the problem was observable on a machine running v2.6.34, where the
>>>>> reclaimable work increased and each process going into direct reclaim
>>>>> eventually got stuck on the xfs inode shrinking path, trying to scan
>>>>> several million objects.
>>>>>
>>>>> Fix this by properly unwinding the reclaimable-state tracking of an
>>>>> inode when it is reclaimed.
>>>>>
>>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>> Cc: stable@kernel.org
>>>>
>>>> Yes, this looks right to me.  The state was correctly
>>>> adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
>>>> inode is found in the cache, but it was not done when
>>>> reclaim completes.
>>>>
>>>> Reviewed-by: Alex Elder <aelder@sgi.com>
>>>
>>> Alex, can you push this to Linus ASAP? This needs to go back to
>>> stable kernels as well..
>>
>> Here is my suggestion of a backport to .34.  Dave, Alex, do you
>> approve?
>>
>> 	Hannes
>>
>> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
>> index 6845db9..3314f2a 100644
>> --- a/fs/xfs/xfs_iget.c
>> +++ b/fs/xfs/xfs_iget.c
>> @@ -499,6 +499,7 @@ xfs_ireclaim(
>>  	write_lock(&pag->pag_ici_lock);
>>  	if (!radix_tree_delete(&pag->pag_ici_root, agino))
>>  		ASSERT(0);
>> +	pag->pag_ici_reclaimable--;
>>  	write_unlock(&pag->pag_ici_lock);
>>  	xfs_perag_put(pag);
> 
> Looks good to me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

i've got this in production and things seem to be acting a lot more like
I would expect.

Tested-by: John 'Warthog9' Hawley <warthog9@kernel.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
