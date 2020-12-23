Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEE5C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 05:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 984F3207A5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 05:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbgLWFVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 00:21:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48742 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbgLWFVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 00:21:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BN5A4wG117239;
        Wed, 23 Dec 2020 05:20:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=80hWD0EsrgByibNbehvH8JyZPyyRgvdXuBxu/ADQlGQ=;
 b=u70b/bZ+upVj3uhgN8wOHp1gkuoVqaVnAmgoiNuOnIQPWtaqNkvsuZwOd2lcMPhewBFW
 Pdp+v1ynfEY8COHlt7VSYLibUeuFQ0oGktrXow7lfXqvD6OcDDBrkt5Gt5aVDHQdttFE
 eZs6WKzGM0wZX/tAEt8sdoytZwJgrNSVdfdd4UkryxvnzgtUg7SRO/i/ORapuXv0jd+X
 +3B6tNgpuCmNFctOzflt0u5QurXd7jVT3U1U08YvFriK3apy37+m7cZ7Q7ZqAJuYIlXx
 4grtAk7n4SU6DiKruc5lLAVa5Erd15/q5nRMTrcjJM5A9YMV9FTnIyQ66RRb4W9whxnT 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35k0d16a02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Dec 2020 05:20:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BN59cCw180852;
        Wed, 23 Dec 2020 05:20:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35k0e9bqba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Dec 2020 05:20:18 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BN5KHsH002994;
        Wed, 23 Dec 2020 05:20:17 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Dec 2020 21:20:17 -0800
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
 <20201222171148.GC2808393@bfoster> <20201222172020.GD2808393@bfoster>
 <20201222184451.GE2808393@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <4d3a8199-4d8f-2691-6ad0-1f7d0aa9500c@oracle.com>
Date:   Tue, 22 Dec 2020 22:20:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201222184451.GE2808393@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9843 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9843 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1011
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012230039
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/22/20 11:44 AM, Brian Foster wrote:
> On Tue, Dec 22, 2020 at 12:20:20PM -0500, Brian Foster wrote:
>> On Tue, Dec 22, 2020 at 12:11:48PM -0500, Brian Foster wrote:
>>> On Fri, Dec 18, 2020 at 12:29:06AM -0700, Allison Henderson wrote:
>>>> This patch modifies the attr remove routines to be delay ready. This
>>>> means they no longer roll or commit transactions, but instead return
>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>> uses a sort of state machine like switch to keep track of where it was
>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>> consists of a simple loop to refresh the transaction until the operation
>>>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
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
>>>
>>> I started with a couple small comments on this patch but inevitably
>>> started thinking more about the factoring again and ended up with a
>>> couple patches on top. The first is more of some small tweaks and
>>> open-coding that IMO makes this patch a bit easier to follow. The
>>> second is more of an RFC so I'll follow up with that in a second email.
>>> I'm curious what folks' thoughts might be on either. Also note that I'm
>>> primarily focusing on code structure and whatnot here, so these are fast
>>> and loose, compile tested only and likely to be broken.
>>>
>>
>> ... and here's the second diff (applies on top of the first).
>>
>> This one popped up after staring at the previous changes for a bit and
>> wondering whether using "done flags" might make the whole thing easier
>> to follow than incremental state transitions. I think the attr remove
>> path is easy enough to follow with either method, but the attr set path
>> is a beast and so this is more with that in mind. Initial thoughts?
>>
> 
> Eh, the more I stare at the attr set code I'm not sure this by itself is
> much of an improvement. It helps in some areas, but there are so many
> transaction rolls embedded throughout at different levels that a larger
> rework of the code is probably still necessary. Anyways, this was just a
> random thought for now..
> 
> Brian

No worries, I know the feeling :-)  The set works and all, but I do 
think there is struggle around trying to find a particularly pleasent 
looking presentation of it.  Especially when we get into the set path, 
it's a bit more complex.  I may pick through the patches you habe here 
and pick up the whitespace cleanups and other style adjustments if 
people prefer it that way.  The good news is, a lot of the *_args 
routines are supposed to disappear at the end of the set, so there's not 
really a need to invest too much in them I suppose. It may help to jump 
to the "Set up infastructure" patch too.  I've expanded the diagram to 
try and help illustrait the code flow a bit, so that may help with 
following the code flow.

