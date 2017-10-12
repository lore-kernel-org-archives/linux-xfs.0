Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752767AbdJLUo1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 16:44:27 -0400
Date: Thu, 12 Oct 2017 16:44:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: trim writepage mapping to within eof
Message-ID: <20171012204425.GA41824@bfoster.bfoster>
References: <20171012114754.39626-1-bfoster@redhat.com>
 <20171012200550.GH7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012200550.GH7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 01:05:50PM -0700, Darrick J. Wong wrote:
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
> 
> Will throw this into the testing machine.  Is this serious enough to
> push into 4.14?  I'm thinking of doing one more 4.14-fixes next week...
> 

I think it's semi-serious due to, as you're aware, the side effect of
the problem. That said, it's been a regression since v4.6 or so and
detected via a stress workload as opposed to a user report, so it's
apparently not the most prevalent thing.

> ...granted I mostly hear my stomach churning "ye $deities another one of
> these stale writeback blahblah problem workarounds" but this would seem
> to fix a file corruption problem. :(
> 

Heh. :P I guess if it were me I would include it so long as there is
enough time to test, but I wouldn't lose sleep if it landed in v4.15 due
to the above.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

Thanks!

Brian

> --D
> 
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
> > +
> >  /*
> >   * Trim the returned map to the required bounds
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index 851982a..502e0d8 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -208,6 +208,7 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
> >  
> >  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
> >  		xfs_filblks_t len);
> > +void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
> >  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> >  void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
> >  void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 1dbc5cf..3ab6d9d 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -423,7 +423,7 @@ xfs_map_blocks(
> >  				imap);
> >  		if (!error)
> >  			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
> > -		return error;
> > +		goto out_trim;
> >  	}
> >  
> >  #ifdef DEBUG
> > @@ -435,7 +435,9 @@ xfs_map_blocks(
> >  #endif
> >  	if (nimaps)
> >  		trace_xfs_map_blocks_found(ip, offset, count, type, imap);
> > -	return 0;
> > +out_trim:
> > +	xfs_trim_extent_eof(imap, ip);
> > +	return error;
> >  }
> >  
> >  STATIC bool
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
