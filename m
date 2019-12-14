Return-Path: <SRS0=IS9S=2E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBE5C43603
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 174AA2465E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Dec 2019 06:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSsRwmSJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfLNG6u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Dec 2019 01:58:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfLNG6u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Dec 2019 01:58:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6nJMC068600;
        Sat, 14 Dec 2019 06:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=5x4j09R2I+654z9dQ2O1MaV+RscM+EvbPk0sSQLGIwg=;
 b=QSsRwmSJLmG8hLjw51Vo0WfgYTnWOZyYmoayituCywtJkA0cxIP2CTL3JDE1seh5UjCP
 bLG3dmpsocZa1nGIiLU297wLVJUMPrmgHdfVIsFI99zCZJ1ILmp5hwaMmC6UppH+2+7r
 rEp7ckGVpAP2kdcdlDBT+hzpbxqbwp7jGb0KoNvJ3r84mXCjWqpK/aN4AY0v3yMOZI4d
 TkuSqaPaCzditQe9UzqMSHvQa917LYLbHyJmefwbK7udlM1ijsUCJgZ1uyv4aqtCOKVa
 pNSvp90tBnFM1v1iY5u6IqaEPjtiEoXJ+q5LxSKw6BIARNCM9TR9qBk4+NHvaQaiSWKZ GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wvqpprbc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:58:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBE6wkPJ077986;
        Sat, 14 Dec 2019 06:58:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2wvq2pnwtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Dec 2019 06:58:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBE6wjI8004527;
        Sat, 14 Dec 2019 06:58:45 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 22:58:45 -0800
Subject: Re: [PATCH v5 07/14] xfs: Factor out xfs_attr_leaf_addname helper
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-8-allison.henderson@oracle.com>
 <20191213141515.GD43376@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <250ed72a-ab7d-2c41-87d1-c8f8452fb7f5@oracle.com>
Date:   Fri, 13 Dec 2019 23:58:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191213141515.GD43376@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912140050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912140049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/13/19 7:15 AM, Brian Foster wrote:
> On Wed, Dec 11, 2019 at 09:15:06PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add.
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_leaf_addname that we can use.  This will help
>> to reduce repetitive code later when we introduce
>> delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 83 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 49 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ee973d2..36f6a43 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -305,10 +305,30 @@ xfs_attr_set_args(
>>   		}
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>> -	else
>> -		error = xfs_attr_node_addname(args);
>> +		if (error == 0 || error != -ENOSPC)
>> +			return 0;
> 
> No need to check for 0 since 0 != -ENOSPC. We also probably want to
> return error instead of zero. With that fixed up:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Ok will fix.  Thank you!!

Allison

> 
>> +
>> +		/*
>> +		 * Commit that transaction so that the node_addname()
>> +		 * call can manage its own transactions.
>> +		 */
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>> +		 * Commit the current trans (including the inode) and
>> +		 * start a new one.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		if (error)
>> +			return error;
>> +
>> +	}
>> +
>> +	error = xfs_attr_node_addname(args);
>>   	return error;
>>   }
>>   
>> @@ -606,21 +626,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>>   STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_leaf_try_add(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		*bp)
>>   {
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -	trace_xfs_attr_leaf_addname(args);
>> +	int			retval, error;
>>   
>>   	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>> @@ -666,31 +677,35 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format.
>> +		 * Unless an error occurs, retain the -ENOSPC retval
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	}
>> +	return retval;
>> +}
>>   
>> -		/*
>> -		 * Commit the current trans (including the inode) and start
>> -		 * a new one.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>>   
>> -		/*
>> -		 * Fob the whole rest of the problem off on the Btree code.
>> -		 */
>> -		error = xfs_attr_node_addname(args);
>> +/*
>> + * Add a name to the leaf attribute list structure
>> + *
>> + * This leaf block cannot have a "remote" value, we only call this routine
>> + * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + */
>> +STATIC int
>> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
>> +{
>> +	int			error, forkoff;
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_leaf_addname(args);
>> +
>> +	error = xfs_attr_leaf_try_add(args, bp);
>> +	if (error)
>>   		return error;
>> -	}
>>   
>>   	/*
>>   	 * Commit the transaction that added the attr name so that
>> -- 
>> 2.7.4
>>
> 
