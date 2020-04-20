Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE9BC54FCC
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F208B206F9
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UpIKIA0o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgDTWqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:46:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45846 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgDTWqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:46:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMd2Ow152171;
        Mon, 20 Apr 2020 22:46:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yJUk222uLqw5IqaurDXCMH/nXhbNCAnu0Llru6Z1WYg=;
 b=UpIKIA0ozZBqxJjcjjK4ObVwlRtMEwnN4uhp99J5+jys7/N5XtCQwoiZ1RE2HRtVFqR2
 39LRPsV7+1ChZL3OjIjN4XqZCaRJBY7FT+33dkXVyrFQmI5oiUpby3S8AqkL5f+/2DtV
 Va80mSBSCqTD0MSM7PXgV043R0PWgbQ4gvyY0GZDoh5oTCwUN3s21FhNs5DABbM77Xhk
 3GgBsuLLexnxXfUf9xcx8zRXw590HAB/2LEud3+3RxFCK+4I8CW71MR61ijIJh0d8Ntl
 165ib+wEI3A92jtrNLi+WGevzqnmkdH6KySQo07o1K7QAhzZ9XJJ56KEQdh0XbXGAdEo Hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30fsgkt0m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMbe3X150430;
        Mon, 20 Apr 2020 22:46:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30gb3r7se6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:00 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KMjxWw017232;
        Mon, 20 Apr 2020 22:45:59 GMT
Received: from [10.65.145.61] (/10.65.145.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 15:45:59 -0700
Subject: Re: [PATCH v8 13/20] xfs: Add helpers xfs_attr_is_shortform and
 xfs_attr_set_shortform
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-14-allison.henderson@oracle.com>
 <1908499.KaWVsrpO4C@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c8aa58ac-8bc1-6f49-58d8-703cc5328439@oracle.com>
Date:   Mon, 20 Apr 2020 15:45:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1908499.KaWVsrpO4C@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/19/20 10:30 PM, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
>> In this patch, we hoist code from xfs_attr_set_args into two new helpers
>> xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
>> to simplify xfs_attr_set_args when we get into delayed attrs later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
>>   1 file changed, 72 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4225a94..ba26ffe 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
>>   }
>>   
>>   /*
>> + * Check to see if the attr should be upgraded from non-existent or shortform to
>> + * single-leaf-block attribute list.
>> + */
>> +static inline bool
>> +xfs_attr_is_shortform(
>> +	struct xfs_inode    *ip)
>> +{
>> +	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +	      (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +	      ip->i_d.di_anextents == 0);
>> +}
>> +
>> +/*
>> + * Attempts to set an attr in shortform, or converts the tree to leaf form if
> 
> I think you meant to say "converts short form to leaf form".
> 
> The functional changes look logically correct,
Ok, will fix the comment.  Thanks for the review!

Allison

> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
>> + * there is not enough room.  If the attr is set, the transaction is committed
>> + * and set to NULL.
>> + */
>> +STATIC int
>> +xfs_attr_set_shortform(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		**leaf_bp)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			error, error2 = 0;
>> +
>> +	/*
>> +	 * Try to add the attr to the attribute list in the inode.
>> +	 */
>> +	error = xfs_attr_try_sf_addname(dp, args);
>> +	if (error != -ENOSPC) {
>> +		error2 = xfs_trans_commit(args->trans);
>> +		args->trans = NULL;
>> +		return error ? error : error2;
>> +	}
>> +	/*
>> +	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>> +	 * another possible req'mt for a double-split btree op.
>> +	 */
>> +	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>> +	 * push cannot grab the half-baked leaf buffer and run into problems
>> +	 * with the write verifier. Once we're done rolling the transaction we
>> +	 * can release the hold and add the attr to the leaf.
>> +	 */
>> +	xfs_trans_bhold(args->trans, *leaf_bp);
>> +	error = xfs_defer_finish(&args->trans);
>> +	xfs_trans_bhold_release(args->trans, *leaf_bp);
>> +	if (error) {
>> +		xfs_trans_brelse(args->trans, *leaf_bp);
>> +		return error;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -212,48 +272,25 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error, error2 = 0;
>> +	int			error = 0;
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
>> -
>> -		/*
>> -		 * Try to add the attr to the attribute list in the inode.
>> -		 */
>> -		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> -		/*
>> -		 * It won't fit in the shortform, transform to a leaf block.
>> -		 * GROT: another possible req'mt for a double-split btree op.
>> -		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> -		if (error)
>> -			return error;
>> +	if (xfs_attr_is_shortform(dp)) {
>>   
>>   		/*
>> -		 * Prevent the leaf buffer from being unlocked so that a
>> -		 * concurrent AIL push cannot grab the half-baked leaf
>> -		 * buffer and run into problems with the write verifier.
>> -		 * Once we're done rolling the transaction we can release
>> -		 * the hold and add the attr to the leaf.
>> +		 * If the attr was successfully set in shortform, the
>> +		 * transaction is committed and set to NULL.  Otherwise, is it
>> +		 * converted from shortform to leaf, and the transaction is
>> +		 * retained.
>>   		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> +		error = xfs_attr_set_shortform(args, &leaf_bp);
>> +		if (error || !args->trans)
>>   			return error;
>> -		}
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>
> 
> 
