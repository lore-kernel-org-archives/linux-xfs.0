Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16766 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935074AbdLSAST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 19:18:19 -0500
Date: Tue, 19 Dec 2017 11:18:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: set cowblocks tag for direct cow writes too
Message-ID: <20171219001816.GK4094@dastard>
References: <151335786780.26575.15542999972223359181.stgit@magnolia>
 <151335789785.26575.9168288718937543398.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151335789785.26575.9168288718937543398.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 15, 2017 at 09:11:37AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a user performs a direct CoW write, we end up loading the CoW fork
> with preallocated extents.  Therefore, we must set the cowblocks tag so
> that they can be cleared out if we run low on space.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
