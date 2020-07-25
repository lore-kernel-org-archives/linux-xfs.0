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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206B3C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F072065F
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 00:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j/PHxHDc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgGYAJg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 20:09:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYAJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:09:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONqmhe171088
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3Pra1j7c5305MoP2RvqS+VPCVCe7FIBfxFdI0TBzcXw=;
 b=j/PHxHDcC7LuBnaz63dycRXY+/9LuDSV5xLeY9oBvmQktxC53IE//cdGW4MRH04knVLZ
 AJX/LFJHQHmn5sIrayQ/vz/WUtPno0B0KPN4yK24KRsDeCLVCER4spyEZ1uWa+B9tkBW
 qu0SXkPD/sbafd3LQeyi5IGCuZFcI9//S8JA+6NtZ/nYni0ToWHXk8388XBseXcv0Yx1
 IK7wN7zTHkDPEfjRavB/7wXKAEO0sn6qYJP7FPBivQUFdKR3DkHzjBc3ZEt40Pw+n3Ky
 3eF7ch/f8gsbGbmL7mtH41dniaz0kLVIiR4C1hyuQx2hTOddmKxgYJUTWAB0dLQOQoAQ oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32brgs1pef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:09:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONsNDW032726
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32g72qrr91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P07XFX013513
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:07:34 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 17:07:33 -0700
Subject: Re: [PATCH v11 20/25] xfs: Simplify xfs_attr_leaf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-21-allison.henderson@oracle.com>
 <20200721233910.GK3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5e135864-58c7-f018-36f5-26f74b49d0a6@oracle.com>
Date:   Fri, 24 Jul 2020 17:07:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721233910.GK3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 4:39 PM, Darrick J. Wong wrote:
> On Mon, Jul 20, 2020 at 05:16:01PM -0700, Allison Collins wrote:
>> Invert the rename logic in xfs_attr_leaf_addname to simplify the
>> delayed attr logic later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Thanks!

Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++-----------------------
>>   1 file changed, 55 insertions(+), 52 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index f993af5..ca1e851 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -695,68 +695,71 @@ xfs_attr_leaf_addname(
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
>> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
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
>> -		forkoff = xfs_attr_shortform_allfit(bp, dp);
>> -		if (forkoff)
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +		error = xfs_attr_rmtval_remove(args);
>> +		if (error)
>> +			return error;
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
