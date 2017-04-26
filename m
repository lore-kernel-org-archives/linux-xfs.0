Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49970 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965945AbdDZTLT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Apr 2017 15:11:19 -0400
Date: Wed, 26 Apr 2017 12:11:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/4] xfs_db: use iocursor type to guess btree geometry
 if bad magic
Message-ID: <20170426191109.GY23371@birch.djwong.org>
References: <149186446125.32572.5134583964816531229.stgit@birch.djwong.org>
 <149186447366.32572.11858750403661352513.stgit@birch.djwong.org>
 <20170411002012.GB5094@birch.djwong.org>
 <2b0434c2-a636-87ba-684d-375f30becf00@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b0434c2-a636-87ba-684d-375f30becf00@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 01:47:47PM -0500, Eric Sandeen wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function block_to_bt plays an integral role in determining the btree
> geometry of a block that we want to manipulate with the debugger.
> Normally we use the block magic to find the geometry profile, but if the
> magic is bad we'll never find it and return NULL.  The callers of this
> function do not check for NULL and crash.
> 
> Therefore, if we can't find a geometry profile matching the magic
> number, use the iocursor type to guess the profile and scowl about that
> to stdout.  This makes it so that even with a corrupt magic we can try
> to print the fields instead of crashing the debugger.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: be less macro-happy and only evaluate hascrc once
> v3: braces around the for loop body
> v4: proposed maintainer changes from eric:
>     fix comments, add magic assert, keep other asserts which
>     were removed for unknown reasons...

Needs a S-o-b: Eric Sandeen for the changes you made, but otherwise,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/db/btblock.c b/db/btblock.c
> index 835a5f0..b7eacb5 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -25,6 +25,8 @@
>  #include "print.h"
>  #include "bit.h"
>  #include "init.h"
> +#include "io.h"
> +#include "output.h"
>  
>  /*
>   * Definition of the possible btree block layouts.
> @@ -113,22 +115,60 @@ struct xfs_db_btree {
>  };
>  
>  /*
> - * Find the right block defintion for a given ondisk block.
> - *
> - * We use the least significant bit of the magic number as index into
> - * the array of block defintions.
> + * Find the right block definition for a given ondisk block.
>   */
>  static struct xfs_db_btree *
>  block_to_bt(
>  	struct xfs_btree_block	*bb)
>  {
> -	struct xfs_db_btree *btp = &btrees[0];
> +	struct xfs_db_btree	*btp;
> +	uint32_t		magic;
> +	bool			crc;
>  
> -	do {
> -		if (be32_to_cpu((bb)->bb_magic) == btp->magic)
> +	magic = be32_to_cpu((bb)->bb_magic);
> +	for (btp = &btrees[0]; btp->magic != 0; btp++) {
> +		if (magic == btp->magic)
> +			return btp;
> +	}
> +
> +	/* Magic is invalid/unknown.  Guess based on iocur type */
> +	crc = xfs_sb_version_hascrc(&mp->m_sb);
> +	switch (iocur_top->typ->typnm) {
> +	case TYP_BMAPBTA:
> +	case TYP_BMAPBTD:
> +		magic = crc ? XFS_BMAP_CRC_MAGIC : XFS_BMAP_MAGIC;
> +		break;
> +	case TYP_BNOBT:
> +		magic = crc ? XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC;
> +		break;
> +	case TYP_CNTBT:
> +		magic = crc ? XFS_ABTC_CRC_MAGIC : XFS_ABTC_MAGIC;
> +		break;
> +	case TYP_INOBT:
> +		magic = crc ? XFS_IBT_CRC_MAGIC : XFS_IBT_MAGIC;
> +		break;
> +	case TYP_FINOBT:
> +		magic = crc ? XFS_FIBT_CRC_MAGIC : XFS_FIBT_MAGIC;
> +		break;
> +	case TYP_RMAPBT:
> +		magic = crc ? XFS_RMAP_CRC_MAGIC : 0;
> +		break;
> +	case TYP_REFCBT:
> +		magic = crc ? XFS_REFC_CRC_MAGIC : 0;
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
> +
> +	ASSERT(magic);
> +	dbprintf(_("Bad btree magic 0x%x; coercing to %s.\n"),
> +		be32_to_cpu((bb)->bb_magic),
> +		iocur_top->typ->name);
> +
> +	for (btp = &btrees[0]; btp->magic != 0; btp++) {
> +		if (magic == btp->magic)
>  			return btp;
> -		btp++;
> -	} while (btp->magic != 0);
> +	}
>  
>  	return NULL;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
