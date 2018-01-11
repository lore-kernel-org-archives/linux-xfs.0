Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31869 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752804AbeAKXOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 18:14:01 -0500
Date: Fri, 12 Jan 2018 10:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS journal corruption after every reboot/shutdown
Message-ID: <20180111231358.GW16421@dastard>
References: <20180111224451.GA3413@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111224451.GA3413@fritha.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Heinz Diehl <htd+ml@fritha.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 11:44:51PM +0100, Heinz Diehl wrote:
> Hi,
> 
> the root partition on three different Fedora 27 based machines is
> XFS-formatted. After every reboot or shutdown, dmesgs shows the following lines after
> restarting:
> 
> [htd@kiera ~]$ dmesg | grep XFS
> [    2.773271] SGI XFS with ACLs, security attributes, no debug enabled
> [    2.774950] XFS (sda2): Mounting V4 Filesystem
> [    2.851266] XFS (sda2): Starting recovery (logdev: internal)
> [    2.876522] XFS (sda2): Ending recovery (logdev: internal)

That's not corruption - that's normal log recovery running at mount
time.

> /dev/sda2 is the root partition. /home, which also is XFS formatted, is
> fine. The journal gets automatically recovered in the boot process and
> root mounts just fine. But this happens after every single reboot or
> shutdown - on three different machines with two different kernels
> (4.14.4 and 4.14.12) and three different harddisks. And it's always
> and solely the root partition which is affected.
> 
> To me, it looks like the root partition doesn't get properly unmounted
> on reboot or shutdown, but I can not find anything in the logs that is
> suspicious. I have also looked into systemd sourcecode and the systemd shutdown
> process, but can not see that the root partition is actually unmounted.

That's because it's not. systemd itself still has open references to
the root filesysetm, so when it tries to unmount the root fs, it
fails with -EBUSY. So it then remounts the root filesystem read
only. It does this with ext3/4 filesystems as well - put a serial
console on your machine and just before the machine reboots/powers
off you'll see something like this:

[1883430.750756] systemd-shutdown[1]: Unmounting file systems.
[1883430.752130] systemd-shutdown[17403]: Remounting '/' read-only in with options 'seclabel,errors=remount-ro,data=ordered'.
[1883430.856501] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,data=ordered
[1883430.908480] systemd-shutdown[1]: All filesystems unmounted.

On XFS, this leaves the journal dirty so that when the filesystem
is mounted on boot it can clean up things like orphan inodes that
were present at the time of the remount,ro (e.g. open but unlinked
files).

IOWs, what you are seeing is normal filesystem behaviour that is a
result of systemd being unable to unmount the root filesystem
cleanly because it still has references open to the root filesystem.

> I have also filed a bug report here because there's F27 on all machines:
> https://bugzilla.redhat.com/show_bug.cgi?id=1533620

Not a bug, please close it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
