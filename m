Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39802 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbeITI72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 04:59:28 -0400
Received: by mail-lf1-f68.google.com with SMTP id v77-v6so6998168lfa.6
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 20:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180920014506.GL27618@dastard>
References: <CAJCQCtQVzmwey0GcuHmZ8=_XuqmrA24d4DDVVuX9vL3KYStwZg@mail.gmail.com>
 <20180920014506.GL27618@dastard>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 19 Sep 2018 21:18:16 -0600
Message-ID: <CAJCQCtQyws4LVJKrNiFST4ajFXB5ViXx=oRWq98r=tppa+K8FQ@mail.gmail.com>
Subject: Re: inline extents
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: xfs list <linux-xfs@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-ext4@vger.kernel.org

Adding fsdevel@, linux-ext4, and btrfs@ (which has a separate subject
on this same issue)



On Wed, Sep 19, 2018 at 7:45 PM, Dave Chinner <david@fromorbit.com> wrote:
>On Wed, Sep 19, 2018 at 10:23:38AM -0600, Chris Murphy wrote:
>> Fedora 29 has a new feature to test if boot+startup fails, so the
>> bootloader can do a fallback at next boot, to a previously working
>> entry. Part of this means GRUB (the bootloader code, not the user
>> space code) uses "save_env" to overwrite the 1024 data bytes with
>> updated environment information.
>
> That's just broken. Illegal. Completely unsupportable. Doesn't
> matter what the filesystem is, nobody is allowed to write directly
> to the block device a filesystem owns.

Yeah, the word I'm thinking of is abomination.

However in their defense, grubenv and the 'save_env' command are old features:

line 3638 @node Environment block
http://git.savannah.gnu.org/cgit/grub.git/tree/docs/grub.texi

"For safety reasons, this storage is only available when installed on a plain
disk (no LVM or RAID), using a non-checksumming filesystem (no ZFS), and
using BIOS or EFI functions (no ATA, USB or IEEE1275)."

I haven't checked how it tests for this. But by now, it should list
the supported file systems, rather than what's exempt. That's a
shorter list.


> ext4 has inline data, too, so there's every chance grub will corrupt
> ext4 filesystems with tit's wonderful new feature. I'm not sure if
> the ext4 metadata cksums cover the entire inode and inline data, but
> if they do it's the same problem as btrfs.

I don't see inline used with a default mkfs, but I do see metadata_csum

e2fsprogs-1.44.3-1.fc29.x86_64

Filesystem features: has_journal ext_attr resize_inode dir_index
filetype extent 64bit flex_bg sparse_super large_file huge_file
dir_nlink extra_isize metadata_csum
Filesystem flags: signed_directory_hash
Default mount options: user_xattr acl

>
>> For XFS, I'm not sure how the inline extent is saved, and whether
>> metadata checksumming includes or excludes the inline extent.
>
> When XFS implements this, it will be like btrfs as the data will be
> covered by the metadata CRCs for the inode, and so writing directly
> to it would corrupt the inode and render it unreadable by the
> filesystem.

Good to know.


>
>> I'm also kinda ignoring the reflink ramifications of this behavior,
>> for now. Let's just say even if there's no corruption I'm really
>> suspicious of bootloader code writing anything, even what seems to be
>> a simple overwrite of two sectors.
>
> You're not the only one
>
> Like I said, it doesn't matter what the filesystem is, overwriting
> file data by writing directly to the block device is not
> supportable. It's essentially a filesystem corruption vector, and
> grub needs to have that functionality removed immediately.

I'm in agreement with respect to the more complex file systems. We've
already realized the folly of the bootloader being unable to do
journal replay, ergo it doesn't really for sure have a complete
picture of the file system anyway. That's suboptimal when it results
in boot failure. But if it were going to use stale file system
information, get a wrong idea of the file system, and then use that to
do even 1024 bytes of writes? No, no, and no.

Meanwhile, also in Fedoraland, it's one of the distros where grubenv
and grub.cfg stuff is on the EFI System partition, which is FAT. This
overwrite behavior will work there, but even this case is a kind of
betrayal that the file is being modified, without its metadata being
updated. I think it's an old era hack that by today's standards simply
isn't good enough. I'm a little surprised that all UEFI
implementations permit arbitrary writes from the pre-boot environment
to arbitrary block devices, even with Secure Boot enabled. That seems
specious.

I know some of the file systems have reserve areas for bootloader
stuff. I'm not sure if that's preferred over bootloaders just getting
their own partition and controlling it stem to stern however they
want.


-- 
Chris Murphy
