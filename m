Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0643C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8099F20720
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jdd38xU4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgGIWEQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 18:04:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGIWEQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 18:04:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LurVN102325;
        Thu, 9 Jul 2020 22:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t3OfZDPHOqYeU7XgT3ahDtw1Ny2y6H6ZyyVX6tmesFQ=;
 b=Jdd38xU4YdpJxVPOwvOGwDHWMUOZ4BJQmj4WN6k9TZfF7E9VosM/ibbjomNVs9nHiobo
 s0BHJdlhkEhHz16/dKDjHc9g17CD1Af1uHGJCmY+DFG+llELxVtfwU4J8g/x/r3seTM8
 8sB0AGhMGOFg12ffRso4hRliDLzWASwdrad+CoR4Op8lFSEE09QT5PlD8kgZdufh92K3
 G35tbaaOjjK7nndOXlg7Me6EjTwGKvT4V9NU9Z5kuJ6T+ZG22JqYjz+PYqFQMJj5Y3OP
 pnYX4+b1pcmZFQ7H0GR8b5hGfPm7eVcWi/NOw2YeMGWCgRA1luvMI/Kt/f1N9nKG4ZW7 Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 325y0ambd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 09 Jul 2020 22:04:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 069LxMiS012676;
        Thu, 9 Jul 2020 22:02:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 325k3j1tc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jul 2020 22:02:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 069M29gi029781;
        Thu, 9 Jul 2020 22:02:09 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jul 2020 15:02:09 -0700
Subject: Re: [PATCH v10 23/25] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200625233018.14585-1-allison.henderson@oracle.com>
 <20200625233018.14585-24-allison.henderson@oracle.com>
 <20200709132456.GB56848@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4238134f-ea78-8ab3-c9ef-c4495365310d@oracle.com>
Date:   Thu, 9 Jul 2020 15:02:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200709132456.GB56848@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007090145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9677 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/9/20 6:24 AM, Brian Foster wrote:
> On Thu, Jun 25, 2020 at 04:30:16PM -0700, Allison Collins wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>> uses a sort of state machine like switch to keep track of where it was
>> when EAGAIN was returned. xfs_attr_node_removename has also been
>> modified to use the switch, and a new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation
>> is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
>> transaction where ever the existing code used to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of perserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 155 ++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr.h        |  73 +++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  40 +++++------
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 208 insertions(+), 66 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4b78c86..5c460f4 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_removename(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -264,6 +264,32 @@ xfs_attr_set_shortform(
>>   }
>>   
>>   /*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * also checks for a defer finish.  Transaction is finished and rolled as
>> + * needed, and returns true of false if the delayed operation should continue.
>> + */
>> +bool
>> +xfs_attr_roll_again(
> 
> The function name suggests this is more of a status checking function
> than one that does actual work. I'd suggest something more like
> xfs_attr_trans_roll() based on the implementation.
Sure, I believe Darrick had asked for this helper in the last review, so 
as long as folks are in agreement with the name, that is fine.

> 
>> +	struct xfs_delattr_context	*dac,
>> +	int				*error)
>> +{
>> +	struct xfs_da_args              *args = dac->da_args;
>> +
>> +	if (*error != -EAGAIN)
>> +		return false;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		*error = xfs_defer_finish(&args->trans);
>> +		if (*error)
>> +			return false;
>> +	}
>> +
> 
> I also find the semantics of this function a little confusing. How would
> a caller distinguish between error == -EAGAIN as passed in from the
> caller vs. error being set by one of the transaction processing calls?
I believe the helper was just meant to be a straight hoist from the v9 
version.  The error parameter here is an input for use in this scope, 
it's not for the caller to do anything with.  Other than to pipe it back 
in.  The caller just needs to know whether or not to continue.

That signature is a bit odd, though this pattern does appear in a few 
places around the code, so it does help consolidate a bit.  I suppose 
it's just a question of which people prefer.

> 
>> +	*error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	return *error == 0;
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -364,23 +390,47 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error;
>> +	int				error = 0;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +	} while (xfs_attr_roll_again(&dac, &error));
>> +
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove the attribute specified in @args.
>> + *
>> + * This function may return -EAGAIN to signal that the transaction needs to be
>> + * rolled.  Callers should continue calling this function until they receive a
>> + * return value other than -EAGAIN.
>> + */
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>> +
>> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>> +		goto node;
> 
> Thoughts on my comments on this on the previous version?
Apologies, I must have missed responding to it, I had a few family 
emergencies at the time and must have lost track.  I do believe we need 
the goto because in the process of shrinking, it is possible that we 
turn back into a block which would cause us to fall into the wrong 
if/else logic with out it. I will run the test and double check though. 
I'm pretty sure I recall running into that though.

