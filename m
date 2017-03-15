Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18756 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbdCOHXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 03:23:55 -0400
Date: Wed, 15 Mar 2017 00:23:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: boot failure after kernel update, imap claims in-use inode
 661690 is free, would correct imap
Message-ID: <20170315072349.GZ5280@birch.djwong.org>
References: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Wed, Mar 15, 2017 at 12:53:10AM -0600, Chris Murphy wrote:
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
> 
> If all I do is do a normal mount, kernel reports log replay, no
> errors, and then I can boot the previously unbootable system just
> fine, and xfs_repair -n reports no errors. So it seems like the volume
> is left dirty at reboot time following these offline updates, and of
> course GRUB doesn't read the XFS log so it has no idea how to recover
> and find grub.cfg or any other affected files.

I'm not sure you'd want to replay the log from grub anyway. :)

So... you fire up gnome-software, click "Update", it downloads rpms to
the hard disk, reboots, (presumably) installs the rpms, reboots again,
and after the /second/ reboot grub just barfs up a grub> prompt?

Now I'm curious how systemd actually triggers the reboot.  Unmounting
would seem to force the log and push the AIL, which (you'd think) would
be enough.  But maybe systemd is doing something weird?  Or maybe
post-update we fail to unmount / ?

(Tempting to, uh, "delegate" to Eric Sandeen. :))

--D

> But with the available information I can't tell why the fs is left
> dirty at reboot. Using the same configuration, the problem doesn't
> happen with ext4 or Btrfs, but it may be normal behavior and what
> really needs to be done is teach GRUB how to do log replay.
> 
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
