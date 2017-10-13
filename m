Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbdJMLmd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Oct 2017 07:42:33 -0400
Date: Fri, 13 Oct 2017 07:42:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: trim writepage mapping to within eof
Message-ID: <20171013114231.GA44461@bfoster.bfoster>
References: <20171012114754.39626-1-bfoster@redhat.com>
 <20171012212244.GT15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012212244.GT15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2017 at 08:22:44AM +1100, Dave Chinner wrote:
> On Thu, Oct 12, 2017 at 07:47:54AM -0400, Brian Foster wrote:
> > The writeback rework in commit fbcc02561359 ("xfs: Introduce
> > writeback context for writepages") introduced a subtle change in
> > behavior with regard to the block mapping used across the
> > ->writepages() sequence. The previous xfs_cluster_write() code would
> > only flush pages up to EOF at the time of the writepage, thus
> > ensuring that any pages due to file-extending writes would be
> > handled on a separate cycle and with a new, updated block mapping.
> > 
> > The updated code establishes a block mapping in xfs_writepage_map()
> > that could extend beyond EOF if the file has post-eof preallocation.
> > Because we now use the generic writeback infrastructure and pass the
> > cached mapping to each writepage call, there is no implicit EOF
> > limit in place. If eofblocks trimming occurs during ->writepages(),
> > any post-eof portion of the cached mapping becomes invalid. The
> > eofblocks code has no means to serialize against writeback because
> > there are no pages associated with post-eof blocks. Therefore if an
> > eofblocks trim occurs and is followed by a file-extending buffered
> > write, not only has the mapping become invalid, but we could end up
> > writing a page to disk based on the invalid mapping.
> > 
> > Consider the following sequence of events:
> > 
> > - A buffered write creates a delalloc extent and post-eof
> >   speculative preallocation.
> > - Writeback starts and on the first writepage cycle, the delalloc
> >   extent is converted to real blocks (including the post-eof blocks)
> >   and the mapping is cached.
> > - The file is closed and xfs_release() trims post-eof blocks. The
> >   cached writeback mapping is now invalid.
> > - Another buffered write appends the file with a delalloc extent.
> > - The concurrent writeback cycle picks up the just written page
> >   because the writeback range end is LLONG_MAX. xfs_writepage_map()
> >   attributes it to the (now invalid) cached mapping and writes the
> >   data to an incorrect location on disk (and where the file offset is
> >   still backed by a delalloc extent).
> > 
> > This problem is reproduced by xfstests test generic/463, which
> > triggers racing writes, appends, open/closes and writeback requests.
> > 
> > To address this problem, trim the mapping used during writeback to
> > within EOF when the mapping is created. This ensures the mapping is
> > revalidated for any pages encountered beyond EOF as of the time the
> > current mapping was cached.
> > 
> > Reported-by: Eryu Guan <eguan@redhat.com>
> > Diagnosed-by: Eryu Guan <eguan@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Hi all,
> > 
> > This is a followup to the issue Eryu tracked down, described here[1].
> > 
> > Note that this patch will not deal with any writeback mapping validity
> > issues not associated with eofblocks management. Dave is working on a
> > more generic approach to deal with such problems. This patch is intended
> > to be a targeted and backportable fix for the regression in the
> > writeback code.
> > 
> > Brian
> > 
> > [1] https://marc.info/?l=linux-xfs&m=150406724427829&w=2
> > 
> >  fs/xfs/libxfs/xfs_bmap.c | 11 +++++++++++
> >  fs/xfs/libxfs/xfs_bmap.h |  1 +
> >  fs/xfs/xfs_aops.c        |  6 ++++--
> >  3 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 044a363..dd3fb7b 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3852,6 +3852,17 @@ xfs_trim_extent(
> >  	}
> >  }
> >  
> > +/* trim extent to within eof */
> > +void
> > +xfs_trim_extent_eof(
> > +	struct xfs_bmbt_irec	*irec,
> > +	struct xfs_inode	*ip)
> > +
> > +{
> > +	xfs_trim_extent(irec, 0, XFS_B_TO_FSB(ip->i_mount,
> > +					      i_size_read(VFS_I(ip))));
> > +}
> 
> Ok, so it's an unlocked, instantaneous sample of the inode size.
> Truncate can race with this and still occur any time after we've
> trimmed the extent but still have it cached.
> 

Yeah, but note that this is really only intended to deal with writeback
racing with eofblocks trimming. I'm not sure we can fully close any
other truncate/writeback issues without your broader, more generic
mapping invalidation work.

With regard to eofblocks trimming, I don't think it can hurt us once
we've trimmed the cached mapping once. Any new eofblocks that come in
due to new buffered writes aren't discovered until we acquire a new
mapping. Truncates up or down before we actually trim the cached mapping
basically also rule out eofblocks trims on file release causing a
problem for the writeback cycle.

> As such, I'm thinking this EOF trimming it should be put in
> xfs_imap_valid() - not xfs_map_blocks() - so it gets revalidated
> every time we check to see if the map covers the current file
> extent...
> 

I'm not sure it's necessary, but it seems Ok to me to be slightly more
aggressive in the validation as long as it's clear (which I think it is
;P) that it isn't intended to technically close any issues unrelated to
eofblocks. I'll give it a shot.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
