Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2141C07E96
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 01:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C761861380
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 01:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhGNBPH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:15:07 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33281 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 21:15:07 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B3937104527D;
        Wed, 14 Jul 2021 11:12:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3TRf-006GFl-6M; Wed, 14 Jul 2021 11:12:15 +1000
Date:   Wed, 14 Jul 2021 11:12:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix an integer overflow error in xfs_growfs_rt
Message-ID: <20210714011215.GU664593@dread.disaster.area>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
 <162612765097.39052.11033534688048926480.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162612765097.39052.11033534688048926480.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=S-Yqqz7BlUN-N22TglQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 03:07:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During a realtime grow operation, we run a single transaction for each
> rt bitmap block added to the filesystem.  This means that each step has
> to be careful to increase sb_rblocks appropriately.
> 
> Fix the integer overflow error in this calculation that can happen when
> the extent size is very large.  Found by running growfs to add a rt
> volume to a filesystem formatted with a 1g rt extent size.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_rtalloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 8920bce4fb0a..a47d43c30283 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1019,7 +1019,7 @@ xfs_growfs_rt(
>  		nsbp->sb_rbmblocks = bmbno + 1;
>  		nsbp->sb_rblocks =
>  			XFS_RTMIN(nrblocks,
> -				  nsbp->sb_rbmblocks * NBBY *
> +				  (xfs_rfsblock_t)nsbp->sb_rbmblocks * NBBY *
>  				  nsbp->sb_blocksize * nsbp->sb_rextsize);
>  		nsbp->sb_rextents = nsbp->sb_rblocks;
>  		do_div(nsbp->sb_rextents, nsbp->sb_rextsize);

Oh, that's just nasty code.  This needs a comment explaining that the
cast is to avoid an overflow, otherwise someone will come along
later and remove the "unnecessary" cast.

Alternatively, because we do "nsbp->sb_rbmblocks = bmbno + 1;" a
couple of lines above, this could be done differently without the
need for a cast. Make bmbno a xfs_rfsblock_t, and simply write the
code as:

		nsbp->sb_rblocks = min(nrblocks,
					(bmbno + 1) * NBBY *
					nsbp->sb_blocksize * nsbp->sb_rextsize);
		nsbp->sb_rbmblocks = bmbno + 1;

Notes for future cleanup:

#define XFS_RTMIN(a,b) ((a) < (b) ? (a) : (b))

Needs to die.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
