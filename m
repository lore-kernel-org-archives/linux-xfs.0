Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:48159 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbeC2BJL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Mar 2018 21:09:11 -0400
Date: Thu, 29 Mar 2018 12:09:09 +1100
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180329010909.GA22702@onthe.net.au>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180322230450.GT1150@dastard>
 <20180328151959.GA6247@onthe.net.au>
 <20180328222754.GC18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180328222754.GC18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 29, 2018 at 09:27:54AM +1100, Dave Chinner wrote:
> On Thu, Mar 29, 2018 at 02:20:00AM +1100, Chris Dunlop wrote:
>> On Fri, Mar 23, 2018 at 10:04:50AM +1100, Dave Chinner wrote:
>>> On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
>>>> On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
>>>>> XFS on LVM on 6 x PVs, each PV is md raid-6, each with 11 x hdd.
>>>
>>> Are these all on the one raid controller? i.e. what's the physical
>>> layout of all these disks?
>>
>> Yep, one controller. Physical layout:
>>
>> c0 LSI 9211-8i (SAS2008)
>> |
>> + SAS expander w/ SATA HDD x 12
>> |   + SAS expander w/ SATA HDD x 24
>> |       + SAS expander w/ SATA HDD x 24
>> |
>> + SAS expander w/ SATA HDD x 24
>>     + SAS expander w/ SATA HDD x 24
>
> Ok, that's good to know. I've seen misdirected writes in a past life
> because a controller had a firmware bug when it hit it's maximum CTQ
> depth of 2048 (controller max, not per-lun max) and the 2049th
> queued write got written to a random lun on the controller. That
> causes random, unpredicatble data corruptions in a similar manner to
> what you are seeing.

Ouch!

> So don't rule out a hardware problem yet.

OK. I'm not sure which of hardware or kernel I'd prefer it to be 
at this point!

>> Whilst that hardware side of things is interesting, and that md4
>> could bear some more investigation, as previously suggested, and now
>> with more evidence (older files checked clean), it's looking like
>> this issue really started with the upgrade from v3.18.25 to v4.9.76
>> on 2018-01-15. I.e. less likely to be hardware related - unless the
>> new kernel is stressing the hardware in new exciting ways.
>
> Right, that's entirely possible the new kernel is doing something
> the old kernel didn't, like loading it up with more concurrent IO
> across more disks. Do you have the latest firmware on the
> controller?

Not quite: it's on 19.00.00.00, looks like latest is 20.00.06.00 or 
20.00.07.00, depending on where you look.

I can't find a comprehensive set of release notes. Sigh.

We originally held off going to 20 because there were reports of 
problems, but it looks like they've since been resolved in the minor 
updates. Unfortunately we won't be able to update the BIOS in the next 
week or so.

> The next steps are to validate the data is getting through each
> layer of the OS intact. This really needs a more predictable test
> case - can you reproduce and detect this corruption using
> genstream/checkstream?
>
> If so, the first step is to move to direct IO to rule out a page
> cache related data corruption. If direct IO still shows the
> corruption, we need to rule out things like file extension and
> zeroing causing issues. e.g. preallocate the entire files, then
> write via direct IO. If that still generates corruption then we need
> to add code into the bottom of the filesystem IO path to validate
> the data being sent by the filesystem is not corrupt.
>
> If we get that far with correct write data, but still get
> corruptions on read, it's not a filesystem created data corruption.
> Let's see if we can get to that point first...

I'll see what I can do - and/or I'll try v4.14.latest: even if that
makes the problem goes away, that will tell us ...something, right?!

Cheers,

Chris
