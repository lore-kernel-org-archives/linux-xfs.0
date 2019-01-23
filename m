Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:15454 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbfAWUvj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 15:51:39 -0500
Date: Thu, 24 Jan 2019 07:51:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: initialize non-leaf finobt blocks with
 correct magic
Message-ID: <20190123205136.GM4205@dastard>
References: <20190123185929.46507-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123185929.46507-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>

On Wed, Jan 23, 2019 at 01:59:29PM -0500, Brian Foster wrote:
> The free inode btree construction code in xfs_repair has a bug where
> any non-leaf nodes outside of the leftmost block at the associated
> level in the tree are incorrectly initialized with the inobt magic
> value. Update the prop_ino_cursor() path responsible for growing the
> non-leaf portion of the inode btrees to use the btnum of the
> specific tree being generated rather than the hardcoded inode btree
> type.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reported-by: Lucas Stach <l.stach@pengutronix.de>
> Root-caused-by: Lucas Stach <l.stach@pengutronix.de>

Looks fine, but one minor thing I noticed when looking at the other
cursor functions that handled different tree types was that they
assert the valid btnums at the start of the prop_?_cursor()
function. I note that build_ino_tree() has a similar assert:

	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);

might be worth adding just for consistency with the rest of the
code?

Other than that,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave.
-- 
Dave Chinner
david@fromorbit.com
