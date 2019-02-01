Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfBARkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 12:40:41 -0500
Date: Fri, 1 Feb 2019 09:40:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 1/6] xfs: eof trim writeback mapping as soon as it is
 cached
Message-ID: <20190201174026.GH5761@magnolia>
References: <20190123184131.46188-1-bfoster@redhat.com>
 <20190123184131.46188-2-bfoster@redhat.com>
 <20190201075829.GB22295@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201075829.GB22295@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 11:58:29PM -0800, Christoph Hellwig wrote:
> Darrick,
> 
> can we get this queue up for 5.0?

Ok, I'll give it a test run.

--D

> On Wed, Jan 23, 2019 at 01:41:26PM -0500, Brian Foster wrote:
> > The cached writeback mapping is EOF trimmed to try and avoid races
> > between post-eof block management and writeback that result in
> > sending cached data to a stale location. The cached mapping is
> > currently trimmed on the validation check, which leaves a race
> > window between the time the mapping is cached and when it is trimmed
> > against the current inode size.
> > 
> > For example, if a new mapping is cached by delalloc conversion on a
> > blocksize == page size fs, we could cycle various locks, perform
> > memory allocations, etc.  in the writeback codepath before the
> > associated mapping is eventually trimmed to i_size. This leaves
> > enough time for a post-eof truncate and file append before the
> > cached mapping is trimmed. The former event essentially invalidates
> > a range of the cached mapping and the latter bumps the inode size
> > such the trim on the next writepage event won't trim all of the
> > invalid blocks. fstest generic/464 reproduces this scenario
> > occasionally and causes a lost writeback and stale delalloc blocks
> > warning on inode inactivation.
> > 
> > To work around this problem, trim the cached writeback mapping as
> > soon as it is cached in addition to on subsequent validation checks.
> > This is a minor tweak to tighten the race window as much as possible
> > until a proper invalidation mechanism is available.
> > 
> > Fixes: 40214d128e07 ("xfs: trim writepage mapping to within eof")
> > Cc: <stable@vger.kernel.org> # v4.14+
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 338b9d9984e0..d9048bcea49c 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -449,6 +449,7 @@ xfs_map_blocks(
> >  	}
> >  
> >  	wpc->imap = imap;
> > +	xfs_trim_extent_eof(&wpc->imap, ip);
> >  	trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
> >  	return 0;
> >  allocate_blocks:
> > @@ -459,6 +460,7 @@ xfs_map_blocks(
> >  	ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
> >  	       imap.br_startoff + imap.br_blockcount <= cow_fsb);
> >  	wpc->imap = imap;
> > +	xfs_trim_extent_eof(&wpc->imap, ip);
> >  	trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
> >  	return 0;
> >  }
> > -- 
> > 2.17.2
> > 
> ---end quoted text---
