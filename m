Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2B1rFuS132703 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 19:53:21 -0600
Received: from borg.medozas.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 13FE733B948
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 17:56:06 -0800 (PST)
Received: from borg.medozas.de (borg.medozas.de [188.40.89.202]) by
	cuda.sgi.com with SMTP id TdqB0YaXGGX5IsyV for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 17:56:06 -0800 (PST)
Date: Fri, 11 Mar 2011 02:56:05 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Many-metadata performance still at a loss
In-Reply-To: <20110311011024.GB15097@dastard>
Message-ID: <alpine.LNX.2.01.1103110243140.6780@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
	<20110311011024.GB15097@dastard>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


On Friday 2011-03-11 02:10, Dave Chinner wrote:
>On Thu, Mar 10, 2011 at 03:14:34PM +0100, Jan Engelhardt wrote:
>> 
>> Was there something I missed?
>> 
>> # xfs_info /
>> meta-data=/dev/md3               isize=256    agcount=32, 
>> agsize=11429117 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=365731739, 
>> imaxpct=5
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=32768, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=0
>                                                              ^^^^^^^^^^^^
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
>You're using an old mkfs?

As mentioned, this is a preexisting fs. This was created in August 2009
using xfsprogs 2.10.1.

>At minimum, this should have lazy-count=1.
>I'm also wondering about the fact this is a MD device but there is
>no sunit/swidth set,
>Further - what is your storage configuration (e.g. what type of MD
>raid are you using) and is the filesystem correctly aligned to the
>storage? If you get these wrong, then nothing else you do will
>improve performance.

mdraid1 over two dumb SATA disks.

>and the agcount of 32 is not a default value,

Right. xfsprogs had just switched from agcount=16 to agcount=4
for its default value, which at that time seemed a little
uncomforting, given disks grow in size. So as much as I can recall,
I only set the agcount manually to 32 (1.5T/32=46G) for
when I once (like, 2007 or so) created an xfs it used 16
(250G/16=15G).

>What are your mount options - perhaps you've missed the fact that
>the new functionality requires the "delaylog" mount option to be
>added.

Per /proc/mounts:
/dev/md3 / xfs rw,relatime,attr2,nobarrier,noquota 0 0

>Mind you, that is not a magic bullet - if the operation is
>single threaded and CPU bound, delaylog makes  no difference to
>performance, and with lazy-count=0 then the superblock will still be
>a major contention point and probably nullify any improvement
>delaylog could provide..

The question is.. is the writeout single-threaded?
Judging from there being only one xfs thread per block device,
that may seem to hold.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
