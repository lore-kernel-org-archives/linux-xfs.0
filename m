Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39336 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdLSUpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:45:08 -0500
Date: Tue, 19 Dec 2017 12:45:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/13] xfs: create structure verifier function for short
 form symlinks
Message-ID: <20171219204504.GD12613@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320954167.30654.14171605803183811747.stgit@magnolia>
 <20171219052758.GR4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219052758.GR4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 04:27:58PM +1100, Dave Chinner wrote:
> On Wed, Dec 13, 2017 at 03:59:01PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a function to check the structure of short form symlink targets.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_shared.h         |    1 +
> >  fs/xfs/libxfs/xfs_symlink_remote.c |   36 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 37 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> > index c6f4eb4..67ccb1a 100644
> > --- a/fs/xfs/libxfs/xfs_shared.h
> > +++ b/fs/xfs/libxfs/xfs_shared.h
> > @@ -143,5 +143,6 @@ bool xfs_symlink_hdr_ok(xfs_ino_t ino, uint32_t offset,
> >  			uint32_t size, struct xfs_buf *bp);
> >  void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
> >  				 struct xfs_inode *ip, struct xfs_ifork *ifp);
> > +xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
> >  
> >  #endif /* __XFS_SHARED_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
> > index b6ef6cb..5d9642e 100644
> > --- a/fs/xfs/libxfs/xfs_symlink_remote.c
> > +++ b/fs/xfs/libxfs/xfs_symlink_remote.c
> > @@ -210,3 +210,39 @@ xfs_symlink_local_to_remote(
> >  	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
> >  					ifp->if_bytes - 1);
> >  }
> > +
> > +/* Verify the consistency of an inline symlink. */
> > +xfs_failaddr_t
> > +xfs_symlink_shortform_verify(
> > +	struct xfs_inode	*ip)
> > +{
> > +	char			*sfp;
> > +	char			*endp;
> > +	struct xfs_ifork	*ifp;
> > +	int			size;
> > +
> > +	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	sfp = (char *)ifp->if_u1.if_data;
> > +	size = ifp->if_bytes;
> > +	endp = sfp + size;
> > +
> > +	/* Zero length symlinks can exist while we're deleting a remote one. */
> > +	if (size == 0)
> > +		return NULL;
> > +
> > +	/* No negative sizes or overly long symlink targets. */
> > +	if (size < 0 || size > XFS_SYMLINK_MAXLEN)
> > +		return __this_address;
> > +
> > +	/* No NULLs in the target either. */
> > +	for (; sfp < endp; sfp++) {
> > +		if (*sfp == 0)
> > +			return __this_address;
> > +	}
> 
> 	if (memchr(sfp, 0, size - 1))
> 		return __this_address;

Fixed.

--D

> Otherwise looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
