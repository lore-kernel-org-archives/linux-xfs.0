Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:35061 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751325AbdGYXnM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2017 19:43:12 -0400
Date: Wed, 26 Jul 2017 09:43:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: warnings complaining IOMAP_DELALLOC blocks in iomap_dio_actor
 from generic/446
Message-ID: <20170725234309.GK17762@dastard>
References: <20170724145019.GG9167@eguan.usersys.redhat.com>
 <20170724160551.GB4352@magnolia>
 <20170724175125.GH9167@eguan.usersys.redhat.com>
 <20170724220205.GE17762@dastard>
 <20170725075348.GO9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170725075348.GO9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jul 25, 2017 at 03:53:48PM +0800, Eryu Guan wrote:
> On Tue, Jul 25, 2017 at 08:02:05AM +1000, Dave Chinner wrote:
> > On Tue, Jul 25, 2017 at 01:51:25AM +0800, Eryu Guan wrote:
> > > On Mon, Jul 24, 2017 at 09:05:51AM -0700, Darrick J. Wong wrote:
> > > > On Mon, Jul 24, 2017 at 10:50:19PM +0800, Eryu Guan wrote:
> > > And I'm wondering what's the bigger problem of letting the dio path take
> > > MMAPLOCK too to serialize against mmap page faults? e.g.
> > > xfs_file_dio_aio_read() takes XFS_MMAPLOCK_SHRED and
> > > xfs_filemap_page_mkwrite() takes XFS_MMAPLOCK_EXCL.
> > 
> > direct IO calls get_user_pages() which can trigger page faults and
> > that means we can't hold any lock that is taken in the page fault
> > path.
> 
> Ah, that's what I missed, thanks!
> 
> > 
> > It's the same reason we have the MMAPLOCK in the first place - we
> > can't use the IOLOCK in the page fault path because copy-in/copy-out
> > in the buffered IO path can trigger page faults, hence we need some
> > other lock that we can use to serialise page faults against extent
> > operations (like fallocate).
> > 
> > > > It looks like the end result of a dioread/mmapwrite collision is that
> > > > the dio reader gets -EIO.  Would it be better to return a short read?
> > > 
> > > Yes, right now dio read gets EIO in this case. I can't tell which one is
> > > better, if the whole dio vs mmap is not recommended, EIO seems to be a
> > > strong signal that indicates "don't do this " :)
> > 
> > $ man 2 open
> > .....
> > 	.... Likewise, applications should avoid  mixing  mmap(2)
> > 	of files with direct I/O to the same files.
> > ....
> > 
> > That said, EIO is extremely unfriendly - a short read would be much
> > better as a properly written app will simply try to read the bit it
> > didn't get again, whereas EIO tends to be an indication of severe
> > failure to the application...
> 
> The problem is dio read could hit delalloc blocks on its first read and
> return 0, how can we tell between a short read and a real EOF? I may
> miss something again ..

Well, stat() + lseek(fd, 0, SEEK_CUR) can be used to determine if
the read() started at the current EOF.

But, yeah, the read(2) man page says "return of zero means EOF" but
then muddies the waters by saying "a read with count = 0 will return
zero but have no effect". IOWs, a return of 0 does not /always/ mean
the read was called at/beyond EOF....

Yay?

POSIX defined behaviour can be a real problem at times, especially
when you are using methods that are specifically designed to work
around limitations of the POSIX specification. Like, for example,
applications using direct IO...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
