Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:3625 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751563AbeFDWDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 18:03:13 -0400
Date: Tue, 5 Jun 2018 08:03:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/4] xfs: don't assert on corrupted unlinked inode list
Message-ID: <20180604220311.GV10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <20180604191754.GP7825@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604191754.GP7825@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 12:17:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the per-ag inode number verifiers to detect corrupt lists and error
> out, instead of using ASSERTs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, though in most cases there isn't going to be anyone to
pass the error back to....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
