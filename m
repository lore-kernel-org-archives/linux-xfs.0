Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96DDD7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 16:05:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 856428F8039
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 14:05:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zP0ZpM5Ikrz71o0g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 14:05:40 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9GL5dgm011899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 17:05:39 -0400
Date: Thu, 16 Oct 2014 17:05:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
Message-ID: <20141016210536.GB33732@bfoster.bfoster>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
	<1413397042-32229-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413397042-32229-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 15, 2014 at 03:17:22PM -0300, Carlos Maiolino wrote:
> Adds a new function named xfs_cross_rename(), responsible to handle requests
> from sys_renameat2() using RENAME_EXCHANGE flag.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Hi Carlos,

Some high-level comments from a first pass...

>  fs/xfs/xfs_inode.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_inode.h |   4 ++
>  fs/xfs/xfs_iops.c  |   7 +-
>  3 files changed, 197 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fea3c92..a5bc88d 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2920,6 +2920,193 @@ xfs_rename(
>  	return error;
>  }
>  
> +/* xfs_cross_rename()
> + *
> + * responsible to handle RENAME_EXCHANGE flag
> + * in renameat2() sytemcall
> + */
> +int
> +xfs_cross_rename(
> +	xfs_inode_t	*src_dp,
> +	struct xfs_name	*src_name,
> +	xfs_inode_t	*src_ip,
> +	xfs_inode_t	*target_dp,
> +	struct xfs_name	*target_name,
> +	xfs_inode_t	*target_ip)
> +{
> +	xfs_trans_t	*tp = NULL;
> +	xfs_mount_t	*mp = src_dp->i_mount;
> +	int		new_parent;		/* Crossing from different parents */
> +	int		src_is_directory;
> +	int		tgt_is_directory;
> +	int		error;
> +	xfs_bmap_free_t	free_list;
> +	xfs_fsblock_t	first_block;
> +	int		cancel_flags;
> +	int		committed;
> +	xfs_inode_t	*inodes[4];
> +	int		spaceres;
> +	int		num_inodes;
> +
> +	new_parent = (src_dp != target_dp);
> +	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
> +	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
> +
> +	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
> +				inodes, &num_inodes);
> +
> +	xfs_bmap_init(&free_list, &first_block);
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
> +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
> +	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, spaceres, 0);
> +

It seems to me that the existing block and log reservations would
"cover" the rename exchange case, but it might be worth defining new
reservations for the purpose of clarity and to prevent future problems.

XFS_RENAME_SPACE_RES() covers directory removal and insertion. Here we
are doing neither, which makes me wonder whether we need a block
reservation at all. It does appear that we have a sf dir case where the
inode number could cause a format conversion. Perhaps we need something
that calculates the blocks required for the insertion of the max of both
names (it seems like the conversion would only happen once, but we don't
know which way)? I haven't spent a ton of time in directory code, so I
could easily be missing something.

The tr_rename log reservation considers four inodes, two directory
modifications, a target inode unlink (the overwrite case), and alloc
btree mods for directory blocks being freed. IIUC, the exchange case
should only ever log four inodes and the possible dir format conversion
(e.g., no unlink, no dir block frees). We could define a new
tr_rename_xchg reservation that encodes that and documents it
appropriately in the comment.

It might be worth getting a second opinion from Dave or somebody before
going too far ahead on the logging work...

> +	if (error == -ENOSPC) {
> +		spaceres = 0;
> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_rename, 0, 0);
> +	}
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
> +		goto std_return;
> +	}
> +
> +	/*
> +	 * Attach the dquots to the inodes
> +	 */
> +	error = xfs_qm_vop_rename_dqattach(inodes);
> +	if (error) {
> +		xfs_trans_cancel(tp, cancel_flags);
> +		goto std_return;
> +	}
> +
> +	/*
> +	 * Lock all participating inodes. In case of RENAME_EXCHANGE, target
> +	 * must exist, so we'll be locking at least 3 inodes here.
> +	 */
> +	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
> +
> +	/*
> +	 * Join all the inodes to the transaction. From this point on,
> +	 * we can rely on either trans_commit or trans_cancel to unlock
> +	 * them.
> +	 * target_ip will always exist, so, no need to check its existence.
> +	 */
> +	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	if (new_parent)
> +		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> +
> +	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> +
> +	/*
> +	* If we are using project inheritance, we only allow RENAME_EXCHANGE
> +	* into our tree when the project IDs are the same; else the tree quota
> +	* mechanism would be circumvented.
> +	*/
> +	if (unlikely(((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) ||
> +		     (src_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)) &&
> +		     (xfs_get_projid(src_dp) != xfs_get_projid(target_dp)) )) {
> +		error = -EXDEV;
> +		goto error_return;
> +	}
> +

I think that having a separate helper for the rename exchange case is
generally the right thing. That said, I wonder if we're splitting things
at the right level because it looks like xfs_rename() could handle
everything we have in xfs_cross_rename() up to about this point.

I definitely don't think we should go too far and try to handle all of
this in one function, even if there is some duplication in the directory
name replacement and inode link management. The logic would probably end
up unnecessarily hairy and difficult to reason about.

