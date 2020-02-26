Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72CEC4BA0A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 03:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B5432465D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 03:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="khzyETLh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBZDaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 22:30:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgBZD3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 22:29:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q3MoWk159327;
        Wed, 26 Feb 2020 03:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PN0zNKkBHnE7YTMQWJIaQPxL52WY91PKt07dkc6yCHY=;
 b=khzyETLhfkx7B5F8+PTm/pwFsqVF7yEQMSHA0ITJebTxtt5s1jCbDd0qYTHG4QNVkS2I
 0pmWjhlsFf7pF60tjtnoaSsd+FKhc9uNiTm0R8czquiAoWGWOjLekPm5PQuRIPzY/R2a
 6lh+0UhMio2nx3twan0RvQ7im0chGyeWeMv+DmxnskrvDOzvpqBYCiS0AukVw4jgjfWz
 jAVq7qt8zGF5plcItyWd1mFP3Z+NxA032JoLGyDR3KtkE+/+3rpcvQcuHwbQNFQ/A0vi
 LhwoZj6qCu7n7rlJWQJ8cRroljLgOABMQ23ceZVTd8Jluo8s/Okzj/qpJTzrW8wIARSx 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2ydct30s1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 03:29:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q3CuWx185423;
        Wed, 26 Feb 2020 03:29:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ydcs8v30x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 03:29:09 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q3T8KH022045;
        Wed, 26 Feb 2020 03:29:08 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 19:29:08 -0800
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-13-allison.henderson@oracle.com>
 <20200224134022.GF15761@bfoster>
 <f8aec2fb-09ef-f636-913c-41b8a5474a9b@oracle.com>
 <20200225132710.GC21304@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <bcb14769-5f5e-4983-9413-f4fa03e921dc@oracle.com>
Date:   Tue, 25 Feb 2020 20:29:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225132710.GC21304@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 6:27 AM, Brian Foster wrote:
> On Mon, Feb 24, 2020 at 02:44:14PM -0700, Allison Collins wrote:
>>
>>
>> On 2/24/20 6:40 AM, Brian Foster wrote:
>>> On Sat, Feb 22, 2020 at 07:06:04PM -0700, Allison Collins wrote:
>>>> This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
>>>> new transactions. We will use this later when we introduce delayed attributes
>>>>
>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
>>>>    fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>>>    2 files changed, 29 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> index 3de2eec..da40f85 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
>>>>    	}
>>>>    	return 0;
>>>>    }
>>>> +
>>>> +/*
>>>> + * Remove the value associated with an attribute by deleting the out-of-line
>>>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>>> + * transaction and recall the function
>>>> + */
>>>> +int
>>>> +xfs_attr_rmtval_unmap(
>>>> +	struct xfs_da_args	*args)
>>>> +{
>>>> +	int	error, done;
>>>> +
>>>> +	/*
>>>> +	 * Unmap value blocks for this attr.  This is similar to
>>>> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
>>>> +	 * for new transactions
>>>> +	 */
>>>> +	error = xfs_bunmapi(args->trans, args->dp,
>>>> +		    args->rmtblkno, args->rmtblkcnt,
>>>> +		    XFS_BMAPI_ATTRFORK, 1, &done);
>>>> +	if (error)
>>>> +		return error;
>>>> +
>>>> +	if (!done)
>>>> +		return -EAGAIN;
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>> Hmm.. any reason this isn't a refactor of the existing remove function?
>>> Just skipping to the end of the series, I see we leave the reference to
>>> xfs_attr_rmtval_remove() (which no longer exists and so is not very
>>> useful) in this comment as well as a stale function declaration in
>>> xfs_attr_remote.h.
>>>
>>> I haven't grokked how this is used yet, but it seems like it would be
>>> more appropriate to lift out the transaction handling from the original
>>> function as we have throughout the rest of the code. That could also
>>> mean creating a temporary wrapper (i.e., rmtval_remove() calls
>>> rmtval_unmap()) for the loop/transaction code that could be removed
>>> later if it ends up unused. Either way is much easier to follow than
>>> creating a (currently unused) replacement..
>> Yes, this came up in one of the other reviews.  I thought about it, but then
>> decided against it.  xfs_attr_rmtval_remove disappears across patches 13 and
>> 14.  The use of xfs_attr_rmtval_remove is replaced with
>> xfs_attr_rmtval_unmap when we finally yank out all the transaction code.
>> The reason I dont want to do it all at once is because that would mean
>> patches 12, 13, 14 and 19 would lump together to make the swap instantaneous
>> in once patch.
>>
> 
> Hmm.. I don't think we're talking about the same thing. If
> xfs_attr_rmtval_remove() was broken down into two functions such that
> one of the two looks exactly like the _unmap() variant, can't we just
> remove the other half when it becomes unused and allow the _remove()
> variant to exist with the implementation of _unmap() proposed here? This
> seems fairly mechanical to me..
Oh, I see what you mean.  No, I had done a review of the uses of 
xfs_attr_rmtval_remove and realized that it appears in both the set and 
remove paths. We use it in the set path when we're doing a rename, and 
need to remove the old attr.

So in patch 13, we replace xfs_attr_rmtval_remove with 
xfs_attr_rmtval_unmap for the remove routines.  But it's still in the 
set routines.  So we cant take it away yet.  Once we get through patch 
14, it is no longer used and we can remove it.  Did that make sense?

> 
>> I've been getting feedback that the set is really complicated, so I've been
>> trying to find a way to organize it to help make it easier to review.  So I
>> thought isolating 13 and 14 to just the state machine would help.  Thus I
>> decided to keep patch 12 separate to take as much craziness out of 13 and 14
>> as possible.  Patches 12 and 19 seem like otherwise easy things for people
>> to look at.  Let me know your thoughts on this. :-)
>>
> 
> I think doing as much refactoring of existing code as early as possible
> will go a long way towards simplifying the complexity around the
> introduction of the state bits.

Alrighty, I was thinking that if I reordered things such that 
modularizing appeared at the end of the set, that it would help people 
to see it in context with the states.  But it sounds like people like it 
the other way around, it's easy enough to put back.  Though I think we 
may still be stuck with 12 and 19 being apart unless 13 and 14 come 
together.  :-(

Allison

> 
> Brian
> 
>> You are right about the stale comment though, I missed it while going back
>> over the commentary at the top.  Will fix.
>>
>> Allison
>>
>>>
>>> Brian
>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> index eff5f95..e06299a 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>>> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>>    int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>>    		xfs_buf_flags_t incore_flags);
>>>>    int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>>> +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>>>>    #endif /* __XFS_ATTR_REMOTE_H__ */
>>>> -- 
>>>> 2.7.4
>>>>
>>>
>>
> 
