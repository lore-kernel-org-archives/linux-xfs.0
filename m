Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34015 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750817AbeAQAaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:30:17 -0500
Date: Wed, 17 Jan 2018 11:29:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 3/5] xfs: directory scrubber must walk through data
 block to offset
Message-ID: <20180117002936.GA6304@dastard>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579465813.8694.2293343683195960907.stgit@magnolia>
 <20180116233045.GF5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116233045.GF5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Tue, Jan 16, 2018 at 03:30:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_scrub_dir_rec, we must walk through the directory block entries
> to arrive at the offset given by the hash structure.  If we blindly
> trust the hash address, we can end up midway into a directory entry and
> stray outside the block.  Found by lastbit fuzzing lents[3].address in
> xfs/390 with KASAN enabled.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: refactor endp users to call the helper
> v2: improve defensive pointer checking (endp theoretically can be null)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
