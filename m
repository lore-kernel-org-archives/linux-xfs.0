Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0748DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 04:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0702070B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 04:39:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Am/sb1bA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgG2Ej0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 00:39:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgG2Ej0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jul 2020 00:39:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4bnOu015375
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=T0ddFLEm4jTmoirv8T/fqwh/udKNWbHma0J1e4q77EU=;
 b=Am/sb1bAWBvVsz9TYnal3upZjqTLjh0a+UwD3F7mj7JELWOyYtw9OWFm8Do7rI4oC94e
 fTAfe6+S3jRyaajbFC7CMX7lzZsTOp82Hu8GppdfpqSWMoV9TvkLQVrP9XRCXfcO2IKk
 8hnzxyAGW1oSdaL1J/ohg1fSo1ri9aVpiq386cJWKylvhIuxP0MgaTxnHLH+cz1n3EPO
 mL9n1sZoIqHPPgyn/7pmie6w0s7X0JOJ6aZonyWNyEYdRgi+INJajKwnCCjsrxD7IuXb
 8VgXiA+ufWF4PwU7CeCKo0QeMeZFZXEnm6s6396p2VFI9TgjA0StMR0YKbw4sELoqfoe YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32hu1jb7rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:39:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06T4WjOU043246
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32hu5v67am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:24 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06T4bONv031455
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 04:37:24 GMT
Received: from [192.168.1.226] (/67.1.123.207)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 21:37:24 -0700
Subject: Re: [PATCH 1/1] xfs: Fix Smatch warning in xfs_attr_node_get
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200729000853.10215-1-allison.henderson@oracle.com>
 <20200729012348.GD3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2d4984ad-8970-7868-ebcb-d61b9e61d42e@oracle.com>
Date:   Tue, 28 Jul 2020 21:37:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729012348.GD3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007290031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=2 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007290032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/28/20 6:23 PM, Darrick J. Wong wrote:
> On Tue, Jul 28, 2020 at 05:08:53PM -0700, Allison Collins wrote:
>> Fix warning: variable dereferenced before check 'state' in
>> xfs_attr_node_get.  If xfs_attr_node_hasname fails, it may return a null
>> state.  If state is null, do not derefrence it.  Go straight to out.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e5ec9ed..90b7b24 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1409,6 +1409,9 @@ xfs_attr_node_get(
>>   	 * Search to see if name exists, and get back a pointer to it.
>>   	 */
>>   	error = xfs_attr_node_hasname(args, &state);
>> +	if (!state)
>> +		goto out;
>> +
>>   	if (error != -EEXIST)
>>   		goto out_release;
>>   
>> @@ -1426,7 +1429,7 @@ xfs_attr_node_get(
> 
> I would've just changed the for loop to:
> 
> 	for (i = 0; state && i < state->path.active; i++) {
> 
> Since that way we'd know that the error-out path always does the right
> thing wrt any resources that could have been allocated.
> 
Sure, will update

Allison
> --D
> 
>>   		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
>>   		state->path.blk[i].bp = NULL;
>>   	}
>> -
>> +out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>>   	return error;
>> -- 
>> 2.7.4
>>
