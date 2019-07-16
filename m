Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37134 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733067AbfGPLiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 07:38:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so18335775wme.2
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 04:38:08 -0700 (PDT)
Date: Tue, 16 Jul 2019 13:38:05 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/4] xfsprogs: don't use enum for buffer flags
Message-ID: <20190716113805.jx4nch3aclzwjrrc@pegasus.maiolino.io>
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
 <9a4275dd-3e33-1fbb-efd4-57db6f646bff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4275dd-3e33-1fbb-efd4-57db6f646bff@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 12, 2019 at 04:46:59PM -0500, Eric Sandeen wrote:
> This roughly mirrors
> 
>   807cbbdb xfs: do not use emums for flags used in tracing
> 
> and lets us use the xfs_buf_flags_t type in function calls as is
> done in the kernel.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index 60e1dbdb..926fe102 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -107,12 +107,12 @@ bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
>  struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
>  					struct xfs_buftarg *btp,
>  					struct xfs_buf_map *map, int nmaps,
> -					uint flags);
> +					xfs_buf_flags_t flags);
>  
>  int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  struct xfs_buftarg *btp,
>  				  struct xfs_buf_map *map, int nmaps,
> -				  uint flags, struct xfs_buf **bpp,
> +				  xfs_buf_flags_t flags, struct xfs_buf **bpp,
>  				  const struct xfs_buf_ops *ops);
>  static inline struct xfs_buf *
>  libxfs_trans_get_buf(
> @@ -133,7 +133,7 @@ libxfs_trans_read_buf(
>  	struct xfs_buftarg	*btp,
>  	xfs_daddr_t		blkno,
>  	int			numblks,
> -	uint			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 79ffd470..e09dd849 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -81,14 +81,15 @@ typedef struct xfs_buf {
>  bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
>  bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
>  
> -enum xfs_buf_flags_t {	/* b_flags bits */
> -	LIBXFS_B_EXIT		= 0x0001,	/* ==LIBXFS_EXIT_ON_FAILURE */
> -	LIBXFS_B_DIRTY		= 0x0002,	/* buffer has been modified */
> -	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
> -	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
> -	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
> -	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
> -};
> +/* b_flags bits */
> +#define LIBXFS_B_EXIT		0x0001	/* ==LIBXFS_EXIT_ON_FAILURE */
> +#define LIBXFS_B_DIRTY		0x0002	/* buffer has been modified */
> +#define LIBXFS_B_STALE		0x0004	/* buffer marked as invalid */
> +#define LIBXFS_B_UPTODATE	0x0008	/* buffer is sync'd to disk */
> +#define LIBXFS_B_DISCONTIG	0x0010	/* discontiguous buffer */
> +#define LIBXFS_B_UNCHECKED	0x0020	/* needs verification */
> +
> +typedef unsigned int xfs_buf_flags_t;

I'd argue about the need of hiding an unsigned int into a typedef, which IMHO
doesn't look necessary here, but I also don't see why not if your main reason is
try to care about your sanity and bring xfsprogs code closer to kernel, other
than that, the patch is fine and you can add my review tag with or without the
typedef.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers

>  
>  #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
>  
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 453e5476..faf36daa 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -404,7 +404,7 @@ libxfs_trans_get_buf_map(
>  	struct xfs_buftarg	*target,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> -	uint			flags)
> +	xfs_buf_flags_t		flags)
>  {
>  	xfs_buf_t		*bp;
>  	struct xfs_buf_log_item	*bip;
> @@ -480,7 +480,7 @@ libxfs_trans_read_buf_map(
>  	struct xfs_buftarg	*target,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> -	uint			flags,
> +	xfs_buf_flags_t		flags,
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> 
> 

-- 
Carlos
