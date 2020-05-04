Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48343C47254
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264E724964
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 23:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iDS5DhyS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgEDXEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 19:04:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgEDXEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:04:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N3gJC074008
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jKPCHNQv5daGlFc/IU20U0P5opIsDT/rGay8wonP+as=;
 b=iDS5DhyStq2gW5ZkPvqre/pEt7i7BkA9spxYk5dTLuj6Wz2j1y3FM+c4PGsbL+uAl+lU
 TnP8cZvSpFOfe+g3ron1HpJW65OYqfDkVSIeKW9O2+DmSk+93s87iE2OfQMTAGQrySyi
 9dV6ljhoyE+eqWDSUx6HCqFl5UqSGPB9/QOxXRISU1N8pULbgk8FyyoxDbTuA/rOI9An
 cwx5sI9+5MLVU78TQNxScVUqXMA0mna98QjgVIyaG3gLdwrLMrVz9B109Dz0gR0SBN6M
 j1Lg/Ht/eq3GBAKem3KfSYw5wFhjJMfDaMCjZywZJUjyNwsUB4zXgbDvMosMtrnwaIZ2 JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30s1gn1kgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:04:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N2Vcf157520
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:04:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30sjjx4mvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:04:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044N4qLY014079
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:04:52 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:04:51 -0700
Subject: Re: [PATCH v9 18/24] xfs: Add helper function
 xfs_attr_node_removename_rmt
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-19-allison.henderson@oracle.com>
 <20200504190016.GE5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c43e8b04-72e4-eb9b-4941-5a617600ae16@oracle.com>
Date:   Mon, 4 May 2020 16:04:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504190016.GE5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 12:00 PM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:10PM -0700, Allison Collins wrote:
>> This patch adds another new helper function
>> xfs_attr_node_removename_rmt. This will also help modularize
>> xfs_attr_node_removename when we add delay ready attributes later.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 28 +++++++++++++++++++---------
>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index c8226c6..ab1c9fa 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1216,6 +1216,24 @@ int xfs_attr_node_removename_setup(
>>   	return 0;
>>   }
>>   
>> +STATIC int
>> +xfs_attr_node_removename_rmt (
> 
> xfs_attr_node_remove_rmt?
I believe this is a name Brian had asked for in a prior review, though I 
don't know how firmly set he is on it?

> 
> Otherwise looks ok,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Alrighty, thank you!

Allison

> 
> --D
> 
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
>> +	 * Refill the state structure with buffers, the prior calls released our
>> +	 * buffers.
>> +	 */
>> +	return xfs_attr_refillstate(state);
>> +}
>> +
>>   /*
>>    * Remove a name from a B-tree attribute list.
>>    *
>> @@ -1244,15 +1262,7 @@ xfs_attr_node_removename(
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
