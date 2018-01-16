Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:23687 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751415AbeAPC7F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jan 2018 21:59:05 -0500
Date: Tue, 16 Jan 2018 13:58:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 21/21] xfs: cross-reference the block mappings when
 possible
Message-ID: <20180116025855.GG16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398990147.18741.17837826861246689519.stgit@magnolia>
 <20180109212633.GP5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109212633.GP5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 01:26:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use an inode's block mappings to cross-reference inode block counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: streamline scrubber arguments, remove stack allocated objects
> ---
>  fs/xfs/scrub/inode.c |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
