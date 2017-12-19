Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:37413 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759505AbdLSFpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 00:45:44 -0500
Date: Tue, 19 Dec 2017 16:45:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/13] xfs: refactor short form directory structure
 verifier function
Message-ID: <20171219054541.GS4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320954767.30654.8487832272647421423.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320954767.30654.8487832272647421423.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:59:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Change the short form directory structure verifier function to return
> the instruction pointer of a failing check or NULL if everything's ok.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |   26 +++++++++++++-------------
>  fs/xfs/libxfs/xfs_inode_fork.c |    5 ++---
>  3 files changed, 16 insertions(+), 17 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
