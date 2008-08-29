Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 29 Aug 2008 11:10:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7TI9uqA001238
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2008 11:09:59 -0700
Date: Fri, 29 Aug 2008 14:11:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace
	(libxfs)
Message-ID: <20080829181120.GA9455@infradead.org>
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Aug 29, 2008 at 05:59:43PM +1000, Barry Naujok wrote:
> On Fri, 29 Aug 2008 17:00:56 +1000, Barry Naujok <bnaujok@sgi.com> wrote:
>
>> Mostly header changes associated with #ifdef __KERNEL__ stuff.
>>
>> Some function prototypes had to be reordered to separate
>> shared and kernel only functions.
>
> fs/xfs/xfs_inode.h patch looked pretty horrid (and there was a missing
> declaration), here's a better version:

I still don't like it very much :)  What about just moving the
xfs_ictimestamp and xfs_icdinode defintions next to the ifork
so that we can save one ifdef __KERNEL__?  Also might be worth
to move the xfs_iflock & co inlines before the end of that __KERNEL__
block to save another ifdef.

>
> Index: 2.6.x-xfs/fs/xfs/xfs_inode.h
> ===================================================================
> --- 2.6.x-xfs.orig/fs/xfs/xfs_inode.h
> +++ 2.6.x-xfs/fs/xfs/xfs_inode.h
> @@ -131,6 +131,8 @@ typedef struct dm_attrs_s {
>  	__uint16_t	da_pad;		/* DMIG extra padding */
>  } dm_attrs_t;
>
> +#endif	/* __KERNEL__ */
> +
>  /*
>   * This is the xfs in-core inode structure.
>   * Most of the on-disk inode is embedded in the i_d field.
> @@ -191,6 +193,8 @@ typedef struct xfs_icdinode {
>  	__uint32_t	di_gen;		/* generation number */
>  } xfs_icdinode_t;
>
> +#ifdef __KERNEL__
> +
>  typedef struct {
>  	struct xfs_inode	*ip_mnext;	/* next inode in mount list */
>  	struct xfs_inode	*ip_mprev;	/* ptr to prev inode */
> @@ -490,19 +494,12 @@ int		xfs_finish_reclaim_all(struct xfs_m
>  /*
>   * xfs_inode.c prototypes.
>   */
> -int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
> -			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
> -			  xfs_daddr_t, uint, uint);
>  int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
>  			  xfs_inode_t **, xfs_daddr_t, uint);
>  int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
>  int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
>  			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
>  			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
> -void		xfs_dinode_from_disk(struct xfs_icdinode *,
> -				     struct xfs_dinode_core *);
> -void		xfs_dinode_to_disk(struct xfs_dinode_core *,
> -				   struct xfs_icdinode *);
>
>  uint		xfs_ip2xflags(struct xfs_inode *);
>  uint		xfs_dic2xflags(struct xfs_dinode *);
> @@ -514,15 +511,11 @@ int		xfs_itruncate_finish(struct xfs_tra
>  int		xfs_iunlink(struct xfs_trans *, xfs_inode_t *);
>
>  struct xfs_inode * xfs_inode_alloc(struct xfs_mount *, xfs_ino_t);
> -void		xfs_idestroy_fork(xfs_inode_t *, int);
>  void		xfs_idestroy(xfs_inode_t *);
> -void		xfs_idata_realloc(xfs_inode_t *, int, int);
>  void		xfs_iextract(xfs_inode_t *);
>  void		xfs_iext_realloc(xfs_inode_t *, int, int);
> -void		xfs_iroot_realloc(xfs_inode_t *, int, int);
>  void		xfs_ipin(xfs_inode_t *);
>  void		xfs_iunpin(xfs_inode_t *);
> -int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
>  int		xfs_iflush(xfs_inode_t *, uint);
>  void		xfs_iflush_all(struct xfs_mount *);
>  void		xfs_ichgtime(xfs_inode_t *, int);
> @@ -532,6 +525,19 @@ void		xfs_lock_two_inodes(xfs_inode_t *,
>
>  void		xfs_synchronize_atime(xfs_inode_t *);
>  void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
> +#endif /* __KERNEL__ */
> +
> +int		xfs_itobp(struct xfs_mount *, struct xfs_trans *,
> +			  xfs_inode_t *, struct xfs_dinode **, struct xfs_buf **,
> +			  xfs_daddr_t, uint, uint);
> +void		xfs_dinode_from_disk(struct xfs_icdinode *,
> +				     struct xfs_dinode_core *);
> +void		xfs_dinode_to_disk(struct xfs_dinode_core *,
> +				   struct xfs_icdinode *);
> +void		xfs_idestroy_fork(xfs_inode_t *, int);
> +void		xfs_idata_realloc(xfs_inode_t *, int, int);
> +void		xfs_iroot_realloc(xfs_inode_t *, int, int);
> +int		xfs_iextents_copy(xfs_inode_t *, xfs_bmbt_rec_t *, int);
>
>  xfs_bmbt_rec_host_t *xfs_iext_get_ext(xfs_ifork_t *, xfs_extnum_t);
>  void		xfs_iext_insert(xfs_ifork_t *, xfs_extnum_t, xfs_extnum_t,
> @@ -577,6 +583,8 @@ extern struct kmem_zone	*xfs_ifork_zone;
>  extern struct kmem_zone	*xfs_inode_zone;
>  extern struct kmem_zone	*xfs_ili_zone;
>
> +#ifdef __KERNEL__
> +
>  /*
>   * Manage the i_flush queue embedded in the inode.  This completion
>   * queue synchronizes processes attempting to flush the in-core
>
>
---end quoted text---
