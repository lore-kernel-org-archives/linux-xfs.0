Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43039 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdGRTvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 15:51:08 -0400
Subject: Re: [PATCH 2/2] libxfs: allow xfs_repair to bypass inode fork read
 verifiers
References: <150040480534.16432.7424988688113046337.stgit@magnolia>
 <150040481174.16432.15688892139606580088.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <374a2285-fbf4-ca95-26fc-d63660c7c893@oracle.com>
Date: Tue, 18 Jul 2017 12:51:02 -0700
MIME-Version: 1.0
In-Reply-To: <150040481174.16432.15688892139606580088.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

This one too.

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

Thanks!

On 07/18/2017 12:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> In xfs_repair phase 6, we want to be able to check and fix short form
> directory inodes.  However, if the directory is already corrupt, the
> read verifier prevents us from loading the inode, which prevents us from
> fixing it.  Therefore, allow _iget callers to bypass the read verifier.
> Note that we do /not/ allow bypassing of the write verifier, ever.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   include/xfs_inode.h     |    3 +++
>   libxfs/libxfs_priv.h    |    3 ---
>   libxfs/xfs_inode_buf.c  |    3 ++-
>   libxfs/xfs_inode_fork.c |   15 ++++++++-------
>   libxfs/xfs_inode_fork.h |    2 +-
>   repair/phase6.c         |    2 +-
>   6 files changed, 15 insertions(+), 13 deletions(-)
>
>
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 5d5158e..b2f2af5 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -148,6 +148,9 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
>   extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
>   
>   /* Inode Cache Interfaces */
> +#define XFS_IGET_CREATE			0x1
> +#define XFS_IGET_UNTRUSTED		0x2
> +#define XFS_IGET_SKIP_FORK_VERIFY	0x4
>   extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>   				uint, uint, struct xfs_inode **);
>   extern void	libxfs_iput(struct xfs_inode *);
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 4f5ba7c..da1cc20 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -103,9 +103,6 @@ extern char    *progname;
>   #define ATTR_KERNOTIME			0
>   #define ATTR_KERNOVAL			0
>   
> -#define XFS_IGET_CREATE			0x1
> -#define XFS_IGET_UNTRUSTED		0x2
> -
>   extern void cmn_err(int, char *, ...);
>   enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
>   
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index b0f2c0d..174a24e 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -522,7 +522,8 @@ xfs_iread(
>   	 */
>   	if (dip->di_mode) {
>   		xfs_inode_from_disk(ip, dip);
> -		error = xfs_iformat_fork(ip, dip);
> +		error = xfs_iformat_fork(ip, dip,
> +				!(iget_flags & XFS_IGET_SKIP_FORK_VERIFY));
>   		if (error)  {
>   #ifdef DEBUG
>   			xfs_alert(mp, "%s: xfs_iformat() returned error %d",
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index 0ef989d..e8379e1 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -50,13 +50,14 @@ STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
>    */
>   int
>   xfs_iformat_fork(
> -	xfs_inode_t		*ip,
> -	xfs_dinode_t		*dip)
> +	struct xfs_inode		*ip,
> +	struct xfs_dinode		*dip,
> +	bool				verify_fork)
>   {
> -	xfs_attr_shortform_t	*atp;
> -	int			size;
> -	int			error = 0;
> -	xfs_fsize_t             di_size;
> +	struct xfs_attr_shortform	*atp;
> +	int				size;
> +	int				error = 0;
> +	xfs_fsize_t			di_size;
>   
>   	if (unlikely(be32_to_cpu(dip->di_nextents) +
>   		     be16_to_cpu(dip->di_anextents) >
> @@ -181,7 +182,7 @@ xfs_iformat_fork(
>   		return error;
>   
>   	/* Check inline dir contents. */
> -	if (S_ISDIR(VFS_I(ip)->i_mode) &&
> +	if (verify_fork && S_ISDIR(VFS_I(ip)->i_mode) &&
>   	    dip->di_format == XFS_DINODE_FMT_LOCAL) {
>   		error = xfs_dir2_sf_verify(ip);
>   		if (error) {
> diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
> index 7fb8365..7a24288 100644
> --- a/libxfs/xfs_inode_fork.h
> +++ b/libxfs/xfs_inode_fork.h
> @@ -139,7 +139,7 @@ typedef struct xfs_ifork {
>   
>   struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
>   
> -int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
> +int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *, bool);
>   void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
>   				struct xfs_inode_log_item *, int);
>   void		xfs_idestroy_fork(struct xfs_inode *, int);
> diff --git a/repair/phase6.c b/repair/phase6.c
> index 011bcdf..5edfd29 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -2817,7 +2817,7 @@ process_dir_inode(
>   
>   	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
>   
> -	error = -libxfs_iget(mp, NULL, ino, 0, 0, &ip);
> +	error = -libxfs_iget(mp, NULL, ino, XFS_IGET_SKIP_FORK_VERIFY, 0, &ip);
>   	if (error) {
>   		if (!no_modify)
>   			do_error(
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

