Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfHHOvs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Aug 2019 10:51:48 -0400
Date: Thu, 8 Aug 2019 09:51:44 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 3/3] xfs: don't crash on null attr fork xfs_bmapi_read
Message-ID: <20190808145144.GA13024@redhat.com>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
 <156527562842.1960675.5982698585427580223.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156527562842.1960675.5982698585427580223.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>

On Thu, Aug 08, 2019 at 07:47:08AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Zorro Lang reported a crash in generic/475 if we try to inactivate a
> corrupt inode with a NULL attr fork (stack trace shortened somewhat):
> 
> RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
> RSP: 0018:ffff888047f9ed68 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffff888047f9f038 RCX: 1ffffffff5f99f51
> RDX: 0000000000000002 RSI: 0000000000000008 RDI: 0000000000000012
> RBP: ffff888002a41f00 R08: ffffed10005483f0 R09: ffffed10005483ef
> R10: ffffed10005483ef R11: ffff888002a41f7f R12: 0000000000000004
> R13: ffffe8fff53b5768 R14: 0000000000000005 R15: 0000000000000001
> FS:  00007f11d44b5b80(0000) GS:ffff888114200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000ef6000 CR3: 000000002e176003 CR4: 00000000001606e0
> Call Trace:
>  xfs_dabuf_map.constprop.18+0x696/0xe50 [xfs]
>  xfs_da_read_buf+0xf5/0x2c0 [xfs]
>  xfs_da3_node_read+0x1d/0x230 [xfs]
>  xfs_attr_inactive+0x3cc/0x5e0 [xfs]
>  xfs_inactive+0x4c8/0x5b0 [xfs]
>  xfs_fs_destroy_inode+0x31b/0x8e0 [xfs]
>  destroy_inode+0xbc/0x190
>  xfs_bulkstat_one_int+0xa8c/0x1200 [xfs]
>  xfs_bulkstat_one+0x16/0x20 [xfs]
>  xfs_bulkstat+0x6fa/0xf20 [xfs]
>  xfs_ioc_bulkstat+0x182/0x2b0 [xfs]
>  xfs_file_ioctl+0xee0/0x12a0 [xfs]
>  do_vfs_ioctl+0x193/0x1000
>  ksys_ioctl+0x60/0x90
>  __x64_sys_ioctl+0x6f/0xb0
>  do_syscall_64+0x9f/0x4d0
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x7f11d39a3e5b
> 
> The "obvious" cause is that the attr ifork is null despite the inode
> claiming an attr fork having at least one extent, but it's not so
> obvious why we ended up with an inode in that state.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204031
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense, and alleviates the problem I occasionally see on g/475.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c |   29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index baf0b72c0a37..07aad70f3931 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3835,15 +3835,28 @@ xfs_bmapi_read(
>  	XFS_STATS_INC(mp, xs_blk_mapr);
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
> +	if (!ifp) {
> +		/* No CoW fork?  Return a hole. */
> +		if (whichfork == XFS_COW_FORK) {
> +			mval->br_startoff = bno;
> +			mval->br_startblock = HOLESTARTBLOCK;
> +			mval->br_blockcount = len;
> +			mval->br_state = XFS_EXT_NORM;
> +			*nmap = 1;
> +			return 0;
> +		}
>  
> -	/* No CoW fork?  Return a hole. */
> -	if (whichfork == XFS_COW_FORK && !ifp) {
> -		mval->br_startoff = bno;
> -		mval->br_startblock = HOLESTARTBLOCK;
> -		mval->br_blockcount = len;
> -		mval->br_state = XFS_EXT_NORM;
> -		*nmap = 1;
> -		return 0;
> +		/*
> +		 * A missing attr ifork implies that the inode says we're in
> +		 * extents or btree format but failed to pass the inode fork
> +		 * verifier while trying to load it.  Treat that as a file
> +		 * corruption too.
> +		 */
> +#ifdef DEBUG
> +		xfs_alert(mp, "%s: inode %llu missing fork %d",
> +				__func__, ip->i_ino, whichfork);
> +#endif /* DEBUG */
> +		return -EFSCORRUPTED;
>  	}
>  
>  	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> 
