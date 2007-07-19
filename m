Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 07:29:28 -0700 (PDT)
Received: from mail.rupa.com (hosted.rupa.com [207.210.101.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6JETPbm029142
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 07:29:26 -0700
Message-ID: <469F906A.6030509@rupa.com>
Date: Thu, 19 Jul 2007 09:25:14 -0700
From: Rupa Schomaker <rupa@rupa.com>
MIME-Version: 1.0
Subject: Re: XFS repair on / in a hosted environment
References: <469E690B.5070600@rupa.com> <20070719023419.GC12413810@sgi.com> <469F6296.9090902@rupa.com>
In-Reply-To: <469F6296.9090902@rupa.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On 7/19/2007 6:09 AM, Rupa Schomaker wrote:
> 
> On 7/18/2007 7:34 PM, David Chinner wrote:
>> On Wed, Jul 18, 2007 at 12:24:59PM -0700, Rupa Schomaker wrote:
>>> I have a virtual server hosted in a XEN environment.  Kernel is
>>> 2.6.16.13-XenU and I can't change it. :( Host provider is not responsive
>>> to getting us a newer kernel.
>>>
>>> Anyway, during my nightly rsync backup, I started seeing the following:
>> .....
>>
>> what does /proc/mounts tell you (rather than /etc/mtab)?
>>
>> If /proc/mounts says ro, then try upgrading your xfsprogs package.
>> and then retrying the repair....
> 
> /proc/mounts shows ro.

I built the latest xfsprogs from cvs.  Still no go.  This is perhaps
something strange with the Xen environment?

hosted:/# mount
/dev/sda1 on / type xfs (rw)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
none on /dev/shm type tmpfs (rw)

hosted:/# cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / xfs ro 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid 0 0
proc /proc proc rw,nosuid,nodev,noexec 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec 0 0
none /dev/shm tmpfs rw 0 0


mount and /proc/mounts don't agree.  Thre is no /dev/root.  I tried the
mount -o remount,ro on both / and /dev/sda1.  No good, only /dev/root is
being changed to ro.

<boggle>

Ok, created a /dev/root.  xfs_repair works as expected.  Now to figure
out what got dumped into lost+found.

-Rupa
