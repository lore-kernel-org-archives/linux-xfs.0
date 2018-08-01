Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37776 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbeHAGZJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 02:25:09 -0400
Subject: Re: agcount 33 by default for a single HDD?
References: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
 <20180801041204.GH2234@dastard>
 <CAJCQCtQh3KCpG=PNNj1-3Z9cMKoeavgF++3aDTxZdo7YQ=15KA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dce71dca-0b85-387c-a1c9-f62f6c824b1c@sandeen.net>
Date: Tue, 31 Jul 2018 23:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQh3KCpG=PNNj1-3Z9cMKoeavgF++3aDTxZdo7YQ=15KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs list <linux-xfs@vger.kernel.org>



On 7/31/18 11:38 PM, Chris Murphy wrote:
> On Tue, Jul 31, 2018 at 10:12 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Jul 31, 2018 at 07:32:50PM -0600, Chris Murphy wrote:
>>> This seems suboptimal.
>>
>> It's actually a very useful optimisation to make on thin devices.
>>
>>> Basically this is a 750G thin volume. I don't
>>> have a plain partition on a device handy to try this out but I'm
>>> pretty certain the default is 4 AG's in that case, so I'm confused why
>>> by default 33 AGs are created on a thin volume. The LVM volume group
>>> is on a dmcrypt PV.
>>
>> It's a thin volume, therefore it advertises an optimal IO size and
>> alignment setting (i.e. the thin volume allocation chunk size).
>> Hence mkfs.xfs treats it as a "multi-disk device" and sets up
>> alignment and AG count appropriately.
>>
>> This is actually the right optimisation to make for sparse devices -
>> more AGs increase filesystem concurrency but we normally restrict it
>> on single spindles because each AG adds more seeks into typical
>> workloads and slows them down. However, the thin volume already adds
>> that penalty to the storage stack for us because they don't have a
>> linear LBA-to-physical location characteristic.  Hence we can
>> increase filesystem concurrency without addition performance
>> penalties being incurred.
> 
> OK so why 33 AG's with xfsprogs 4.15, but 4 AG's with xfsprogs 4.17,
> when directed to the same thin LV? And also the difference in sunit
> and swidth?
> 

Did you build 4.17 with --disable-blkid?

-Eric
