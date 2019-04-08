Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35998 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbfDHWm2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Apr 2019 18:42:28 -0400
Date: Mon, 8 Apr 2019 15:42:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfsprogs: remove unused function prototypes
Message-ID: <20190408224214.GC5147@magnolia>
References: <d708b5f4-a955-43eb-dbee-56e8a0606aa4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d708b5f4-a955-43eb-dbee-56e8a0606aa4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 08, 2019 at 05:39:31PM -0500, Eric Sandeen wrote:
> These are prototypes for functions that aren't defined anywhere in
> the code, so remove them.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/db/crc.h b/db/crc.h
> index ca2621f..e5cc53d 100644
> --- a/db/crc.h
> +++ b/db/crc.h
> @@ -7,4 +7,3 @@
>  struct field;
>  
>  extern void	crc_init(void);
> -extern void	crc_struct(const field_t *fields, int argc, char **argv);
> diff --git a/db/faddr.h b/db/faddr.h
> index 371bef4..50c4b01 100644
> --- a/db/faddr.h
> +++ b/db/faddr.h
> @@ -13,7 +13,6 @@ extern void	fa_cfileoffd(void *obj, int bit, typnm_t next);
>  extern void	fa_cfsblock(void *obj, int bit, typnm_t next);
>  extern void	fa_dfiloffd(void *obj, int bit, typnm_t next);
>  extern void	fa_dfsbno(void *obj, int bit, typnm_t next);
> -extern void	fa_dinode_union(void *obj, int bit, typnm_t next);
>  extern void	fa_dirblock(void *obj, int bit, typnm_t next);
>  extern void	fa_drfsbno(void *obj, int bit, typnm_t next);
>  extern void	fa_drtbno(void *obj, int bit, typnm_t next);
> diff --git a/db/io.h b/db/io.h
> index 7618be4..c29a748 100644
> --- a/db/io.h
> +++ b/db/io.h
> @@ -46,8 +46,7 @@ extern void	pop_cur(void);
>  extern void	print_iocur(char *tag, iocur_t *ioc);
>  extern void	push_cur(void);
>  extern void	push_cur_and_set_type(void);
> -extern int	read_buf(int64_t daddr, int count, void *bufp);
> -extern void     write_cur(void);
> +extern void	write_cur(void);
>  extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
>  			int len, int ring_add, bbmap_t *bbmap);
>  extern void     ring_add(void);
> diff --git a/include/input.h b/include/input.h
> index 4878d69..6d8dbcc 100644
> --- a/include/input.h
> +++ b/include/input.h
> @@ -19,7 +19,6 @@ extern char	*fetchline(void);
>  
>  extern size_t numlen(uint64_t val, size_t base);
>  
> -extern struct timeval tadd(struct timeval t1, struct timeval t2);
>  extern struct timeval tsub(struct timeval t1, struct timeval t2);
>  extern double	tdiv(double value, struct timeval tv);
>  
> diff --git a/include/libxlog.h b/include/libxlog.h
> index 6c79115..92c54f4 100644
> --- a/include/libxlog.h
> +++ b/include/libxlog.h
> @@ -88,7 +88,6 @@ extern int	xlog_find_cycle_start(struct xlog *log, xfs_buf_t *bp,
>  extern int	xlog_find_tail(struct xlog *log, xfs_daddr_t *head_blk,
>  				xfs_daddr_t *tail_blk);
>  
> -extern int	xlog_test_footer(struct xlog *log);
>  extern int	xlog_recover(struct xlog *log, int readonly);
>  extern void	xlog_recover_print_data(char *p, int len);
>  extern void	xlog_recover_print_logitem(xlog_recover_item_t *item);
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 12064d7..5bcf733 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -176,7 +176,6 @@ extern void	libxfs_bcache_free(void);
>  extern void	libxfs_bcache_flush(void);
>  extern void	libxfs_purgebuf(xfs_buf_t *);
>  extern int	libxfs_bcache_overflowed(void);
> -extern int	libxfs_bcache_usage(void);
>  
>  /* Buffer (Raw) Interfaces */
>  extern xfs_buf_t *libxfs_getbufr(struct xfs_buftarg *, xfs_daddr_t, int);
> diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
> index 59f9fb2..08643a3 100644
> --- a/libxfs/xfs_dir2_priv.h
> +++ b/libxfs/xfs_dir2_priv.h
> @@ -119,8 +119,4 @@ extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
>  extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
>  extern xfs_failaddr_t xfs_dir2_sf_verify(struct xfs_inode *ip);
>  
> -/* xfs_dir2_readdir.c */
> -extern int xfs_readdir(struct xfs_trans *tp, struct xfs_inode *dp,
> -		       struct dir_context *ctx, size_t bufsize);
> -
>  #endif /* __XFS_DIR2_PRIV_H__ */
> 
