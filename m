Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:46836 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935883AbeE3Goz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 02:44:55 -0400
Date: Wed, 30 May 2018 16:44:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0.5/22] xfs: grab the per-ag structure whenever relevant
Message-ID: <20180530064452.GV10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <20180518034732.GX23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518034732.GX23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 17, 2018 at 08:47:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Grab and hold the per-AG data across a scrub run whenever relevant.
> This helps us avoid repeated trips through rcu in the repair code.

rcu and the radix tree

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Code looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
