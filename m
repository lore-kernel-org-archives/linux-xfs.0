Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E2NHeF212783 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 20:23:18 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C508164707
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 18:24:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	OS91Don3jl3gCYyC for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 18:24:12 -0800 (PST)
Date: Thu, 14 Jan 2010 13:24:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS data corruption with high I/O even on hardware raid
Message-ID: <20100114022409.GW17483@discord.disaster>
References: <4B4E6F3F.1090901@chaven.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B4E6F3F.1090901@chaven.com>
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
To: Steve Costaras <stevecs@chaven.com>
Cc: xfs@oss.sgi.com

On Wed, Jan 13, 2010 at 07:11:27PM -0600, Steve Costaras wrote:
> Ok, I've been seeing a problem here since had to move over to XFS from  
> JFS due to file system size issues.   I am seeing XFS Data corruption  
> under ?heavy io?   Basically, what happens is that under heavy load  
> (i.e. if I'm doing say a xfs_fsr (which nearly always triggers the  
> freeze issue) on a volume the system hovers around 90% utilization for  
> the dm device for a while (sometimes an hour+, sometimes minutes) the  
> subsystem goes into 100% utilization and then freezes solid forcing me  
> to do a hard reboot of the box.

xfs_fsr can cause a *large* amount of IO to be done, so it is no
surprise that it can trigger high load bugs in hardware and
software. XFS can trigger high load problems on hardware more
readily than other filesystems because using direct IO (like xfs_fsr
does) it can push far, far higher throughput to the starge subsystem
than any other linux filesystem can.

The fact that the IO subsystem is freezing at 100% elevator queue
utilisation points to an IO never completing. This immediately makes
me point a finger at either the RAID hardware or the driver - a bug
in XFS is highly unlikely to cause this symptom as those stats are
generated at layers lower than XFS.

Next time you get a freeze, the output of:

# echo w > /proc/sysrq-trigger

will tell use what the system is waiting on (i.e. why it is stuck)

...


> Since I'm using hardware raid w/ BBU when I reboot and it comes back up  
> the raid controller writes out to the drives any outstanding data in  
> it's cache and from the hardware point of view (as well as lvm's point  
> of view) the array is ok.    The file system however generally can't be  
> mounted (about 4 out of 5 times, some times it does get auto-mounted but  
> when I then run an xfs_repair -n -v in those cases there are pages of  
> errors (badly aligned inode rec, bad starting inode #'s, dubious inode  
> btree block headers among others).    When I let a repair actually run  
> in one case out of 4,500,000 files it linked about 2,000,000 or so but  
> there was no way to identify and verify file integrity.  The others were  
> just lost.
>
> This is not limited to large volume sizes I have seen similar on small  
> ~2TiB file systems as well.  Also when it happened in a couple cases the  
> file system that was taking the I/O (say xfs_fsr -v /home ) another XFS  
> filesystem on the same system which was NOT taking much if any I/O gets  
> badly corrupted (say /var/test ).   Both would be using the same areca  
> controllers and same physical discs (same PV's and same VG's but  
> different LV's).

These symptoms really point to a problem outside XFS - the only time
I've seen this sort of behaviour is on buggy hardware. The
cross-volume corruption is the smoking gun, but proving it is damn
near impossible without expensive lab equipment and a lot of time.

> Any suggestions on how to isolate or eliminate this would be greatly  
> appreciated.

I'd start by not running xfs_fsr as a short term workaround to keep
the load below the problem threshold.

Looking at the iostat output - the volumes sd[f-i] all lock up at
100% utilisation at the same time. Then looking at this:

> ==============
> LVM is using as it's base physical volumes 8 hardware raids  
> (MediaVol00-70 inclusive):
> [  175.320738] ARECA RAID ADAPTER4: FIRMWARE VERSION V1.47 2009-07-16
> [  175.336238] scsi4 : Areca SAS Host Adapter RAID Controller( RAID6  
> capable)
....
> [  175.356231] ARECA RAID ADAPTER5: FIRMWARE VERSION V1.47 2009-10-22
> [  175.376144] scsi5 : Areca SAS Host Adapter RAID Controller( RAID6  
> capable)

You've got 4 luns on each controller, and it looks like all the luns
on one controller have locked up. Everything is pointing at the
raid controller as being the problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
