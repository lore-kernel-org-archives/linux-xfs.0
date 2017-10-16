Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:43477 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753023AbdJPWAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2017 18:00:14 -0400
Date: Tue, 17 Oct 2017 09:00:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel BUG at fs/xfs/xfs_aops.c:853! in kernel 4.13 rc6
Message-ID: <20171016220010.GI15067@dastard>
References: <CABXGCsMorRzy-dJrjTO6sP80BSb0RAeMhF3QGwSkk50m7VYzOA@mail.gmail.com>
 <CABXGCsOeex62Y4qQJwvMJ+fJ+MnKyKGDj9eRbKemeMVWo5huKw@mail.gmail.com>
 <20171009000529.GY3666@dastard>
 <20171009183129.GE11645@wotan.suse.de>
 <87wp442lgm.fsf@xmission.com>
 <8729041d-05e5-6bea-98db-7f265edde193@suse.de>
 <20171015130625.o5k6tk5uflm3rx65@thunk.org>
 <87efq4qcry.fsf@xmission.com>
 <20171016011301.dcam44qylno7rm6a@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016011301.dcam44qylno7rm6a@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <asarai@suse.de>, "Luis R. Rodriguez" <mcgrof@kernel.org>, =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>, Christoph Hellwig <hch@infradead.org>, Jan Blunck <jblunck@infradead.org>, linux-mm@kvack.org, Oscar Salvador <osalvador@suse.com>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org

On Sun, Oct 15, 2017 at 09:13:01PM -0400, Theodore Ts'o wrote:
> On Sun, Oct 15, 2017 at 05:14:41PM -0500, Eric W. Biederman wrote:
> > 
> > Looking at the code it appears ext4, f2fs, and xfs shutdown path
> > implements revoking a bdev from a filesystem.  Further if the ext4
> > implementation is anything to go by it looks like something we could
> > generalize into the vfs.
> 
> There are two things which the current file system shutdown paths do.
> The first is that they prevent the file system from attempting to
> write to the bdev.  That's all very file system specific, and can't be
> generalized into the VFS.
> 
> The second thing they do is they cause system calls which might modify
> the file system to return an error.  Currently operations that might
> result in _reads_ are not shutdown, so it's not a true revoke(2)

Which is different to XFS - XFS shuts down all access to the bdev,
read or write, and returns EIO to the callers.(*) IOWs, a UAPI has
been copy-and-pasted, but the behaviour and semantics have not been
copied/duplicated. The requirement was "close enough for fstests to
use it" not "must behave the exact same way on all filesystems".

>From that perspective, I agree with Ted:  we need an interface
that provides userspace with sane, consistent semantics and allows
filesystems to be disconnected from userspace references so can be
unmounted. What the filesystem then does to disconnect itself from
the block device and allow unmount to complete (i.e. the shutdown
implementation) is irrelevant to the VFS and users....

Cheers,

Dave.

(*) Shutdown in XFS is primarily intended to prevent propagating
damage in the filesystem when corruption is first detected or an
unrecoverable error occurs. Historically speaking, it is always
initiated by the XFS filesystem itself, so whatever we do to provide
unmount sanity isn't going to replace internal filesystem shutdown
functionality...

-- 
Dave Chinner
david@fromorbit.com
