Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40160 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752851AbdCOSm5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 14:42:57 -0400
Subject: Re: boot failure after kernel update, imap claims in-use inode 661690
 is free, would correct imap
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <25ef4413-9364-1077-9727-a506e9b250de@sandeen.net>
Date: Wed, 15 Mar 2017 13:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

On 3/15/17 1:53 AM, Chris Murphy wrote:
> Hi,
> 
> A user reports a curious OS update bug with Fedora 22, 23, 24, and 25,
> where after a kernel update, upon reboot there's only a grub> prompt,
> no menu.
> 
> I've reproduced this using a qemu-kvm VM, with device SATA and unsafe
> caching, pointed to an LVM LV. If I do 'dnf update' to update the
> kernel, the problem doesn't happen, if I use gnome-software the
> problem always happens.
> 
> gnome-software leverages PackageKit for downloading and staging, then
> reboots to a systemd offline update target to do the update. So it's a
> joint effort. The detailed reproduce steps I've come up with are in
> comment 39 of the original bug report:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1227736#c39
> 
> The gist of the analysis in that comment is that the modified grub.cfg
> is a 0 length file, and that's why GRUB arrives at a grub> prompt
> instead of a menu. If I boot from alternate media and run xfs_repair
> -n, I get tons of errors - that log is attached to the bug report and
> is here
> 
> https://bugzilla.redhat.com/attachment.cgi?id=1263176

Ok, those errors are probably just due to a dirty log.  (I just sent
a patch to make this more clear in xfs_repair output with -n)

> If all I do is do a normal mount, kernel reports log replay,

Ok, so I think the question is: why after a clean reboot is the log
still dirty?  That's not supposed to happen.

systemd is still doing remount,ro before shooting the system in the
head, right?

Does a normal reboot also come up w/ a dirty log?

/me goes to read the bug...

-Eric
