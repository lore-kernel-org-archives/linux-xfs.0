Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8CD0229DF9
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 07:47:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1905AAC009
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:47:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DSBdex1WGh6DH99F for
	<xfs@oss.sgi.com>; Mon, 18 Nov 2013 05:47:01 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAIDl0Ct030739
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 08:47:00 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rAIDkxer027447
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 08:47:00 -0500
Message-ID: <528A1BCD.9060900@redhat.com>
Date: Mon, 18 Nov 2013 08:53:17 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: add xfs_setattr_time
References: <20131118131040.GA21649@infradead.org>
	<20131118131052.GB21649@infradead.org>
In-Reply-To: <20131118131052.GB21649@infradead.org>
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
To: xfs@oss.sgi.com

On 11/18/2013 08:10 AM, Christoph Hellwig wrote:
> Split out a xfs_setattr_time helper to share code between truncate and
> regular setattr similar to xfs_setattr_mode.  I might also have another
> caller growing for this in the near future.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c |   66 ++++++++++++++++++++++++------------------------------
>  1 file changed, 30 insertions(+), 36 deletions(-)
> 
> Index: linux/fs/xfs/xfs_iops.c
> ===================================================================
> --- linux.orig/fs/xfs/xfs_iops.c	2013-11-18 11:54:46.083792257 +0100
> +++ linux/fs/xfs/xfs_iops.c	2013-11-18 11:55:34.891791256 +0100
> @@ -474,6 +474,32 @@ xfs_setattr_mode(
>  	inode->i_mode |= mode & ~S_IFMT;
>  }
>  
> +static void
> +xfs_setattr_time(
> +	struct xfs_inode	*ip,
> +	struct iattr		*iattr)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	if (iattr->ia_valid & ATTR_ATIME) {
> +		inode->i_atime = iattr->ia_atime;
> +		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
> +		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
> +	}
> +	if (iattr->ia_valid & ATTR_CTIME) {
> +		inode->i_ctime = iattr->ia_ctime;
> +		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
> +		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
> +	}
> +	if (iattr->ia_valid & ATTR_MTIME) {
> +		inode->i_mtime = iattr->ia_mtime;
> +		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
> +		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
> +	}
> +}
> +
>  int
>  xfs_setattr_nonsize(
>  	struct xfs_inode	*ip,
> @@ -627,30 +653,10 @@ xfs_setattr_nonsize(
>  		}
>  	}
>  
> -	/*
> -	 * Change file access modes.
> -	 */
>  	if (mask & ATTR_MODE)
>  		xfs_setattr_mode(ip, iattr);
> -
> -	/*
> -	 * Change file access or modified times.
> -	 */
> -	if (mask & ATTR_ATIME) {
> -		inode->i_atime = iattr->ia_atime;
> -		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
> -		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
> -	}
> -	if (mask & ATTR_CTIME) {
> -		inode->i_ctime = iattr->ia_ctime;
> -		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
> -		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
> -	}
> -	if (mask & ATTR_MTIME) {
> -		inode->i_mtime = iattr->ia_mtime;
> -		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
> -		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
> -	}
> +	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> +		xfs_setattr_time(ip, iattr);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> @@ -865,22 +871,10 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> -	/*
> -	 * Change file access modes.
> -	 */
>  	if (mask & ATTR_MODE)
>  		xfs_setattr_mode(ip, iattr);
> -
> -	if (mask & ATTR_CTIME) {
> -		inode->i_ctime = iattr->ia_ctime;
> -		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
> -		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
> -	}
> -	if (mask & ATTR_MTIME) {
> -		inode->i_mtime = iattr->ia_mtime;
> -		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
> -		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
> -	}
> +	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> +		xfs_setattr_time(ip, iattr);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
