Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43740 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbeCUSDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 14:03:42 -0400
Date: Wed, 21 Mar 2018 11:03:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/9] xfs: refactor inode buffer verifier error logging
Message-ID: <20180321180336.GH4818@magnolia>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107379476.19571.15155451515464003337.stgit@magnolia>
 <20180321135530.GE11127@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321135530.GE11127@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 09:55:30AM -0400, Brian Foster wrote:
> On Wed, Mar 14, 2018 at 05:29:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When the inode buffer verifier encounters an error, it's much more
> > helpful to print a buffer from the offending inode instead of just the
> > start of the inode chunk buffer.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c |    4 +++-
> >  fs/xfs/xfs_error.c            |   29 ++++++++++++++++++++++++-----
> >  fs/xfs/xfs_error.h            |    3 +++
> >  3 files changed, 30 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 4fe17b3..51019e5 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -115,13 +115,15 @@ xfs_inode_buf_verify(
> >  				return;
> >  			}
> >  
> > -			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> >  #ifdef DEBUG
> >  			xfs_alert(mp,
> >  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
> >  				(unsigned long long)bp->b_bn, i,
> >  				be16_to_cpu(dip->di_magic));
> >  #endif
> > +			xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> > +					__func__, dip, sizeof(*dip),
> > +					NULL);
> 
> Why not continue to pass __this_address? Otherwise looks fine:

On the xfsprogs side it causes weird compilation problems on old gcc,
and since a NULL failaddr maps to __return_address inside
xfs_buf_verifier_error we'll get the desired effect anyway.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  		}
> >  	}
> >  	xfs_inobp_check(mp, bp);
> > diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> > index ccf520f..a63f508 100644
> > --- a/fs/xfs/xfs_error.c
> > +++ b/fs/xfs/xfs_error.c
> > @@ -347,27 +347,32 @@ xfs_corruption_error(
> >   * values, and omit the stack trace unless the error level is tuned high.
> >   */
> >  void
> > -xfs_verifier_error(
> > +xfs_buf_verifier_error(
> >  	struct xfs_buf		*bp,
> >  	int			error,
> > +	const char		*name,
> > +	void			*buf,
> > +	size_t			bufsz,
> >  	xfs_failaddr_t		failaddr)
> >  {
> >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> >  	xfs_failaddr_t		fa;
> > +	int			sz;
> >  
> >  	fa = failaddr ? failaddr : __return_address;
> >  	__xfs_buf_ioerror(bp, error, fa);
> >  
> > -	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
> > +	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx %s",
> >  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> > -		  fa, bp->b_ops->name, bp->b_bn);
> > +		  fa, bp->b_ops->name, bp->b_bn, name);
> >  
> >  	xfs_alert(mp, "Unmount and run xfs_repair");
> >  
> >  	if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
> > +		sz = min_t(size_t, XFS_CORRUPTION_DUMP_LEN, bufsz);
> >  		xfs_alert(mp, "First %d bytes of corrupted metadata buffer:",
> > -				XFS_CORRUPTION_DUMP_LEN);
> > -		xfs_hex_dump(xfs_buf_offset(bp, 0), XFS_CORRUPTION_DUMP_LEN);
> > +				sz);
> > +		xfs_hex_dump(buf, sz);
> >  	}
> >  
> >  	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> > @@ -375,6 +380,20 @@ xfs_verifier_error(
> >  }
> >  
> >  /*
> > + * Warnings specifically for verifier errors.  Differentiate CRC vs. invalid
> > + * values, and omit the stack trace unless the error level is tuned high.
> > + */
> > +void
> > +xfs_verifier_error(
> > +	struct xfs_buf		*bp,
> > +	int			error,
> > +	xfs_failaddr_t		failaddr)
> > +{
> > +	return xfs_buf_verifier_error(bp, error, "", xfs_buf_offset(bp, 0),
> > +			XFS_CORRUPTION_DUMP_LEN, failaddr);
> > +}
> > +
> > +/*
> >   * Warnings for inode corruption problems.  Don't bother with the stack
> >   * trace unless the error level is turned up high.
> >   */
> > diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> > index 7e728c5..ce39134 100644
> > --- a/fs/xfs/xfs_error.h
> > +++ b/fs/xfs/xfs_error.h
> > @@ -26,6 +26,9 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
> >  extern void xfs_corruption_error(const char *tag, int level,
> >  			struct xfs_mount *mp, void *p, const char *filename,
> >  			int linenum, xfs_failaddr_t failaddr);
> > +extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
> > +			const char *name, void *buf, size_t bufsz,
> > +			xfs_failaddr_t failaddr);
> >  extern void xfs_verifier_error(struct xfs_buf *bp, int error,
> >  			xfs_failaddr_t failaddr);
> >  extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
