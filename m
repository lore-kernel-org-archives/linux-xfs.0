Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46160C35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 137D0206ED
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 17:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R6G9euXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgBWR25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:28:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56310 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgBWR25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 12:28:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHStG3172073;
        Sun, 23 Feb 2020 17:28:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iKMHiHlqbuAayDW/BeGTOljGXne2WrAAwrVZ4htj74A=;
 b=R6G9euXo/KmaDSyf+m/1hAvOdisfiixnMh3tjBXX/Yn14a0uxpvs8gIrZ8rOdENecaxP
 FRM4ACOdHkzczw4xYulYyVuAoFTHS5yn65vWaM0soMx6YiYWb1PcJWzi1yEiR+br1Bc1
 XZuH1oATaDAvv1QM0KRIW60vm/SOgvq2oyBpENXrsSgaCdRs9g6NSmKvVJIK/4TYo/56
 UWLZ1uvNkYKr/VgTtl+Nu3HNNyKY9BwFN+4LVN/TpY8evIp5wjeBHikdfGYVGlwtuqrt
 pm1GrdeoAvQh7OqsVh8X5jbdUDUZWdaiBgm7ksUGiE85Bo/ND6l0O3gjnytNP6YGx0/s Uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ybvr4g3ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:28:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NHSsim060558;
        Sun, 23 Feb 2020 17:28:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ybdsem50p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 17:28:54 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NHSsZd008676;
        Sun, 23 Feb 2020 17:28:54 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 09:28:53 -0800
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
 <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2694f05a-3f13-2b13-547d-21b303d4e67f@oracle.com>
Date:   Sun, 23 Feb 2020 10:28:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiUVy3OfFsqx_KyirE6pD0XvnzNEehn7Vv4cxXw8kTSjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 5:20 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of an attribute.
>> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
>> Common code that appears in existing attr add and remove functions have been
>> factored out to help reduce the appearance of duplicated code.  We will need these
>> routines later for delayed attributes since delayed operations cannot return error
>> codes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>>   4 files changed, 188 insertions(+), 98 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9acdb23..2255060 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>
>>   /*
>>    * Internal routines when attribute list is more than one block.
>> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>> +                                struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>
>> @@ -310,6 +313,37 @@ xfs_attr_set_args(
>>   }
>>
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
> 
> This is a very silly return value for a function named has_attr in my taste.
> I realize you inherited this interface from xfs_attr3_leaf_lookup_int(), but
> IMO this change looks like a very good opportunity to change that internal
> API:
> 
> xfs_has_attr?
> 
> 0: NO
> 1: YES (or stay with the syscall standard of -ENOATTR)
> <0: error
Darrick had mentioned something like that in the last revision, but I 
think people wanted to keep everything a straight hoist at this phase. 
At least as much as possible.  Maybe I can add another patch that does 
this at the end when we're doing clean ups.

Allison

> 
>> + */
>> +int
>> +xfs_has_attr(
>> +       struct xfs_da_args      *args)
>> +{
>> +       struct xfs_inode        *dp = args->dp;
>> +       struct xfs_buf          *bp = NULL;
>> +       int                     error;
>> +
>> +       if (!xfs_inode_hasattr(dp))
>> +               return -ENOATTR;
>> +
>> +       if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +               ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +               return xfs_attr_sf_findname(args, NULL, NULL);
>> +       }
>> +
>> +       if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +               error = xfs_attr_leaf_hasname(args, &bp);
>> +
>> +               if (bp)
>> +                       xfs_trans_brelse(args->trans, bp);
>> +
>> +               return error;
>> +       }
>> +
>> +       return xfs_attr_node_hasname(args, NULL);
>> +}
>> +
>> +/*
>>    * Remove the attribute specified in @args.
>>    */
>>   int
>> @@ -583,26 +617,20 @@ STATIC int
>>   xfs_attr_leaf_addname(
>>          struct xfs_da_args      *args)
>>   {
>> -       struct xfs_inode        *dp;
>>          struct xfs_buf          *bp;
>>          int                     retval, error, forkoff;
>> +       struct xfs_inode        *dp = args->dp;
>>
>>          trace_xfs_attr_leaf_addname(args);
>>
>>          /*
>> -        * Read the (only) block in the attribute list in.
>> -        */
>> -       dp = args->dp;
>> -       args->blkno = 0;
>> -       error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -       if (error)
>> -               return error;
>> -
>> -       /*
>>           * Look up the given attribute in the leaf block.  Figure out if
>>           * the given flags produce an error or call for an atomic rename.
>>           */
>> -       retval = xfs_attr3_leaf_lookup_int(bp, args);
>> +       retval = xfs_attr_leaf_hasname(args, &bp);
>> +       if (retval != -ENOATTR && retval != -EEXIST)
>> +               return retval;
>> +
>>          if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> 
> Example of how sane code (in my taste) would look like:
> 
>         retval = xfs_attr_leaf_hasname(args, &bp);
>         if (retval < 0)
>                 return retval;
> 
>          if ((args->name.type & ATTR_REPLACE) && !retval) {
>                   xfs_trans_brelse(args->trans, bp);
>                   return -ENOATTR;
>          } else if (retval) {
>                  if (args->flags & ATTR_CREATE) {        /* pure create op */
>                          xfs_trans_brelse(args->trans, bp);
>                          return -EEXIST;
>                 }
> 
> Thanks,
> Amir.
> 
