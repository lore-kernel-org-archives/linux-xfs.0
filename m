Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 446E2C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 23:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 102FD22B2D
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Dec 2020 23:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgLUXu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Dec 2020 18:50:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLUXu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Dec 2020 18:50:57 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLNoFFr007240;
        Mon, 21 Dec 2020 23:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sZCleVmgdNtBZpx4r08I0dpSzJ4R/HXCzJAgfzJGwBQ=;
 b=rnLl4uWNDrqkX8giKHfGzps44gyQ1QAPLZJo01yu0SMsqMiPFlqjO1MFw2yiIdh5UQLd
 wPSnPs4Lbk+vpXgwOf14td+hXBuB7U3IU89kcx0JGWHwvgPFJdHMJ6Eb0SwRBTE9egDK
 b5y9oESZC7K3QRzOplMTbv+laF2hOAa9oNpfYn5TLhJfhyNnUMmMo3r2tlYEpt+9skWH
 EC1HReCzExDJWsybeshARzaUqSkCh2JpwMoMOx/ihKbu4MsKSLHE0CP2H5SJcswKyZ5e
 WKUbSqAabE6JVlpg8b2hpE9+Q/jfAlvDB3a0u0eY8+uSD7ehGPij6vPn0cIDIzAa65VK kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35k0d1163q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 23:50:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BLNeUaT059816;
        Mon, 21 Dec 2020 23:48:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35k0erufce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 23:48:14 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BLNmD7b013508;
        Mon, 21 Dec 2020 23:48:13 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Dec 2020 15:48:13 -0800
Subject: Re: [PATCH v14 01/15] xfs: Add helper xfs_attr_node_remove_step
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-2-allison.henderson@oracle.com>
 <7926169.lSfAI5dGga@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <ec582aed-08ac-8565-569c-7d79e928679b@oracle.com>
Date:   Mon, 21 Dec 2020 16:48:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7926169.lSfAI5dGga@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210161
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/20/20 11:45 PM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:03 -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> This patch as a new helper function xfs_attr_node_remove_step.  This
> 
> The above should probably be "This patch adds a new ...".
> 
>> will help simplify and modularize the calling function
>> xfs_attr_node_remove.
> 
> The calling function is xfs_attr_node_removename.
> 
> Other than the above mentioned nits, the changes look good to me,
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, will fix nits
Thank you!

Allison
> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fd8e641..8b55a8d 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>>    * the root node (a special case of an intermediate node).
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_remove_step(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> -	trace_xfs_attr_node_removename(args);
>> -
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_node_remove_rmt(args, state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>>   	/*
>> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>>   	if (retval && (state->path.active > 1)) {
>>   		error = xfs_da3_join(state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		/*
>>   		 * Commit the Btree join operation and start a new trans.
>>   		 */
>>   		error = xfs_trans_roll_inode(&args->trans, dp);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove a name from a B-tree attribute list.
>> + *
>> + * This routine will find the blocks of the name to remove, remove them and
>> + * shrink the tree if needed.
>> + */
>> +STATIC int
>> +xfs_attr_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state = NULL;
>> +	int			error;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	error = xfs_attr_node_removename_setup(args, &state);
>> +	if (error)
>> +		goto out;
>> +
>> +	error = xfs_attr_node_remove_step(args, state);
>> +	if (error)
>> +		goto out;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>>
> 
> 
