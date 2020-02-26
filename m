Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB91C4BA09
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A72424650
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 00:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vedw2W2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgBZA56 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 19:57:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40288 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgBZA56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 19:57:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q0qcTB150096;
        Wed, 26 Feb 2020 00:57:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E0p31TJI4/1QwqqHETKMUOB4trsvTtTTDY/1jP3HXoA=;
 b=Vedw2W2Qa7y83z/gDuPkgybhWo75hDmWhDtkIGRzNuI2bmq3mXMf/czX9jgxWPasx6Vz
 vll9Rmiqboq+MBViIpzyuT5CiXAoWlk7r7KreNC9YMQ5J4kRRpKYinOgj4exqgOxZdWo
 oMSiojfcDPtDTLOCyDiBbdm30rdGdK7B0hdIwRVYkuv3eD51w5AQ34M13MVDgJXJOsgF
 1U0M2mvRD6CUTOVs+4zH9zOD/AMMojRyh9+7TrapiqoymeC28d/0DcRgTfGO7rHZ2WFe
 2w2aBRpYVxhenoEfd+lb8QZ06ixp6S7+9a7iXdqFk1vjho/QVIRw6bTesHhe1LxoG6GH GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct30byk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 00:57:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q0uZAC111945;
        Wed, 26 Feb 2020 00:57:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ydcs8nkba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 00:57:54 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q0vq0w024759;
        Wed, 26 Feb 2020 00:57:52 GMT
Received: from [192.168.1.9] (/67.1.3.112) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 25 Feb 2020 16:57:47 -0800
USER-AGENT: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Content-Language: en-US
MIME-Version: 1.0
Message-ID: <6075dabe-c503-05e4-ac3a-9eb028d40e9d@oracle.com>
Date:   Tue, 25 Feb 2020 16:57:46 -0800 (PST)
From:   Allison Collins <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 13/19] xfs: Add delay ready attr remove routines
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-14-allison.henderson@oracle.com>
 <20200225085705.GI10776@dread.disaster.area>
In-Reply-To: <20200225085705.GI10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260003
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 1:57 AM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:06:05PM -0700, Allison Collins wrote:
>> This patch modifies the attr remove routines to be delay ready. This means they no
>> longer roll or commit transactions, but instead return -EAGAIN to have the calling
>> routine roll and refresh the transaction. In this series, xfs_attr_remove_args has
>> become xfs_attr_remove_iter, which uses a sort of state machine like switch to keep
>> track of where it was when EAGAIN was returned. xfs_attr_node_removename has also
>> been modified to use the switch, and a  new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation is
>> completed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use to keep
>> track of the current state of an attribute operation. The new xfs_delattr_state
>> enum is used to track various operations that are in progress so that we know not
>> to repeat them, and resume where we left off before EAGAIN was returned to cycle
>> out the transaction. Other members take the place of local variables that need
>> to retain their values across multiple function recalls.
>>
>> Below is a state machine diagram for attr remove operations. The XFS_DAS_* states
> 
> Ok, so I find all the DA/da prefixes in this code confusing,
> especially as they have very similar actual names. e.g. da_state
> vs delattr_state, DAS vs DA_STATE, etc.
> 
> Basically, I can't tell from reading the code what "DA" the actual
> variable belongs to, and in a few months time I'll most definitely
> have forgotten and have to relearn it from scratch.
> 
> So while "Delayed Attributes" is a great name for the feature, I
> don't think it makes a great acronym for shortening variable names
> because of the conflict with the existing DA namespace prefix.
> 
> Also, "dac" as shorthand for delattr context is also overloaded.
> "DAC" is "discretionary access control" and is quite widely used
> in the kernel (e.g. CAP_DAC_READ_SEARCH, CAP_DAC_OVERRIDE) so again
> I read thsi code and it doesn't make much sense.
> 
> I haven't come up with a better name - "attribute iterator" is the
> best I've managed (marketing++ - XFS has AI now!) and shortening it
> down to ator would go a long way to alleviating my namespace
> confusion....

