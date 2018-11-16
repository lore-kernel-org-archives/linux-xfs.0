Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbeKQFpI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 17 Nov 2018 00:45:08 -0500
Date: Fri, 16 Nov 2018 14:31:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181116193124.GA32290@bfoster>
References: <20181116190724.GW4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116190724.GW4235@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 16, 2018 at 11:07:24AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we're remapping into a range that starts beyond EOF, we have to zero
> the memory between EOF and the start of the target range, as established
> in 410fdc72b05af.  However, in 4918ef4ea008, we extended the pagecache
> truncation range downwards to a page boundary to guarantee that
> pagecache pages are removed and that there's no possibility that we end
> up zeroing subpage blocks within a page.  Unfortunately, we never commit
> the posteof zeroing to disk, so on a filesystem where page size > block
> size the truncation partially undoes the zeroing and we end up with
> stale disk contents.
> 
> Brian and I reproduced this problem by running generic/091 on a 1k block
> xfs filesystem, assuming fsx in fstests supports clone/dedupe/copyrange.
> 

Note that I think we might have hit different manifestations of the same
problem. I actually reproduced an assert failure via shared/010 with the
writeback patch I just posted that checks that we don't write to shared
extents. A trace focused on the problematic range showed:

        fsstress-12966 [002] 14464.404582: xfs_zero_eof:         dev 253:3 ino 0x80009b isize 0x14070 disize 0x14070 offset 0x14070 count 655248
        fsstress-12966 [002] 14464.404583: xfs_ilock:            dev 253:3 ino 0x80009b flags ILOCK_EXCL caller xfs_file_iomap_begin
        fsstress-12966 [002] 14464.404585: xfs_reflink_trim_around_shared: dev 253:3 ino 0x80009b lblk 0x14 len 0x1 pblk 1048635 st 0
        fsstress-12966 [002] 14464.404641: xfs_iomap_found:      dev 253:3 ino 0x80009b size 0x14070 offset 0x14070 count 655248 type 0x0 startoff 0x14 startblock 1048635 blockcount 0x1
        fsstress-12966 [002] 14464.404642: xfs_iunlock:          dev 253:3 ino 0x80009b flags ILOCK_EXCL caller xfs_file_iomap_begin
        fsstress-12966 [002] 14464.404704: writeback_dirty_page: bdi 253:3: ino=8388763 index=20

... which implies that the eof zeroing associated with the remap dirties
the page that ends up being written back to a shared block. As a quick
hack, I just swapped the order of the zeroing and the existing flush
calls and that made the problem disappear.

> Fixes: 410fdc72b05a ("xfs: zero posteof blocks when cloning above eof")
> Fixes: 4918ef4ea008 ("xfs: fix pagecache truncation prior to reflink")
> Simultaneously-diagnosed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> Note: I haven't tested this thoroughly but wanted to push this out for
> everyone to look at ASAP.
> ---

This addresses the problem that I reproduce with shared/010 as well, and
looks Ok to me pending further testing:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c56bdbfcf7ae..8ea09a7e550c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1255,13 +1255,19 @@ xfs_reflink_zero_posteof(
>  	loff_t			pos)
>  {
>  	loff_t			isize = i_size_read(VFS_I(ip));
> +	int			error;
>  
>  	if (pos <= isize)
>  		return 0;
>  
>  	trace_xfs_zero_eof(ip, isize, pos - isize);
> -	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
> +	error = iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
>  			&xfs_iomap_ops);
> +	if (error)
> +		return error;
> +
> +	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> +			isize, pos - 1);

Random nit: any particular reason we use ->i_data in the page truncate
call in xfs_reflink_remap_prep() and ->i_mapping everywhere else?

Brian

>  }
>  
>  /*
