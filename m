Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:47389 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727856AbfDPH6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 03:58:06 -0400
Date: Tue, 16 Apr 2019 17:58:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/5] xfs: scrub should only cross-reference with
 healthy btrees
Message-ID: <20190416075804.GM29573@dread.disaster.area>
References: <155537397092.27935.16073573221774618735.stgit@magnolia>
 <155537400192.27935.5071586825961103642.stgit@magnolia>
 <20190416014502.GK4752@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416014502.GK4752@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Apr 15, 2019 at 06:45:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip cross-referencing with a btree if the health report tells us that
> it's known to be bad.  This should reduce the dmesg spew considerably.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: condense the switch cases per dchinner suggestion

Much nicer :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
