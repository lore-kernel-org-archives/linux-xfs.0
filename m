Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43659 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfDHJCq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 05:02:46 -0400
MIME-Version: 1.0
References: <20190404165737.30889-1-amir73il@gmail.com> <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com> <20190407232728.GF26298@dastard>
In-Reply-To: <20190407232728.GF26298@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Apr 2019 12:02:34 +0300
Message-ID: <CAOQ4uxgD4ErSUtbu0xqb5dSm_tM4J92qt6=hGH8GRc5KNGqP9A@mail.gmail.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw workload
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>

On Mon, Apr 8, 2019 at 2:27 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, Apr 05, 2019 at 05:02:33PM +0300, Amir Goldstein wrote:
> > On Fri, Apr 5, 2019 at 12:17 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> > > > This patch improves performance of mixed random rw workload
> > > > on xfs without relaxing the atomic buffered read/write guaranty
> > > > that xfs has always provided.
> > > >
> > > > We achieve that by calling generic_file_read_iter() twice.
> > > > Once with a discard iterator to warm up page cache before taking
> > > > the shared ilock and once again under shared ilock.
> > >
> > > This will race with thing like truncate, hole punching, etc that
> > > serialise IO and invalidate the page cache for data integrity
> > > reasons under the IOLOCK. These rely on there being no IO to the
> > > inode in progress at all to work correctly, which this patch
> > > violates. IOWs, while this is fast, it is not safe and so not a
> > > viable approach to solving the problem.
> > >
> >
> > This statement leaves me wondering, if ext4 does not takes
> > i_rwsem on generic_file_read_iter(), how does ext4 (or any other
> > fs for that matter) guaranty buffered read synchronization with
> > truncate, hole punching etc?
> > The answer in ext4 case is i_mmap_sem, which is read locked
> > in the page fault handler.
>
> Nope, the  i_mmap_sem is for serialisation of /page faults/ against
> truncate, holepunching, etc. Completely irrelevant to the read()
> path.
>

I'm at lost here. Why are page faults completely irrelevant to read()
path? Aren't full pages supposed to be faulted in on read() after
truncate_pagecache_range()? And aren't partial pages supposed
to be partially zeroed and uptodate after truncate_pagecache_range()?

> > And xfs does the same type of synchronization with MMAPLOCK,
> > so while my patch may not be safe, I cannot follow why from your
> > explanation, so please explain if I am missing something.
>
> mmap_sem inversions require independent locks for IO path and page
> faults - the MMAPLOCK does not protect anything in the
> read()/write() IO path.
>
[...]
>
> All you see is this:
>
> truncate:                               read()
>
> IOLOCK_EXCL
>   flush relevant cached data
>   truncate page cache
>                                         pre-read page cache between
>                                         new eof and old eof
>                                         IOLOCK_SHARED
>                                         <blocks>
>   start transaction
>   ILOCK_EXCL
>     update isize
>     remove extents
> ....
>   commit xactn
> IOLOCK unlock
>                                         <gets lock>
>                                         sees beyond EOF, returns 0
>
>
> So you see the read() doing the right thing (detect EOF, returning
> short read). Great.
>
> But what I see is uptodate pages containing stale data being left in
> the page cache beyond EOF. That is th eproblem here - truncate must
> not leave stale pages beyond EOF behind - it's the landmine that
> causes future things to go wrong.
>
> e.g. now the app does post-eof preallocation so the range those
> pages are cached over are allocated as unwritten - the filesystem
> will do this without even looking at the page cache because it's
> beyond EOF.  Now we extend the file past those cached pages, and
> iomap_zero() sees the range as unwritten and so does not write zeros
> to the blocks between the old EOF and the new EOF. Now the app reads
> from that range (say it does a sub-page write, triggering a page
> cache RMW cycle). the read goes to instantiate the page cache page,
> finds a page already in the cache that is uptodate, and uses it
> without zeroing or reading from disk.
>
> And now we have stale data exposure and/or data corruption.
>
> If can come up with quite a few scenarios where this particular
> "populate cache after invalidation" race can cause similar problems
> for XFS. Hole punch and most of the other fallocate extent
> manipulations have the same serialisation requirements - no IO over
> the range of the operation can be *initiated* between the /start/ of
> the page cache invalidation and the end of the specific extent
> manipulation operation.
>
> So how does ext4 avoid this problem on truncate?
>
> History lesson: truncate in Linux (and hence ext4) has traditionally
> been serialised by the hacky post-page-lock checks that are strewn
> all through the page cache and mm/ subsystem. i.e. every time you
> look up and lock a page cache page, you have to check the
> page->mapping and page->index to ensure that the lookup-and-lock
> hasn't raced with truncate. This only works because truncate
> requires the inode size to be updated before invalidating the page
> cache - that's the "hacky" part of it.
>
> IOWs, the burden of detecting truncate races is strewn throughout
> the mm/ subsystem, rather than being the responisibility of the
> filesystem. This is made worse by the fact this mechanism simply
> doesn't work for hole punching because there is no file size change
> to indicate that the page lookup is racing with an in-progress
> invalidation.
>
> That means the mm/ and page cache code is unable to detect hole
> punch races, and so the serialisation of invalidation vs page cache
> instantiation has to be done in the filesystem. And no Linux native
> filesystem had the infrastructure for such serialisation because
> they never had to implement anything to ensure truncate was
> serialised against new and in-progress IO.
>
> The result of this is that, AFAICT, ext4 does not protect against
> read() vs hole punch races - it's hole punching code it does:
>
> Hole Punch:                             read():
>
> inode_lock()
> inode_dio_wait(inode);
> down_write(i_mmap_sem)
> truncate_pagecache_range()
>                                         ext4_file_iter_read()
>                                           ext4_map_blocks()
>                                             down_read(i_data_sem)
>                                              <gets mapping>
>                                         <populates page cache over hole>
>                                         <reads stale data into cache>
>                                         .....
> down_write(i_data_sem)
>   remove extents
>
> IOWs, ext4 is safe against truncate because of the
> change-inode-size-before-invalidation hacks, but the lack of
> serialise buffered reads means that hole punch and other similar
> fallocate based extent manipulations can race against reads....
>

Adding some ext4 folks to comment on the above.
Could it be that those races were already addressed by Lukas' work:
https://lore.kernel.org/patchwork/cover/371861/

Thanks,
Amir.
