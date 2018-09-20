Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:3899 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726123AbeITHZz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 03:25:55 -0400
Date: Thu, 20 Sep 2018 11:45:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: inline extents
Message-ID: <20180920014506.GL27618@dastard>
References: <CAJCQCtQVzmwey0GcuHmZ8=_XuqmrA24d4DDVVuX9vL3KYStwZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQVzmwey0GcuHmZ8=_XuqmrA24d4DDVVuX9vL3KYStwZg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Wed, Sep 19, 2018 at 10:23:38AM -0600, Chris Murphy wrote:
> Hi,
> 
> I ran across this:
> xfs: introduce inode data inline feature
> https://lwn.net/Articles/759183/
> 
> I'm wondering if there's a chance it becomes the default one day in
> the not too distant future?  And if it is enabled at all (user or by
> default), what happens if something where to directly overwrite 1024
> bytes outside of the file system?

First somebody has to implement the feature in a way that it can be
merged. :)

> For example:
> 
> The file /boot/grub/grubenv is 1KiB and stores GRUB environment info,
> like what the default boot should be. Fedora up until now only writes
> to it when booted, so it goes through the file system, and the
> bootloader only reads from it.
> 
> Fedora 29 has a new feature to test if boot+startup fails, so the
> bootloader can do a fallback at next boot, to a previously working
> entry. Part of this means GRUB (the bootloader code, not the user
> space code) uses "save_env" to overwrite the 1024 data bytes with
> updated environment information.

That's just broken. Illegal. Completely unsupportable. Doesn't
matter what the filesystem is, nobody is allowed to write directly
to the block device a filesystem owns.

> On something like FAT or ext2 or even ext4 without checksums, this
> isn't a problem. On Btrfs, 1KiB is almost always going to be an inline
> extent, found inside a 16KiB leaf, and that leaf has a checksum
> predicated on the entire contents of that leaf. Overwrite 1KiB outside
> the file system and now the checksum is wrong, the kernel code will
> consider the entire 16KiB leaf corrupt.

Yup. Or it's a shared data extent (i.e. a reflinked or deduped file)
and writing to it corrupts the other copies because the filesystem
wasn't able to COW it.

> And that leaf might contain
> items totally unrelated to the file being modified so it could be a
> rather significant corruption. And it may not be fixable (I haven't
> really tested this yet and I think GRUB knows better than to write to
> a grubenv on Btrfs anyway).

ext4 has inline data, too, so there's every chance grub will corrupt
ext4 filesystems with tit's wonderful new feature. I'm not sure if
the ext4 metadata cksums cover the entire inode and inline data, but
if they do it's the same problem as btrfs.

> For XFS, I'm not sure how the inline extent is saved, and whether
> metadata checksumming includes or excludes the inline extent.

When XFS implements this, it will be like btrfs as the data will be
covered by the metadata CRCs for the inode, and so writing directly
to it would corrupt the inode and render it unreadable by the
filesystem.

> I'm also kinda ignoring the reflink ramifications of this behavior,
> for now. Let's just say even if there's no corruption I'm really
> suspicious of bootloader code writing anything, even what seems to be
> a simple overwrite of two sectors.

You're not the only one

Like I said, it doesn't matter what the filesystem is, overwriting
file data by writing directly to the block device is not
supportable. It's essentially a filesystem corruption vector, and
grub needs to have that functionality removed immediately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
