Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36588 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731563AbfDET2n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 15:28:43 -0400
Subject: Re: [PATCH 36/36] libxfs: remove libxfs_trans_iget
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259765381.31886.8973943242633989393.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a7d4cba4-2186-b543-7411-ae1d7791d000@sandeen.net>
Date: Fri, 5 Apr 2019 14:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <155259765381.31886.8973943242633989393.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> libxfs_trans_iget no longer has a counterpart in the kernel.  Remove it
> and make the xfs_iget/xfs_trans_ijoin usage consistent throughout
> xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nice, this syncs us up with roughly 2011 I think ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_trans.h      |    2 --
>  libxfs/libxfs_api_defs.h |    1 -
>  libxfs/trans.c           |   35 -----------------------------------
>  libxfs/util.c            |    4 +++-
>  repair/phase6.c          |   21 +++++++++++++++------
>  repair/phase7.c          |    4 ++--
>  6 files changed, 20 insertions(+), 47 deletions(-)
> 
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index 9e44d18e..e6bb74c4 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -98,8 +98,6 @@ void xfs_defer_cancel(struct xfs_trans *);
>  
>  struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
>  
> -int	libxfs_trans_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
> -				uint, uint, struct xfs_inode **);
>  void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
>  void	libxfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, int);
>  void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index e10d78cd..bb0f07bd 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -31,7 +31,6 @@
>  #define xfs_trans_del_item		libxfs_trans_del_item
>  #define xfs_trans_get_buf		libxfs_trans_get_buf
>  #define xfs_trans_getsb			libxfs_trans_getsb
> -#define xfs_trans_iget			libxfs_trans_iget
>  #define xfs_trans_ichgtime		libxfs_trans_ichgtime
>  #define xfs_trans_ijoin			libxfs_trans_ijoin
>  #define xfs_trans_init			libxfs_trans_init
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index ce199654..d6785e20 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -336,41 +336,6 @@ libxfs_trans_cancel(
>  	return;
>  }
>  
> -int
> -libxfs_trans_iget(
> -	xfs_mount_t		*mp,
> -	xfs_trans_t		*tp,
> -	xfs_ino_t		ino,
> -	uint			flags,
> -	uint			lock_flags,
> -	xfs_inode_t		**ipp)
> -{
> -	int			error;
> -	xfs_inode_t		*ip;
> -	xfs_inode_log_item_t	*iip;
> -
> -	if (tp == NULL)
> -		return libxfs_iget(mp, tp, ino, lock_flags, ipp,
> -				&xfs_default_ifork_ops);
> -
> -	error = libxfs_iget(mp, tp, ino, lock_flags, &ip,
> -			&xfs_default_ifork_ops);
> -	if (error)
> -		return error;
> -	ASSERT(ip != NULL);
> -
> -	if (ip->i_itemp == NULL)
> -		xfs_inode_item_init(ip, mp);
> -	iip = ip->i_itemp;
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
> -
> -	/* initialize i_transp so we can find it incore */
> -	ip->i_transp = tp;
> -
> -	*ipp = ip;
> -	return 0;
> -}
> -
>  void
>  libxfs_trans_ijoin(
>  	xfs_trans_t		*tp,
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 0799f965..2e3b9d51 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -262,7 +262,8 @@ libxfs_ialloc(
>  	}
>  	ASSERT(*ialloc_context == NULL);
>  
> -	error = xfs_trans_iget(tp->t_mountp, tp, ino, 0, 0, &ip);
> +	error = libxfs_iget(tp->t_mountp, tp, ino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error != 0)
>  		return error;
>  	ASSERT(ip != NULL);
> @@ -376,6 +377,7 @@ libxfs_ialloc(
>  	/*
>  	 * Log the new values stuffed into the inode.
>  	 */
> +	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_trans_log_inode(tp, ip, flags);
>  	*ipp = ip;
>  	return 0;
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 194cfdbf..28e633de 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -535,7 +535,8 @@ mk_rbmino(xfs_mount_t *mp)
>  	if (i)
>  		res_failed(i);
>  
> -	error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error) {
>  		do_error(
>  		_("couldn't iget realtime bitmap inode -- error - %d\n"),
> @@ -572,6 +573,7 @@ mk_rbmino(xfs_mount_t *mp)
>  	/*
>  	 * commit changes
>  	 */
> +	libxfs_trans_ijoin(tp, ip, 0);
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = -libxfs_trans_commit(tp);
>  	if (error)
> @@ -634,7 +636,8 @@ fill_rbmino(xfs_mount_t *mp)
>  	if (error)
>  		res_failed(error);
>  
> -	error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rbmino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error) {
>  		do_error(
>  		_("couldn't iget realtime bitmap inode -- error - %d\n"),
> @@ -645,6 +648,7 @@ fill_rbmino(xfs_mount_t *mp)
>  		/*
>  		 * fill the file one block at a time
>  		 */
> +		libxfs_trans_ijoin(tp, ip, 0);
>  		nmap = 1;
>  		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
> @@ -703,7 +707,8 @@ fill_rsumino(xfs_mount_t *mp)
>  	if (error)
>  		res_failed(error);
>  
> -	error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error) {
>  		do_error(
>  		_("couldn't iget realtime summary inode -- error - %d\n"),
> @@ -714,6 +719,7 @@ fill_rsumino(xfs_mount_t *mp)
>  		/*
>  		 * fill the file one block at a time
>  		 */
> +		libxfs_trans_ijoin(tp, ip, 0);
>  		nmap = 1;
>  		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
>  		if (error || nmap != 1) {
> @@ -775,7 +781,8 @@ mk_rsumino(xfs_mount_t *mp)
>  	if (i)
>  		res_failed(i);
>  
> -	error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rsumino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error) {
>  		do_error(
>  		_("couldn't iget realtime summary inode -- error - %d\n"),
> @@ -812,6 +819,7 @@ mk_rsumino(xfs_mount_t *mp)
>  	/*
>  	 * commit changes
>  	 */
> +	libxfs_trans_ijoin(tp, ip, 0);
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  	error = -libxfs_trans_commit(tp);
>  	if (error)
> @@ -875,7 +883,8 @@ mk_root_dir(xfs_mount_t *mp)
>  	if (i)
>  		res_failed(i);
>  
> -	error = -libxfs_trans_iget(mp, tp, mp->m_sb.sb_rootino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rootino, 0, &ip,
> +			&xfs_default_ifork_ops);
>  	if (error) {
>  		do_error(_("could not iget root inode -- error - %d\n"), error);
>  	}
> @@ -900,7 +909,7 @@ mk_root_dir(xfs_mount_t *mp)
>  		times |= XFS_ICHGTIME_CREATE;
>  	}
>  	libxfs_trans_ichgtime(tp, ip, times);
> -
> +	libxfs_trans_ijoin(tp, ip, 0);
>  	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  
>  	/*
> diff --git a/repair/phase7.c b/repair/phase7.c
> index c2a60a93..c2996470 100644
> --- a/repair/phase7.c
> +++ b/repair/phase7.c
> @@ -32,8 +32,7 @@ update_inode_nlinks(
>  	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
>  	ASSERT(error == 0);
>  
> -	error = -libxfs_trans_iget(mp, tp, ino, 0, 0, &ip);
> -
> +	error = -libxfs_iget(mp, tp, ino, 0, &ip, &xfs_default_ifork_ops);
>  	if (error)  {
>  		if (!no_modify)
>  			do_error(
> @@ -67,6 +66,7 @@ update_inode_nlinks(
>  	if (!dirty)  {
>  		libxfs_trans_cancel(tp);
>  	} else  {
> +		libxfs_trans_ijoin(tp, ip, 0);
>  		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		/*
>  		 * no need to do a bmap finish since
> 
