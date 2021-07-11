Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DFB6C07E96
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jul 2021 22:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3DB61008
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jul 2021 22:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhGKWtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jul 2021 18:49:43 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:55454 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhGKWtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jul 2021 18:49:43 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3150C4ED3;
        Mon, 12 Jul 2021 08:46:53 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m2iDr-005SU9-Kp; Mon, 12 Jul 2021 08:46:51 +1000
Date:   Mon, 12 Jul 2021 08:46:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] fs:xfs: cleanup __FUNCTION__ usage
Message-ID: <20210711224651.GR664593@dread.disaster.area>
References: <20210711085153.95856-1-dwaipayanray1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210711085153.95856-1-dwaipayanray1@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=-04TyFfsXmtQx-_KwuwA:9 a=KzjSoPuBCdaCrBdG:21
        a=r1UvY4bH-UbycAGe:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 11, 2021 at 02:21:53PM +0530, Dwaipayan Ray wrote:
> __FUNCTION__ exists only for backwards compatibility reasons
> with old gcc versions. Replace it with __func__.
> 
> Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
> ---
>  fs/xfs/xfs_icreate_item.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 9b3994b9c716..017904a34c02 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -201,7 +201,7 @@ xlog_recover_icreate_commit_pass2(
>  	if (length != igeo->ialloc_blks &&
>  	    length != igeo->ialloc_min_blks) {
>  		xfs_warn(log->l_mp,
> -			 "%s: unsupported chunk length", __FUNCTION__);
> +			 "%s: unsupported chunk length", __func__);
>  		return -EINVAL;
>  	}
>  
> @@ -209,7 +209,7 @@ xlog_recover_icreate_commit_pass2(
>  	if ((count >> mp->m_sb.sb_inopblog) != length) {
>  		xfs_warn(log->l_mp,
>  			 "%s: inconsistent inode count and chunk length",
> -			 __FUNCTION__);
> +			 __func__);
>  		return -EINVAL;
>  	}

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

For future reference, the subject only needs "xfs:", you can drop
the "fs:" prefix from it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
