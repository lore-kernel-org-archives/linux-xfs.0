Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33538 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752727AbeEUOnm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 May 2018 10:43:42 -0400
Date: Mon, 21 May 2018 10:43:33 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] fs: clear writeback errors in inode_init_always
Message-ID: <20180521144333.GA23868@thunk.org>
References: <20180518225037.GA26206@thunk.org>
 <630faadb74f608aa5a42649b81657e8b62d46bc3.camel@kernel.org>
 <20180519152700.GB4507@magnolia>
 <20180519231944.GB23448@thunk.org>
 <fa3b4dec3452aa5696b8657ef509891908901d95.camel@kernel.org>
 <20180520125843.GA25612@bombadil.infradead.org>
 <20180520162954.GA5250@thunk.org>
 <20180520192009.GA22365@bombadil.infradead.org>
 <20180520194124.GB5072@thunk.org>
 <a11668bbe2050c8b5fb8f27b8b301ba8a78e6a97.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a11668bbe2050c8b5fb8f27b8b301ba8a78e6a97.camel@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

On Mon, May 21, 2018 at 07:20:05AM -0400, Jeff Layton wrote:
> 
> As a side note, it looks like __loop_update_dio will discard an error
> from vfs_fsync, so certain ioctls against a loop device can cause errors
> to be lost. It seems like those ought to get propagated to userland or
> to the blockdev's mapping somehow.

I'm not sure it's worth it.  All of the ioctls that call
loop_update_dio are used just to configure the loop device.  In
practice they are never called once the loop device is actually
running.  It might be a better choice is to just define that errors
get reset if there is any attempt to reconfigure the loop device.

One of these ioctls change the offset that a loop device maps onto the
backing file.  So for example, while offset 0 of the loop device might
have corresponds beginning of the backing file, after executing the
ioctl, offset 0 of the loop device no corresponds to offset 2MB of the
backing store.  This might happen if we are resetting the loop device
to point at the first partition of a disk image, for example.  I
really don't think that preserving the error status when we are doing
that kind of radical configuration makes sense.

Or for example, when we change the block size of the loop device; if
the underlying backing store is an IBM Mainframe DASD with a 2k block
size, the reason why the error was signalled was because there was an
attempt to write a 1k block onto a 2k block device.  So again,
resetting the error status of the loop device is the right thing to
do.

The final thing that's worth perhaps exploring is whether or not we
need all of these knobs and ioctls.  In particular, LOOP_CHANGE_FD is
used by losetup.  It exists because back in prehistory, some
distribution installer needed it for some obscure corner case.  If I
remember correctly, it had to do with switching out the initramfs
floppy disk with the root file system floppy disk.  We've wasted
developer bandwidth trying to deal with syzbot complaints about that
ioctl, and it's not clear it was worth the effort, because it's not
clear any real code actually _needs_ that ioctl.  It might have been
easier to comment out the ioctl, and see if anyone screamed.

Given that loop device is maintianed mostly on the margins, and it's
not clear that lots of complicated error handling during setup is
really necessary, this is basically a please to keep things simple, or
at least no more complicated than it has to be.

Cheers,

						- Ted
