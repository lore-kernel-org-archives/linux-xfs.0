Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43239 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759816AbdJQJUU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Oct 2017 05:20:20 -0400
Date: Tue, 17 Oct 2017 11:20:17 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Message-ID: <20171017092017.GN9762@quack2.suse.cz>
References: <CABXGCsMorRzy-dJrjTO6sP80BSb0RAeMhF3QGwSkk50m7VYzOA@mail.gmail.com>
 <CABXGCsOeex62Y4qQJwvMJ+fJ+MnKyKGDj9eRbKemeMVWo5huKw@mail.gmail.com>
 <20171009000529.GY3666@dastard>
 <20171009183129.GE11645@wotan.suse.de>
 <87wp442lgm.fsf@xmission.com>
 <8729041d-05e5-6bea-98db-7f265edde193@suse.de>
 <20171015130625.o5k6tk5uflm3rx65@thunk.org>
 <87efq4qcry.fsf@xmission.com>
 <20171016011301.dcam44qylno7rm6a@thunk.org>
 <c5bb6c1b-90c9-f50e-7283-af7e0de67caa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5bb6c1b-90c9-f50e-7283-af7e0de67caa@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Aleksa Sarai <asarai@suse.de>
Cc: Theodore Ts'o <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@infradead.org>, linux-mm@kvack.org, Oscar Salvador <osalvador@suse.com>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org

On Tue 17-10-17 11:59:50, Aleksa Sarai wrote:
> >>Looking at the code it appears ext4, f2fs, and xfs shutdown path
> >>implements revoking a bdev from a filesystem.  Further if the ext4
> >>implementation is anything to go by it looks like something we could
> >>generalize into the vfs.
> >
> >There are two things which the current file system shutdown paths do.
> >The first is that they prevent the file system from attempting to
> >write to the bdev.  That's all very file system specific, and can't be
> >generalized into the VFS.
> >
> >The second thing they do is they cause system calls which might modify
> >the file system to return an error.  Currently operations that might
> >result in _reads_ are not shutdown, so it's not a true revoke(2)
> >functionality ala *BSD.  I assume that's what you are talking about
> >generalizing into the VFS.  Personally, I would prefer to see us
> >generalize something like vhangup() but which works on a file
> >descriptor, not just a TTY.  That it is, it disconnects the file
> >descriptor entirely from the hardware / file system so in the case of
> >the tty, it can be used by other login session, and in the case of the
> >file descriptor belonging to a file system, it stops the file system
> >from being unmounted
> Presumably the fd would just be used to specify the backing store? I was
> imagining doing it through an additional umount(2) flag but I guess that
> having an fd open is probably better form.
> 
> I'm a little confused about whether this actually will solve the original
> problem though, because it still requires the iteration over /proc/**/mounts
> in order for userspace to finish the unmounts. I feel like this is trying to
> generalise the idea behind luksSuspend -- am I misunderstanding how this
> would solve the original issue? Is it the case that if we "disconnect" at
> the file descriptor level, then the bdev is no longer considered "used" and
> it can be operated on safely?

So umount(2) is essentially a directory tree operation - detach filesystem
mounted on 'dir' from the directory tree. If this was the last point where
the superblock was mounted, we also cleanup the superblock and release the
underlying device.

The operation we are speaking about here is different. It is more along the
lines of "release this device".  And in the current world of containers,
mount namespaces, etc. it is not trivial for userspace to implement this
using umount(2) as Ted points out. I believe we could do that by walking
through all mount points of a superblock and unmounting them (and I don't
want to get into a discussion how to efficiently implement that now but in
principle the kernel has all the necessary information).

And then there's another dimension to this problem (and I believe it is
good to explicitely distinguish this) - what to do if someone is actually
using some of the mountpoints either by having CWD there, having file open
there, or having something else mounted underneath. umount(2) returns EBUSY
in these cases which is impractical for some use cases. And I believe the
proposal here is to "invalidate" open file descriptors through revoke, then
put the superblock into quiescent state and make filesystem stop accessing
the device (and probably release the device reference so that the device is
really free).

I think we could implement the "put the superblock into quiescent state
and make filesystem stop accessing the device" by a mechanism similar to
filesystem freezing. That already implements putting filesystem into
quiescent state while still in use. We would have to modify
sb_start_write() etc. calls to be able to return errors in case write
access is revoked and never going back (instead of blocking forever) but
that should be doable and in my opinion that is easier than trying to tweak
fs shutdown to result in a consistent filesystem. The read part could be
handled as well by putting checks in strategic place.

What I'm a bit concerned about is the "release device reference" part - for
a block device to stop looking busy we have to do that however then the
block device can go away and the filesystem isn't prepared to that - we
reference sb->s_bdev in lots of places, we have buffer heads which are part
of bdev page cache, and probably other indirect assumptions I forgot about
now. One solution to this is to not just stop accessing the device but
truly cleanup the filesystem up to a point where it is practically
unmounted. I like this solution more but we have to be careful to block
any access attemps high enough in VFS ideally before ever entering fs code.

Another option would be to do something similar to what we do when the
device just gets unplugged under our hands - we detach bdev from gendisk,
leave it dangling and invisible. But we would still somehow have to
convince DM that the bdev practically went away by calling
disk->fops->release() and it all just seems fragile to me. But I wanted to
mention this option in case the above solution proves to be too difficult.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
