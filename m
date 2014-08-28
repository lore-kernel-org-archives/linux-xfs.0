Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BFFE7F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:34:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D60128F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 15:34:18 -0700 (PDT)
Received: from mail-ie0-f182.google.com (mail-ie0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	hBeUYaUox3h5cNoA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 15:34:17 -0700 (PDT)
Received: by mail-ie0-f182.google.com with SMTP id rd18so1845133iec.13
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 15:34:16 -0700 (PDT)
Date: Thu, 28 Aug 2014 15:34:14 -0700
From: Iustin Pop <iustin@google.com>
Subject: Re: [PATCH] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories
Message-ID: <20140828223414.GC29940@google.com>
References: <20140718191314.GB27801@teal.hq.k1024.org>
	<1409199773-16802-1-git-send-email-iusty@k1024.org>
	<20140828093158.GR20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140828093158.GR20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: hch@infradead.org, Iustin Pop <iusty@k1024.org>, xfs@oss.sgi.com

On Don, Aug 28, 2014 at 07:31:58 +1000, Dave Chinner wrote:
> On Wed, Aug 27, 2014 at 09:22:53PM -0700, Iustin Pop wrote:
> > Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
> > targets as regular files: it refuses to change the extent size if
> > extents are allocated. This is wrong for directories, as there the
> > extent size is only used as a default for children.
> > 
> > The patch fixes this by only checking for allocated extents for regular
> > files; it leaves undefined what it means to set an extent size on a
> > non-regular, non-directory inode. Additionally, when setting a non-zero
> > extent size, the appropriate flags (EXTSIZE, respectively EXTSZINHERIT)
> > are enforced for regular files and directories.
> > 
> > Signed-off-by: Iustin Pop <iusty@k1024.org>
> > ---
> >  A patch against xfstests to test for the fixed behaviour will follow
> >  shortly.
> > 
> >  fs/xfs/xfs_ioctl.c | 34 ++++++++++++++++++++++++++--------
> >  1 file changed, 26 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 8bc1bbc..5b9acd2 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1116,14 +1116,32 @@ xfs_ioctl_setattr(
> >  	}
> >  
> >  	if (mask & FSX_EXTSIZE) {
> > -		/*
> > -		 * Can't change extent size if any extents are allocated.
> > -		 */
> > -		if (ip->i_d.di_nextents &&
> > -		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
> > -		     fa->fsx_extsize)) {
> > -			code = XFS_ERROR(EINVAL);	/* EFBIG? */
> > -			goto error_return;
> 
> Doesn't apply to a current 3.17-rc1 tree. Can you update the patch?

Will do, thanks. Is it correct to use git://oss.sgi.com/xfs/xfs, master
branch as what I should rebase it on top of?

> > +		if (S_ISDIR(ip->i_d.di_mode)) {
> > +			/*
> > +			 * Enforce setting the EXTSZINHERIT flag when
> > +			 * a non-zero extent size has been specified.
> > +			 */
> > +			if (fa->fsx_extsize) {
> > +				fa->fsx_xflags |= XFS_XFLAG_EXTSZINHERIT;
> > +			}
> > +		} else if (S_ISREG(ip->i_d.di_mode)) {
> > +			/*
> > +			 * For a regular file, we can't change extent
> > +			 * size if any extents are allocated.
> > +			 */
> > +			if (ip->i_d.di_nextents &&
> > +			    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
> > +			     fa->fsx_extsize)) {
> > +				code = XFS_ERROR(EINVAL);	/* EFBIG? */
> > +				goto error_return;
> > +			}
> > +			/*
> > +			 * Enforce setting the EXTSIZE flag when
> > +			 * a non-zero extent size has been specified.
> > +			 */
> > +			if (fa->fsx_extsize) {
> > +				fa->fsx_xflags |= XFS_XFLAG_EXTSIZE;
> > +			}
> >  		}
> 
> Hmmmm. That's not validating/enforcing the correct use of
> XFS_XFLAG_EXTSIZE or XFS_XFLAG_EXTSZINHERIT, that's setting it
> implicitly based on the type of inode.
> 
> If we are going to enforce this properly, then XFS_XFLAG_EXTSIZE is
> only valid for a regular file, and XFS_XFLAG_EXTSZINHERIT is only
> valid on a directory, and the flags on th einode should only be set
> if the hint is not zero. i.e:
> 
> 	if (mask & FSX_EXTSIZE) {
> 		error = -EINVAL;
> 
> 		/* validate the flags are set appropriately */
> 		if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) &&
> 		    !S_ISREG(ip->i_d.di_mode))
> 			goto error_return;
> 		if ((fa->fsx_xflags & XFS_XFLAG_EXTSZINHERIT) &&
> 		    !S_ISDIR(ip->i_d.di_mode))
> 			goto error_return;

This only prevents invalid flags, but doesn't prevent setting a non-zero
extent_size without the appropriate flag. We already are having this
discussion in the other patch, so I'll defer this to that.

But aside from that, the current code that actually applies the flag
changes (xfs_set_diflags) implicitly drops invalid flags - that's why I
didn't bother to validate the flags here. If we want to do validation,
maybe we should validate (with error, not silently) in that function,
instead of here?

thanks,
iustin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
