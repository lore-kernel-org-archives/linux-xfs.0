Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D68C4BA09
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 102B721744
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 02:13:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aOH0bGzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgBZCNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 21:13:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgBZCNs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 21:13:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2CpJw104108;
        Wed, 26 Feb 2020 02:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qX225SgbfkdsBx6FtuyBV3atptpw+4NrlAKo1ohpRrE=;
 b=aOH0bGzISHN0mIemuDH6p0VqthwLCQo97/9eeOawFiFYn93F2P1Rqqk0OWhkmltGFmvS
 PzxCsyC24r6/Y2YdZBtvVwlnY44XwNt+Nt2WnJSyl4BxBZOUGMUnRHULjk+aDhRkHIeB
 xE3332eCio54la/jdz9rO+BNDQQpcQ3JpeLnQ7XPgiXRtzMzoF7Nejm4/IGx2wU7J8g7
 67dJaBXoH1WmR5NIGRdS/y47mCFTqBEFOFB2yNa2Hl4POosKiS7YbGmwK2vWDd1/PAvG
 rygpnl/T81PlULMlvKpYBR77U37qVU12DWtQp2hGOKtCythrTs+TZSCnDiAe+kixloZY 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ydct30jbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:13:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q2CM02016430;
        Wed, 26 Feb 2020 02:13:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ydcs2nhes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 02:13:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01Q2DhHM023835;
        Wed, 26 Feb 2020 02:13:43 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 18:13:43 -0800
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-17-allison.henderson@oracle.com>
 <20200225092122.GK10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b0167c4e-7703-1805-7b58-42096fcee90a@oracle.com>
Date:   Tue, 25 Feb 2020 19:13:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225092122.GK10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 2:21 AM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:06:08PM -0700, Allison Collins wrote:
>> Delayed attribute mechanics make frequent use of goto statements.  We can use this
>> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
>> conditions, we can invert the if logic and jump to the goto. This helps to reduce
>> indentation and simplify things.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 42 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 30a16fe..dd935ff 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>>   }
>>   
>>   /*
>> + * Check to see if the attr should be upgraded from non-existent or shortform to
>> + * single-leaf-block attribute list.
>> + */
>> +static inline bool
>> +xfs_attr_fmt_needs_update(
>> +	struct xfs_inode    *dp)
> 
> Can we use *ip for the inode in newly factored code helpers like
> this?

Sure, will fix

> 
>> +{
>> +	return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	      (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +	      dp->i_d.di_anextents == 0);
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>>   	}
>>   
>>   	/*
>> -	 * If the attribute list is non-existent or a shortform list,
>> -	 * upgrade it to a single-leaf-block attribute list.
>> +	 * If the attribute list is already in leaf format, jump straight to
>> +	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>> +	 * list; if there's no room then convert the list to leaf format and try
>> +	 * again.
>>   	 */
>> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> -	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -	     dp->i_d.di_anextents == 0)) {
>> +	if (!xfs_attr_fmt_needs_update(dp))
>> +		goto add_leaf;
> 
> The logic seems inverted to me here, but that really indicates a
> sub-optimal function name. It's really checking if the attribute
> fork is empty or in shortform format. Hence:
> 
> 	if (!xfs_attr_is_shortform(dp))
> 		goto add_leaf;
> 
Ok, this had come up in the last review too, we had tried to simplify it 
to an "is_leaf" helper, though it turned out the logic didnt quite work 
the same functionally, so I put it back and renamed it "needs_update". 
I think "is_shortform" is a closer description though.  Will update.

>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>>   
>> -		/* Should only be 0, -EEXIST or ENOSPC */
>> -		if (error != -ENOSPC)
>> -			return error;
>> +	/* Should only be 0, -EEXIST or ENOSPC */
>> +	if (error != -ENOSPC)
>> +		return error;
>>   
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -		if (error)
>> -			return error;
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +	if (error)
>> +		return error;
>>   
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 */
>> -		xfs_trans_bhold(args->trans, *leaf_bp);
>> -		args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> -		args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> -		return -EAGAIN;
>> -	}
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf
>> +	 * buffer and run into problems with the write verifier.
>> +	 */
>> +	xfs_trans_bhold(args->trans, *leaf_bp);
>> +	args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +	args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> +	return -EAGAIN;
> 
> Heh. This is an example of exactly why I think this should be
> factored into functions first. Move all the code you just
> re-indented into xfs_attr_set_shortform(), and the goto disappears
> because this code becomes:
> 
> 	if (xfs_attr_is_shortform(dp))
> 		return xfs_attr_set_shortform(dp, args);
> 
> add_leaf:
> 
> That massively improves the readability of the code - it separates
> the operation implementation from the decision logic nice and
> cleanly, and lends itself to being implemented in the delayed attr
> state machine without needing gotos at all.
Sure, I actually had it more like that in the last version.  I flipped 
it around because I thought it would help people understand what the 
refactoring was for if they could see it in context with the states. 
But if the other way is more helpful, its easy to put back.  Will move :-)

Allison
> 
> Cheers,
> 
> Dave.
> 
