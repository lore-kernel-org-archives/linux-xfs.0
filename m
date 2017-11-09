Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:6302 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751352AbdKICQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:16:41 -0500
Date: Thu, 9 Nov 2017 13:16:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: fix btree scrub deref check
Message-ID: <20171109021607.GO4094@dastard>
References: <151001660179.26786.15701876786383794673.stgit@magnolia>
 <151001663224.26786.16638321559848220870.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001663224.26786.16638321559848220870.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 05:03:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The btree scrubber has some custom code to retrieve and check a btree
> block via xfs_btree_lookup_get_block.  This function will either return
> an error code (verifiers failed) or a *pblock will be untouched (bad
> pointer).  Since we previously set *pblock to NULL, we need to check
> *pblock, not pblock, to trigger the early bailout.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ah, the dangers of double pointers. Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
