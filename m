Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755401AbdGXRv3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 13:51:29 -0400
Date: Tue, 25 Jul 2017 01:51:25 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: warnings complaining IOMAP_DELALLOC blocks in iomap_dio_actor
 from generic/446
Message-ID: <20170724175125.GH9167@eguan.usersys.redhat.com>
References: <20170724145019.GG9167@eguan.usersys.redhat.com>
 <20170724160551.GB4352@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724160551.GB4352@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 09:05:51AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2017 at 10:50:19PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > Currently generic/446 could trigger a warning in iomap_dio_actor()
> > easily, it's complaining about unexpected iomap->type (see the end for
> > full call trace).
> > 
> > fs/iomap.c: iomap_dio_actor()
> >  859         default:
> >  860                 WARN_ON_ONCE(1);
> >  861                 return -EIO;
> > 
> > It's due to the race between direct read and mmap write pagefault on the
> > same *sparse* file. 
> > 
> > direct read process			mmap write process
> > xfs_file_dio_aio_read (take IOLOCK_SHARED)
> >  iomap_dio_rw
> >   iomap_apply
> >    filemap_write_and_wait_range
> >    invalidate_inode_pages2_range
> >    iomap_apply
> > 					mmap
> > 					 xfs_filemap_page_mkwrite (take MMAPLOCK_SHARED)
> > 					  iomap_page_mkwrite
> > 					   iomap_apply
> > 					    xfs_file_iomap_begin
> > 					     xfs_file_iomap_begin_delay (take ILOCK_EXCL)
> > 					     (release ILOCK_EXCL)
> > 					     ...
> >     xfs_file_iomap_begin
> >     (take ILOCK and read in bmap info)
> >     iomap_dio_actor
> >     ...
> > 
> > The dio path and page_mkwrite path are taking different locks so they're
> > not serialized. So after dio read flushing the file range but before
> > taking ILOCK, the page faults from mmap write could fault in and update
> > the file map first with delalloc blocks. Then the dio reader sees this
> > delalloc block map unexpectedly.
> > 
> > I'm not sure what's the best way to fix it, but a quick hack of
> > disabling delalloc in the write page fault path could do the work for
> > me, e.g.
> > 
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -981,7 +981,7 @@ xfs_file_iomap_begin(
> >         if (XFS_FORCED_SHUTDOWN(mp))
> >                 return -EIO;
> > 
> > -       if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> > +       if (((flags & (IOMAP_WRITE|IOMAP_DIRECT|IOMAP_FAULT)) == IOMAP_WRITE) &&
> >                         !IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
> >                 /* Reserve delalloc blocks for regular writeback. */
> >                 return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> > 
> > So that mmap write page fault brings in already allocated blocks, and
> > dio reader sees non-IOMAP_DELALLOC iomaps.
> 
> But now we can't take advantage of delayed allocation for mmap writes
> even when the user isn't being evil by peppering us with dio reads.

That's true, so I called it a hack not fix :)

And I'm wondering what's the bigger problem of letting the dio path take
MMAPLOCK too to serialize against mmap page faults? e.g.
xfs_file_dio_aio_read() takes XFS_MMAPLOCK_SHRED and
xfs_filemap_page_mkwrite() takes XFS_MMAPLOCK_EXCL.

> 
> > I know concurrent dio and mmap io are not recommended, so is this
> > something that doens't need a fix at all, and the test should filter out
> > the warning instead?
> 
> XFS no longer BUG_ON, so I guess it's fine if the test filters out the
> warning.

OK.

> 
> It looks like the end result of a dioread/mmapwrite collision is that
> the dio reader gets -EIO.  Would it be better to return a short read?

Yes, right now dio read gets EIO in this case. I can't tell which one is
better, if the whole dio vs mmap is not recommended, EIO seems to be a
strong signal that indicates "don't do this " :)

Thanks,
Eryu
