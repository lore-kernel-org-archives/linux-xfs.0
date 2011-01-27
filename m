Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3kfdG184031 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:46:41 -0600
Received: from ironport2-out.pppoe.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B1BE105D30D
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:49:04 -0800 (PST)
Received: from ironport2-out.pppoe.ca (ironport2-out.teksavvy.com
	[206.248.154.181]) by cuda.sgi.com with ESMTP id
	9EoXuXJaHE93GvzL for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:49:04 -0800 (PST)
Message-ID: <4D40EB2F.2050809@teksavvy.com>
Date: Wed, 26 Jan 2011 22:49:03 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard>
In-Reply-To: <20110127033011.GH21311@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

On 11-01-26 10:30 PM, Dave Chinner wrote:
> [Please cc xfs@oss.sgi.com on XFS bug reports. Added.]
>
> On Wed, Jan 26, 2011 at 08:22:25PM -0500, Mark Lord wrote:
>> Alex / Christoph,
>>
>> My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
>> It is behaving rather strangely though, and has gotten worse recently.
>> Here is what I see happening:
>>
>> The drive mounts fine at boot, but the very first attempt to write a new file
>> to the filesystem suffers from a very very long pause, 30-60 seconds, during which
>> time the disk activity light is fully "on".
>
> Please post the output of xfs_info <mtpt> so we can see what you
> filesystem configuration is.

   /dev/sdb1 on /var/lib/mythtv type xfs
(rw,noatime,allocsize=64M,logbufs=8,largeio)

   [~] xfs_info /var/lib/mythtv
   meta-data=/dev/sdb1              isize=256    agcount=7453, agsize=65536 blks
            =                       sectsz=512   attr=2
   data     =                       bsize=4096   blocks=488378638, imaxpct=5
            =                       sunit=0      swidth=0 blks
   naming   =version 2              bsize=4096   ascii-ci=0
   log      =internal               bsize=4096   blocks=32768, version=2
            =                       sectsz=512   sunit=0 blks, lazy-count=0
   realtime =none                   extsz=4096   blocks=0, rtextents=0

>> This happens only on the first new file write after mounting.
>> From then on, the filesystem is fast and responsive as expected.
>> If I umount the filesystem, and then mount it again,
>> the exact same behaviour can be observed.
>
> I can't say I've seen this. Can you capture a blktrace of the IO so
> we can see what IO is actually being done, and perhaps also record
> an XFS event trace as well (i.e. of all the events in
> /sys/kernel/debug/tracing/events/xfs).

I'll have to reconfig/rebuild the kernel to include support for blktrace first.
Can you specify the exact commands/args you'd like for running blktrace etc?

>> This of course screws up mythtv, as it causes me to lose the first 30-60
>> seconds of the first recording it attempts after booting.  So as a workaround
>> I now have a startup script to create, sync, and delete a 64MB file before
>> starting mythtv.  This still takes 30-60 seconds, but it all happens and
>> finishes before mythtv has a real-time need to write to the filesystem.
>>
>> The 2TB drive is fine -- zero errors, no events in the SMART logs,
>> and I've disabled the silly WD head-unload logic on it.
>>
>> What's happening here?  Why the big long burst of activity?
>> I've only just noticed this behaviour in the past few weeks,
>> running 2.6.35 and more recently 2.6.37.
>
> Can you be a bit more precise? what were you running before 2.6.35
> when you didn't notice this?

Those details are in my earlier follow-up posting.

>> The other issue is something I notice at umount time.

I'm going to let that issue rest for now,
until we figure out the first issue.
Heck, they might even be the exact same thing.. :)

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
