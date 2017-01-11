Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43860 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933339AbdAKI5b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:57:31 -0500
Date: Wed, 11 Jan 2017 09:57:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
Message-ID: <20170111085728.GC16116@quack2.suse.cz>
References: <20170110101745.4841-1-jack@suse.cz>
 <20170110124320.GA3321@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170110124320.GA3321@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Vlastimil Babka <vbabka@suse.cz>

On Tue 10-01-17 07:43:20, Brian Foster wrote:
> On Tue, Jan 10, 2017 at 11:17:45AM +0100, Jan Kara wrote:
> > Commit 99579ccec4e2 "xfs: skip dirty pages in ->releasepage()" started
> > to skip dirty pages in xfs_vm_releasepage() which also has the effect
> > that if a dirty page is truncated, it does not get freed by
> > block_invalidatepage() and is lingering in LRU list waiting for reclaim.
> > So a simple loop like:
> > 
> > while true; do
> > 	dd if=/dev/zero of=file bs=1M count=100
> > 	rm file
> > done
> > 
> > will keep using more and more memory until we hit low watermarks and
> > start pagecache reclaim which will eventually reclaim also the truncate
> > pages. Keeping these truncated (and thus never usable) pages in memory
> > is just a waste of memory, is unnecessarily stressing page cache
> > reclaim, and is also confusing users thinking they are running out of
> > memory.
> > 
> > So instead of just skipping dirty pages in xfs_vm_releasepage(), return
> > to old behavior of skipping them only if they have delalloc or unwritten
> > buffers and fix the spurious warnings by warning only if the page is
> > clean.
> > 
> > CC: Brian Foster <bfoster@redhat.com>
> > CC: Vlastimil Babka <vbabka@suse.cz>
> > Reported-by: Petr Tůma <petr.tuma@d3s.mff.cuni.cz>
> > Fixes: 99579ccec4e271c3d4d4e7c946058766812afdab
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> Ugh, so this is closer to the alternative I was considering at the time
> this was posted. Thanks for the fix. The code looks fine, I'd just like
> to update the comment...

OK, done.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
