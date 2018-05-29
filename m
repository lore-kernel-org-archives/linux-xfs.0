Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:63521 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932475AbeE2DQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:16:02 -0400
Date: Tue, 29 May 2018 13:16:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 05/22] xfs: recover AG btree roots from rmap data
Message-ID: <20180529031600.GL10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365045.1556.6221144971800322852.stgit@magnolia>
 <20180518035449.GB23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518035449.GB23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 17, 2018 at 08:54:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper function to help us recover btree roots from the rmap data.
> Callers pass in a list of rmap owner codes, buffer ops, and magic
> numbers.  We iterate the rmap records looking for owner matches, and
> then read the matching blocks to see if the magic number & uuid match.
> If so, we then read-verify the block, and if that passes then we retain
> a pointer to the block with the highest level, assuming that by the end
> of the call we will have found the root.  This will be used to reset the
> AGF/AGI btree root fields during their rebuild procedures.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: document how we probe for btree roots and dcoument the locking
>     requirements for the callers

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
