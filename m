Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27831 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751342AbeAEBYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:24:39 -0500
Date: Fri, 5 Jan 2018 12:23:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/21] xfs: distinguish between corrupt inode and invalid
 inum in xfs_scrub_get_inode
Message-ID: <20180105012328.GS30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398980084.18741.9629764343639418897.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398980084.18741.9629764343639418897.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:20PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_scrub_get_inode, we don't do a good enough job distinguishing
> EINVAL returns from xfs_iget w/ IGET_UNTRUSTED -- this can happen if the
> passed in inode number is invalid (past eofs, inobt says it isn't an
> inode) or if the inum is actually valid but the inode buffer fails
> verifier.  In the first case we still want to return ENOENT, but in the
> second case we want to capture the corruption error.
> 
> Therefore, if xfs_iget returns EINVAL, try the raw imap lookup.  If that
> succeeds, we conclude it's a corruption error, otherwise we just bounce
> out to userspace.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine - it's in an error path so isn't going to affect anything
in the common "everything is fine" case.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
