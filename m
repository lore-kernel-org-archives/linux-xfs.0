Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62907 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751837AbeAQBFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 20:05:07 -0500
Date: Wed, 17 Jan 2018 12:03:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 20/21] xfs: cross-reference the realtime bitmap
Message-ID: <20180117010349.GI6304@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398989544.18741.8012375240764840486.stgit@magnolia>
 <20180116232751.GE5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116232751.GE5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 16, 2018 at 03:27:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> While we're scrubbing various btrees, cross-reference the records
> with the other metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v3: fix indenting and standardize helper naming, refactor helpers per dave's
>     suggestion and add clarifying comments
> v2: streamline scrubber arguments, remove stack allocated objects
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |   21 +++++++++++++++++++++
>  fs/xfs/scrub/bmap.c          |    3 +++
>  fs/xfs/scrub/rtbitmap.c      |   23 +++++++++++++++++++++++
>  fs/xfs/scrub/scrub.h         |    6 ++++++
>  fs/xfs/xfs_rtalloc.h         |    4 ++++
>  5 files changed, 57 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
