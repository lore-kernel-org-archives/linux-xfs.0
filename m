Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17458 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752385AbdLCVqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 16:46:04 -0500
Date: Mon, 4 Dec 2017 08:46:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 4/7] xfs: truncate transaction does not modify the
 inobt
Message-ID: <20171203214601.GT5858@dastard>
References: <20171130185836.18481-1-bfoster@redhat.com>
 <20171130185836.18481-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-5-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:33PM -0500, Brian Foster wrote:
> The truncate transaction does not ever modify the inode btree, but
> includes an associated log reservation. Update
> xfs_calc_itruncate_reservation() to remove the reservation
> associated with inobt updates.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
