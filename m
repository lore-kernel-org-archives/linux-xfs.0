Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:36124 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdCOGxM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Mar 2017 02:53:12 -0400
Received: by mail-yw0-f175.google.com with SMTP id o4so4806952ywd.3
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2017 23:53:12 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 15 Mar 2017 00:53:10 -0600
Message-ID: <CAJCQCtQ8aZn5y7WjCC=PamChxSw9Fd=0D7o2+S_GEbifV1h+ig@mail.gmail.com>
Subject: boot failure after kernel update, imap claims in-use inode 661690 is
 free, would correct imap
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

Hi,

A user reports a curious OS update bug with Fedora 22, 23, 24, and 25,
where after a kernel update, upon reboot there's only a grub> prompt,
no menu.

I've reproduced this using a qemu-kvm VM, with device SATA and unsafe
caching, pointed to an LVM LV. If I do 'dnf update' to update the
kernel, the problem doesn't happen, if I use gnome-software the
problem always happens.

gnome-software leverages PackageKit for downloading and staging, then
reboots to a systemd offline update target to do the update. So it's a
joint effort. The detailed reproduce steps I've come up with are in
comment 39 of the original bug report:

https://bugzilla.redhat.com/show_bug.cgi?id=1227736#c39

The gist of the analysis in that comment is that the modified grub.cfg
is a 0 length file, and that's why GRUB arrives at a grub> prompt
instead of a menu. If I boot from alternate media and run xfs_repair
-n, I get tons of errors - that log is attached to the bug report and
is here

https://bugzilla.redhat.com/attachment.cgi?id=1263176

If all I do is do a normal mount, kernel reports log replay, no
errors, and then I can boot the previously unbootable system just
fine, and xfs_repair -n reports no errors. So it seems like the volume
is left dirty at reboot time following these offline updates, and of
course GRUB doesn't read the XFS log so it has no idea how to recover
and find grub.cfg or any other affected files.

But with the available information I can't tell why the fs is left
dirty at reboot. Using the same configuration, the problem doesn't
happen with ext4 or Btrfs, but it may be normal behavior and what
really needs to be done is teach GRUB how to do log replay.



-- 
Chris Murphy
