Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11744 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935504AbdLSAMw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 19:12:52 -0500
Date: Tue, 19 Dec 2017 11:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: track cowblocks separately in i_flags
Message-ID: <20171219001202.GH4094@dastard>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335787965.26575.17711793213679430025.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335787965.26575.17711793213679430025.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 15, 2017 at 09:11:19AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The EOFBLOCKS/COWBLOCKS tags are totally separate things, so track them
> with separate i_flags.  Right now we're abusing IEOFBLOCKS for both,
> which is totally bogus because we won't tag the inode with COWBLOCKS if
> IEOFBLOCKS was set by a previous tagging of the inode with EOFBLOCKS.
> Found by wiring up clonerange to fsstress in xfs/017.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks reasonable.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
