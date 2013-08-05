Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F92D7CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:57:12 -0500 (CDT)
Message-ID: <52001FB7.3010901@sgi.com>
Date: Mon, 05 Aug 2013 16:57:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 28/49] xfs: move unrealted definitions out of xfs_inode.h
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-29-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-29-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index e504103..37aca08 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -89,6 +89,13 @@ struct xfs_log_item_desc {
>   #define	XFS_ATTR_BTREE_REF	1
>   #define	XFS_DQUOT_REF		1
>
> +/*
> + * Flags for xfs_trans_ichgtime().
> + */
> +#define	XFS_ICHGTIME_MOD	0x1	/* data fork modification timestamp */
> +#define	XFS_ICHGTIME_CHG	0x2	/* inode field change timestamp */
> +#define	XFS_ICHGTIME_CREATE	0x4	/* inode create timestamp */
> +

in the kernel patch 13/49 these entries go into xfs_log_format.h

>   #ifdef __KERNEL__
>
>   struct xfs_buf;
> diff --git a/libxfs/xfs.h b/libxfs/xfs.h
> index 7149c09..1a01c61 100644
> --- a/libxfs/xfs.h
> +++ b/libxfs/xfs.h
> @@ -68,6 +68,9 @@ typedef __uint32_t		inst_t;		/* an instruction */
>
>   #define IHOLD(ip)			((void) 0)
>
> +#define XFS_IGET_CREATE			0x1
> +#define XFS_IGET_UNTRUSTED		0x2
> +
>   /* stop unused var warnings by assigning mp to itself */
>   #define XFS_CORRUPTION_ERROR(e,l,mp,m)	do { \
>   	(mp) = (mp); \

in the kernel patch 13/49 these entries go into xfs_icache.h

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
