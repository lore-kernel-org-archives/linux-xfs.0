Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6644C7F4E
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 16:54:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 297D4304032
	for <xfs@oss.sgi.com>; Mon,  6 Oct 2014 14:53:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Do04nCfzAIYpUfMb for <xfs@oss.sgi.com>;
	Mon, 06 Oct 2014 14:53:55 -0700 (PDT)
Date: Tue, 7 Oct 2014 08:53:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/16] xfs: store utf8version in the superblock
Message-ID: <20141006215352.GG2301@dastard>
References: <20141003214758.GY1865@sgi.com>
 <20141003220031.GI1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003220031.GI1865@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, olaf@sgi.com, xfs@oss.sgi.com

On Fri, Oct 03, 2014 at 05:00:31PM -0500, Ben Myers wrote:
> From: Ben Myers <bpm@sgi.com>
> 
> The utf8 version a filesystem was created with needs to be stored in
> order that normalizations will remain stable over the lifetime of the
> filesystem.  Convert sb_pad to sb_utf8version in the super block.  This
> also adds checks at mount time to see whether the unicode normalization
> module has support for the version of unicode that the filesystem
> requires.  If not we fail the mount.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c | 28 ++++++++++++++++---
>  fs/xfs/libxfs/xfs_sb.c   |  4 +--
>  fs/xfs/libxfs/xfs_sb.h   | 10 ++++---
>  fs/xfs/libxfs/xfs_utf8.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_utf8.h | 24 +++++++++++++++++
>  5 files changed, 126 insertions(+), 10 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_utf8.c
>  create mode 100644 fs/xfs/libxfs/xfs_utf8.h
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 4eb0973..2c89211 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -157,10 +157,30 @@ xfs_da_mount(
>  				(uint)sizeof(xfs_da_node_entry_t);
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>  
> -	if (xfs_sb_version_hasasciici(&mp->m_sb))
> -		mp->m_dirnameops = &xfs_ascii_ci_nameops;
> -	else
> -		mp->m_dirnameops = &xfs_default_nameops;
> +	if (xfs_sb_version_hasutf8(&mp->m_sb)) {
> +#ifdef CONFIG_XFS_UTF8
> +		if (!xfs_utf8_version_ok(mp))
> +			return -ENOSYS;
> +
> +		/* XXX these are replaced in the next patch need
> +		   to do some kind of reordering here */
> +		if (xfs_sb_version_hasasciici(&mp->m_sb))
> +			mp->m_dirnameops = &xfs_ascii_ci_nameops;
> +		else
> +			mp->m_dirnameops = &xfs_default_nameops;
> +#else
> +		xfs_warn(mp,
> +"Recompile XFS with CONFIG_XFS_UTF8 to mount this filesystem");
> +		kmem_free(mp->m_dir_geo);
> +		kmem_free(mp->m_attr_geo);
> +		return -ENOSYS;
> +#endif

This config check doesn't belong here. Validation of superblock
fields vs the current config goes in the superblock verifier. I also
think that indication of UTF8 support being compiled in needs to go
in the XFS_VERSION_STRING, not have ifdef hackery added into the
code.

i.e. the mount should fail very early on with a superblock
verification failure from xfs_mount_validate_sb().


> +	} else {
> +		if (xfs_sb_version_hasasciici(&mp->m_sb))
> +			mp->m_dirnameops = &xfs_ascii_ci_nameops;
> +		else
> +			mp->m_dirnameops = &xfs_default_nameops;
> +	}
>  
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ad525a5..1ee7d33 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -99,7 +99,7 @@ static const struct {
>  	{ offsetof(xfs_sb_t, sb_features_incompat),	0 },
>  	{ offsetof(xfs_sb_t, sb_features_log_incompat),	0 },
>  	{ offsetof(xfs_sb_t, sb_crc),		0 },
> -	{ offsetof(xfs_sb_t, sb_pad),		0 },
> +	{ offsetof(xfs_sb_t, sb_utf8version),	0 },
>  	{ offsetof(xfs_sb_t, sb_pquotino),	0 },
>  	{ offsetof(xfs_sb_t, sb_lsn),		0 },
>  	{ sizeof(xfs_sb_t),			0 }
> @@ -443,7 +443,7 @@ __xfs_sb_from_disk(
>  	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
>  	to->sb_features_log_incompat =
>  				be32_to_cpu(from->sb_features_log_incompat);
> -	to->sb_pad = 0;
> +	to->sb_utf8version = be32_to_cpu(from->sb_utf8version);
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
>  	/* Convert on-disk flags to in-memory flags? */
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 525eacb..dc7b6c6 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -159,7 +159,7 @@ typedef struct xfs_sb {
>  	__uint32_t	sb_features_log_incompat;
>  
>  	__uint32_t	sb_crc;		/* superblock crc */
> -	__uint32_t	sb_pad;
> +	__uint32_t	sb_utf8version;	/* unicode version */
>  
>  	xfs_ino_t	sb_pquotino;	/* project quota inode */
>  	xfs_lsn_t	sb_lsn;		/* last write sequence */
> @@ -245,7 +245,7 @@ typedef struct xfs_dsb {
>  	__be32		sb_features_log_incompat;
>  
>  	__le32		sb_crc;		/* superblock crc */
> -	__be32		sb_pad;
> +	__be32		sb_utf8version;	/* version of unicode */
>  
>  	__be64		sb_pquotino;	/* project quota inode */
>  	__be64		sb_lsn;		/* last write sequence */
> @@ -271,7 +271,7 @@ typedef enum {
>  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
>  	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
>  	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
> -	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
> +	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_UTF8VERSION,
>  	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
>  	XFS_SBS_FIELDCOUNT
>  } xfs_sb_field_t;
> @@ -303,6 +303,7 @@ typedef enum {
>  #define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
>  #define XFS_SB_FEATURES_LOG_INCOMPAT XFS_SB_MVAL(FEATURES_LOG_INCOMPAT)
>  #define XFS_SB_CRC		XFS_SB_MVAL(CRC)
> +#define XFS_SB_UTF8VERSION	XFS_SB_MVAL(UTF8VERSION)
>  #define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
>  #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
>  #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
> @@ -313,7 +314,8 @@ typedef enum {
>  	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
>  	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
>  	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
> -	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
> +	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_UTF8VERSION | \
> +	 XFS_SB_PQUOTINO)

We should never be modifying the utf8 version number from the
kernel, so this shouldn't be set in the XFS_SB_MOD_BITS mask.

> diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
> new file mode 100644
> index 0000000..7e63111
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_utf8.c
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (c) 2014 SGI.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_types.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_inum.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_sb.h"
> +#include "xfs_ag.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_dir2.h"
> +#include "xfs_mount.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_format.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_alloc_btree.h"
> +#include "xfs_dinode.h"
> +#include "xfs_inode.h"
> +#include "xfs_inode_item.h"
> +#include "xfs_bmap.h"
> +#include "xfs_error.h"
> +#include "xfs_trace.h"
> +#include "xfs_utf8.h"

This may sound pedantic, but in all the libxfs rework I've managed
to standadise the initial include file order to be roughly:

#include "xfs.h"
#include "xfs_fs.h"
#include "xfs_shared.h"
#include "xfs_format.h"
#include "xfs_log_format.h"
#include "xfs_trans_resv.h"
#include "xfs_bit.h"
#include "xfs_inum.h"
#include "xfs_sb.h"
#include "xfs_ag.h"
#include "xfs_mount.h"
#include "xfs_da_format.h"

i.e. include all the type, shared and on-disk format information
first. Can you re-order these to follow the same convention?

> +#include <linux/utf8norm.h>

And that should end up being included from fs/xfs/xfs_linux.h,
because we can't include things directly from the linux kernel
headers in fs/xfs/libxfs/ files.

> +
> +int

Bool.

> +xfs_utf8_version_ok(
> +	struct xfs_mount	*mp)
> +{
> +	int	major, minor, revision;
> +
> +	if (utf8version_is_supported(mp->m_sb.sb_utf8version))
> +		return 1;

return true;
> +
> +	major = mp->m_sb.sb_utf8version >> UNICODE_MAJ_SHIFT;
> +	minor = (mp->m_sb.sb_utf8version & 0xff00) >> UNICODE_MIN_SHIFT;
> +	revision = mp->m_sb.sb_utf8version & 0xff;
> +
> +	if (revision) {
> +		xfs_warn(mp,
> +		"Unicode version %d.%d.%d not supported by utf8norm.ko",
> +		major, minor, revision);
> +	} else {
> +		xfs_warn(mp,
> +		"Unicode version %d.%d not supported by utf8norm.ko",
> +		major, minor);
> +	}

why do you need two different print statements? Version X.Y.0 is
pretty much recognisable as being the same as X.Y....

> +
> +	return 0;

return false;

> +}
> diff --git a/fs/xfs/libxfs/xfs_utf8.h b/fs/xfs/libxfs/xfs_utf8.h
> new file mode 100644
> index 0000000..8a700de
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_utf8.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (c) 2014 SGI.
> + * All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#ifndef XFS_UTF8_H
> +#define XFS_UTF8_H
> +
> +extern int xfs_utf8_version_ok(struct xfs_mount *);
> +
> +#endif /* XFS_UTF8_H */

Do we really need a separate header file for this?
fs/xfs/libxfs/xfs_shared.h was created for such one-off or
limited definitions that need to be shared with userspace...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
