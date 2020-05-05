Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D251C47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DC3206CC
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 17:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C/apm+BW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgEERhj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 13:37:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgEERhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 13:37:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045HXFSJ138741;
        Tue, 5 May 2020 17:37:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EEX+mm+dGQjpIYRbCTljwSW1c/gPT6iEsCkear28tS0=;
 b=C/apm+BW01uyj7JgY0GWe9+temAkvHaKVyBoa63i/VYkE0jhjVHWkMcCmXemXAQHNHtX
 fwE+w2TB0Fet9Nzz1PX0TamP68cggcwtjruXlEk3ThoksdMnd0PhvmqOvP6WmupKIxbt
 lBI81SI86LghTB9DjjJahRE1GydvuZ0H6KZ306b8XakGKfUBpAhvQPjloZ7DK9kvRGQW
 Q/00RVHfkZHaDgMabC4eAAT98Wh5ZUZ3JXd9e6DlaPnoVKesKlGN+SAryXffzh/7PZxT
 ERfXKeO7CPgb1dv0xBoCiymUvRAFh0MjwHHMLlAI3ZFP7Ap05fD77k/RA5qaCp6oMA9P +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tme671-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:37:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045Halxx030143;
        Tue, 5 May 2020 17:37:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30sjk06ty6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 May 2020 17:37:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 045HbZWw022044;
        Tue, 5 May 2020 17:37:35 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 May 2020 10:37:34 -0700
Subject: Re: [PATCH v9 21/24] xfs: Lift -ENOSPC handler from
 xfs_attr_leaf_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-22-allison.henderson@oracle.com>
 <20200505131243.GE60048@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0077af51-2aeb-0100-728a-3a7a5bc49a6b@oracle.com>
Date:   Tue, 5 May 2020 10:37:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200505131243.GE60048@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9612 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/5/20 6:12 AM, Brian Foster wrote:
> On Thu, Apr 30, 2020 at 03:50:13PM -0700, Allison Collins wrote:
>> Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
>> reorganize transitions between the attr forms later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thank you!
Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
>>   1 file changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9171895..c8cae68 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -299,6 +299,13 @@ xfs_attr_set_args(
>>   			return error;
>>   
>>   		/*
>> +		 * Promote the attribute list to the Btree format.
>> +		 */
>> +		error = xfs_attr3_leaf_to_node(args);
>> +		if (error)
>> +			return error;
>> +
>> +		/*
>>   		 * Commit that transaction so that the node_addname()
>>   		 * call can manage its own transactions.
>>   		 */
>> @@ -602,7 +609,7 @@ xfs_attr_leaf_try_add(
>>   	struct xfs_da_args	*args,
>>   	struct xfs_buf		*bp)
>>   {
>> -	int			retval, error;
>> +	int			retval;
>>   
>>   	/*
>>   	 * Look up the given attribute in the leaf block.  Figure out if
>> @@ -634,20 +641,10 @@ xfs_attr_leaf_try_add(
>>   	}
>>   
>>   	/*
>> -	 * Add the attribute to the leaf block, transitioning to a Btree
>> -	 * if required.
>> +	 * Add the attribute to the leaf block
>>   	 */
>> -	retval = xfs_attr3_leaf_add(bp, args);
>> -	if (retval == -ENOSPC) {
>> -		/*
>> -		 * Promote the attribute list to the Btree format. Unless an
>> -		 * error occurs, retain the -ENOSPC retval
>> -		 */
>> -		error = xfs_attr3_leaf_to_node(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -	return retval;
>> +	return xfs_attr3_leaf_add(bp, args);
>> +
>>   out_brelse:
>>   	xfs_trans_brelse(args->trans, bp);
>>   	return retval;
>> -- 
>> 2.7.4
>>
> 