Sure, no worries, there's still time to give it some thought
> 
>> indicate places where the function would return -EAGAIN, and then immediately
>> resume from after being recalled by the calling function.  States marked as a
>> "subroutine state" indicate that they belong to a subroutine, and so the calling
>> function needs to pass them back to that subroutine to allow it to finish where
>> it left off. But they otherwise do not have a role in the calling function other
>> than just passing through.
>>
>>   xfs_attr_remove_iter()
>>           XFS_DAS_RM_SHRINK     ─┐
>>           (subroutine state)     │
>>                                  │
>>           XFS_DAS_RMTVAL_REMOVE ─┤
>>           (subroutine state)     │
>>                                  └─>xfs_attr_node_removename()
>>                                                   │
>>                                                   v
>>                                           need to remove
>>                                     ┌─n──  rmt blocks?
>>                                     │             │
>>                                     │             y
>>                                     │             │
>>                                     │             v
>>                                     │  ┌─>XFS_DAS_RMTVAL_REMOVE
>>                                     │  │          │
>>                                     │  │          v
>>                                     │  └──y── more blks
>>                                     │         to remove?
>>                                     │             │
>>                                     │             n
>>                                     │             │
>>                                     │             v
>>                                     │         need to
>>                                     └─────> shrink tree? ─n─┐
>>                                                   │         │
>>                                                   y         │
>>                                                   │         │
>>                                                   v         │
>>                                           XFS_DAS_RM_SHRINK │
>>                                                   │         │
>>                                                   v         │
>>                                                  done <─────┘
> 
> Nice.
I'm glad people like those, I wasnt sure what people expected or what to 
expect as a response, but I think it helps facilitate the design at 
least for the time being :-)

> 
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c     | 114 +++++++++++++++++++++++++++++++++++++------
>>   fs/xfs/libxfs/xfs_attr.h     |   1 +
>>   fs/xfs/libxfs/xfs_da_btree.h |  30 ++++++++++++
>>   fs/xfs/scrub/common.c        |   2 +
>>   fs/xfs/xfs_acl.c             |   2 +
>>   fs/xfs/xfs_attr_list.c       |   1 +
>>   fs/xfs/xfs_ioctl.c           |   2 +
>>   fs/xfs/xfs_ioctl32.c         |   2 +
>>   fs/xfs/xfs_iops.c            |   2 +
>>   fs/xfs/xfs_xattr.c           |   1 +
>>   10 files changed, 141 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5d73bdf..cd3a3f7 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -368,11 +368,60 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> +	struct xfs_da_args	*argsc
>> +{
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(args);
>> +		if (error && error != -EAGAIN)
>> +			goto out;
>> +
>> +		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>> +			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>> +
>> +			err2 = xfs_defer_finish(&args->trans);
>> +			if (err2) {
>> +				error = err2;
>> +				goto out;
>> +			}
>> +		}
>> +
>> +		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (err2) {
>> +			error = err2;
>> +			goto out;
>> +		}
>> +
>> +	} while (error == -EAGAIN);
>> +out:
>> +	return error;
>> +}
> 
> Brian commented on the structure of this loop better than I could.
> 
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
>>   	struct xfs_da_args      *args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	int			error;
>>   
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_RM_SHRINK:
>> +	case XFS_DAS_RMTVAL_REMOVE:
>> +		goto node;
>> +	default:
>> +		break;
>> +	}
> 
> Why separate out the state machine? Doesn't this shortcut the
> xfs_inode_hasattr() check? Shouldn't that come first?
Well, the idea is that when we first start the routine, we come in with 
neither state set, and we fall through to the break.  So we execute the 
check the first time through.

Though now that you point it out, I should probably go back and put the 
explicit numbering back in the enum (starting with 1) or they will 
default to zero, which would be incorrect.  I had pulled it out in one 
of the last reviews thinking it would be ok, but it should go back in.

> 
> As it is:
> 
> 	case XFS_DAS_RM_SHRINK:
> 	case XFS_DAS_RMTVAL_REMOVE:
> 		return xfs_attr_node_removename(args);
> 	default:
> 		break;
> 
> would be nicer, and if this is the only way we can get to
> xfs_attr_node_removename(c, getting rid of it from the code
> below could be done, too.
Well, the remove path is a lot simpler than the set path, so that trick 
does work here :-)

The idea though was to establish "jump points" with the "XFS_DAS_*" 
states.  Based on the state, we jump back to where we were.  We could 
break this pattern for the remove path, but I dont think we'd want to do 
the same for the others.  The set routine is a really big function that 
would end up being inside a really big switch!

