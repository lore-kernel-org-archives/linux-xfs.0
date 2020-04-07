Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25335C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E88A520771
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PDef3hbA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgDGVxS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 17:53:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGVxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 17:53:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037Ln09A145007;
        Tue, 7 Apr 2020 21:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tHdWpM0T4AdWAkiFSNoN/h5xUKuw8tO0azYIUf2n38w=;
 b=PDef3hbAReLZdl1FmzNWNHt/6It6NBlzEBCu49JWnw7oDqnJxZzHN33BvHHLoUmHnNs9
 YvZXF94PEbNCdO4NfdDCu1XkrspkCqaZmyHLBqirAkpaGSarf3wgG+1tvQg4DkT1DSgz
 FFR6twT9n0g1MG772QfieYQ7gnLSIkfOfr9rCDXGK1ReF0chzx+u2fhIzPeuu7thU413
 oZTJ+3zT6M/GlDAJQ0rgLqo64KzRswy8FvqM3vLc+kRkXxDA9BeaaXcvOCIQQ92RN3KW
 ch9MQEkGnGWhcaN6a3TAvt/MO7x7VnGhGjfWbUUZtgAuWl6bXquYAfm8Lla4HkIEyZbA aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3091mng1pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:53:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037LlHeP168245;
        Tue, 7 Apr 2020 21:53:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091ky8ymp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:53:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037LrES3021012;
        Tue, 7 Apr 2020 21:53:14 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 14:53:14 -0700
Subject: Re: [PATCH v8 12/20] xfs: Removed unneeded xfs_trans_roll_inode calls
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-13-allison.henderson@oracle.com>
 <20200407141723.GC28936@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <416ff860-7c41-3e4c-3630-4610688f6da1@oracle.com>
Date:   Tue, 7 Apr 2020 14:53:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407141723.GC28936@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/7/20 7:17 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:21PM -0700, Allison Collins wrote:
>> Some calls to xfs_trans_roll_inode in the *_addname routines are not
>> needed. If they are the last operations executed in these functions, and
>> no further changes are made, then higher level routines will roll or
>> commit the tranactions. The xfs_trans_roll in _removename is also not
>> needed because invalidating blocks is not an incore change.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 30 ------------------------------
>>   1 file changed, 30 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 27a9bb5..4225a94 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -700,11 +700,6 @@ xfs_attr_leaf_addname(
>>   				return error;
>>   		}
>>   
>> -		/*
>> -		 * Commit the remove and start the next trans in series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -
> 
> Ok, so it looks like the only caller immediately rolls again.
> 
>>   	} else if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>> @@ -712,12 +707,6 @@ xfs_attr_leaf_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			return error;
>> -
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>   	}
> 
> Same logic applies here. Makes sense.
> 
>>   	return error;
>>   }
>> @@ -1069,13 +1058,6 @@ xfs_attr_node_addname(
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
>  From here, we log the inode and commit, so that seems safe.
> 
> BTW, doesn't that mean the defer_finish() just above (after the
> da3_join()) is unnecessary as well?
Hmm, I think you're right.  Will clean out here too.

> 
>>   	} else if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>> @@ -1083,14 +1065,6 @@ xfs_attr_node_addname(
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> -
>> -		 /*
>> -		  * Commit the flag value change and start the next trans in
>> -		  * series.
>> -		  */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>>   	}
>>   	retval = error = 0;
>>   
>> @@ -1189,10 +1163,6 @@ xfs_attr_node_removename(
>>   		if (error)
>>   			goto out;
>>   
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>> -
> 
> Hmm, not sure I follow this one. Don't we want to commit the incomplete
> flag before proceeding? Or are we just saying it can be combined with
> the first bunmap since that's going to roll anyways..?
> 
> BTW, the commit log refers to the invalidation as "not incore," which I
> think is opposite. :P xfs_attr_rmtval_invalidate() is incore-only in the
> sense that it doesn't seem to use the transaction. Is that what you
> mean?
Yes, sorry, the commit should say in-core only.  We pulled this one out 
in v5 for that reason.  It used to belong to the later "Add delay ready 
attr remove routines" patch in v6 and v7. Then when we decided to clean 
out these extra transaction rolls, because it simplifies the top level 
transaction rolling.  So I decided to do the removename clean out in 
this patch because it seemed appropriate.  In any case, will amend the 
commit message.  Discussion thread just for brain refresh:

https://lore.kernel.org/linux-xfs/27f6d1f2-8d7e-c759-31e1-6c4ac8c7ccad@oracle.com/

Thanks for the reviews!  Will update!

Allison


> 
> Brian
> 
>>   		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			goto out;
>> -- 
>> 2.7.4
>>
> 
