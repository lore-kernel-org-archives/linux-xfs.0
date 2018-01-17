Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:32018 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750796AbeAQAwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:52:32 -0500
Date: Wed, 17 Jan 2018 11:52:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 17/21] xfs: cross-reference reverse-mapping btree
Message-ID: <20180117005230.GF6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398987679.18741.2129470901020229164.stgit@magnolia>
 <20180116232502.GB5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116232502.GB5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:25:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When scrubbing various btrees, we should cross-reference the records
> with the reverse mapping btree and ensure that traversing the btree
> finds the same number of blocks that the rmapbt thinks are owned by
> that btree.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix indenting and standardize helper naming, refactor helpers per dave's suggestion
> v2: streamline scrubber arguments, remove stack allocated objects
> ---

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
