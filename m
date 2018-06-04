Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:62824 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751444AbeFDAST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 20:18:19 -0400
Date: Mon, 4 Jun 2018 10:18:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/10] xfs: don't return garbage buffers in
 xfs_da3_node_read
Message-ID: <20180604001817.GH10363@dastard>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
 <152806820783.18187.7435549978381764983.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152806820783.18187.7435549978381764983.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 03, 2018 at 04:23:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If we're reading a node in a dir/attr btree and the buffer comes off the
> disk with a magic number we don't recognize, don't ASSERT and don't set
> a garbage buffer type (0 also triggers ASSERTs).  Instead, report the
> corruption, release the buffer, and return -EFSCORRUPTED because that's
> what the dabtree is -- corrupt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Makes sense. I'm kinda surprised we haven't tripped over this given
that it looks like an obvious fuzzer target....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
