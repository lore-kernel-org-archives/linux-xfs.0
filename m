Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AEC867CA1
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 02:34:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F1A9304039
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 00:34:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CKE3dreryaPNWjJd (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 00:34:53 -0700 (PDT)
Date: Tue, 9 Aug 2016 00:34:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] iomap: add fiemap support for attribute mappings
Message-ID: <20160809073450.GB25647@infradead.org>
References: <1470637351-27933-1-git-send-email-david@fromorbit.com>
	<1470637351-27933-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470637351-27933-3-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Aug 08, 2016 at 04:22:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prior to the iomap conversion, XFS supported the FIEMAP_FLAG_XATTR
> flag for mapping the attribute fork block map. This flag was not
> added to the iomap fiemap support so we have regressed fiemap
> functionality with this change.
> 
> Add an iomap control flag to indicate that we should be operating
> on the attribute map rather than the file data map and pass it from
> iomap_fiemap() as appropriate. Add the appropriate flags to the XFS
> code to switch to the attribute fork lookup, and ensure we return
> EINVAL if anyone attempts a write mapping of the attribute fork.

I'm a little worried about this for a few reasons:

> -	ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC);
> +	ret = fiemap_check_flags(fi, FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR);

FIEMAP_FLAG_XATTR is a magic thing only supported by ext4 and
historically XFS.  By claiming general support here we make iomap_fiemap
unsuitable for general use.  At least we should pass in a flag if it's
supported or not into the generic helper.  Or see below for another
idea.

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 4398932..17b5b82 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -993,10 +993,22 @@ xfs_file_iomap_begin(
>  	struct xfs_bmbt_irec	imap;
>  	xfs_fileoff_t		offset_fsb, end_fsb;
>  	int			nimaps = 1, error = 0;
> +	int			bmflags = XFS_BMAPI_ENTIRE;
>  
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	/* Attribute fork can only be read via this interface */
> +	if (flags & IOMAP_ATTR) {
> +		if (flags & ~IOMAP_ATTR)
> +			return -EINVAL;
> +		/* if there are no attribute fork or extents, return ENOENT */
> +		if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents)
> +			return -ENOENT;
> +		ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
> +		bmflags |= XFS_BMAPI_ATTRFORK;
> +	}

And this adds a special case for totally rare attr fork operation to
the fast path that we'll soon be using for all file I/O.

I'd suggest to just have a separate stub set of iomap_ops for the xattr
case.  xfs_vn_fiemap would then look something like:


	xfs_ilock(XFS_I(inode), XFS_IOLOCK_SHARED);
	if (fi->fi_flags & FIEMAP_FLAG_XATTR) {
		fi->fi_flags &= ~FIEMAP_FLAG_XATTR;
		error = iomap_fiemap(inode, fieinfo, start, length,
				&xfs_attr_iomap_ops);
	} else {
		error = iomap_fiemap(inode, fieinfo, start, length,
				&xfs_iomap_ops);
	}
	xfs_iunlock(XFS_I(inode), XFS_IOLOCK_SHARED);

	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
