Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3771AC3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09CF1217F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 22:49:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kj7v75bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393910AbfITWtg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 18:49:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfITWtf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 18:49:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMmvh6017443;
        Fri, 20 Sep 2019 22:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RUbMdxSdfoK8SR7CHEDwceXgzlsHQbF/hpvlclGIdGM=;
 b=kj7v75bFhdYSrrt1OD+i0ycXv43OPr3YQGXljIdpKDZm5doYRqNoCrNgBgoIn2d1ERkA
 +2v/8HIXeXS4U3qlUCheGd9foKIFNj/eHdz6rRdqn3QnANIAKqXa7C8x2KqcquAWZ7Ip
 sKCQvKYvGjKhHO/AfVykTzyBPaSHEBKVKY2QIydWXqLeG40HRtrEwLFS5MhyIhTDeIss
 /awUw+ywstOjdUAiblrxrqsg5vlp4Iet8X7LbZLvrEqx/j/+CXuNuVEPGzRSRT0qVAM8
 I6Dw7CAn9Df6dUljJZEERqwxAp2jf5vCtqI2tDKSH/aRKl3/qe1j2a/Vxyj2L6PFdQLW /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v3vb4vxrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:49:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8KMn0JK009698;
        Fri, 20 Sep 2019 22:49:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v51vr0801-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 22:49:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8KMnRGo005201;
        Fri, 20 Sep 2019 22:49:27 GMT
Received: from [192.168.1.9] (/67.1.21.243)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 20 Sep 2019 15:49:27 -0700
Subject: Re: [PATCH v3 12/19] xfs: Factor up trans roll in
 xfs_attr3_leaf_clearflag
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190905221837.17388-1-allison.henderson@oracle.com>
 <20190905221837.17388-13-allison.henderson@oracle.com>
 <20190920135129.GJ40150@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c49da92b-5e81-7fff-28ad-f73dc2975dd7@oracle.com>
Date:   Fri, 20 Sep 2019 15:49:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920135129.GJ40150@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909200189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9386 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909200189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/20/19 6:51 AM, Brian Foster wrote:
> On Thu, Sep 05, 2019 at 03:18:30PM -0700, Allison Collins wrote:
>> New delayed allocation routines cannot be handling
>> transactions so factor them up into the calling functions
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 14 ++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  5 +----
>>   2 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 5e5b688..781dd8a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -783,6 +783,12 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
> 
Alrighty, will fix.
Allison

> Need an error check here now that this isn't the last call in the
> function before we return.
> 
> Brian
> 
>> +
>> +		/*
>> +		 * Commit the flag value change and start the next trans in
>> +		 * series.
>> +		 */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
>>   	return error;
>>   }
>> @@ -1140,6 +1146,14 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> +
>> +		 /*
>> +		  * Commit the flag value change and start the next trans in
>> +		  * series.
>> +		  */
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		if (error)
>> +			goto out;
>>   	}
>>   	retval = error = 0;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 79650c9..786b851 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -2750,10 +2750,7 @@ xfs_attr3_leaf_clearflag(
>>   			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>>   	}
>>   
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series.
>> -	 */
>> -	return xfs_trans_roll_inode(&args->trans, args->dp);
>> +	return error;
>>   }
>>   
>>   /*
>> -- 
>> 2.7.4
>>
