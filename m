Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46558 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758613AbeAIXDO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 18:03:14 -0500
Date: Wed, 10 Jan 2018 10:01:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: use %pS printk format for direct instruction
 addresses
Message-ID: <20180109230101.GO16421@dastard>
References: <151553075309.16288.5030700495895866371.stgit@magnolia>
 <151553076542.16288.14073908543082638592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151553076542.16288.14073908543082638592.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 12:46:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the %pS instead of the %pF printk format specifier for printing
> symbols from direct addresses. This is needed for the ia64, ppc64 and
> parisc64 architectures.

I think we've done this conversion at least once before :/

> While we're at it, be consistent with the capitalization of the 'S'.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/trace.h |   20 ++++++++++----------
>  fs/xfs/xfs_inode.c   |    4 ++--
>  fs/xfs/xfs_trace.h   |   22 +++++++++++-----------
>  3 files changed, 23 insertions(+), 23 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
