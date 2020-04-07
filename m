Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27228C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1B720748
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 21:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P4jpwzPE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGVzE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 17:55:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51946 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGVzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 17:55:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037LmGGH182734;
        Tue, 7 Apr 2020 21:55:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9rtjjTUKEAxGkE9w1oQDHCB1KFY/bwIGBzcNk66XQ6U=;
 b=P4jpwzPEOPJoNKVi1cGuEEe9xlMrzfwMOOv/F0PuHO8vOe+cuCLYwEbPyWOUYkPirTYQ
 cv5ZZpi95boqDUbyoV3ROygkWWi9P8N9PL7S+XzxliCOjYzgJGKJaYKQwPQRWb8yTvGs
 ZQJS9bfjR8ysicKcsgCOEv3Gcbju57ZRqkrUfnjndaPZpYZEiI/k7fO9Et95Jw4YF0xr
 w8/5Y8T3wH8lY8PGYwU7VUEdumu5hx0USUg+goONRi/CQXheE/Bj/U8oe8/Ptq1SvWyZ
 YrlwJVr2JnbMFZ1395spGC3V/HrYkoveNh+FFhf5llk8zGHe3T+9HTnF1XUO3rXyCjym rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3091m381y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:55:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037LmTPn094881;
        Tue, 7 Apr 2020 21:53:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3091mg8j68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 21:53:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 037LqxpH008499;
        Tue, 7 Apr 2020 21:52:59 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 14:52:59 -0700
Subject: Re: [PATCH v8 11/20] xfs: Add helper function xfs_attr_node_shrink
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-12-allison.henderson@oracle.com>
 <20200407141706.GB28936@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <b810a800-943f-9290-dfc9-2638c19f8165@oracle.com>
Date:   Tue, 7 Apr 2020 14:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200407141706.GB28936@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/7/20 7:17 AM, Brian Foster wrote:
> On Fri, Apr 03, 2020 at 03:12:20PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_shrink used to
>> shrink an attr name into an inode if it is small enough.  This helps to
>> modularize the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 67 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 42 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index db5a99c..27a9bb5 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -1197,31 +1235,10 @@ xfs_attr_node_removename(
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		/*
>> -		 * Have to get rid of the copy of this dabuf in the state.
>> -		 */
>> -		ASSERT(state->path.active == 1);
>> -		ASSERT(state->path.blk[0].bp);
>> -		state->path.blk[0].bp = NULL;
>> -
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> -		if (error)
>> -			goto out;
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		error = xfs_attr_node_shrink(args, state);
>>   
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>> -		} else
>> -			xfs_trans_brelse(args->trans, bp);
>> -	}
>>   	error = 0;
> 
> Looks like the error handling is busted here..? We used to goto out, now
> we always reset error to 0.
> 
> Brian
Ah, yes the error = 0; should have been removed along with the rest of 
it.  Will remove. Thanks!

Allison

> 
>> -
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> -- 
>> 2.7.4
>>
> 
