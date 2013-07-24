Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D8D57F76
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 07:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1107B8F8049
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:12:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yGzDsnHyreNYfsxr for
	<xfs@oss.sgi.com>; Wed, 24 Jul 2013 05:12:53 -0700 (PDT)
Message-ID: <51EFC401.20209@redhat.com>
Date: Wed, 24 Jul 2013 08:09:37 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/49] xfs: separate icreate log format definitions from
	xfs_icreate_item.h
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/2013 02:24 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The on disk log format definitions for the icreate log item are
> intertwined with the kernel-only in-memory log item definitions.
> Separate the log format definitions out into their own header file
> so they can easily be shared with userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icreate_item.h | 18 ------------------
>  fs/xfs/xfs_log_format.h   | 18 ++++++++++++++++++
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
> index 88ba8aa..59e89f8 100644
> --- a/fs/xfs/xfs_icreate_item.h
> +++ b/fs/xfs/xfs_icreate_item.h
> @@ -18,24 +18,6 @@
>  #ifndef XFS_ICREATE_ITEM_H
>  #define XFS_ICREATE_ITEM_H	1
>  
> -/*
> - * on disk log item structure
> - *
> - * Log recovery assumes the first two entries are the type and size and they fit
> - * in 32 bits. Also in host order (ugh) so they have to be 32 bit aligned so
> - * decoding can be done correctly.
> - */
> -struct xfs_icreate_log {
> -	__uint16_t	icl_type;	/* type of log format structure */
> -	__uint16_t	icl_size;	/* size of log format structure */
> -	__be32		icl_ag;		/* ag being allocated in */
> -	__be32		icl_agbno;	/* start block of inode range */
> -	__be32		icl_count;	/* number of inodes to initialise */
> -	__be32		icl_isize;	/* size of inodes */
> -	__be32		icl_length;	/* length of extent to initialise */
> -	__be32		icl_gen;	/* inode generation number to use */
> -};
> -
>  /* in memory log item structure */
>  struct xfs_icreate_item {
>  	struct xfs_log_item	ic_item;
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index 5963ec7..02639c7 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -602,4 +602,22 @@ typedef struct xfs_qoff_logformat {
>  #define XFS_ALL_QUOTA_CHKD	\
>  		(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD | XFS_PQUOTA_CHKD)
>  
> +/*
> + * Inode create log item structure
> + *
> + * Log recovery assumes the first two entries are the type and size and they fit
> + * in 32 bits. Also in host order (ugh) so they have to be 32 bit aligned so
> + * decoding can be done correctly.
> + */
> +struct xfs_icreate_log {
> +	__uint16_t	icl_type;	/* type of log format structure */
> +	__uint16_t	icl_size;	/* size of log format structure */
> +	__be32		icl_ag;		/* ag being allocated in */
> +	__be32		icl_agbno;	/* start block of inode range */
> +	__be32		icl_count;	/* number of inodes to initialise */
> +	__be32		icl_isize;	/* size of inodes */
> +	__be32		icl_length;	/* length of extent to initialise */
> +	__be32		icl_gen;	/* inode generation number to use */
> +};
> +
>  #endif /* __XFS_LOG_FORMAT_H__ */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
