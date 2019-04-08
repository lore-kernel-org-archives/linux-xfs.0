Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35383 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfDHRlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 13:41:21 -0400
MIME-Version: 1.0
References: <20190404165737.30889-1-amir73il@gmail.com> <20190404211730.GD26298@dastard>
 <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
 <20190407232728.GF26298@dastard> <CAOQ4uxgD4ErSUtbu0xqb5dSm_tM4J92qt6=hGH8GRc5KNGqP9A@mail.gmail.com>
 <20190408141114.GC15023@quack2.suse.cz>
In-Reply-To: <20190408141114.GC15023@quack2.suse.cz>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 8 Apr 2019 20:41:09 +0300
Message-ID: <CAOQ4uxhxgYASST1k-UaqfbLL9ERquHaKL2jtydB2+iF9aT8SRQ@mail.gmail.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw workload
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>

On Mon, Apr 8, 2019 at 5:11 PM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 08-04-19 12:02:34, Amir Goldstein wrote:
> > On Mon, Apr 8, 2019 at 2:27 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, Apr 05, 2019 at 05:02:33PM +0300, Amir Goldstein wrote:
> > > > On Fri, Apr 5, 2019 at 12:17 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > >
> > > > > On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> > > > > > This patch improves performance of mixed random rw workload
> > > > > > on xfs without relaxing the atomic buffered read/write guaranty
> > > > > > that xfs has always provided.
> > > > > >
> > > > > > We achieve that by calling generic_file_read_iter() twice.
> > > > > > Once with a discard iterator to warm up page cache before taking
> > > > > > the shared ilock and once again under shared ilock.
> > > > >
> > > > > This will race with thing like truncate, hole punching, etc that
> > > > > serialise IO and invalidate the page cache for data integrity
> > > > > reasons under the IOLOCK. These rely on there being no IO to the
> > > > > inode in progress at all to work correctly, which this patch
> > > > > violates. IOWs, while this is fast, it is not safe and so not a
> > > > > viable approach to solving the problem.
> > > > >
> > > >
> > > > This statement leaves me wondering, if ext4 does not takes
> > > > i_rwsem on generic_file_read_iter(), how does ext4 (or any other
> > > > fs for that matter) guaranty buffered read synchronization with
> > > > truncate, hole punching etc?
> > > > The answer in ext4 case is i_mmap_sem, which is read locked
> > > > in the page fault handler.
> > >
> > > Nope, the  i_mmap_sem is for serialisation of /page faults/ against
> > > truncate, holepunching, etc. Completely irrelevant to the read()
> > > path.
> > >
> >
> > I'm at lost here. Why are page faults completely irrelevant to read()
> > path? Aren't full pages supposed to be faulted in on read() after
> > truncate_pagecache_range()?
>
> During read(2), pages are not "faulted in". Just look at
> what generic_file_buffered_read() does. It uses completely separate code to
> add page to page cache, trigger readahead, and possibly call ->readpage() to
> fill the page with data. "fault" path (handled by filemap_fault()) applies
> only to accesses from userspace to mmaps.
>

Oh! thanks for fixing my blind spot.
So if you agree with Dave that ext4, and who knows what other fs,
are vulnerable to populating page cache with stale "uptodate" data,
then it seems to me that also xfs is vulnerable via readahead(2) and
posix_fadvise().
Mind you, I recently added an fadvise f_op, so it could be used by
xfs to synchronize with IOLOCK.

Perhaps a better solution would be for truncate_pagecache_range()
to leave zeroed or Unwritten (i.e. lazy zeroed by read) pages in page
cache. When we have shared pages for files, these pages could be
deduped.

Thanks,
Amir.
