Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41944 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfDXCY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 22:24:57 -0400
Subject: Re: [PATCH 7/9] xfs: Add attr context to log item
References: <20190412225036.22939-1-allison.henderson@oracle.com>
 <20190412225036.22939-8-allison.henderson@oracle.com>
 <20190422130338.GB56876@bfoster>
 <e60582d4-289d-92be-21d0-1d83d37bbd22@oracle.com>
 <20190423132024.GC2841@bfoster>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ae2f758b-fe03-23b9-4080-8763296258b0@oracle.com>
Date: Tue, 23 Apr 2019 19:24:40 -0700
MIME-Version: 1.0
In-Reply-To: <20190423132024.GC2841@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org


On 4/23/19 6:20 AM, Brian Foster wrote:
> On Mon, Apr 22, 2019 at 03:01:27PM -0700, Allison Henderson wrote:
>>
>>
>> On 4/22/19 6:03 AM, Brian Foster wrote:
>>> On Fri, Apr 12, 2019 at 03:50:34PM -0700, Allison Henderson wrote:
>>>> This patch modifies xfs_attr_item to store a xfs_da_args, a xfs_buf pointer
>>>> and a new state type. We will use these in the next patch when
>>>> we modify xfs_set_attr_args to roll transactions by returning EAGAIN.
>>>> Because the subroutines of this function modify the contents of these
>>>> structures, we need to find a place to store them where they remain
>>>> instantiated across multiple calls to xfs_set_attr_args.
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>
>>> I see Darrick has already commented on the whole state thing. I'll
>>> probably have to grok the next patch to comment further, but just a
>>> couple initial thoughts:
>>>
>>> First, I hit a build failure with this patch. It looks like there's a
>>> missed include in the scrub code:
>>>
>>>     ...
>>>     CC [M]  fs/xfs/scrub/repair.o
>>> In file included from fs/xfs/scrub/repair.c:32:
>>> fs/xfs/libxfs/xfs_attr.h:105:21: error: field ‘xattri_args’ has incomplete type
>>>     struct xfs_da_args xattri_args;   /* args context */
>> Hmm, ok.  I'll get that corrected, I probably need to clean out my workspace
>> and build from scratch.
>>
>>>     ...
>>>
>>> Second, the commit log suggests that the states will reflect the current
>>> transaction roll points (i.e., establishing re-entry points down in
>>> xfs_attr_set_args(). I'm kind of wondering if we should break these
>>> xattr set sub-sequences down into smaller helper functions (refactoring
>>> the existing code as we go) such that the mechanism could technically be
>>> used deferred or not. Re: the previous thought on whether to defer xattr
>>> removes or not, there might also be cases where there's not a need to
>>> defer xattr sets.
>>>
>>> E.g., taking a quick peek into the next patch, the state 1 case in
>>> xfs_attr_try_sf_addname() is actually a transaction commit, which I
>>> think means we're done. We'd have done an attr memory allocation,
>>> deferred op and transaction roll where none was necessary so it might
>>> not be worth it to defer in that scenario. Hmm, it also looks like we
>>> return -EAGAIN in places where we've not actually done any work, like if
>>> a shortform add attempt returns -ENOSPC (or the -EAGAIN return before we
>>> even attempt the sf add). That kind of looks like a waste of transaction
>>> rolls and further suggests it might be cleaner to break this whole path
>>> down into helpers and put it back together in a way more conducive to
>>> deferred operations.
>>
>> Yes, this area is a bit of a wart the way it is right now.  I think you're
>> right in that ultimately we may end up having to do a lot of refactoring in
>> order to have more efficient "re-entry points".  The state machine is hard
>> to get into subroutines, so it's limited in use in the top level function.
>>
>> I was also starting to wonder if maybe I could do some refactoring in
>> xfs_defer_finish_noroll to capture the common code associated with the
>> -EAGAIN handling.  Then maybe we could make a function pointer that we can
>> pass through the finish_item interface.  The idea being that subroutines
>> could use the function pointer to cycle out the transaction when needed
>> instead of having to record states and back out like this. It'd be a new
>> parameter to pipe around, but it'd be more efficient than the state machine,
>> and less surgery in the refactor.  And maybe a blessing to any other
>> operations that might need to go through this transition in the future.
>> Thoughts?
>>
> 
> That's an interesting idea. It still strikes me as a bit of a
> fallback/hack as opposed to organizing the code to properly fit into the
> dfops infrastructure, but it could be useful as a transient solution.
>  From a high level, it looks like we'd have to create a new intent, relog
> this item and all remaining items associated with the dfp to it, roll
> the tx, and finally create a done item associated with the intent in the
> new tx. You'd need access to the dfp for some of that, so it's not
> immediately clear to me that this ends up much easier than fixing up
> the xattr code.
> 
> BTW, if we did end up with something like that I'd probably prefer to
> see it as an exported dfops helper function as opposed to a function
> pointer being passed around, if possible.
> 

Alrighty, I think for now I may try to pursue something more like what 
you proposed in the next patch and see where I get first.  Maybe I'll 
come back to this later if for some reason it doesn't work out, but I 
think what you have there is reasonable.

Thanks again for the reviews!
Allison

> Brian
> 
>> Thanks again for the reviews!
>>
>> Allison
>>
>>>
>>> Brian
>>>
>>>
>>>>    fs/xfs/libxfs/xfs_attr.h | 18 +++++++++++++++++-
>>>>    fs/xfs/scrub/common.c    |  2 ++
>>>>    fs/xfs/xfs_acl.c         |  2 ++
>>>>    fs/xfs/xfs_attr_item.c   |  2 +-
>>>>    fs/xfs/xfs_ioctl.c       |  2 ++
>>>>    fs/xfs/xfs_ioctl32.c     |  2 ++
>>>>    fs/xfs/xfs_iops.c        |  1 +
>>>>    fs/xfs/xfs_xattr.c       |  1 +
>>>>    8 files changed, 28 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 974c963..4ce3b0a 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -77,6 +77,13 @@ typedef struct attrlist_ent {	/* data from attr_list() */
>>>>    	char	a_name[1];	/* attr name (NULL terminated) */
>>>>    } attrlist_ent_t;
>>>> +/* Attr state machine types */
>>>> +enum xfs_attr_state {
>>>> +	XFS_ATTR_STATE1 = 1,
>>>> +	XFS_ATTR_STATE2 = 2,
>>>> +	XFS_ATTR_STATE3 = 3,
>>>> +};
>>>> +
>>>>    /*
>>>>     * List of attrs to commit later.
>>>>     */
>>>> @@ -88,7 +95,16 @@ struct xfs_attr_item {
>>>>    	void		  *xattri_name;	      /* attr name */
>>>>    	uint32_t	  xattri_name_len;    /* length of name */
>>>>    	uint32_t	  xattri_flags;       /* attr flags */
>>>> -	struct list_head  xattri_list;
>>>> +
>>>> +	/*
>>>> +	 * Delayed attr parameters that need to remain instantiated
>>>> +	 * across transaction rolls during the defer finish
>>>> +	 */
>>>> +	struct xfs_buf		*xattri_leaf_bp;  /* Leaf buf to release */
>>>> +	enum xfs_attr_state	xattri_state;	  /* state machine marker */
>>>> +	struct xfs_da_args	xattri_args;	  /* args context */
>>>> +
>>>> +	struct list_head	xattri_list;
>>>>    	/*
>>>>    	 * A byte array follows the header containing the file name and
>>>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>>>> index 0c54ff5..270c32e 100644
>>>> --- a/fs/xfs/scrub/common.c
>>>> +++ b/fs/xfs/scrub/common.c
>>>> @@ -30,6 +30,8 @@
>>>>    #include "xfs_rmap_btree.h"
>>>>    #include "xfs_log.h"
>>>>    #include "xfs_trans_priv.h"
>>>> +#include "xfs_da_format.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_reflink.h"
>>>>    #include "scrub/xfs_scrub.h"
>>>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>>>> index 142de8d..9b1b93e 100644
>>>> --- a/fs/xfs/xfs_acl.c
>>>> +++ b/fs/xfs/xfs_acl.c
>>>> @@ -10,6 +10,8 @@
>>>>    #include "xfs_mount.h"
>>>>    #include "xfs_inode.h"
>>>>    #include "xfs_acl.h"
>>>> +#include "xfs_da_format.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_trace.h"
>>>>    #include <linux/slab.h>
>>>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>>>> index 0ea19b4..36e6d1e 100644
>>>> --- a/fs/xfs/xfs_attr_item.c
>>>> +++ b/fs/xfs/xfs_attr_item.c
>>>> @@ -19,10 +19,10 @@
>>>>    #include "xfs_rmap.h"
>>>>    #include "xfs_inode.h"
>>>>    #include "xfs_icache.h"
>>>> -#include "xfs_attr.h"
>>>>    #include "xfs_shared.h"
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_da_btree.h"
>>>> +#include "xfs_attr.h"
>>>>    static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
>>>>    {
>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>> index ab341d6..c8728ca 100644
>>>> --- a/fs/xfs/xfs_ioctl.c
>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>> @@ -16,6 +16,8 @@
>>>>    #include "xfs_rtalloc.h"
>>>>    #include "xfs_itable.h"
>>>>    #include "xfs_error.h"
>>>> +#include "xfs_da_format.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_bmap.h"
>>>>    #include "xfs_bmap_util.h"
>>>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>>>> index 5001dca..23f6990 100644
>>>> --- a/fs/xfs/xfs_ioctl32.c
>>>> +++ b/fs/xfs/xfs_ioctl32.c
>>>> @@ -21,6 +21,8 @@
>>>>    #include "xfs_fsops.h"
>>>>    #include "xfs_alloc.h"
>>>>    #include "xfs_rtalloc.h"
>>>> +#include "xfs_da_format.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_ioctl.h"
>>>>    #include "xfs_ioctl32.h"
>>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>>> index e73c21a..561c467 100644
>>>> --- a/fs/xfs/xfs_iops.c
>>>> +++ b/fs/xfs/xfs_iops.c
>>>> @@ -17,6 +17,7 @@
>>>>    #include "xfs_acl.h"
>>>>    #include "xfs_quota.h"
>>>>    #include "xfs_error.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_trans.h"
>>>>    #include "xfs_trace.h"
>>>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>>>> index 3013746..938e81d 100644
>>>> --- a/fs/xfs/xfs_xattr.c
>>>> +++ b/fs/xfs/xfs_xattr.c
>>>> @@ -11,6 +11,7 @@
>>>>    #include "xfs_mount.h"
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_inode.h"
>>>> +#include "xfs_da_btree.h"
>>>>    #include "xfs_attr.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_acl.h"
>>>> -- 
>>>> 2.7.4
>>>>
