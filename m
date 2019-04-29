Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51046 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726439AbfD2BsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 21:48:18 -0400
Date: Mon, 29 Apr 2019 11:48:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfs: add online scrub for superblock counters
Message-ID: <20190429014813.GH29573@dread.disaster.area>
References: <20190428221006.GD5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428221006.GD5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Sun, Apr 28, 2019 at 03:10:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach online scrub how to check the filesystem summary counters.  We use
> the incore delalloc block counter along with the incore AG headers to
> compute expected values for fdblocks, icount, and ifree, and then check
> that the percpu counter is within a certain threshold of the expected
> value.  This is done to avoid having to freeze or otherwise lock the
> filesystem, which means that we're only checking that the counters are
> fairly close, not that they're exactly correct.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks OK, the variance checking seems a lot better for both small
and large filesystems.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
