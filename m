Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36136 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753668AbcLPBjy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 20:39:54 -0500
Subject: Re: [PATCH 1/3] xfs_repair: fix some potential null pointer
 deferences
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <e50f0bdd-9555-2c67-781c-362b4140e431@sandeen.net>
 <20161216005849.GF5357@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f6d495fe-2284-e37f-79a1-42ed1f31ad01@sandeen.net>
Date: Thu, 15 Dec 2016 19:39:52 -0600
MIME-Version: 1.0
In-Reply-To: <20161216005849.GF5357@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 12/15/16 6:58 PM, Darrick J. Wong wrote:
> On Thu, Dec 15, 2016 at 05:17:14PM -0600, Eric Sandeen wrote:
>> On 12/15/16 12:11 PM, Darrick J. Wong wrote:
>>> Fix some potential NULL pointer deferences that Coverity pointed out,
>>> and remove a trivial dead integer check.
>>>
>>> Coverity-id: 1375789, 1375790, 1375791, 1375792
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>>  repair/phase5.c |    2 +-
>>>  repair/rmap.c   |    2 +-
>>>  repair/slab.h   |    2 +-
>>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>>
>>> diff --git a/repair/phase5.c b/repair/phase5.c
>>> index 3604d1d..cbda556 100644
>>> --- a/repair/phase5.c
>>> +++ b/repair/phase5.c
>>> @@ -1925,7 +1925,7 @@ _("Insufficient memory to construct refcount cursor."));
>>>  	refc_rec = pop_slab_cursor(refc_cur);
>>>  	lptr = &btree_curs->level[0];
>>>  
>>> -	for (i = 0; i < lptr->num_blocks; i++)  {
>>> +	for (i = 0; i < lptr->num_blocks && refc_rec != NULL; i++)  {
>>
>> Ok, you sent this patch already as well :)
>>
>> And it matches the exact same thing that exists for a while in
>> the rmap_tree builder, so yay for that.  :)
>>
>> but is this just shutting up coverity, or is this something that could
>> happen?  If it /does/ happen, is skipping the loop all we really need
>> to do?  Sorry - I have to think harder about what's going on in here
>> as we build the tree, but maybe you already know. 
> 
> It's just shutting Coverity up -- we should always run out of num_blocks
> before pop_slab_cursor runs out of records to put in the leaf blocks and
> returns NULL.  init_{rmap,refcount}bt_cursor does the following:
> 
> num_recs = {rmap,refcount}_record_count(...);
> lptr->num_blocks = (num_recs + maxrecs - 1) / maxrecs;
> 
> But there's no harm in sanity checking just in case this ever becomes
> untrue.

I wonder if an ASSERT would also shut Coverity up - that'd communicate
to coverity that we can't ever deref a null ptr, but also communicates
to the reader that a null ptr is not expected (better than a test
in a loop, which looks like maybe it is expected...)

/me wishes covscan allowed scratch builds to test

-Eric

>> My sense of tidiness and consistency is bothered by the fact that
>> we don't have similar null-check-skip-loop for, say, ino_rec
>> in build_ino_tree, or ext_ptr in build_freespace_tree.
> 
> The other tree builders don't use slabs, so the loops are different.
> 
> --D
> 
>>
>>
>>>  		/*
>>>  		 * block initialization, lay in block header
>>>  		 */
>>> diff --git a/repair/rmap.c b/repair/rmap.c
>>> index 45e183a..7508973 100644
>>> --- a/repair/rmap.c
>>> +++ b/repair/rmap.c
>>> @@ -790,7 +790,7 @@ compute_refcounts(
>>>  		mark_inode_rl(mp, stack_top);
>>>  
>>>  		/* Set nbno to the bno of the next refcount change */
>>> -		if (n < slab_count(rmaps))
>>> +		if (n < slab_count(rmaps) && array_cur)
>>>  			nbno = array_cur->rm_startblock;
>>>  		else
>>>  			nbno = NULLAGBLOCK;
>>> diff --git a/repair/slab.h b/repair/slab.h
>>> index 4aa5512..a2201f1 100644
>>> --- a/repair/slab.h
>>> +++ b/repair/slab.h
>>> @@ -54,7 +54,7 @@ extern void *bag_item(struct xfs_bag *, size_t);
>>>  
>>>  #define foreach_bag_ptr_reverse(bag, idx, ptr) \
>>>  	for ((idx) = bag_count(bag) - 1, (ptr) = bag_item((bag), (idx)); \
>>> -	     (idx) >= 0 && (ptr) != NULL; \
>>> +	     (ptr) != NULL; \
>>>  	     (idx)--, (ptr) = bag_item((bag), (idx)))
>>>  
>>>  #endif /* SLAB_H_ */
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
