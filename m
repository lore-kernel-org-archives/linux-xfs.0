Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAF227FAB
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 12:21:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A4B2AC003
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 10:21:17 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id J2cUoKKEXKAxmKRJ for <xfs@oss.sgi.com>;
	Fri, 08 Nov 2013 10:21:15 -0800 (PST)
Message-ID: <527D2BA0.7000504@sandeen.net>
Date: Fri, 08 Nov 2013 12:21:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1383280040-21979-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 10/31/13, 11:27 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> v5 filesystems use 512 byte inodes as a minimum, so read inodes in

I think you meant :

"..., so today we read inodes in clusters that are..."
         ^^^^^^^^

- changes the meaning quite a bit.  :)

> clusters that are effectively half the size of a v4 filesystem with
> 256 byte inodes. For v5 fielsystems, scale the inode cluster size
> with the size of the inode so that we keep a constant 32 inodes per
> cluster ratio for all inode IO.
> 
> This only works if mkfs.xfs sets the inode alignment appropriately
> for larger inode clusters, so this functionality is made conditional
> on mkfs doing the right thing. xfs_repair needs to know about
> the inode alignment changes, too.
> 
> Wall time:
> 	create	bulkstat	find+stat	ls -R	unlink
> v4	237s	161s		173s		201s	299s
> v5	235s	163s		205s		 31s	356s
> patched	234s	160s		182s		 29s	317s
> 
> System time:
> 	create	bulkstat	find+stat	ls -R	unlink
> v4	2601s	2490s		1653s		1656s	2960s
> v5	2637s	2497s		1681s		  20s	3216s
> patched	2613s	2451s		1658s		  20s	3007s
> 
> So, wall time same or down across the board, system time same or
> down across the board, and cache hit rates all improve except for
> the ls -R case which is a pure cold cache directory read workload
> on v5 filesystems...
> 
> So, this patch removes most of the performance and CPU usage
> differential between v4 and v5 filesystems on traversal related
> workloads.

We already have some issues w/ larger inode clusters & freespace
fragmentation resulting in the inability to create new clusters,
right?

How might this impact that problem?  I understand that it may be
a tradeoff.

> Note: while this patch is currently for v5 filesystems only, there
> is no reason it can't be ported back to v4 filesystems.  This hasn't
> been done here because bringing the code back to v4 requires
> forwards and backwards kernel compatibility testing.  i.e. to
> deterine if older kernels(*) do the right thing with larger inode
> alignments but still only using 8k inode cluster sizes. None of this
> testing and validation on v4 filesystems has been done, so for the
> moment larger inode clusters is limited to v5 superblocks.

Thanks for that explanation.

> (*) a current default config v4 filesystem should mount just fine on
> 2.6.23 (when lazy-count support was introduced), and so if we change
> the alignment emitted by mkfs without a feature bit then we have to
> make sure it works properly on all kernels since 2.6.23. And if we
> allow it to be changed when the lazy-count bit is not set, then it's
> all kernels since v2 logs were introduced that need to be tested for
> compatibility...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c      | 15 +++++++++++++++
>  fs/xfs/xfs_mount.h      |  2 +-
>  fs/xfs/xfs_trans_resv.c |  3 +--
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index da88f16..02df7b4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -41,6 +41,7 @@
>  #include "xfs_fsops.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_dinode.h"
>  
>  
>  #ifdef HAVE_PERCPU_SB
> @@ -718,8 +719,22 @@ xfs_mountfs(
>  	 * Set the inode cluster size.
>  	 * This may still be overridden by the file system
>  	 * block size if it is larger than the chosen cluster size.
> +	 *
> +	 * For v5 filesystems, scale the cluster size with the inode size to
> +	 * keep a constant ratio of inode per cluster buffer, but only if mkfs
> +	 * has set the inode alignment value appropriately for larger cluster
> +	 * sizes.
>  	 */
>  	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;

Just thinking out loud here: So this is runtime only; nothing on disk sets
the cluster size explicitly (granted, it never did).

So moving back and forth across newer/older kernels will create clusters 
of different sizes on the same filesystem, right?

(In the very distant past, this same change could have happened if
the amount of memory in a box changed (!) - see commit
425f9ddd534573f58df8e7b633a534fcfc16d44d; prior to that we set
m_inode_cluster_size on the fly as well).

But sb_inoalignmt is a mkfs-set, on-disk feature.  So we might start with
i.e. this, where A1 are 8k alignment points, and 512 byte inodes, in clusters
of size 8k / 16 inodes:

A1           A1           A1           A1           
[ 16 inodes ][ 16 inodes ]             [ 16 inodes ]

and in this case we couldn't bump up m_inode_cluster_size, lest we
allocate a larger cluster on the smaller alignment & overlap:

A1           A1           A1           A1           
[ 16 inodes ][ 16 inodes ]             [ 16 inodes ] <--- existing
                         [        32 inodes        ] <--- new

But if we had a larger (say, 16k) inode alignment, like:  we could
safely do:

A1                        A2                        A2          
[ 16 inodes ]                                       [ 16 inodes ]
                          [        32 inodes       ] <--- new

and be ok.

So the only other thing I wonder about is when we are handling
pre-existing, smaller-than m_inode_cluster_size clusters.

i.e. xfs_ifree_cluster() figures out the number of blocks &
number of inodes in a cluster, based on the (now not
constant) m_inode_cluster_size.

What stops us from going off the end of a smaller cluster?
</handwave>

I'm not up to speed on inode IO TBH, so will dig into it a little more.

Aside from all those vague questions, this seems sane.  ;)

> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		int	new_size = mp->m_inode_cluster_size;
> +
> +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> +			mp->m_inode_cluster_size = new_size;
> +		xfs_info(mp, "Using inode cluster size of %d bytes",
> +			 mp->m_inode_cluster_size);
> +	}
>  
>  	/*
>  	 * Set inode alignment fields

next 2 hunks are just tidying, right.

Thanks,
-Eric

> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 1d8101a..a466c5e 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -112,7 +112,7 @@ typedef struct xfs_mount {
>  	__uint8_t		m_blkbb_log;	/* blocklog - BBSHIFT */
>  	__uint8_t		m_agno_log;	/* log #ag's */
>  	__uint8_t		m_agino_log;	/* #bits for agino in inum */
> -	__uint16_t		m_inode_cluster_size;/* min inode buf size */
> +	uint			m_inode_cluster_size;/* min inode buf size */
>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
>  	uint			m_blockwmask;	/* blockwsize-1 */
> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
> index d53d9f0..2fd59c0 100644
> --- a/fs/xfs/xfs_trans_resv.c
> +++ b/fs/xfs/xfs_trans_resv.c
> @@ -385,8 +385,7 @@ xfs_calc_ifree_reservation(
>  		xfs_calc_inode_res(mp, 1) +
>  		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
>  		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
> -		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
> -		    XFS_INODE_CLUSTER_SIZE(mp)) +
> +		max_t(uint, XFS_FSB_TO_B(mp, 1), XFS_INODE_CLUSTER_SIZE(mp)) +
>  		xfs_calc_buf_res(1, 0) +
>  		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
>  				 mp->m_in_maxlevels, 0) +
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
