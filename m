Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE1AC35666
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B28320880
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 18:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yBg/toIu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWSmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:42:10 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49590 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 13:42:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIfxjr041493;
        Sun, 23 Feb 2020 18:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AdmAwbTNvOfLJYmTpXaQysUAry3TLZI9MfCXXajsKvw=;
 b=yBg/toIuFP/cz1iijbloAnjkzSgPYgBao9LN/bbs6uN7kqrJvWwSVrStEw1NYxUVYGar
 0bMN7mL5pqCNcXAWv6x+UHjWAhrkPsxo34tjImEKbA/av9l27MHsOnEn8qmDhGh6VGYv
 rVP9ijKaqT1c+Vop2qq4noqsvrRcirrqxSilzsT6Fa6bI/q27ELRrFCOdZBoU7iKKoo0
 qwS/2+UfNqxYNmS3zU+kcPns3s7U+4FWFb1fyA2K66xKWK9PCuImvLcyI3HvC4F1HRr5
 bRbSHqATGjt4BqbeADs2vtUrUDL/tKb+WDl/n819oIDm1OjfY3I+cCr9P2URtb+U4rg0 9w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrbvj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:42:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NIg8Uk086142;
        Sun, 23 Feb 2020 18:42:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdser1qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 18:42:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01NIg74M020130;
        Sun, 23 Feb 2020 18:42:07 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 10:42:07 -0800
Subject: Re: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-17-allison.henderson@oracle.com>
 <CAOQ4uxhyz28N18tHUQpX_-RkYKip4go5MsuHmc5FJXxBZDM4nQ@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1e91f7fb-8bd8-2cef-fdbe-b750ab624109@oracle.com>
Date:   Sun, 23 Feb 2020 11:42:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhyz28N18tHUQpX_-RkYKip4go5MsuHmc5FJXxBZDM4nQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230155
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



On 2/23/20 6:26 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> Delayed attribute mechanics make frequent use of goto statements.  We can use this
>> to further simplify xfs_attr_set_iter.  Because states tend to fall between if
>> conditions, we can invert the if logic and jump to the goto. This helps to reduce
>> indentation and simplify things.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Looks better IMO and doesn't change logic.
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Alrighty, thanks!

Allison

> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
>>   1 file changed, 42 insertions(+), 29 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 30a16fe..dd935ff 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
>>   }
>>
>>   /*
>> + * Check to see if the attr should be upgraded from non-existent or shortform to
>> + * single-leaf-block attribute list.
>> + */
>> +static inline bool
>> +xfs_attr_fmt_needs_update(
>> +       struct xfs_inode    *dp)
>> +{
>> +       return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +             (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +             dp->i_d.di_anextents == 0);
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -342,40 +355,40 @@ xfs_attr_set_iter(
>>          }
>>
>>          /*
>> -        * If the attribute list is non-existent or a shortform list,
>> -        * upgrade it to a single-leaf-block attribute list.
>> +        * If the attribute list is already in leaf format, jump straight to
>> +        * leaf handling.  Otherwise, try to add the attribute to the shortform
>> +        * list; if there's no room then convert the list to leaf format and try
>> +        * again.
>>           */
>> -       if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> -           (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> -            dp->i_d.di_anextents == 0)) {
>> +       if (!xfs_attr_fmt_needs_update(dp))
>> +               goto add_leaf;
>>
>> -               /*
>> -                * Try to add the attr to the attribute list in the inode.
>> -                */
>> -               error = xfs_attr_try_sf_addname(dp, args);
>> +       /*
>> +        * Try to add the attr to the attribute list in the inode.
>> +        */
>> +       error = xfs_attr_try_sf_addname(dp, args);
>>
>> -               /* Should only be 0, -EEXIST or ENOSPC */
>> -               if (error != -ENOSPC)
>> -                       return error;
>> +       /* Should only be 0, -EEXIST or ENOSPC */
>> +       if (error != -ENOSPC)
>> +               return error;
>>
>> -               /*
>> -                * It won't fit in the shortform, transform to a leaf block.
>> -                * GROT: another possible req'mt for a double-split btree op.
>> -                */
>> -               error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> -               if (error)
>> -                       return error;
>> +       /*
>> +        * It won't fit in the shortform, transform to a leaf block.
>> +        * GROT: another possible req'mt for a double-split btree op.
>> +        */
>> +       error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>> +       if (error)
>> +               return error;
>>
>> -               /*
>> -                * Prevent the leaf buffer from being unlocked so that a
>> -                * concurrent AIL push cannot grab the half-baked leaf
>> -                * buffer and run into problems with the write verifier.
>> -                */
>> -               xfs_trans_bhold(args->trans, *leaf_bp);
>> -               args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> -               args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> -               return -EAGAIN;
>> -       }
>> +       /*
>> +        * Prevent the leaf buffer from being unlocked so that a
>> +        * concurrent AIL push cannot grab the half-baked leaf
>> +        * buffer and run into problems with the write verifier.
>> +        */
>> +       xfs_trans_bhold(args->trans, *leaf_bp);
>> +       args->dac.flags |= XFS_DAC_FINISH_TRANS;
>> +       args->dac.dela_state = XFS_DAS_ADD_LEAF;
>> +       return -EAGAIN;
>>
>>   add_leaf:
>>
>> --
>> 2.7.4
>>
