Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1342 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751040AbeACAj4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:39:56 -0500
Date: Wed, 3 Jan 2018 11:39:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/20] xfs: separate dquot repair into a separate function
Message-ID: <20180103003952.GF5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399133030.23543.13471674725718289527.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399133030.23543.13471674725718289527.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:08:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the dquot repair code into a separate function and remove
> XFS_QMOPT_DQREPAIR in favor of calling the helper directly.  Remove
> other dead code because quotacheck is the only caller of DQREPAIR.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c  |   22 +++++++++++-----
>  fs/xfs/libxfs/xfs_quota_defs.h |    3 +-
>  fs/xfs/xfs_dquot.c             |   54 ----------------------------------------
>  fs/xfs/xfs_qm.c                |    7 ++++-
>  4 files changed, 22 insertions(+), 64 deletions(-)

Nice cleanup!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