> 
>>   
>>   	if (!xfs_inode_hasattr(dp)) {
>> -		error = -ENOATTR;
>> +		return -ENOATTR;
>>   	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -		error = xfs_attr_shortform_remove(args);
>> +		return xfs_attr_shortform_remove(args);
>>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(args);
>> -	} else {
>> -		error = xfs_attr_node_removename(args);
>> +		return xfs_attr_leaf_removename(args);
>>   	}
>> -
>> -	return error;
>> +node:
>> +	return  xfs_attr_node_removename(dac);
>>   }
>>   
>>   /*
> ...
>> @@ -1268,17 +1348,14 @@ xfs_attr_node_removename(
>>   		error = xfs_da3_join(state);
>>   		if (error)
>>   			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> +
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>> +		dac->dela_state = XFS_DAS_RM_SHRINK;
>> +		return -EAGAIN;
>>   	}
>>   
>> +das_rm_shrink:
>> +
> 
> I think I also mentioned the tail of this function might sit better in
> the caller..
I see, yes I'll see if I could pull that up.  If I missed anything else, 
please call it out.  Thank you for your reviews!

Allison

> 
> Brian
> 
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 3e97a93..6c58792 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -74,6 +74,75 @@ struct xfs_attr_list_context {
>>   };
>>   
>>   
>> +/*
>> + * ========================================================================
>> + * Structure used to pass context around among the delayed routines.
>> + * ========================================================================
>> + */
>> +
>> +/*
>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>> + * states indicate places where the function would return -EAGAIN, and then
>> + * immediately resume from after being recalled by the calling function. States
>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>> + * so the calling function needs to pass them back to that subroutine to allow
>> + * it to finish where it left off. But they otherwise do not have a role in the
>> + * calling function other than just passing through.
>> + *
>> + * xfs_attr_remove_iter()
>> + *	  XFS_DAS_RM_SHRINK ─┐
>> + *	  (subroutine state) │
>> + *	                     └─>xfs_attr_node_removename()
>> + *	                                      │
>> + *	                                      v
>> + *	                                   need to
>> + *	                                shrink tree? ─n─┐
>> + *	                                      │         │
>> + *	                                      y         │
>> + *	                                      │         │
>> + *	                                      v         │
>> + *	                              XFS_DAS_RM_SHRINK │
>> + *	                                      │         │
>> + *	                                      v         │
>> + *	                                     done <─────┘
>> + *
>> + */
>> +
>> +/*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +				      /* Zero is uninitalized */
>> +	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_args      *da_args;
>> +
>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>> +	struct xfs_da_state     *da_state;
>> +	struct xfs_da_state_blk *blk;
>> +
>> +	/* Used to keep track of current state of delayed operation */
>> +	unsigned int            flags;
>> +	enum xfs_delattr_state  dela_state;
>> +};
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -91,6 +160,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> +bool xfs_attr_roll_again(struct xfs_delattr_context *dac, int *error);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> +			      struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 351351c..20521bf 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -19,8 +19,8 @@
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_attr_sf.h"
>> -#include "xfs_attr_remote.h"
>>   #include "xfs_attr.h"
>> +#include "xfs_attr_remote.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 85dca51..20e4605 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -676,12 +676,14 @@ xfs_attr_rmtval_invalidate(
>>    */
>>   int
>>   xfs_attr_rmtval_remove(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args		*args)
>>   {
>> -	xfs_dablk_t		lblkno;
>> -	int			blkcnt;
>> -	int			error = 0;
>> -	int			retval = 0;
>> +	xfs_dablk_t			lblkno;
>> +	int				blkcnt;
>> +	int				error = 0;
>> +	struct xfs_delattr_context	dac  = {
>> +		.da_args	= args,
>> +	};
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> @@ -691,19 +693,10 @@ xfs_attr_rmtval_remove(
>>   	lblkno = args->rmtblkno;
>>   	blkcnt = args->rmtblkcnt;
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != EAGAIN)
>> -			return retval;
>> -
>> -		/*
>> -		 * Close out trans and start the next one in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			return error;
>> -	} while (retval == -EAGAIN);
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +	} while (xfs_attr_roll_again(&dac, &error));
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -713,9 +706,10 @@ xfs_attr_rmtval_remove(
>>    */
>>   int
>>   __xfs_attr_rmtval_remove(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, done;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * Unmap value blocks for this attr.
>> @@ -725,12 +719,10 @@ __xfs_attr_rmtval_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_defer_finish(&args->trans);
>> -	if (error)
>> -		return error;
>> -
>> -	if (!done)
>> +	if (!done) {
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		return -EAGAIN;
>> +	}
>>   
>>   	return error;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9eee615..002fd30 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index bfad669..aaa7e66 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -15,10 +15,10 @@
>>   #include "xfs_da_format.h"
>>   #include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_attr.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> -#include "xfs_attr.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_dir2.h"
>> -- 
>> 2.7.4
>>
> 
