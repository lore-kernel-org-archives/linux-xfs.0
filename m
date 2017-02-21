Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57929 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752429AbdBUN5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 08:57:03 -0500
Date: Tue, 21 Feb 2017 14:56:39 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] xfs: clear delalloc and cache on buffered write failure
Message-ID: <20170221135639.GA26768@kroah.com>
References: <1487684787-5004-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487684787-5004-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, Michal Hocko <mhocko@kernel.org>

On Tue, Feb 21, 2017 at 08:46:27AM -0500, Brian Foster wrote:
> commit fa7f138ac4c70dc00519c124cf7cd4862a0a5b0e upstream.
> 
> The buffered write failure handling code in
> xfs_file_iomap_end_delalloc() has a couple minor problems. First, if
> written == 0, start_fsb is not rounded down and it fails to kill off a
> delalloc block if the start offset is block unaligned. This results in a
> lingering delalloc block and broken delalloc block accounting detected
> at unmount time. Fix this by rounding down start_fsb in the unlikely
> event that written == 0.
> 
> Second, it is possible for a failed overwrite of a delalloc extent to
> leave dirty pagecache around over a hole in the file. This is because is
> possible to hit ->iomap_end() on write failure before the iomap code has
> attempted to allocate pagecache, and thus has no need to clean it up. If
> the targeted delalloc extent was successfully written by a previous
> write, however, then it does still have dirty pages when ->iomap_end()
> punches out the underlying blocks. This ultimately results in writeback
> over a hole. To fix this problem, unconditionally punch out the
> pagecache from XFS before the associated delalloc range.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> CC: stable@vger.kernel.org # v4.8+
> ---
> 
> This is for stable... it fixes a latent regression exposed by
> d1908f52557b ("fs: break out of iomap_file_buffered_write on fatal
> signals"), which is to be backported to 4.8+ stable kernels.

For XFS patches, I need an explicit ack from the maintainer before
applying them, as per their instructions in the past...

thanks,

greg k-h
