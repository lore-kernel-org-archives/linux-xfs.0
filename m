Return-Path: <SRS0=lPx5=3L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DA9C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 07:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E4CB2465B
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jan 2020 07:39:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m0qf5aA5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbgAVHjs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jan 2020 02:39:48 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49872 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVHjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jan 2020 02:39:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M7cUTq181102
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 07:39:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=1OXrkULqbu/H8ASkcdolHQZ4z4cfNGTAZiEuh+OU1Ag=;
 b=m0qf5aA5BA0t7nSh605Ub4Ylio0au9u2r/dLaqAojEESH2xHRnlcM9UsaEljsrw8iHOO
 Fu9Zg8hnW5ed5xpdUNAzzYJImvCMrPVOPTsMwGrBaWPqUzoJOkJAd4h6tL5c+7wSDucx
 B165xc7d9w2yE7K/xQ6KAmmLOoSu52RVvrWtvQ66n4DSZXFI1ByEo4ySpu6Tpe9FF/Wn
 fLLZAZsJ3WweiiQLi41pbAVHIOLG4XOVTcsqZ0laNO5EYXxqhjs2c3RdCW31iq9XRXy4
 0uAS4ccdwGzSXM0gDDURqhroIZsmTHAMHQT0on7ofBCh3GYFGSkvvwbZBonHIn6lcKVU ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnr9s1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 07:39:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M7d3Ir112808
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 07:39:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2xnsj6cuae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 07:39:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00M7dkvg023997
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 07:39:46 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 23:39:45 -0800
Subject: Re: [PATCH v6 14/16] xfs: Simplify xfs_attr_set_args
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-15-allison.henderson@oracle.com>
 <20200121233147.GN8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8db11e90-9d75-60d0-f2e9-8888a4ecda77@oracle.com>
Date:   Wed, 22 Jan 2020 00:39:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121233147.GN8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 4:31 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:33PM -0700, Allison Collins wrote:
>> Delayed attribute mechanics make frequent use of goto statements.  We
>> can use this to further simplify xfs_attr_set_args.  In this patch we
>> introduce one of the gotos now to help pre-simplify the routine.  This
>> will help make proceeding patches in this area easier to read.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 71 +++++++++++++++++++++++++-----------------------
>>   1 file changed, 37 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 453ea59..90e0b2d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -264,47 +264,50 @@ xfs_attr_set_args(
>>   	int			error, error2 = 0;
>>   
>>   	/*
>> -	 * If the attribute list is non-existent or a shortform list,
>> -	 * upgrade it to a single-leaf-block attribute list.
>> +	 * If the attribute list is non-existent or a shortform list, proceed to
>> +	 * upgrade it to a single-leaf-block attribute list.  Otherwise jump
>> +	 * straight to leaf handling
> 
> We don't jump to "upgrade it to a single leaf block attr list" quite
> that soon.
> 
> "If the attribute list is already in leaf format, jump straight to leaf
> handling.  Otherwise, try to add the attribute to the shortform list; if
> there's no room then convert the list to leaf format and try again." ?
Sure, I think that sounds good.

> 
>>   	 */
>> -	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	if (!(dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>>   	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -	     dp->i_d.di_anextents == 0)) {
>> +	     dp->i_d.di_anextents == 0)))
> 
> Also... maybe this should just be a separate predicate?
> 
> static inline bool
> xfs_attr_is_leaf_format(
> 	struct xfs_inode	*dp)
> {
> 	return dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> 		dp->i_d.di_anextents > 0;
> }
> 
> 
> if (xfs_attr_is_leaf_format(dp))
> 	goto add_leaf;

Ok, I think that looks better too.  Will add.

> 
>> +		goto sf_to_leaf;
>>   
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>>   
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> -			return error;
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.
>> +	 * GROT: another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +	if (error)
>> +		return error;
>>   
>> -		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 * Once we're done rolling the transaction we can release
>> -		 * the hold and add the attr to the leaf.
>> -		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a
>> +	 * concurrent AIL push cannot grab the half-baked leaf
>> +	 * buffer and run into problems with the write verifier.
>> +	 * Once we're done rolling the transaction we can release
>> +	 * the hold and add the attr to the leaf.
>> +	 */
>> +	xfs_trans_bhold(args->trans, leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, leaf_bp);
>> +	if (error) {
>> +		xfs_trans_brelse(args->trans, leaf_bp);
>> +		return error;
>>   	}
>>   
>> +sf_to_leaf:
> 
> The attr list already has to be in list format by the time it gets here,
> which means that the label name is misleading.  How about "add_leaf" ?
Sure, I'll update the state machine names to match too then.

Thanks for the review!
Allison

> 
> --D
> 
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>>   		if (error != -ENOSPC)
>> -- 
>> 2.7.4
>>
