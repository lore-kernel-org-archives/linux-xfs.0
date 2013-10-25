Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ABD237F51
	for <xfs@oss.sgi.com>; Fri, 25 Oct 2013 16:47:58 -0500 (CDT)
Date: Fri, 25 Oct 2013 16:47:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 19/19] xfs: convert directory vector functions to constants
Message-ID: <20131025214758.GA1935@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-20-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381789085-21923-20-git-send-email-david@fromorbit.com>
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

On Tue, Oct 15, 2013 at 09:18:05AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Many of the vectorised function calls now take no parameters and
> return a constant value. There is no reason for these to be vectored
> functions, so convert them to constants
> 
> Binary sizes:
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
>  791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
>  791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>



> @@ -879,35 +817,35 @@ const struct xfs_dir_ops xfs_dir3_ops = {
>  	.data_entry_p = xfs_dir3_data_entry_p,
>  	.data_unused_p = xfs_dir3_data_unused_p,
>  
> -	.leaf_hdr_size = xfs_dir3_leaf_hdr_size,
> +	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
>  	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
>  	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
>  	.leaf_max_ents = xfs_dir3_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
> -	.node_hdr_size = xfs_da3_node_hdr_size,
> +	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
>  	.node_hdr_to_disk = xfs_da3_node_hdr_to_disk,
>  	.node_hdr_from_disk = xfs_da3_node_hdr_from_disk,
>  	.node_tree_p = xfs_da3_node_tree_p,
>  
> -	.free_hdr_size = xfs_dir3_free_hdr_size,
> +	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
> -	.free_max_bests = xfs_dir2_free_max_bests,
> +	.free_max_bests = xfs_dir3_free_max_bests,
			  ^^^^^^^^^^^^^^^^^^^^^^^^

That looks like it fixes a bug introduced in one of the earlier patches.  Other
than that this looks good.

I like how . and .. offsets changed into constants.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
