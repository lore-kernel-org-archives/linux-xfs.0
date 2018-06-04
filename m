Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:29058 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751232AbeFDV4K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jun 2018 17:56:10 -0400
Date: Tue, 5 Jun 2018 07:56:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: check directory bestfree information in the
 verifier
Message-ID: <20180604215608.GQ10363@dastard>
References: <152812862079.2736.15381483104759513267.stgit@magnolia>
 <152812862797.2736.1635127719444719703.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152812862797.2736.1635127719444719703.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:10:28AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a variant of xfs_dir2_data_freefind that is suitable for use in a
> verifier.  Because _freefind is called by the verifier, we simply
> duplicate the _freefind function, convert the ASSERTs to return
> __this_address, and modify the verifier to call our new function.  Once
> we've made it impossible for directory blocks with bad bestfree data to
> make it into the filesystem we can remove the DEBUG code from the
> regular _freefind function.
> 
> Underlying argument: corruption of on-disk metadata should return
> -EFSCORRUPTED instead of blowing ASSERTs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
