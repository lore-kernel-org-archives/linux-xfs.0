Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E2EC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 00:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241463AbiF1A1R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 20:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242575AbiF1A1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 20:27:10 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BADF1CFFD
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 17:27:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 28DE110E75FA;
        Tue, 28 Jun 2022 10:27:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5z4J-00BsFz-V6; Tue, 28 Jun 2022 10:27:03 +1000
Date:   Tue, 28 Jun 2022 10:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 1/3] xfs: empty xattr leaf header blocks are not
 corruption
Message-ID: <20220628002703.GH227878@dread.disaster.area>
References: <165636572124.355536.216420713221853575.stgit@magnolia>
 <165636572697.355536.5348656551657221213.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165636572697.355536.5348656551657221213.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62ba4ad9
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=DradFFlVwTRTQ0eFAyEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 02:35:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> TLDR: Revert commit 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
> xfs_attr3_leaf_verify") because it was wrong.
....
> 
> Original-bug: 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
> Still-not-fixed-by: 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier during log replay")
> Removed-in: f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf block")
> Fixes: 51e6104fdb95 ("xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 37e7c33f6283..f6629960e17b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -289,6 +289,23 @@ xfs_attr3_leaf_verify_entry(
>  	return NULL;
>  }
>  
> +/*
> + * Validate an attribute leaf block.
> + *
> + * Empty leaf blocks can occur under the following circumstances:
> + *
> + * 1. setxattr adds a new extended attribute to a file;
> + * 2. The file has zero existing attributes;
> + * 3. The attribute is too large to fit in the attribute fork;
> + * 4. The attribute is small enough to fit in a leaf block;
> + * 5. A log flush occurs after committing the transaction that creates
> + *    the (empty) leaf block; and
> + * 6. The filesystem goes down after the log flush but before the new
> + *    attribute can be committed to the leaf block.
> + *
> + * Hence we need to ensure that we don't fail the validation purely
> + * because the leaf is empty.
> + */
>  static xfs_failaddr_t
>  xfs_attr3_leaf_verify(
>  	struct xfs_buf			*bp)
> @@ -310,15 +327,6 @@ xfs_attr3_leaf_verify(
>  	if (fa)
>  		return fa;
>  
> -	/*
> -	 * Empty leaf blocks should never occur;  they imply the existence of a
> -	 * software bug that needs fixing. xfs_repair also flags them as a
> -	 * corruption that needs fixing, so we should never let these go to
> -	 * disk.
> -	 */
> -	if (ichdr.count == 0)
> -		return __this_address;
> -
>  	/*
>  	 * firstused is the block offset of the first name info structure.
>  	 * Make sure it doesn't go off the block or crash into the header.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
