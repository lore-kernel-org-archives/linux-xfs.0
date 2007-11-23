Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 09:40:12 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANHe5h4029813
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 09:40:07 -0800
Date: Fri, 23 Nov 2007 17:40:13 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/9] Factor common inode cluster buffer lookup code
Message-ID: <20071123174013.GB12227@infradead.org>
References: <20071122003642.GJ114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122003642.GJ114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

On Thu, Nov 22, 2007 at 11:36:42AM +1100, David Chinner wrote:
> +STATIC int
> +xfs_ino_to_imap(
> +	xfs_mount_t	*mp,
> +	xfs_trans_t	*tp,
> +	xfs_ino_t	ino,
> +	xfs_imap_t	*imap,
> +	uint		imap_flags)
> +{
> +	int		error;
> +
> +	error = xfs_imap(mp, tp, ino, imap, imap_flags);
> +	if (error) {
> +		cmn_err(CE_WARN, "xfs_ino_to_imap: xfs_imap()  returned an "
> +				"error %d on %s.  Returning error.",
> +				error, mp->m_fsname);
> +		return error;
> +	}
> +
> +	/*
> +	 * If the inode number maps to a block outside the bounds
> +	 * of the file system then return NULL rather than calling
> +	 * read_buf and panicing when we get an error from the
> +	 * driver.
> +	 */
> +	if ((imap->im_blkno + imap->im_len) >
> +	    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) {
> +		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_ino_to_imap: "
> +			"(imap->im_blkno (0x%llx) + imap->im_len (0x%llx)) > "
> +			" XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) (0x%llx)",
> +			(unsigned long long) imap->im_blkno,
> +			(unsigned long long) imap->im_len,
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
> +		return XFS_ERROR(EINVAL);
> +	}

What about just adding this verification to xfs_imap instead of creating
this wrapper for two of it's three callers?

Otherwise this patch looks fine to me.
