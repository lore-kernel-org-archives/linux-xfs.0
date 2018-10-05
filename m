Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:50160 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727558AbeJEMZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 08:25:46 -0400
Date: Fri, 5 Oct 2018 15:28:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/15] xfs: zero posteof blocks when cloning above eof
Message-ID: <20181005052839.GC12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870029414.29072.6572683664719818617.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153870029414.29072.6572683664719818617.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Oct 04, 2018 at 05:44:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're reflinking between two files and the destination file range
> is well beyond the destination file's EOF marker, zero any posteof
> speculative preallocations in the destination file so that we don't
> expose stale disk contents.  The previous strategy of trying to clear
> the preallocations does not work if the destination file has the
> PREALLOC flag set.
> 
> Uncovered by shared/010.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Bugzilla-id: https://bugzilla.kernel.org/show_bug.cgi?id=201259
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