> 
> 
>> +
>>   	if (!xfs_inode_hasattr(dp)) {
>>   		error = -ENOATTR;
>>   	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> @@ -381,6 +430,7 @@ xfs_attr_remove_args(
>>   	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_removename(args);
>>   	} else {
>> +node:
>>   		error = xfs_attr_node_removename(args);
>>   	}
>>   
>> @@ -895,9 +945,8 @@ xfs_attr_leaf_removename(
>>   		/* bp is gone due to xfs_da_shrink_inode */
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +
>> +		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>   	}
>>   	return 0;
>>   }
>> @@ -1218,6 +1267,11 @@ xfs_attr_node_addname(
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an inline or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>>   STATIC int
>>   xfs_attr_node_removename(
>> @@ -1230,10 +1284,24 @@ xfs_attr_node_removename(
>>   	struct xfs_inode	*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>> +	state = args->dac.da_state;
>> +	blk = args->dac.blk;
>> +
>> +	/* State machine switch */
>> +	switch (args->dac.dela_state) {
>> +	case XFS_DAS_RMTVAL_REMOVE:
>> +		goto rm_node_blks;
>> +	case XFS_DAS_RM_SHRINK:
>> +		goto rm_shrink;
>> +	default:
>> +		break;
>> +	}
> 
> This really is calling out for this function to be broken into three
> smaller functions. That would greatly simplify the code flow and
> logic here.
Yes, that is the goal we are working towards.

> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index ce7b039..ea873a5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -155,6 +155,7 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_da_args *args);
>>   int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>>   		  int flags, struct attrlist_cursor_kern *cursor);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>> index 14f1be3..3c78498 100644
>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>> @@ -50,9 +50,39 @@ enum xfs_dacmp {
>>   };
>>   
>>   /*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */Note to self: need put the ordering back to starting at 1, not zero

>> +	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define	XFS_DAC_FINISH_TRANS	0x1 /* indicates to finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_state	*da_state;
>> +	struct xfs_da_state_blk *blk;
>> +	unsigned int		flags;
>> +	enum xfs_delattr_state	dela_state;
>> +};
>> +
>> +/*
>>    * Structure to ease passing around component names.
>>    */
>>   typedef struct xfs_da_args {
>> +	struct xfs_delattr_context dac; /* context used for delay attr ops */
> 
> Probably should put this at the end of the structure rather than the
> front.
Sure, will do

> 
> I'm also wondering if it should be kept separate to the da_args and
> contain a pointer to the da_args instead of being wrapped inside
> them.
> 
> i.e. we put the iterating state structure on the stack, then
> 
> 	struct attr_iter	ater = {
> 		.da_args = args,
> 	};
> 
> 	do {
> 		error = xfs_attr_remove_iter(&ater);
> 		.....
> 	
> And that largely separates the delayed attribute iteration state
> from the da_args that holds the internal attribute manipulation
> information.
Oh i see.  Sure, let me see if that will work, it seems like it should

> 
>>   	struct xfs_da_geometry *geo;	/* da block geometry */
>>   	struct xfs_name	name;		/* name, length and argument  flags*/
>>   	uint8_t		filetype;	/* filetype of inode for directories */
>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>> index 1887605..9a649d1 100644
>> --- a/fs/xfs/scrub/common.c
>> +++ b/fs/xfs/scrub/common.c
>> @@ -24,6 +24,8 @@
>>   #include "xfs_rmap_btree.h"
>>   #include "xfs_log.h"
>>   #include "xfs_trans_priv.h"
>> +#include "xfs_da_format.h"
>> +#include "xfs_da_btree.h"
>>   #include "xfs_attr.h"
>>   #include "xfs_reflink.h"
>>   #include "scrub/scrub.h"
> 
> Hmmm - why are these new includes necessary? You didn't add anything
> new to these files or common header files to make the includes
> needed....

Because the delayed attr context uses things from those headers.  And we 
put the context in xfs_da_args.  Now everything that uses xfs_da_args 
needs those includes.  But maybe if we do what you suggest above, we 
wont need to. :-)

Thanks for the reviews!  I know its a lot!
Allison

> 
> Cheers,
> 
> Dave.
> 
