Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfDXC0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 22:26:32 -0400
Subject: Re: [PATCH 5/9] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-6-allison.henderson@oracle.com>
 <20190418154911.GC2885@bfoster>
 <8be843b1-7a12-57b5-101a-25485261484a@oracle.com>
 <20190422110127.GB55937@bfoster>
 <730071a4-1eeb-b734-e5a1-5eadea7827f5@oracle.com>
 <20190423130043.GB2841@bfoster>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <96e0e31c-439c-4c93-2f87-6595a30915f5@oracle.com>
Date: Tue, 23 Apr 2019 19:24:23 -0700
MIME-Version: 1.0
In-Reply-To: <20190423130043.GB2841@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 4/23/19 6:00 AM, Brian Foster wrote:
> On Mon, Apr 22, 2019 at 03:01:14PM -0700, Allison Henderson wrote:
>>
>>
>> On 4/22/19 4:01 AM, Brian Foster wrote:
>>> On Thu, Apr 18, 2019 at 02:28:00PM -0700, Allison Henderson wrote:
>>>> On 4/18/19 8:49 AM, Brian Foster wrote:
>>>>> On Fri, Apr 12, 2019 at 03:50:32PM -0700, Allison Henderson wrote:
>>>>>> These routines set up set and start a new deferred attribute
>>>>>> operation.  These functions are meant to be called by other
>>>>>> code needing to initiate a deferred attribute operation.  We
>>>>>> will use these routines later in the parent pointer patches.
>>>>>>
>>>>>
>>>>> We probably don't need to reference the parent pointer stuff any more
>>>>> for this, right? I'm assuming we'll be converting generic attr
>>>>> infrastructure over to this mechanism in subsequent patches..?
>>>>
>>>> Right, some of these comments are a little stale.  I will clean then up a
>>>> bit.
>>>>
>>>>>
>>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>>> ---
>>>>>>     fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>     fs/xfs/libxfs/xfs_attr.h |  7 +++++
>>>>>>     2 files changed, 87 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>>> index fadd485..c3477fa7 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> ...
>>>>>> @@ -513,6 +560,39 @@ xfs_attr_remove(
>>>>>>     	return error;
>>>>>>     }
>>>>>> +/* Removes an attribute for an inode as a deferred operation */
>>>>>> +int
>>>>>> +xfs_attr_remove_deferred(
>>>>>
>>>>> Hmm.. I'm kind of wondering if we actually need to defer attr removes.
>>>>> Do we have the same kind of challenges for attr removal as for attr
>>>>> creation, or is there some future scenario where this is needed?
>>>>
>>>> I suppose we don't have to have it?  The motivation was to help break up the
>>>> amount of transaction activity that happens on inode create/rename/remove
>>>> operations once pptrs go in.  Attr remove does not look as complex as attr
>>>> set, but I suppose it helps to some degree?
>>>>
>>>
>>> Ok, this probably needs more thought. On one hand, I'm not a huge fan of
>>> using complex infrastructure where not required just because it's there.
>>> On the other, it could just be more simple to have consistency between
>>> xattr ops. As you note above, perhaps we do want the ability to defer
>>> xattr removes so we can use it in particular contexts (parent pointer
>>> updates) and not others (direct xattr remove requests from userspace).
>>> Perhaps the right thing to do for the time being is to continue on with
>>> the support for deferred xattr remove but don't invoke it from the
>>> direct xattr remove codepath..?
>>
>> We can do this, but it means we need to keep the "roll_trans" boolean for
>> all code paths that want to retain their original functionality, and also
>> still be able to function as a delayed operation too.
>>
>> It's not a big deal I suppose.  The remove code path does not have as many
>> uses of the boolean.  But I seem to recall people thinking that the boolean
>> was not particularly elegant, so I was careful to point out that it was
>> going away at the end of the set :-)
>>
> 
> Hmm, I was hoping we could refactor the existing code in a way that
> supports both without spreading the boolean all over the place (by
> breaking things down into smaller functional components), but poking
> deeper into the xattr codepath suggests that could get quite hairy and
> might not be worth it. I think it might be reasonable to just leave
> around enough direct functionality for operations that don't require a
> transaction roll. For example, a shortform xattr set just commits the
> transaction if it succeeds. If it fails, we could make the decision to
> defer the operation as we know we're now going to require a tx roll
> anyways. That way a direct xattr set doesn't need to be deferred for no
> reason if it wouldn't otherwise roll, while we still have the ability to
> defer an arbitrary xattr set (even if shortform) for internal things
> like parent pointers where we don't necessarily have an xattr
> transaction.
> 
> Same goes for the shortform remove operation (and perhaps others), which
> could be reused in both direct and deferred contexts because it doesn't
> appear to roll the tx. Note that we don't necessarily have to share the
> exact same xfs_attr_[set|remove]_args() function between direct and
> deferred context. A separate function in the direct path to attempt a
> direct op and then defer and another in the deferred path that covers
> pretty much everything (with fixed up -EAGAIN magic) might be easier to
> manage.

