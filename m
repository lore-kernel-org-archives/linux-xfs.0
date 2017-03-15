Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35488 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdCOSLZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 14:11:25 -0400
Received: by mail-yw0-f170.google.com with SMTP id v198so16072979ywc.2
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 11:11:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170315072349.GZ5280@birch.djwong.org>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
 <20170315072349.GZ5280@birch.djwong.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 15 Mar 2017 12:11:22 -0600
Message-ID: <CAJCQCtR8RLOBxK7S9Ck0ATT_5vVY6T9rmLtKrYGLPJTrsDRdNQ@mail.gmail.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 1:23 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:

>
> So... you fire up gnome-software, click "Update", it downloads rpms to
> the hard disk, reboots, (presumably) installs the rpms, reboots again,
> and after the /second/ reboot grub just barfs up a grub> prompt?

Correct.


> Now I'm curious how systemd actually triggers the reboot.  Unmounting
> would seem to force the log and push the AIL, which (you'd think) would
> be enough.  But maybe systemd is doing something weird?  Or maybe
> post-update we fail to unmount / ?

If I boot with the following parameters, and use virsh console to
track what's going on right after the updating,

systemd.log_level=debug systemd.log_target=console console=ttyS0,38400



Sending SIGTERM to remaining processes...
Sending SIGKILL to remaining processes...
Process 304 (plymouthd) has been marked to be excluded from killing.
It is running from the root file system, and thus likely to block
re-mounting of the root file system to read-only. Please consider
moving it into an initrd file system instead.
Unmounting file systems.
Remounting '/tmp' read-only with options 'seclabel'.
Unmounting /tmp.
Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
Remounting '/' read-only with options 'seclabel,attr2,inode64,noquota'.
All filesystems unmounted.
Deactivating swaps.
All swaps deactivated.
Detaching loop devices.
device-enumerator: scan all dirs
  device-enumerator: scanning /sys/bus
  device-enumerator: scanning /sys/class
All loop devices detached.
Detaching DM devices.
device-enumerator: scan all dirs
  device-enumerator: scanning /sys/bus
  device-enumerator: scanning /sys/class
All DM devices detached.
Spawned /usr/lib/systemd/system-shutdown/mdadm.shutdown as 8408.
/usr/lib/systemd/system-shutdown/mdadm.shutdown succeeded.
system-shutdown succeeded.
Failed to read reboot parameter file: No such file or directory
Rebooting.
[   52.963598] Unregister pv shared memory for cpu 0
[   52.965736] Unregister pv shared memory for cpu 1
[   52.966795] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[   52.991220] reboot: Restarting system
[   52.993119] reboot: machine restart
<no further entries, VM shuts down>

However, I get a different result. This time I get a stale grub menu
with a single kernel option (same as if the update hadn't happened).
If I boot, kernel messages reports log replay. When I reboot again,
now I have a two kernel grub menu. I'm guessing the slowness of
systemd debug is



-- 
Chris Murphy
