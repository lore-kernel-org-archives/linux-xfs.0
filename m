Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49526 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932443AbdHWUWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 16:22:19 -0400
Date: Wed, 23 Aug 2017 13:22:13 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
 creations
Message-ID: <20170823202213.GA4796@magnolia>
References: <20170821082404.3387-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170821082404.3387-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 21, 2017 at 10:24:04AM +0200, Christoph Hellwig wrote:
> If we create a new file we will need an inode, and usually some metadata
> in the parent direction.  Aiming for everything to go well despite the
> lack of a reservation leads to dirty transactions cancelled under a heavy
> create/delete load.  This patch removes those nospace transactions, which
> will lead to slightly earlier ENOSPC on some workloads, but instead
> prevent file system shutdowns due to cancelling dirty transactions for
> others.
> 
> A customer could observe assertations failures and shutdowns due to
> cancelation of dirty transactions during heavy NFS workloads as shown
> below:

Looks ok... but is there a xfstest somewhere that can be coaxed into
reproducing this?  I'm looking at what this code does and have been
wondering why it even tries this weird workaround in the first place?

IOWS, the weirdness removed by this patch didn't quite smell right, but
at the same time I want to know more about why the smelly weirdness was
there at all before I rip it out. Context, anyone? :)

Will throw it on the pile and test.

--D

