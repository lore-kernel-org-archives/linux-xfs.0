Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6930 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752734AbdLCVya (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:54:30 -0500
Date: Mon, 4 Dec 2017 08:54:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 7/7] xfs: eliminate duplicate icreate tx reservation
 functions
Message-ID: <20171203215428.GV5858@dastard>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:36PM -0500, Brian Foster wrote:
> The create transaction reservation calculation has two different
> branches of code depending on whether the filesystem is a v5 format
> fs or older. Each branch considers the max reservation between the
> allocation case (new chunk allocation + record insert) and the
> modify case (chunk exists, record modification) of inode allocation.
> 
> The modify case is the same for both superblock versions with the
> exception of the finobt. The finobt helper checks the feature bit,
> however, and so the modify case already shares the same code.
> 
> Now that inode chunk allocation has been refactored into a helper
> that checks the superblock version to calculate the appropriate
> reservation for the create transaction, the only remaining
> difference between the create and icreate branches is the call to
> the finobt helper. As noted above, the finobt helper is a no-op when
> the feature is not enabled. Therefore, these branches are
> effectively duplicate and can be condensed.
> 
> Remove the xfs_calc_create_*() branch of functions and update the
> various callers to use the xfs_calc_icreate_*() variant. The latter
> creates the same reservation size for v4 create transactions as the
> removed branch. As such, this patch does not result in transaction
> reservation changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Nice simplification. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
