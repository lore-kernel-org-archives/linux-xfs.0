Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:34365 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbeDEXOM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Apr 2018 19:14:12 -0400
Date: Fri, 6 Apr 2018 09:14:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/21] xfs: halt auto-reclamation activities while
 rebuilding rmap
Message-ID: <20180405231410.GL23861@dastard>
References: <152269897182.16346.1710955088267364781.stgit@magnolia>
 <152269901947.16346.4613132998047134020.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152269901947.16346.4613132998047134020.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 02, 2018 at 12:56:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuilding the reverse-mapping tree requires us to quiesce all inodes in
> the filesystem, so we must stop background reclamation of post-EOF and
> CoW prealloc blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Cleans up this set of operations nicely!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
