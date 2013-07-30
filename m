Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A17B29DFC
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 11:20:19 -0500 (CDT)
Message-ID: <51F7E7BF.6020108@sgi.com>
Date: Tue, 30 Jul 2013 11:20:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/49] xfs: split out inode log item format definition
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-3-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:24, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Th elog item format definitions are shared with userspace. split the
> out of header files that contain kernel only defintions to make it
> simple to shared them.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

>   #include "xfs_mount.h"
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index b55fd34..de4f963 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h

...

> - * NOTE:  This structure must be kept identical to struct xfs_dinode
> - * 	  in xfs_dinode.h except for the endianness annotations.
> - */
> -typedef struct xfs_icdinode {
> -	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */

...

> -	uuid_t		di_uuid;	/* UUID of the filesystem */
> -
> -	/* structure must be padded to 64 bit alignment */
> -} xfs_icdinode_t;
> -

...
> diff --git a/fs/xfs/xfs_log_format.h b/fs/xfs/xfs_log_format.h
> index 9f9aeb6..fd46a7f 100644
> --- a/fs/xfs/xfs_log_format.h
> +++ b/fs/xfs/xfs_log_format.h
> @@ -18,6 +18,16 @@
>   #ifndef	__XFS_LOG_FORMAT_H__
>   #define __XFS_LOG_FORMAT_H__
>
> +/*
> + * On-disk Log Format definitions.
> + *
> + * This file contains all the on-disk format definitions used within the log. It
> + * includes the physical log structure itself, as well as all the log item
> + * format structures that are written into the log and intepreted by log
> + * recovery. We start with the physical log format definitions, and then work
> + * through all the log items definitions and everything they encode into the
> + * log.
> + */

...

> +static inline int xfs_ilog_fdata(int w)
> +{
> +	return (w == XFS_DATA_FORK ? XFS_ILOG_DDATA : XFS_ILOG_ADATA);
> +}
> +
> +/*
> + * Incore version of the on-disk inode core structures. We log this directly
> + * into the journal in host CPU format (for better or worse) and as such
> + * directly mirrors the xfs_dinode structure as it must contain all the same
> + * information.
> + */
> +typedef struct xfs_ictimestamp {
> +	__int32_t	t_sec;		/* timestamp seconds */
> +	__int32_t	t_nsec;		/* timestamp nanoseconds */
> +} xfs_ictimestamp_t;
> +
> +/*
> + * NOTE:  This structure must be kept identical to struct xfs_dinode
> + *	  in xfs_dinode.h except for the endianness annotations.
> + */
> +typedef struct xfs_icdinode {
> +	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
> +	__uint16_t	di_mode;	/* mode and type of file */

...

> +	uuid_t		di_uuid;	/* UUID of the filesystem */
> +
> +	/* structure must be padded to 64 bit alignment */
> +} xfs_icdinode_t;


A log header file does not strike me as the place for the internal 
representation of the on disk inode structure.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
