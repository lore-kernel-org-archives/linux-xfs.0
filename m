Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F594C2D0F4
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B09D20820
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 16:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bydQ6ACM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgDHQcq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 12:32:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgDHQcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 12:32:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GN1A8150368;
        Wed, 8 Apr 2020 16:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bXkoEK471jqyHwzpzcTHQ4r98krIEyAPksDvQKc4eyU=;
 b=bydQ6ACMdD4fzYbro+8WkLakC8P33XXdoJ05rYET2Ug+PYhgD1cZc4W6C3bBWA4u5B4y
 zTye/t6h6nbf1bD7CF9DBSy4jXsJBAZShsWkE5erCUs4IOAixgFFb2s6fTGzbv4NjAI6
 ucDFC9c5zJTQ7zm4yyv+T/iXaTunwTRGO+OSJOmXFAcfEHvPKkbj5CPeodY+H7t0Qlbv
 66f2IMJPEOk6Ce47M+/3SwD7p90mqabmvNJk57wiCECIo40D05sO9UDrCf1ijNxO5t9h
 JzCYjHBdUJkFyIjSgzV4g5jtUKVpP64jNSndq1A7U1cND8AFPWgw7ZH9Igef1ib9W3zl KA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 309gw48hu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:32:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038GMiec080544;
        Wed, 8 Apr 2020 16:32:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 309ag26gp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 16:32:41 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 038GWe9B020124;
        Wed, 8 Apr 2020 16:32:40 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Apr 2020 09:32:40 -0700
Subject: Re: [PATCH v8 17/20] xfs: Add helper function
 xfs_attr_node_removename_rmt
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-18-allison.henderson@oracle.com>
 <20200408121006.GD33192@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5dbad766-97d7-37e0-bcaf-0e1bb5557626@oracle.com>
Date:   Wed, 8 Apr 2020 09:32:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200408121006.GD33192@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/8/20 5:10 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:26PM -0700, Allison Collins wrote:
>> This patch adds another new helper function
>> xfs_attr_node_removename_rmt. This will also help modularize
>> xfs_attr_node_removename when we add delay ready attributes later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 32 +++++++++++++++++++++++---------
>>   1 file changed, 23 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 3c33dc5..d735570 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1221,6 +1221,28 @@ int xfs_attr_node_removename_setup(
>>   	return 0;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_node_removename_rmt (
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>> +{
>> +	int			error = 0;
>> +
>> +	error = xfs_attr_rmtval_remove(args);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Refill the state structure with buffers, the prior calls
>> +	 * released our buffers.
>> +	 */
> 
> The comment can be widened to 80 chars now that indentation has been
> reduced.
> 
>> +	error = xfs_attr_refillstate(state);
>> +	if (error)
>> +		return error;
>> +
>> +	return 0;
> 
> 	return xfs_attr_refillstate(state);
> 
> With those nits fixed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Alrighty, will fix.  Thanks!

Allison
> 
>> +}
>> +
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1249,15 +1271,7 @@ xfs_attr_node_removename(
>>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			goto out;
>> -
>> -		/*
>> -		 * Refill the state structure with buffers, the prior calls
>> -		 * released our buffers.
>> -		 */
>> -		error = xfs_attr_refillstate(state);
>> +		error = xfs_attr_node_removename_rmt(args, state);
>>   		if (error)
>>   			goto out;
>>   	}
>> -- 
>> 2.7.4
>>
> 
