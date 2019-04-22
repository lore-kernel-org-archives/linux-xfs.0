Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57356 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727588AbfDVWBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Apr 2019 18:01:33 -0400
Subject: Re: [PATCH 5/9] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-6-allison.henderson@oracle.com>
 <20190418154911.GC2885@bfoster>
 <8be843b1-7a12-57b5-101a-25485261484a@oracle.com>
 <20190422110127.GB55937@bfoster>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <730071a4-1eeb-b734-e5a1-5eadea7827f5@oracle.com>
Date: Mon, 22 Apr 2019 15:01:14 -0700
MIME-Version: 1.0
In-Reply-To: <20190422110127.GB55937@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org



On 4/22/19 4:01 AM, Brian Foster wrote:
> On Thu, Apr 18, 2019 at 02:28:00PM -0700, Allison Henderson wrote:
>> On 4/18/19 8:49 AM, Brian Foster wrote:
>>> On Fri, Apr 12, 2019 at 03:50:32PM -0700, Allison Henderson wrote:
>>>> These routines set up set and start a new deferred attribute
>>>> operation.  These functions are meant to be called by other
>>>> code needing to initiate a deferred attribute operation.  We
>>>> will use these routines later in the parent pointer patches.
>>>>
>>>
>>> We probably don't need to reference the parent pointer stuff any more
>>> for this, right? I'm assuming we'll be converting generic attr
>>> infrastructure over to this mechanism in subsequent patches..?
>>
>> Right, some of these comments are a little stale.  I will clean then up a
>> bit.
>>
>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/xfs/libxfs/xfs_attr.h |  7 +++++
>>>>    2 files changed, 87 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index fadd485..c3477fa7 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>>>> @@ -513,6 +560,39 @@ xfs_attr_remove(
>>>>    	return error;
>>>>    }
>>>> +/* Removes an attribute for an inode as a deferred operation */
>>>> +int
>>>> +xfs_attr_remove_deferred(
>>>
>>> Hmm.. I'm kind of wondering if we actually need to defer attr removes.
>>> Do we have the same kind of challenges for attr removal as for attr
>>> creation, or is there some future scenario where this is needed?
>>
>> I suppose we don't have to have it?  The motivation was to help break up the
>> amount of transaction activity that happens on inode create/rename/remove
>> operations once pptrs go in.  Attr remove does not look as complex as attr
>> set, but I suppose it helps to some degree?
>>
> 
> Ok, this probably needs more thought. On one hand, I'm not a huge fan of
> using complex infrastructure where not required just because it's there.
> On the other, it could just be more simple to have consistency between
> xattr ops. As you note above, perhaps we do want the ability to defer
> xattr removes so we can use it in particular contexts (parent pointer
> updates) and not others (direct xattr remove requests from userspace).
> Perhaps the right thing to do for the time being is to continue on with
> the support for deferred xattr remove but don't invoke it from the
> direct xattr remove codepath..?

We can do this, but it means we need to keep the "roll_trans" boolean 
for all code paths that want to retain their original functionality, and 
also still be able to function as a delayed operation too.

It's not a big deal I suppose.  The remove code path does not have as 
many uses of the boolean.  But I seem to recall people thinking that the 
boolean was not particularly elegant, so I was careful to point out that 
it was going away at the end of the set :-)

> 
> Note that if we took that approach, we could add a DEBUG option and/or
> an errortag to (randomly) defer xattr removes in the common path for
> test coverage purposes.

Sure, that would be an easy thing to stitch in.  Once parent pointers go 
in, delayed attrs will get a lot more exorcise since they will be a part 
of inode create/move/remove too.

Allison

> 
> Brian
> 
>>>
>>>> +	struct xfs_inode        *dp,
>>>> +	struct xfs_trans	*tp,
>>>> +	const unsigned char	*name,
>>>> +	unsigned int		namelen,
>>>> +	int                     flags)
>>>> +{
>>>> +
>>>> +	struct xfs_attr_item	*new;
>>>> +	char			*name_value;
>>>> +
>>>> +	if (!namelen) {
>>>> +		ASSERT(0);
>>>> +		return -EFSCORRUPTED;
>>>
>>> Similar comment around -EFSCORRUPTED vs. -EINVAL (or something else..).
>> Ok, I will change to EINVAL here too.
>>
>> Thanks again for the reviews!!  They are very helpful!
>>
>> Allison
>>>
>>> Brian
>>>
>>>> +	}
>>>> +
>>>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(namelen, 0), KM_SLEEP|KM_NOFS);
>>>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>>>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, 0));
>>>> +	new->xattri_ip = dp;
>>>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
>>>> +	new->xattri_name_len = namelen;
>>>> +	new->xattri_value_len = 0;
>>>> +	new->xattri_flags = flags;
>>>> +	memcpy(name_value, name, namelen);
>>>> +
>>>> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>    /*========================================================================
>>>>     * External routines when attribute list is inside the inode
>>>>     *========================================================================*/
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 92d9a15..83b3621 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -175,5 +175,12 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>>>    int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>>>    			const unsigned char *name, size_t namelen, int flags);
>>>>    int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>>> +			  const unsigned char *name, unsigned int name_len,
>>>> +			  const unsigned char *value, unsigned int valuelen,
>>>> +			  int flags);
>>>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>>>> +			    const unsigned char *name, unsigned int namelen,
>>>> +			    int flags);
>>>>    #endif	/* __XFS_ATTR_H__ */
>>>> -- 
>>>> 2.7.4
>>>>
