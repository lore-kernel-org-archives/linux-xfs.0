Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD22C35DF2
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1E9822464
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 04:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tGrEoJEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgBYEWD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 23:22:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgBYEWD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 23:22:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4JIbW187219;
        Tue, 25 Feb 2020 04:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X6m+xZLB8A2IHLJmDeKFy/E3WqYocqdWbM4G6bul4+w=;
 b=tGrEoJEUXxbQ9CCzb/g9CBwDML0gBmOOk3WB0cy5QuCS2GFrZKrkycSsmA2sPnj2Xhgo
 mVprRSs1X5QKuR2TLlTni9NLi4dm8ICOFLQOU4arTiPa2mWZDsyaWwruci7Rple/Abzy
 kuXsunEZ54PXHbYuQnq0j+SKnsiT7g0cdiJh6bYls08AFjggSCw6cycYTAG8haG9bRa2
 fzYfKlJT8S+1B1FQDUnLPhljdS/Q3easdYpR6DbuuBpgWJt2E9uj0esoVW4UmF+/rS3A
 qkS53uTyGII2vn+BLmm8Rz/3mFqFPO5XhOA5CQl4BdnGnrS/j2JD778wA6YtKO3+Ya1t aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ycppr971d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:22:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P4I7ie098822;
        Tue, 25 Feb 2020 04:20:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ybe12u0u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 04:19:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P4JxSK015279;
        Tue, 25 Feb 2020 04:19:59 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 20:19:59 -0800
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <20200225005718.GC10776@dread.disaster.area>
 <5de019d4-d19f-315d-0299-3926c49cf150@oracle.com>
 <20200225040652.GD10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d3fdea13-ff1d-ed69-8005-60193c2d2e53@oracle.com>
Date:   Mon, 24 Feb 2020 21:19:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225040652.GD10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 9:06 PM, Dave Chinner wrote:
> On Mon, Feb 24, 2020 at 07:00:35PM -0700, Allison Collins wrote:
>>
>>
>> On 2/24/20 5:57 PM, Dave Chinner wrote:
>>> On Sat, Feb 22, 2020 at 07:05:54PM -0700, Allison Collins wrote:
>>>> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
>>>> members.  This helps to clean up the xfs_da_args structure and make it more uniform
>>>> with the new xfs_name parameter being passed around.
>>>
>>> Commit message should wrap at 68-72 columns.
>>>
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
>>>>    	args->geo = dp->i_mount->m_attr_geo;
>>>>    	args->whichfork = XFS_ATTR_FORK;
>>>>    	args->dp = dp;
>>>> -	args->flags = flags;
>>>> -	args->name = name->name;
>>>> -	args->namelen = name->len;
>>>> -	if (args->namelen >= MAXNAMELEN)
>>>> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>>>> +	args->name.type = flags;
>>>
>>> This doesn't play well with Christoph's cleanup series which fixes
>>> up all the confusion with internal versus API flags. I guess the
>>> namespace is part of the attribute name, but I think this would be a
>>> much clearer conversion when placed on top of the way Christoph
>>> cleaned all this up...
>>>
>>> Have you looked at rebasing this on top of that cleanup series?
>>>
>>> Cheers,
>>>
>> Yes, there is some conflict between the sets here and there, but I think
>> folks wanted to keep them separate for now.
> 
> That makes it really hard to form a clear view of what the code
> looks like after both patchsets have been applied. :(
> 
>> Are you referring to
>> "[780d29057781] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag"?  I'm
>> pretty sure this set is already seated on top of that one.  This one is
>> based on the latest for-next.
> 
> No, I'm talking about the series that ends up undoing that commit
> (i.e. the DA_OP_INCOMPLETE flag goes away again) and turns
> args->flags into args->attr_filter as the namespace filter for
> lookups. THis also turn adds XFS_ATTR_INCOMPLETE into a lookup
> filter.
> 
> With this separation of ops vs lookup filters, moving the lookup
> filter into the xfs_name makes a bit more sense (i.e. the namespace
> filter is passed with the attribute name), but as a standalone
> movement it creates a bit of an impedence mismatch between the xname
> and the use of these flags.
> 
> I think the end result will be fine, but it's making it hard for me
> to reconcile the changes in the two patchsets...
> 
> Cheers,

I'd be happy to go through the sets and find the intersections. Or make 
a big super set if you like.  I got the impression though that Christoph 
didnt particularly like the delayed attr series or the idea of blending 
them.  But I do think it would be a good idea to take into consideration 
what the combination of them is going to look like.

Allison

> 
> Dave.
> 


