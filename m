Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34069 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751933AbdBNHn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 02:43:27 -0500
Date: Mon, 13 Feb 2017 23:43:26 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/7] nonblocking aio: xfs
Message-ID: <20170214074326.GA20629@infradead.org>
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170214024603.9563-7-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org

On Mon, Feb 13, 2017 at 08:46:02PM -0600, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Please Cc the while series to all lists, otherwiwe it's impossible
to review the thing.

> 
> If IOCB_NONBLOCKING is set:
> 	+ Check if writing beyond end of file, if yes return EAGAIN
> 	- check if writing to a hole which does not have allocated
> 	  file blocks.
> 	- Check if i_rwsem is immediately lockable in xfs_rw_ilock()

Why the + vs - above? 

> -static inline void
> +static inline int
>  xfs_rw_ilock(

This function has been removed a while ago.

>  
> +	if (iocb->ki_flags & IOCB_NONBLOCKING) {
> +		struct xfs_bmbt_irec	imap;
> +		xfs_fileoff_t           offset_fsb, end_fsb;
> +		int			nimaps = 1, ret = 0;
> +		end_fsb = XFS_B_TO_FSB(ip->i_mount, iocb->ki_pos + count);
> +		if (XFS_B_TO_FSB(ip->i_mount, i_size_read(inode)) < end_fsb)
> +			return -EAGAIN;

Bogus check, XFS supports async write beyond EOF if the space is
preallocated.

> +		/* Check if it is an unallocated hole */
> +		offset_fsb = XFS_B_TO_FSBT(ip->i_mount, iocb->ki_pos);
> +
> +		ret = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
> +				&nimaps, 0);
> +		if (ret)
> +			return ret;
> +		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK)
> +			return -EAGAIN;

This would need the ilock.  But extent list lookups are expensive,
so please don't add another one here.  Just return when we hit the
first unallocated extent in xfs_bmapi_write - either a short write or
-EAGAIN if nothing has been written.

>  	error = xfs_break_layouts(inode, iolock, true);
>  	if (error)
>  		return error;

Additionally this can drop the iolock, so you might get a new
hole after it.
