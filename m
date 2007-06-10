Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 07:41:37 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5CEf1Wt016965
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 07:41:09 -0700
Date: Sun, 10 Jun 2007 18:43:48 +0000
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070610184348.GA4417@ucw.cz>
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

Hi!

> >On Thu, Jun 07, 2007 at 11:30:05AM +0100, David Greaves 
> >wrote:
> >>Tejun Heo wrote:
> >>>Hello,
> >>>
> >>>David Greaves wrote:
> >>>>Just to be clear. This problem is where my system 
> >>>>won't resume after s2d
> >>>>unless I umount my xfs over raid6 filesystem.
> >>>This is really weird.  I don't see how xfs mount can 
> >>>affect this at all.
> >>Indeed.
> >>It does :)
> >
> >Ok, so lets determine if it really is XFS.
> Seems like a good next step...
> 
> >Does the lockup happen with a
> >different filesystem on the md device? Or if you can't 
> >test that, does
> >any other XFS filesystem you have show the same problem?
> It's a rather full 1.2Tb raid6 array - can't reformat it 
> - sorry :)
> I only noticed the problem when I umounted the fs during 
> tests to prevent corruption - and it worked. I'm doing a 
> sync each time it hibernates (see below) and a couple of 
> paranoia xfs_repairs haven't shown any problems.
> 
> I do have another xfs filesystem on /dev/hdb2 (mentioned 
> when I noticed the md/XFS correlation). It doesn't seem 
> to have/cause any problems.
> 
> >If it is xfs that is causing the problem, what happens 
> >if you
> >remount read-only instead of unmounting before shutting 
> >down?
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
> cu:~# mount
> /dev/hda2 on / type xfs (rw)
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> usbfs on /proc/bus/usb type usbfs (rw)
> tmpfs on /dev/shm type tmpfs (rw)
> devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> nfsd on /proc/fs/nfsd type nfsd (rw)
> /dev/hda1 on /boot type ext3 (rw)
> /dev/md0 on /huge type xfs (ro)
> /dev/hdb2 on /scratch type xfs (rw)
> tmpfs on /dev type tmpfs (rw,size=10M,mode=0755)
> rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs 
> (rw)
> cu:(pid2862,port1022) on /net type nfs 
> (intr,rw,port=1022,toplvl,map=/usr/share/am-utils/amd.net,noac)
> elm:/space on /amd/elm/root/space type nfs 
> (rw,vers=3,proto=tcp)
> elm:/space-backup on /amd/elm/root/space-backup type nfs 
> (rw,vers=3,proto=tcp)
> elm:/usr/src on /amd/elm/root/usr/src type nfs 
> (rw,vers=3,proto=tcp)
> cu:~# /usr/net/bin/hibernate
> [this works and resumes]
> 
> cu:~# mount -oremount,rw /huge
> cu:~# /usr/net/bin/hibernate
> [this works and resumes too !]
> 
> cu:~# touch /huge/tst
> cu:~# /usr/net/bin/hibernate
> [but this doesn't even hibernate]

This is very probably separate problem... and you should have enough
data in dmesg to do something with it.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
