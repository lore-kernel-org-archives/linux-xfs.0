Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 617757F54
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 09:11:46 -0500 (CDT)
Message-ID: <522F289E.6070802@sgi.com>
Date: Tue, 10 Sep 2013 09:11:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/55 V2] libxfs: switch over to xfs_sb.c and remove
	xfs_mount.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-32-git-send-email-david@fromorbit.com>
	<522A1BCA.6010500@sgi.com> <20130906214021.GD12541@dastard>
	<522A4C79.1030200@sgi.com> <20130910010241.GZ12779@dastard>
In-Reply-To: <20130910010241.GZ12779@dastard>
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

On 09/09/13 20:02, Dave Chinner wrote:
> diff --git a/include/xfs_sb.h b/include/xfs_sb.h
> index 4a710d6..04fe32a 100644
> --- a/include/xfs_sb.h
> +++ b/include/xfs_sb.h
> @@ -26,6 +26,7 @@
>
>   struct xfs_buf;
>   struct xfs_mount;
> +struct xfs_trans;
>
>   #define	XFS_SB_MAGIC		0x58465342	/* 'XFSB' */
>   #define	XFS_SB_VERSION_1	1		/* 5.3, 6.0.1, 6.1 */
> @@ -630,6 +631,12 @@ static inline int xfs_sb_version_has_pquotino(xfs_sb_t *sbp)
>   	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>   }
>
> +static inline bool
> +xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> +{
> +	return (ino == sbp->sb_uquotino || ino == sbp->sb_gquotino);
> +}
> +
>   /*

Thanks Dave for doing all this work.

The current kernel xfs_sb.h has an additional
   " || ino == sbp->sb_pquotino"
from kernel commit d892d586 that is not making it into  user xfs_sb.h.

It is wrong to add it here but in a follow up patch (Chandra?).

I am happy with the kernel / user sync series.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
