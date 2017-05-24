Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36597 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934842AbdEXGWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 02:22:25 -0400
Received: by mail-yw0-f196.google.com with SMTP id h82so12260100ywb.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2017 23:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
References: <20170518012618.GT4519@birch.djwong.org> <20170518013242.GW4519@birch.djwong.org>
 <20170518083405.GQ17542@dastard> <20170518223053.GD4519@birch.djwong.org>
 <CAJCQCtTj-7BovZbXyZu9=Dhh4ROR-AJ6Dpsw1GKbM-a2fr+uVw@mail.gmail.com>
 <20170519210040.GL4519@birch.djwong.org> <20170522020112.GV17542@dastard> <CAJCQCtTj4it6o-Fop6vm3s_HFbRemF5o_H9w-tvS6wmFfVwKBA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 May 2017 00:22:13 -0600
Message-ID: <CAJCQCtTgtMPCdZA3SOV7UFmQ3Y83op2JHPh-0iSkm7-2SvMCXg@mail.gmail.com>
Subject: Re: [PATCH 3/3] xfs: freeze rw filesystems just prior to reboot
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

On Mon, May 22, 2017 at 2:46 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Second, I have only been able to reproduce this problem with grubby +
> XFS. If I manually do grub2-mkconfig + reboot -f instead, the problem
> does not happen. It might be that I'm too slow, and the marginal
> amount of extra time permits the new grub.cfg to fully commit, but I
> don't know.

This is wrong. I retested this and 2 for 2 attempts I can reproduce
the problem either with grubby + reboot -f, or grub2-mkconfig + reboot
-f; so I must have been doing a normal reboot and somehow systemd
must've been successful at umounting or remount-ro'ing the file system
before the reboot.

But I did notice something else in both grubby and grub-mkconfig
cases. The initramfs and/or the kernel are variably either missing or
are zero length files. Here's an example from an updated system that
fails to boot due to zero length grub.cfg;

-rw-------. 1 root root 59650987 May 23 18:16
initramfs-0-rescue-a0269ef67a5f4c1ca97e0817ac1c4a6d.img
-rw-------. 1 root root 19764807 May 23 18:16 initramfs-4.11.0-2.fc26.x86_64.img
-rw-r--r--. 1 root root   182704 Feb 10 22:58 memtest86+-5.01
-rw-------. 1 root root  3548950 May  9 09:42 System.map-4.11.0-2.fc26.x86_64
-rw-------. 1 root root        0 May 15 13:46 System.map-4.11.1-300.fc26.x86_64
-rwxr-xr-x. 1 root root  7282776 May 23 18:16
vmlinuz-0-rescue-a0269ef67a5f4c1ca97e0817ac1c4a6d
-rwxr-xr-x. 1 root root  7282776 May  9 09:43 vmlinuz-4.11.0-2.fc26.x86_64
-rwxr-xr-x. 1 root root        0 May 15 13:46 vmlinuz-4.11.1-300.fc26.x86_64

-rw-rw-r--. 1 root root    0 May 23 18:44 grub.cfg

The proper initramfs is not there at all. The kernel is zero bytes.
And as previously reported the grub.cfg is zero bytes, hence failure
in grub. Upon normal mount, all of them appear as you'd expect.

If grubby and grub-mkconfig are to be blamed for not freezing the
system, on the basis that remount-ro or umount cannot be depended on,
then that means non-GRUB and non-grubby setups need their kernel
package postinstall script to fsfreeze.

Consider this scenario on UEFI. The grub.cfg on Fedora/RH systems goes
on the FAT EFI System partition (unlike upstream which calls for it
going on /boot), and it's got a pretty good chance of fully committing
even if systemd fails to remount-ro /boot. So we get a valid grub.cfg
pointing to a new kernel and initramfs that may not be locatable by
the bootloader because it can't read the dirty log. And again it
implicates the kernel package for not having done an fsfreeze, knowing
full well the limitations of the most common bootloaders which don't
read logs.

Something seems really out of order here. The kernel is installed
first, then the initramfs is built, grub.cfg.new is created, grub.cfg
is deleted, grub.cfg.new is renamed to grub.cfg. How is it the first
two items are in the dirty log, not fully committed to fs metadata;
but the grub.cfg is zero length? Why isn't the old one still there as
far as grub is concerned? If that were the case, the old kernel and
initramfs could be booted and then the log replayed to fix up
everything. The ordering here seems pretty screwy.



-- 
Chris Murphy
