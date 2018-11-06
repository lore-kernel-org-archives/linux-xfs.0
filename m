Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:40161 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387612AbeKGHGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 02:06:51 -0500
Date: Wed, 7 Nov 2018 08:39:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: hoist inode cluster checks out of loop
Message-ID: <20181106213933.GS19305@dastard>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147732071.32496.10360183009741260995.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154147732071.32496.10360183009741260995.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 08:08:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hoist the inode cluster checks out of the inobt record check loop into
> a separate function in preparation for refactoring of that loop.  No
> functional changes here; that's in the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks ok,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
