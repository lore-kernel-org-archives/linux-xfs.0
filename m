Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32053 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751432AbdGWR7I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 13:59:08 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6NHx7nS011188
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:59:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6NHx7Xs030828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:59:07 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6NHx6MK015115
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2017 17:59:07 GMT
Subject: Re: [PATCH 19/22] xfs: scrub symbolic links
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061203238.14732.8954692492620694902.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <d17c3e00-6593-7378-0d68-20c94331f510@oracle.com>
Date: Sun, 23 Jul 2017 10:59:01 -0700
MIME-Version: 1.0
In-Reply-To: <150061203238.14732.8954692492620694902.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Looks good.  Looks like you caught some bugs along the way
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 7/20/2017 9:40 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create the infrastructure to scrub symbolic link data.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile        |    1 +
>  fs/xfs/libxfs/xfs_fs.h |    3 +-
>  fs/xfs/scrub/common.c  |    4 ++
>  fs/xfs/scrub/common.h  |    2 +
>  fs/xfs/scrub/symlink.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h     |    3 +-
>  6 files changed, 105 insertions(+), 2 deletions(-)
>  create mode 100644 fs/xfs/scrub/symlink.c
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index da64bef..3d862b9 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -153,5 +153,6 @@ xfs-y				+= $(addprefix scrub/, \
>  				   metabufs.o \
>  				   refcount.o \
>  				   rmap.o \
> +				   symlink.o \
>  				   )
>  endif
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2f553ed..95d9ce9 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -499,7 +499,8 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_BMBTC	15	/* CoW fork block mapping */
>  #define XFS_SCRUB_TYPE_DIR	16	/* directory */
>  #define XFS_SCRUB_TYPE_XATTR	17	/* extended attribute */
> -#define XFS_SCRUB_TYPE_MAX	17
> +#define XFS_SCRUB_TYPE_SYMLINK	18	/* symbolic link */
> +#define XFS_SCRUB_TYPE_MAX	18
>
>  /* i: repair this metadata */
>  #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index a47c654..4003c2f 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -852,6 +852,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
>  		.setup	= xfs_scrub_setup_xattr,
>  		.scrub	= xfs_scrub_xattr,
>  	},
> +	{ /* symbolic link */
> +		.setup	= xfs_scrub_setup_symlink,
> +		.scrub	= xfs_scrub_symlink,
> +	},
>  };
>
>  /* Dispatch metadata scrubbing. */
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 1cfe0cc..6d02a64 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -223,6 +223,7 @@ SETUP_FN(xfs_scrub_setup_inode_bmap_data);
>  SETUP_FN(xfs_scrub_setup_inode_bmap);
>  SETUP_FN(xfs_scrub_setup_directory);
>  SETUP_FN(xfs_scrub_setup_xattr);
> +SETUP_FN(xfs_scrub_setup_symlink);
>  #undef SETUP_FN
>
>  /* Metadata scrubbers */
> @@ -246,6 +247,7 @@ SCRUB_FN(xfs_scrub_bmap_attr);
>  SCRUB_FN(xfs_scrub_bmap_cow);
>  SCRUB_FN(xfs_scrub_directory);
>  SCRUB_FN(xfs_scrub_xattr);
> +SCRUB_FN(xfs_scrub_symlink);
>  #undef SCRUB_FN
>
>  #endif	/* __XFS_REPAIR_COMMON_H__ */
> diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
> new file mode 100644
> index 0000000..75537e9
> --- /dev/null
> +++ b/fs/xfs/scrub/symlink.c
> @@ -0,0 +1,94 @@
> +/*
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_trace.h"
> +#include "xfs_sb.h"
> +#include "xfs_inode.h"
> +#include "xfs_inode_fork.h"
> +#include "xfs_symlink.h"
> +#include "scrub/common.h"
> +
> +/* Set us up to scrub a symbolic link. */
> +int
> +xfs_scrub_setup_symlink(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_inode		*ip)
> +{
> +	/* Allocate the buffer without the inode lock held. */
> +	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, KM_SLEEP);
> +	if (!sc->buf)
> +		return -ENOMEM;
> +
> +	return xfs_scrub_setup_inode_contents(sc, ip, 0);
> +}
> +
> +/* Symbolic links. */
> +
> +#define XFS_SCRUB_SYMLINK_CHECK(fs_ok) \
> +	XFS_SCRUB_INO_CHECK(sc, ip->i_ino, NULL, "symlink", fs_ok)
> +#define XFS_SCRUB_SYMLINK_GOTO(fs_ok, label) \
> +	XFS_SCRUB_INO_GOTO(sc, ip->i_ino, NULL, "symlink", fs_ok, label)
> +int
> +xfs_scrub_symlink(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_inode		*ip = sc->ip;
> +	struct xfs_ifork		*ifp;
> +	loff_t				len;
> +	int				error = 0;
> +
> +	if (!S_ISLNK(VFS_I(ip)->i_mode))
> +		return -ENOENT;
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	len = ip->i_d.di_size;
> +
> +	/* Plausible size? */
> +	XFS_SCRUB_SYMLINK_GOTO(len <= XFS_SYMLINK_MAXLEN, out);
> +	XFS_SCRUB_SYMLINK_GOTO(len > 0, out);
> +
> +	/* Inline symlink? */
> +	if (ifp->if_flags & XFS_IFINLINE) {
> +		XFS_SCRUB_SYMLINK_GOTO(len > 0, out);
> +		XFS_SCRUB_SYMLINK_CHECK(len <= XFS_IFORK_DSIZE(ip));
> +		XFS_SCRUB_SYMLINK_CHECK(len <= strnlen(ifp->if_u1.if_data,
> +				XFS_IFORK_DSIZE(ip)));
> +		goto out;
> +	}
> +
> +	/* Remote symlink; must read the contents. */
> +	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
> +	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, 0, "symlink",
> +			&error, out);
> +	XFS_SCRUB_SYMLINK_CHECK(len <= strnlen(sc->buf, XFS_SYMLINK_MAXLEN));
> +out:
> +	return error;
> +}
> +#undef XFS_SCRUB_SYMLINK_GOTO
> +#undef XFS_SCRUB_SYMLINK_CHECK
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index fe4b313..39824f8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3329,7 +3329,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
>  	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
>  	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
>  	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
> -	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
> +	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
> +	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
>  DECLARE_EVENT_CLASS(xfs_scrub_class,
>  	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
>  		 int error),
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
