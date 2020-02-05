Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324C3C35247
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 23:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DDF214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 23:07:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="svz+/tSP";
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U3zXppCp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBEXHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:07:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56990 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBEXHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 18:07:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015N3HHr004490
        for <linux-xfs@vger.kernel.org>; Wed, 5 Feb 2020 23:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=g7alu0WwEyihLOsd/c+261BH1t8IM8fdAiPIekos0mk=;
 b=svz+/tSPWyvIeVDh864gvIzGrrcSUhNOAKbstERNljSAPdUZpaBo+q8Ky5OpOATvCg+7
 jzbp1SqpiZHM6K/wFAS/TsHSm3iwH4fJWUQQDe6E4Xp/IAkh2yhEebDqAREK6zLY19PT
 q0jOb7eUVGn+ilOFnYvDbUA2OCiQeTedFfqjky91Ef9Xu7/rcOpCAaUfsF7NW+slmR80
 4ZN7KTuqw0CHmhBXd3R/bYsRDx2A/zCk5rBNp1f8vfZdQe9EiIcJu7dFM1diWMY2hR3T
 bxwrw+Xjk5euCDMrNnezDMAYsKSeOkcmQUzy1SM8bzAzb0sEvZozzlF/Rp6BxGqi7ESl 2Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g7alu0WwEyihLOsd/c+261BH1t8IM8fdAiPIekos0mk=;
 b=U3zXppCpgaaBmkgSJh+VXhOlvoC51vbPGeaf1Y4Mn1MONa//6AU5NaJZQq3ko+kCPhD0
 2Q/JzeeW01LeMdOKJqqi5astJycCmJ81BSsKF/4fn6d9F+Cv2qWkUbBTQHDZVWSKtcSe
 8Os1hS4OwVUlFH1uOwEP3L/nLlFE48Y1Xa/L8yeZzaDKrhvh0oykqC8M9ptuO3mD8pc1
 OQ+4FpDcvEnFV0WSwFULzS/H12Ml8O36CDArSHLh5yhCNryIw/QR6evJ5+wdo7bJNOFM
 /UdsaStJMs++hJSCD17QfdvuaL+k5/Pgw9BuElgm1aogqeffmwWojtFw7GXz+D4BfqPf xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xykbpe89w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2020 23:07:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 015N4JeO130931
        for <linux-xfs@vger.kernel.org>; Wed, 5 Feb 2020 23:07:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xymutvd71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2020 23:07:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 015N7cDm005607
        for <linux-xfs@vger.kernel.org>; Wed, 5 Feb 2020 23:07:38 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 Feb 2020 15:07:38 -0800
Subject: Re: [PATCH v6 16/16] xfs: Add delay ready attr set routines
From:   Allison Collins <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-17-allison.henderson@oracle.com>
 <20200122001237.GP8247@magnolia>
 <23b9c16b-dcf7-de47-bfae-5e03adb81703@oracle.com>
Message-ID: <738cb956-f44b-12cd-6f57-feca617d5c6a@oracle.com>
Date:   Wed, 5 Feb 2020 16:07:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <23b9c16b-dcf7-de47-bfae-5e03adb81703@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9522 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/22/20 3:30 AM, Allison Collins wrote:
> 
> 
> On 1/21/20 5:12 PM, Darrick J. Wong wrote:
>> On Sat, Jan 18, 2020 at 03:50:35PM -0700, Allison Collins wrote:

<snip>

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
> No.  And if they did, they would have to show up in the calling 
> functions state switches.  Because the calling function has to manage 
> jumping straight back to the subroutine when ever the state belongs to 
> the subroutine.  Kind of like how you see XFS_DAS_ALLOC_LEAF and 
> XFS_DAS_FLIP_LFLAG in the state switch for xfs_attr_set_iter, even 
> though those states only apply to xfs_attr_leaf_addname.
> 
>>
>> The new state machine code in last two patches would be a lot easier to
>> review if I could look down from above instead of up from the XFS_DAS
>> values and goto labels.  I /think/ it looks sane, but I'm only 20%
>> confident of that statement.
>>
> Sure, I'll see if I can put together a diagram to help folks out a bit.
> 
> Thanks for the reviews!
> Allison
> 
>> --D
>>

Ok, so I've put together some quick high level diagrams, and I wanted to 
run it by you to see what you thought.

These diagrams illustrate the state machine logic as it appears in the 
current set. The XFS_DAS_* states indicate places where the function 
would return -EAGAIN, and then immediately resume from after being 
recalled by the calling function.  States marked as a "subroutine state" 
indicate that they belong to a subroutine, and so the calling function 
needs to pass them back to that subroutine to allow it to finish where 
it left off.  But they otherwise do not have a role in the calling 
function other than just passing through.

Hope this helps!  Let me know if you have any questions or if there's 
anything that would help make things more clear.  Thanks!

