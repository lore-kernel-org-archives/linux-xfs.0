Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC1C433EA
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2DCF2065F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:09:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q3YiooCS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGYAJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:09:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60542 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgGYAJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:09:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONpSCO186819
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YvGykBbKB+lbGFeF8cO4RpMoFS4Qr46iKmG9+zQLfBQ=;
 b=q3YiooCS14r4XTrNe+BHIM51LHDV9eE3NE8JNS3i6EoAtEk88EWNM+64h2RSUbtCbC4e
 KYXvELkzymWXVMZ54SsvFL09WqS8JNkrKR3Gn/AmAVjOC/0DBHlVf9IMx4Up5ZIvtre5
 46qEYPYDH+g5TTDv+FfPTaZCYqExlliUUYXRfI+aYLx7SiW5j4U6UPcvEDDXYUxWkRdi
 0/WG1eiXKIvJtflwlSf9CxMgw+Q6zHCv/RVgCkstnW8wgVPiZui2iWxflQuURevLlbxn
 rUL8y0SR6OJObqbI/z+XY6j+psEhsIZkuG1audQ1kcVtiQSAMllefZjkFJD0Qg0Lfbsm HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32d6kt5vgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:09:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONsVb2043759
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32g7xv438q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:21 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P07KtV013748
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:20 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:07:20 -0700
Subject: Re: [PATCH v11 05/25] xfs: Split apart xfs_attr_leaf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-6-allison.henderson@oracle.com>
 <20200721231944.GG3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ce237efd-0715-1aef-a03d-6850aad415b6@oracle.com>
Date:   Fri, 24 Jul 2020 17:07:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721231944.GG3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:19 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:15:46PM -0700, Allison Collins wrote:
>> Split out new helper function xfs_attr_leaf_try_add from
>> xfs_attr_leaf_addname. Because new delayed attribute routines cannot
>> roll transactions, we split off the parts of xfs_attr_leaf_addname that
>> we can use, and move the commit into the calling function.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> 
> Looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, thank you!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 95 +++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 61 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 28a9f8e..6fc6dc6 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -256,10 +256,31 @@ xfs_attr_set_args(
>>   		}
>>   	}
>>   
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>   		error = xfs_attr_leaf_addname(args);
>> -	else
>> -		error = xfs_attr_node_addname(args);
>> +		if (error != -ENOSPC)
>> +			return error;
>> +
>> +		/*
>> +		 * Finish any deferred work items and roll the transaction once
>> +		 * more.  The goal here is to call node_addname with the inode
>> +		 * and transaction in the same state (inode locked and joined,
>> +		 * transaction clean) no matter how we got to this step.
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
>> +	}
>> +
>> +	error = xfs_attr_node_addname(args);
>>   	return error;
>>   }
>>   
>> @@ -507,20 +528,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    *========================================================================*/
>>   
>>   /*
>> - * Add a name to the leaf attribute list structure
>> + * Tries to add an attribute to an inode in leaf form
>>    *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + * This function is meant to execute as part of a delayed operation and leaves
>> + * the transaction handling to the caller.  On success the attribute is added
>> + * and the inode and transaction are left dirty.  If there is not enough space,
>> + * the attr data is converted to node format and -ENOSPC is returned. Caller is
>> + * responsible for handling the dirty inode and transaction or adding the attr
>> + * in node format.
>>    */
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
>> @@ -562,31 +584,39 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format. Unless an
>> +		 * error occurs, retain the -ENOSPC retval
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>> +	}
>> +	return retval;
>> +out_brelse:
>> +	xfs_trans_brelse(args->trans, bp);
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
>> +xfs_attr_leaf_addname(
>> +	struct xfs_da_args	*args)
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
>> @@ -681,9 +711,6 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   	}
>>   	return error;
>> -out_brelse:
>> -	xfs_trans_brelse(args->trans, bp);
>> -	return retval;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
