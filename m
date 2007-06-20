Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 17:19:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K0JDdo024680
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 17:19:15 -0700
Date: Wed, 20 Jun 2007 10:18:50 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Message-ID: <20070620001850.GV86004887@sgi.com>
References: <46744065.6060605@dgreaves.com> <4674645F.5000906@gmail.com> <46751D37.5020608@dgreaves.com> <4676390E.6010202@dgreaves.com> <20070618145007.GE85884050@sgi.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4677A0C7.4000306@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Tue, Jun 19, 2007 at 10:24:23AM +0100, David Greaves wrote:
> David Greaves wrote:
> so I cd'ed out of /scratch and umounted.
> 
> I then tried the xfs_check.
> 
> haze:~# xfs_check /dev/video_vg/video_lv
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> haze:~# mount /scratch/
> haze:~# umount /scratch/
> haze:~# xfs_check /dev/video_vg/video_lv
> 
> Message from syslogd@haze at Tue Jun 19 08:47:30 2007 ...
> haze kernel: Bad page state in process 'xfs_db'

I think we can safely say that your system is hosed at this point ;)

> ugh. Try again
> haze:~# xfs_check /dev/video_vg/video_lv
> haze:~#

zero output means no on-disk corruption was found. Everything is
consistent on disk, so that seems to indicate something in memory has been
crispy fried by the suspend/resume....

> Dave, I ran xfs_check -v... but I got bored when it reached 122M of bz2 
> compressed output with no sign of stopping... still got it if it's any 
> use...

No, not useful. It's a log of every operation it does and so is really
only useful for debugging xfs-check problems ;)

> I then rebooted and ran a repair which didn't show any damage.

Not surprising as your first check showed no damage.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
