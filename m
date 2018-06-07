Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16165 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752620AbeFGFci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 01:32:38 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fQnXI-0004uH-5G
        for linux-xfs@vger.kernel.org; Thu, 07 Jun 2018 15:32:36 +1000
Date: Thu, 7 Jun 2018 15:32:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: setup VFS i_rwsem lockdep state correctly
Message-ID: <20180607053236.GR10363@dastard>
References: <20180607052132.6207-1-david@fromorbit.com>
 <20180607052132.6207-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607052132.6207-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 03:21:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When lockdep is enabled, it changes the type of the inode i_rwsem
> semaphore before unlocking a newly instantiated inode. THere is the
> possibility that there is already a waiter on that inode lock by the
> time we unlock the new inode, so having lockdep re-initialise the
> lock is a vector for trouble.
> 
> Avoid this whole situation by setting up the i_rwsem lockdep class
> at the same time we set up the XFS inode i_ilock classes and so the
> VFS doesn't have to change the lock class itself when it is
> potentially unsafe.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

I just realised that the VFS equivalent patch has made it upstream,
too, which would help explain this a bit more. Darrick, can you add
this to the commit message:

"This change is necessary because the equivalent fixes to the VFS
code made in commit 1e2e547a93a0 ("do d_instantiate/unlock_new_inode
combinations safely") are not relevant to XFS as it has it's own
internal inode cache lookup and instantiation routines."

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
