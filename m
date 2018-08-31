Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:17903 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbeHaGdY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Aug 2018 02:33:24 -0400
Date: Fri, 31 Aug 2018 12:28:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/18] xfs: support storing records in the inode core root
Message-ID: <20180831022812.GJ5631@dastard>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
 <153565390854.32612.15669075123760228429.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153565390854.32612.15669075123760228429.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 30, 2018 at 11:31:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make it so that we can actually store btree records in the inode
> core (i.e. enable bb_level == 0) so that the rtrmapbt can do this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

So this is so you don't need XFS_DINODE_FMT_RMAP_EXTENTS/BTREE 
inode fork types, right? i.e. there just XFS_DINODE_FMT_RMAP to
indicate it's an rmap tree in the fork?

Could this code be used by the data fork, too? Sure, we need to
keep the on-disk fork format info the same, but we could use this to
kill the special BMDR formatting code it currently uses, right?

(just trying to get an idea of whether we'll have to maintain two
bits of code that do essentially the same thing forever)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
