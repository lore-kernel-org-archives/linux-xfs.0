Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 160CD7F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 13:28:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F4C9AC001
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 11:28:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id smcaGgSxI7hzyLm0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 11:28:37 -0700 (PDT)
Date: Thu, 19 Mar 2015 14:28:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: don't write uninitialized heap contents into new
	directory blocks
Message-ID: <20150319182834.GI11669@laptop.bfoster>
References: <20150318232159.GA24608@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150318232159.GA24608@birch.djwong.org>
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

On Wed, Mar 18, 2015 at 04:21:59PM -0700, Darrick J. Wong wrote:
> When we're initializing a new directory block, zero the buffer
> contents to avoid writing random heap contents (and crc thereof)
> to disk.  This eliminates a few valgrind complaints in xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Well it seems Ok to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... but I do notice that we start ending up with multiple memset() calls
throughout these codepaths. E.g., xfs_dir3_data_init() memsets the
target bytes for the header if crc is enabled, xfs_dir3_leaf_get_buf()
calls xfs_dir3_leaf_init() which does something similar, etc.

I wonder if we should just zero the buffer content unconditionally on
allocation?

Brian

>  libxfs/xfs_da_btree.c  |    1 +
>  libxfs/xfs_dir2_data.c |    1 +
>  libxfs/xfs_dir2_leaf.c |    1 +
>  libxfs/xfs_dir2_node.c |    2 +-
>  4 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
> index b731b54..bc73cbc 100644
> --- a/libxfs/xfs_da_btree.c
> +++ b/libxfs/xfs_da_btree.c
> @@ -562,6 +562,7 @@ xfs_da3_root_split(
>  	if (error)
>  		return error;
>  	node = bp->b_addr;
> +	memset(bp->b_addr, 0, bp->b_bcount);
>  	oldroot = blk1->bp->b_addr;
>  	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
>  	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC)) {
> diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> index dc9df4d..79c2fc2 100644
> --- a/libxfs/xfs_dir2_data.c
> +++ b/libxfs/xfs_dir2_data.c
> @@ -559,6 +559,7 @@ xfs_dir3_data_init(
>  		XFS_DATA_FORK);
>  	if (error)
>  		return error;
> +	memset(bp->b_addr, 0, bp->b_bcount);
>  	bp->b_ops = &xfs_dir3_data_buf_ops;
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
>  
> diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
> index 8e0cbc9..6eb03fc 100644
> --- a/libxfs/xfs_dir2_leaf.c
> +++ b/libxfs/xfs_dir2_leaf.c
> @@ -382,6 +382,7 @@ xfs_dir3_leaf_get_buf(
>  	if (error)
>  		return error;
>  
> +	memset(bp->b_addr, 0, bp->b_bcount);
>  	xfs_dir3_leaf_init(mp, tp, bp, dp->i_ino, magic);
>  	xfs_dir3_leaf_log_header(tp, bp);
>  	if (magic == XFS_DIR2_LEAF1_MAGIC)
> diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
> index 3737e4e..3e2f04d 100644
> --- a/libxfs/xfs_dir2_node.c
> +++ b/libxfs/xfs_dir2_node.c
> @@ -247,7 +247,7 @@ xfs_dir3_free_get_buf(
>  	 * Initialize the new block to be empty, and remember
>  	 * its first slot as our empty slot.
>  	 */
> -	memset(bp->b_addr, 0, sizeof(struct xfs_dir3_free_hdr));
> +	memset(bp->b_addr, 0, bp->b_bcount);
>  	memset(&hdr, 0, sizeof(hdr));
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
