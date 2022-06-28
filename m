Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81862C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiF1W7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiF1W7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:59:01 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E500432EF1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:58:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 02A0C10E787E;
        Wed, 29 Jun 2022 08:58:58 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6KAb-00CFSH-Vd; Wed, 29 Jun 2022 08:58:57 +1000
Date:   Wed, 29 Jun 2022 08:58:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem
 doesn't support nrext64
Message-ID: <20220628225857.GO227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936573.1089996.11135224585697421312.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644936573.1089996.11135224585697421312.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bb87b3
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=qT1kxbrivFsqesuqiNQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:49:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
> feature enabled in the superblock.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/dinode.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 00de31fb..547c5833 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2690,6 +2690,25 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			}
>  		}
>  
> +		if (xfs_dinode_has_large_extent_counts(dino) &&
> +		    !xfs_has_large_extent_counts(mp)) {
> +			if (!uncertain) {
> +				do_warn(
> +	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
> +					lino);
> +			}
> +			flags2 &= ~XFS_DIFLAG2_NREXT64;
> +
> +			if (no_modify) {
> +				do_warn(_("would zero extent counts.\n"));
> +			} else {
> +				do_warn(_("zeroing extent counts.\n"));
> +				dino->di_nextents = 0;
> +				dino->di_anextents = 0;
> +				*dirty = 1;

Is that necessary? If the existing extent counts are within the
bounds of the old extent fields, then shouldn't we just rewrite the
current values into the old format rather than trashing all the
data/xattrs on the inode?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
