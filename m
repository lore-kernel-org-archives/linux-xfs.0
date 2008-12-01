Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1DgbVY026854 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 07:42:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 412731BE8578
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 05:42:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WMiGDIov0HGjEia4 for
	<xfs@oss.sgi.com>; Mon, 01 Dec 2008 05:42:37 -0800 (PST)
Date: Mon, 1 Dec 2008 08:42:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Fix unaligned accesses in IA64 in xfsprogs
Message-ID: <20081201134205.GA7528@infradead.org>
References: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 01, 2008 at 05:34:39PM +1100, Barry Naujok wrote:
> xfs_repair is the main culprit when getting disk extents which aren't
> properly aligned in memory. This patch does not call
> xfs_bmbt_disk_get_all directly anymore but does an unaligned get on
> the disk extent record and calls xfs_bmbt_get_all which is host-based
> like the rest of the kernel routines do.

What about just doin the get_unaligned in xfs_bmbt_disk_get_all?  That
way we could just use it everywhere.  The only users that don't need
the get_unaligned are in the tracing code, and I don't think we should
be worried about that little bit of overhead.

> @@ -277,21 +277,17 @@ convert_extent(
>   	xfs_dfilblks_t		*cp,
>   	int			*fp)
>   {

And then we could replace this helper with a direct call to
xfs_bmbt_disk_get_all as the caller would be much cleaner with a
xfs_bmbt_irec_t on the stack anyway..

> --- a/xfsprogs/repair/dino_chunks.c	2008-12-01 17:10:37.000000000 +1100
> +++ b/xfsprogs/repair/dino_chunks.c	2008-12-01 16:11:11.549834281 +1100
> @@ -609,7 +609,8 @@ process_inode_chunk(
>   	if (blks_per_cluster == 0)
>   		blks_per_cluster = 1;
>   	cluster_count = XFS_INODES_PER_CHUNK / inodes_per_cluster;
> -	ASSERT(cluster_count > 0);
> +	if (cluster_count == 0)
> +		cluster_count = 1;

I can't see how this is related.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
