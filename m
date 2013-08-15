Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ACAB77CBE
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:45:34 -0500 (CDT)
Date: Thu, 15 Aug 2013 14:45:31 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH, RFC] xfs: don't verify checksum on non-V5 superblocks
Message-ID: <20130815194531.GL12719@sgi.com>
References: <520D1BA3.1050500@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520D1BA3.1050500@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On Thu, Aug 15, 2013 at 01:19:15PM -0500, Eric Sandeen wrote:
> The current test in xfs_sb_read_verify() will attempt to validate
> an sb checksum if sb_crc is non-zero, even if the superblock is not
> marked as being version 5.
> 
> This runs the risk of picking up random garbage in sb_crc for non-V5
> superblocks; such garbage is known to exist in the wild due to prior bugs.
> This will cause verification to fail for otherwise non-fatal reasons.
> 
> I'm not sure of the point of trying to validate a non-V5 superblock;
> is there one?  Shouldn't this || be an &&?  (Can sb_crc validly be
> 0 for a V5 SB?)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

This looks good to me.
Reviewed-by: Ben Myers <bpm@sgi.com>

> --- 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2b0ba35..5ca299b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -764,7 +764,7 @@ xfs_sb_read_verify(
>  	 */
>  	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC) &&
>  	    (((be16_to_cpu(dsb->sb_versionnum) & XFS_SB_VERSION_NUMBITS) ==
> -						XFS_SB_VERSION_5) ||
> +						XFS_SB_VERSION_5) &&
>  	     dsb->sb_crc != 0)) {
>  
>  		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
