Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 009C07F51
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 23:08:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E517A304032
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 21:08:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pTr9PImUrlBRvapA for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 21:08:13 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 18A5B63D5B55
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 23:08:13 -0600 (CST)
Subject: Re: [PATCH 3/5] libxfs: move struct xfs_attr_shortform to
	xfs_da_format.h
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<20160123003514.2475.80318.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56A30ABC.9010508@sandeen.net>
Date: Fri, 22 Jan 2016 23:08:12 -0600
MIME-Version: 1.0
In-Reply-To: <20160123003514.2475.80318.stgit@birch.djwong.org>
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

On 1/22/16 6:35 PM, Darrick J. Wong wrote:
> Move the shortform attr structure definition to the same place as the
> other attribute structure definitions for consistency and also so that
> xfs/122 verifies the structure size.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libxfs/xfs_attr_sf.h    |   16 ----------------
>  libxfs/xfs_da_format.h  |   16 ++++++++++++++++
>  libxfs/xfs_inode_fork.c |    1 +
>  3 files changed, 17 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
> index 919756e..90928bb 100644
> --- a/libxfs/xfs_attr_sf.h
> +++ b/libxfs/xfs_attr_sf.h
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
> diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
> index b14bbd6..8d4d8bc 100644
> --- a/libxfs/xfs_da_format.h
> +++ b/libxfs/xfs_da_format.h
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
> diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
> index e1968b4..f40649e 100644
> --- a/libxfs/xfs_inode_fork.c
> +++ b/libxfs/xfs_inode_fork.c
> @@ -27,6 +27,7 @@
>  #include "xfs_bmap.h"
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
