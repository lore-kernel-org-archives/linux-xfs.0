Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B48C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jun 2022 21:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiFPVyn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jun 2022 17:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378570AbiFPVym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jun 2022 17:54:42 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A96CC5D64F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 14:54:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5A89710E75D0;
        Fri, 17 Jun 2022 07:54:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1xRl-007UNv-E6; Fri, 17 Jun 2022 07:54:37 +1000
Date:   Fri, 17 Jun 2022 07:54:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 16/17] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
Message-ID: <20220616215437.GF227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611094200.129502-17-allison.henderson@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62aba69f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=aCTOmMBIufKB2SpVV7AA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 02:41:59AM -0700, Allison Henderson wrote:
> Renames that generate parent pointer updates will need to 2 extra defer
> operations. One for the rmap update and another for the parent pointer
> update

Not sure I follow this - defer operation counts are something
tracked in the transaction reservations, whilst this is changing the
number of inodes that are joined and held across defer operations.

These rmap updates already occur on the directory inodes in a rename
(when the dir update changes the dir shape), so I'm guessing that
you are now talking about changing parent attrs for the child inodes
may require attr fork shape changes (hence rmap updates) due to the
deferred parent pointer xattr update?

If so, this should be placed in the series before the modifications
to the rename operation is modified to join 4 ops to it, preferably
at the start of the series....

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 114a3a4930a3..0c2a6e537016 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -70,7 +70,7 @@ extern const struct xfs_defer_op_type xfs_attr_defer_type;
>  /*
>   * Deferred operation item relogging limits.
>   */
> -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> +#define XFS_DEFER_OPS_NR_INODES	4	/* join up to four inodes */

The comment is not useful  - it should desvribe what operation
requires 4 inodes to be joined. e.g.

/*
 * Rename w/ parent pointers requires 4 indoes with defered ops to
 * be joined to the transaction.
 */

Then, if we are changing the maximum number of inodes that are
joined to a deferred operation, then we need to also update the
locking code such as in xfs_defer_ops_continue() that has to order
locking of multiple inodes correctly.

Also, rename can lock and modify 5 inodes, not 4, so the 4 inodes
that get joined here need to be clearly documented somewhere. Also,
xfs_sort_for_rename() that orders all the inodes in rename into
correct locking order in an array, and xfs_lock_inodes() that does
the locking of the inodes in the array.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
