Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442C5C35679
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147DE2072D
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 07:37:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="umeMB2Jc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgBXHhD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 02:37:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35456 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgBXHhD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 02:37:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01O7XD51055006;
        Mon, 24 Feb 2020 07:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/IYHveXJXlT3eGsm6He594YhbZ/7WVL5rySn5t1MyOU=;
 b=umeMB2JcRhWLSFz+5wWZORol41kY0JvXSvLSX4BvGhuCExiY+RlGEyAsN0SoPs5erqiG
 4s5vUnwWGEJ2vuSglrBNSQuFSNUsjZzNOOyiqFmXUWLniK3jJxsqKrGLh32OiFzELg5G
 hjQ5lYULYXBJ3vUtke5oVwULOlswDEtK2EQ+uoaGqjkN0pYEj62unMxShENidtKu8wjV
 dOk3wrULoeM+R0PR5Mz5lg+WECZbZ7u/qTYZmQGQERsdgsBI671lurAuqRQdNUFwSwzX
 Mr4LA4pvGeeMLbcDB0dfErorxZyAiSY4PmdJpBtkTri2g/A9kMxJR2MVvUR2LunkCLmd vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yauqu5fvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 07:37:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01O7RxA5053049;
        Mon, 24 Feb 2020 07:37:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ybe10kbus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 07:37:00 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01O7axbK006395;
        Mon, 24 Feb 2020 07:37:00 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 23:36:59 -0800
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
 <0726eb62-c308-3c04-8e3b-ff1f6c76844a@oracle.com>
 <CAOQ4uxiDcaApzkrdL9NVGSgM35K8tc-ny-rta7tYJiQPiL_Dzg@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <1bc9a981-8694-ebce-8243-8d79d7c3ba7f@oracle.com>
Date:   Mon, 24 Feb 2020 00:36:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiDcaApzkrdL9NVGSgM35K8tc-ny-rta7tYJiQPiL_Dzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 11:50 PM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 6:51 PM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>>
>>
>> On 2/23/20 4:54 AM, Amir Goldstein wrote:
>>> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
>>> <allison.henderson@oracle.com> wrote:
>>>>
>>>> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
>>>> members.  This helps to clean up the xfs_da_args structure and make it more uniform
>>>> with the new xfs_name parameter being passed around.
>>>>
>>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
>>>>    fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>>>>    fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
>>>>    fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>>>>    fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>>>>    fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>>>>    fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>>>>    fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
>>>>    fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>>>>    fs/xfs/scrub/attr.c             |  12 ++---
>>>>    fs/xfs/xfs_trace.h              |  20 ++++----
>>>>    12 files changed, 130 insertions(+), 123 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 6717f47..9acdb23 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>>>>           args->geo = dp->i_mount->m_attr_geo;
>>>>           args->whichfork = XFS_ATTR_FORK;
>>>>           args->dp = dp;
>>>> -       args->flags = flags;
>>>> -       args->name = name->name;
>>>> -       args->namelen = name->len;
>>>> -       if (args->namelen >= MAXNAMELEN)
>>>> +       memcpy(&args->name, name, sizeof(struct xfs_name));
>>>
>>> Maybe xfs_name_copy and xfs_name_equal are in order?
>> You are suggesting to add xfs_name_copy and xfs_name_equal helpers?  I'm
>> not sure there's a use case yet for xfs_name_equal, at least not in this
>> set.  And I think people indicated that they preferred the memcpy in
>> past reviews rather than handling each member of the xfs_name struct.
>> Unless I misunderstood the question, I'm not sure there is much left for
>> a xfs_name_copy helper to cover that the memcpy does not?
>>
> 
> It's fine. The choice between xfs_name_copy and memcpy is
> mostly personal taste. I did not read through past reviews.
> 
>>>
>>>>
>>>> +       /* Use name now stored in args */
>>>> +       name = &args.name;
>>>> +
>>>
>>> It seem that the context of these comments be clear in the future.
>> You are asking to add more context to the comment?  How about:
>>          /*
>>           * Use name now stored in args.  Abandon the local name
>>           * parameter as it will not be updated in the subroutines
>>           */
>>
>> Does that help some?
> 
> Can't you just not use local name arg anymore?
> Instead of re-assigning it and explaining why you do that.
> Does that gain anything to code readability or anything else?
Well, with out the set, you cannot use for example name->type anymore, 
you need to use args->name->type.  In order to use the local name 
variable again, it needs to be updated.  I stumbled across this myself 
when working with it and thought it would be better to fix it right away 
rather than let others run across the same mistake.  It seems like a 
subtle and easy thing to overlook otherwise.

I do think it's a bit of a wart that people may not have thought about 
when we talked about adding this patch.  Though I don't know that it's a 
big enough deal to drop it either.  But I did feel some motivation to at 
least clean it up and make a comment about it.

Allison

> 
> Thanks,
> Amir.
> 
