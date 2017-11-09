Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:27115 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751470AbdKICL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:11:56 -0500
Date: Thu, 9 Nov 2017 13:11:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: refactor the directory data block bestfree
 checks
Message-ID: <20171109021135.GL4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001661390.26786.10161063535996587375.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001661390.26786.10161063535996587375.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>

On Mon, Nov 06, 2017 at 05:03:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In a directory data block, the zeroth bestfree item must point to the
> longest free space.  Therefore, when we check the bestfree block's
> records against the data blocks, we only need to compare with bf[0] and
> don't need the loop.
> 
> The weird loop was most probably the result of an earlier refactoring
> gone bad.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.


Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
