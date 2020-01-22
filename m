Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CE2C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 05:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34C1121835
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 05:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kMZ9G8B9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgAVFF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 00:05:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgAVFF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 00:05:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4w2B1061142
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BGjRrER/Cp8HIwYFJXb8bJg+t60zuTFHf5BO0w1MAfk=;
 b=kMZ9G8B9QCkohuaua2ElhvIHaShrOR6vNzkwYAWbJKhrUYxqxUzcQzvUdZPSh+4GRKeC
 43tLP9KmLt6ilVdslv09YF669OOu9q9E5JGQ8v9Et7meltUh+e71V8d2g3D7uB9Srkua
 AeNv9aK/4S0d7U8ugE0Vl22aXYEougtVQ/pCZlw6dRQAi+NIFR+pSjuxCrh1olnM2LDW
 aR5FwQXaKZaw9unLEtXkBBvwR2RfMyQp0fseFCYDU3ovYBAu9ElREjduQpqzi6lCxXT5
 suaYLzu8IYoBYPSCGvhK9Xt9mFqj+y0a6gdCTKuQaLqC+Fp4KP3kNk/AQpQ1bu5siurx vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr95sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:05:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4xRFY063597
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:05:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xnpejf1jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:05:55 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00M55sUA014405
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 05:05:54 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 21:05:54 -0800
Subject: Re: [PATCH v6 12/16] xfs: Add helper function
 xfs_attr_init_unmapstate
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-13-allison.henderson@oracle.com>
 <20200121232139.GL8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <e2e17731-85e5-1010-4259-5a9fe46a6deb@oracle.com>
Date:   Tue, 21 Jan 2020 22:05:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121232139.GL8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220043
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 4:21 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:31PM -0700, Allison Collins wrote:
>> This patch helps to pre-simplify xfs_attr_node_removename by modularizing
>> the code around the transactions into helper functions.  This will make
>> the function easier to follow when we introduce delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>>   1 file changed, 31 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e9d22c1..453ea59 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1202,6 +1202,36 @@ xfs_attr_node_addname(
>>   }
>>   
>>   /*
>> + * Set up the state for unmap and set the incomplete flag
> 
> "Mark an attribute entry INCOMPLETE and save pointers to the relevant
> buffers for later deletion of the entry." ?
I am fine with that if folks prefer.

> 
>> + */
>> +STATIC int
>> +xfs_attr_init_unmapstate(
> 
> I'm hung up on this name -- it marks the entry incomplete and saves some
> breadcrumbs for erasing data later, which I guess is "unmap state"?
> What do you think of:
> 
> xfs_attr_leaf_mark_incomplete()

I actually struggled a bit with what to call it.  I called it an init 
because in the immediately proceeding code we fall into a loop of 
bunmapi and refilling the state, rolling the transaction in between. 
But we only make this initial call once before we start doing that. 
Later when we get into the state machine this turns into multiple 
iterations of jumping in and out of this region of code.  Even though 
the while() syntax is gone, it still ends up functioning very much like 
a loop.

This helper function isnt so much necessary as much as it is an effort 
to cut down on the size of xfs_attr_node_removename which was getting 
quite lengthy.

In anycase, xfs_attr_leaf_mark_incomplete is fine with me :-)

> 
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	int error;
>> +
>> +	/*
>> +	 * Fill in disk block numbers in the state structure
>> +	 * so that we can get the buffers back after we commit
>> +	 * several transactions in the following calls.
>> +	 */
>> +	error = xfs_attr_fillstate(state);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Mark the attribute as INCOMPLETE
> 
> Has this stopped doing the bunmapi call, or was the comment inaccurate?
> I'm guessing the second if it's necessary to save state to recover
> buffer pointers later...?
Right, I clipped off the comment because we dont do the bunmapi in this 
function scope.  That happens later in the loop behavior described above.

Hope that helps!

Allison

> 
> --D
> 
>> +	 */
>> +	error = xfs_attr3_leaf_setflag(args);
>> +	if (error)
>> +		return error;
>> +
>> +	return 0;
>> +}
>> +
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1233,20 +1263,7 @@ xfs_attr_node_removename(
>>   	ASSERT(blk->bp != NULL);
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   	if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Fill in disk block numbers in the state structure
>> -		 * so that we can get the buffers back after we commit
>> -		 * several transactions in the following calls.
>> -		 */
>> -		error = xfs_attr_fillstate(state);
>> -		if (error)
>> -			goto out;
>> -
>> -		/*
>> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
>> -		 * remote value.
>> -		 */
>> -		error = xfs_attr3_leaf_setflag(args);
>> +		error = xfs_attr_init_unmapstate(args, state);
>>   		if (error)
>>   			goto out;
>>   
>> -- 
>> 2.7.4
>>
