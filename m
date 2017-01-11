Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43946 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdAKI7R (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:59:17 -0500
Date: Wed, 11 Jan 2017 09:59:15 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
Message-ID: <20170111085915.GD16116@quack2.suse.cz>
References: <20170110101745.4841-1-jack@suse.cz>
 <7ecf901b-ecbd-3914-25c3-1f6f6faf3264@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ecf901b-ecbd-3914-25c3-1f6f6faf3264@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Brian Foster <bfoster@redhat.com>

Hi,

On Wed 11-01-17 09:07:51, Vlastimil Babka wrote:
> On 01/10/2017 11:17 AM, Jan Kara wrote:
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
> 
> So the impact is even worse than that, as it's the kernel that is
> actually confused, while the user still gets the impression of memory
> being available.
> According to the reporter, this bug has manifested as anonymous mmap()
> returning with ENOMEM in their workload (some benchmark), which does not
> happen anymore after switching from xfs to ext4.

OK, I've changed the changelog to contain:

... and reportedly also leads to anonymous mmap(2) returning ENOMEM
prematurely.

<snip>

> So this would explain the ENOMEM, and how this bug is a problem for
> workloads that truncate/remove files on xfs, and at the same time rely
> on anonymous mmap(). In that case, these mmaps can apparently start
> failing if there's no other source of sufficient memory pressure to let
> reclaim get rid of the truncated pages on LRU. This should be serious
> enough for a stable backport IMHO.

OK, added CC to stable.
	
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
