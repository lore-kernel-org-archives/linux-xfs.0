Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48443 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932825AbcJGVPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 17:15:50 -0400
Date: Fri, 7 Oct 2016 14:15:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 46/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20161007211540.GI11241@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
 <20161007180506.GF58659@bfoster.bfoster>
 <20161007202639.GG11241@birch.djwong.org>
 <20161007205838.GH58659@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007205838.GH58659@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Fri, Oct 07, 2016 at 04:58:38PM -0400, Brian Foster wrote:
> On Fri, Oct 07, 2016 at 01:26:39PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 07, 2016 at 02:05:07PM -0400, Brian Foster wrote:
> > > On Thu, Sep 29, 2016 at 08:10:39PM -0700, Darrick J. Wong wrote:
> > > > Unshare all shared extents if the user calls fallocate with the new
> > > > unshare mode flag set, so that we can guarantee that a subsequent
> > > > write will not ENOSPC.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > [hch: pass inode instead of file to xfs_reflink_dirty_range,
> > > >       use iomap infrastructure for copy up]
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_file.c    |   10 ++
> > > >  fs/xfs/xfs_reflink.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_reflink.h |    2 
> > > >  3 files changed, 247 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > > index 77ac810..065e836 100644
> > > > --- a/fs/xfs/xfs_reflink.c
> > > > +++ b/fs/xfs/xfs_reflink.c
> > > > @@ -1472,3 +1472,240 @@ xfs_reflink_remap_range(
> > > >  		trace_xfs_reflink_remap_range_error(dest, error, _RET_IP_);
> > > >  	return error;
> > > >  }
> > > ...
> > > > +/* Iterate the extents; if there are no reflinked blocks, clear the flag. */
> > > > +STATIC int
> > > > +xfs_reflink_try_clear_inode_flag(
> > > > +	struct xfs_inode	*ip,
> > > > +	xfs_off_t		old_isize)
> > > > +{
> > > > +	struct xfs_mount	*mp = ip->i_mount;
> > > > +	struct xfs_trans	*tp;
> > > > +	xfs_fileoff_t		fbno;
> > > > +	xfs_filblks_t		end;
> > > > +	xfs_agnumber_t		agno;
> > > > +	xfs_agblock_t		agbno;
> > > > +	xfs_extlen_t		aglen;
> > > > +	xfs_agblock_t		rbno;
> > > > +	xfs_extlen_t		rlen;
> > > > +	struct xfs_bmbt_irec	map[2];
> > > > +	int			nmaps;
> > > > +	int			error = 0;
> > > > +
> > > > +	/* Start a rolling transaction to remove the mappings */
> > > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > +	xfs_trans_ijoin(tp, ip, 0);
> > > > +
> > > > +	if (old_isize != i_size_read(VFS_I(ip)))
> > > > +		goto cancel;
> > > > +	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK))
> > > > +		goto cancel;
> > > > +
> > > 
> > > The code that has been merged is now different from this code :/, but
> > > just a heads up that the code in the tree looks like it has another one
> > > of those potentially blind transaction commit sequences between
> > > xfs_reflink_try_clear_inode_flag() and xfs_reflink_clear_inode_flag().
> > 
> > _reflink_unshare jumps out if it's not a reflink inode before
> > calling _reflink_try_clear_inode_flag -> _reflink_clear_inode_flag.
> > We do not call _reflink_clear_inode_flag with a non-reflink inode.
> > As for blindly committing a transaction with no dirty data, that's
> > fine, _trans_commit checks for that case and simply frees everything
> > attached to the transaction.
> > 
> 
> Yeah, I saw that. That's what I was alluding to below wrt to the usage
> being fine in the patch. It's just the pattern that's used that stands
> out.
> 
> With regard to the transaction.. sure, that situation may not be broken,
> but it's still not ideal if it's a log reservation we didn't have to
> make in the first place.

Yeah.  We must hold the ilock from the start of the extent iteration
until we clear (or not) the inode flag, but we have to allocate the
transaction before grabbing the ilock.  In other words, we don't know if
we need the transaction until it's too late to get one, hence this
suboptimal thing where we sometimes get a reservation and never commit
anything.  I don't know of any way to avoid that.

--D

