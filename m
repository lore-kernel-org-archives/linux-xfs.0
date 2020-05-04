Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6996EC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E06320707
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 22:15:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pYnpni6W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgEDWPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 18:15:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgEDWPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 18:15:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MDXJg091420;
        Mon, 4 May 2020 22:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ICGqzM6IY4ckXF8aTVOGCTwr5lCx8i6QU5OhCrO6ulU=;
 b=pYnpni6WAjrX2l62x5sBUpexSRs81FdBv+h3fP6bFtwAGpj5OOLrzYblL/4QomsZOoOf
 ELnDq09OxTg2G9uia4k1jeEuMCyg1WLuxMLj/fVZ4q2KsxZY3s+zeYqO+9gQa8/GBMsJ
 SJ5fsqBfMH2Dmc70o6SWcdHbix3CMxhNB8bjyu7jfKBX665NqPxVgwgC1Kszk+iwZxnW
 MByrl2k+s1rva4XHkjI5n3sCECx3q0rsUMJo/2trUxWiMh01FurbtlcTJPmCBlsEb2so
 AQ+InAyWHZiKvzNz66nQOmY4+TTwUZe6PV/VDRa9DqjLvDRqqp2QkEFypSIlF8P1Bdb6 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r1nhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 22:15:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044MDMaE033113;
        Mon, 4 May 2020 22:15:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30sjnc61bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 22:15:27 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044MFQ8A014291;
        Mon, 4 May 2020 22:15:26 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 15:15:26 -0700
Subject: Re: [PATCH v9 13/24] xfs: Remove unneeded xfs_trans_roll_inode calls
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-14-allison.henderson@oracle.com>
 <20200504133022.GD54625@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <6fb30f03-3c21-90c4-369b-09a83ca88e05@oracle.com>
Date:   Mon, 4 May 2020 15:15:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504133022.GD54625@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 6:30 AM, Brian Foster wrote:
> On Thu, Apr 30, 2020 at 03:50:05PM -0700, Allison Collins wrote:
>> Some calls to xfs_trans_roll_inode and xfs_defer_finish routines are not
>> needed. If they are the last operations executed in these functions, and
>> no further changes are made, then higher level routines will roll or
>> commit the tranactions. The xfs_trans_roll in _removename is also not
>> needed because invalidating blocks is an incore-only change.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 40 ----------------------------------------
>>   1 file changed, 40 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index d83443c..af47566 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -784,9 +770,6 @@ xfs_attr_leaf_removename(
>>   		/* bp is gone due to xfs_da_shrink_inode */
>>   		if (error)
>>   			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>>   	}
>>   	return 0;
> 
> Looks like this could be simplified to return error at the end of the
> function. Some of the others might have similar simplifications
> available.
Sure, will do
> 
>>   }
>> @@ -1074,13 +1057,6 @@ xfs_attr_node_addname(
>>   				goto out;
>>   		}
>>   
>> -		/*
>> -		 * Commit and start the next trans in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -
> 
> There's an xfs_defer_finish() before this roll. Is that not also
> extraneous? It looks like we return straight up to xfs_attr_set() (trans
> commit) from here..
Ok, I see it.  Yes I think so, I will see if I can take it out

> 
>>   	} else if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
> ...
>> @@ -1194,10 +1158,6 @@ xfs_attr_node_removename(
>>   		if (error)
>>   			goto out;
>>   
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>> -
> 
> I'm still a bit on the fence about this one. At first glance it looks
> like it's not necessary, but technically we're changing behavior by
> combining setting the inactive flag and the first remote block unmap,
> right? If so, that seems fairly reasonable, but it's hard to say for
> sure with the state of the xattr transaction reservations...
> 
As I recall, I had initially not removed this roll in v5, and I had an 
extra XFS_DAS_RM_INVALIDATE state to roll the transaction here.  And 
then I think we reasoned that because invalidating blocks didnt have in 
core changes, we could just remove it, thus getting rid of the extra 
state.  Later I split it out into this separate patch along with a few 
other transaction rolls that we identified as not being necessary.

link just for reference...
https://patchwork.kernel.org/patch/11287029/


> Looking around some more, I suppose this could be analogous to the
> !remote remove case where an entry is removed and a potential dabtree
> join occurs under the same transaction. If that's the best argument we
> have, however, I might suggest to split this one out into an independent
> patch and let the commit log describe what's going on in more detail.
> That way it's more obvious to reviewers and if it's wrong it's easier to
> revert.
I'm not sure that was the argument at the time, but I think it makes 
sense. :-)  Will split off into separate patch.

Thanks for the reviews!

Allison

> 
> Brian



> 
>>   		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			return error;
>> -- 
>> 2.7.4
>>
> 