Allison

/*
  * State machine diagram for attr remove operations
  *
  * xfs_attr_remove_iter()
  *         XFS_DAS_RM_SHRINK     ─┐
  *         (subroutine state)     │
  *                                │
  *         XFS_DAS_RMTVAL_REMOVE ─┤
  *         (subroutine state)     │
  *                                └─>xfs_attr_node_removename()
  *                                                 │
  *                                                 v
  *                                         need to remove
  *                                   ┌─n──  rmt blocks?
  *                                   │             │
  *                                   │             y
  *                                   │             │
  *                                   │             v
  *                                   │  ┌─>XFS_DAS_RMTVAL_REMOVE
  *                                   │  │          │
  *                                   │  │          v
  *                                   │  └──y── more blks
  *                                   │         to remove?
  *                                   │             │
  *                                   │             n
  *                                   │             │
  *                                   │             v
  *                                   │         need to
  *                                   └─────> shrink tree? ─n─┐
  *                                                 │         │
  *                                                 y         │
  *                                                 │         │
  *                                                 v         │
  *                                         XFS_DAS_RM_SHRINK │
  *                                                 │         │
  *                                                 v         │
  *                                                done <─────┘
  */

/*
  * State machine diagram for attr set operations
  *
  * xfs_attr_set_iter()
  *                 │
  *                 v
  *           need to upgrade
  *          from sf to leaf? ──n─┐
  *                 │             │
  *                 y             │
  *                 │             │
  *                 V             │
  *          XFS_DAS_ADD_LEAF     │
  *                 │             │
  *                 v             │
  *  ┌──────n── fork has   <──────┘
  *  │         only 1 blk?
  *  │              │
  *  │              y
  *  │              │
  *  │              v
  *  │     xfs_attr_leaf_try_add()
  *  │              │
  *  │              v
  *  │          had enough
  *  ├──────n──   space?
  *  │              │
  *  │              y
  *  │              │
  *  │              v
  *  │      XFS_DAS_FOUND_LBLK  ──┐
  *  │                            │
  *  │      XFS_DAS_FLIP_LFLAG  ──┤
  *  │      (subroutine state)    │
  *  │                            │
  *  │      XFS_DAS_ALLOC_LEAF  ──┤
  *  │      (subroutine state)    │
  *  │                            └─>xfs_attr_leaf_addname()
  *  │                                              │
  *  │                                              v
  *  │                                ┌─────n──  need to
  *  │                                │        alloc blks?
  *  │                                │             │
  *  │                                │             y
  *  │                                │             │
  *  │                                │             v
  *  │                                │  ┌─>XFS_DAS_ALLOC_LEAF
  *  │                                │  │          │
  *  │                                │  │          v
  *  │                                │  └──y── need to alloc
  *  │                                │         more blocks?
  *  │                                │             │
  *  │                                │             n
  *  │                                │             │
  *  │                                │             v
  *  │                                │          was this
  *  │                                └────────> a rename? ──n─┐
  *  │                                              │          │
  *  │                                              y          │
  *  │                                              │          │
  *  │                                              v          │
  *  │                                      XFS_DAS_FLIP_LFLAG │
  *  │                                              │          │
  *  │                                              v          │
  *  │                                             done <──────┘
  *  └────> XFS_DAS_LEAF_TO_NODE ─┐
  *                               │
  *         XFS_DAS_FOUND_NBLK  ──┤
  *         (subroutine state)    │
  *                               │
  *         XFS_DAS_ALLOC_NODE  ──┤
  *         (subroutine state)    │
  *                               │
  *         XFS_DAS_FLIP_NFLAG  ──┤
  *         (subroutine state)    │
  *                               │
  *                               └─>xfs_attr_node_addname()
  *                                                 │
  *                                                 v
  *                                         find space to store
  *                                        attr. Split if needed
  *                                                 │
  *                                                 v
  *                                         XFS_DAS_FOUND_NBLK
  *                                                 │
  *                                                 v
  *                                   ┌─────n──  need to
  *                                   │        alloc blks?
  *                                   │             │
  *                                   │             y
  *                                   │             │
  *                                   │             v
  *                                   │  ┌─>XFS_DAS_ALLOC_NODE
  *                                   │  │          │
  *                                   │  │          v
  *                                   │  └──y── need to alloc
  *                                   │         more blocks?
  *                                   │             │
  *                                   │             n
  *                                   │             │
  *                                   │             v
  *                                   │          was this
  *                                   └────────> a rename? ──n─┐
  *                                                 │          │
  *                                                 y          │
  *                                                 │          │
  *                                                 v          │
  *                                         XFS_DAS_FLIP_NFLAG │
  *                                                 │          │
  *                                                 v          │
  *                                                done <──────┘
  */