> 
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728125] XFS: Assertion failed: error != -ENOSPC, file: fs/xfs/xfs_inode.c, line: 1262
> 
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728222] Call Trace:
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728246]  [<ffffffff81795daf>] dump_stack+0x63/0x81
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728262]  [<ffffffff810a1a5a>] warn_slowpath_common+0x8a/0xc0
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728264]  [<ffffffff810a1b8a>] warn_slowpath_null+0x1a/0x20
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728285]  [<ffffffffa01bf403>] asswarn+0x33/0x40 [xfs]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728308]  [<ffffffffa01bb07e>] xfs_create+0x7be/0x7d0 [xfs]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728329]  [<ffffffffa01b6ffb>] xfs_generic_create+0x1fb/0x2e0 [xfs]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728348]  [<ffffffffa01b7114>] xfs_vn_mknod+0x14/0x20 [xfs]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728366]  [<ffffffffa01b7153>] xfs_vn_create+0x13/0x20 [xfs]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728380]  [<ffffffff81231de5>] vfs_create+0xd5/0x140
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728390]  [<ffffffffa045ddb9>] do_nfsd_create+0x499/0x610 [nfsd]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728396]  [<ffffffffa0465fa5>] nfsd3_proc_create+0x135/0x210 [nfsd]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728401]  [<ffffffffa04561e3>] nfsd_dispatch+0xc3/0x210 [nfsd]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728416]  [<ffffffffa03bfa43>] svc_process_common+0x453/0x6f0 [sunrpc]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728423]  [<ffffffffa03bfdf3>] svc_process+0x113/0x1f0 [sunrpc]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728427]  [<ffffffffa0455bcf>] nfsd+0x10f/0x180 [nfsd]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728432]  [<ffffffffa0455ac0>] ? nfsd_destroy+0x80/0x80 [nfsd]
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728438]  [<ffffffff810c0d58>] kthread+0xd8/0xf0
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728441]  [<ffffffff810c0c80>] ? kthread_create_on_node+0x1b0/0x1b0
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728451]  [<ffffffff8179d962>] ret_from_fork+0x42/0x70
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728453]  [<ffffffff810c0c80>] ? kthread_create_on_node+0x1b0/0x1b0
> 2017-05-30 21:17:06 kernel: WARNING: [ 2670.728454] ---[ end trace f9822c842fec81d4 ]---
> 
> 2017-05-30 21:17:06 kernel: ALERT: [ 2670.728477] XFS (sdb): Internal error xfs_trans_cancel at line 983 of file fs/xfs/xfs_trans.c.  Caller xfs_create+0x4ee/0x7d0 [xfs]
> 
> 2017-05-30 21:17:06 kernel: ALERT: [ 2670.728684] XFS (sdb): Corruption of in-memory data detected. Shutting down filesystem
> 2017-05-30 21:17:06 kernel: ALERT: [ 2670.728685] XFS (sdb): Please umount the filesystem and rectify the problem(s)
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 10 +++-------
>  fs/xfs/libxfs/xfs_ialloc.h |  1 -
>  fs/xfs/xfs_inode.c         | 33 +++++++--------------------------
>  fs/xfs/xfs_inode.h         |  2 +-
>  fs/xfs/xfs_qm.c            |  4 ++--
>  fs/xfs/xfs_symlink.c       | 15 +--------------
>  6 files changed, 14 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index abf5beaae907..6af9ef5d33de 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -921,8 +921,7 @@ STATIC xfs_agnumber_t
>  xfs_ialloc_ag_select(
>  	xfs_trans_t	*tp,		/* transaction pointer */
>  	xfs_ino_t	parent,		/* parent directory inode number */
> -	umode_t		mode,		/* bits set to indicate file type */
> -	int		okalloc)	/* ok to allocate more space */
> +	umode_t		mode)		/* bits set to indicate file type */
>  {
>  	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
>  	xfs_agnumber_t	agno;		/* current ag number */
> @@ -979,9 +978,6 @@ xfs_ialloc_ag_select(
>  			return agno;
>  		}
>  
> -		if (!okalloc)
> -			goto nextag;
> -
>  		if (!pag->pagf_init) {
>  			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
>  			if (error)
> @@ -1682,7 +1678,6 @@ xfs_dialloc(
>  	struct xfs_trans	*tp,
>  	xfs_ino_t		parent,
>  	umode_t			mode,
> -	int			okalloc,
>  	struct xfs_buf		**IO_agbp,
>  	xfs_ino_t		*inop)
>  {
> @@ -1694,6 +1689,7 @@ xfs_dialloc(
>  	int			noroom = 0;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
> +	int			okalloc = 1;
>  
>  	if (*IO_agbp) {
>  		/*
> @@ -1709,7 +1705,7 @@ xfs_dialloc(
>  	 * We do not have an agbp, so select an initial allocation
>  	 * group for inode allocation.
>  	 */
> -	start_agno = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
> +	start_agno = xfs_ialloc_ag_select(tp, parent, mode);
>  	if (start_agno == NULLAGNUMBER) {
>  		*inop = NULLFSINO;
>  		return 0;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index b32cfb5aeb5b..72311a636458 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -81,7 +81,6 @@ xfs_dialloc(
>  	struct xfs_trans *tp,		/* transaction pointer */
>  	xfs_ino_t	parent,		/* parent inode (directory) */
>  	umode_t		mode,		/* mode bits for new inode */
> -	int		okalloc,	/* ok to allocate more space */
>  	struct xfs_buf	**agbp,		/* buf for a.g. inode header */
>  	xfs_ino_t	*inop);		/* inode number allocated */
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index ff48f0096810..6af59418f4ab 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -769,7 +769,6 @@ xfs_ialloc(
>  	xfs_nlink_t	nlink,
>  	xfs_dev_t	rdev,
>  	prid_t		prid,
> -	int		okalloc,
>  	xfs_buf_t	**ialloc_context,
>  	xfs_inode_t	**ipp)
>  {
> @@ -785,7 +784,7 @@ xfs_ialloc(
>  	 * Call the space management code to pick
>  	 * the on-disk inode to be allocated.
>  	 */
> -	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode, okalloc,
> +	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
>  			    ialloc_context, &ino);
>  	if (error)
>  		return error;
> @@ -977,7 +976,6 @@ xfs_dir_ialloc(
>  	xfs_nlink_t	nlink,
>  	xfs_dev_t	rdev,
>  	prid_t		prid,		/* project id */
> -	int		okalloc,	/* ok to allocate new space */
>  	xfs_inode_t	**ipp,		/* pointer to inode; it will be
>  					   locked. */
>  	int		*committed)
> @@ -1008,8 +1006,8 @@ xfs_dir_ialloc(
>  	 * transaction commit so that no other process can steal
>  	 * the inode(s) that we've just allocated.
>  	 */
> -	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, okalloc,
> -			  &ialloc_context, &ip);
> +	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
> +			&ip);
>  
>  	/*
>  	 * Return an error if we were unable to allocate a new inode.
> @@ -1081,7 +1079,7 @@ xfs_dir_ialloc(
>  		 * this call should always succeed.
>  		 */
>  		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
> -				  okalloc, &ialloc_context, &ip);
> +				  &ialloc_context, &ip);
>  
>  		/*
>  		 * If we get an error at this point, return to the caller
> @@ -1203,11 +1201,6 @@ xfs_create(
>  		xfs_flush_inodes(mp);
>  		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
>  	}
> -	if (error == -ENOSPC) {
> -		/* No space at all so try a "no-allocation" reservation */
> -		resblks = 0;
> -		error = xfs_trans_alloc(mp, tres, 0, 0, 0, &tp);
> -	}
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -1224,19 +1217,13 @@ xfs_create(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	if (!resblks) {
> -		error = xfs_dir_canenter(tp, dp, name);
> -		if (error)
> -			goto out_trans_cancel;
> -	}
> -
>  	/*
>  	 * A newly created regular or special file just has one directory
>  	 * entry pointing to them, but a directory also the "." entry
>  	 * pointing to itself.
>  	 */
> -	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
> -			       prid, resblks > 0, &ip, NULL);
> +	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip,
> +			NULL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1361,11 +1348,6 @@ xfs_create_tmpfile(
>  	tres = &M_RES(mp)->tr_create_tmpfile;
>  
>  	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
> -	if (error == -ENOSPC) {
> -		/* No space at all so try a "no-allocation" reservation */
> -		resblks = 0;
> -		error = xfs_trans_alloc(mp, tres, 0, 0, 0, &tp);
> -	}
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -1374,8 +1356,7 @@ xfs_create_tmpfile(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0,
> -				prid, resblks > 0, &ip, NULL);
> +	error = xfs_dir_ialloc(&tp, dp, mode, 1, 0, prid, &ip, NULL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 0ee453de239a..ef9b634e4a0a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -428,7 +428,7 @@ xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
>  xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
>  
>  int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
> -			       xfs_nlink_t, xfs_dev_t, prid_t, int,
> +			       xfs_nlink_t, xfs_dev_t, prid_t,
>  			       struct xfs_inode **, int *);
>  
>  /* from xfs_file.c */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 15751dc2a27d..b1e45ac8ada7 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -792,8 +792,8 @@ xfs_qm_qino_alloc(
>  		return error;
>  
>  	if (need_alloc) {
> -		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip,
> -								&committed);
> +		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip,
> +				&committed);
>  		if (error) {
>  			xfs_trans_cancel(tp);
>  			return error;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 23a50d7aa46a..ae8071a4d035 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -232,11 +232,6 @@ xfs_symlink(
>  	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
>  
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, resblks, 0, 0, &tp);
> -	if (error == -ENOSPC && fs_blocks == 0) {
> -		resblks = 0;
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, 0, 0, 0,
> -				&tp);
> -	}
>  	if (error)
>  		goto out_release_inode;
>  
> @@ -260,14 +255,6 @@ xfs_symlink(
>  		goto out_trans_cancel;
>  
>  	/*
> -	 * Check for ability to enter directory entry, if no space reserved.
> -	 */
> -	if (!resblks) {
> -		error = xfs_dir_canenter(tp, dp, link_name);
> -		if (error)
> -			goto out_trans_cancel;
> -	}
> -	/*
>  	 * Initialize the bmap freelist prior to calling either
>  	 * bmapi or the directory create code.
>  	 */
> @@ -277,7 +264,7 @@ xfs_symlink(
>  	 * Allocate an inode for the symlink.
>  	 */
>  	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
> -			       prid, resblks > 0, &ip, NULL);
> +			       prid, &ip, NULL);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
