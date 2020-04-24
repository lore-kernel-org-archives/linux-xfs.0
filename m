Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89095C54FD0
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 21:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C78621707
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 21:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zhT4Dwx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDXVpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 17:45:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXVpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 17:45:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OLcxEm147008;
        Fri, 24 Apr 2020 21:45:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aUuB/02tY3qAUu1aNgpAaRYOeRfIUZ5oDcZxk9+lH4g=;
 b=zhT4Dwx/7s8YHFBfZgCa+MROwNsNystfWQLKRFKnCqYQ9jcBA5J1ZRn/m046Qh2Dmmcb
 Cq2OntD2AtVF8//I62ukDWh4gOYOc99wux2hhJanxKKdVWOOXmFUfbEHzgUm4ssAKJDR
 iSZKm8xCzs9Cv7eQHI9iP3Q+apMNe0GmrzAsVHxjEEBmeOlZ1RrA3A3bjjh5cXibmqZj
 19ZfRj+nLnuizPBvDMJ8G6R5XzMaHt0ZapiSsIEcyOGP1YnlCglhzL1HirLCMQ0iCrQ6
 tSo0XwstIMf3Xgg+ilih66guhnVKWTlws8IJsNZhL1vnTrHsEl/Am813X1C9CSGV6jMY ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30ketdpn1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 21:45:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OLcoLM017006;
        Fri, 24 Apr 2020 21:45:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbr9wv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 21:45:26 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OLjPau011266;
        Fri, 24 Apr 2020 21:45:25 GMT
Received: from dhcp-10-159-247-144.vpn.oracle.com (/10.159.247.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 14:45:25 -0700
Subject: Re: [PATCH] xfs: don't change to infinate lock to avoid dead lock
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200423172325.8595-1-wen.gang.wang@oracle.com>
 <20200423230515.GZ27860@dread.disaster.area>
 <ed040889-5f79-e4f5-a203-b7ad8aa701d4@oracle.com>
 <bca65738-3deb-ef43-6dde-1c2402942032@oracle.com>
 <20200424013948.GA2040@dread.disaster.area>
 <676ecd15-d8ea-0e18-6075-3cb11f8c2e15@oracle.com>
 <20200424213729.GC2040@dread.disaster.area>
From:   Wengang Wang <wen.gang.wang@oracle.com>
Message-ID: <c0aa836c-c6e1-0ca8-4b73-3c945b620c09@oracle.com>
Date:   Fri, 24 Apr 2020 14:45:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424213729.GC2040@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=3 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 suspectscore=3 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

OK, make sense! Thanks Dave!

Wengang

On 4/24/20 2:37 PM, Dave Chinner wrote:
> On Fri, Apr 24, 2020 at 09:58:09AM -0700, Wengang Wang wrote:
>> On 4/23/20 6:39 PM, Dave Chinner wrote:
>>> On Thu, Apr 23, 2020 at 04:19:52PM -0700, Wengang Wang wrote:
>>>> On 4/23/20 4:14 PM, Wengang Wang wrote:
>>>>> The real case I hit is that the process A is waiting for inode unpin on
>>>>> XFS A which is a loop device backed mount.
>>>> And actually, there is a dm-thin on top of the loop device..
>>> Makes no difference, really, because it's still the loop device
>>> that is doing the IO to the underlying filesystem...
>> I mentioned IO path here, not the IO its self.  In this case, the IO patch
>> includes dm-thin.
>>
>> We have to consider it as long as we are not sure if there is GPF_KERNEL (or
>> any flags without NOFS, NOIO) allocation happens in dm-thin.
>>
>> If dm-thin has GPF_KERNEL allocation and goes into memory direct reclaiming,
>> the deadlock forms.
> If that happens, then that is a bug in dm-thin, not a bug in XFS.
> There are rules to how memory allocation must be done to avoid
> deadlocks, and one of those is that block device level IO path
> allocations *must* use GFP_NOIO. This prevents reclaim from
> recursing into subsystems that might require IO to reclaim memory
> and hence self deadlock because the IO layer requires allocation to
> succeed to make forwards progress.
>
> That's why we have mempools and GFP_NOIO at the block and device
> layers....
>
>
>>>>> And the backing file is from a different (X)FS B mount. So the IO is
>>>>> going through loop device, (direct) writes to (X)FS B.
>>>>>
>>>>> The (direct) writes to (X)FS B do memory allocations and then memory
>>>>> direct reclaims...
>>> THe loop device issues IO to the lower filesystem in
>>> memalloc_noio_save() context, which means all memory allocations in
>>> it's IO path are done with GFP_NOIO context. Hence those allocations
>>> will not recurse into reclaim on -any filesystem- and hence will not
>>> deadlock on filesystem reclaim. So what I said originally is correct
>>> even when we take filesystems stacked via loop devices into account.
>> You are right here. Seems loop device is doing NOFS|NOIO allocations.
>>
>> The deadlock happened with a bit lower kernel version which is without loop
>> device patch that does NOFS|NOIO allocation.
> Right, the loop device used to have an allocation context bug, but
> that has been fixed. Either way, this is not an XFS or even a
> filesystem layer issue.
>
>> Well, here you are only talking about loop device, it's not enough to say
>> it's also safe in case the memory reclaiming happens at higher layer above
>> loop device in the IO path.
> Yes it is.
>
> Block devices and device drivers are *required* to use GFP_NOIO
> context for memory allocations in the IO path. IOWs, any block
> device that is doing GFP_KERNEL context allocation violates the
> memory allocation rules we have for the IO path.  This architectural
> constraint exists exclusively to avoid this entire class of IO-based
> memory reclaim recursion deadlocks.
>
>>> Hence I'll ask again: do you have stack traces of the deadlock or a
>>> lockdep report? If not, can you please describe the storage setup
>>> from top to bottom and lay out exactly where in what layers trigger
>>> this deadlock?
>> Sharing the callback traces:
> <snip>
>
> Yeah, so the loop device is doing GFP_KERNEL allocation in a
> GFP_NOIO context. You need to fix the loop device in whatever kernel
> you are testing, which you have conveniently never mentioned. I'm
> betting this is a vendor kernel that is missing fixes from the
> upstream kernel. In which case you need to talk to your OS vendor,
> not upstream...
>
> Cheers,
>
> Dave.
