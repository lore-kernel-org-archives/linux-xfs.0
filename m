Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdLSUkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:40:03 -0500
Date: Tue, 19 Dec 2017 12:34:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/13] xfs: move inode fork verifiers to xfs_dinode_verify
Message-ID: <20171219203459.GB12613@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320952955.30654.5858027812526222455.stgit@magnolia>
 <20171219051619.GP4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219051619.GP4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 04:16:19PM +1100, Dave Chinner wrote:
> On Wed, Dec 13, 2017 at 03:58:49PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Consolidate the fork size and format verifiers to xfs_dinode_verify so
> > that we can reject bad inodes earlier and in a single place.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c  |   72 ++++++++++++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_inode_fork.c |   86 ----------------------------------------
> >  2 files changed, 69 insertions(+), 89 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 0e4c720..1392fe9 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -390,6 +390,7 @@ xfs_dinode_verify(
> >  	uint16_t		mode;
> >  	uint16_t		flags;
> >  	uint64_t		flags2;
> > +	uint64_t		di_size;
> >  
> >  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
> >  		return __this_address;
> > @@ -408,7 +409,8 @@ xfs_dinode_verify(
> >  	}
> >  
> >  	/* don't allow invalid i_size */
> > -	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
> > +	di_size = be64_to_cpu(dip->di_size);
> > +	if (di_size & (1ULL << 63))
> >  		return __this_address;
> >  
> >  	mode = be16_to_cpu(dip->di_mode);
> > @@ -416,14 +418,74 @@ xfs_dinode_verify(
> >  		return __this_address;
> >  
> >  	/* No zero-length symlinks/dirs. */
> > -	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
> > +	if ((S_ISLNK(mode) || S_ISDIR(mode)) && di_size == 0)
> >  		return __this_address;
> >  
> > +	/* Fork checks carried over from xfs_iformat_fork */
> > +	if (mode &&
> > +	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> > +	    be64_to_cpu(dip->di_nblocks))
> 
> Can you indent this last line so it doesn't look like a spearate
> logic check?

Done.

> 	if (mode &&
> 	    be32_to_cpu(dip->di_nextents) + be16_to_cpu(dip->di_anextents) >
> 				be64_to_cpu(dip->di_nblocks))
> > +		return __this_address;
> > +
> > +	if (mode && dip->di_forkoff > mp->m_sb.sb_inodesize)
> > +		return __this_address;
> 
> Hold on, this check is completely bogus. di_forkoff is in units of 8 bytes,
> which inode size is in bytes. Also, di_forkoff is a u8, so it can't
> /ever/ be larger than the inode size which are >= 256 bytes. Yeah,
> though so:
> 
> #define XFS_DFORK_BOFF(dip)             ((int)((dip)->di_forkoff << 3))
> 
> This check needs to be:
> 
> 	if (mode && XFS_DFORK_BOFF(dip) > mp->m_sb.sb_inodesize)
> 		return __this_address;
> 
> Otherwise looks good.

Oops, thank you for catching that!

--D

> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
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
