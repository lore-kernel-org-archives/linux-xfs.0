Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:11873 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935504AbdLSANb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 19:13:31 -0500
Date: Tue, 19 Dec 2017 11:12:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: don't be so eager to clear the cowblocks tag on
 truncate
Message-ID: <20171219001258.GI4094@dastard>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335788573.26575.10453091656387965703.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335788573.26575.10453091656387965703.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 15, 2017 at 09:11:25AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, xfs_itruncate_extents clears the cowblocks tag if i_cnextents
> is zero.  This is wrong, since i_cnextents only tracks real extents in
> the CoW fork, which means that we could have some delayed CoW
> reservations still in there that will now never get cleaned.
> 
> Fix a further bug where we /don't/ clear the reflink iflag if there are
> any attribute blocks -- really, it's only safe to clear the reflink flag
> if there are no data fork extents and no cow fork extents.
> 
> Found by adding clonerange to fsstress in xfs/017.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
