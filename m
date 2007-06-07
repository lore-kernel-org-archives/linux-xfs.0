Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 15:28:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l57MSZWt007786
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 15:28:37 -0700
Date: Fri, 8 Jun 2007 08:28:13 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070607222813.GG85884050@sgi.com>
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46680F5E.6070806@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

On Thu, Jun 07, 2007 at 02:59:58PM +0100, David Greaves wrote:
> David Chinner wrote:
> >On Thu, Jun 07, 2007 at 11:30:05AM +0100, David Greaves wrote:
> >>Tejun Heo wrote:
> >>>Hello,
> >>>
> >>>David Greaves wrote:
> >>>>Just to be clear. This problem is where my system won't resume after s2d
> >>>>unless I umount my xfs over raid6 filesystem.
> >>>This is really weird.  I don't see how xfs mount can affect this at all.
> >>Indeed.
> >>It does :)
> >
> >Ok, so lets determine if it really is XFS.
> Seems like a good next step...
> 
> >Does the lockup happen with a
> >different filesystem on the md device? Or if you can't test that, does
> >any other XFS filesystem you have show the same problem?
> It's a rather full 1.2Tb raid6 array - can't reformat it - sorry :)

I suspected as much :/

> I only noticed the problem when I umounted the fs during tests to prevent 
> corruption - and it worked. I'm doing a sync each time it hibernates (see 
> below) and a couple of paranoia xfs_repairs haven't shown any problems.

sync just guarantees that metadata changes are logged and data is
on disk - it doesn't stop the filesystem from doing anything after
the sync...

> I do have another xfs filesystem on /dev/hdb2 (mentioned when I noticed the 
> md/XFS correlation). It doesn't seem to have/cause any problems.

Ok, so it's not an obvious XFS problem...

> >If it is xfs that is causing the problem, what happens if you
> >remount read-only instead of unmounting before shutting down?
> Yes, I'm happy to try these tests.
> nb, the hibernate script is:
> ethtool -s eth0 wol g
> sync
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> 
> So there has always been a sync before any hibernate.
> 
> 
> cu:~# mount -oremount,ro /huge
.....
> [this works and resumes]

Ok.

> cu:~# mount -oremount,rw /huge
> cu:~# /usr/net/bin/hibernate
> [this works and resumes too !]

Interesting. That means something in the generic remount code
is affecting this.

> cu:~# touch /huge/tst
> cu:~# /usr/net/bin/hibernate
> [but this doesn't even hibernate]

Ok, so a clean inode is sufficient to prevent hibernate from working.

So, what's different between a sync and a remount?

do_remount_sb() does:

    599         shrink_dcache_sb(sb);
    600         fsync_super(sb);

of which a sync does neither. sync does what fsync_super() does in
different sort of way, but does not call sync_blockdev() on each
block device. It looks like that is the two main differences between
sync and remount - remount trims the dentry cache and syncs the blockdev,
sync doesn't.

> > What about freezing the filesystem?
> cu:~# xfs_freeze -f /huge
> cu:~# /usr/net/bin/hibernate
> [but this doesn't even hibernate - same as the 'touch']

I suspect that the frozen filesystem might cause other problems
in the hibernate process. However, while a freeze calls sync_blockdev()
it does not trim the dentry cache.....

So, rather than a remount before hibernate, lets see if we can 
remove the dentries some other way to determine if removing excess
dentries/inodes from the caches makes a difference. Can you do:

# touch /huge/foo
# sync
# echo 1 > /proc/sys/vm/drop_caches
# hibernate

# touch /huge/bar
# sync
# echo 2 > /proc/sys/vm/drop_caches
# hibernate

# touch /huge/baz
# sync
# echo 3 > /proc/sys/vm/drop_caches
# hibernate

And see if any of those survive the suspend/resume?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
