Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:52645 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbeFEJ1c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 05:27:32 -0400
Received: by mail-wm0-f43.google.com with SMTP id p126-v6so3535832wmb.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jun 2018 02:27:31 -0700 (PDT)
Date: Tue, 5 Jun 2018 11:27:27 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/6] xfs: catch bad stripe alignment configurations
Message-ID: <20180605092727.3rzcvpidstjbeanj@odin.usersys.redhat.com>
References: <20180605062423.4877-1-david@fromorbit.com>
 <20180605062423.4877-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605062423.4877-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 04:24:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When stripe alignments are invalid, data alignment algorithms in the
> allocator may not work correctly. Ensure we catch superblocks with
> invalid stripe alignment setups at mount time. These data alignment
> mismatches are now detected at mount time like this:
> 
> XFS (loop0): SB stripe unit sanity check failed
> XFS (loop0): Metadata corruption detected at xfs_sb_read_verify+0xab/0x110, xfs_sb block 0xffffffffffffffff
> XFS (loop0): Unmount and run xfs_repair
> XFS (loop0): First 128 bytes of corrupted metadata buffer:
> 0000000091c2de02: 58 46 53 42 00 00 10 00 00 00 00 00 00 00 10 00  XFSB............
> 0000000023bff869: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000000cdd8c893: 17 32 37 15 ff ca 46 3d 9a 17 d3 33 04 b5 f1 a2  .27...F=...3....
> 000000009fd2844f: 00 00 00 00 00 00 00 04 00 00 00 00 00 00 06 d0  ................
> 0000000088e9b0bb: 00 00 00 00 00 00 06 d1 00 00 00 00 00 00 06 d2  ................
> 00000000ff233a20: 00 00 00 01 00 00 10 00 00 00 00 01 00 00 00 00  ................
> 000000009db0ac8b: 00 00 03 60 e1 34 02 00 08 00 00 02 00 00 00 00  ...`.4..........
> 00000000f7022460: 00 00 00 00 00 00 00 00 0c 09 0b 01 0c 00 00 19  ................
> XFS (loop0): SB validate failed with error -117.
> 
> And the mount fails.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Looks good, you can add if you want:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 54c5e14fdfda..fe9448862667 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -266,6 +266,22 @@ xfs_mount_validate_sb(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (sbp->sb_unit) {
> +		if (!xfs_sb_version_hasdalign(sbp) ||
> +		    sbp->sb_unit > sbp->sb_width ||
> +		    (sbp->sb_width % sbp->sb_unit) != 0) {
> +			xfs_notice(mp, "SB stripe unit sanity check failed");
> +			return -EFSCORRUPTED;
> +		}
> +	} else if (xfs_sb_version_hasdalign(sbp)) {
> +		xfs_notice(mp, "SB stripe alignment sanity check failed");
> +		return -EFSCORRUPTED;
> +	} else if (sbp->sb_width) {
> +		xfs_notice(mp, "SB stripe width sanity check failed");
> +		return -EFSCORRUPTED;
> +	}
> +
> +
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
>  	    sbp->sb_blocksize < XFS_MIN_CRC_BLOCKSIZE) {
>  		xfs_notice(mp, "v5 SB sanity check failed");
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
