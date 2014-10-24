Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E11C07F37
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 17:19:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE5AD8F8049
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 15:19:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Qn4RMLxXxXE0g3F8 for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 15:19:36 -0700 (PDT)
Message-ID: <544AD077.4080305@sandeen.net>
Date: Fri, 24 Oct 2014 17:19:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com> <544AB338.2050905@sandeen.net>
	<544ACDC4.1070501@hardwarefreak.com>
In-Reply-To: <544ACDC4.1070501@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 10/24/14 5:08 PM, Stan Hoeppner wrote:
> 
> On 10/24/2014 03:14 PM, Eric Sandeen wrote:

...

>>> Any ideas how to verify what's going on here and fix it?
>>
>> # blockdev --getiomin --getioopt /dev/s2d_a1l003
>>
>> The first number, minimum io size, is what is used for sunit
>> The 2nd number, optimal io size, is what is used for swidth
>>
>> Where dm got the geometry, I'm not sure - you'd have to look into
>> how you set up the dm device, and what its defaults are I think.
> 
> Looks like they're being passed up the stack:
> # blockdev --getiomin --getioopt /dev/dm-0
> 512
> 1048576
> 
> # multipath -ll
> 3600c0ff0003630917954075401000000 dm-0 Tek,DH6554
> size=44T features='0' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=50 status=active
> | `- 9:0:0:3 sdj 8:144 active ready running
> `-+- policy='round-robin 0' prio=10 status=enabled
>   `- 1:0:0:3 sdf 8:80  active ready running
> 
> /sys/block/sdj/queue# cat minimum_io_size
> 512
> /sys/block/sdj/queue# cat optimal_io_size
> 1048576

so supposedly a 512 byte stripe unit, and a 1MB width.  Hrmph.

> root@Anguish-ssu-1:/sys/block/sdf/queue# cat minimum_io_size
> 512
> root@Anguish-ssu-1:/sys/block/sdf/queue# cat optimal_io_size
> 1048576
> 
> So it's the presence of a value in optimal_io_size that causes the
> problem here.  My single disk workstation has min but not optimal, as I
> assume most do.  And I don't get this msg when formatting it.
> 
> It's interesting that mkfs.xfs would use these values given they are
> static firmware values in most controllers.  Thus they don't change when
> one uses different geometry for different arrays/LUNs...

Well, they should change with geometry, but many hardware raids
don't advertise anything meaningful.

There are some heuristics in mkfs to ignore things that just
obviously don't make sense.  Perhaps we should ignore anything
with a sector-sized "stripe unit".

(I'll also ask the dm folks why they set it this way).

Dave, any thoughts?

> So it seems I can safely ignore this mkfs msg.

Probably so, but it'd be nice to get rid of it if we could, either
by ignoring sector-sized "stripe units" or changing what dm reports;
not sure.

-Eric

> Thanks,
> Stan
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
