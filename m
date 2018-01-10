Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17389 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752057AbeAJAUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jan 2018 19:20:09 -0500
Date: Wed, 10 Jan 2018 11:19:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 15/21] xfs: cross-reference bnobt records with cntbt
Message-ID: <20180110001950.GS16421@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398986464.18741.745289369411639057.stgit@magnolia>
 <20180109212008.GJ5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109212008.GJ5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 09, 2018 at 01:20:08PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Scrub should make sure that each bnobt record has a corresponding
> cntbt record.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: streamline scrubber arguments, remove stack allocated objects
> ---
>  fs/xfs/scrub/agheader.c |   35 +++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/alloc.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)

A little difficult to follow ("other" meaning the "other freespace
btree" is the slightly odd bit), but otherwise OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
