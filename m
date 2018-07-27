Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49570 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbeG0Fe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 01:34:56 -0400
Subject: Re: Question about reflink feature
References: <5B582B43.8070207@cn.fujitsu.com> <20180725191626.GA4809@magnolia>
 <5B5A76BC.8000703@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a7cbf5e4-4f3e-6772-6cd6-d698d980813b@sandeen.net>
Date: Thu, 26 Jul 2018 21:14:55 -0700
MIME-Version: 1.0
In-Reply-To: <5B5A76BC.8000703@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 7/26/18 6:34 PM, Xiao Yang wrote:
> Hi Darrick,
> 
> Thanks for your explanation.
> 
> rmapbt, reflink and dedupe features will be enabled by default together?

dedup is not a "feature" of xfs by itself; rather there are userspace
applications which can use clone_file_range (related to reflink) to
do out of band deduplication from userspace.

I believe that rmapbt has a fair bit of performance overhead, and may
not get enabled by default.  Not certain about this though.

-Eric

> Thanks
> Xiao Yang
> On 2018/07/26 3:16, Darrick J. Wong wrote:
>> [add linux-xfs to cc]
>>
>> On Wed, Jul 25, 2018 at 03:48:19PM +0800, Xiao Yang wrote:
>>> Hi Darrick,
>>>
>>> Sorry to bother you.
>>>
>>> Currently, all reflink tests for XFS in xfstests are skipped even if we
>>> use the lastest kernel and xfsprogs.
>>> It seems that mkfs.xfs doesn't enable reflink by default, do you want to
>>> enable it by default in later
>>> xfsprogs version?
>> It will be enabled by default when we've had a long enough period to
>> test it and make sure it's stable for general use.  That may happen some
>> time in early 2019.
>>
>>> Shoud we enable it forcely by "mkfs.xfs -m reflink" in
>>> xfstests if mkfs.xfs supports it?
>> For now, yes.
>>
>> --D
>>
>>> Thanks,
>>> Xiao Yang
>>>
>>>
>>
>>
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
