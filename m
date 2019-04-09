Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbfDII0I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 04:26:08 -0400
Date: Tue, 9 Apr 2019 10:26:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw
 workload
Message-ID: <20190409082605.GA8107@quack2.suse.cz>
References: <20190404165737.30889-1-amir73il@gmail.com>
 <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
 <20190407232728.GF26298@dastard>
 <CAOQ4uxgD4ErSUtbu0xqb5dSm_tM4J92qt6=hGH8GRc5KNGqP9A@mail.gmail.com>
 <20190408141114.GC15023@quack2.suse.cz>
 <CAOQ4uxhxgYASST1k-UaqfbLL9ERquHaKL2jtydB2+iF9aT8SRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhxgYASST1k-UaqfbLL9ERquHaKL2jtydB2+iF9aT8SRQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>

On Mon 08-04-19 20:41:09, Amir Goldstein wrote:
> On Mon, Apr 8, 2019 at 5:11 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Mon 08-04-19 12:02:34, Amir Goldstein wrote:
> > > On Mon, Apr 8, 2019 at 2:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Fri, Apr 05, 2019 at 05:02:33PM +0300, Amir Goldstein wrote:
> > > > > On Fri, Apr 5, 2019 at 12:17 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > >
> > > > > > On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> > > > > > > This patch improves performance of mixed random rw workload
> > > > > > > on xfs without relaxing the atomic buffered read/write guaranty
> > > > > > > that xfs has always provided.
> > > > > > >
> > > > > > > We achieve that by calling generic_file_read_iter() twice.
> > > > > > > Once with a discard iterator to warm up page cache before taking
> > > > > > > the shared ilock and once again under shared ilock.
> > > > > >
> > > > > > This will race with thing like truncate, hole punching, etc that
> > > > > > serialise IO and invalidate the page cache for data integrity
> > > > > > reasons under the IOLOCK. These rely on there being no IO to the
> > > > > > inode in progress at all to work correctly, which this patch
> > > > > > violates. IOWs, while this is fast, it is not safe and so not a
> > > > > > viable approach to solving the problem.
> > > > > >
> > > > >
> > > > > This statement leaves me wondering, if ext4 does not takes
> > > > > i_rwsem on generic_file_read_iter(), how does ext4 (or any other
> > > > > fs for that matter) guaranty buffered read synchronization with
> > > > > truncate, hole punching etc?
> > > > > The answer in ext4 case is i_mmap_sem, which is read locked
> > > > > in the page fault handler.
> > > >
> > > > Nope, the  i_mmap_sem is for serialisation of /page faults/ against
> > > > truncate, holepunching, etc. Completely irrelevant to the read()
> > > > path.
> > > >
> > >
> > > I'm at lost here. Why are page faults completely irrelevant to read()
> > > path? Aren't full pages supposed to be faulted in on read() after
> > > truncate_pagecache_range()?
> >
> > During read(2), pages are not "faulted in". Just look at
> > what generic_file_buffered_read() does. It uses completely separate code to
> > add page to page cache, trigger readahead, and possibly call ->readpage() to
> > fill the page with data. "fault" path (handled by filemap_fault()) applies
> > only to accesses from userspace to mmaps.
> >
> 
> Oh! thanks for fixing my blind spot.
> So if you agree with Dave that ext4, and who knows what other fs,
> are vulnerable to populating page cache with stale "uptodate" data,

Not that many filesystems support punching holes but you're right.

> then it seems to me that also xfs is vulnerable via readahead(2) and
> posix_fadvise().

Yes, this is correct AFAICT.

> Mind you, I recently added an fadvise f_op, so it could be used by
> xfs to synchronize with IOLOCK.

And yes, this should work.

> Perhaps a better solution would be for truncate_pagecache_range()
> to leave zeroed or Unwritten (i.e. lazy zeroed by read) pages in page
> cache. When we have shared pages for files, these pages could be
> deduped.

No, I wouldn't really mess with sharing pages due to this. It would be hard
to make that scale resonably and would be rather complex. We really need a
proper and reasonably simple synchronization mechanism between operations
removing blocks from inode and operations filling in page cache of the
inode. Page lock was supposed to provide this but doesn't quite work
because hole punching first remove pagecache pages and then go removing all
blocks.

So I agree with Dave that going for range lock is really the cleanest way
forward here without causing big regressions for mixed rw workloads. I'm
just thinking how to best do that without introducing lot of boilerplate
code into each filesystem.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
