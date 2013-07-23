Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C160D7F4E
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 09:05:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 405CAAC008
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 07:05:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3bx7buER9ESTMDaD for
	<xfs@oss.sgi.com>; Tue, 23 Jul 2013 07:05:12 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6NE5Bu9003499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 10:05:11 -0400
Received: from laptop.bfoster (vpn-63-213.rdu2.redhat.com [10.10.63.213])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r6NE5AVp008351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 10:05:11 -0400
Message-ID: <51EE8CD6.9070004@redhat.com>
Date: Tue, 23 Jul 2013 10:01:58 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/49] xfs: split out inode log item format definition
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-5-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On 07/19/2013 02:24 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The EFI/EFD item format definitions are shared with userspace. Split
> the out of header files that contain kernel only defintions to make
> it simple to shared them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.h | 88 ++---------------------------------------------
>  fs/xfs/xfs_log_format.h   | 83 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 86 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index 4322224..0ffbce3 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -18,93 +18,11 @@
>  #ifndef	__XFS_EXTFREE_ITEM_H__
>  #define	__XFS_EXTFREE_ITEM_H__
>  
> +/* kernel only EFI/EFD definitions */
> +
>  struct xfs_mount;
>  struct kmem_zone;
>  
> -typedef struct xfs_extent {
> -	xfs_dfsbno_t	ext_start;
> -	xfs_extlen_t	ext_len;
> -} xfs_extent_t;
> -
> -/*
> - * Since an xfs_extent_t has types (start:64, len: 32)
> - * there are different alignments on 32 bit and 64 bit kernels.
> - * So we provide the different variants for use by a
> - * conversion routine.
> - */
> -
> -typedef struct xfs_extent_32 {
> -	__uint64_t	ext_start;
> -	__uint32_t	ext_len;
> -} __attribute__((packed)) xfs_extent_32_t;
> -
> -typedef struct xfs_extent_64 {
> -	__uint64_t	ext_start;
> -	__uint32_t	ext_len;
> -	__uint32_t	ext_pad;
> -} xfs_extent_64_t;
> -
> -/*
> - * This is the structure used to lay out an efi log item in the
> - * log.  The efi_extents field is a variable size array whose
> - * size is given by efi_nextents.
> - */
> -typedef struct xfs_efi_log_format {
> -	__uint16_t		efi_type;	/* efi log item type */
> -	__uint16_t		efi_size;	/* size of this item */
> -	__uint32_t		efi_nextents;	/* # extents to free */
> -	__uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_t		efi_extents[1];	/* array of extents to free */
> -} xfs_efi_log_format_t;
> -
> -typedef struct xfs_efi_log_format_32 {
> -	__uint16_t		efi_type;	/* efi log item type */
> -	__uint16_t		efi_size;	/* size of this item */
> -	__uint32_t		efi_nextents;	/* # extents to free */
> -	__uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
> -} __attribute__((packed)) xfs_efi_log_format_32_t;
> -
> -typedef struct xfs_efi_log_format_64 {
> -	__uint16_t		efi_type;	/* efi log item type */
> -	__uint16_t		efi_size;	/* size of this item */
> -	__uint32_t		efi_nextents;	/* # extents to free */
> -	__uint64_t		efi_id;		/* efi identifier */
> -	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
> -} xfs_efi_log_format_64_t;
> -
> -/*
> - * This is the structure used to lay out an efd log item in the
> - * log.  The efd_extents array is a variable size array whose
> - * size is given by efd_nextents;
> - */
> -typedef struct xfs_efd_log_format {
> -	__uint16_t		efd_type;	/* efd log item type */
> -	__uint16_t		efd_size;	/* size of this item */
> -	__uint32_t		efd_nextents;	/* # of extents freed */
> -	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> -} xfs_efd_log_format_t;
> -
> -typedef struct xfs_efd_log_format_32 {
> -	__uint16_t		efd_type;	/* efd log item type */
> -	__uint16_t		efd_size;	/* size of this item */
> -	__uint32_t		efd_nextents;	/* # of extents freed */
> -	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
> -} __attribute__((packed)) xfs_efd_log_format_32_t;
> -
> -typedef struct xfs_efd_log_format_64 {
> -	__uint16_t		efd_type;	/* efd log item type */
> -	__uint16_t		efd_size;	/* size of this item */
> -	__uint32_t		efd_nextents;	/* # of extents freed */
> -	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> -	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
> -} xfs_efd_log_format_64_t;
> -
> -
> -#ifdef __KERNEL__
> -
>  /*
>   * Max number of extents in fast allocation path.
>   */
> @@ -160,6 +78,4 @@ int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
>  					    xfs_efi_log_format_t *dst_efi_fmt);
>  void			xfs_efi_item_free(xfs_efi_log_item_t *);
>  
> -#endif	/* __KERNEL__ */
> -
>  #endif	/* __XFS_EXTFREE_ITEM_H__ */
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index 77a6024..d1e93d3 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -461,4 +461,87 @@ xfs_blft_from_flags(struct xfs_buf_log_format *blf)
>  	return (blf->blf_flags & XFS_BLFT_MASK) >> XFS_BLFT_SHIFT;
>  }
>  
> +/*
> + * EFI/EFD log format definitions
> + */
> +typedef struct xfs_extent {
> +	xfs_dfsbno_t	ext_start;
> +	xfs_extlen_t	ext_len;
> +} xfs_extent_t;
> +
> +/*
> + * Since an xfs_extent_t has types (start:64, len: 32)
> + * there are different alignments on 32 bit and 64 bit kernels.
> + * So we provide the different variants for use by a
> + * conversion routine.
> + */
> +typedef struct xfs_extent_32 {
> +	__uint64_t	ext_start;
> +	__uint32_t	ext_len;
> +} __attribute__((packed)) xfs_extent_32_t;
> +
> +typedef struct xfs_extent_64 {
> +	__uint64_t	ext_start;
> +	__uint32_t	ext_len;
> +	__uint32_t	ext_pad;
> +} xfs_extent_64_t;
> +
> +/*
> + * This is the structure used to lay out an efi log item in the
> + * log.  The efi_extents field is a variable size array whose
> + * size is given by efi_nextents.
> + */
> +typedef struct xfs_efi_log_format {
> +	__uint16_t		efi_type;	/* efi log item type */
> +	__uint16_t		efi_size;	/* size of this item */
> +	__uint32_t		efi_nextents;	/* # extents to free */
> +	__uint64_t		efi_id;		/* efi identifier */
> +	xfs_extent_t		efi_extents[1];	/* array of extents to free */
> +} xfs_efi_log_format_t;
> +
> +typedef struct xfs_efi_log_format_32 {
> +	__uint16_t		efi_type;	/* efi log item type */
> +	__uint16_t		efi_size;	/* size of this item */
> +	__uint32_t		efi_nextents;	/* # extents to free */
> +	__uint64_t		efi_id;		/* efi identifier */
> +	xfs_extent_32_t		efi_extents[1];	/* array of extents to free */
> +} __attribute__((packed)) xfs_efi_log_format_32_t;
> +
> +typedef struct xfs_efi_log_format_64 {
> +	__uint16_t		efi_type;	/* efi log item type */
> +	__uint16_t		efi_size;	/* size of this item */
> +	__uint32_t		efi_nextents;	/* # extents to free */
> +	__uint64_t		efi_id;		/* efi identifier */
> +	xfs_extent_64_t		efi_extents[1];	/* array of extents to free */
> +} xfs_efi_log_format_64_t;
> +
> +/*
> + * This is the structure used to lay out an efd log item in the
> + * log.  The efd_extents array is a variable size array whose
> + * size is given by efd_nextents;
> + */
> +typedef struct xfs_efd_log_format {
> +	__uint16_t		efd_type;	/* efd log item type */
> +	__uint16_t		efd_size;	/* size of this item */
> +	__uint32_t		efd_nextents;	/* # of extents freed */
> +	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> +	xfs_extent_t		efd_extents[1];	/* array of extents freed */
> +} xfs_efd_log_format_t;
> +
> +typedef struct xfs_efd_log_format_32 {
> +	__uint16_t		efd_type;	/* efd log item type */
> +	__uint16_t		efd_size;	/* size of this item */
> +	__uint32_t		efd_nextents;	/* # of extents freed */
> +	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> +	xfs_extent_32_t		efd_extents[1];	/* array of extents freed */
> +} __attribute__((packed)) xfs_efd_log_format_32_t;
> +
> +typedef struct xfs_efd_log_format_64 {
> +	__uint16_t		efd_type;	/* efd log item type */
> +	__uint16_t		efd_size;	/* size of this item */
> +	__uint32_t		efd_nextents;	/* # of extents freed */
> +	__uint64_t		efd_efi_id;	/* id of corresponding efi */
> +	xfs_extent_64_t		efd_extents[1];	/* array of extents freed */
> +} xfs_efd_log_format_64_t;
> +
>  #endif /* __XFS_LOG_FORMAT_H__ */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
