Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:2420 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751480AbdDHXT4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Apr 2017 19:19:56 -0400
Date: Sun, 9 Apr 2017 09:19:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs_db: use iocursor type to guess btree geometry if
 bad magic
Message-ID: <20170408231953.GF23007@dastard>
References: <149162062276.22901.7801103937404880951.stgit@birch.djwong.org>
 <149162063502.22901.11947139521251833946.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149162063502.22901.11947139521251833946.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Apr 07, 2017 at 08:03:55PM -0700, Darrick J. Wong wrote:
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

....

> +#define M(a,b) (!xfs_sb_version_hascrc(&mp->m_sb) ? (a) : (b))
> +	switch (iocur_top->typ->typnm) {
> +	case TYP_BMAPBTA:
> +	case TYP_BMAPBTD:
> +		magic = M(XFS_BMAP_MAGIC, XFS_BMAP_CRC_MAGIC);
> +		break;

That's really quite special, Darrick. :P

This:

	(!xfs_sb_version_hascrc(&mp->m_sb) ? (a) : (b))

Could written more simply as:

	(xfs_sb_version_hascrc(&mp->m_sb) ? (b) : (a))

or you could swap the macro args so you only need to drop the
negation.

Even better, though, would be to use a local variable to only
evaluate the CRC status once and kill the macro altogether:

	has_crc = xfs_sb_version_hascrc(&mp->m_sb);
	switch (iocur_top->typ->typnm) {
	case TYP_BMAPBTA:
	case TYP_BMAPBTD:
		magic = has_crc ? XFS_ABTB_CRC_MAGIC : XFS_ABTB_MAGIC;
		break;
.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
