Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56474 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbeIUBTZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Sep 2018 21:19:25 -0400
Date: Thu, 20 Sep 2018 15:34:20 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: inline extents
Message-ID: <20180920193420.GA9343@thunk.org>
References: <CAJCQCtQVzmwey0GcuHmZ8=_XuqmrA24d4DDVVuX9vL3KYStwZg@mail.gmail.com>
 <20180920014506.GL27618@dastard>
 <CAJCQCtQyws4LVJKrNiFST4ajFXB5ViXx=oRWq98r=tppa+K8FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQyws4LVJKrNiFST4ajFXB5ViXx=oRWq98r=tppa+K8FQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs list <linux-xfs@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-ext4@vger.kernel.org

On Wed, Sep 19, 2018 at 09:18:16PM -0600, Chris Murphy wrote:
> > ext4 has inline data, too, so there's every chance grub will corrupt
> > ext4 filesystems with tit's wonderful new feature. I'm not sure if
> > the ext4 metadata cksums cover the entire inode and inline data, but
> > if they do it's the same problem as btrfs.
> 
> I don't see inline used with a default mkfs, but I do see metadata_csum

The grub environment block is 1024 bytes, so unless you are using a 4k
inode size (the default is 256 bytes), the grub environment block
won't be an inline data file.  So in practice, this won't be a
problem.  So in practice this won't be a problem for ext4 today.

There are ways that grub can query the file system (using FIEMAP or
FS_IOC_GETFLAGS) to see whether or not the file is an inline file.
For xfs grub would also need to make sure the file isn't reflinked
file (which can also be queried using FIEMAP).  That's fine for
inline, since a file won't magically change from stored in a block
versus inline, so grub can check this at grub setup time.  But the
problem with reflink is that a file that was originally using a block
exclusively could later have that block be shared by another file, at
which point it's only safe to write the block using copy-on-write.

> I know some of the file systems have reserve areas for bootloader
> stuff. I'm not sure if that's preferred over bootloaders just getting
> their own partition and controlling it stem to stern however they
> want.

Ext4 had reserved the bootloader inode, and we have defined a way for
a bootloader to access it.  The original intent was that not it just
be fore the environment block, but also the grub stage 1.5 or stage 2
loader.  This would allow grub to just use a fixed list of blocks or
extents, and not need to understand the ext4 extents structures.  We
added way this when, because we anticipated this would be easier for
grub than having it learn how to read ext4 extents structures.
Instead, the bootloader would at setup time use the EXT4_IOC_SWAP_BOOT
ioctl and then use a fixed list of blocks or block extents like LILO
used to do.

Of course, grub exceeded expectations and actually learned how to read
ext4 file systems, and probably we (the ext4 developers) should have
reached out to GRUB folks.

Cheers,

						- Ted
