Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C7AF7CA2
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 07:31:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 575A78F8035
	for <xfs@oss.sgi.com>; Wed, 27 Jan 2016 05:31:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sbqh3KPusmXqWPCy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Jan 2016 05:31:15 -0800 (PST)
Date: Wed, 27 Jan 2016 08:31:13 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: move struct xfs_attr_shortform to xfs_da_format.h
Message-ID: <20160127133113.GC60730@bfoster.bfoster>
References: <20160123003425.2338.18133.stgit@birch.djwong.org>
	<20160123003438.2338.51748.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123003438.2338.51748.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 04:34:38PM -0800, Darrick J. Wong wrote:
> Move the shortform attr structure definition to the same place as the
> other attribute structure definitions for consistency and also so that
> xfs/122 verifies the structure size.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_sf.h    |   16 ----------------
>  fs/xfs/libxfs/xfs_da_format.h  |   16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.c |    1 +
>  3 files changed, 17 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index 919756e..90928bb 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -24,22 +24,6 @@
>   * Small attribute lists are packed as tightly as possible so as
>   * to fit into the literal area of the inode.
>   */
> -
> -/*
> - * Entries are packed toward the top as tight as possible.
> - */
> -typedef struct xfs_attr_shortform {
> -	struct xfs_attr_sf_hdr {	/* constant-structure header block */
> -		__be16	totsize;	/* total bytes in shortform list */
> -		__u8	count;	/* count of active entries */
> -	} hdr;
> -	struct xfs_attr_sf_entry {
> -		__uint8_t namelen;	/* actual length of name (no NULL) */
> -		__uint8_t valuelen;	/* actual length of value (no NULL) */
> -		__uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> -		__uint8_t nameval[1];	/* name & value bytes concatenated */
> -	} list[1];			/* variable sized array */
> -} xfs_attr_shortform_t;
>  typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
>  typedef struct xfs_attr_sf_entry xfs_attr_sf_entry_t;
>  
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index b14bbd6..8d4d8bc 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -641,6 +641,22 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>   */
>  #define XFS_ATTR_LEAF_MAPSIZE	3	/* how many freespace slots */
>  
> +/*
> + * Entries are packed toward the top as tight as possible.
> + */
> +typedef struct xfs_attr_shortform {
> +	struct xfs_attr_sf_hdr {	/* constant-structure header block */
> +		__be16	totsize;	/* total bytes in shortform list */
> +		__u8	count;	/* count of active entries */
> +	} hdr;
> +	struct xfs_attr_sf_entry {
> +		__uint8_t namelen;	/* actual length of name (no NULL) */
> +		__uint8_t valuelen;	/* actual length of value (no NULL) */
> +		__uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
> +		__uint8_t nameval[1];	/* name & value bytes concatenated */
> +	} list[1];			/* variable sized array */
> +} xfs_attr_shortform_t;
> +
>  typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
>  	__be16	base;			  /* base of free region */
>  	__be16	size;			  /* length of free region */
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 0defbd0..ef22a78 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -31,6 +31,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_sf.h"
> +#include "xfs_da_format.h"
>  
>  kmem_zone_t *xfs_ifork_zone;
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
