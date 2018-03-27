Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:47799 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752227AbeC0XJy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:09:54 -0400
Date: Wed, 28 Mar 2018 10:09:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/20] xfs: add BMAPI_NORMAP flag to perform block
 remapping without updating rmpabt
Message-ID: <20180327230951.GW18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210858579.13184.11212409465147497211.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210858579.13184.11212409465147497211.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new flag, XFS_BMAPI_NORMAP, which will perform file block
> remapping without updating the rmapbt.  This will be used by the repair
> code to reconstruct bmbts from the rmapbt, in which case we don't want
> the rmapbt update.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hmmm - this also converts xfs_bmapi_remap() to be able to operate
on the attribute fork. they seem unrelated, so maybe this should be
two patches?

Otherwise it looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
