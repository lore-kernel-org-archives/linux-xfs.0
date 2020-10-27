Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D4BC9DD65
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 15:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1026A2416E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 15:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QXIfGPje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801512AbgJ0Pld (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:41:33 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60938 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1800453AbgJ0Pfy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 11:35:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFTQG9008670;
        Tue, 27 Oct 2020 15:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xdSCWtIDOh/sQ1YJe0YZKfprlTg0iUCUQya8Tuj5Ahk=;
 b=QXIfGPjevhOJq8ZSnEJEQJ3G4zvdOdCGq3hvKWoH1DfVQVo9O1I1zYAoGemdAN1Njh4K
 U3/mdHJONx6mjrvC5xTILjtNp6qoWcnHgYUkVfYbPONeQSErbZJNc0to4j85Z6YQwAUI
 3oquyo8E8+q14kgAd6fjlr5ynXKF/2q8gludmLv2jKkdnw06YovV3USXo/PlTzbpn1Me
 0PHpnaq3WerodwY7aIb4cPdVCvvsfWG9EtxL1piJ0Ic9ego1GYwzc7E69sUIQ6KcWvwz
 Yag9tWEG8/WIhYPo4vo4b+eTTtSOOI9GBPc2V2baIRLISE0q2mRgC4t8H+TZOCWtrPCT QA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9satwam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 15:35:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RFUi5H160231;
        Tue, 27 Oct 2020 15:33:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwumhgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 15:33:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RFXoMv002384;
        Tue, 27 Oct 2020 15:33:50 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 08:33:50 -0700
Subject: Re: [PATCH v13 01/10] xfs: Add helper xfs_attr_node_remove_step
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-2-allison.henderson@oracle.com>
 <20201027121553.GA1560077@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0c50dcdb-1a88-2e6f-eba4-cfc2ae159a46@oracle.com>
Date:   Tue, 27 Oct 2020 08:33:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201027121553.GA1560077@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270097
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270097
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/27/20 5:15 AM, Brian Foster wrote:
> On Thu, Oct 22, 2020 at 11:34:26PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> This patch adds a new helper function xfs_attr_node_remove_step.  This
>> will help simplify and modularize the calling function
>> xfs_attr_node_remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fd8e641..f4d39bf 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
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
>> + * shirnk the tree if needed.
>> + */
>> +STATIC int
>> +xfs_attr_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state;
> 
> It urks me a little bit that we have to dig down into a couple functions
> to grok that state allocation is the first step or otherwise occurs
> before we potentially use the error path. Since we already check for
> state in the out path, can we just initialize this as *state = NULL
> here so the logic is clear? Otherwise the patch LGTM:
> 
Sure, will add.  Thanks!

Allison
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
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
>> -- 
>> 2.7.4
>>
> 
