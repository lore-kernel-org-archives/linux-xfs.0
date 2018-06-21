Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934125AbeFUXQT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 19:16:19 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
 <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
 <20180621223644.GW19934@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1c60e3f5-3d2f-d739-cc1d-e23919f6c585@sandeen.net>
Date: Thu, 21 Jun 2018 18:16:17 -0500
MIME-Version: 1.0
In-Reply-To: <20180621223644.GW19934@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jeff Mahoney <jeffm@suse.com>
Cc: linux-xfs@vger.kernel.org



On 6/21/18 5:36 PM, Dave Chinner wrote:
> On Thu, Jun 21, 2018 at 05:31:58PM -0400, Jeff Mahoney wrote:
>> On 6/21/18 3:49 PM, Dave Chinner wrote:
>>> On Thu, Jun 21, 2018 at 02:26:45PM -0500, Eric Sandeen wrote:
>>>> On 6/21/18 2:15 PM, Jeff Mahoney wrote:
>>>>> On 6/20/18 11:57 PM, Dave Chinner wrote:
>>>>>> On Wed, Jun 20, 2018 at 10:55:20PM -0400, jeffm@suse.com wrote:
>>>>>>> From: Jeff Mahoney <jeffm@suse.com>
>>>>>>>
>>>>>>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>>>>>>> AG alignment code into a separate function.  It got rid of
>>>>>>> redundant checks for dswidth != 0 but did too good a job since now
>>>>>>> it doesn't check at all.
>>>>>>
>>>>>> Of course they got removed - we've already validated the CLI input
>>>>>> and guaranteed that cfg->dswidth can only be zero iff cfg->dsunit is
>>>>>> zero in calc_stripe_factors().
>>>>>>
>>>>>> i.e. We do input validation of CLI paramters before anything else so
>>>>>> that later users (like align_ag_geometry()) can assume the
>>>>>> parameters they are using are valid. In this case, the assumption is
>>>>>> that either both dsunit and dswidth are zero or that both are
>>>>>> non-zero and dswidth an integer multple of dsunit.
>>>>>
>>>>> It's not coming from the CLI parameters.  It's coming from the topology.
>>>>>  The blkid topology stuff is returning 8k for minimal i/o and 0 for
>>>>> optimal.  Without a CLI config, we have dunit=0 in calc_stripe_factors,
>>>>> which takes it from the device.  We set cfg->dsunit=16 and
>>>>> cfg->dswidth=0, and then head down to align_ag_geometry.
>>>>>
>>>>> The topology on this system looks like:
>>>>>
>>>>> ft = {dsunit = 16, dswidth = 0, rtswidth = 0, lsectorsize = 512,
>>>>>
>>>>> psectorsize = 512}
>>>>> That matches with a few of the dm targets I see reported on this system.
>>>
>>> Exactly what kind of dm device does that - we've never had anyone
>>> report this before? Also, if it's a dm device, shouldn't it
>>> also be fixed to output a sane set of IO characteristics in /sys?
>>
>> It's multipath, so it just follows the stacking rules.  The underlying
>> SCSI devices report the same numbers.  The optimal io number is
>> documented as being optional, at least for the kernel, so we need to
>> handle it being 0 anyway.  I'm not sure if the device specifying a
>> minimum i/o size larger than the sector size and also not specifying an
>> optimal i/o size is valid SCSI.  I'll ask for more information since now
>> I'm also curious.
> 
> Ah, so it came from the hardware? In that case, we probably
> shouldn't zero sunit when blkid reports this whacky case. i.e. I
> think we should set swidth = sunit so that we retain allocation
> alignment to the minimum IO size the device specified.

Hrmph.

yeah, I'd really like to see 

# blockdev --getiomin --getioopt --getss --getpbsz

for all the devices in the stack, I guess...

-Eric
