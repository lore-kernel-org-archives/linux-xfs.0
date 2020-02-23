Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFF2C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EDE9206E2
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 16:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EhZvHpEv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWQve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 11:51:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWQvd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 11:51:33 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NGmhOS148881;
        Sun, 23 Feb 2020 16:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JPGyY0swOuBDY4AsqXiZPFi4Bh2r+NRyAHPdDqQZAVw=;
 b=EhZvHpEvIa3YzX+w/8VuufAkfJGfjL8YdQEz24bSDVZKjZ9n8jn+IOCbgW/heXPG3zqh
 dTqe46Jy0KuHgSfhYfK7fwRudRutYnBxcWBCzlhSKLkDDyAiZKnjyBfsQvvbKjU/xpfz
 YudLDwSYkJJ747N5KLC2EQvRlUSnmSJQ9gDw4tV5IhQk1JDbtoDQ65s7GWyVEgYEm5hD
 zelXKQzkMNJcWnnWJjeQ7Ym+piOj6B3rUvK8uaFx6Pocow9NSXIB9/W5lY43XiY/XR+Q
 viS8wEBiYbKPDs/El03n4coen9qp0sOOpOp3kATenKZzHUijBKva0ZmuKPavF1Zw04Ju hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxrbr1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:51:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01NGmZhg085245;
        Sun, 23 Feb 2020 16:51:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ybdsej63k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 16:51:31 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01NGpUcZ024748;
        Sun, 23 Feb 2020 16:51:30 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 08:51:30 -0800
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0726eb62-c308-3c04-8e3b-ff1f6c76844a@oracle.com>
Date:   Sun, 23 Feb 2020 09:51:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjnByzxLUsF6GL7-fOeiNwQR46vgt5nSgfUNfB8jdfqMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9540 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/20 4:54 AM, Amir Goldstein wrote:
> On Sun, Feb 23, 2020 at 4:07 AM Allison Collins
> <allison.henderson@oracle.com> wrote:
>>
>> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
>> members.  This helps to clean up the xfs_da_args structure and make it more uniform
>> with the new xfs_name parameter being passed around.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        |  37 +++++++-------
>>   fs/xfs/libxfs/xfs_attr_leaf.c   | 104 +++++++++++++++++++++-------------------
>>   fs/xfs/libxfs/xfs_attr_remote.c |   2 +-
>>   fs/xfs/libxfs/xfs_da_btree.c    |   6 ++-
>>   fs/xfs/libxfs/xfs_da_btree.h    |   4 +-
>>   fs/xfs/libxfs/xfs_dir2.c        |  18 +++----
>>   fs/xfs/libxfs/xfs_dir2_block.c  |   6 +--
>>   fs/xfs/libxfs/xfs_dir2_leaf.c   |   6 +--
>>   fs/xfs/libxfs/xfs_dir2_node.c   |   8 ++--
>>   fs/xfs/libxfs/xfs_dir2_sf.c     |  30 ++++++------
>>   fs/xfs/scrub/attr.c             |  12 ++---
>>   fs/xfs/xfs_trace.h              |  20 ++++----
>>   12 files changed, 130 insertions(+), 123 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 6717f47..9acdb23 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -72,13 +72,12 @@ xfs_attr_args_init(
>>          args->geo = dp->i_mount->m_attr_geo;
>>          args->whichfork = XFS_ATTR_FORK;
>>          args->dp = dp;
>> -       args->flags = flags;
>> -       args->name = name->name;
>> -       args->namelen = name->len;
>> -       if (args->namelen >= MAXNAMELEN)
>> +       memcpy(&args->name, name, sizeof(struct xfs_name));
> 
> Maybe xfs_name_copy and xfs_name_equal are in order?
You are suggesting to add xfs_name_copy and xfs_name_equal helpers?  I'm 
not sure there's a use case yet for xfs_name_equal, at least not in this 
set.  And I think people indicated that they preferred the memcpy in 
past reviews rather than handling each member of the xfs_name struct. 
Unless I misunderstood the question, I'm not sure there is much left for 
a xfs_name_copy helper to cover that the memcpy does not?

> 
>>
>> +       /* Use name now stored in args */
>> +       name = &args.name;
>> +
> 
> It seem that the context of these comments be clear in the future.
You are asking to add more context to the comment?  How about:
	/*
	 * Use name now stored in args.  Abandon the local name 	
	 * parameter as it will not be updated in the subroutines
	 */

Does that help some?

> 
>>          args.value = value;
>>          args.valuelen = valuelen;
>>          args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
>> @@ -372,7 +374,7 @@ xfs_attr_set(
>>           */
>>          if (XFS_IFORK_Q(dp) == 0) {
>>                  int sf_size = sizeof(xfs_attr_sf_hdr_t) +
>> -                       XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
>> +                       XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
>>
>>                  error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
>>                  if (error)
>> @@ -457,6 +459,9 @@ xfs_attr_remove(
>>          if (error)
>>                  return error;
>>
>> +       /* Use name now stored in args */
>> +       name = &args.name;
>> +
>>          /*
>>           * we have no control over the attribute names that userspace passes us
>>           * to remove, so we have to allow the name lookup prior to attribute
>> @@ -532,10 +537,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>          trace_xfs_attr_sf_addname(args);
>>
>>          retval = xfs_attr_shortform_lookup(args);
>> -       if ((args->flags & ATTR_REPLACE) && (retval == -ENOATTR)) {
>> +       if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>>                  return retval;
>>          } else if (retval == -EEXIST) {
>> -               if (args->flags & ATTR_CREATE)
>> +               if (args->name.type & ATTR_CREATE)
>>                          return retval;
>>                  retval = xfs_attr_shortform_remove(args);
>>                  if (retval)
>> @@ -545,15 +550,15 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>                   * that the leaf format add routine won't trip over the attr
>>                   * not being around.
>>                   */
>> -               args->flags &= ~ATTR_REPLACE;
>> +               args->name.type &= ~ATTR_REPLACE;
> 
> 
> This doesn't look good it looks like a hack.
> 
> Even if want to avoid growing struct xfs_name we can store two shorts instead
> of overloading int type with flags.
> type doesn't even need more than a single byte, because XFS_DIR3_FT_WHT
> is not used and will never be used on-disk.
> 
> Thanks,
> Amir.
> 
The exact use of .type has gone around a few times since this patch 
started, which was actually all the way back in parent pointers.  :-) 
Initially the xfs_name struct replaced anything that passed all three 
parameters, and then later we decided that flags should stay separate 
for top level get/set/remove routines, but become integrated below the 
*_args routines.  I don't recall people being concerned about growing 
the struct, though a union seems reasonable to resolve the naming 
weirdness.  I would like to have a little more feedback from folks 
though just to make sure everyones in agreement since this one's gone 
through quite few reviews already. Thanks all!

Allison
