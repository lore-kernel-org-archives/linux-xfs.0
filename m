Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBDMws1r178201 for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 16:58:55 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B69951571FC5
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 14:58:53 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DHGfAZaBEvrODvfm for <xfs@oss.sgi.com>;
	Tue, 13 Dec 2011 14:58:53 -0800 (PST)
Date: Wed, 14 Dec 2011 09:58:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfs: remove the i_size field in struct xfs_inode
Message-ID: <20111213225850.GF3179@dastard>
References: <20111208155755.323930705@bombadil.infradead.org>
	<20111208155918.841972809@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111208155918.841972809@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 08, 2011 at 10:58:03AM -0500, Christoph Hellwig wrote:
> There is no fundamental need to keep an in-memory inode size copy in the
> XFS inode.  We already have the on-disk value in the dinode, and the
> separate in-memory copy that we need for regular files only in the
> XFS inode.
> 
> Remove the xfs_inode i_size field and change the XFS_ISIZE macro to use
> the VFS inode i_size field for regular fields.  Switch code that was
> directly accessing it to either the XFS_ISIZE macro or direct access
> of the VFS i_size if the code is limited to regular files and in
> highlevel code.

Welcome back, XFS_ISIZE() ;)

> This also allows dropping a a big bunch of fairly complicated code in the
> write path which dealt with keeping the xfs_inode i_size uptodate with the
> VFS i_size that is getting updated inside ->write_end.

Excellent - one less round trip on the ILOCK for each extending
write.

> Note that we do not bother resetting the VFS i_size when truncating a file
> that gets freed to zero as there is point in doing so.  Just relax the

                                     no point in doing so because
				     the VFS inode is no longer in
				     use at this point.

> assert in xfs_ifree to only check the on-disk size instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

......

> @@ -3997,11 +3997,8 @@ xfs_bmap_one_block(
>  	xfs_bmbt_irec_t	s;		/* internal version of extent */
>  
>  #ifndef DEBUG
> -	if (whichfork == XFS_DATA_FORK) {
> -		return S_ISREG(ip->i_d.di_mode) ?
> -			(ip->i_size == ip->i_mount->m_sb.sb_blocksize) :
> -			(ip->i_d.di_size == ip->i_mount->m_sb.sb_blocksize);
> -	}
> +	if (whichfork == XFS_DATA_FORK)
> +		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
>  #endif	/* !DEBUG */
>  	if (XFS_IFORK_NEXTENTS(ip, whichfork) != 1)
>  		return 0;

I thought that this was a small change of logic, and validated that
it was OK to do so, but turns out it is not. I soon noticed that
this was the logic inside XFS_ISIZE(), and that it is all the
ip->i_size to XFS_ISIZE(ip) conversions that change the logic:

> @@ -269,6 +265,18 @@ static inline struct inode *VFS_I(struct
>  }
>  
>  /*
> + * For regular files we only update the on-disk filesize when actually
> + * writing data back to disk.  Until then only the copy in the VFS inode
> + * is uptodate.
> + */
> +static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
> +{
> +	if (S_ISREG(ip->i_d.di_mode))
> +		return i_size_read(VFS_I(ip));
> +	return ip->i_d.di_size;
> +}

This means we -explicity- only have a separate in-memory size for
regular files which is a significant change of logic. Preivously all
inodes, regardless of type, had both on-disk and in-memory values.

After thinking about this for a bit, the new code actually reflects
the original intent of the i_size/i_d.di_size split.  i.e. it was
only necessary to separate the size into in-memory/on-disk pair so
that the on-disk size matched what -data writeback- had completed.
And data writeback can only occur on regular files, so it was only
necessary for regular files. The original implementation didn't
reflect this - it just changed all inodes to have this split.

However, For all other types of inodes, all the size updates are
made directly to i_d.di_size and a logged immediately. In those
cases, we are simultaneously updating i_size, so we don't really
need it at all. e also don't need to touch the inode->i_size,
because the VFS is already maintaining that for use in these
cases....

Ok, I've convinced myself that this is valid, and I haven't seen any
problems in testing, so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
