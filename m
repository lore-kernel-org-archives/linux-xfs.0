Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:32918 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfDEOCq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Apr 2019 10:02:46 -0400
MIME-Version: 1.0
References: <20190404165737.30889-1-amir73il@gmail.com> <20190404211730.GD26298@dastard>
In-Reply-To: <20190404211730.GD26298@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Apr 2019 17:02:33 +0300
Message-ID: <CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com>
Subject: Re: [POC][PATCH] xfs: reduce ilock contention on buffered randrw workload
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 5, 2019 at 12:17 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Apr 04, 2019 at 07:57:37PM +0300, Amir Goldstein wrote:
> > This patch improves performance of mixed random rw workload
> > on xfs without relaxing the atomic buffered read/write guaranty
> > that xfs has always provided.
> >
> > We achieve that by calling generic_file_read_iter() twice.
> > Once with a discard iterator to warm up page cache before taking
> > the shared ilock and once again under shared ilock.
>
> This will race with thing like truncate, hole punching, etc that
> serialise IO and invalidate the page cache for data integrity
> reasons under the IOLOCK. These rely on there being no IO to the
> inode in progress at all to work correctly, which this patch
> violates. IOWs, while this is fast, it is not safe and so not a
> viable approach to solving the problem.
>

This statement leaves me wondering, if ext4 does not takes
i_rwsem on generic_file_read_iter(), how does ext4 (or any other
fs for that matter) guaranty buffered read synchronization with
truncate, hole punching etc?
The answer in ext4 case is i_mmap_sem, which is read locked
in the page fault handler.

And xfs does the same type of synchronization with MMAPLOCK,
so while my patch may not be safe, I cannot follow why from your
explanation, so please explain if I am missing something.

One thing that Darrick mentioned earlier was that IOLOCK is also
used by xfs to synchronization pNFS leases (probably listed under
'etc' in your explanation). I consent that my patch does not look safe
w.r.t pNFS leases, but that can be sorted out with a hammer
#ifndef CONFIG_EXPORTFS_BLOCK_OPS
or with finer instruments.

> FYI, I'm working on a range lock implementation that should both
> solve the performance issue and the reader starvation issue at the
> same time by allowing concurrent buffered reads and writes to
> different file ranges.
>
> IO range locks will allow proper exclusion for other extent
> manipulation operations like fallocate and truncate, and eventually
> even allow truncate, hole punch, file extension, etc to run
> concurrently with other non-overlapping IO. They solve more than
> just the performance issue you are seeing....
>

I'm glad to hear that. IO range locks are definitely a more wholesome
solution to the problem looking forward.

However, I am still interested to continue the discussion on my POC
patch. One reason is that I am guessing it would be much easier for
distros to backport and pick up to solve performance issues.

Even if my patch doesn't get applied upstream nor picked by distros,
I would still like to understand its flaws and limitations. I know...
if I break it, I get to keep the pieces, but the information that you
provide helps me make my risk assessments.

Thanks,
Amir.
