Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:46953 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751489AbeFDALV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:11:21 -0400
Date: Mon, 4 Jun 2018 10:11:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfs: remove redundant ASSERT on insufficient
 bestfree length in _leaf_addname
Message-ID: <20180604001115.GD10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806818271.18187.6990427991156565889.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806818271.18187.6990427991156565889.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:23:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_dir2_leaf_addname we ASSERT if the length of the unused space
> described by bestfree[0] is less the amount of space we wish to consume.
> Immediately after it is a call to xfs_dir2_data_use_free where the
> offset parameter is offset of the unused space and the length parameter
> is the amount of space we wish to consume.  Both values (and the unused
> space pointer) are passed into xfs_dir2_data_check_free, which also
> validates that the region of unused space is big enough to cover the
> space we wish to consume.  This is effectively the same check that the
> ASSERT covers, and since a check failure results in a corruption message
> being logged we can remove the ASSERT.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
