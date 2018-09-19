Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f45.google.com ([209.85.167.45]:33970 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731762AbeISWCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 18:02:19 -0400
Received: by mail-lf1-f45.google.com with SMTP id c29-v6so5694052lfj.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 09:23:40 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 19 Sep 2018 10:23:38 -0600
Message-ID: <CAJCQCtQVzmwey0GcuHmZ8=_XuqmrA24d4DDVVuX9vL3KYStwZg@mail.gmail.com>
Subject: inline extents
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs list <linux-xfs@vger.kernel.org>

Hi,

I ran across this:
xfs: introduce inode data inline feature
https://lwn.net/Articles/759183/

I'm wondering if there's a chance it becomes the default one day in
the not too distant future? And if it is enabled at all (user or by
default), what happens if something where to directly overwrite 1024
bytes outside of the file system?

For example:

The file /boot/grub/grubenv is 1KiB and stores GRUB environment info,
like what the default boot should be. Fedora up until now only writes
to it when booted, so it goes through the file system, and the
bootloader only reads from it.

Fedora 29 has a new feature to test if boot+startup fails, so the
bootloader can do a fallback at next boot, to a previously working
entry. Part of this means GRUB (the bootloader code, not the user
space code) uses "save_env" to overwrite the 1024 data bytes with
updated environment information.

On something like FAT or ext2 or even ext4 without checksums, this
isn't a problem. On Btrfs, 1KiB is almost always going to be an inline
extent, found inside a 16KiB leaf, and that leaf has a checksum
predicated on the entire contents of that leaf. Overwrite 1KiB outside
the file system and now the checksum is wrong, the kernel code will
consider the entire 16KiB leaf corrupt. And that leaf might contain
items totally unrelated to the file being modified so it could be a
rather significant corruption. And it may not be fixable (I haven't
really tested this yet and I think GRUB knows better than to write to
a grubenv on Btrfs anyway).

For XFS, I'm not sure how the inline extent is saved, and whether
metadata checksumming includes or excludes the inline extent.

I'm also kinda ignoring the reflink ramifications of this behavior,
for now. Let's just say even if there's no corruption I'm really
suspicious of bootloader code writing anything, even what seems to be
a simple overwrite of two sectors.

Thanks,


-- 
Chris Murphy
