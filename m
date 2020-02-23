Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23976C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2385206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:41:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rShry86R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWSlV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:41:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:48626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 13:41:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIdHMu159474;
        Sun, 23 Feb 2020 18:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eV9mbBTtC6j5IhQpGUHnciDOHLat4gHsUOgitY+FcIA=;
 b=rShry86RwDCmkyODWae0QBjG1b0J8Nmw/Uk3E26BRW/uLDPgOFM3bs0ZEuWQLgHkkK4l
 vR2UeQeWGHug77Zf1dJLDsS+8tSRG+yjR4Q0CxI0q+SmnSeHtAOJrSJXKqq36AhrsKKs
 NdkQ/pfyT5t2+JvroDMd5mm9MxRptxhwhMxvXdmYPq2nZF+ZAhoC5KsKxMMPKvCVWlBk
 OI5B3fgzqSs2YAY4Mstt6lJm52bz4kXbT6erxgT8CREz+VtaoTA00dHZAyWNG3GzmBXQ
 nt2RFpS+tOvjlZOZ8xEfL8dlmssYCHqJnC6srWd8z6a7mrxvjbRY6CgKln5HrRNruq32 TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yavxrbvh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:41:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIaQga083865;
        Sun, 23 Feb 2020 18:41:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybdusqrqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:41:17 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NIfHjc024410;
        Sun, 23 Feb 2020 18:41:17 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 10:41:17 -0800
Subject: Re: [PATCH v7 15/19] xfs: Add helper function xfs_attr_node_shrink
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-16-allison.henderson@oracle.com>
 <CAOQ4uxhyhoKwBejwi96BM1EWgsFC7918S_ydY4c9MFEmML7iKQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <3edf076e-83ee-54aa-4d15-6aa095908745@oracle.com>
Date:   Sun, 23 Feb 2020 11:41:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhyhoKwBejwi96BM1EWgsFC7918S_ydY4c9MFEmML7iKQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/23/20 6:22 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> This patch adds a new helper function xfs_attr_node_shrink used to shrink an
>> attr name into an inode if it is small enough.  This helps to modularize
>> the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 66 +++++++++++++++++++++++++++++-------------------
>>   1 file changed, 40 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4b788f2..30a16fe 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1366,6 +1366,43 @@ xfs_attr_node_addname(
>>   }
>>
>>   /*
>> + * Shrink an attribute from leaf to shortform
>> + */
>> +STATIC int
>> +xfs_attr_node_shrink(
>> +       struct xfs_da_args      *args,
>> +       struct xfs_da_state     *state)
>> +{
>> +       struct xfs_inode        *dp = args->dp;
>> +       int                     error, forkoff;
>> +       struct xfs_buf          *bp;
>> +
>> +       /*
>> +        * Have to get rid of the copy of this dabuf in the state.
>> +        */
>> +       ASSERT(state->path.active == 1);
>> +       ASSERT(state->path.blk[0].bp);
>> +       state->path.blk[0].bp = NULL;
>> +
>> +       error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> +       if (error)
>> +               return error;
>> +
>> +       forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +       if (forkoff) {
>> +               error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +               /* bp is gone due to xfs_da_shrink_inode */
>> +               if (error)
>> +                       return error;
>> +
>> +               args->dac.flags |= XFS_DAC_FINISH_TRANS;
> 
> Why did xfs_defer_finish(&args->trans); turn into the above?
> 
> Are you testing reviewers alertness? ;-)
> Please keep logic preserving patches separate from logic change patches.
You're right, I missed this when I was separating it from the previous 
patch.  Will correct.  Thanks for the catch!

Allison

> 
> Thanks,
> Amir.
> 
>> +       } else
>> +               xfs_trans_brelse(args->trans, bp);
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>>    * Remove a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>> @@ -1383,8 +1420,7 @@ xfs_attr_node_removename(
>>   {
>>          struct xfs_da_state     *state;
>>          struct xfs_da_state_blk *blk;
>> -       struct xfs_buf          *bp;
>> -       int                     retval, error, forkoff;
>> +       int                     retval, error;
>>          struct xfs_inode        *dp = args->dp;
>>
>>          trace_xfs_attr_node_removename(args);
>> @@ -1493,30 +1529,8 @@ xfs_attr_node_removename(
>>          /*
>>           * If the result is small enough, push it all into the inode.
>>           */
>> -       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -               /*
>> -                * Have to get rid of the copy of this dabuf in the state.
>> -                */
>> -               ASSERT(state->path.active == 1);
>> -               ASSERT(state->path.blk[0].bp);
>> -               state->path.blk[0].bp = NULL;
>> -
>> -               error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>> -               if (error)
>> -                       goto out;
>> -
>> -               if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -                       /* bp is gone due to xfs_da_shrink_inode */
>> -                       if (error)
>> -                               goto out;
>> -                       error = xfs_defer_finish(&args->trans);
>> -                       if (error)
>> -                               goto out;
>> -               } else
>> -                       xfs_trans_brelse(args->trans, bp);
>> -       }
>> -       error = 0;
>> +       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +               error = xfs_attr_node_shrink(args, state);
>>
>>   out:
>>          if (state)
>> --
>> 2.7.4
>>
