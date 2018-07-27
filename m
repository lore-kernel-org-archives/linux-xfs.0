Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:21594 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731937AbeG0Cyd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jul 2018 22:54:33 -0400
Message-ID: <5B5A76BC.8000703@cn.fujitsu.com>
Date: Fri, 27 Jul 2018 09:34:52 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: Question about reflink feature
References: <5B582B43.8070207@cn.fujitsu.com> <20180725191626.GA4809@magnolia>
In-Reply-To: <20180725191626.GA4809@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Hi Darrick,

Thanks for your explanation.

rmapbt, reflink and dedupe features will be enabled by default together?

Thanks
Xiao Yang
On 2018/07/26 3:16, Darrick J. Wong wrote:
> [add linux-xfs to cc]
>
> On Wed, Jul 25, 2018 at 03:48:19PM +0800, Xiao Yang wrote:
>> Hi Darrick,
>>
>> Sorry to bother you.
>>
>> Currently, all reflink tests for XFS in xfstests are skipped even if we
>> use the lastest kernel and xfsprogs.
>> It seems that mkfs.xfs doesn't enable reflink by default, do you want to
>> enable it by default in later
>> xfsprogs version?
> It will be enabled by default when we've had a long enough period to
> test it and make sure it's stable for general use.  That may happen some
> time in early 2019.
>
>> Shoud we enable it forcely by "mkfs.xfs -m reflink" in
>> xfstests if mkfs.xfs supports it?
> For now, yes.
>
> --D
>
>> Thanks,
>> Xiao Yang
>>
>>
>
>



