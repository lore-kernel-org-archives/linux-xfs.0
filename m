Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:45577 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751713AbeFDAO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:14:57 -0400
Date: Mon, 4 Jun 2018 10:14:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: btree lookup shouldn't ASSERT on empty btree
 nodes
Message-ID: <20180604001454.GF10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806819494.18187.5772777797608092085.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806819494.18187.5772777797608092085.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:23:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a btree lookup encounters an empty btree node or an empty btree leaf
> on a multi-level btree, that's evidence of a corrupt on-disk btree.
> Therefore, we should return -EFSCORRUPTED to the upper levels, not an
> ASSERT failure.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
