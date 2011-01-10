Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AAuOjB236972 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 04:56:25 -0600
Received: from homer.ka9q.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29CBB1D1E6CA
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 02:58:35 -0800 (PST)
Received: from homer.ka9q.net (homer.ka9q.net [75.60.237.89]) by cuda.sgi.com
	with ESMTP id 2S8EYCbjjtwxE1rp for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 02:58:35 -0800 (PST)
Message-ID: <4D2AE656.6090807@ka9q.net>
Date: Mon, 10 Jan 2011 02:58:30 -0800
From: Phil Karn <karn@ka9q.net>
MIME-Version: 1.0
Subject: Re: realtime partition support?
References: <4D2724E0.9020801@philkarn.net> <20110108021728.GA28803@dastard>
	<4D27E11F.4030607@philkarn.net> <20110110003506.GE28803@dastard>
In-Reply-To: <20110110003506.GE28803@dastard>
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

On 1/9/11 4:35 PM, Dave Chinner wrote:

> Which often does not require IO because the path and inodes are
> cached in memory.

I'm thinking mainly of rapid file creation or deletion, such as

tar xjf linux-2.6.37.tar.bz2
rm -rf linux-2.6.37

Most of the paths are likely cached, yes, but a lot of inodes are being
rapidly created or deleted so there's a lot of log activity.

> Not that much more quickly, because XFS uses readahead to hide a lot
> of the directory traversal IO latency when it is not cached....

> As has already been suggested, "-o delaylog" is the solution to that
> problem.

Thanks for the suggestion. I hadn't even heard of delaylog until the
other day as it's not in the manual page. I just tried it, and 'tar x'
now completes far more quickly. But the output rate shown by 'vmstat' is
still rather low, and it takes a very long time (minutes) for a
subsequent 'sync' or 'umount' command to finish.

And just now my system has deadlocked. The CPUs are all idle, there's no
disk I/O, and commands referencing that filesystem hang. /, /boot and
/home, which are on a separate SSD, seem OK.

[I just noticed that there doesn't seem to be any checking of options to
'mount -o remount'; anything is silently accepted:

$ sudo mount -o rw,remount,relatime,xyzzy,bletch /dev/md0 /big
$ mount
[....]
/dev/md0 on /big type xfs (rw,relatime,xyzzy,bletch)
$

Options are checked when explicitly mounting a file system not already
mounted.]

> 
>> Turning off the write barrier also speeds things up considerably, but
>> that also makes me nervous. My system doesn't have a RAID controller
>> with a nonvolatile cache but it is plugged into a UPS (actually a large
>> solar power system with a battery bank) so unexpected loss of power is
>> unlikely. Can I safely turn off the barrier?
> 
> Should be safe.  In 2.6.37 the overhead of barriers is greatly
> reduced. IIRC, on most modern hardware they will most likely be
> unnoticable, so disabling them is probably not necessary...

I'm running stock 2.6.37 and here the effect of barrier/nobarrier on
rapid file creation or deletion is dramatic, well over an order of
magnitude. With barriers on, "vmstat" shows a bo (block output) rate of
only several hundred kB/sec. With nobarrier, it jumps to 5-9 MB/s. This
is on a RAID-5 array of four 2TB WDC WD20EARS (advanced format) drives.
(The XFS blocksize is 4K, and I was careful to align the partitions on
4K boundaries.) According to hdparm, each drive is running at 3.0 Gb/s,
write caching is enabled but multicount is off. The SATA controllers are
Intel ICH10 82801JI with the ahci driver.

On another system with another WDC drive of the same model connected to
a Intel ICH9R 82801IR controller and the ata_piix driver, multicount is
set to 16. Could this be because the drives on the first machine are in
a RAID array while the second is standalone? Is it safe to change this
setting with hdparm to see what happens?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