> +	error = xfs_dir_replace(tp, src_dp, src_name,
> +				target_ip->i_ino,
> +				&first_block, &free_list, spaceres);
> +	if (error)
> +		goto abort_return;
> +
> +	/*
> +	 * Update ".." entry to match the new parent
> +	 */
> +	if (new_parent && tgt_is_directory) {
> +		error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> +					src_dp->i_ino, &first_block, &free_list, spaceres);
> +		if (error)
> +			goto abort_return;
> +	}
> +
> +	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +	error = xfs_dir_replace(tp, target_dp, target_name,
> +				src_ip->i_ino,
> +				&first_block, &free_list, spaceres);
> +	if (error)
> +		goto abort_return;
> +
> +	/*
> +	 * Update ".." entry to match the new parent
> +	 */
> +	if (new_parent && src_is_directory) {
> +		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> +					target_dp->i_ino, &first_block, &free_list, spaceres);
> +		if (error)
> +			goto abort_return;
> +	}
> +
> +	/*
> +	 * In case we are crossing different file types between different
> +	 * parents, we must update parent's link count to match the ".."
> +	 * entry of the new child (or the removal of it).
> +	 */
> +	if (new_parent) {
> +		xfs_trans_ichgtime(tp, target_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +		if (src_is_directory && !tgt_is_directory) {
> +			error = xfs_droplink(tp, src_dp);
> +				if (error)
> +					goto abort_return;
> +			error = xfs_bumplink(tp, target_dp);
> +				if (error)
> +					goto abort_return;
> +		}
> +
> +		if (tgt_is_directory && !src_is_directory) {
> +			error = xfs_droplink(tp, target_dp);
> +				if (error)
> +					goto abort_return;
> +			error = xfs_bumplink(tp, src_dp);
> +				if (error)
> +					goto abort_return;
> +		}
> +
> +		/*
> +		 * We don't need to log the source dir if
> +		 * this is the same as the target.
> +		 */
> +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
> +	}
> +
> +	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);
> +

... and from here to the end also looks equivalent to xfs_rename().
Could we do something like pass the flags (or some new parameter) to
xfs_rename() and convert the meat of the directory update calls into a
couple internal helpers? For example:

xfs_rename(...)
{
	/* setup tp, lock inodes, etc. */

	if (rename_exchange)
		error = xfs_rename_exchange_int(...);
	else
		error = xfs_rename(...);
	if (error)
		...

	/* tp completion handling */

	return xfs_trans_commit(...);

abort_return:
...

	return error;
}

... and that could be done with another refactoring patch to prepare
xfs_rename(). Just a thought.

> +	/*
> +	 * If this is a synchronous mount, make sure the rename transaction goes
> +	 * to disk before returning to the user.
> +	 */
> +	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
> +		xfs_trans_set_sync(tp);
> +
> +	error = xfs_bmap_finish(&tp, &free_list, &committed);
> +	if (error) {
> +		xfs_bmap_cancel(&free_list);
> +		xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
> +		goto std_return;
> +	}
> +
> +	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> +
> +abort_return:
> +	cancel_flags |= XFS_TRANS_ABORT;
> +error_return:
> +	xfs_bmap_cancel(&free_list);
> +	xfs_trans_cancel(tp, cancel_flags);
> +std_return:
> +	return error;
> +
> +}
> +
>  STATIC int
>  xfs_iflush_cluster(
>  	xfs_inode_t	*ip,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c10e3fa..16889d3 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -341,6 +341,10 @@ int		xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
>  			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
>  			   struct xfs_name *target_name,
>  			   struct xfs_inode *target_ip);
> +int		xfs_cross_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
> +			   struct xfs_inode *src_ip, struct xfs_inode *target_dp,
> +			   struct xfs_name *target_name,
> +			   struct xfs_inode *target_ip);
>  
>  void		xfs_ilock(xfs_inode_t *, uint);
>  int		xfs_ilock_nowait(xfs_inode_t *, uint);
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b2b92c7..bc164df 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -391,12 +391,17 @@ xfs_vn_rename2(
>  	struct xfs_name	nname;
>  
>  	/* XFS does not support RENAME_EXCHANGE yet */
> -	if (flags & ~RENAME_NOREPLACE)
> +	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE))
>  		return -EINVAL;
>  
>  	xfs_dentry_to_name(&oname, odentry, 0);

This might need to be handled differently for the exchange case. As
below, the new dentry always gets the old mode. I suspect we don't care
about the mode of the original dentry in traditional rename since that
entry goes away. It looks like it would be set to 0 here in the exchange
case, however, rather than ndentry->d_inode->i_mode (which we can't
assume exists for the non-exchange case).

Brian

>  	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
>  
> +	if (flags & RENAME_EXCHANGE)
> +		return xfs_cross_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
> +					XFS_I(ndir), &nname,
> +					new_inode ? XFS_I(new_inode) : NULL);
> +
>  	return xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
>  			  XFS_I(ndir), &nname,
>  			  new_inode ? XFS_I(new_inode) : NULL);
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