Ok, I think I understand what you're trying to describe here.  I'll see 
if I can separate the areas that need delayed function and try to factor 
out more common code.  I guess I usually try to aim to eliminate code 
with duplicate function just because more code volume tends to generate 
more maintenance.  But if people feel more comfortable having both 
methods I will try and see if I can preserve both.

> 
> All that said, if you'd rather just defer everything for now and
> potentially revisit pulling more things into the direct path later on
> then I think that's perfectly reasonable too. The existing code is
> really kind of a jumbled mess and we stand to benefit just by
> simplifying/organizing it, IMO. I think there's a reasonable argument to
> be made that we're better off working through all of the -EAGAIN stuff
> and working the direct case as an optimization from there.
> 

Alrighty then, perhaps we should focus more on how we want to reorganize 
things for the this EAGAIN handling first, since it might change what we 
decide here.

>>>
>>> Note that if we took that approach, we could add a DEBUG option and/or
>>> an errortag to (randomly) defer xattr removes in the common path for
>>> test coverage purposes.
>>
>> Sure, that would be an easy thing to stitch in.  Once parent pointers go in,
>> delayed attrs will get a lot more exorcise since they will be a part of
>> inode create/move/remove too.
>>
> 
> Note that I think this would only be warranted if there was no other way
> to invoke the deferred path directly from userspace (for testing). If we
> did a deferred fallback approach like the above or just resort to
> deferring everything, then we'll defer plenty (or all) of traditional
> xattr ops and this is probably not necessary.

Sure, I'll find a way to make sure it gets a thorough work out depending 
on what we end up with.  We can take always take the error tag back out 
once we get to pptrs.

Fwiw, I'm trying to keep the extended pptr set stable on top of this set 
as we go along, just to make sure we don't come up with something that 
causes issues later down the road.  ATM, I'm just limiting the reviews 
to a smaller set because I know bandwidth is limited, and if we can keep 
focused here maybe we can get through the bigger picture in smaller 
chunks :-)

Thx for the feedback!
Allison
> 
> Brian
> 
>> Allison
>>
>>>
>>> Brian
>>>
>>>>>
>>>>>> +	struct xfs_inode        *dp,
>>>>>> +	struct xfs_trans	*tp,
>>>>>> +	const unsigned char	*name,
>>>>>> +	unsigned int		namelen,
>>>>>> +	int                     flags)
>>>>>> +{
>>>>>> +
>>>>>> +	struct xfs_attr_item	*new;
>>>>>> +	char			*name_value;
>>>>>> +
>>>>>> +	if (!namelen) {
>>>>>> +		ASSERT(0);
>>>>>> +		return -EFSCORRUPTED;
>>>>>
>>>>> Similar comment around -EFSCORRUPTED vs. -EINVAL (or something else..).
>>>> Ok, I will change to EINVAL here too.
>>>>
>>>> Thanks again for the reviews!!  They are very helpful!
>>>>
>>>> Allison
>>>>>
>>>>> Brian
>>>>>
>>>>>> +	}
>>>>>> +
>>>>>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
>>>>>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>>>>>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
>>>>>> +	new->xattri_ip = dp;
>>>>>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
>>>>>> +	new->xattri_name_len = namelen;
>>>>>> +	new->xattri_value_len = 0;
>>>>>> +	new->xattri_flags = flags;
>>>>>> +	memcpy(name_value, name, namelen);
>>>>>> +
>>>>>> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>>     /*========================================================================
>>>>>>      * External routines when attribute list is inside the inode
>>>>>>      *========================================================================*/
>>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>>>> index 92d9a15..83b3621 100644
>>>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>>>> @@ -175,5 +175,12 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>>>>>     int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>>>>>     			const unsigned char *name, size_t namelen, int flags);
>>>>>>     int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>>>>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>>>>> +			  const unsigned char *name, unsigned int name_len,
>>>>>> +			  const unsigned char *value, unsigned int valuelen,
>>>>>> +			  int flags);
>>>>>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>>>>> +			    const unsigned char *name, unsigned int namelen,
>>>>>> +			    int flags);
>>>>>>     #endif	/* __XFS_ATTR_H__ */
>>>>>> -- 
>>>>>> 2.7.4
>>>>>>
