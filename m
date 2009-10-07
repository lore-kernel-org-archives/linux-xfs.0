Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n97MMxY5215418 for <xfs@oss.sgi.com>; Wed, 7 Oct 2009 17:22:59 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: stop calling filemap_fdatawait inside ->fsync
Date: Wed, 7 Oct 2009 17:23:34 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AD39@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090926195504.GA11121@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Now that the VFS actually waits for the data I/O to complete before
> calling into ->fsync we can stop doing it ourselves.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2009-09-26 14:09:24.933003650 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2009-09-26 14:09:46.804256831 -0300
> @@ -176,14 +176,7 @@ xfs_file_fsync(
>  	struct dentry		*dentry,
>  	int			datasync)
>  {
> -	struct inode		*inode = dentry->d_inode;
>  	struct xfs_inode	*ip = XFS_I(inode);
> -	int			error;
> -
> -	/* capture size updates in I/O completion before writing the inode. */
> -	error = filemap_fdatawait(inode->i_mapping);
> -	if (error)
> -		return error;
> 
>  	xfs_iflags_clear(ip, XFS_ITRUNCATED);
>  	return -xfs_fsync(ip);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
