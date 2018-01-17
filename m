Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47069 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750816AbeAQAoX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:44:23 -0500
Date: Wed, 17 Jan 2018 11:44:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 16/21] xfs: cross-reference inode btrees during scrub
Message-ID: <20180117004420.GE6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987068.18741.4829286717637372866.stgit@magnolia>
 <20180116232322.GA5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116232322.GA5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:23:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Cross-reference the inode btrees with the other metadata when we
> scrub the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix some indenting craziness, clean up helpers per dave's suggestion
> v2: streamline scrubber arguments, remove stack allocated objects
> ---

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
