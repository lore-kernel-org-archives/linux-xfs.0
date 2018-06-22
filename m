Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46848 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934042AbeFVBeu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Jun 2018 21:34:50 -0400
Subject: Re: [PATCH] mkfs: fix divide-by-zero in align_ag_geometry
From: Eric Sandeen <sandeen@sandeen.net>
References: <20180621025520.9115-1-jeffm@suse.com>
 <20180621035749.GR19934@dastard>
 <85feed9e-c347-5559-59cc-9f4e035324e5@suse.com>
 <342f7e6a-83f6-e887-b24f-b9a628f790e2@sandeen.net>
 <20180621194936.GS19934@dastard>
 <919ce2d0-b560-3fe6-f16c-503f57e3157c@suse.com>
 <20180621223644.GW19934@dastard>
 <1c60e3f5-3d2f-d739-cc1d-e23919f6c585@sandeen.net>
Message-ID: <c78886ab-c334-a96f-795e-ea1985a1a8f3@sandeen.net>
Date: Thu, 21 Jun 2018 20:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <1c60e3f5-3d2f-d739-cc1d-e23919f6c585@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jeff Mahoney <jeffm@suse.com>
Cc: linux-xfs@vger.kernel.org

On 6/21/18 6:16 PM, Eric Sandeen wrote:
>> Ah, so it came from the hardware? In that case, we probably
>> shouldn't zero sunit when blkid reports this whacky case. i.e. I
>> think we should set swidth = sunit so that we retain allocation
>> alignment to the minimum IO size the device specified.
> Hrmph.
> 
> yeah, I'd really like to see 
> 
> # blockdev --getiomin --getioopt --getss --getpbsz
> 
> for all the devices in the stack, I guess...

Ok, so Jeff shared the lsblk output with me; the underlying
device and the mpath device are both:

MIN-IO OPT-IO PHY-SEC LOG-SEC
8192      0     512     512

so logical/physical 512, with minimum io 8192 and optimal io 0.
On further inspection Jeff says this may be because an optimal
size is reported as greater than the maximum size, so we get 0
due to the inconsistency.

Ok, well, I guess I see your point that we should probably set
sunit=swidth=8192 here.  I was thinking that conflicted with
how we process it on the commandline but no, it doesn't; if you're
going to manually specify you can't set one to 0 and not the other,
but we have to make the best of what the hardware tells us.

So we could do:

        /*
         * Some odd hardware sets minimum IO but not optimal; assume
         * minimal is the smallest preferred IO size, and set optimal
	 * to the same value, i.e. a stripe of 1 disk.
         */
        if (*sunit && *swidth == 0)
                *swidth = *sunit;

But it's clearly buggy hardware.  How are we to know which values 
are accurate and which are not?  It still may be better to just set
to no stripe geometry if we've gotten nonsense from libblockdev,
if the device wants better performance it needs to have rational
firmware... trying to 2nd guess bad values is just a crapshoot.
I guess we could issue a warning ...

-Eric
