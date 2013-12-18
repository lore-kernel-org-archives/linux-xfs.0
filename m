Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 358F07F3F
	for <xfs@oss.sgi.com>; Wed, 18 Dec 2013 15:48:00 -0600 (CST)
Date: Wed, 18 Dec 2013 15:47:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/11 v2] xfs: add xfs_ilock_attr_map_shared
Message-ID: <20131218214759.GW1935@sgi.com>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.663030833@bombadil.infradead.org>
	<20131208223610.GE31386@dastard>
	<20131209181612.GA22183@infradead.org>
	<20131209222433.GY10988@dastard>
	<20131210161349.GD19510@infradead.org>
	<20131217173334.GV1935@sgi.com>
	<20131218101439.GA5060@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131218101439.GA5060@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 18, 2013 at 02:14:39AM -0800, Christoph Hellwig wrote:
> Equivalent to xfs_ilock_data_map_shared, except for the attribute fork.
> 
> Make xfs_getbmap use it if called for the attribute fork instead of
> xfs_ilock_data_map_shared.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap_util.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap_util.c	2013-12-18 11:14:52.587953376 +0100
> +++ xfs/fs/xfs/xfs_bmap_util.c	2013-12-18 11:15:29.367952621 +0100
> @@ -617,22 +617,27 @@ xfs_getbmap(
>  		return XFS_ERROR(ENOMEM);
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> -	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
> -		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
> +	if (whichfork == XFS_DATA_FORK) {
> +		if (!(iflags & BMV_IF_DELALLOC) &&
> +		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
>  			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
>  			if (error)
>  				goto out_unlock_iolock;
> +
> +			/*
> +			 * Even after flushing the inode, there can still be
> +			 * delalloc blocks on the inode beyond EOF due to
> +			 * speculative preallocation.  These are not removed

This one has a 'p'.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
