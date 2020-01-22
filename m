Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B7BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6348D21569
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 17:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YQYrSIzz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAVRE5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:04:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38208 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVRE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 12:04:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwA8L078266
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 17:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5vmeJuBPcXOUeIGs7Pdf03PfFcCELVDToSP0YEI+yBo=;
 b=YQYrSIzzqapkqc9C8EtqL5bWlYUO44Fm75qGC2CJdTtRsh29rr26lUrNH0VM/lcEWEP7
 69PTK6J2N4QVxCP/98lo7A/kZ3GnoLykI2qKPGN1kq4T5llB0xYugg+nWgqQRSHXBK5P
 mVrUl+9mus2ANHFWJItUZ2PO7FNgJkhzfpZ5nkbfv+pBKgPfZoteoi34wJFXFX8yvc2L
 DUvHi7LfBYQygNIP9lEdXK0HZffvgvz09hKWQej9X+x/przYJ49TWzqjjyko4+84J2RU
 MtCpBavEdbjGFF3RM/18U8jSTrTmZKAvOGKy7dNVbO9SHYbOs7yWuBOM9gWu5RZU8oga fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrcydg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 17:04:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00MGwe4p163129
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 17:04:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xppq0g8sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 17:04:53 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00MH4qAF017848
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 17:04:52 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 09:04:52 -0800
Subject: Re: [PATCH v6 16/16] xfs: Add delay ready attr set routines
From:   Allison Collins <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-17-allison.henderson@oracle.com>
 <20200122001237.GP8247@magnolia>
 <6bbbd8f7-28ca-9d32-bcc3-372d4701452a@oracle.com>
