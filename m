Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753414AbeCUUwS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 16:52:18 -0400
Date: Wed, 21 Mar 2018 13:52:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/9] xfs: don't accept inode buffers with suspicious
 unlinked chains
Message-ID: <20180321205214.GN4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <20180321032136.GQ1757@magnolia>
 <20180321174323.GL11127@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321174323.GL11127@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 01:43:24PM -0400, Brian Foster wrote:
> On Tue, Mar 20, 2018 at 08:21:36PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we're verifying inode buffers, sanity-check the unlinked pointer.
> > We don't want to run the risk of trying to purge something that's
> > obviously broken.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> FYI this doesn't seem to apply to for-next (HEAD is commit
> df79b81b2e)...

Yeah, I think I have some cleaning to do, and then I'll resend this
series with all the fixed up stuff.

--D

> Brian
> 
> >  fs/xfs/libxfs/xfs_inode_buf.c |   10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 4fe17b3..f216d5b 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -93,20 +93,26 @@ xfs_inode_buf_verify(
> >  	bool		readahead)
> >  {
> >  	struct xfs_mount *mp = bp->b_target->bt_mount;
> > +	xfs_agnumber_t	agno;
> >  	int		i;
> >  	int		ni;
> >  
> >  	/*
> >  	 * Validate the magic number and version of every inode in the buffer
> >  	 */
> > +	agno = xfs_daddr_to_agno(mp, XFS_BUF_ADDR(bp));
> >  	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
> >  	for (i = 0; i < ni; i++) {
> >  		int		di_ok;
> >  		xfs_dinode_t	*dip;
> > +		xfs_agino_t	unlinked_ino;
> >  
> >  		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
> > +		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
> >  		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
> > -			xfs_dinode_good_version(mp, dip->di_version);
> > +			xfs_dinode_good_version(mp, dip->di_version) &&
> > +			(unlinked_ino == NULLAGINO ||
> > +			 xfs_verify_agino(mp, agno, unlinked_ino));
> >  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> >  						XFS_ERRTAG_ITOBP_INOTOBP))) {
> >  			if (readahead) {
> > @@ -122,9 +128,9 @@ xfs_inode_buf_verify(
> >  				(unsigned long long)bp->b_bn, i,
> >  				be16_to_cpu(dip->di_magic));
> >  #endif
> > +			return;
> >  		}
> >  	}
> > -	xfs_inobp_check(mp, bp);
> >  }
> >  
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
