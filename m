Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF91DC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D24206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iNUCO7NX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgEERfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 13:35:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729709AbgEERfr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 13:35:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HXe8Q195830;
        Tue, 5 May 2020 17:35:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=YGqGdu8B51T66Dapjef7eE1iSDqfXypTB4fOYoRd4S4=;
 b=iNUCO7NXF7gQTnXBC+UoINK2go3P88S4yqmDFm2f05/aExzQ1+FkfZjhVNde1q1j9u0s
 KCJaVD775hjCtPkdotSI1M5zsdhAKeWIVB9dI7NGizWO/3p0P0ROUln0MNwwl6AcJL1O
 0o/mcA1IutLIsxrm3c6l94vcCNoD0TZTKwxBUQMeUHxHoHJAy9kTiRfM0e7kg42qosDc
 mqpBJWO4HRrdjRkQBSlVu9yXCRKo/uW8Y1E3mlPkkM1B9smjDxVpEAdTVd7LiXgAuSFa
 ULVMYlB5HpueFtGSymorVAbIxTtAB06AO4ZHWDBO56mVXh7v1fnUPrd49fLTOfHr9lK4 Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30s09r670j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:35:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HWaEB018762;
        Tue, 5 May 2020 17:35:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30sjk06r0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:35:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 045HZbRm030441;
        Tue, 5 May 2020 17:35:39 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 10:35:34 -0700
Subject: Re: [PATCH v9 19/24] xfs: Simplify xfs_attr_leaf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-20-allison.henderson@oracle.com>
 <20200505131147.GC60048@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8b6950f6-13f9-7091-0ba1-b76ece761f88@oracle.com>
Date:   Tue, 5 May 2020 10:35:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200505131147.GC60048@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/5/20 6:11 AM, Brian Foster wrote:
> On Thu, Apr 30, 2020 at 03:50:11PM -0700, Allison Collins wrote:
>> Quick patch to unnest the rename logic in the leaf code path.  This will
>> help simplify delayed attr logic later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> With Darrick's cleanups:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Great, thank you!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 108 +++++++++++++++++++++++------------------------
>>   1 file changed, 53 insertions(+), 55 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ab1c9fa..1810f90 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -694,73 +694,71 @@ xfs_attr_leaf_addname(
>>   			return error;
>>   	}
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
>>   		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> +		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			return error;
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>>   
>> -		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> -		 */
>> -		xfs_attr_restore_rmt_blk(args);
>> +		return error;
>> +	}
>>   
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_invalidate(args);
>> -			if (error)
>> -				return error;
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>>   
>> -			error = xfs_attr_rmtval_remove(args);
>> -			if (error)
>> -				return error;
>> -		}
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		return error;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series.
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		return error;
>>   
>> -		/*
>> -		 * Read in the block containing the "old" attr, then
>> -		 * remove the "old" attr from that block (neat, huh!)
>> -		 */
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -					   &bp);
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>> +
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			return error;
>>   
>> -		xfs_attr3_leaf_remove(bp, args);
>> -
>> -		/*
>> -		 * If the result is small enough, shrink it all into the inode.
>> -		 */
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				return error;
>> -		}
>> -
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			return error;
>>   	}
>> +
>> +	/*
>> +	 * Read in the block containing the "old" attr, then remove the "old"
>> +	 * attr from that block (neat, huh!)
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				   &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_attr3_leaf_remove(bp, args);
>> +
>> +	/*
>> +	 * If the result is small enough, shrink it all into the inode.
>> +	 */
>> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +	if (forkoff)
>> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +		/* bp is gone due to xfs_da_shrink_inode */
>> +
>>   	return error;
>>   }
>>   
>> -- 
>> 2.7.4
>>
> 
