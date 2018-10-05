Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60140 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbeJEVzC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 17:55:02 -0400
Subject: Re: mkfs.xfs: don't go into multidisk mode if there is only one
 stripe
References: <20181004175839.18736-1-idryomov@gmail.com>
 <24d229f3-1a75-a65d-5ad3-c8565cb32e76@sandeen.net>
 <20181004222952.GV31060@dastard>
 <CAOi1vP_U-QpABgs+a9oYpYvLWs4D2qVmff=-JEikn7S_=eCAXQ@mail.gmail.com>
 <20181005145001.GA4883@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5f6d3d86-7e56-dcf7-fb3d-3c3bc54ebc97@sandeen.net>
Date: Fri, 5 Oct 2018 09:55:57 -0500
MIME-Version: 1.0
In-Reply-To: <20181005145001.GA4883@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mike Snitzer <snitzer@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>, Mark Nelson <mnelson@redhat.com>, Eric Sandeen <sandeen@redhat.com>



On 10/5/18 9:50 AM, Mike Snitzer wrote:
> On Fri, Oct 05 2018 at  7:27am -0400,
> Ilya Dryomov <idryomov@gmail.com> wrote:
> 
>> On Fri, Oct 5, 2018 at 12:29 AM Dave Chinner <david@fromorbit.com> wrote:
>>>
>>> On Thu, Oct 04, 2018 at 01:33:12PM -0500, Eric Sandeen wrote:
>>>> On 10/4/18 12:58 PM, Ilya Dryomov wrote:
>>>>> rbd devices report the following geometry:
>>>>>
>>>>>   $ blockdev --getss --getpbsz --getiomin --getioopt /dev/rbd0
>>>>>   512
>>>>>   512
>>>>>   4194304
>>>>>   4194304
>>>
>>> dm-thinp does this as well. THis is from the thinp device created
>>> by tests/generic/459:
>>>
>>> 512
>>> 4096
>>> 65536
>>> 65536
>>
>> (adding Mike)
>>
>> ... and that 300M filesystem ends up with 8 AGs, when normally you get
>> 4 AGs for anything less than 4T.  Is that really intended?
>>
>> AFAIK dm-thinp reports these values for the same exact reason as rbd:
>> we are passing up the information about the efficient I/O size.  In the
>> case of dm-thinp, this is the thinp block size.  If you put dm-thinp on
>> top of a RAID array, I suspect it would pass up the array's preferred
>> sizes, as long as they are a proper factor of the thinp block size.
> 
> Right, see pool_io_hints() for all the logic thinp uses to consume block
> core's blk_stack_limits() provided limits.. thinp can override if the
> underlying limits are _not_ a factor of the thinp's blocksize.
> 
>> The high agcount on dm-thinp has come up before and you suggested that
>> dm-thinp should report iomin == ioopt (i.e. sunit == swidth).  If that
>> was the right fix back in 2014, mkfs.xfs must have regressed:
>>
>>   https://marc.info/?l=linux-xfs&m=137783388617206&w=2
>>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fdfb4c8c1a9fc8dd8cf8eeb4e3ed83573b375285
> 
> Yeah, if we're getting larger AG count again, certainly seems like
> mkfs.xfs regressed.

Our emails crossed ;) - no, there's no regression.  Dave's comment about
the thinp values weren't related to the mkfs AG heuristic.

-Eric
