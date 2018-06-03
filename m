Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:2053 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeFCXpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:45:54 -0400
Date: Mon, 4 Jun 2018 09:45:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: strengthen btree pointer checks before use
Message-ID: <20180603234551.GY10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806815486.18187.14504589975269520134.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806815486.18187.14504589975269520134.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:22:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Instead of ASSERTing on null btree pointers in xfs_btree_ptr_to_daddr,
> use the new block number verifiers to ensure that the btree pointer
> doesn't point to any sensitive areas (AG headers, past-EOFS) and return
> -EFSCORRUPTED if this is the case.  Remove the ASSERT because on-disk
> corruptions shouldn't trigger ASSERTs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
