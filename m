Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41310 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934284AbdKPQf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 11:35:59 -0500
Date: Thu, 16 Nov 2017 08:35:45 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: report collisions between directio and buffered
 writes to userspace
Message-ID: <20171116163545.GI5119@magnolia>
References: <20171116012707.GB5130@magnolia>
 <CAOi1vP8QzuZRFosZWHi4Hb8=WC1jAqXFHwH28PyoOV6eXScnQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP8QzuZRFosZWHi4Hb8=WC1jAqXFHwH28PyoOV6eXScnQw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ilya Dryomov <idryomov@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com

On Thu, Nov 16, 2017 at 10:14:14AM +0100, Ilya Dryomov wrote:
> On Thu, Nov 16, 2017 at 2:27 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > If two programs simultaneously try to write to the same part of a file
> > via direct IO and buffered IO, there's a chance that the post-diowrite
> > pagecache invalidation will fail on the dirty page.  When this happens,
> > the dio write succeeded, which means that the page cache is no longer
> > coherent with the disk!  Programs are not supposed to mix IO types and
> > this is a clear case of data corruption, so store an EIO which will be
> > reflected to userspace during the next fsync.  Get rid of the WARN_ON
> > to assuage the fuzz-tester complaints.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/iomap.c |   25 +++++++++++++++++++++++--
> >  1 file changed, 23 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index 5011a96..9f0e8d4 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -711,6 +711,19 @@ struct iomap_dio {
> >         };
> >  };
> >
> > +static void iomap_warn_stale_pagecache(struct inode *inode)
> > +{
> > +       static DEFINE_RATELIMIT_STATE(_rs,
> > +                       DEFAULT_RATELIMIT_INTERVAL,
> > +                       DEFAULT_RATELIMIT_BURST);
> > +
> > +       errseq_set(&inode->i_mapping->wb_err, -EIO);
> > +       if (__ratelimit(&_rs)) {
> > +               pr_crit("Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!\n");
> > +               dump_stack_print_info(KERN_CRIT);
> > +       }
> > +}
> > +
> >  static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >  {
> >         struct kiocb *iocb = dio->iocb;
> > @@ -753,7 +766,8 @@ static ssize_t iomap_dio_complete(struct iomap_dio *dio)
> >                 err = invalidate_inode_pages2_range(inode->i_mapping,
> >                                 offset >> PAGE_SHIFT,
> >                                 (offset + dio->size - 1) >> PAGE_SHIFT);
> > -               WARN_ON_ONCE(err);
> > +               if (err)
> > +                       iomap_warn_stale_pagecache(inode);
> >         }
> >
> >         inode_dio_end(file_inode(iocb->ki_filp));
> > @@ -1012,9 +1026,16 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >         if (ret)
> >                 goto out_free_dio;
> >
> > +       /*
> > +        * Try to invalidate cache pages for the range we're direct
> > +        * writing.  If this invalidation fails, tough, the write will
> > +        * still work, but racing two incompatible write paths is a
> > +        * pretty crazy thing to do, so we don't support it 100%.
> > +        */
> >         ret = invalidate_inode_pages2_range(mapping,
> >                         start >> PAGE_SHIFT, end >> PAGE_SHIFT);
> > -       WARN_ON_ONCE(ret);
> > +       if (ret)
> > +               iomap_warn_stale_pagecache(inode);
> >         ret = 0;
> >
> >         if (iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
> 
> Shouldn't the same be done for the non-iomap path as well?
> dio_complete() has a similar WARN_ON_ONCE().

Most probably yes, however the users of the old dio paths should decide
that.  XFS moved to iomap a few releases ago for directio.

--D

> Thanks,
> 
>                 Ilya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
