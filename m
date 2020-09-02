Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42887C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04F0207EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 02:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oaFL42RT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIBCdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 22:33:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33972 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBCdv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:33:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822Xahw098775
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 02:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SNSDnjAdxF/XZcho3C4jwvsoRLkT1ll9FWy/apOrGrQ=;
 b=oaFL42RTgtFo+YculYdzNrcMCB/umwvjDYbDpI4I3n4M/BLhmMCAzLC20cPgHstkLLlX
 98dBnQN3w/utFrgxivTbnC4NUB418ATdon503HXC6A5E2Pmv6Vwqomv7lWbTL9bM/Jqo
 Lvah3ce9XLHeEmhTBw8gffqLxrCWCowjZPz3s3nkBZbP5Gk8b1+aEPrvlGfSmIFaPQZA
 ssL4efZjT7kQNiiM+W/KSQMiUvnA/apcnDlCwei+tntZMssN8PFQifFIqPbUXeqYn7iS
 j7lLRqvvrFSbItaFS8l/NKpP4AvyAWnqdtZJq25DfdUJT2rorpkBhSTCo50cPI7r37W7 kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 339dmmx8dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 02:33:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822ThKe114664
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 02:33:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380xxpuua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 02:33:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0822Xe9u023508
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 02:33:40 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:33:40 -0700
Subject: Re: [PATCH v12 4/8] xfs: Set up infastructure for deferred attribute
 operations
From:   Allison Collins <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200827003518.1231-1-allison.henderson@oracle.com>
 <20200827003518.1231-5-allison.henderson@oracle.com>
 <20200828212753.GG6090@magnolia>
 <8015b01d-5c7e-a7f0-ce83-170ae3451e52@oracle.com>
