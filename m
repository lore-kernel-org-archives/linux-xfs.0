Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA87C55181
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88A0E206F9
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vyQNFjUw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDTWqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:46:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42928 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTWqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 18:46:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMcURv130175;
        Mon, 20 Apr 2020 22:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+pVhbOiLMMINqHN2eL8P/r9MzsF1H25PRHsIchb5xns=;
 b=vyQNFjUwHwljuxs53uh29qD4UpxVqpRCTcJEuPDBKj3tVzwdeALZkC5JgqNZOjrjyNLw
 /mDBuPrQzkCKrNTMNqL02a/I90q5HRJstX1QwN3yn6TERVQeK1Und0mjWkyU3rTBTyr/
 XkY2QalyZ/vTQRFl1L4sW4vTha7ghtZ4Xc5cz9EYng+tOqn+uoMEiixXq6zrfOxp9yeQ
 Xsg+RAEdL2y50fT1f6O9j2W8KDfty74pzt03PCmEsfMOA60XGGAnIRXx8Iqq9VjIoFU1
 7qE5PoebzGSEEcDDBRFMFl1NBB57kOW2XitNb3Dcg4hF9illPEn43f3szfIPslc4Kbke Vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30ft6n1wpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KMbdCc150309;
        Mon, 20 Apr 2020 22:46:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3r7sh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 22:46:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03KMk4Ff016227;
        Mon, 20 Apr 2020 22:46:04 GMT
Received: from [10.65.145.61] (/10.65.145.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 15:46:04 -0700
Subject: Re: [PATCH v8 17/20] xfs: Add helper function
 xfs_attr_node_removename_rmt
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-18-allison.henderson@oracle.com>
 <132283294.3z7BuaCSDq@localhost.localdomain>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <59bcbe46-fb00-d681-569c-47ca358f8b6d@oracle.com>
Date:   Mon, 20 Apr 2020 15:46:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <132283294.3z7BuaCSDq@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9597 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/19/20 11:38 PM, Chandan Rajendra wrote:
> On Saturday, April 4, 2020 3:42 AM Allison Collins wrote:
>> This patch adds another new helper function
>> xfs_attr_node_removename_rmt. This will also help modularize
>> xfs_attr_node_removename when we add delay ready attributes later.
>>
> 
> The changes look logically correct.
> 
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Thank you!
Allison

> 
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
>> +	error = xfs_attr_refillstate(state);
>> +	if (error)
>> +		return error;
>> +
>> +	return 0;
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
>>
> 
> 
