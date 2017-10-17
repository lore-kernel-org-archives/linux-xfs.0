Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54346 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755257AbdJQBfJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 21:35:09 -0400
Date: Mon, 16 Oct 2017 21:34:56 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Message-ID: <20171017013456.ts73zw562gpldq66@thunk.org>
References: <CABXGCsMorRzy-dJrjTO6sP80BSb0RAeMhF3QGwSkk50m7VYzOA@mail.gmail.com>
 <CABXGCsOeex62Y4qQJwvMJ+fJ+MnKyKGDj9eRbKemeMVWo5huKw@mail.gmail.com>
 <20171009000529.GY3666@dastard>
 <20171009183129.GE11645@wotan.suse.de>
 <87wp442lgm.fsf@xmission.com>
 <8729041d-05e5-6bea-98db-7f265edde193@suse.de>
 <20171015130625.o5k6tk5uflm3rx65@thunk.org>
 <87efq4qcry.fsf@xmission.com>
 <20171016011301.dcam44qylno7rm6a@thunk.org>
 <20171016220010.GI15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016220010.GI15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <asarai@suse.de>, "Luis R. Rodriguez" <mcgrof@kernel.org>, =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@infradead.org>, linux-mm@kvack.org, Oscar Salvador <osalvador@suse.com>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org

On Tue, Oct 17, 2017 at 09:00:11AM +1100, Dave Chinner wrote:
> > The second thing they do is they cause system calls which might modify
> > the file system to return an error.  Currently operations that might
> > result in _reads_ are not shutdown, so it's not a true revoke(2)
> 
> Which is different to XFS - XFS shuts down all access to the bdev,
> read or write, and returns EIO to the callers.(*) IOWs, a UAPI has
> been copy-and-pasted, but the behaviour and semantics have not been
> copied/duplicated. The requirement was "close enough for fstests to
> use it" not "must behave the exact same way on all filesystems".

Funny story, we was actually trying to copy XFS's semantics.
Originally I had a shutdown test in ext4's readpage() and readpages()
--- but during the code review, someone pointed out that xfs didn't
have those tests in xfs_vm_readpage() and xfs_rm_readpages().  Since
it didn't really matter for my intended use case, I ended up removing
the checks from ext4's readpage() and readpages() functions.

What we didn't notice the that the shutdown test was in
xfs_get_blocks().

> From that perspective, I agree with Ted:  we need an interface
> that provides userspace with sane, consistent semantics and allows
> filesystems to be disconnected from userspace references so can be
> unmounted. What the filesystem then does to disconnect itself from
> the block device and allow unmount to complete (i.e. the shutdown
> implementation) is irrelevant to the VFS and users....


I agree that we should formally define what the semantics should be.
I also believe it should work even if the file system doesn't support
journals, and the file system should be left in a consistent state if
possible, since there are three different, distinct use cases:

* The file system is damaged, so we want to avoid making any changes
  to the file system to minimize further damage.
* The block device has already disappeared, and we are trying to minimize the
  block I/O devices.  We would also prefer that attempts to write dirty pages
  in the writeback pages not cause a kernel panic.
* The user wants to remove the USB thumb drive, but hasn't removed it yet, and the
  system would like to cleanly unmount the file system and leave the thumb drive
  in a consistent state --- without having to force userspace to brute force
  search through /proc and terminate processes just to allow the device to be
  unmounted.

					- Ted
					
