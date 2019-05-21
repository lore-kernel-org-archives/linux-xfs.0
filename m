Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58850 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfEUQax (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:30:53 -0400
Subject: Re: [PATCH 01/12] libxfs: fix attr include mess
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839420721.68606.5873005194118073203.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f6804b1-9f23-a0b3-515d-f74f09db3ada@sandeen.net>
Date: Tue, 21 May 2019 11:30:52 -0500
MIME-Version: 1.0
In-Reply-To: <155839420721.68606.5873005194118073203.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/20/19 6:16 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove all the userspace xfs_attr shim cruft so that we have one
> definition of ATTR_* macros so that we can actually use xfs_attr.c
> routines and include xfs_attr.h without problems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

<handwaves about namespace for flag #defines ok sure>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/libxfs.h         |   10 +---------
>  libxfs/libxfs_api_defs.h |    5 +++++
>  libxfs/libxfs_priv.h     |    8 --------
>  libxfs/xfs_attr.c        |    1 +
>  libxfs/xfs_attr_leaf.c   |    1 +
>  5 files changed, 8 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/include/libxfs.h b/include/libxfs.h
> index 230bc3e8..dd5fe542 100644
> --- a/include/libxfs.h
> +++ b/include/libxfs.h
> @@ -211,14 +211,6 @@ libxfs_bmbt_disk_get_all(
>  int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
>  bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
>  
> -/* XXX: need parts of xfs_attr.h in userspace */
> -#define LIBXFS_ATTR_ROOT	0x0002	/* use attrs in root namespace */
> -#define LIBXFS_ATTR_SECURE	0x0008	/* use attrs in security namespace */
> -#define LIBXFS_ATTR_CREATE	0x0010	/* create, but fail if attr exists */
> -#define LIBXFS_ATTR_REPLACE	0x0020	/* set, but fail if attr not exists */
> -
> -int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
> -int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
> -		 unsigned char *value, int valuelen, int flags);
> +#include "xfs_attr.h"
>  
>  #endif	/* __LIBXFS_H__ */
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 1150ec93..34bb552d 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -144,4 +144,9 @@
>  #define xfs_fs_geometry			libxfs_fs_geometry
>  #define xfs_init_local_fork		libxfs_init_local_fork
>  
> +#define LIBXFS_ATTR_ROOT		ATTR_ROOT
> +#define LIBXFS_ATTR_SECURE		ATTR_SECURE
> +#define LIBXFS_ATTR_CREATE		ATTR_CREATE
> +#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
> +
>  #endif /* __LIBXFS_API_DEFS_H__ */
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index d668a157..f60bff06 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -104,14 +104,6 @@ extern char    *progname;
>   */
>  #define PTR_FMT "%p"
>  
> -/* XXX: need to push these out to make LIBXFS_ATTR defines */
> -#define ATTR_ROOT			0x0002
> -#define ATTR_SECURE			0x0008
> -#define ATTR_CREATE			0x0010
> -#define ATTR_REPLACE			0x0020
> -#define ATTR_KERNOTIME			0
> -#define ATTR_KERNOVAL			0
> -
>  #define XFS_IGET_CREATE			0x1
>  #define XFS_IGET_UNTRUSTED		0x2
>  
> diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
> index b8838302..170e64cf 100644
> --- a/libxfs/xfs_attr.c
> +++ b/libxfs/xfs_attr.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_btree.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_attr_remote.h"
>  #include "xfs_trans_space.h"
> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
> index 679c7d0d..1027ca01 100644
> --- a/libxfs/xfs_attr_leaf.c
> +++ b/libxfs/xfs_attr_leaf.c
> @@ -21,6 +21,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_attr_sf.h"
>  #include "xfs_attr_remote.h"
> +#include "xfs_attr.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_trace.h"
>  #include "xfs_cksum.h"
> 