> > > It doesn't appear to be a problem in how it is actually used in this
> > > patch, but for reference, I think it's better practice for lower level
> > > functions like xfs_reflink_clear_inode_flag() to assert that the flag is
> > > set and make it the responsibility of the caller to check for it and do
> > > the right thing. Just my .02 though.
> > 
> > Ok, I'll add an assert.
> > 
> ...
> > > > +		}
> > > > +
> > > > +next:
> > > > +		fbno = map[0].br_startoff + map[0].br_blockcount;
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * We didn't find any shared blocks so turn off the reflink flag.
> > > > +	 * First, get rid of any leftover CoW mappings.
> > > > +	 */
> > > > +	error = xfs_reflink_cancel_cow_blocks(ip, &tp, 0, NULLFILEOFF);
> > > > +	if (error)
> > > > +		goto cancel;
> > > > +
> > > > +	/* Clear the inode flag. */
> > > > +	trace_xfs_reflink_unset_inode_flag(ip);
> > > > +	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> > > > +	xfs_trans_ijoin(tp, ip, 0);
> > > > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > > > +
> > > > +	error = xfs_trans_commit(tp);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > +	return 0;
> > > > +cancel:
> > > > +	xfs_trans_cancel(tp);
> > > > +out:
> > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > +	return error;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Pre-COW all shared blocks within a given byte range of a file and turn off
> > > > + * the reflink flag if we unshare all of the file's blocks.
> > > > + */
> > > > +int
> > > > +xfs_reflink_unshare(
> > > > +	struct xfs_inode	*ip,
> > > > +	xfs_off_t		offset,
> > > > +	xfs_off_t		len)
> > > > +{
> > > > +	struct xfs_mount	*mp = ip->i_mount;
> > > > +	xfs_fileoff_t		fbno;
> > > > +	xfs_filblks_t		end;
> > > > +	xfs_off_t		old_isize, isize;
> > > > +	int			error;
> > > > +
> > > > +	if (!xfs_is_reflink_inode(ip))
> > > > +		return 0;
> > > > +
> > > > +	trace_xfs_reflink_unshare(ip, offset, len);
> > > > +
> > > > +	inode_dio_wait(VFS_I(ip));
> > > > +
> > > > +	/* Try to CoW the selected ranges */
> > > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > > +	fbno = XFS_B_TO_FSB(mp, offset);
> > > 
> > > XFS_B_TO_FSBT() ?
> > > 
> > > > +	old_isize = isize = i_size_read(VFS_I(ip));
> > > > +	end = XFS_B_TO_FSB(mp, offset + len);
> > > > +	error = xfs_reflink_dirty_extents(ip, fbno, end, isize);
> > > > +	if (error)
> > > > +		goto out_unlock;
> > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > +
> > > > +	/* Wait for the IO to finish */
> > > > +	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
> > > > +	if (error)
> > > > +		goto out;
> > > > +
> > > > +	/* Turn off the reflink flag if we unshared the whole file */
> > > > +	if (offset == 0 && len == isize) {
> > > 
> > > Isn't this valid if len is larger than isize (similar check in
> > > xfs_reflink_try_clear_inode_flag() might defeat this as well)?
> > > 
> > > FWIW, this has a similar issue as the earlier truncate code in that we
> > > might just unshare the shared regions and thus retain the flag.
> > 
> > Yes, it is suboptimal for the flag to be set when there are no shared
> > extents.  I'm not sure when is a good opportunity to try to turn off the
> > flag -- certainly we don't want to do that after every CoW operation.
> 
> Indeed..
> 
> > Doing it as part of a fallocate operation seems reasonable enough.
> > Prior to the removal of the UNSHARE flag it would try to clear the flag
> > any time the user asked for an unshare, but when I removed the flag from
> > the interface I decided we should only do that if the user fallocated
> > the entire file.
> > 
> > Now that UNSHARE has been re-added to the interface, I'll just take out
> > these weird checks.  Note that the upcoming online repair patchset will
> > try to unset the flag.
> > 
> 
> Ok, it sounds reasonable to me to try the removal on fallocate.
> 
> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > +		error = xfs_reflink_try_clear_inode_flag(ip, old_isize);
> > > > +		if (error)
> > > > +			goto out;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +
> > > > +out_unlock:
> > > > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > +out:
> > > > +	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
> > > > +	return error;
> > > > +}
> > > > diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
> > > > index df82b20..ad4fc61 100644
> > > > --- a/fs/xfs/xfs_reflink.h
> > > > +++ b/fs/xfs/xfs_reflink.h
> > > > @@ -48,5 +48,7 @@ extern int xfs_reflink_recover_cow(struct xfs_mount *mp);
> > > >  extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
> > > >  		struct xfs_inode *dest, xfs_off_t destoff, xfs_off_t len,
> > > >  		unsigned int flags);
> > > > +extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
> > > > +		xfs_off_t len);
> > > >  
> > > >  #endif /* __XFS_REFLINK_H */
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
