Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51931 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdCAPSA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:18:00 -0500
Date: Wed, 1 Mar 2017 16:17:57 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/12] xfs: implement failure-atomic writes
Message-ID: <20170301151757.GH12248@lst.de>
References: <20170228145737.19016-1-hch@lst.de> <20170228145737.19016-8-hch@lst.de> <20170228230940.GB26319@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228230940.GB26319@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Feb 28, 2017 at 03:09:40PM -0800, Darrick J. Wong wrote:
> By the way, the copy on write code remembers the extents it has
> allocated for CoW staging in the refcount btree so that it can free them
> after a crash, which means that O_ATOMIC requires reflink to be enabled.

Yeah.

> There doesn't seem to be any explicit checking that reflink is even
> enabled, which will probably just lead to weird crashes on a pre-reflink
> xfs.

True.  I had this earlier when I hat basic O_ATOMIC validity checking,
but that was dropped from the series I posted.

> 
> FWIW I didn't see any checking anywhere (vfs or xfs) that the filesystem
> can actually support O_ATOMIC.  If the FS doesn't support atomic writes,
> shouldn't the kernel send EINVAL or something back to userspace?

Older kernels can't check it, so having new ones check it creates even
more of a mess.

I'm still not feeling very well about O_ATOMIC - either we need an
open2 that checks for unknown flags, or I need to change this to
a per-op flag - RWF_ATOMIC for write (pwritev2 actually), and MAP_ATOMIC
for mmap.  But given that pwritev2 isn't really supported in common
userland yet that might be rather painful.

> At the start of xfs_reflink.c is a long block comment describing how the
> copy on write mechanism works.  Since O_ATOMIC is a variant on CoW (it's
> basically CoW with remapping deferred until fsync), please update the
> comment so that the comments capture the details of how atomic writes
> work.
> 
> (IOWs: Dave asked me to leave the big comment, so I'm going to try to
> keep it fairly up to date.)

I'll add some information to it.

> I suppose it goes without saying that userspace will have to coordinate
> its O_ATOMIC writes to the file.

It does - but if you have multiple writers to a file they really need
to be coordinated anyway.  If you have threads whose updates race
you'd need something like

open(O_TMPFILE)
clone file (or range) into tempfile

update tempfile

clone region you want atomically inserted back into the original file.

We can actually do that with existing primitives, but it's a bit more
heavyweight.  We could opimize this a bit by checking if an extent
already points to the same physical blocks before replacing it in
clone_file_range.

> > +	if (file->f_flags & O_ATOMIC)
> > +		printk_ratelimited("O_ATOMIC!\n");
> 
> Per above,
> 
> if (file->f_flags & O_ATOMIC) {
> 	if (!xfs_sb_version_hasreflink(...))
> 		return -EPROTONOSUPPORT;

Yeah.

> 	printk_ratelimited("EXPERIMENTAL atomic writes feature in use!\n");

And that should just go away - it was a local debug aid :)
