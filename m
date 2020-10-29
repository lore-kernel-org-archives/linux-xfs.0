Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC6CEC4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4053420790
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 01:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QZGFf8Zn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgJ2BFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 21:05:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40360 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730007AbgJ2BFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 21:05:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0jmtk044581;
        Thu, 29 Oct 2020 01:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z1k6WBF0Nm0kd0FTgoGY1dr4EuxST2lM2cbZF+IRvNI=;
 b=QZGFf8ZniOHUPK5ieovBhg4UDeUJ1vQr9NDTQxfxFxaNXeJRlIDAg4dfj3CE2iWVUutr
 kxFD7r8LOHW/qxCMxFXGuiZZcho+N1Nsmb8nc0bhCHuwIWO86d9FnllNGFHHVrJadneb
 OAkHsGxj2YvoKBv+IRegeF6uYwZ7nVktO3zYqvwpx1Nh0lBYFiQG0Y75gK2tbMszEeio
 E8Robp2TOOTBHhR7UwgZS2kDYC3CMRfTq5M/G6qRvZ7UeU8/YWaEImNJ2kXeQM83HyCd
 snE49MXdsACiRuu8BDGwVJTnXxcCSF8CmnxjEx1obi7ybLC5DcYUMYhrVyqhYsm5mDpA cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb2g6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 01:05:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T0kMkh192767;
        Thu, 29 Oct 2020 01:03:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1sn14f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 01:03:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09T132sD032656;
        Thu, 29 Oct 2020 01:03:02 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 18:03:02 -0700
Subject: Re: [PATCH v13 02/10] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-3-allison.henderson@oracle.com>
 <20201027121645.GB1560077@bfoster>
 <95c25c2e-c7b2-cfa0-51e3-129a0df7f828@oracle.com>
 <20201028122841.GA1611922@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <8dd4fc7a-f432-2c42-91d6-c055d4b1154f@oracle.com>
