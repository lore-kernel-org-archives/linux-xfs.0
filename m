Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:25213
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751506AbdJPC0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Oct 2017 22:26:01 -0400
Date: Mon, 16 Oct 2017 13:25:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/30] xfs: scrub free space btrees
Message-ID: <20171016022558.GT3666@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777255503.1724.7657235551348811131.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777255503.1724.7657235551348811131.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:42:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the extent records free space btrees to ensure that the values
> look sane.

Minor thing:

> +/* Scrub a bnobt/cntbt record. */
> +STATIC int
> +xfs_scrub_allocbt_helper(

xfs_scrub_allocbt_rec()

Reads much more nicely with this name. :P

Otherwise, consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
