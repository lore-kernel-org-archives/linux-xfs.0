Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61571 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752311AbeC0XPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:15:11 -0400
Date: Wed, 28 Mar 2018 10:15:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/20] xfs: halt auto-reclamation activities while
 rebuilding rmap
Message-ID: <20180327231509.GX18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210859201.13184.1114348565922103.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210859201.13184.1114348565922103.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuilding the reverse-mapping tree requires us to quiesce all inodes in
> the filesystem, so we must stop background reclamation of post-EOF and
> CoW prealloc blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

We also do the same thing during remount and unmount, so these
helpers should be used in those places, too.

And, thinking about it - if the filesystem is frozen then we should
also be cancelling this background work and re-enabling it on
thaw. Seems like we've missed that altogether...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
