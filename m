Return-Path: <SRS0=b7mv=XQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5F4C49ED7
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20D2A2080F
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Sep 2019 07:02:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hC69pjzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437194AbfIUHCo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Sep 2019 03:02:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437193AbfIUHCo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Sep 2019 03:02:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L6wqup105259;
        Sat, 21 Sep 2019 07:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nxbpnkf/xGwnKoXMB7N88oKVqLwW0WoviZFLt6Wv5ZY=;
 b=hC69pjzS6EWSzOu7IcY2EQeyWklzesFqvTn+gFjWPkalvxmqh+BnT9HXAxuAndVJm1g3
 K2kpp3Bd6WAGeXpByeYje7XF1reyNK08NCkrZabBuR1DV0uGWY4dhIG15KLwYosF4Bnv
 z2ZAUpxJHNjVm+RWLTB1RZlq53jEQ/UY9/da4+6LZ973zEYnCmCB9OWinIABlVOYUzG/
 hc1ES5enpnVWRFE3A2FBQEyAt/DR2QG8+ig81w25GG4L0oxveNqJo8TTomZNOuFUadTp
 mA8GKgU9qjK68JwO3U9U0TNw8VAc2OObwVGBwATF/7ICEKWkyuNt+5ZahJqW8rdFy/cL iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btpg9h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:02:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8L6x9wU195486;
        Sat, 21 Sep 2019 07:00:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v590ee38g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Sep 2019 07:00:32 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8L70VZw011382;
        Sat, 21 Sep 2019 07:00:31 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 21 Sep 2019 07:00:31 +0000
Subject: Re: [PATCH v3 06/19] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-7-allison.henderson@oracle.com>
 <20190920134941.GD40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6451a6f1-7171-7650-22b9-2e07a3e1fcf5@oracle.com>
Date:   Sat, 21 Sep 2019 00:00:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920134941.GD40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909210077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909210077
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/20/19 6:49 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:24PM -0700, Allison Collins wrote:
>> Since delayed operations cannot roll transactions, factor
>> up the transaction handling into the calling function
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thank you!!

Allison
> 
>>   fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
>>   2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index a297857..7a6dd37 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -710,6 +710,13 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_flipflags(args);
>>   		if (error)
>>   			return error;
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			return error;
>>   
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing
>> @@ -1046,6 +1053,13 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_flipflags(args);
>>   		if (error)
>>   			goto out;
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			goto out;
>>   
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index a501538..3903e5c 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2919,10 +2919,5 @@ xfs_attr3_leaf_flipflags(
>>   			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -
>>   	return error;
>>   }
>> -- 
>> 2.7.4
>>
