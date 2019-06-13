Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38575 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVVQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 17:21:16 -0400
Date: Thu, 13 Jun 2019 17:21:12 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: pagecache locking (was: bcachefs status update) merged)
Message-ID: <20190613212112.GB28171@kmo-pixel>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
 <20190613183625.GA28171@kmo-pixel>
 <AE838C22-1A11-4F93-AB88-80CF009BD301@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE838C22-1A11-4F93-AB88-80CF009BD301@dilger.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 13, 2019 at 03:13:40PM -0600, Andreas Dilger wrote:
> There are definitely workloads that require multiple threads doing non-overlapping
> writes to a single file in HPC.  This is becoming an increasingly common problem
> as the number of cores on a single client increase, since there is typically one
> thread per core trying to write to a shared file.  Using multiple files (one per
> core) is possible, but that has file management issues for users when there are a
> million cores running on the same job/file (obviously not on the same client node)
> dumping data every hour.

Mixed buffered and O_DIRECT though? That profile looks like just buffered IO to
me.

> We were just looking at this exact problem last week, and most of the threads are
> spinning in grab_cache_page_nowait->add_to_page_cache_lru() and set_page_dirty()
> when writing at 1.9GB/s when they could be writing at 5.8GB/s (when threads are
> writing O_DIRECT instead of buffered).  Flame graph is attached for 16-thread case,
> but high-end systems today easily have 2-4x that many cores.

Yeah I've been spending some time on buffered IO performance too - 4k page
overhead is a killer.

bcachefs has a buffered write path that looks up multiple pages at a time and
locks them, and then copies the data to all the pages at once (I stole the idea
from btrfs). It was a very significant performance increase.

https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/fs-io.c#n1498