Message-ID: <1e00e684-9d65-9af7-b014-1b959652e2b0@oracle.com>
Date:   Wed, 22 Jan 2020 10:04:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6bbbd8f7-28ca-9d32-bcc3-372d4701452a@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/22/20 9:57 AM, Allison Collins wrote:
> 
> 
> On 1/21/20 5:12 PM, Darrick J. Wong wrote:
>> On Sat, Jan 18, 2020 at 03:50:35PM -0700, Allison Collins wrote:
>>> This patch modifies the attr set routines to be delay ready. This means
>>> they no longer roll or commit transactions, but instead return -EAGAIN
>>> to have the calling routine roll and refresh the transaction.  In this
>>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
>>> state machine like switch to keep track of where it was when EAGAIN was
>>> returned.
>>>
>>> Part of xfs_attr_leaf_addname has been factored out into a new helper
>>> function xfs_attr_leaf_try_add to allow transaction cycling between the
>>> two routines.
>>>
>>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
>>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>>> context to allow the caller to roll the transaction between allocations.
>>> This helps to simplify and consolidate code used by
>>> xfs_attr_leaf_addname and xfs_attr_node_addname
>>>
>>> Finally, xfs_attr_set_args has become a simple loop to refresh the
>>> transaction until the operation is completed.
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c        | 347 
>>> +++++++++++++++++++++++++---------------
>>>   fs/xfs/libxfs/xfs_attr.h        |   1 +
>>>   fs/xfs/libxfs/xfs_attr_remote.c |  67 +++++++-
>>>   fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>>>   fs/xfs/libxfs/xfs_da_btree.h    |  13 ++
>>>   5 files changed, 301 insertions(+), 131 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 92929ad..02a7f55 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -58,6 +58,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>                    struct xfs_da_state **state);
>>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct 
>>> xfs_buf *bp);
>>>   STATIC int
>>> @@ -259,9 +260,86 @@ int
>>>   xfs_attr_set_args(
>>>       struct xfs_da_args    *args)
>>>   {
>>> +    int            error = 0;
>>> +    int            err2 = 0;
>>> +    struct xfs_buf        *leaf_bp = NULL;
>>> +
>>> +    do {
>>> +        error = xfs_attr_set_iter(args, &leaf_bp);
>>> +        if (error && error != -EAGAIN)
>>> +            goto out;
>>> +
>>> +        if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
>>> +            args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
>>> +
>>> +            err2 = xfs_defer_finish(&args->trans);
>>> +            if (err2) {
>>> +                error = err2;
>>> +                goto out;
>>> +            }
>>> +        }
>>> +
>>> +        err2 = xfs_trans_roll_inode(&args->trans, args->dp);
>>> +        if (err2) {
>>> +            error = err2;
>>> +            goto out;
>>> +        }
>>> +
>>> +        if (leaf_bp) {
>>> +            xfs_trans_bjoin(args->trans, leaf_bp);
>>> +            xfs_trans_bhold(args->trans, leaf_bp);
>>> +        }
>>> +
>>> +    } while (error == -EAGAIN);
>>> +
>>> +out:
>>> +    return error;
>>> +}
>>> +
>>> +/*
>>> + * Set the attribute specified in @args.
>>> + * This routine is meant to function as a delayed operation, and may 
>>> return
>>> + * -EAGAIN when the transaction needs to be rolled.  Calling 
>>> functions will need
>>> + * to handle this, and recall the function until a successful error 
>>> code is
>>> + * returned.
>>> + */
>>> +int
>>> +xfs_attr_set_iter(
>>> +    struct xfs_da_args    *args,
>>> +    struct xfs_buf          **leaf_bp)
>>> +{
>>>       struct xfs_inode    *dp = args->dp;
>>> -    struct xfs_buf          *leaf_bp = NULL;
>>> -    int            error, error2 = 0;
>>> +    int            error = 0;
>>> +    int            sf_size;
>>> +
>>> +    /* State machine switch */
>>> +    switch (args->dac.dela_state) {
>>> +    case XFS_DAS_SF_TO_LEAF:
>>> +        goto sf_to_leaf;
>>> +    case XFS_DAS_ALLOC_LEAF:
>>> +    case XFS_DAS_FLIP_LFLAG:
>>> +    case XFS_DAS_FOUND_LBLK:
>>> +        goto leaf;
>>> +    case XFS_DAS_FOUND_NBLK:
>>> +    case XFS_DAS_FLIP_NFLAG:
>>> +    case XFS_DAS_ALLOC_NODE:
>>> +    case XFS_DAS_LEAF_TO_NODE:
>>> +        goto node;
>>> +    default:
>>
>> Er... do these need to ASSERT on invalid states?  e.g. if somehow we end
>> up with XFS_DAS_RM_SHRINK, we ought to blow up loudly, right?
>>
>>
>>> +        break;
>>> +    }
>>> +
>>> +    /*
>>> +     * New inodes may not have an attribute fork yet. So set the 
>>> attribute
>>> +     * fork appropriately
>>> +     */
>>> +    if (XFS_IFORK_Q((args->dp)) == 0) {
>>> +        sf_size = sizeof(struct xfs_attr_sf_hdr) +
>>> +             XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, 
>>> args->valuelen);
>>> +        xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>>> +        args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
>>> +        args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>>> +    }
>>>       /*
>>>        * If the attribute list is non-existent or a shortform list, 
>>> proceed to
>>> @@ -272,22 +350,20 @@ xfs_attr_set_args(
>>>           (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>>>            dp->i_d.di_anextents == 0)))
>>>           goto sf_to_leaf;
>>> -
>>>       /*
>>>        * Try to add the attr to the attribute list in the inode.
>>>        */
>>>       error = xfs_attr_try_sf_addname(dp, args);
>>> -    if (error != -ENOSPC) {
>>> -        error2 = xfs_trans_commit(args->trans);
>>> -        args->trans = NULL;
>>> -        return error ? error : error2;
>>
>> Where does this commit go?
>>
>>> -    }
>>> +
>>> +    /* Should only be 0, -EEXIST or ENOSPC */
>>> +    if (error != -ENOSPC)
>>> +        return error;
>>>       /*
>>>        * It won't fit in the shortform, transform to a leaf block.
>>>        * GROT: another possible req'mt for a double-split btree op.
>>>        */
>>> -    error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>>> +    error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>>>       if (error)
>>>           return error;
>>> @@ -295,42 +371,47 @@ xfs_attr_set_args(
>>>        * Prevent the leaf buffer from being unlocked so that a
>>>        * concurrent AIL push cannot grab the half-baked leaf
>>>        * buffer and run into problems with the write verifier.
>>> -     * Once we're done rolling the transaction we can release
>>> -     * the hold and add the attr to the leaf.
>>>        */
>>> -    xfs_trans_bhold(args->trans, leaf_bp);
>>> -    error = xfs_defer_finish(&args->trans);
>>> -    xfs_trans_bhold_release(args->trans, leaf_bp);
>>> -    if (error) {
>>> -        xfs_trans_brelse(args->trans, leaf_bp);
>>> -        return error;
>>> -    }
>>> +    xfs_trans_bhold(args->trans, *leaf_bp);
>>> +    args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +    args->dac.dela_state = XFS_DAS_SF_TO_LEAF;
>>> +    return -EAGAIN;
>>>   sf_to_leaf:
>>> -    if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>> -        error = xfs_attr_leaf_addname(args);
>>> -        if (error != -ENOSPC)
>>> -            return error;
>>> -
>>> -        /*
>>> -         * Commit that transaction so that the node_addname()
>>> -         * call can manage its own transactions.
>>> -         */
>>> -        error = xfs_defer_finish(&args->trans);
>>> -        if (error)
>>> -            return error;
>>> +    /*
>>> +     * After a shortform to leaf conversion, we need to hold the 
>>> leaf and
>>> +     * cylce out the transaction.  When we get back, we need to release
>>> +     * the leaf.
>>> +     */
>>> +    if (*leaf_bp != NULL) {
>>> +        xfs_trans_brelse(args->trans, *leaf_bp);
>>> +        *leaf_bp = NULL;
>>> +    }
>>> -        /*
>>> -         * Commit the current trans (including the inode) and
>>> -         * start a new one.
>>> -         */
>>> -        error = xfs_trans_roll_inode(&args->trans, dp);
>>> -        if (error)
>>> +    if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>> +        error = xfs_attr_leaf_try_add(args, *leaf_bp);
>>> +        switch (error) {
>>> +        case -ENOSPC:
>>> +            args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +            args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>>> +            return -EAGAIN;
>>> +        case 0:
>>> +            args->dac.dela_state = XFS_DAS_FOUND_LBLK;
>>> +            return -EAGAIN;
>>> +        default:
>>>               return error;
>>> -
>>> +        }
>>> +leaf:
>>> +        error = xfs_attr_leaf_addname(args);
>>> +        if (error == -ENOSPC) {
>>> +            args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>>> +            return -EAGAIN;
>>> +        }
>>> +        return error;
>>>       }
>>> -
>>> +    args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
>>> +node:
>>>       error = xfs_attr_node_addname(args);
>>>       return error;
>>>   }
>>> @@ -759,27 +840,28 @@ xfs_attr_leaf_try_add(
>>>    *
>>>    * This leaf block cannot have a "remote" value, we only call this 
>>> routine
>>>    * if bmap_one_block() says there is only one block (ie: no remote 
>>> blks).
>>> + *
>>> + * This routine is meant to function as a delayed operation, and may 
>>> return
>>> + * -EAGAIN when the transaction needs to be rolled.  Calling 
>>> functions will need
>>> + * to handle this, and recall the function until a successful error 
>>> code is
>>> + * returned.
>>>    */
>>>   STATIC int
>>>   xfs_attr_leaf_addname(struct xfs_da_args    *args)
>>>   {
>>> -    int            error, forkoff;
>>>       struct xfs_buf        *bp = NULL;
>>> +    int            error, forkoff;
>>>       struct xfs_inode    *dp = args->dp;
>>> -    trace_xfs_attr_leaf_addname(args);
>>> -
>>> -    error = xfs_attr_leaf_try_add(args, bp);
>>> -    if (error)
>>> -        return error;
>>> -
>>> -    /*
>>> -     * Commit the transaction that added the attr name so that
>>> -     * later routines can manage their own transactions.
>>> -     */
>>> -    error = xfs_trans_roll_inode(&args->trans, dp);
>>> -    if (error)
>>> -        return error;
>>> +    /* State machine switch */
>>> +    switch (args->dac.dela_state) {
>>> +    case XFS_DAS_FLIP_LFLAG:
>>> +        goto flip_flag;
>>> +    case XFS_DAS_ALLOC_LEAF:
>>> +        goto alloc_leaf;
>>> +    default:
>>> +        break;
>>> +    }
>>>       /*
>>>        * If there was an out-of-line value, allocate the blocks we
>>> @@ -788,7 +870,28 @@ xfs_attr_leaf_addname(struct xfs_da_args    *args)
>>>        * maximum size of a transaction and/or hit a deadlock.
>>>        */
>>>       if (args->rmtblkno > 0) {
>>> -        error = xfs_attr_rmtval_set(args);
>>> +
>>> +        /* Open coded xfs_attr_rmtval_set without trans handling */
>>> +        error = xfs_attr_rmtval_set_init(args);
>>> +        if (error)
>>> +            return error;
>>> +
>>> +        /*
>>> +         * Roll through the "value", allocating blocks on disk as
>>> +         * required.
>>> +         */
>>> +alloc_leaf:
>>> +        while (args->dac.blkcnt > 0) {
>>> +            error = xfs_attr_rmtval_set_blk(args);
>>> +            if (error)
>>> +                return error;
>>> +
>>> +            args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +            args->dac.dela_state = XFS_DAS_ALLOC_LEAF;
>>> +            return -EAGAIN;
>>> +        }
>>> +
>>> +        error = xfs_attr_rmtval_set_value(args);
>>>           if (error)
>>>               return error;
>>>       }
>>> @@ -807,13 +910,10 @@ xfs_attr_leaf_addname(struct xfs_da_args    *args)
>>>           error = xfs_attr3_leaf_flipflags(args);
>>>           if (error)
>>>               return error;
>>> -        /*
>>> -         * Commit the flag value change and start the next trans in
>>> -         * series.
>>> -         */
>>> -        error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> -        if (error)
>>> -            return error;
>>> +
>>> +        args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
>>> +        return -EAGAIN;
>>> +flip_flag:
>>>           /*
>>>            * Dismantle the "old" attribute/value pair by removing
>>> @@ -844,34 +944,17 @@ xfs_attr_leaf_addname(struct xfs_da_args    *args)
>>>           /*
>>>            * If the result is small enough, shrink it all into the 
>>> inode.
>>>            */
>>> -        if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>>> +        forkoff = xfs_attr_shortform_allfit(bp, dp);
>>> +        if (forkoff)
>>>               error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>>> -            /* bp is gone due to xfs_da_shrink_inode */
>>> -            if (error)
>>> -                return error;
>>> -            error = xfs_defer_finish(&args->trans);
>>> -            if (error)
>>> -                return error;
>>> -        }
>>> -        /*
>>> -         * Commit the remove and start the next trans in series.
>>> -         */
>>> -        error = xfs_trans_roll_inode(&args->trans, dp);
>>> +        args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>>       } else if (args->rmtblkno > 0) {
>>>           /*
>>>            * Added a "remote" value, just clear the incomplete flag.
>>>            */
>>>           error = xfs_attr3_leaf_clearflag(args);
>>> -        if (error)
>>> -            return error;
>>> -
>>> -        /*
>>> -         * Commit the flag value change and start the next trans in
>>> -         * series.
>>> -         */
>>> -        error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>       }
>>>       return error;
>>>   }
>>> @@ -1020,16 +1103,22 @@ xfs_attr_node_hasname(
>>>    *
>>>    * "Remote" attribute values confuse the issue and atomic rename 
>>> operations
>>>    * add a whole extra layer of confusion on top of that.
>>> + *
>>> + * This routine is meant to function as a delayed operation, and may 
>>> return
>>> + * -EAGAIN when the transaction needs to be rolled.  Calling 
>>> functions will need
>>> + * to handle this, and recall the function until a successful error 
>>> code is
>>> + *returned.
>>>    */
>>>   STATIC int
>>>   xfs_attr_node_addname(
>>>       struct xfs_da_args    *args)
>>>   {
>>> -    struct xfs_da_state    *state;
>>> +    struct xfs_da_state    *state = NULL;
>>>       struct xfs_da_state_blk    *blk;
>>>       struct xfs_inode    *dp;
>>>       struct xfs_mount    *mp;
>>> -    int            retval, error;
>>> +    int            retval = 0;
>>> +    int            error = 0;
>>>       trace_xfs_attr_node_addname(args);
>>> @@ -1038,7 +1127,19 @@ xfs_attr_node_addname(
>>>        */
>>>       dp = args->dp;
>>>       mp = dp->i_mount;
>>> -restart:
>>> +
>>> +    /* State machine switch */
>>> +    switch (args->dac.dela_state) {
>>> +    case XFS_DAS_FLIP_NFLAG:
>>> +        goto flip_flag;
>>> +    case XFS_DAS_FOUND_NBLK:
>>> +        goto found_nblk;
>>> +    case XFS_DAS_ALLOC_NODE:
>>> +        goto alloc_node;
>>> +    default:
>>> +        break;
>>> +    }
>>> +
>>>       /*
>>>        * Search to see if name already exists, and get back a pointer
>>>        * to where it should go.
>>> @@ -1088,19 +1189,13 @@ xfs_attr_node_addname(
>>>               error = xfs_attr3_leaf_to_node(args);
>>>               if (error)
>>>                   goto out;
>>> -            error = xfs_defer_finish(&args->trans);
>>> -            if (error)
>>> -                goto out;
>>>               /*
>>> -             * Commit the node conversion and start the next
>>> -             * trans in the chain.
>>> +             * Restart routine from the top.  No need to set  the
>>> +             * state
>>
> 
> I think I missed responding to this comment in my last email:
> 
>> *OH*, dela_state == 0 does not mean "do not use delayed attrs", we're
>> switching /all/ users to delayed attrs.  Urk.
> 
> Not quite.  While both inline and delayed operations go through this 
> same dance of EAGAIN ping pong, it's not a delayed operation until we 
> package it into an intent and log it.  And then the intent pops back out 
> during defer finish, and the ping pong starts from 
> xfs_defer_finish_noroll instead of xfs_attr_set_iter.
Sorry, that should say xfs_attr_set_args, not xfs_attr_set_iter.  :-)

> 
> We still need to support in line operations for older versions that do 
> not support the attr log item.  Later when we get into delayed attrs, we 
> use a feature bit to control this, and toggle as needed.
> 
> Hope that helps!
> 
>>
>>>                */
>>> -            error = xfs_trans_roll_inode(&args->trans, dp);
>>> -            if (error)
>>> -                goto out;
>>> -
>>> -            goto restart;
>>> +            args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +            return -EAGAIN;
>>>           }
>>>           /*
>>> @@ -1112,9 +1207,7 @@ xfs_attr_node_addname(
>>>           error = xfs_da3_split(state);
>>>           if (error)
>>>               goto out;
>>> -        error = xfs_defer_finish(&args->trans);
>>> -        if (error)
>>> -            goto out;
>>> +        args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>>       } else {
>>>           /*
>>>            * Addition succeeded, update Btree hashvals.
>>> @@ -1129,13 +1222,9 @@ xfs_attr_node_addname(
>>>       xfs_da_state_free(state);
>>>       state = NULL;
>>> -    /*
>>> -     * Commit the leaf addition or btree split and start the next
>>> -     * trans in the chain.
>>> -     */
>>> -    error = xfs_trans_roll_inode(&args->trans, dp);
>>> -    if (error)
>>> -        goto out;
>>> +    args->dac.dela_state = XFS_DAS_FOUND_NBLK;
>>> +    return -EAGAIN;
>>> +found_nblk:
>>>       /*
>>>        * If there was an out-of-line value, allocate the blocks we
>>> @@ -1144,7 +1233,27 @@ xfs_attr_node_addname(
>>>        * maximum size of a transaction and/or hit a deadlock.
>>>        */
>>>       if (args->rmtblkno > 0) {
>>> -        error = xfs_attr_rmtval_set(args);
>>> +        /* Open coded xfs_attr_rmtval_set without trans handling */
>>> +        error = xfs_attr_rmtval_set_init(args);
>>> +        if (error)
>>> +            return error;
>>> +
>>> +        /*
>>> +         * Roll through the "value", allocating blocks on disk as
>>> +         * required.
>>> +         */
>>> +alloc_node:
>>> +        while (args->dac.blkcnt > 0) {
>>> +            error = xfs_attr_rmtval_set_blk(args);
>>> +            if (error)
>>> +                return error;
>>> +
>>> +            args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +            args->dac.dela_state = XFS_DAS_ALLOC_NODE;
>>> +            return -EAGAIN;
>>> +        }
>>> +
>>> +        error = xfs_attr_rmtval_set_value(args);
>>>           if (error)
>>>               return error;
>>>       }
>>> @@ -1167,10 +1276,9 @@ xfs_attr_node_addname(
>>>            * Commit the flag value change and start the next trans in
>>>            * series
>>>            */
>>> -        error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> -        if (error)
>>> -            goto out;
>>> -
>>> +        args->dac.dela_state = XFS_DAS_FLIP_NFLAG;
>>> +        return -EAGAIN;
>>> +flip_flag:
>>>           /*
>>>            * Dismantle the "old" attribute/value pair by removing
>>>            * a "remote" value (if it exists).
>>> @@ -1199,7 +1307,6 @@ xfs_attr_node_addname(
>>>           error = xfs_da3_node_lookup_int(state, &retval);
>>>           if (error)
>>>               goto out;
>>> -
>>>           /*
>>>            * Remove the name and update the hashvals in the tree.
>>>            */
>>> @@ -1207,7 +1314,6 @@ xfs_attr_node_addname(
>>>           ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>>           error = xfs_attr3_leaf_remove(blk->bp, args);
>>>           xfs_da3_fixhashpath(state, &state->path);
>>> -
>>>           /*
>>>            * Check to see if the tree needs to be collapsed.
>>>            */
>>> @@ -1215,18 +1321,9 @@ xfs_attr_node_addname(
>>>               error = xfs_da3_join(state);
>>>               if (error)
>>>                   goto out;
>>> -            error = xfs_defer_finish(&args->trans);
>>> -            if (error)
>>> -                goto out;
>>> -        }
>>> -
>>> -        /*
>>> -         * Commit and start the next trans in the chain.
>>> -         */
>>> -        error = xfs_trans_roll_inode(&args->trans, dp);
>>> -        if (error)
>>> -            goto out;
>>> +            args->dac.flags |= XFS_DAC_FINISH_TRANS;
>>> +        }
>>>       } else if (args->rmtblkno > 0) {
>>>           /*
>>>            * Added a "remote" value, just clear the incomplete flag.
>>> @@ -1234,14 +1331,6 @@ xfs_attr_node_addname(
>>>           error = xfs_attr3_leaf_clearflag(args);
>>>           if (error)
>>>               goto out;
>>> -
>>> -         /*
>>> -          * Commit the flag value change and start the next trans in
>>> -          * series.
>>> -          */
>>> -        error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> -        if (error)
>>> -            goto out;
>>>       }
>>>       retval = error = 0;
>>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>>> index ea873a5..f450d8c 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.h
>>> +++ b/fs/xfs/libxfs/xfs_attr.h
>>> @@ -152,6 +152,7 @@ int xfs_attr_get(struct xfs_inode *ip, struct 
>>> xfs_name *name,
>>>   int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>>>            unsigned char *value, int valuelen, int flags);
>>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>> +int xfs_attr_set_iter(struct xfs_da_args *args, struct xfs_buf 
>>> **leaf_bp);
>>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, 
>>> int flags);
>>>   int xfs_has_attr(struct xfs_da_args *args);
>>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c 
>>> b/fs/xfs/libxfs/xfs_attr_remote.c
>>> index f2ee0b8..ad4f14a 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>> @@ -428,7 +428,7 @@ xfs_attr_rmtval_get(
>>>    * Find a "hole" in the attribute address space large enough for us 
>>> to drop the
>>>    * new attribute's value into
>>>    */
>>> -STATIC int
>>> +int
>>>   xfs_attr_rmt_find_hole(
>>>       struct xfs_da_args    *args)
>>>   {
>>> @@ -455,7 +455,7 @@ xfs_attr_rmt_find_hole(
>>>       return 0;
>>>   }
>>> -STATIC int
>>> +int
>>>   xfs_attr_rmtval_set_value(
>>>       struct xfs_da_args    *args)
>>>   {
>>> @@ -588,6 +588,69 @@ xfs_attr_rmtval_set(
>>>   }
>>>   /*
>>> + * Find a hole for the attr and store it in the delayed attr 
>>> context.  This
>>> + * initializes the context to roll through allocating an attr extent 
>>> for a
>>> + * delayed attr operation
>>> + */
>>> +int
>>> +xfs_attr_rmtval_set_init(
>>> +    struct xfs_da_args    *args)
>>> +{
>>> +    struct xfs_bmbt_irec    *map = &args->dac.map;
>>> +    int error;
>>> +
>>> +    args->dac.lblkno = 0;
>>> +    args->dac.lfileoff = 0;
>>> +    args->dac.blkcnt = 0;
>>> +    args->rmtblkcnt = 0;
>>> +    args->rmtblkno = 0;
>>> +    memset(map, 0, sizeof(struct xfs_bmbt_irec));
>>> +
>>> +    error = xfs_attr_rmt_find_hole(args);
>>> +    if (error)
>>> +        return error;
>>> +
>>> +    args->dac.blkcnt = args->rmtblkcnt;
>>> +    args->dac.lblkno = args->rmtblkno;
>>> +
>>> +    return error;
>>> +}
>>> +
>>> +/*
>>> + * Write one block of the value associated with an attribute into the
>>> + * out-of-line buffer that we have defined for it. This is similar 
>>> to a subset
>>> + * of xfs_attr_rmtval_set, but records the current block to the 
>>> delayed attr
>>> + * context, and leaves transaction handling to the caller.
>>> + */
>>> +int
>>> +xfs_attr_rmtval_set_blk(
>>> +    struct xfs_da_args    *args)
>>> +{
>>> +    struct xfs_inode    *dp = args->dp;
>>> +    struct xfs_bmbt_irec    *map = &args->dac.map;
>>> +    int nmap;
>>> +    int error;
>>> +
>>> +    nmap = 1;
>>> +    error = xfs_bmapi_write(args->trans, dp,
>>> +          (xfs_fileoff_t)args->dac.lblkno,
>>> +          args->dac.blkcnt, XFS_BMAPI_ATTRFORK,
>>> +          args->total, map, &nmap);
>>> +    if (error)
>>> +        return error;
>>> +
>>> +    ASSERT(nmap == 1);
>>> +    ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>>> +           (map->br_startblock != HOLESTARTBLOCK));
>>> +
>>> +    /* roll attribute extent map forwards */
>>> +    args->dac.lblkno += map->br_blockcount;
>>> +    args->dac.blkcnt -= map->br_blockcount;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +/*
>>>    * Remove the value associated with an attribute by deleting the
>>>    * out-of-line buffer that it is stored on.
>>>    */
>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h 
>>> b/fs/xfs/libxfs/xfs_attr_remote.h
>>> index 7ab3770..ab03519 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>> @@ -13,4 +13,8 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>   int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>>> +int xfs_attr_rmtval_set_blk(struct xfs_da_args *args);
>>> +int xfs_attr_rmtval_set_init(struct xfs_da_args *args);
>>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>>> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
>>> index 7fc87da..9943062 100644
>>> --- a/fs/xfs/libxfs/xfs_da_btree.h
>>> +++ b/fs/xfs/libxfs/xfs_da_btree.h
>>> @@ -55,6 +55,14 @@ enum xfs_dacmp {
>>>   enum xfs_delattr_state {
>>>       XFS_DAS_RM_SHRINK    = 1, /* We are shrinking the tree */
>>>       XFS_DAS_RM_NODE_BLKS    = 2, /* We are removing node blocks */
>>> +    XFS_DAS_SF_TO_LEAF    = 3, /* Converted short form to leaf */
>>> +    XFS_DAS_FOUND_LBLK    = 4, /* We found leaf blk for attr */
>>> +    XFS_DAS_LEAF_TO_NODE    = 5, /* Converted leaf to node */
>>> +    XFS_DAS_FOUND_NBLK    = 6, /* We found node blk for attr */
>>> +    XFS_DAS_ALLOC_LEAF    = 7, /* We are allocating leaf blocks */
>>> +    XFS_DAS_FLIP_LFLAG    = 8, /* Flipped leaf INCOMPLETE attr flag */
>>> +    XFS_DAS_ALLOC_NODE    = 9, /* We are allocating node blocks */
>>> +    XFS_DAS_FLIP_NFLAG    = 10,/* Flipped node INCOMPLETE attr flag */
>>
>> We've definitely reached the point where a state diagram would be
>> helpful.  Can you go from any of the RM_ states to the ones that you've
>> just added?
>>
>> The new state machine code in last two patches would be a lot easier to
>> review if I could look down from above instead of up from the XFS_DAS
>> values and goto labels.  I /think/ it looks sane, but I'm only 20%
>> confident of that statement.
>>
>> --D
>>
>>>   };
>>>   /*
>>> @@ -66,8 +74,13 @@ enum xfs_delattr_state {
>>>    * Context used for keeping track of delayed attribute operations
>>>    */
>>>   struct xfs_delattr_context {
>>> +    struct xfs_bmbt_irec    map;
>>> +    struct xfs_buf        *leaf_bp;
>>> +    xfs_fileoff_t        lfileoff;
>>>       struct xfs_da_state    *da_state;
>>>       struct xfs_da_state_blk *blk;
>>> +    xfs_dablk_t        lblkno;
>>> +    int            blkcnt;
>>>       int            flags;
>>>       enum xfs_delattr_state    dela_state;
>>>   };
>>> -- 
>>> 2.7.4
>>>
