Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E85DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 05:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiFPFjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 01:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358910AbiFPFiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 01:38:21 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF5925B3FF
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 22:38:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 856C710E75FF;
        Thu, 16 Jun 2022 15:38:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1iCl-007DoK-V8; Thu, 16 Jun 2022 15:38:07 +1000
Date:   Thu, 16 Jun 2022 15:38:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 09/17] xfs: extent transaction reservations for parent
 attributes
Message-ID: <20220616053807.GC227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-10-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62aac1c1
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=T5YSFahVxu7R_s6lTFoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:52AM -0700, Allison Henderson wrote:
> We need to add, remove or modify parent pointer attributes during
> create/link/unlink/rename operations atomically with the dirents in the
> parent directories being modified. This means they need to be modified
> in the same transaction as the parent directories, and so we need to add
> the required space for the attribute modifications to the transaction
> reservations.
> 
> [achender: rebased, added xfs_sb_version_hasparent stub]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h     |   5 ++
>  fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
>  3 files changed, 90 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index afdfc8108c5f..96976497306c 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -390,6 +390,11 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> +static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
> +{
> +	return false; /* We'll enable this at the end of the set */
> +}

Just noticed this in passing - I have not looked at the reservation
calculations at all yet. We don't use "xfs_sb_version" feature
checks anymore. This goes into xfs_mount.h as a feature flag and we
use xfs_has_parent_pointers(mp) to check for the feature rather that
superblock bits.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
