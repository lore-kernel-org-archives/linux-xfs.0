Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1084C35DEA
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 02:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A86218AC
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 02:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XuOMzP8o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBYCCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 21:02:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbgBYCCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 21:02:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P22Ad4184911;
        Tue, 25 Feb 2020 02:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=M9ox+p1Lc7RUC5CWYRfcjRZmCwlaZt5rX+RZUimErUI=;
 b=XuOMzP8oAHfUinu8dwM7UxT90vEkJNbo7ffG1P18+MNJ6r6Hhyvd3sE5M+IIlgvQgmP3
 vTz8+IowqW7PnNM5TQzomVctiXjmgh55eO6pJ60QRkFCoREnq2bLuHxyjobD1kMNSlYD
 vKz8W8Cg1BDQgUtSzsuX1M8cAUF3WV/FwHhhkVI59pz6zQWde2qp0t4PCwsC8UNh3ohQ
 XsVzrRE5C2erdYxO7Unctz6XR+WVcv1nLIM2NNVAGjqwGIHSFh+eafCKApJyuIoYPxxy
 JvALQuh/VjeMhPDP6gXaIt88OBDcUSaM4LDPyBD5RuEVuaxopV8kE4Oku6HNEt1Xn+OK aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2ybvr4qegb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 02:02:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P1x56N160214;
        Tue, 25 Feb 2020 02:00:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2yby5ems67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 02:00:37 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01P20ZHi016286;
        Tue, 25 Feb 2020 02:00:36 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 18:00:35 -0800
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <20200225005718.GC10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5de019d4-d19f-315d-0299-3926c49cf150@oracle.com>
Date:   Mon, 24 Feb 2020 19:00:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225005718.GC10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 5:57 PM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:05:54PM -0700, Allison Collins wrote:
>> This patch embeds an xfs_name in xfs_da_args, replacing the name, namelen, and flags
>> members.  This helps to clean up the xfs_da_args structure and make it more uniform
>> with the new xfs_name parameter being passed around.
> 
> Commit message should wrap at 68-72 columns.
> 
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
>>   	args->geo = dp->i_mount->m_attr_geo;
>>   	args->whichfork = XFS_ATTR_FORK;
>>   	args->dp = dp;
>> -	args->flags = flags;
>> -	args->name = name->name;
>> -	args->namelen = name->len;
>> -	if (args->namelen >= MAXNAMELEN)
>> +	memcpy(&args->name, name, sizeof(struct xfs_name));
>> +	args->name.type = flags;
> 
> This doesn't play well with Christoph's cleanup series which fixes
> up all the confusion with internal versus API flags. I guess the
> namespace is part of the attribute name, but I think this would be a
> much clearer conversion when placed on top of the way Christoph
> cleaned all this up...
> 
> Have you looked at rebasing this on top of that cleanup series?
> 
> Cheers,
> 
Yes, there is some conflict between the sets here and there, but I think 
folks wanted to keep them separate for now.  Are you referring to 
"[780d29057781] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag"?  I'm 
pretty sure this set is already seated on top of that one.  This one is 
based on the latest for-next.

Allison