Date:   Wed, 28 Oct 2020 18:03:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201028122841.GA1611922@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/28/20 5:28 AM, Brian Foster wrote:
> On Tue, Oct 27, 2020 at 03:27:20PM -0700, Allison Henderson wrote:
>>
>>
>> On 10/27/20 5:16 AM, Brian Foster wrote:
>>> On Thu, Oct 22, 2020 at 11:34:27PM -0700, Allison Henderson wrote:
>>>> This patch modifies the attr remove routines to be delay ready. This
>>>> means they no longer roll or commit transactions, but instead return
>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>> uses a sort of state machine like switch to keep track of where it was
>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>> consists of a simple loop to refresh the transaction until the operation
>>>> is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
>>>> transaction where ever the existing code used to.
>>>>
>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>> version __xfs_attr_rmtval_remove. We will rename
>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>> done.
>>>>
>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>> during a rename).  For reasons of preserving existing function, we
>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>> used and will be removed.
>>>>
>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>> to keep track of the current state of an attribute operation. The new
>>>> xfs_delattr_state enum is used to track various operations that are in
>>>> progress so that we know not to repeat them, and resume where we left
>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>> members take the place of local variables that need to retain their
>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>> detailed diagram of the states.
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c        | 200 +++++++++++++++++++++++++++++-----------
>>>>    fs/xfs/libxfs/xfs_attr.h        |  72 +++++++++++++++
>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>>>    fs/xfs/libxfs/xfs_attr_remote.c |  37 ++++----
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>>>    fs/xfs/xfs_attr_inactive.c      |   2 +-
>>>>    6 files changed, 241 insertions(+), 74 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index f4d39bf..6ca94cb 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>>>> @@ -1282,31 +1356,53 @@ xfs_attr_node_remove_step(
>>>>     *
>>>>     * This routine will find the blocks of the name to remove, remove them and
>>>>     * shirnk the tree if needed.
>>>> + *
>>>> + * This routine is meant to function as either an inline or delayed operation,
>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>> + * functions will need to handle this, and recall the function until a
>>>> + * successful error code is returned.
>>>>     */
>>>>    STATIC int
>>>> -xfs_attr_node_removename(
>>>> -	struct xfs_da_args	*args)
>>>> +xfs_attr_node_removename_iter(
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	struct xfs_da_state	*state;
>>>> -	int			error;
>>>> -	struct xfs_inode	*dp = args->dp;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	struct xfs_da_state		*state;
>>>> +	int				error;
>>>> +	struct xfs_inode		*dp = args->dp;
>>>>    	trace_xfs_attr_node_removename(args);
>>>> +	state = dac->da_state;
>>>> -	error = xfs_attr_node_removename_setup(args, &state);
>>>> -	if (error)
>>>> -		goto out;
>>>> +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
>>>> +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
>>>> +		error = xfs_attr_node_removename_setup(dac, &state);
>>>> +		if (error)
>>>> +			goto out;
>>>> +	}
>>>> -	error = xfs_attr_node_remove_step(args, state);
>>>> -	if (error)
>>>> -		goto out;
>>>> +	switch (dac->dela_state) {
>>>> +	case XFS_DAS_UNINIT:
>>>> +		error = xfs_attr_node_remove_step(dac);
>>>> +		if (error)
>>>> +			break;
>>>
>>> I think there's a bit more preliminary refactoring to do here to isolate
>>> the state management to this one function. I.e., from the discussion on
>>> the previous version, we'd ideally pull the logic that checks for the
>>> subsequent shrink state out of xfs_attr_node_remove_step() and lift it
>>> into this branch. See the pseudocode in the previous discussion for an
>>> example of what I mean:
>>>
>>>     https://urldefense.com/v3/__https://lore.kernel.org/linux-xfs/20200901170020.GC174813@bfoster/__;!!GqivPVa7Brio!JKxU3Z07HVj0V1YFesXrveRWnoGuWqiTZuaIDiG9UFmSxz-aFGsZPpLtjIOjSht7WL_h$
>>>
>>> The general goal of that is to refactor the existing code such that all
>>> of the state transitions and whatnot are shown in one place and the rest
>>> is broken down into smaller functional helpers.
>>>
>>> Brian
>>
>> Yes, I did see the pseudo code, though I wasnt able to get it through the
>> test cases quite the way it appears.  Because whether or not we proceed to
>> shrink is determined by the leaf remove that's burried in the step function.
>> Otherwise we run into some failed asserts in the shrink routines for
>> "state->path.active == 1". Alternatly we can add another helper to pull it
>> up to this scope.  Then the switch ends up looking like this:
>>
> 
> Ok. That was more focused on just showing an approach that collects all
> of the state transition logic in one place. The factoring below seems
> generally reasonable to me..
> 
>>          switch (dac->dela_state) {
>>
>>          case XFS_DAS_UNINIT:
>>
>>                  /*
>>
>>                   * repeatedly remove remote blocks, remove the entry and
>>                   * join. returns -EAGAIN or 0 for completion of the step.
>>                   */
>>
>>                  error = xfs_attr_node_remove_step(dac);
>>
>>                  if (error)
>>
>>                          break;
>>
>>
>>
>>                  retval = xfs_attr_node_remove_cleanup(dac);
>>
>>
>>
>>                  /*
>>
>>                   * Check to see if the tree needs to be collapsed.  Set the
>> flag to
>>                   * indicate that the calling function needs to move the to
>> shrink
>>                   * operation
>>
>>                   */
>>
>>                  if (retval && (state->path.active > 1)) {
>>
>>                          error = xfs_da3_join(state);
>>
>>                          if (error)
>>
>>                                  return error;
>>
>>
>>
>>                          dac->dela_state = XFS_DAS_RM_SHRINK;
>>
>>                          return -EAGAIN;
>>
>>                  }
>>
>>
>>
>>                  /* check whether to shrink or return success */
>>
>>                  if (!error && xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>
>>                          dac->dela_state = XFS_DAS_RM_SHRINK;
>>
>>                          error = -EAGAIN;
>>
>>                  }
> 
> ... though what is the purpose of this hunk? This seems to diverge from
> the current logic, but maybe I'm missing something.
> 
That's just me trying to get as close to the psuedo code as possible, 
but if the concern is just to keep the state management in this scope, I 
may move it back down into the the XFS_DAS_RM_SHRINK case where it was, 
I think it looks a little cleaner there.


>>
>>                  break;
>>
>>          case XFS_DAS_RM_SHRINK:
>>
>>                  /*
>>
>>                   * If the result is small enough, push it all into the
>> inode.
>>                   */
>>
So it would go back down here like this, which is more akin to the 
original code flow:


		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>                  error = xfs_attr_node_shrink(args, state);
>>
>>
>>
>>                  break;
>>
>>          default:
>>
>>                  ASSERT(0);
>>
>>                  return -EINVAL;
>>
>>          }
>>
>>
>>
>>          if (error == -EAGAIN)
>>
>>                  return error;
>>
>>
>>
>>
>>
>> And then we have this little clean up helper that we pull out of
>> remove_step:
>>
>>
>>
>> STATIC int
>>
>> xfs_attr_node_remove_cleanup(
>>
>>          struct xfs_delattr_context      *dac)
>>
>> {
>>
>>          struct xfs_da_args              *args = dac->da_args;
>>
>>          struct xfs_da_state_blk         *blk;
>>
>>          int                             retval;
>>
>>
>>
>>          /*
>>
>>           * Remove the name and update the hashvals in the tree.
>>
>>           */
>>
>>          blk = &dac->da_state->path.blk[ dac->da_state->path.active-1 ];
>>
>>          ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>
>>          retval = xfs_attr3_leaf_remove(blk->bp, args);
>>
>>          xfs_da3_fixhashpath(dac->da_state, &dac->da_state->path);
>>
>>
>>
>>          return retval;
>>
>> }
>>
>>
>> This configuration seems to get through the test cases.  It's not quite as
>> tidy, but it does get all the state handling into this scope.  If people
>> prefer it this way I can add in the extra helper and make these adjustments?
>>
> 
> Makes sense. I think the goal should be to pull the state management
> into one (or as few) place(s) as technically possible and we should
> refactor however necessary to accomplish that (please just pull the
> refactoring out into preliminary patches to facilitate review). Thanks.
> 
> Brian
Sure, I'll add in another patch for that extra helper in the next set. 
Thanks for the review!

Allison

> 
>> Allison
>>
>>>
>>>> -	/*
>>>> -	 * If the result is small enough, push it all into the inode.
>>>> -	 */
>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>> -		error = xfs_attr_node_shrink(args, state);
>>>> +		/* do not break, proceed to shrink if needed */
>>>> +	case XFS_DAS_RM_SHRINK:
>>>> +		/*
>>>> +		 * If the result is small enough, push it all into the inode.
>>>> +		 */
>>>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>> +			error = xfs_attr_node_shrink(args, state);
>>>> +		break;
>>>> +	default:
>>>> +		ASSERT(0);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	if (error == -EAGAIN)
>>>> +		return error;
>>>>    out:
>>>>    	if (state)
>>>>    		xfs_da_state_free(state);
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>>> index 3e97a93..64dcf0f 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>>> @@ -74,6 +74,74 @@ struct xfs_attr_list_context {
>>>>    };
>>>> +/*
>>>> + * ========================================================================
>>>> + * Structure used to pass context around among the delayed routines.
>>>> + * ========================================================================
>>>> + */
>>>> +
>>>> +/*
>>>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>>>> + * states indicate places where the function would return -EAGAIN, and then
>>>> + * immediately resume from after being recalled by the calling function. States
>>>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>>>> + * so the calling function needs to pass them back to that subroutine to allow
>>>> + * it to finish where it left off. But they otherwise do not have a role in the
>>>> + * calling function other than just passing through.
>>>> + *
>>>> + * xfs_attr_remove_iter()
>>>> + *	  XFS_DAS_RM_SHRINK ─┐
>>>> + *	  (subroutine state) │
>>>> + *	                     └─>xfs_attr_node_removename()
>>>> + *	                                      │
>>>> + *	                                      v
>>>> + *	                                   need to
>>>> + *	                                shrink tree? ─n─┐
>>>> + *	                                      │         │
>>>> + *	                                      y         │
>>>> + *	                                      │         │
>>>> + *	                                      v         │
>>>> + *	                              XFS_DAS_RM_SHRINK │
>>>> + *	                                      │         │
>>>> + *	                                      v         │
>>>> + *	                                     done <─────┘
>>>> + *
>>>> + */
>>>> +
>>>> +/*
>>>> + * Enum values for xfs_delattr_context.da_state
>>>> + *
>>>> + * These values are used by delayed attribute operations to keep track  of where
>>>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>>>> + * calling function to roll the transaction, and then recall the subroutine to
>>>> + * finish the operation.  The enum is then used by the subroutine to jump back
>>>> + * to where it was and resume executing where it left off.
>>>> + */
>>>> +enum xfs_delattr_state {
>>>> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>>>> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>>>> +};
>>>> +
>>>> +/*
>>>> + * Defines for xfs_delattr_context.flags
>>>> + */
>>>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>>>> +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
>>>> +
>>>> +/*
>>>> + * Context used for keeping track of delayed attribute operations
>>>> + */
>>>> +struct xfs_delattr_context {
>>>> +	struct xfs_da_args      *da_args;
>>>> +
>>>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>>>> +	struct xfs_da_state     *da_state;
>>>> +
>>>> +	/* Used to keep track of current state of delayed operation */
>>>> +	unsigned int            flags;
>>>> +	enum xfs_delattr_state  dela_state;
>>>> +};
>>>> +
>>>>    /*========================================================================
>>>>     * Function prototypes for the kernel.
>>>>     *========================================================================*/
>>>> @@ -91,6 +159,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>>>    int xfs_attr_set_args(struct xfs_da_args *args);
>>>>    int xfs_has_attr(struct xfs_da_args *args);
>>>>    int xfs_attr_remove_args(struct xfs_da_args *args);
>>>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>>> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>>>    bool xfs_attr_namecheck(const void *name, size_t length);
>>>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>>> +			      struct xfs_da_args *args);
>>>>    #endif	/* __XFS_ATTR_H__ */
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> index bb128db..338377e 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>>>> @@ -19,8 +19,8 @@
>>>>    #include "xfs_bmap_btree.h"
>>>>    #include "xfs_bmap.h"
>>>>    #include "xfs_attr_sf.h"
>>>> -#include "xfs_attr_remote.h"
>>>>    #include "xfs_attr.h"
>>>> +#include "xfs_attr_remote.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_error.h"
>>>>    #include "xfs_trace.h"
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index 48d8e9c..1426c15 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>>>>     */
>>>>    int
>>>>    xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args      *args)
>>>> +	struct xfs_da_args		*args)
>>>>    {
>>>> -	int			error;
>>>> -	int			retval;
>>>> +	int				error;
>>>> +	struct xfs_delattr_context	dac  = {
>>>> +		.da_args	= args,
>>>> +	};
>>>>    	trace_xfs_attr_rmtval_remove(args);
>>>> @@ -685,19 +687,17 @@ xfs_attr_rmtval_remove(
>>>>    	 * Keep de-allocating extents until the remote-value region is gone.
>>>>    	 */
>>>>    	do {
>>>> -		retval = __xfs_attr_rmtval_remove(args);
>>>> -		if (retval && retval != -EAGAIN)
>>>> -			return retval;
>>>> +		error = __xfs_attr_rmtval_remove(&dac);
>>>> +		if (error != -EAGAIN)
>>>> +			break;
>>>> -		/*
>>>> -		 * Close out trans and start the next one in the chain.
>>>> -		 */
>>>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>> +		error = xfs_attr_trans_roll(&dac);
>>>>    		if (error)
>>>>    			return error;
>>>> -	} while (retval == -EAGAIN);
>>>> -	return 0;
>>>> +	} while (true);
>>>> +
>>>> +	return error;
>>>>    }
>>>>    /*
>>>> @@ -707,9 +707,10 @@ xfs_attr_rmtval_remove(
>>>>     */
>>>>    int
>>>>    __xfs_attr_rmtval_remove(
>>>> -	struct xfs_da_args	*args)
>>>> +	struct xfs_delattr_context	*dac)
>>>>    {
>>>> -	int			error, done;
>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>> +	int				error, done;
>>>>    	/*
>>>>    	 * Unmap value blocks for this attr.
>>>> @@ -719,12 +720,10 @@ __xfs_attr_rmtval_remove(
>>>>    	if (error)
>>>>    		return error;
>>>> -	error = xfs_defer_finish(&args->trans);
>>>> -	if (error)
>>>> -		return error;
>>>> -
>>>> -	if (!done)
>>>> +	if (!done) {
>>>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    		return -EAGAIN;
>>>> +	}
>>>>    	return error;
>>>>    }
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index 9eee615..002fd30 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>>>> index bfad669..aaa7e66 100644
>>>> --- a/fs/xfs/xfs_attr_inactive.c
>>>> +++ b/fs/xfs/xfs_attr_inactive.c
>>>> @@ -15,10 +15,10 @@
>>>>    #include "xfs_da_format.h"
>>>>    #include "xfs_da_btree.h"
>>>>    #include "xfs_inode.h"
>>>> +#include "xfs_attr.h"
>>>>    #include "xfs_attr_remote.h"
>>>>    #include "xfs_trans.h"
>>>>    #include "xfs_bmap.h"
>>>> -#include "xfs_attr.h"
>>>>    #include "xfs_attr_leaf.h"
>>>>    #include "xfs_quota.h"
>>>>    #include "xfs_dir2.h"
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
