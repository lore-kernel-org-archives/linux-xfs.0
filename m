Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39744 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933452AbeFKSPb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 14:15:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BIBZLe148224
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:15:31 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2jgecxduvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:15:31 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5BIFUuC013674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:15:30 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5BIFUgI016669
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 18:15:30 GMT
Date: Mon, 11 Jun 2018 11:15:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 25/27] xfsprogs: Add parent pointers during protofile
 creation
Message-ID: <20180611181529.GG22045@magnolia>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-26-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528607272-11122-26-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jun 09, 2018 at 10:07:50PM -0700, Allison Henderson wrote:
> Inodes created from protofile parsing will also need to
> add the appropriate parent pointers
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  mkfs/proto.c | 55 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index 67c228a..222479f 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -19,6 +19,7 @@
>  #include "libxfs.h"
>  #include <sys/stat.h>
>  #include "xfs_multidisk.h"
> +#include "xfs_parent.h"
>  
>  /*
>   * Prototypes for internal functions.
> @@ -318,23 +319,25 @@ newregfile(
>  
>  static void
>  newdirent(
> -	xfs_mount_t	*mp,
> -	xfs_trans_t	*tp,
> -	xfs_inode_t	*pip,
> -	struct xfs_name	*name,
> -	xfs_ino_t	inum,
> -	xfs_fsblock_t	*first,
> -	struct xfs_defer_ops	*dfops)
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*pip,
> +	struct xfs_name		*name,
> +	struct xfs_inode	*ip,
> +	xfs_fsblock_t		*first,
> +	struct xfs_defer_ops	*dfops,
> +	xfs_dir2_dataptr_t      *offset)
>  {
> -	int	error;
> -	int	rsv;
> +	int			error;
> +	int			rsv;
>  
>  	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
>  
> -	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv,
> -				       NULL);
> +	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, first, dfops, rsv,
> +				       offset);

This line is over 80 characters, please just rewrap the whole thing:

	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, first, dfops,
			rsv, offset);

>  	if (error)
>  		fail(_("directory createname error"), error);
> +
>  }
>  
>  static void
> @@ -387,6 +390,7 @@ parseproto(
>  	cred_t		creds;
>  	char		*value;
>  	struct xfs_name	xname;
> +	xfs_dir2_dataptr_t offset;
>  
>  	memset(&creds, 0, sizeof(creds));
>  	mstr = getstr(pp);
> @@ -470,7 +474,7 @@ parseproto(
>  			free(buf);
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_REG_FILE;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		break;
>  
>  	case IF_RESERVED:			/* pre-allocated space only */
> @@ -493,7 +497,7 @@ parseproto(
>  		libxfs_trans_ijoin(tp, pip, 0);
>  
>  		xname.type = XFS_DIR3_FT_REG_FILE;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		libxfs_trans_log_inode(tp, ip, flags);
>  
>  		libxfs_defer_ijoin(&dfops, ip);
> @@ -516,7 +520,7 @@ parseproto(
>  		}
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_BLKDEV;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		flags |= XFS_ILOG_DEV;
>  		break;
>  
> @@ -530,7 +534,7 @@ parseproto(
>  			fail(_("Inode allocation failed"), error);
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_CHRDEV;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		flags |= XFS_ILOG_DEV;
>  		break;
>  
> @@ -542,7 +546,7 @@ parseproto(
>  			fail(_("Inode allocation failed"), error);
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_FIFO;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		break;
>  	case IF_SYMLINK:
>  		buf = getstr(pp);
> @@ -555,7 +559,7 @@ parseproto(
>  		flags |= newfile(tp, ip, &dfops, &first, 1, 1, buf, len);
>  		libxfs_trans_ijoin(tp, pip, 0);
>  		xname.type = XFS_DIR3_FT_SYMLINK;
> -		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &dfops);
> +		newdirent(mp, tp, pip, &xname, ip, &first, &dfops, &offset);
>  		break;
>  	case IF_DIRECTORY:
>  		tp = getres(mp, 0);
> @@ -572,8 +576,8 @@ parseproto(
>  		} else {
>  			libxfs_trans_ijoin(tp, pip, 0);
>  			xname.type = XFS_DIR3_FT_DIR;
> -			newdirent(mp, tp, pip, &xname, ip->i_ino,
> -				  &first, &dfops);
> +			newdirent(mp, tp, pip, &xname, ip,
> +				  &first, &dfops, &offset);
>  			inc_nlink(VFS_I(pip));
>  			libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
>  		}
> @@ -612,6 +616,19 @@ parseproto(
>  		fail(_("Error encountered creating file from prototype file"),
>  			error);
>  	}
> +
> +	if (xfs_sb_version_hasparent(&mp->m_sb)) {
> +		error = xfs_parent_add(pip, ip, &xname, offset, &first, &dfops);

Didn't we just _defer_finish(&dfops) in the hunk right above this?  Why
not add the deferred pptr before the first _defer_finish call?

--D

> +		if (error)
> +			fail(_("Error creating parent pointer"), error);
> +
> +		libxfs_trans_log_inode(tp, ip, flags);
> +		libxfs_defer_ijoin(&dfops, ip);
> +		error = -libxfs_defer_finish(&tp, &dfops);
> +		if (error)
> +			fail(_("Directory creation failed"), error);
> +	}
> +
>  	libxfs_trans_commit(tp);
>  	IRELE(ip);
>  }
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