Message-ID: <5ec30656-b007-abc4-e542-74384af79ab8@oracle.com>
Date:   Tue, 1 Sep 2020 19:33:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8015b01d-5c7e-a7f0-ce83-170ae3451e52@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/1/20 5:46 PM, Allison Collins wrote:
> 
> 
> On 8/28/20 2:27 PM, Darrick J. Wong wrote:
>> On Wed, Aug 26, 2020 at 05:35:14PM -0700, Allison Collins wrote:
>>> Currently attributes are modified directly across one or more
>>> transactions. But they are not logged or replayed in the event of an
>>> error. The goal of delayed attributes is to enable logging and replaying
>>> of attribute operations using the existing delayed operations
>>> infrastructure.  This will later enable the attributes to become part of
>>> larger multi part operations that also must first be recorded to the
>>> log.  This is mostly of interest in the scheme of parent pointers which
>>> would need to maintain an attribute containing parent inode information
>>> any time an inode is moved, created, or removed.  Parent pointers would
>>> then be of interest to any feature that would need to quickly derive an
>>> inode path from the mount point. Online scrub, nfs lookups and fs grow
>>> or shrink operations are all features that could take advantage of this.
>>>
>>> This patch adds two new log item types for setting or removing
>>> attributes as deferred operations.  The xfs_attri_log_item logs an
>>> intent to set or remove an attribute.  The corresponding
>>> xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
>>> freed once the transaction is done.  Both log items use a generic
>>> xfs_attr_log_format structure that contains the attribute name, value,
>>> flags, inode, and an op_flag that indicates if the operations is a set
>>> or remove.
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/Makefile                 |   1 +
>>>   fs/xfs/libxfs/xfs_attr.c        |   7 +-
>>>   fs/xfs/libxfs/xfs_attr.h        |  39 ++
>>>   fs/xfs/libxfs/xfs_defer.c       |   1 +
>>>   fs/xfs/libxfs/xfs_defer.h       |   3 +
>>>   fs/xfs/libxfs/xfs_log_format.h  |  44 ++-
>>>   fs/xfs/libxfs/xfs_log_recover.h |   2 +
>>>   fs/xfs/libxfs/xfs_types.h       |   1 +
>>>   fs/xfs/scrub/common.c           |   2 +
>>>   fs/xfs/xfs_acl.c                |   2 +
>>>   fs/xfs/xfs_attr_item.c          | 829 
>>> ++++++++++++++++++++++++++++++++++++++++
>>>   fs/xfs/xfs_attr_item.h          |  76 ++++
>>>   fs/xfs/xfs_attr_list.c          |   1 +
>>>   fs/xfs/xfs_ioctl.c              |   2 +
>>>   fs/xfs/xfs_ioctl32.c            |   2 +
>>>   fs/xfs/xfs_iops.c               |   2 +
>>>   fs/xfs/xfs_log.c                |   4 +
>>>   fs/xfs/xfs_log_recover.c        |   2 +
>>>   fs/xfs/xfs_ondisk.h             |   2 +
>>>   fs/xfs/xfs_xattr.c              |   1 +
>>>   20 files changed, 1017 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
>>> index 04611a1..b056cfc 100644
>>> --- a/fs/xfs/Makefile
>>> +++ b/fs/xfs/Makefile
>>> @@ -102,6 +102,7 @@ xfs-y                += xfs_log.o \
>>>                      xfs_buf_item_recover.o \
>>>                      xfs_dquot_item_recover.o \
>>>                      xfs_extfree_item.o \
>>> +                   xfs_attr_item.o \
>>>                      xfs_icreate_item.o \
>>>                      xfs_inode_item.o \
>>>                      xfs_inode_item_recover.o \
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index a8cfe62..cf75742 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -24,6 +24,7 @@
>>>   #include "xfs_quota.h"
>>>   #include "xfs_trans_space.h"
>>>   #include "xfs_trace.h"
>>> +#include "xfs_attr_item.h"
>>>   /*
>>>    * xfs_attr.c
>>> @@ -59,8 +60,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>>   STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct 
>>> xfs_buf *bp);
>>> -STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>>> -                 struct xfs_buf **leaf_bp);
>>>   int
>>>   xfs_inode_hasattr(
>>> @@ -142,7 +141,7 @@ xfs_attr_get(
>>>   /*
>>>    * Calculate how many blocks we need for the new attribute,
>>>    */
>>> -STATIC int
>>> +int
>>>   xfs_attr_calc_size(
>>>       struct xfs_da_args    *args,
>>>       int            *local)
>>> @@ -327,7 +326,7 @@ xfs_attr_set_args(
>>>    * to handle this, and recall the function until a successful error 
>>> code is
>>>    * returned.
>>>    */
>>> -STATIC int
>>> +int
>>>   xfs_attr_set_iter(
>>>       struct xfs_delattr_context    *dac,
>>>       struct xfs_buf            **leaf_bp)
>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>> index 4f6bba8..23b8308 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>> @@ -247,6 +247,7 @@ enum xfs_delattr_state {
>>>   #define XFS_DAC_DEFER_FINISH        0x01 /* finish the transaction */
>>>   #define XFS_DAC_NODE_RMVNAME_INIT    0x02 /* 
>>> xfs_attr_node_removename init */
>>>   #define XFS_DAC_LEAF_ADDNAME_INIT    0x04 /* xfs_attr_leaf_addname 
>>> init*/
>>> +#define XFS_DAC_DELAYED_OP_INIT        0x08 /* delayed operations 
>>> init*/
>>>   /*
>>>    * Context used for keeping track of delayed attribute operations
>>> @@ -254,6 +255,9 @@ enum xfs_delattr_state {
>>>   struct xfs_delattr_context {
>>>       struct xfs_da_args      *da_args;
>>> +    /* Used by delayed attributes to hold leaf across transactions */
>>> +    struct xfs_buf        *leaf_bp;
>>> +
>>>       /* Used in xfs_attr_rmtval_set_blk to roll through allocating 
>>> blocks */
>>>       struct xfs_bmbt_irec    map;
>>>       xfs_dablk_t        lblkno;
>>> @@ -268,6 +272,38 @@ struct xfs_delattr_context {
>>>       enum xfs_delattr_state  dela_state;
>>>   };
>>
>> I'll start by pasting in the full xfs_delattr_context definition for
>> easier reading:
>>
>> /*
>>   * Context used for keeping track of delayed attribute operations
>>   */
>> struct xfs_delattr_context {
>>     struct xfs_da_args      *da_args;
>>
>>     /* Used by delayed attributes to hold leaf across transactions */
>>     struct xfs_buf        *leaf_bp;
>>
>>     /* Used in xfs_attr_rmtval_set_blk to roll through allocating 
>> blocks */
>>     struct xfs_bmbt_irec    map;
>>     xfs_dablk_t        lblkno;
>>     int            blkcnt;
>>
>>     /* Used in xfs_attr_node_removename to roll through removing 
>> blocks */
>>     struct xfs_da_state     *da_state;
>>     struct xfs_da_state_blk *blk;
>>
>>     /* Used to keep track of current state of delayed operation */
>>     unsigned int            flags;
>>     enum xfs_delattr_state  dela_state;
>> };
>>
>> Admittedly, I /am/ conducting a backwards review and zeroing in on the
>> data structures first.
>>
>>> +/*
>>> + * List of attrs to commit later.
>>> + */
>>> +struct xfs_attr_item {
>>> +    struct xfs_inode    *xattri_ip;
>>> +    void            *xattri_value;        /* attr value */
>>> +    void            *xattri_name;        /* attr name */
>>> +    uint32_t        xattri_op_flags;    /* attr op set or rm */
>>> +    uint32_t        xattri_value_len;    /* length of value */
>>> +    uint32_t        xattri_name_len;    /* length of name */
>>> +    uint32_t        xattri_flags;        /* attr flags */
>>> +
>>> +    /* used to log this item to an intent */
>>> +    struct list_head    xattri_list;
>>> +
>>> +    /*
>>> +     * xfs_delattr_context and xfs_da_args need to remain instantiated
>>> +     * across transaction rolls during the defer finish, so store 
>>> them here
>>> +     */
>>> +    struct xfs_da_args        xattri_args;
>>> +    struct xfs_delattr_context    xattri_dac;
>>> +
>>> +    /*
>>> +     * A byte array follows the header containing the file name and
>>> +     * attribute value.
>>> +     */
>>> +};
>>
>> These two structures (xfs_delattr_context and xfs_attr_item) duplicate a
>> lot of information considering that they both track incore state during
>> an xattr set/remove operation.  There's also a lot of duplication
>> between the do-while loop in xfs_attr_set_args and the inner loop of the
>> defer attr set code.
> Yes, to clarify a bit of the history: most of this was sort of adopted 
> from the efi/efd code as a sort model.  Most of the fields in the 
> xfs_attr_item are sort of like the parameters needed to kick off a 
> delayed operation.
> 
> The xfs_da_args and the xfs_delattr_context are an exception to that 
> model.  Most of the time, they're not even populated.  The reason they 
> are here is because they need to be instantiated somewhere not inside 
> the call stack of the delayed attr operations.  Otherwise we'd loose 
> them every time we come back with -EAGAIN.  In the non delayed attr 
> code, they are kept in the xfs_attr_*_args functions.  In the delayed 
> attr code path, they are kept here.
> 
> IOW: I had to plop them somewhere, and discovered that the *_items 
> remain instantiated across their corresponding delayed operations.  So 
> it seemed like a reasonable place?  I suspect attrs are the first 
> delayed operation to require a context of sorts as I did not see any of 
> the other delayed operations needing to deal with this issue.  So attr 
> operations a little unique in this way.
> 
> 
>>
>> To make sure I'm understanding this correctly, let me start by repeating
>> back to you what I think is the code flow through the hasdelattr path
>> and then the !hasdelattr path.  Let's call the hasdelattr path (A).
>>
>> First, the caller allocates an xfs_da_args structure and partially
>> initializes it with dp, attr_filter, attr_flags, name, namelen, value,
>> and valuelen set appropriately for the operation it wants.  The rest of
>> the struct should be zeroed, because the uninitialized parts are
>> internal state.
>>
>> Second, the *args are passed to xfs_attr_set, which after setting up a
>> transaction calls xfs_attr_set_deferred.  This calls xfs_attr_item_init
>> to allocate and initialize a struct xfs_attr_item with dp, name,
>> namelen, attr_filter, value, and valuelen, and passes this incore state
>> tracking structure to the defer ops machinery.
>>
>> Third, the defer ops machinery calls xfs_attr_finish_item to deal with
>> the attr request.  If the xfs_delattr_context within the xfs_attr_item
>> is uninitialized it willl set the xfs_da_args state that's within the
>> xfs_attr_item to the values already stored in the xfs_attr_item.
>>
>> Fourth, xfs_attr_finish_item calls xfs_trans_attr to dispatch based on
>> op_flags.  For setting, this means we call xfs_attr_set_iter.
>>
>> Fifth, xfs_attr_set_iter dispatches functions based on whatever
>> dela_state in the delattr_context is set to.  The functions it calls can
>> set DAC_DEFER_FINISH and/or return -EAGAIN to signal the defer ops
>> machinery that it needs to roll the transaction so that we can repeat
>> steps 3-5 until we're done.  The defer ops machinery ought to honor
>> DEFER_FINISH and complete whatever work items we've put on the queue,
>> but... it's buggy and doesn't.  I'll come back to this later.
> Oh you are right... this should be updated.  So the history was: at some 
> time during the review of the delayed ready series, it was proposed that 
> we have a top level loop that rolls the transactions, rather than trying 
> to plumb in an "off switch" for the transactions.  This looping concept 
> was already modeled here, so I had adopted it for use in the delay ready 
> series.
> 
> I did however, forget to go back and update it with the DEFER_FINISH 
> flags that we added later.  Or consolidate them, which I suspect is 
> where you are going with this... :-)
> 
>>
>> Sixth, once we're done, we return out to xfs_attr_set to commit the
>> transaction and exit.
>>
>> Did I understand that correctly? 
> That sounds about right
> 
> If so, I'll move on to the !hasdelattr
>> case, which we'll call (B).
>>
>> First, the caller allocates an xfs_da_args structure and partially
>> initializes it with dp, attr_filter, attr_flags, name, namelen, value,
>> and valuelen set appropriately for the operation it wants.  The rest of
>> the struct should be zeroed, because the uninitialized parts are
>> internal state.  This is the same as step A1 above.
>>
>> Second, the *args are passed to xfs_attr_set, which after setting up a
>> transaction calls xfs_attr_set_args.  This calls xfs_attr_set_iter,
>> which is the dela_state function dispatcher mentioned in step A5 above.
>> The functions it calls can set DAC_DEFER_FINISH to signal to
>> xfs_attr_set_args that it needs to complete whatever work items we've
>> attached to the transaction.  They can also return -EAGAIN to signal
>> to xfs_attr_set_args that it's time to roll the transaction.
>>
>> Third, once we're done, we return out of xfs_attr_set, same as step A6
>> above.
>>
>> Assuming I understood those two code paths correctly, I'll move on to
>> the attr item recovery case.  Call this (C).
> Sounds about right
> 
>>
>> First, xfs_attri_item_recover is called with a recovered incore log
>> item.  It allocates an xfs_da_args and fills out most of the same
>> fields that xfs_attr_set does in A1-A2 and B1-B2 above; and then it
>> allocates a transaction.
>>
>> Second, _recover has its own while loop(!) to call xfs_trans_attr, which
>> calls xfs_attr_set_iter, sort of like what A4 does.  I'll come back to
>> this later as well.
>>
>> Third, xfs_attr_set_iter uses dela_state to dispatch functions, similar
>> to what A5 does above.  If those functions set DAC_DEFER_FINISH or
>> return -EAGAIN, we'll pass that out to xfs_attr_set_iter to get the
>> transaction rolled so we can move on to the next state.
> Mmm, xfs_attr_set_iter doesn't roll transactions. xfs_attr_*_args does. 
> Perhaps the *_recover should follow suit, or be consolidated.
> 
>>
>> Fourth, when the loop is done we commit the transaction and move on with
>> whatever is next in log recovery.
>>
>> Does that sound right?  If so, let's move on to the issues I noted
>> above.
>>
>> I think the first problem is that this patchset adds two more xattr
>> operation state structures.  Current xfs_da_args store both the
>> operation arguments (inode, name, value, other flags) and most of the
>> state of the operation (whichfork, hashval, geo, block indices, rmt
>> block indices).  The series then adds a xfs_delattr_context that holds
>> more state that needs to survive a transaction roll (leafbp, rmt
>> mappings, da btree state, and dela_state).  Then, it adds yet another
>> xfs_attr_item that contains its own xfs_da_args and xfs_delattr_context,
>> and has a bunch more fields xattri_(ip, value, name, opflags, value)
>> that duplicate the fields that already exist in xfs_da_args.
>>
>> This is hard to follow.  I don't know what's the difference between
>> xfs_attr_item.xattri_name and xfs_attr_item.xattri_args.name, and I
>> suspect this makes xfs_attr_item much larger than it needs to be.
> Hmm, ok.  Let me see if I could get away with having just having args 
> and dac.  That might eliminate some of the overlap.
> 
>>
>> Question 1: Can we break up struct xfs_da_args?  Right now its field
>> definition is the union set of everything needed to track both a
>> directory operation and an xattr operation.  What do you think of
>> creating separate xfs_dirop_state and xfs_attrop_state structures that
>> each embed an xfs_da_args, and then move the dir and attr-specific
>> pieces out of xfs_da_args and into xfs_{dir,attr}op_state as
>> appropriate?  I think Christoph has suggested this elsewhere on the list
>> in the past.
>>
>> (Note that xfs_da_state is its own separate thing for dealing with
>> dabtree operations; that doesn't change.)
> Sure, let me dig around and see if I can better modularize args so that 
> we're not carrying around all the dir op stuff through all the attr op 
> stuff.
> 
>>
>> Question 2: Should we revise the arguments to xfs_attr_[gs]et?  Right
>> now the callers of these functions have to initialize the entire
>> xfs_da_state structure even though they only care about 7 of the 26
>> fields.  What do you think of changing the xfs_attr_[gs]et function
>> declarations to pass in the 7 arguments directly?  Or you could create a
>> new arguments struct?  If you did that, then xfs_args_[gs]et would be
>> responsible for allocating and initializing their internal state.  This
>> is cleaner interface-wise, 
> I can dig around and see if I can get something like that to work.  I 
> like the mini struct idea.  I suspect we'll end up with a few routines 
> with similar set of 7 params, so the struct makes sense
> 
> and leads me into...
>>
>> Question 3: Instead of creating separate xfs_delattr_context
>> andxfs_attr_item structs, can you put all the stuff those structures
>> track into xfs_attrop_state? 
> Where xfs_attrop_state is the combination of xfs_delattr_context, 
> xfs_attr_item, and a subset of xfs_da_args?
> 
> I sense that the duplication and pointer
>> indirection in _delattr_context and _attr_item might be a result of it
>> not being all that clear where the xfs_da_args is actually allocated,
>> and therefore the scoping rules.  Would all that be clearer if all the
>> new state was thrown into the same xfs_attrop_state that we dynamically
>> allocate at the start of xfs_attr_[gs]et()?  (Yes, this question's
>> existence depends on your answer to Q2.)
> I suppose it could me made to work?  I think we're starting to glob 
> together members that belong to slightly similar scopes, so the real 
> question would be: Are people going to be amicable to seeing it that way?
> 
> The xfs_attr_item was sort of modeled from xfs_extent_free_item.  In 
> general these structs are meant to function as sort of items in a list 
> of log items.  Hats why they all have the list_head field at a minimum. 
> (xfs_bmap_intent, xfs_extent_free_item, xfs_refcount_intent, 
> xfs_rmap_intent, are similar in this way.  They all have their own 
> corresponding *_finish_item routines whose purpose is to unpack the item 
> and hand it off to it's corresponding *_trans routines).  It seemed to 
> be a sort of established pattern, so I figured I should fall in line 
> with that.
> 
> xfs_delattr_context is a bit of an odd ball.  It doesn't really 
> represent a set of associated properties like names and values and such. 
>   It's really more about bookmarking a position in a sequence of events. 
> So their their contents really have no meaning outside this context. For 
> example, blkcnt is used during attr grow an shrink operations, but an 
> attr doesn't otherwise normally have a block count associated with it.
> 
> I personally think it's a bit messy to try and lump all of that 
> together, but it's really an aesthetic thing. Ultimately that is going 
> to come down to the cross section of opinions that people are most 
> comfortable seeing. :-)
> 
>>
>> Question 4: Does xfs_attr_item_init need to allocate space to hold the
>> name and value buffers when it is called from xfs_attr_set?
> It would if it were ever used in a routine that passed name and value as 
> local params, and then exited before finishing the transaction, or if it 
> in anyway manipulated their values in a way not meant to be reflected in 
> the delayed operation.
> 
> I'm not sure if there's an instance where we do this, but I'd really 
> have to try it and see. Will verify.
> 
>> xfs_attr_set does not return until we're completely finished with the
>> deferred xattr processing, which means that the buffers passed into
>> xfs_attr_set cannot go out of scope, right?
>>
>> (I think you /do/ need to allocate separate buffers for log recovery.)
> Yes, the on disk structs are xfs_attri_log_format and xfs_attrd_log_format
> 
>>
>> My second set of questions revolve around the duplication of attr
>> operation loops between xfs_attr_set_args() and the defer ops code.
>> AFAICT there's no reason to have xfs_attr_set_args, since there is no
>> requirement in the deferred ops machinery to create log intent or log
>> done items.
> Yes, let me see if I can consolidate that, I forgot that I had nabbed 
> the looping code from later in the set and pulled it downwards some time 
> ago.   I'm thinking maybe xfs_attri_item_recover should just unpack the 
> log item and pipe it through to xfs_attr_set_args
> 
>>
>> Question 5: Instead of open-coding a do {attrset roll hold} loop in
>> xfs_attr_set_args, what do you think about setting up the deferred op
>> code (xfs_attr_defer_type and the functions assigned to it in patch 4)
>> to do that from the start?  By adding the defer op code early, patch 2
>> would create xfs_attr_set_iter as it does now, and xfs_attr_finish_item
>> would call it directly.  Since there's no log item defined yet, the
>> other defer ops functions (create_intent, abort_intent, create_done) can
>> return NULL log item pointers.
>>
> K, this one I'm having a hard time following.... the purpose of 
> xis_tart_finish_item is to unpack the xis_tart_item, and must also 
> adhere to the xfs_defer_op_type.finish_item signature.  It doesn't loop 
> like xfs_attr_set_args does because the calling delayed operation 
> infrastructure already does that (see the loop in xfs_defer_finish_one). 
>   Without the delayed operation machinery in the picture, a non delayed 
> attribute is going to need an equivalent loop somewhere.  We can 
> consolidate it with the loop we see in the recovery path, but we do need 
> to keep at least one loop somewhere, and it cant be in 
> xfs_attr_finish_item.
Sorry xis_tart_finish_item should read xfs_attr_finish_item and 
xis_tart_item should be xis_attr_item.

need to keep closer eye on spell checker...

> 
>> Once you get to the point whre you have defined the log items, you can
>> add in all the other log item handling (i.e. xfs_attr[id]_item_ops).  As
>> an example of a defer op that optionally records changes to its incore
>> operation state with log items, see xfs_swapext_defer_type[1].
>>
>> [1] 
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=atomic-file-updates&id=53c7233842969347174e8d68c8486dbf3efb734c__;!!GqivPVa7Brio!N0NsMhrByLcmev5aFDxTBS_VvzIbprn_VmNb4kY_gw4ADR0q1ERQzlaQe-tjnhXmUNhu$ 
>>
> Ok, let me go through that, maybe I'm missing something here
> 
>>
>> Moving along to the DEFER_FINISH question that I said I'd get back to
>> later -- there's a subtle difference to the order in which deferred log
>> items that are created while trying to make progress on an xattr op are
>> finished.  This is due to a design wart of the original defer ops
>> machinery, and Brian and I have discussed this previously.
>>
>> In a nutshell, let's pretend that step 1 of an xattr operation creates
>> new deferred ops ABCD and step 2 creates new deferred ops EFGH.  Let's
>> also pretend that step 1 and step 2 both set DEFER_FINISH.  In the
>> !delattr case, xfs_attr_set_args -> xfs_attr_trans_roll will run step 1,
>> process A->B->C->D, roll, run step 2, and then process E->F->G->H and
>> commit.
>>
>> In the delattr case, however, the defer ops machinery shoves all the new
>> defer ops to the end of the queue, which means that we run step 1, roll,
>> run step 2, and then run A->B->C->D->E->F->G->H and commit.  I would
>> like to fix that, since it seems more logical to me that you'd finish
>> A-D before moving on to the second phase; and the atomic swapext code is
>> going to require that.
>>
>> Question 6: So, uh, can you go have a look at the latest patches[2]?
>> I'll post them soon if I can get past the bigtime review.  I don't think
>> this wart of the defer ops mechanism affects your patchset, but you know
>> how deferred attrs work better than I. :)
>>
>> [2] 
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=defer-ops-stalls__;!!GqivPVa7Brio!N0NsMhrByLcmev5aFDxTBS_VvzIbprn_VmNb4kY_gw4ADR0q1ERQzlaQe-tjnqXvaBRR$ 
>>
> Oh ok.  Sure, will take a look
> 
>>
>> I also had a couple questions (observations?) about how log recovery
>> works for attr items, because I noticed that xfs_attri_item_recover also
>> has a do {attrset, roll} loop.
>>
>> HAH, I just realized (while writing Q7) that xfs_defer_move needs to log
>> intent items for each newly scheduled work item because if log recovery
>> crashes after finishing the existing intent items but before it gets to
>> the new intent items, the next attempt at log recovery will not see the
>> missing intents and will /never/ even be aware that it should have
>> finished a chain.  That leads to fs corruption!  So that series has more
>> work to do, and you can set Q6 aside for now.
> :-)  I may take a peek anyway
> 
>>
>> Question 7: Why is there a do {attrset, roll} loop in the recovery
>> routine?  Log intent item recovery functions are only supposed to
>> complete a single transaction's worth of work.  If there's more work to
>> do, the recovery function should attach a new defer ops item to the
>> transaction to schedule the rest of the work, and use xfs_defer_move
>> to attach the list of new defer ops to *parent_tp.
> Oh ok.  I wasnt aware of how that was supposed to work.  Will update.
> 
>>
>> The reason for this is that log recovery has to finish every unfinished
>> intent item that was in the log before it can move on to new log items
>> that were created as a result of recovering log items.
> Ok, so maybe we dont consolidate the loops since this one will need to 
> go away.  Thanks for the catch though!
> 
>>
>> Ok, that's probably enough questions for now.
>>
>> --D
> 
> Thanks!  I know it's a lot!!
> Allison
> 
>>
>>> +
>>> +#define XFS_ATTR_ITEM_SIZEOF(namelen, valuelen)    \
>>> +    (sizeof(struct xfs_attr_item) + (namelen) + (valuelen))
>>
>>> +
>>> +
>>>   
>>> /*======================================================================== 
>>>
>>>    * Function prototypes for the kernel.
>>>    
>>> *========================================================================*/ 
>>>
>>> @@ -283,11 +319,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args 
>>> *args);
>>>   int xfs_attr_get(struct xfs_da_args *args);
>>>   int xfs_attr_set(struct xfs_da_args *args);
>>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>> +int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>>> +              struct xfs_buf **leaf_bp);
>>>   int xfs_has_attr(struct xfs_da_args *args);
>>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>>   int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>>>   bool xfs_attr_namecheck(const void *name, size_t length);
>>>   void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>>>                     struct xfs_da_args *args);
>>> +int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>>>   #endif    /* __XFS_ATTR_H__ */
>>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>>> index d8f5862..4392279 100644
>>> --- a/fs/xfs/libxfs/xfs_defer.c
>>> +++ b/fs/xfs/libxfs/xfs_defer.c
>>> @@ -176,6 +176,7 @@ static const struct xfs_defer_op_type 
>>> *defer_op_types[] = {
>>>       [XFS_DEFER_OPS_TYPE_RMAP]    = &xfs_rmap_update_defer_type,
>>>       [XFS_DEFER_OPS_TYPE_FREE]    = &xfs_extent_free_defer_type,
>>>       [XFS_DEFER_OPS_TYPE_AGFL_FREE]    = &xfs_agfl_free_defer_type,
>>> +    [XFS_DEFER_OPS_TYPE_ATTR]    = &xfs_attr_defer_type,
>>>   };
>>>   static void
>>> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
>>> index 6b2ca58..193d3bb 100644
>>> --- a/fs/xfs/libxfs/xfs_defer.h
>>> +++ b/fs/xfs/libxfs/xfs_defer.h
>>> @@ -18,6 +18,7 @@ enum xfs_defer_ops_type {
>>>       XFS_DEFER_OPS_TYPE_RMAP,
>>>       XFS_DEFER_OPS_TYPE_FREE,
>>>       XFS_DEFER_OPS_TYPE_AGFL_FREE,
>>> +    XFS_DEFER_OPS_TYPE_ATTR,
>>>       XFS_DEFER_OPS_TYPE_MAX,
>>>   };
>>> @@ -62,5 +63,7 @@ extern const struct xfs_defer_op_type 
>>> xfs_refcount_update_defer_type;
>>>   extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>>>   extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>>>   extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>>> +extern const struct xfs_defer_op_type xfs_attr_defer_type;
>>> +
>>>   #endif /* __XFS_DEFER_H__ */
>>> diff --git a/fs/xfs/libxfs/xfs_log_format.h 
>>> b/fs/xfs/libxfs/xfs_log_format.h
>>> index e3400c9..33b26b6 100644
>>> --- a/fs/xfs/libxfs/xfs_log_format.h
>>> +++ b/fs/xfs/libxfs/xfs_log_format.h
>>> @@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
>>>   #define XLOG_REG_TYPE_CUD_FORMAT    24
>>>   #define XLOG_REG_TYPE_BUI_FORMAT    25
>>>   #define XLOG_REG_TYPE_BUD_FORMAT    26
>>> -#define XLOG_REG_TYPE_MAX        26
>>> +#define XLOG_REG_TYPE_ATTRI_FORMAT    27
>>> +#define XLOG_REG_TYPE_ATTRD_FORMAT    28
>>> +#define XLOG_REG_TYPE_ATTR_NAME    29
>>> +#define XLOG_REG_TYPE_ATTR_VALUE    30
>>> +#define XLOG_REG_TYPE_MAX        30
>>> +
>>>   /*
>>>    * Flags to log operation header
>>> @@ -240,6 +245,8 @@ typedef struct xfs_trans_header {
>>>   #define    XFS_LI_CUD        0x1243
>>>   #define    XFS_LI_BUI        0x1244    /* bmbt update intent */
>>>   #define    XFS_LI_BUD        0x1245
>>> +#define    XFS_LI_ATTRI        0x1246  /* attr set/remove intent*/
>>> +#define    XFS_LI_ATTRD        0x1247  /* attr set/remove done */
>>>   #define XFS_LI_TYPE_DESC \
>>>       { XFS_LI_EFI,        "XFS_LI_EFI" }, \
>>> @@ -255,7 +262,9 @@ typedef struct xfs_trans_header {
>>>       { XFS_LI_CUI,        "XFS_LI_CUI" }, \
>>>       { XFS_LI_CUD,        "XFS_LI_CUD" }, \
>>>       { XFS_LI_BUI,        "XFS_LI_BUI" }, \
>>> -    { XFS_LI_BUD,        "XFS_LI_BUD" }
>>> +    { XFS_LI_BUD,        "XFS_LI_BUD" }, \
>>> +    { XFS_LI_ATTRI,        "XFS_LI_ATTRI" }, \
>>> +    { XFS_LI_ATTRD,        "XFS_LI_ATTRD" }
>>>   /*
>>>    * Inode Log Item Format definitions.
>>> @@ -860,4 +869,35 @@ struct xfs_icreate_log {
>>>       __be32        icl_gen;    /* inode generation number to use */
>>>   };
>>> +/*
>>> + * Flags for deferred attribute operations.
>>> + * Upper bits are flags, lower byte is type code
>>> + */
>>> +#define XFS_ATTR_OP_FLAGS_SET        1    /* Set the attribute */
>>> +#define XFS_ATTR_OP_FLAGS_REMOVE    2    /* Remove the attribute */
>>> +#define XFS_ATTR_OP_FLAGS_TYPE_MASK    0x0FF    /* Flags type mask */
>>> +
>>> +/*
>>> + * This is the structure used to lay out an attr log item in the
>>> + * log.
>>> + */
>>> +struct xfs_attri_log_format {
>>> +    uint16_t    alfi_type;    /* attri log item type */
>>> +    uint16_t    alfi_size;    /* size of this item */
>>> +    uint32_t    __pad;        /* pad to 64 bit aligned */
>>> +    uint64_t    alfi_id;    /* attri identifier */
>>> +    xfs_ino_t       alfi_ino;    /* the inode for this attr 
>>> operation */
>>> +    uint32_t        alfi_op_flags;    /* marks the op as a set or 
>>> remove */
>>> +    uint32_t        alfi_name_len;    /* attr name length */
>>> +    uint32_t        alfi_value_len;    /* attr value length */
>>> +    uint32_t        alfi_attr_flags;/* attr flags */
>>> +};
>>> +
>>> +struct xfs_attrd_log_format {
>>> +    uint16_t    alfd_type;    /* attrd log item type */
>>> +    uint16_t    alfd_size;    /* size of this item */
>>> +    uint32_t    __pad;        /* pad to 64 bit aligned */
>>> +    uint64_t    alfd_alf_id;    /* id of corresponding attrd */
>>> +};
>>> +
>>>   #endif /* __XFS_LOG_FORMAT_H__ */
>>> diff --git a/fs/xfs/libxfs/xfs_log_recover.h 
>>> b/fs/xfs/libxfs/xfs_log_recover.h
>>> index 641132d..b0b8e94 100644
>>> --- a/fs/xfs/libxfs/xfs_log_recover.h
>>> +++ b/fs/xfs/libxfs/xfs_log_recover.h
>>> @@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops 
>>> xlog_rui_item_ops;
>>>   extern const struct xlog_recover_item_ops xlog_rud_item_ops;
>>>   extern const struct xlog_recover_item_ops xlog_cui_item_ops;
>>>   extern const struct xlog_recover_item_ops xlog_cud_item_ops;
>>> +extern const struct xlog_recover_item_ops xlog_attri_item_ops;
>>> +extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
>>>   /*
>>>    * Macros, structures, prototypes for internal log manager use.
>>> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
>>> index 397d947..860cdd2 100644
>>> --- a/fs/xfs/libxfs/xfs_types.h
>>> +++ b/fs/xfs/libxfs/xfs_types.h
>>> @@ -11,6 +11,7 @@ typedef uint32_t    prid_t;        /* project ID */
>>>   typedef uint32_t    xfs_agblock_t;    /* blockno in alloc. group */
>>>   typedef uint32_t    xfs_agino_t;    /* inode # within allocation 
>>> grp */
>>>   typedef uint32_t    xfs_extlen_t;    /* extent length in blocks */
>>> +typedef uint32_t    xfs_attrlen_t;    /* attr length */
>>>   typedef uint32_t    xfs_agnumber_t;    /* allocation group number */
>>>   typedef int32_t        xfs_extnum_t;    /* # of extents in a file */
>>>   typedef int16_t        xfs_aextnum_t;    /* # extents in an 
>>> attribute fork */
>>> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
>>> index 1887605..9a649d1 100644
>>> --- a/fs/xfs/scrub/common.c
>>> +++ b/fs/xfs/scrub/common.c
>>> @@ -24,6 +24,8 @@
>>>   #include "xfs_rmap_btree.h"
>>>   #include "xfs_log.h"
>>>   #include "xfs_trans_priv.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_reflink.h"
>>>   #include "scrub/scrub.h"
>>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
>>> index d4c687b5c..2fa173a 100644
>>> --- a/fs/xfs/xfs_acl.c
>>> +++ b/fs/xfs/xfs_acl.c
>>> @@ -10,6 +10,8 @@
>>>   #include "xfs_trans_resv.h"
>>>   #include "xfs_mount.h"
>>>   #include "xfs_inode.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_trace.h"
>>>   #include "xfs_error.h"
>>> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
>>> new file mode 100644
>>> index 0000000..923c288
>>> --- /dev/null
>>> +++ b/fs/xfs/xfs_attr_item.c
>>> @@ -0,0 +1,829 @@
>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>> +/*
>>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
>>> + * Author: Allison Collins <allison.henderson@oracle.com>
>>> + */
>>> +
>>> +#include "xfs.h"
>>> +#include "xfs_fs.h"
>>> +#include "xfs_format.h"
>>> +#include "xfs_log_format.h"
>>> +#include "xfs_trans_resv.h"
>>> +#include "xfs_bit.h"
>>> +#include "xfs_shared.h"
>>> +#include "xfs_mount.h"
>>> +#include "xfs_defer.h"
>>> +#include "xfs_trans.h"
>>> +#include "xfs_trans_priv.h"
>>> +#include "xfs_buf_item.h"
>>> +#include "xfs_attr_item.h"
>>> +#include "xfs_log.h"
>>> +#include "xfs_btree.h"
>>> +#include "xfs_rmap.h"
>>> +#include "xfs_inode.h"
>>> +#include "xfs_icache.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>> +#include "xfs_attr.h"
>>> +#include "xfs_shared.h"
>>> +#include "xfs_attr_item.h"
>>> +#include "xfs_alloc.h"
>>> +#include "xfs_bmap.h"
>>> +#include "xfs_trace.h"
>>> +#include "libxfs/xfs_da_format.h"
>>> +#include "xfs_inode.h"
>>> +#include "xfs_quota.h"
>>> +#include "xfs_log_priv.h"
>>> +#include "xfs_log_recover.h"
>>> +
>>> +static const struct xfs_item_ops xfs_attri_item_ops;
>>> +static const struct xfs_item_ops xfs_attrd_item_ops;
>>> +
>>> +static inline struct xfs_attri_log_item *ATTRI_ITEM(struct 
>>> xfs_log_item *lip)
>>> +{
>>> +    return container_of(lip, struct xfs_attri_log_item, attri_item);
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attri_item_free(
>>> +    struct xfs_attri_log_item    *attrip)
>>> +{
>>> +    kmem_free(attrip->attri_item.li_lv_shadow);
>>> +    kmem_free(attrip);
>>> +}
>>> +
>>> +/*
>>> + * Freeing the attrip requires that we remove it from the AIL if it 
>>> has already
>>> + * been placed there. However, the ATTRI may not yet have been 
>>> placed in the
>>> + * AIL when called by xfs_attri_release() from ATTRD processing due 
>>> to the
>>> + * ordering of committed vs unpin operations in bulk insert 
>>> operations. Hence
>>> + * the reference count to ensure only the last caller frees the ATTRI.
>>> + */
>>> +STATIC void
>>> +xfs_attri_release(
>>> +    struct xfs_attri_log_item    *attrip)
>>> +{
>>> +    ASSERT(atomic_read(&attrip->attri_refcount) > 0);
>>> +    if (atomic_dec_and_test(&attrip->attri_refcount)) {
>>> +        xfs_trans_ail_delete(&attrip->attri_item,
>>> +                     SHUTDOWN_LOG_IO_ERROR);
>>> +        xfs_attri_item_free(attrip);
>>> +    }
>>> +}
>>> +
>>> +/*
>>> + * This returns the number of iovecs needed to log the given attri 
>>> item. We
>>> + * only need 1 iovec for an attri item.  It just logs the 
>>> attr_log_format
>>> + * structure.
>>> + */
>>> +static inline int
>>> +xfs_attri_item_sizeof(
>>> +    struct xfs_attri_log_item *attrip)
>>> +{
>>> +    return sizeof(struct xfs_attri_log_format);
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attri_item_size(
>>> +    struct xfs_log_item    *lip,
>>> +    int            *nvecs,
>>> +    int            *nbytes)
>>> +{
>>> +    struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
>>> +
>>> +    *nvecs += 1;
>>> +    *nbytes += xfs_attri_item_sizeof(attrip);
>>> +
>>> +    /* Attr set and remove operations require a name */
>>> +    ASSERT(attrip->attri_name_len > 0);
>>> +
>>> +    *nvecs += 1;
>>> +    *nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
>>> +
>>> +    /*
>>> +     * Set ops can accept a value of 0 len to clear an attr value.  
>>> Remove
>>> +     * ops do not need a value at all.  So only account for the value
>>> +     * when it is needed.
>>> +     */
>>> +    if (attrip->attri_value_len > 0) {
>>> +        *nvecs += 1;
>>> +        *nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
>>> +    }
>>> +}
>>> +
>>> +/*
>>> + * This is called to fill in the log iovecs for the given attri log
>>> + * item. We use  1 iovec for the attri_format_item, 1 for the name, and
>>> + * another for the value if it is present
>>> + */
>>> +STATIC void
>>> +xfs_attri_item_format(
>>> +    struct xfs_log_item    *lip,
>>> +    struct xfs_log_vec    *lv)
>>> +{
>>> +    struct xfs_attri_log_item    *attrip = ATTRI_ITEM(lip);
>>> +    struct xfs_log_iovec        *vecp = NULL;
>>> +
>>> +    attrip->attri_format.alfi_type = XFS_LI_ATTRI;
>>> +    attrip->attri_format.alfi_size = 1;
>>> +
>>> +    /*
>>> +     * This size accounting must be done before copying the attrip 
>>> into the
>>> +     * iovec.  If we do it after, the wrong size will be recorded to 
>>> the log
>>> +     * and we trip across assertion checks for bad region sizes 
>>> later during
>>> +     * the log recovery.
>>> +     */
>>> +
>>> +    ASSERT(attrip->attri_name_len > 0);
>>> +    attrip->attri_format.alfi_size++;
>>> +
>>> +    if (attrip->attri_value_len > 0)
>>> +        attrip->attri_format.alfi_size++;
>>> +
>>> +    xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>>> +            &attrip->attri_format,
>>> +            xfs_attri_item_sizeof(attrip));
>>> +    if (attrip->attri_name_len > 0)
>>> +        xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
>>> +                attrip->attri_name,
>>> +                ATTR_NVEC_SIZE(attrip->attri_name_len));
>>> +
>>> +    if (attrip->attri_value_len > 0)
>>> +        xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
>>> +                attrip->attri_value,
>>> +                ATTR_NVEC_SIZE(attrip->attri_value_len));
>>> +}
>>> +
>>> +/*
>>> + * The unpin operation is the last place an ATTRI is manipulated in 
>>> the log. It
>>> + * is either inserted in the AIL or aborted in the event of a log 
>>> I/O error. In
>>> + * either case, the ATTRI transaction has been successfully 
>>> committed to make
>>> + * it this far. Therefore, we expect whoever committed the ATTRI to 
>>> either
>>> + * construct and commit the ATTRD or drop the ATTRD's reference in 
>>> the event of
>>> + * error. Simply drop the log's ATTRI reference now that the log is 
>>> done with
>>> + * it.
>>> + */
>>> +STATIC void
>>> +xfs_attri_item_unpin(
>>> +    struct xfs_log_item    *lip,
>>> +    int            remove)
>>> +{
>>> +    struct xfs_attri_log_item    *attrip = ATTRI_ITEM(lip);
>>> +
>>> +    xfs_attri_release(attrip);
>>> +}
>>> +
>>> +
>>> +STATIC void
>>> +xfs_attri_item_release(
>>> +    struct xfs_log_item    *lip)
>>> +{
>>> +    xfs_attri_release(ATTRI_ITEM(lip));
>>> +}
>>> +
>>> +/*
>>> + * Allocate and initialize an attri item
>>> + */
>>> +STATIC struct xfs_attri_log_item *
>>> +xfs_attri_init(
>>> +    struct xfs_mount    *mp)
>>> +
>>> +{
>>> +    struct xfs_attri_log_item    *attrip;
>>> +    uint                size;
>>> +
>>> +    size = (uint)(sizeof(struct xfs_attri_log_item));
>>> +    attrip = kmem_zalloc(size, 0);
>>> +
>>> +    xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
>>> +              &xfs_attri_item_ops);
>>> +    attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
>>> +    atomic_set(&attrip->attri_refcount, 2);
>>> +
>>> +    return attrip;
>>> +}
>>> +
>>> +/*
>>> + * Copy an attr format buffer from the given buf, and into the 
>>> destination attr
>>> + * format structure.
>>> + */
>>> +STATIC int
>>> +xfs_attri_copy_format(struct xfs_log_iovec *buf,
>>> +              struct xfs_attri_log_format *dst_attr_fmt)
>>> +{
>>> +    struct xfs_attri_log_format *src_attr_fmt = buf->i_addr;
>>> +    uint len = sizeof(struct xfs_attri_log_format);
>>> +
>>> +    if (buf->i_len != len)
>>> +        return -EFSCORRUPTED;
>>> +
>>> +    memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
>>> +    return 0;
>>> +}
>>> +
>>> +static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct 
>>> xfs_log_item *lip)
>>> +{
>>> +    return container_of(lip, struct xfs_attrd_log_item, attrd_item);
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
>>> +{
>>> +    kmem_free(attrdp->attrd_item.li_lv_shadow);
>>> +    kmem_free(attrdp);
>>> +}
>>> +
>>> +/*
>>> + * This returns the number of iovecs needed to log the given attrd 
>>> item.
>>> + * We only need 1 iovec for an attrd item.  It just logs the 
>>> attr_log_format
>>> + * structure.
>>> + */
>>> +static inline int
>>> +xfs_attrd_item_sizeof(
>>> +    struct xfs_attrd_log_item *attrdp)
>>> +{
>>> +    return sizeof(struct xfs_attrd_log_format);
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attrd_item_size(
>>> +    struct xfs_log_item    *lip,
>>> +    int            *nvecs,
>>> +    int            *nbytes)
>>> +{
>>> +    struct xfs_attrd_log_item    *attrdp = ATTRD_ITEM(lip);
>>> +    *nvecs += 1;
>>> +    *nbytes += xfs_attrd_item_sizeof(attrdp);
>>> +}
>>> +
>>> +/*
>>> + * This is called to fill in the log iovecs for the given attrd log 
>>> item. We use
>>> + * only 1 iovec for the attrd_format, and we point that at the 
>>> attr_log_format
>>> + * structure embedded in the attrd item.
>>> + */
>>> +STATIC void
>>> +xfs_attrd_item_format(
>>> +    struct xfs_log_item    *lip,
>>> +    struct xfs_log_vec    *lv)
>>> +{
>>> +    struct xfs_attrd_log_item    *attrdp = ATTRD_ITEM(lip);
>>> +    struct xfs_log_iovec        *vecp = NULL;
>>> +
>>> +    attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>>> +    attrdp->attrd_format.alfd_size = 1;
>>> +
>>> +    xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
>>> +            &attrdp->attrd_format, xfs_attrd_item_sizeof(attrdp));
>>> +}
>>> +
>>> +/*
>>> + * The ATTRD is either committed or aborted if the transaction is 
>>> cancelled. If
>>> + * the transaction is cancelled, drop our reference to the ATTRI and 
>>> free the
>>> + * ATTRD.
>>> + */
>>> +STATIC void
>>> +xfs_attrd_item_release(
>>> +    struct xfs_log_item     *lip)
>>> +{
>>> +    struct xfs_attrd_log_item *attrdp = ATTRD_ITEM(lip);
>>> +    xfs_attri_release(attrdp->attrd_attrip);
>>> +    xfs_attrd_item_free(attrdp);
>>> +}
>>> +
>>> +/*
>>> + * Log an ATTRI it to the ATTRD when the attr op is done.  An attr 
>>> operation
>>> + * may be a set or a remove.  Note that the transaction is marked dirty
>>> + * regardless of whether the operation succeeds or fails to support the
>>> + * ATTRI/ATTRD lifecycle rules.
>>> + */
>>> +int
>>> +xfs_trans_attr(
>>> +    struct xfs_delattr_context    *dac,
>>> +    struct xfs_attrd_log_item    *attrdp,
>>> +    struct xfs_buf            **leaf_bp,
>>> +    uint32_t            op_flags)
>>> +{
>>> +    struct xfs_da_args        *args = dac->da_args;
>>> +    int                error;
>>> +
>>> +    error = xfs_qm_dqattach_locked(args->dp, 0);
>>> +    if (error)
>>> +        return error;
>>> +
>>> +    switch (op_flags) {
>>> +    case XFS_ATTR_OP_FLAGS_SET:
>>> +        args->op_flags |= XFS_DA_OP_ADDNAME;
>>> +        error = xfs_attr_set_iter(dac, leaf_bp);
>>> +        break;
>>> +    case XFS_ATTR_OP_FLAGS_REMOVE:
>>> +        ASSERT(XFS_IFORK_Q((args->dp)));
>>> +        error = xfs_attr_remove_iter(dac);
>>> +        break;
>>> +    default:
>>> +        error = -EFSCORRUPTED;
>>> +        break;
>>> +    }
>>> +
>>> +    /*
>>> +     * Mark the transaction dirty, even on error. This ensures the
>>> +     * transaction is aborted, which:
>>> +     *
>>> +     * 1.) releases the ATTRI and frees the ATTRD
>>> +     * 2.) shuts down the filesystem
>>> +     */
>>> +    args->trans->t_flags |= XFS_TRANS_DIRTY;
>>> +    set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>>> +
>>> +    return error;
>>> +}
>>> +
>>> +/* Log an attr to the intent item. */
>>> +STATIC void
>>> +xfs_attr_log_item(
>>> +    struct xfs_trans        *tp,
>>> +    struct xfs_attri_log_item    *attrip,
>>> +    struct xfs_attr_item        *attr)
>>> +{
>>> +    struct xfs_attri_log_format    *attrp;
>>> +    char                *name_value;
>>> +
>>> +    name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
>>> +
>>> +    tp->t_flags |= XFS_TRANS_DIRTY;
>>> +    set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
>>> +
>>> +    /*
>>> +     * At this point the xfs_attr_item has been constructed, and we've
>>> +     * created the log intent. Fill in the attri log item and log 
>>> format
>>> +     * structure with fields from this xfs_attr_item
>>> +     */
>>> +    attrp = &attrip->attri_format;
>>> +    attrp->alfi_ino = attr->xattri_ip->i_ino;
>>> +    attrp->alfi_op_flags = attr->xattri_op_flags;
>>> +    attrp->alfi_value_len = attr->xattri_value_len;
>>> +    attrp->alfi_name_len = attr->xattri_name_len;
>>> +    attrp->alfi_attr_flags = attr->xattri_flags;
>>> +
>>> +    attrip->attri_name = name_value;
>>> +    attrip->attri_value = &name_value[attr->xattri_name_len];
>>> +    attrip->attri_name_len = attr->xattri_name_len;
>>> +    attrip->attri_value_len = attr->xattri_value_len;
>>> +}
>>> +
>>> +/* Get an ATTRI. */
>>> +static struct xfs_log_item *
>>> +xfs_attr_create_intent(
>>> +    struct xfs_trans        *tp,
>>> +    struct list_head        *items,
>>> +    unsigned int            count,
>>> +    bool                sort)
>>> +{
>>> +    struct xfs_mount        *mp = tp->t_mountp;
>>> +    struct xfs_attri_log_item    *attrip = xfs_attri_init(mp);
>>> +    struct xfs_attr_item        *attr;
>>> +
>>> +    ASSERT(count == 1);
>>> +
>>> +    xfs_trans_add_item(tp, &attrip->attri_item);
>>> +    list_for_each_entry(attr, items, xattri_list)
>>> +        xfs_attr_log_item(tp, attrip, attr);
>>> +    return &attrip->attri_item;
>>> +}
>>> +
>>> +/* Process an attr. */
>>> +STATIC int
>>> +xfs_attr_finish_item(
>>> +    struct xfs_trans        *tp,
>>> +    struct xfs_log_item        *done,
>>> +    struct list_head        *item,
>>> +    struct xfs_btree_cur        **state)
>>> +{
>>> +    struct xfs_attr_item        *attr;
>>> +    int                error;
>>> +    int                local;
>>> +    struct xfs_delattr_context    *dac;
>>> +    struct xfs_da_args        *args;
>>> +    struct xfs_attrd_log_item    *attrdp;
>>> +    struct xfs_attri_log_item    *attrip;
>>> +
>>> +    attr = container_of(item, struct xfs_attr_item, xattri_list);
>>> +    dac = &attr->xattri_dac;
>>> +    args = &attr->xattri_args;
>>> +
>>> +    if (!(dac->flags & XFS_DAC_DELAYED_OP_INIT)) {
>>> +        /* Only need to initialize args context once */
>>> +        memset(args, 0, sizeof(*args));
>>> +        args->geo = attr->xattri_ip->i_mount->m_attr_geo;
>>> +        args->whichfork = XFS_ATTR_FORK;
>>> +        args->dp = attr->xattri_ip;
>>> +        args->name = ((const unsigned char *)attr) +
>>> +                  sizeof(struct xfs_attr_item);
>>> +        args->namelen = attr->xattri_name_len;
>>> +        args->attr_filter = attr->xattri_flags;
>>> +        args->hashval = xfs_da_hashname(args->name, args->namelen);
>>> +        args->value = (void *)&args->name[attr->xattri_name_len];
>>> +        args->valuelen = attr->xattri_value_len;
>>> +        args->op_flags = XFS_DA_OP_OKNOENT;
>>> +
>>> +        /* must match existing transaction block res */
>>> +        args->total = xfs_attr_calc_size(args, &local);
>>> +
>>> +        memset(dac, 0, sizeof(struct xfs_delattr_context));
>>> +        dac->flags |= XFS_DAC_DELAYED_OP_INIT;
>>> +        dac->da_args = args;
>>> +    }
>>> +
>>> +    /*
>>> +     * Always reset trans after EAGAIN cycle
>>> +     * since the transaction is new
>>> +     */
>>> +    args->trans = tp;
>>> +
>>> +    error = xfs_trans_attr(dac, ATTRD_ITEM(done), &dac->leaf_bp,
>>> +                   attr->xattri_op_flags);
>>> +    /*
>>> +     * The attrip refers to xfs_attr_item memory to log the name and 
>>> value
>>> +     * with the intent item. This already occurred when the intent was
>>> +     * committed so these fields are no longer accessed. Clear them 
>>> out of
>>> +     * caution since we're about to free the xfs_attr_item.
>>> +     */
>>> +    attrdp = (struct xfs_attrd_log_item *)done;
>>> +    attrip = attrdp->attrd_attrip;
>>> +    attrip->attri_name = NULL;
>>> +    attrip->attri_value = NULL;
>>> +
>>> +    if (error != -EAGAIN)
>>> +        kmem_free(attr);
>>> +
>>> +    return error;
>>> +}
>>> +
>>> +/* Abort all pending ATTRs. */
>>> +STATIC void
>>> +xfs_attr_abort_intent(
>>> +    struct xfs_log_item        *intent)
>>> +{
>>> +    xfs_attri_release(ATTRI_ITEM(intent));
>>> +}
>>> +
>>> +/* Cancel an attr */
>>> +STATIC void
>>> +xfs_attr_cancel_item(
>>> +    struct list_head        *item)
>>> +{
>>> +    struct xfs_attr_item        *attr;
>>> +
>>> +    attr = container_of(item, struct xfs_attr_item, xattri_list);
>>> +    kmem_free(attr);
>>> +}
>>> +
>>> +/*
>>> + * The ATTRI is logged only once and cannot be moved in the log, so 
>>> simply
>>> + * return the lsn at which it's been logged.
>>> + */
>>> +STATIC xfs_lsn_t
>>> +xfs_attri_item_committed(
>>> +    struct xfs_log_item    *lip,
>>> +    xfs_lsn_t        lsn)
>>> +{
>>> +    return lsn;
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attri_item_committing(
>>> +    struct xfs_log_item    *lip,
>>> +    xfs_lsn_t        lsn)
>>> +{
>>> +}
>>> +
>>> +STATIC bool
>>> +xfs_attri_item_match(
>>> +    struct xfs_log_item    *lip,
>>> +    uint64_t        intent_id)
>>> +{
>>> +    return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>>> +}
>>> +
>>> +/*
>>> + * When the attrd item is committed to disk, all we need to do is 
>>> delete our
>>> + * reference to our partner attri item and then free ourselves. 
>>> Since we're
>>> + * freeing ourselves we must return -1 to keep the transaction code 
>>> from
>>> + * further referencing this item.
>>> + */
>>> +STATIC xfs_lsn_t
>>> +xfs_attrd_item_committed(
>>> +    struct xfs_log_item    *lip,
>>> +    xfs_lsn_t        lsn)
>>> +{
>>> +    struct xfs_attrd_log_item    *attrdp = ATTRD_ITEM(lip);
>>> +
>>> +    /*
>>> +     * Drop the ATTRI reference regardless of whether the ATTRD has 
>>> been
>>> +     * aborted. Once the ATTRD transaction is constructed, it is the 
>>> sole
>>> +     * responsibility of the ATTRD to release the ATTRI (even if the 
>>> ATTRI
>>> +     * is aborted due to log I/O error).
>>> +     */
>>> +    xfs_attri_release(attrdp->attrd_attrip);
>>> +    xfs_attrd_item_free(attrdp);
>>> +
>>> +    return NULLCOMMITLSN;
>>> +}
>>> +
>>> +STATIC void
>>> +xfs_attrd_item_committing(
>>> +    struct xfs_log_item    *lip,
>>> +    xfs_lsn_t        lsn)
>>> +{
>>> +}
>>> +
>>> +
>>> +/*
>>> + * Allocate and initialize an attrd item
>>> + */
>>> +struct xfs_attrd_log_item *
>>> +xfs_attrd_init(
>>> +    struct xfs_mount        *mp,
>>> +    struct xfs_attri_log_item    *attrip)
>>> +
>>> +{
>>> +    struct xfs_attrd_log_item    *attrdp;
>>> +    uint                size;
>>> +
>>> +    size = (uint)(sizeof(struct xfs_attrd_log_item));
>>> +    attrdp = kmem_zalloc(size, 0);
>>> +    memset(attrdp, 0, size);
>>> +
>>> +    xfs_log_item_init(mp, &attrdp->attrd_item, XFS_LI_ATTRD,
>>> +              &xfs_attrd_item_ops);
>>> +    attrdp->attrd_attrip = attrip;
>>> +    attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
>>> +
>>> +    return attrdp;
>>> +}
>>> +
>>> +/*
>>> + * This routine is called to allocate an "attr free done" log item.
>>> + */
>>> +struct xfs_attrd_log_item *
>>> +xfs_trans_get_attrd(struct xfs_trans        *tp,
>>> +          struct xfs_attri_log_item    *attrip)
>>> +{
>>> +    struct xfs_attrd_log_item        *attrdp;
>>> +
>>> +    ASSERT(tp != NULL);
>>> +
>>> +    attrdp = xfs_attrd_init(tp->t_mountp, attrip);
>>> +    ASSERT(attrdp != NULL);
>>> +
>>> +    xfs_trans_add_item(tp, &attrdp->attrd_item);
>>> +    return attrdp;
>>> +}
>>> +
>>> +static const struct xfs_item_ops xfs_attrd_item_ops = {
>>> +    .iop_size    = xfs_attrd_item_size,
>>> +    .iop_format    = xfs_attrd_item_format,
>>> +    .iop_release    = xfs_attrd_item_release,
>>> +    .iop_committing    = xfs_attrd_item_committing,
>>> +    .iop_committed    = xfs_attrd_item_committed,
>>> +};
>>> +
>>> +
>>> +/* Get an ATTRD so we can process all the attrs. */
>>> +static struct xfs_log_item *
>>> +xfs_attr_create_done(
>>> +    struct xfs_trans        *tp,
>>> +    struct xfs_log_item        *intent,
>>> +    unsigned int            count)
>>> +{
>>> +    return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
>>> +}
>>> +
>>> +const struct xfs_defer_op_type xfs_attr_defer_type = {
>>> +    .max_items    = 1,
>>> +    .create_intent    = xfs_attr_create_intent,
>>> +    .abort_intent    = xfs_attr_abort_intent,
>>> +    .create_done    = xfs_attr_create_done,
>>> +    .finish_item    = xfs_attr_finish_item,
>>> +    .cancel_item    = xfs_attr_cancel_item,
>>> +};
>>> +
>>> +/*
>>> + * Process an attr intent item that was recovered from the log.  We 
>>> need to
>>> + * delete the attr that it describes.
>>> + */
>>> +STATIC int
>>> +xfs_attri_item_recover(
>>> +    struct xfs_log_item        *lip,
>>> +    struct xfs_trans        *parent_tp)
>>> +{
>>> +    struct xfs_attri_log_item    *attrip = ATTRI_ITEM(lip);
>>> +    struct xfs_mount        *mp = parent_tp->t_mountp;
>>> +    struct xfs_inode        *ip;
>>> +    struct xfs_attrd_log_item    *attrdp;
>>> +    struct xfs_da_args        args;
>>> +    struct xfs_attri_log_format    *attrp;
>>> +    struct xfs_trans_res        tres;
>>> +    int                local;
>>> +    int                error, err2 = 0;
>>> +    int                rsvd = 0;
>>> +    struct xfs_buf            *leaf_bp = NULL;
>>> +    struct xfs_delattr_context    dac = {
>>> +        .da_args    = &args,
>>> +    };
>>> +
>>> +    /*
>>> +     * First check the validity of the attr described by the ATTRI.  
>>> If any
>>> +     * are bad, then assume that all are bad and just toss the ATTRI.
>>> +     */
>>> +    attrp = &attrip->attri_format;
>>> +    if (!(attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET ||
>>> +          attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE) ||
>>> +        (attrp->alfi_value_len > XATTR_SIZE_MAX) ||
>>> +        (attrp->alfi_name_len > XATTR_NAME_MAX) ||
>>> +        (attrp->alfi_name_len == 0)) {
>>> +        /*
>>> +         * This will pull the ATTRI from the AIL and free the memory
>>> +         * associated with it.
>>> +         */
>>> +        xfs_attri_release(attrip);
>>> +        return -EFSCORRUPTED;
>>> +    }
>>> +
>>> +    error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
>>> +    if (error)
>>> +        return error;
>>> +
>>> +    memset(&args, 0, sizeof(args));
>>> +    args.geo = ip->i_mount->m_attr_geo;
>>> +    args.whichfork = XFS_ATTR_FORK;
>>> +    args.dp = ip;
>>> +    args.name = attrip->attri_name;
>>> +    args.namelen = attrp->alfi_name_len;
>>> +    args.attr_filter = attrp->alfi_attr_flags;
>>> +    args.hashval = xfs_da_hashname(attrip->attri_name,
>>> +                    attrp->alfi_name_len);
>>> +    args.value = attrip->attri_value;
>>> +    args.valuelen = attrp->alfi_value_len;
>>> +    args.op_flags = XFS_DA_OP_OKNOENT;
>>> +    args.total = xfs_attr_calc_size(&args, &local);
>>> +
>>> +    tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
>>> +            M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
>>> +    tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>>> +    tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>>> +
>>> +    error = xfs_trans_alloc(mp, &tres, args.total,  0,
>>> +                rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
>>> +    if (error)
>>> +        goto out_rele;
>>> +    attrdp = xfs_trans_get_attrd(args.trans, attrip);
>>> +
>>> +    xfs_ilock(ip, XFS_ILOCK_EXCL);
>>> +
>>> +    xfs_trans_ijoin(args.trans, ip, 0);
>>> +
>>> +    do {
>>> +        error = xfs_trans_attr(&dac, attrdp, &leaf_bp,
>>> +                       attrp->alfi_op_flags);
>>> +        if (error && error != -EAGAIN)
>>> +            goto abort_error;
>>> +
>>> +        xfs_trans_log_inode(args.trans, ip,
>>> +                XFS_ILOG_CORE | XFS_ILOG_ADATA);
>>> +
>>> +        err2 = xfs_trans_roll(&args.trans);
>>> +        if (err2) {
>>> +            error = err2;
>>> +            goto abort_error;
>>> +        }
>>> +
>>> +        /* Rejoin inode and leaf if needed */
>>> +        xfs_trans_ijoin(args.trans, ip, 0);
>>> +        if (leaf_bp) {
>>> +            xfs_trans_bjoin(args.trans, leaf_bp);
>>> +            xfs_trans_bhold(args.trans, leaf_bp);
>>> +        }
>>> +
>>> +    } while (error == -EAGAIN);
>>> +
>>> +    error = xfs_trans_commit(args.trans);
>>> +    if (error)
>>> +        goto abort_error;
>>> +
>>> +    xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>> +    xfs_irele(ip);
>>> +    return error;
>>> +
>>> +abort_error:
>>> +    xfs_trans_cancel(args.trans);
>>> +    xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>> +out_rele:
>>> +    xfs_irele(ip);
>>> +    return error;
>>> +}
>>> +
>>> +static const struct xfs_item_ops xfs_attri_item_ops = {
>>> +    .iop_size    = xfs_attri_item_size,
>>> +    .iop_format    = xfs_attri_item_format,
>>> +    .iop_unpin    = xfs_attri_item_unpin,
>>> +    .iop_committed    = xfs_attri_item_committed,
>>> +    .iop_committing = xfs_attri_item_committing,
>>> +    .iop_release    = xfs_attri_item_release,
>>> +    .iop_recover    = xfs_attri_item_recover,
>>> +    .iop_match    = xfs_attri_item_match,
>>> +};
>>> +
>>> +
>>> +
>>> +STATIC int
>>> +xlog_recover_attri_commit_pass2(
>>> +    struct xlog                     *log,
>>> +    struct list_head        *buffer_list,
>>> +    struct xlog_recover_item        *item,
>>> +    xfs_lsn_t                       lsn)
>>> +{
>>> +    int                             error;
>>> +    struct xfs_mount                *mp = log->l_mp;
>>> +    struct xfs_attri_log_item       *attrip;
>>> +    struct xfs_attri_log_format     *attri_formatp;
>>> +    char                *name = NULL;
>>> +    char                *value = NULL;
>>> +    int                region = 0;
>>> +
>>> +    attri_formatp = item->ri_buf[region].i_addr;
>>> +
>>> +    attrip = xfs_attri_init(mp);
>>> +    error = xfs_attri_copy_format(&item->ri_buf[region],
>>> +                      &attrip->attri_format);
>>> +    if (error) {
>>> +        xfs_attri_item_free(attrip);
>>> +        return error;
>>> +    }
>>> +
>>> +    attrip->attri_name_len = attri_formatp->alfi_name_len;
>>> +    attrip->attri_value_len = attri_formatp->alfi_value_len;
>>> +    attrip = kmem_realloc(attrip, sizeof(struct xfs_attri_log_item) +
>>> +                  attrip->attri_name_len + attrip->attri_value_len,
>>> +                  0);
>>> +
>>> +    ASSERT(attrip->attri_name_len > 0);
>>> +    region++;
>>> +    name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
>>> +    memcpy(name, item->ri_buf[region].i_addr,
>>> +           attrip->attri_name_len);
>>> +    attrip->attri_name = name;
>>> +
>>> +    if (attrip->attri_value_len > 0) {
>>> +        region++;
>>> +        value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
>>> +            attrip->attri_name_len;
>>> +        memcpy(value, item->ri_buf[region].i_addr,
>>> +            attrip->attri_value_len);
>>> +        attrip->attri_value = value;
>>> +    }
>>> +
>>> +    /*
>>> +     * The ATTRI has two references. One for the ATTRD and one for 
>>> ATTRI to
>>> +     * ensure it makes it into the AIL. Insert the ATTRI into the AIL
>>> +     * directly and drop the ATTRI reference. Note that
>>> +     * xfs_trans_ail_update() drops the AIL lock.
>>> +     */
>>> +    xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
>>> +    xfs_attri_release(attrip);
>>> +    return 0;
>>> +}
>>> +
>>> +const struct xlog_recover_item_ops xlog_attri_item_ops = {
>>> +    .item_type    = XFS_LI_ATTRI,
>>> +    .commit_pass2    = xlog_recover_attri_commit_pass2,
>>> +};
>>> +
>>> +/*
>>> + * This routine is called when an ATTRD format structure is found in 
>>> a committed
>>> + * transaction in the log. Its purpose is to cancel the 
>>> corresponding ATTRI if
>>> + * it was still in the log. To do this it searches the AIL for the 
>>> ATTRI with
>>> + * an id equal to that in the ATTRD format structure. If we find it 
>>> we drop
>>> + * the ATTRD reference, which removes the ATTRI from the AIL and 
>>> frees it.
>>> + */
>>> +STATIC int
>>> +xlog_recover_attrd_commit_pass2(
>>> +    struct xlog            *log,
>>> +    struct list_head        *buffer_list,
>>> +    struct xlog_recover_item    *item,
>>> +    xfs_lsn_t            lsn)
>>> +{
>>> +    struct xfs_attrd_log_format    *attrd_formatp;
>>> +
>>> +    attrd_formatp = item->ri_buf[0].i_addr;
>>> +    ASSERT((item->ri_buf[0].i_len ==
>>> +                (sizeof(struct xfs_attrd_log_format))));
>>> +
>>> +    xlog_recover_release_intent(log, XFS_LI_ATTRI,
>>> +                    attrd_formatp->alfd_alf_id);
>>> +    return 0;
>>> +}
>>> +
>>> +const struct xlog_recover_item_ops xlog_attrd_item_ops = {
>>> +    .item_type    = XFS_LI_ATTRD,
>>> +    .commit_pass2    = xlog_recover_attrd_commit_pass2,
>>> +};
>>> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
>>> new file mode 100644
>>> index 0000000..7dd2572
>>> --- /dev/null
>>> +++ b/fs/xfs/xfs_attr_item.h
>>> @@ -0,0 +1,76 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>>> + *
>>> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
>>> + * Author: Allison Collins <allison.henderson@oracle.com>
>>> + */
>>> +#ifndef    __XFS_ATTR_ITEM_H__
>>> +#define    __XFS_ATTR_ITEM_H__
>>> +
>>> +/* kernel only ATTRI/ATTRD definitions */
>>> +
>>> +struct xfs_mount;
>>> +struct kmem_zone;
>>> +
>>> +/*
>>> + * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
>>> + */
>>> +#define    XFS_ATTRI_RECOVERED    1
>>> +
>>> +
>>> +/* iovec length must be 32-bit aligned */
>>> +#define ATTR_NVEC_SIZE(size) (size == sizeof(int32_t) ? 
>>> sizeof(int32_t) : \
>>> +                size + sizeof(int32_t) - \
>>> +                (size % sizeof(int32_t)))
>>> +
>>> +/*
>>> + * This is the "attr intention" log item.  It is used to log the 
>>> fact that some
>>> + * attribute operations need to be processed.  An operation is 
>>> currently either
>>> + * a set or remove.  Set or remove operations are described by the 
>>> xfs_attr_item
>>> + * which may be logged to this intent.  Intents are used in 
>>> conjunction with the
>>> + * "attr done" log item described below.
>>> + *
>>> + * The ATTRI is reference counted so that it is not freed prior to 
>>> both the
>>> + * ATTRI and ATTRD being committed and unpinned. This ensures the 
>>> ATTRI is
>>> + * inserted into the AIL even in the event of out of order ATTRI/ATTRD
>>> + * processing. In other words, an ATTRI is born with two references:
>>> + *
>>> + *      1.) an ATTRI held reference to track ATTRI AIL insertion
>>> + *      2.) an ATTRD held reference to track ATTRD commit
>>> + *
>>> + * On allocation, both references are the responsibility of the 
>>> caller. Once the
>>> + * ATTRI is added to and dirtied in a transaction, ownership of 
>>> reference one
>>> + * transfers to the transaction. The reference is dropped once the 
>>> ATTRI is
>>> + * inserted to the AIL or in the event of failure along the way 
>>> (e.g., commit
>>> + * failure, log I/O error, etc.). Note that the caller remains 
>>> responsible for
>>> + * the ATTRD reference under all circumstances to this point. The 
>>> caller has no
>>> + * means to detect failure once the transaction is committed, however.
>>> + * Therefore, an ATTRD is required after this point, even in the 
>>> event of
>>> + * unrelated failure.
>>> + *
>>> + * Once an ATTRD is allocated and dirtied in a transaction, 
>>> reference two
>>> + * transfers to the transaction. The ATTRD reference is dropped once 
>>> it reaches
>>> + * the unpin handler. Similar to the ATTRI, the reference also drops 
>>> in the
>>> + * event of commit failure or log I/O errors. Note that the ATTRD is 
>>> not
>>> + * inserted in the AIL, so at this point both the ATTRI and ATTRD 
>>> are freed.
>>> + */
>>> +struct xfs_attri_log_item {
>>> +    struct xfs_log_item        attri_item;
>>> +    atomic_t            attri_refcount;
>>> +    int                attri_name_len;
>>> +    void                *attri_name;
>>> +    int                attri_value_len;
>>> +    void                *attri_value;
>>> +    struct xfs_attri_log_format    attri_format;
>>> +};
>>> +
>>> +/*
>>> + * This is the "attr done" log item.  It is used to log the fact 
>>> that some attrs
>>> + * earlier mentioned in an attri item have been freed.
>>> + */
>>> +struct xfs_attrd_log_item {
>>> +    struct xfs_attri_log_item    *attrd_attrip;
>>> +    struct xfs_log_item        attrd_item;
>>> +    struct xfs_attrd_log_format    attrd_format;
>>> +};
>>> +
>>> +#endif    /* __XFS_ATTR_ITEM_H__ */
>>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>>> index 50f922c..166b680 100644
>>> --- a/fs/xfs/xfs_attr_list.c
>>> +++ b/fs/xfs/xfs_attr_list.c
>>> @@ -15,6 +15,7 @@
>>>   #include "xfs_inode.h"
>>>   #include "xfs_trans.h"
>>>   #include "xfs_bmap.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_attr_sf.h"
>>>   #include "xfs_attr_leaf.h"
>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>> index 6f22a66..edc05af 100644
>>> --- a/fs/xfs/xfs_ioctl.c
>>> +++ b/fs/xfs/xfs_ioctl.c
>>> @@ -15,6 +15,8 @@
>>>   #include "xfs_iwalk.h"
>>>   #include "xfs_itable.h"
>>>   #include "xfs_error.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_bmap.h"
>>>   #include "xfs_bmap_util.h"
>>> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
>>> index c1771e7..62e1534 100644
>>> --- a/fs/xfs/xfs_ioctl32.c
>>> +++ b/fs/xfs/xfs_ioctl32.c
>>> @@ -17,6 +17,8 @@
>>>   #include "xfs_itable.h"
>>>   #include "xfs_fsops.h"
>>>   #include "xfs_rtalloc.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_ioctl.h"
>>>   #include "xfs_ioctl32.h"
>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>> index 80a13c8..fe60da1 100644
>>> --- a/fs/xfs/xfs_iops.c
>>> +++ b/fs/xfs/xfs_iops.c
>>> @@ -13,6 +13,8 @@
>>>   #include "xfs_inode.h"
>>>   #include "xfs_acl.h"
>>>   #include "xfs_quota.h"
>>> +#include "xfs_da_format.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_trans.h"
>>>   #include "xfs_trace.h"
>>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>>> index ad0c69ee..6405ce33 100644
>>> --- a/fs/xfs/xfs_log.c
>>> +++ b/fs/xfs/xfs_log.c
>>> @@ -1975,6 +1975,10 @@ xlog_print_tic_res(
>>>           REG_TYPE_STR(CUD_FORMAT, "cud_format"),
>>>           REG_TYPE_STR(BUI_FORMAT, "bui_format"),
>>>           REG_TYPE_STR(BUD_FORMAT, "bud_format"),
>>> +        REG_TYPE_STR(ATTRI_FORMAT, "attri_format"),
>>> +        REG_TYPE_STR(ATTRD_FORMAT, "attrd_format"),
>>> +        REG_TYPE_STR(ATTR_NAME, "attr_name"),
>>> +        REG_TYPE_STR(ATTR_VALUE, "attr_value"),
>>>       };
>>>       BUILD_BUG_ON(ARRAY_SIZE(res_type_str) != XLOG_REG_TYPE_MAX + 1);
>>>   #undef REG_TYPE_STR
>>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>>> index e2ec91b..ec31db0 100644
>>> --- a/fs/xfs/xfs_log_recover.c
>>> +++ b/fs/xfs/xfs_log_recover.c
>>> @@ -1811,6 +1811,8 @@ static const struct xlog_recover_item_ops 
>>> *xlog_recover_item_ops[] = {
>>>       &xlog_cud_item_ops,
>>>       &xlog_bui_item_ops,
>>>       &xlog_bud_item_ops,
>>> +    &xlog_attri_item_ops,
>>> +    &xlog_attrd_item_ops,
>>>   };
>>>   static const struct xlog_recover_item_ops *
>>> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
>>> index 5f04d8a..0597a04 100644
>>> --- a/fs/xfs/xfs_ondisk.h
>>> +++ b/fs/xfs/xfs_ondisk.h
>>> @@ -126,6 +126,8 @@ xfs_check_ondisk_structs(void)
>>>       XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,    56);
>>>       XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,    20);
>>>       XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,        16);
>>> +    XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,    40);
>>> +    XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,    16);
>>>       /*
>>>        * The v5 superblock format extended several v4 header 
>>> structures with
>>> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
>>> index bca48b3..9b0c790 100644
>>> --- a/fs/xfs/xfs_xattr.c
>>> +++ b/fs/xfs/xfs_xattr.c
>>> @@ -10,6 +10,7 @@
>>>   #include "xfs_log_format.h"
>>>   #include "xfs_da_format.h"
>>>   #include "xfs_inode.h"
>>> +#include "xfs_da_btree.h"
>>>   #include "xfs_attr.h"
>>>   #include "xfs_acl.h"
>>>   #include "xfs_da_btree.h"
>>> -- 
>>> 2.7.4
>>>
