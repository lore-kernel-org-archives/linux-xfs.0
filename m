Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:6240 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751052AbeFDV6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 17:58:35 -0400
Date: Tue, 5 Jun 2018 07:58:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: strengthen btree pointer checks before use
Message-ID: <20180604215833.GT10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <152812864651.2736.14013770828662833917.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812864651.2736.14013770828662833917.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:10:46AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Instead of ASSERTing on null btree pointers in xfs_btree_ptr_to_daddr,
> use the new block number verifiers to ensure that the btree pointer
> doesn't point to any sensitive areas (AG headers, past-EOFS) and return
> -EFSCORRUPTED if this is the case.  Remove the ASSERT because on-disk
> corruptions shouldn't trigger ASSERTs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I still get the feling we're going to have to validate ptrs before
we pull them from the tree, but this patch is fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
