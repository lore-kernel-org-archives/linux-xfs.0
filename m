Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC8BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 23:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C7861076
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 23:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhKKX1c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 18:27:32 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52560 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229710AbhKKX1b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 18:27:31 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 724CA105CD5A;
        Fri, 12 Nov 2021 10:24:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mlJQt-007iYg-Qe; Fri, 12 Nov 2021 10:24:39 +1100
Date:   Fri, 12 Nov 2021 10:24:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] xfs: add leaf to node error tag
Message-ID: <20211111232439.GK449541@dread.disaster.area>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111001716.77336-3-catherine.hoang@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=618da638
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=kj9zAlcOel0A:10 a=vIxV3rELxO4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=uau6aF2md854eXosP6gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:17:16AM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
> recovery and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>  fs/xfs/xfs_error.c            | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 74b76b09509f..fdeb09de74ca 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -28,6 +28,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
> +#include "xfs_errortag.h"
>  
>  
>  /*
> @@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
>  
>  	trace_xfs_attr_leaf_to_node(args);
>  
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LEAF_TO_NODE)) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 31aeeb94dd5b..cc1650b58723 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_LEAF_SPLIT				40
> -#define XFS_ERRTAG_MAX					41
> +#define XFS_ERRTAG_LEAF_TO_NODE				41
> +#define XFS_ERRTAG_MAX					42

Same again about naming. THis is an attribute fork injection point,
not a generic "leaf-to-node" error injection point.

Whihc makes me wonder: this is testing just the initial leaf split
shape change. There are other shape changes - inline -> leaf, leaf
-> multi-level tree (xfs_da3_split()) and multi-level -> single
level leaf, leaf -> inline - for the attr tree, and there are even
more shape changes for the directory tree (inline, leaf, leafN,
node)

As a general infrastructure question, are we really going to now add
separate error injections for each different shape change on each
different type of btree? That explodes the number of injection
points quite quickly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
