Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbeK2Hky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 02:40:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASKTTMG061912
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 20:38:00 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nxx2uckuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 20:37:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wASKbxMK005207
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 20:37:59 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wASKbxST019372
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 20:37:59 GMT
Date: Wed, 28 Nov 2018 12:37:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: fix transaction block reservation in
 xfs_reflink_end_cow
Message-ID: <20181128203758.GI8125@magnolia>
References: <20181127161652.GE6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127161652.GE6792@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 27, 2018 at 08:16:52AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_reflink_end_cow, we have to swap written extents from the CoW
> fork into the data fork, which can require extensive block map updates.
> The block calculation has an off-by-one underflow, which can lead to
> following shutdown:
> 
> XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 116
> <machine registers snipped>
> Call Trace:
>  xfs_trans_dup+0x211/0x250 [xfs]
>  xfs_trans_roll+0x6d/0x180 [xfs]
>  xfs_defer_trans_roll+0x10c/0x3b0 [xfs]
>  xfs_defer_finish_noroll+0xdf/0x740 [xfs]
>  xfs_defer_finish+0x13/0x70 [xfs]
>  xfs_reflink_end_cow+0x2c6/0x680 [xfs]
>  xfs_dio_write_end_io+0x115/0x220 [xfs]
>  iomap_dio_complete+0x3f/0x130
>  iomap_dio_rw+0x3c3/0x420
>  xfs_file_dio_aio_write+0x132/0x3c0 [xfs]
>  xfs_file_write_iter+0x8b/0xc0 [xfs]
>  __vfs_write+0x193/0x1f0
>  vfs_write+0xba/0x1c0
>  ksys_write+0x52/0xc0
>  do_syscall_64+0x50/0x160
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 322a852ce284..d7a451e8b0b9 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -657,14 +657,14 @@ xfs_reflink_end_cow(
>  	 * Stick a warning in just in case, and avoid 64-bit division.
>  	 */
>  	BUILD_BUG_ON(MAX_RW_COUNT > UINT_MAX);
> -	if (end_fsb - offset_fsb > UINT_MAX) {
> +	if (end_fsb - offset_fsb >= UINT_MAX) {
>  		error = -EFSCORRUPTED;
>  		xfs_force_shutdown(ip->i_mount, SHUTDOWN_CORRUPT_INCORE);
>  		ASSERT(0);
>  		goto out;
>  	}
>  	resblks = XFS_NEXTENTADD_SPACE_RES(ip->i_mount,
> -			(unsigned int)(end_fsb - offset_fsb),
> +			(unsigned int)(end_fsb - offset_fsb + 1),

This isn't it either.  I managed to reproduce the ASSERT with some
debugging enabled, and noticed that just prior to the directio write the
data fork looked like this:

D: ABCDEFGH

where A-H are each single-block mappings.  The COW fork for whatever
reason was pretty fragmented too:

C: IJKLMNOP

where I-P are also single block mappings.  The log showed that there was
a chain of transactions with EFIs and block allocations, and I observed
that the number of extents was just enough that the mappings wouldn't
fit in an extents format data fork.  I surmised that the end_cow loop
would punch out the last block of the range:

D: ABCDEFG-
C: IJKLMNOP

which causes the bmap code to collapse the bmbt block into extents
format, freeing the bmbt block.  Then, we remap out of the COW fork:

D: ABCDEFGP
C: IJKLMNO-

which causes the bmap code to convert the data fork from extents format
back into bmbt format, which allocates a block.  We then repeat this
process to replace block G with block O, which causes yet another
collapse and convert cycle.  The NEXTENTADD block reservation macro only
reserves enough blocks to add I-P (8 blocks) to a data fork where A-H have
*already* been cleared out, which means that we assume 1 bmbt split.

Therefore, we only reserve 5 blocks for that split (max bmbt height for
this fs), and we use up all 5 of them mapping blocks P-L into the data
fork.  The extents -> btree conversion for remapping block K overflows
the transaction block reservation and down goes the filesystem.  Note
that in the vast majority of cases the extents are bigger or we don't
ping-pong the reservation, so we've never hit this until now.

I /think/ the solution is to push the transaction allocation into the
loop so that each transaction roll-chain only moves one extent and
therefore we only have to reserve enough blocks for a single btree
split, which should be enough for us.  The downside is that we drop the
ilock during end_cow, which I think(?) is fine since all CoW write paths
go through _reflink_end_cow, and it isn't picky about holes.  As a
bonus, this will also remove the restriction on the number of bytes you
can _reflink_end_cow in a single call.  Not that anyone's complained
about not being able to CoW 16T in a single operation...

--D

>  			XFS_DATA_FORK);
>  	error = xfs_trans_alloc(ip->i_mount, &M_RES(ip->i_mount)->tr_write,
>  			resblks, 0, XFS_TRANS_RESERVE | XFS_TRANS_NOFS, &tp);
