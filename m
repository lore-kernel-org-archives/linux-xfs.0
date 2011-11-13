Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pADC4N6e110100 for <xfs@oss.sgi.com>; Sun, 13 Nov 2011 06:04:24 -0600
Date: Sun, 13 Nov 2011 07:04:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfsprogs: mkfs.xfs: let libxfs_umount() do its thing
Message-ID: <20111113120421.GD19435@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<9f5a2c84d462158505a0a4fce6c9417315ab59ee.1320955676.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9f5a2c84d462158505a0a4fce6c9417315ab59ee.1320955676.git.aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Kevan Rehm <kfr@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:14PM -0600, Alex Elder wrote:
> From: Kevan Rehm <kfr@sgi.com>
> 
> In the mkfs.xfs main() routine (which is gargantuan, by the way),
> there are a few function calls intended to do some clean up before
> unmounting the filesystem.
> 
> The first function drops references that will be dropped again in
> the unmnount call.  The others assume all references will go away as
> a result of the purge, but the filesystem's root inode reference
> will remain.
> 
> Let the unmount function take care of destroying the real-time
> structures.  And instead of purging the inode and block caches, just
> flush them (at least the block cache) and let the unmount code take
> care of the final purge.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> ---
>  mkfs/xfs_mkfs.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f527f3d..213cc74 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2674,9 +2674,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  	 * Dump all inodes and buffers before marking us all done.
>  	 * Need to drop references to inodes we still hold, first.
>  	 */
> -	libxfs_rtmount_destroy(mp);

After his libxfs_rtmount_destroy should be marked static.
> -	libxfs_icache_purge();
> -	libxfs_bcache_purge();
> +	libxfs_bcache_flush();

Why don't we need a flush for the inode cache here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
