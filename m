Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58890 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfE1QfH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 12:35:07 -0400
Date: Tue, 28 May 2019 09:34:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 7/8] vfs: allow copy_file_range to copy across devices
Message-ID: <20190528163425.GH5221@magnolia>
References: <20190526061100.21761-1-amir73il@gmail.com>
 <20190526061100.21761-8-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526061100.21761-8-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-api@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Sun, May 26, 2019 at 09:10:58AM +0300, Amir Goldstein wrote:
> We want to enable cross-filesystem copy_file_range functionality
> where possible, so push the "same superblock only" checks down to
> the individual filesystem callouts so they can make their own
> decisions about cross-superblock copy offload and fallack to
> generic_copy_file_range() for cross-superblock copy.
> 
> [Amir] We do not call ->remap_file_range() in case the inodes are not
> on the same sb and do not call ->copy_file_range() in case the inodes
> are not on the same filesystem type.
> 
> This changes behavior of the copy_file_range(2) syscall, which will
> now allow cross filesystem in-kernel copy.  CIFS already supports
> cross-superblock copy, between two shares to the same server. This
> functionality will now be available via the copy_file_range(2) syscall.
> 
> Cc: Steve French <stfrench@microsoft.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/ceph/file.c    |  4 +++-
>  fs/cifs/cifsfs.c  |  2 +-
>  fs/fuse/file.c    |  5 ++++-
>  fs/nfs/nfs4file.c |  5 ++++-
>  fs/read_write.c   | 20 ++++++++++++++------
>  5 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 54cfc877a6ef..adf99557c46c 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1909,6 +1909,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  
>  	if (src_inode == dst_inode)
>  		return -EINVAL;
> +	if (src_inode->i_sb != dst_inode->i_sb)
> +		return -EXDEV;
>  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>  		return -EROFS;
>  
> @@ -2118,7 +2120,7 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	ret = __ceph_copy_file_range(src_file, src_off, dst_file, dst_off,
>  				     len, flags);
>  
> -	if (ret == -EOPNOTSUPP)
> +	if (ret == -EOPNOTSUPP || ret == -EXDEV)
>  		ret = generic_copy_file_range(src_file, src_off, dst_file,
>  					      dst_off, len, flags);
>  	return ret;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e103b499aaa8..7bde046110ce 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1152,7 +1152,7 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
>  					len, flags);
>  	free_xid(xid);
>  
> -	if (rc == -EOPNOTSUPP)
> +	if (rc == -EOPNOTSUPP || rc == -EXDEV)
>  		rc = generic_copy_file_range(src_file, off, dst_file,
>  					     destoff, len, flags);
>  	return rc;
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 3531d4a3d9ec..180161f6f0bd 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3126,6 +3126,9 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (fc->no_copy_file_range)
>  		return -EOPNOTSUPP;
>  
> +	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +		return -EXDEV;
> +
>  	inode_lock(inode_out);
>  
>  	err = generic_copy_file_range_prep(file_in, file_out);
> @@ -3186,7 +3189,7 @@ static ssize_t fuse_copy_file_range(struct file *src_file, loff_t src_off,
>  	ret = __fuse_copy_file_range(src_file, src_off, dst_file, dst_off,
>  				     len, flags);
>  
> -	if (ret == -EOPNOTSUPP)
> +	if (ret == -EOPNOTSUPP || ret == -EXDEV)
>  		ret = generic_copy_file_range(src_file, src_off, dst_file,
>  					      dst_off, len, flags);
>  	return ret;
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 4842f3ab3161..f4157eb1f69d 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -133,6 +133,9 @@ static ssize_t __nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  				      struct file *file_out, loff_t pos_out,
>  				      size_t count, unsigned int flags)
>  {
> +	/* Only offload copy if superblock is the same */
> +	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +		return -EXDEV;
>  	if (!nfs_server_capable(file_inode(file_out), NFS_CAP_COPY))
>  		return -EOPNOTSUPP;
>  	if (file_inode(file_in) == file_inode(file_out))
> @@ -148,7 +151,7 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  
>  	ret = __nfs4_copy_file_range(file_in, pos_in, file_out, pos_out, count,
>  				     flags);
> -	if (ret == -EOPNOTSUPP)
> +	if (ret == -EOPNOTSUPP || ret == -EXDEV)
>  		ret = generic_copy_file_range(file_in, pos_in, file_out,
>  					      pos_out, count, flags);
>  	return ret;
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 4b23a86aacd9..283ec30d2136 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1640,7 +1640,18 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
>  				  struct file *file_out, loff_t pos_out,
>  				  size_t len, unsigned int flags)
>  {
> -	if (file_out->f_op->copy_file_range)
> +	/*
> +	 * Although we now allow filesystems to handle cross sb copy, passing
> +	 * an inode of the wrong filesystem type to filesystem operation can
> +	 * often result in an attempt to dereference the wrong concrete inode
> +	 * struct, so avoid doing that until we really have a good reason.
> +	 * The incentive for passing inode from different sb to filesystem is
> +	 * NFS cross server copy and for that use case, enforcing same
> +	 * filesystem type is acceptable.
> +	 */
> +	if (file_out->f_op->copy_file_range &&
> +	    file_inode(file_in)->i_sb->s_type ==
> +	    file_inode(file_out)->i_sb->s_type)
>  		return file_out->f_op->copy_file_range(file_in, pos_in,
>  						       file_out, pos_out,
>  						       len, flags);
> @@ -1663,10 +1674,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (flags != 0)
>  		return -EINVAL;
>  
> -	/* this could be relaxed once a method supports cross-fs copies */
> -	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> -		return -EXDEV;
> -
>  	ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
>  				       flags);
>  	if (unlikely(ret))
> @@ -1689,7 +1696,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	 * Try cloning first, this is supported by more file systems, and
>  	 * more efficient if both clone and copy are supported (e.g. NFS).
>  	 */
> -	if (file_in->f_op->remap_file_range) {
> +	if (file_in->f_op->remap_file_range &&
> +	    file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {

For the fs/read_write.c bits,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(I'm not going to pass judgement on whether or not cifs/nfs should be
doing cross-sb copies, as I know nothing about how well that works in
practice.)

--D

>  		loff_t cloned;
>  
>  		cloned = file_in->f_op->remap_file_range(file_in, pos_in,
> -- 
> 2.17.1
> 
