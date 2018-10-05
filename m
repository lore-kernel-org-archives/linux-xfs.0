Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:25594 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727823AbeJEQAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 12:00:34 -0400
Date: Fri, 5 Oct 2018 19:02:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181005090242.GF12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
 <20181005070228.GE12041@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005070228.GE12041@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Fri, Oct 05, 2018 at 05:02:28PM +1000, Dave Chinner wrote:
> On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor all the reflink preparation steps into a separate helper that
> > we'll use to land all the upcoming fixes for insufficient input checks.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> 
> > +xfs_reflink_remap_range(
> > +	struct file		*file_in,
> > +	loff_t			pos_in,
> > +	struct file		*file_out,
> > +	loff_t			pos_out,
> > +	u64			len,
> > +	bool			is_dedupe)
> > +{
> > +	struct inode		*inode_in = file_inode(file_in);
> > +	struct xfs_inode	*src = XFS_I(inode_in);
> > +	struct inode		*inode_out = file_inode(file_out);
> > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > +	struct xfs_mount	*mp = src->i_mount;
> > +	xfs_fileoff_t		sfsbno, dfsbno;
> > +	xfs_filblks_t		fsblen;
> > +	xfs_extlen_t		cowextsize;
> > +	ssize_t			ret;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return -EIO;
> > +
> > +	/* Prepare and then clone file data. */
> > +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> > +			len, is_dedupe);

More than one bug. vfs_clone_file_prep_inodes() modifes the length
parameter in the case of whole file reflink by way of "len == 0"
on a non-zero length file. So I fixed this, too.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
