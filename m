Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60847 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965950AbeEXQsS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 12:48:18 -0400
Date: Thu, 24 May 2018 18:53:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 22/34] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180524165350.GA22675@lst.de>
References: <20180523144357.18985-1-hch@lst.de> <20180523144357.18985-23-hch@lst.de> <20180524145935.GA84959@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180524145935.GA84959@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>

> > +		if (!wpc->imap_valid || wpc->io_type == XFS_IO_HOLE) {
> > +			/*
> > +			 * set_page_dirty dirties all buffers in a page, independent
> > +			 * of their state.  The dirty state however is entirely
> > +			 * meaningless for holes (!mapped && uptodate), so check we did
> > +			 * have a buffer covering a hole here and continue.
> > +			 */
> 
> The comment above doesn't make much sense given that we don't check for
> anything here and just continue the loop.

It gets removed in the last patch of the original series when we
kill buffer heads.  But I can fold the removal into this patch as well.

> That aside, the concern I had with this patch when it was last posted is
> that it indirectly dropped the error/consistency check between page
> state and extent state provided by the XFS_BMAPI_DELALLOC flag. What was
> historically an accounting/reservation issue was turned into something
> like this by XFS_BMAPI_DELALLOC:
> 
> # xfs_io -c "pwrite 0 4k" -c fsync /mnt/file
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0041 sec (974.184 KiB/sec and 243.5460 ops/sec)
> fsync: Input/output error

What is that issue that gets you an I/O error on a 4k write?  That
is what is missing in the above reproducer?

> As of this patch, that same error condition now behaves something like
> this:
> 
> [root@localhost ~]# xfs_io -c "pwrite 0 4k" -c fsync /mnt/file
> wrote 4096/4096 bytes at offset 0
> 4 KiB, 1 ops; 0.0029 sec (1.325 MiB/sec and 339.2130 ops/sec)
> [root@localhost ~]# ls -al /mnt/file
> -rw-r--r--. 1 root root 4096 May 24 08:27 /mnt/file
> [root@localhost ~]# umount  /mnt ; mount /dev/test/scratch /mnt/
> [root@localhost ~]# ls -al /mnt/file
> -rw-r--r--. 1 root root 0 May 24 08:27 /mnt/file
> 
> So our behavior has changed from forced block allocation (violating
> reservation) and writing the data, to instead return an error, and now
> to silently skip the page.

We should never, ever allocate space that we didn't have a delalloc
reservation for in writepage/writepages.  But I agree that we should
record and error.  I have to admit I'm lost on where we did record
the error and why we don't do that now.  I'd be happy to fix it.

> I suppose there are situations (i.e., races
> with truncate) where a hole is valid and the correct behavior is to skip
> the page, and this is admittedly an error condition that "should never
> happen," but can we at least add an assert somewhere in this series that
> ensures if uptodate data maps over a hole that the associated block
> offset is beyond EOF (or something of that nature)?

We can have plenty of holes in dirty pages.  However we should never
allocate blocks for them.  Fortunately we stop even looking at anything
but the extent tree for block status by the end of this series for 4k
file systems, and with the next series even for small block sizes, so
that whole mismatch is a thing of the past now.