Allison

> 
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 2e466c4ac283..106e3c070131 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1271,14 +1271,12 @@ int xfs_attr_node_removename_setup(
>>    * successful error code is returned.
>>    */
>>   STATIC int
>> -xfs_attr_node_remove_step(
>> -	struct xfs_delattr_context	*dac,
>> -	bool				*joined)
>> +xfs_attr_node_remove_rmt_step(
>> +	struct xfs_delattr_context	*dac)
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>>   	struct xfs_da_state		*state = dac->da_state;
>> -	struct xfs_da_state_blk		*blk;
>> -	int				error = 0, retval, done;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.  This is
>> @@ -1300,6 +1298,19 @@ xfs_attr_node_remove_step(
>>   			return error;
>>   	}
>>   
>> +	dac->dela_state |= XFS_DAS_RMT_DONE;
>> +	return error;
>> +}
>> +
>> +STATIC int
>> +xfs_attr_node_remove_join_step(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	struct xfs_da_state_blk		*blk;
>> +	int				error, retval;
>> +
>>   	/*
>>   	 * Remove the name and update the hashvals in the tree.
>>   	 */
>> @@ -1317,9 +1328,12 @@ xfs_attr_node_remove_step(
>>   		error = xfs_da3_join(state);
>>   		if (error)
>>   			return error;
>> -		*joined = true;
>> +
>> +		error = -EAGAIN;
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   	}
>>   
>> +	dac->dela_state |= XFS_DAS_JOIN_DONE;
>>   	return error;
>>   }
>>   
>> @@ -1342,36 +1356,23 @@ xfs_attr_node_removename_iter(
>>   	struct xfs_da_state		*state = dac->da_state;
>>   	int				error;
>>   	struct xfs_inode		*dp = args->dp;
>> -	bool				joined = false;
>>   
>> -	switch (dac->dela_state) {
>> -	case XFS_DAS_UNINIT:
>> -		/*
>> -		 * repeatedly remove remote blocks, remove the entry and join.
>> -		 * returns -EAGAIN or 0 for completion of the step.
>> -		 */
>> -		error = xfs_attr_node_remove_step(dac, &joined);
>> +	if (!(dac->dela_state & XFS_DAS_RMT_DONE)) {
>> +		error = xfs_attr_node_remove_rmt_step(dac);
>>   		if (error)
>>   			goto out;
>> -		if (joined) {
>> -			dac->flags |= XFS_DAC_DEFER_FINISH;
>> -			dac->dela_state = XFS_DAS_RM_SHRINK;
>> -			return -EAGAIN;
>> -		}
>> -		/* fallthrough */
>> -	case XFS_DAS_RM_SHRINK:
>> -		/*
>> -		 * If the result is small enough, push it all into the inode.
>> -		 */
>> -		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -			error = xfs_attr_node_shrink(args, state);
>> -		break;
>> -	default:
>> -		ASSERT(0);
>> -		error = -EINVAL;
>> -		goto out;
>>   	}
>>   
>> +	if (!(dac->dela_state & XFS_DAS_JOIN_DONE)) {
>> +		error = xfs_attr_node_remove_join_step(dac);
>> +		if (error)
>> +			goto out;
>> +	}
>> +
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_node_shrink(args, state);
>> +	ASSERT(error != -EAGAIN);
>> +
>>   out:
>>   	if (state && error != -EAGAIN)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 3154ef4b7833..67e730cd3267 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -151,6 +151,9 @@ enum xfs_delattr_state {
>>   	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>>   };
>>   
>> +#define XFS_DAS_RMT_DONE	0x1
>> +#define XFS_DAS_JOIN_DONE	0x2
>> +
>>   /*
>>    * Defines for xfs_delattr_context.flags
>>    */
>>
> 
