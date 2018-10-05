Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1105 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727179AbeJEM1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 08:27:46 -0400
Date: Fri, 5 Oct 2018 15:30:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/15] xfs: update ctime and remove suid before cloning
 files
Message-ID: <20181005053038.GD12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870030069.29072.11055871953561649172.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870030069.29072.11055871953561649172.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Thu, Oct 04, 2018 at 05:45:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before cloning into a file, update the ctime and remove sensitive
> attributes like suid, just like we'd do for a regular file write.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Because this fixes a security related problem, I'm going to push
this with the data corruption fixes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
