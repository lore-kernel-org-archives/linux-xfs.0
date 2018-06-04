Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:63315 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbeFDV4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 17:56:54 -0400
Date: Tue, 5 Jun 2018 07:56:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: introduce xfs_btree_debug_check_ptr
Message-ID: <20180604215652.GR10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <152812863422.2736.10487632470115859469.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812863422.2736.10487632470115859469.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:10:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make xfs_btree_check_ptr a non-debug function and introduce a new _debug
> version that only runs when #ifdef DEBUG.   This will enable us to reuse
> the checking logic with other parts of the btree code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
