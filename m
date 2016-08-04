Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 282FC7CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 10:44:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9FB31AC004
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 08:44:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id bm7EZPKe6leGRvVB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 08:44:41 -0700 (PDT)
Date: Thu, 4 Aug 2016 08:44:39 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: store rmapbt block count in the AGF
Message-ID: <20160804154439.GA15656@infradead.org>
References: <20160803214613.GF8593@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803214613.GF8593@birch.djwong.org>
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

On Wed, Aug 03, 2016 at 02:46:13PM -0700, Darrick J. Wong wrote:
> Track the number of blocks used for the rmapbt in the AGF.  When we
> get to the AG reservation code we need this counter to quickly
> make our reservation during mount.
> 
> v2: Actually include growfs support.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c      |    1 +
>  fs/xfs/libxfs/xfs_format.h     |   11 ++++++++---
>  fs/xfs/libxfs/xfs_rmap_btree.c |    6 ++++++
>  fs/xfs/xfs_fsops.c             |    1 +
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 776ae2f..af1a72e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2264,6 +2264,7 @@ xfs_alloc_log_agf(
>  		offsetof(xfs_agf_t, agf_longest),
>  		offsetof(xfs_agf_t, agf_btreeblks),
>  		offsetof(xfs_agf_t, agf_uuid),
> +		offsetof(xfs_agf_t, agf_rmap_blocks),
>  		sizeof(xfs_agf_t)
>  	};
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f814d42..e6a8bea 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -640,12 +640,15 @@ typedef struct xfs_agf {
>  	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
>  	uuid_t		agf_uuid;	/* uuid of filesystem */
>  
> +	__be32		agf_rmap_blocks;	/* rmapbt blocks used */
> +	__be32		agf_padding;		/* padding */

Now _spare?  It could easily be used by the next new field.

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
