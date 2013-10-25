Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD8347F3F
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 13:47:02 -0500 (CDT)
Date: Fri, 25 Oct 2013 13:46:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 17/19] xfs: vectorise encoding/decoding directory headers
Message-ID: <20131025184646.GX1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-18-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 15, 2013 at 09:18:03AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Conversion from on-disk structures to in-core header structures
> currently relies on magic number checks. If the magic number is
> wrong, but one of the supported values, we do the wrong thing with
> the encode/decode operation. Split these functions so that there are
> discrete operations for the specific directory format we are
> handling.
> 
> In doing this, move all the header encode/decode functions to
> xfs_da_format.c as they are directly manipulating the on-disk
> format. It should be noted that all the growth in binary size is
> from xfs_da_format.c - the rest of the code actaully shrinks.
> 
>    text    data     bss     dec     hex filename
>  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
>  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
>  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
>  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
>  789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
>  789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
>  789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
>  791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>


>  const struct xfs_dir_ops xfs_dir2_ops = {
>  	.sf_entsize = xfs_dir2_sf_entsize,
>  	.sf_nextentry = xfs_dir2_sf_nextentry,
> @@ -532,10 +712,14 @@ const struct xfs_dir_ops xfs_dir2_ops = {
>  	.data_unused_p = xfs_dir2_data_unused_p,
>  
>  	.leaf_hdr_size = xfs_dir2_leaf_hdr_size,
> +	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
> +	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
>  	.node_hdr_size = xfs_da2_node_hdr_size,
> +	.node_hdr_to_disk = xfs_da2_node_hdr_to_disk,
> +	.node_hdr_from_disk = xfs_da2_node_hdr_from_disk,
>  	.node_tree_p = xfs_da2_node_tree_p,

	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,

Is this missing?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
