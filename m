Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31137 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754792AbcJGUbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 16:31:50 -0400
Date: Fri, 7 Oct 2016 13:31:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 42/63] xfs: add clone file and clone range vfs functions
Message-ID: <20161007203140.GH11241@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520501393.29434.5617758777691039165.stgit@birch.djwong.org>
 <20161007180430.GE58659@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007180430.GE58659@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Oct 07, 2016 at 02:04:30PM -0400, Brian Foster wrote:
> On Thu, Sep 29, 2016 at 08:10:14PM -0700, Darrick J. Wong wrote:
> > Define two VFS functions which allow userspace to reflink a range of
> > blocks between two files or to reflink one file's contents to another.
> > These functions fit the new VFS ioctls that standardize the checking
> > for the btrfs CLONE and CLONE RANGE ioctls.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: Plug into the VFS function pointers instead of handling ioctls
> > directly.
> > ---
> >  fs/xfs/xfs_file.c |  142 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 142 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 025d52f..3db3f34 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -974,6 +974,146 @@ xfs_file_fallocate(
> ...
> > +/* Hook up to the VFS reflink function */
> > +STATIC int
> > +xfs_file_share_range(
> > +	struct file	*file_in,
> > +	loff_t		pos_in,
> > +	struct file	*file_out,
> > +	loff_t		pos_out,
> > +	u64		len)
> > +{
> ...
> > +	/* Wait for the completion of any pending IOs on srcfile */
> > +	ret = xfs_file_wait_for_io(inode_in, pos_in, len);
> > +	if (ret)
> > +		goto out_unlock;
> > +	ret = xfs_file_wait_for_io(inode_out, pos_out, len);
> > +	if (ret)
> > +		goto out_unlock;
> > +
> > +	ret = xfs_reflink_remap_range(XFS_I(inode_in), pos_in, XFS_I(inode_out),
> > +			pos_out, len);
> > +	if (ret < 0)
> > +		goto out_unlock;
> > +
> > +out_unlock:
> 
> Nit: 'out:'

Fixed.

--D

> 
> Brian
> 
> > +	return ret;
> > +}
> > +
> > +STATIC ssize_t
> > +xfs_file_copy_range(
> > +	struct file	*file_in,
> > +	loff_t		pos_in,
> > +	struct file	*file_out,
> > +	loff_t		pos_out,
> > +	size_t		len,
> > +	unsigned int	flags)
> > +{
> > +	int		error;
> > +
> > +	error = xfs_file_share_range(file_in, pos_in, file_out, pos_out,
> > +				     len);
> > +	if (error)
> > +		return error;
> > +	return len;
> > +}
> > +
> > +STATIC int
> > +xfs_file_clone_range(
> > +	struct file	*file_in,
> > +	loff_t		pos_in,
> > +	struct file	*file_out,
> > +	loff_t		pos_out,
> > +	u64		len)
> > +{
> > +	return xfs_file_share_range(file_in, pos_in, file_out, pos_out,
> > +				     len);
> > +}
> >  
> >  STATIC int
> >  xfs_file_open(
> > @@ -1634,6 +1774,8 @@ const struct file_operations xfs_file_operations = {
> >  	.release	= xfs_file_release,
> >  	.fsync		= xfs_file_fsync,
> >  	.fallocate	= xfs_file_fallocate,
> > +	.copy_file_range = xfs_file_copy_range,
> > +	.clone_file_range = xfs_file_clone_range,
> >  };
> >  
> >  const struct file_operations xfs_dir_file_operations = {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
