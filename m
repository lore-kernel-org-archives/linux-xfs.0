Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD01C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 01:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiF0BQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 21:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiF0BQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 21:16:58 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 180DDF2C
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 18:16:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 27E9610E75E2;
        Mon, 27 Jun 2022 11:16:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5dN0-00BUXQ-82; Mon, 27 Jun 2022 11:16:54 +1000
Date:   Mon, 27 Jun 2022 11:16:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 1/3] xfs: empty xattr leaf header blocks are not
 corruption
Message-ID: <20220627011654.GZ227878@dread.disaster.area>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628103299.4040423.12298502732701682950.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165628103299.4040423.12298502732701682950.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b90508
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=13CCqVVdltTl2oCT6fwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 26, 2022 at 03:03:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then we get a corruption report from the kernel or
> xfs_repair about empty leaf blocks in the extended attribute structure.
> We've long thought that these shouldn't be possible, but prior to 5.18
> one would shake loose in the recoveryloop fstests about once a month.
> 
> A new addition to the xattr leaf block verifier in 5.19-rc1 makes this
> happen every 7 minutes on my testing cloud.

Ok, so this is all just a long way of saying:

Revert commit 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
xfs_attr3_leaf_verify") because it was wrong.

Yes?

> Original-bug: 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
> Still-not-fixed: 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier during log replay")
> Removed-in: f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf block")
> Fixes: 51e6104fdb95 ("xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   48 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 42 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 37e7c33f6283..be7c216ec8f2 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -311,13 +311,49 @@ xfs_attr3_leaf_verify(
>  		return fa;
>  
>  	/*
> -	 * Empty leaf blocks should never occur;  they imply the existence of a
> -	 * software bug that needs fixing. xfs_repair also flags them as a
> -	 * corruption that needs fixing, so we should never let these go to
> -	 * disk.
> +	 * Empty leaf blocks can occur under the following circumstances:
> +	 *
> +	 * 1. setxattr adds a new extended attribute to a file;
> +	 * 2. The file has zero existing attributes;
> +	 * 3. The attribute is too large to fit in the attribute fork;
> +	 * 4. The attribute is small enough to fit in a leaf block;
> +	 * 5. A log flush occurs after committing the transaction that creates
> +	 *    the (empty) leaf block; and
> +	 * 6. The filesystem goes down after the log flush but before the new
> +	 *    attribute can be committed to the leaf block.
> +	 *
> +	 * xfs_repair used to flag these empty leaf blocks as corruption, but
> +	 * aside from wasting space, they are benign.  The rest of the xattr
> +	 * code will happily add attributes to empty leaf blocks.  Hence this
> +	 * comment serves as a tombstone to incorrect verifier code.
> +	 *
> +	 * Unfortunately, this check has been added and removed multiple times
> +	 * throughout history.  It first appeared in[1] kernel 3.10 as part of
> +	 * the early V5 format patches.  The check was later discovered to
> +	 * break log recovery and hence disabled[2] during log recovery in
> +	 * kernel 4.10.  Simultaneously, the check was added[3] to xfs_repair
> +	 * 4.9.0 to try to weed out the empty leaf blocks.  This was still not
> +	 * correct because log recovery would recover an empty attr leaf block
> +	 * successfully only for regular xattr operations to trip over the
> +	 * empty block during of the block during regular operation.
> +	 * Therefore, the check was removed entirely[4] in kernel 5.7 but
> +	 * removal of the xfs_repair check was forgotten.  The continued
> +	 * complaints from xfs_repair lead to us mistakenly re-adding[5] the
> +	 * verifier check for kernel 5.19, and has been removed once again.
> +	 *
> +	 * [1] 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
> +	 * [2] 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier
> +	 *                    during log replay")
> +	 * [3] f7140161 ("xfs_repair: junk leaf attribute if count == 0")
> +	 * [4] f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf
> +	 *                    block")
> +	 * [5] 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
> +	 *                    xfs_attr3_leaf_verify")
> +	 *
> +	 * Normally this would go in the commit message, but as we've a history
> +	 * of getting this wrong, this now goes in the code base as a gigantic
> +	 * comment.
>  	 */

I still think it should be in the commit history, not here in the
code. The reason I missed this is that the existing comment about
empty leaf attrs is above a section that is verifying entries
*after* various fields in the header had been validated. Hence I
thought it was a case that the header field had not been validated
and so I added it. Simple mistake.

This needs to be a comment at the head of the function, not
associated with validity checking the entries. i.e.

/*
 * Validate the attribute leaf.
 *
 * A leaf block can be empty as a result of transient state whilst
 * creating a new leaf form attribute:
 *
 * 1. setxattr adds a new extended attribute to a file;
 * 2. The file has zero existing attributes;
 * 3. The attribute is too large to fit in the attribute fork;
 * 4. The attribute is small enough to fit in a leaf block;
 * 5. A log flush occurs after committing the transaction that creates
 *    the (empty) leaf block; and
 * 6. The filesystem goes down after the log flush but before the new
 *    attribute can be committed to the leaf block.
 *
 * Hence we need to ensure that we don't fail the validation purely
 * because the leaf is empty.
 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
