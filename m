Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:6833 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750766AbdJLFvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 01:51:21 -0400
Date: Thu, 12 Oct 2017 16:51:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/30] xfs: refactor btree pointer checks
Message-ID: <20171012055119.GS15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777246184.1724.16766765917643944746.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777246184.1724.16766765917643944746.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the btree pointer checks so that we can call them from the
> scrub code without logging errors to dmesg.  Preserve the existing error
> reporting for regular operations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  |    4 +--
>  fs/xfs/libxfs/xfs_btree.c |   70 +++++++++++++++++++++------------------------
>  fs/xfs/libxfs/xfs_btree.h |   13 +++++++-
>  3 files changed, 45 insertions(+), 42 deletions(-)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
