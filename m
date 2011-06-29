Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T1OfS7027251 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 20:24:41 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A8BC3C768
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:24:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	YZFY1DLdEpYYjkXL for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 18:24:40 -0700 (PDT)
Date: Wed, 29 Jun 2011 11:24:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS file loss - 2.6.38.5, FC RAID
Message-ID: <20110629012416.GS32466@dastard>
References: <BANLkTimsEAyCF52hzx0ay4S+6TkscpKXoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimsEAyCF52hzx0ay4S+6TkscpKXoQ@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 28, 2011 at 11:03:02AM -0400, Paul Anderson wrote:
> I'm sending this error report as an informational point - I'm not sure
> much can be done about it at the present time.
> 
> We had a machine crash Sunday night (June 26) around 8PM - the
> hardware failed due to a Sun J4400 chassis fault.  The XFS file loss
> noted in this report was not on this chassis.
> 
> On power cycle and subsequent reboot, one of our home directory
> volumes, a pair of 40TiByte Promise RAID6 fiber channel SAN array
> together in a single LVM, lost many files.
> 
> File loss is characterized by numerous files now with length of zero.
> I lost files that I know were last changed on Friday (June 24), more
> than 2 days before the crash.

Which means either they weren't written back, or the inode was never
written to disk or logged after the data was written. Can you tell
us about the files were that were zero length? e.g. their lifecycle,
how they are modified, expected size, etc?

> Kernel is 2.6.38.5, userland is Ubuntu 10.04, server hardware is a 24
> core Dell R900 w/128GiBytes RAM, an LSIFC949E fiber channel card, a
> bunch of Dell PERC 6 RAID cards, and a lot of direct attach SAS JBOD
> cabinets (mostly J4400, but a few Dell MD1000's).  The boot drive is a
> pair of matched 1TiByte drives in a HW RAID-1 config.

hmmmm - lots of RAM. I wonder if something in writeback land got
stuck and the system never hit dirty memory thresholds or some other
writeback trigger. Anything in the log about hung tasks?

> The Promise RAID6 SAN unit where the files were lost is battery
> backed, and reports no errors.  The filesystem showed no signs of
> distress prior to this.  The filesystem was less than 4 weeks old.
> 
> Here's the fstab mount options:
> 
> /dev/wonderlandhomet/homet    /homet    xfs
> inode64,logbufs=8,noatime        0       0

Ok, so not using delayed logging.

> xfs_info shows:
> 
> root@wonderland:~# xfs_info /homet
> meta-data=/dev/mapper/wonderlandhomet-homet isize=256    agcount=81,
> agsize=268435328 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=21484355584, imaxpct=1
>          =                       sunit=128    swidth=2816 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The dmesg log shows no signs of hardware or kernel software problems
> up to the point where the directly attached SAS card reported faults
> for the cabinet.
> 
> The vm tuning parameters are defaults (yes, I know this is bad):
> 
> root@louie:/proc/sys/vm# cat dirty_background_bytes
> 0
> root@louie:/proc/sys/vm# cat dirty_background_ratio
> 10
> root@louie:/proc/sys/vm# cat dirty_bytes
> 0
> root@louie:/proc/sys/vm# cat dirty_expire_centisecs
> 3000
> root@louie:/proc/sys/vm# cat dirty_ratio
> 40
> root@louie:/proc/sys/vm# cat dirty_writeback_centisecs
> 500

Those look like the defaults to me, so background writeback
won't start until ~13GB of memory is dirty. Hence it should only be
doing kupdate writeback at that point based on inodes aging more than
30s...

> My main question is: what specific action can I take to minimize the
> likelihood of this happening again?  As far as I know, the dirty pages
> should expire and be flushed to the FC array (2 days?  should be
> enough), and the FC array itself is stable.

No idea at this point.

There is the possibility that the AIL did not get pushed because
there wasn't sufficient transaction activity so the inode never got
written back (you've got a ~2GB log, so entirely possible), but I
would have expect log replay to handle that case just fine. 2.6.39
pushes the AIL every 30s so avoids this problem, but the fix is not
a simple backport to 2.6.38 because it is part of a conversion of
the xfssyncd/xfsaild to use workqueues.

Other than that, I can't really say. A reproducable test case is
usually needed to find such problems, and I don't think you have one
of those... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
