Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58418 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933584AbdLSGXs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 01:23:48 -0500
Date: Tue, 19 Dec 2017 17:23:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/13] xfs: scrub in-core metadata
Message-ID: <20171219062314.GW4094@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320957218.30654.113836892237178906.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320957218.30654.113836892237178906.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:59:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Whenever we load a buffer, explicitly re-call the structure verifier to
> ensure that memory isn't corrupting things.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/agheader.c |    3 +++
>  fs/xfs/scrub/btree.c    |    4 ++++
>  fs/xfs/scrub/common.c   |   23 +++++++++++++++++++++++
>  fs/xfs/scrub/common.h   |    2 ++
>  fs/xfs/scrub/dabtree.c  |   22 ++++++++++++++++++++++
>  fs/xfs/scrub/dir.c      |    4 ++++
>  6 files changed, 58 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
