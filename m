Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31442 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934214AbdDGPJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2017 11:09:36 -0400
Date: Fri, 7 Apr 2017 08:08:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 7/8] nowait aio: xfs
Message-ID: <20170407150851.GC4853@birch.djwong.org>
References: <20170403185307.6243-1-rgoldwyn@suse.de>
 <20170403185307.6243-8-rgoldwyn@suse.de>
 <20170404065211.GD21942@infradead.org>
 <20170406225415.GC4864@birch.djwong.org>
 <6cc69b0c-7af4-879e-1012-aae8ba5358bd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc69b0c-7af4-879e-1012-aae8ba5358bd@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Apr 07, 2017 at 06:34:28AM -0500, Goldwyn Rodrigues wrote:
> 
> 
> On 04/06/2017 05:54 PM, Darrick J. Wong wrote:
> > On Mon, Apr 03, 2017 at 11:52:11PM -0700, Christoph Hellwig wrote:
> >>> +	if (unaligned_io) {
> >>> +		/* If we are going to wait for other DIO to finish, bail */
> >>> +		if ((iocb->ki_flags & IOCB_NOWAIT) &&
> >>> +		     atomic_read(&inode->i_dio_count))
> >>> +			return -EAGAIN;
> >>>  		inode_dio_wait(inode);
> >>
> >> This checks i_dio_count twice in the nowait case, I think it should be:
> >>
> >> 	if (iocb->ki_flags & IOCB_NOWAIT) {
> >> 		if (atomic_read(&inode->i_dio_count))
> >> 			return -EAGAIN;
> >> 	} else {
> >> 		inode_dio_wait(inode);
> >> 	}
> >>
> >>>  	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
> >>>  		if (flags & IOMAP_DIRECT) {
> >>> +			/* A reflinked inode will result in CoW alloc */
> >>> +			if (flags & IOMAP_NOWAIT) {
> >>> +				error = -EAGAIN;
> >>> +				goto out_unlock;
> >>> +			}
> >>
> >> This is a bit pessimistic - just because the inode has any shared
> >> extents we could still write into unshared ones.  For now I think this
> >> pessimistic check is fine, but the comment should be corrected.
> > 
> > Consider what happens in both _reflink_{allocate,reserve}_cow.  If there
> > is already an existing reservation in the CoW fork then we'll have to
> > CoW and therefore can't satisfy the NOWAIT flag.  If there isn't already
> > anything in the CoW fork, then we have to see if there are shared blocks
> > by calling _reflink_trim_around_shared.  That performs a refcountbt
> > lookup, which involves locking the AGF, so we also can't satisfy NOWAIT.
> > 
> > IOWs, I think this hunk has to move outside the IOMAP_DIRECT check to
> > cover both write-to-reflinked-file cases.
> > 
> 
> IOMAP_NOWAIT is set only with IOMAP_DIRECT since the nowait feature is
> for direct-IO only. This is checked early on, when we are checking for

Ah, ok.  Disregard what I said about moving it then.

--D

> user-passed flags, and if not, -EINVAL is returned.
> 
> 
> -- 
> Goldwyn
