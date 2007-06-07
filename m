Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 07:00:08 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l57E01Wt025578
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 07:00:02 -0700
Message-ID: <46680F5E.6070806@dgreaves.com>
Date: Thu, 07 Jun 2007 14:59:58 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com>
In-Reply-To: <20070607110708.GS86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

David Chinner wrote:
> On Thu, Jun 07, 2007 at 11:30:05AM +0100, David Greaves wrote:
>> Tejun Heo wrote:
>>> Hello,
>>>
>>> David Greaves wrote:
>>>> Just to be clear. This problem is where my system won't resume after s2d
>>>> unless I umount my xfs over raid6 filesystem.
>>> This is really weird.  I don't see how xfs mount can affect this at all.
>> Indeed.
>> It does :)
> 
> Ok, so lets determine if it really is XFS.
Seems like a good next step...

> Does the lockup happen with a
> different filesystem on the md device? Or if you can't test that, does
> any other XFS filesystem you have show the same problem?
It's a rather full 1.2Tb raid6 array - can't reformat it - sorry :)
I only noticed the problem when I umounted the fs during tests to prevent 
corruption - and it worked. I'm doing a sync each time it hibernates (see below) 
and a couple of paranoia xfs_repairs haven't shown any problems.

I do have another xfs filesystem on /dev/hdb2 (mentioned when I noticed the 
md/XFS correlation). It doesn't seem to have/cause any problems.

> If it is xfs that is causing the problem, what happens if you
> remount read-only instead of unmounting before shutting down?
Yes, I'm happy to try these tests.
nb, the hibernate script is:
ethtool -s eth0 wol g
sync
echo platform > /sys/power/disk
echo disk > /sys/power/state

So there has always been a sync before any hibernate.


cu:~# mount -oremount,ro /huge
cu:~# mount
/dev/hda2 on / type xfs (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
usbfs on /proc/bus/usb type usbfs (rw)
tmpfs on /dev/shm type tmpfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
nfsd on /proc/fs/nfsd type nfsd (rw)
/dev/hda1 on /boot type ext3 (rw)
/dev/md0 on /huge type xfs (ro)
/dev/hdb2 on /scratch type xfs (rw)
tmpfs on /dev type tmpfs (rw,size=10M,mode=0755)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
cu:(pid2862,port1022) on /net type nfs 
(intr,rw,port=1022,toplvl,map=/usr/share/am-utils/amd.net,noac)
elm:/space on /amd/elm/root/space type nfs (rw,vers=3,proto=tcp)
elm:/space-backup on /amd/elm/root/space-backup type nfs (rw,vers=3,proto=tcp)
elm:/usr/src on /amd/elm/root/usr/src type nfs (rw,vers=3,proto=tcp)
cu:~# /usr/net/bin/hibernate
[this works and resumes]

cu:~# mount -oremount,rw /huge
cu:~# /usr/net/bin/hibernate
[this works and resumes too !]

cu:~# touch /huge/tst
cu:~# /usr/net/bin/hibernate
[but this doesn't even hibernate]




 > What about freezing the filesystem?
cu:~# xfs_freeze -f /huge
cu:~# /usr/net/bin/hibernate
[but this doesn't even hibernate - same as the 'touch']

Nb the screen looks like this:
http://www.dgreaves.com/pub/2.6.21-rc4-ptched-suspend-failure.jpg
whether it hangs on suspend or resume.

So I wouldn't say it *is* XFS at fault - but there certainly seems to be an 
interaction...
At least it's easily reproducible :) Shame about the sysrq

I can think of other permutations of freeze/ro/writing tests but I'm just 
thrashing really. Happy for you to tell me what to try next ...


David
