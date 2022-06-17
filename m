Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA39DC43334
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 22:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbiFQWEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 18:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFQWEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 18:04:33 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEB053A5E7
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 15:04:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 73A4F10EB808;
        Sat, 18 Jun 2022 08:04:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o2K4q-007t8Q-C0; Sat, 18 Jun 2022 08:04:28 +1000
Date:   Sat, 18 Jun 2022 08:04:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, hch@infradead.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RESEND PATCH 1/2] xfs: factor out the common lock flags assert
Message-ID: <20220617220428.GI227878@dread.disaster.area>
References: <1655433034-17934-1-git-send-email-kaixuxia@tencent.com>
 <1655433034-17934-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655433034-17934-2-git-send-email-kaixuxia@tencent.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62acfa70
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=mB9Urk2OCLzokBG8Z5MA:9
        a=CjuIK1q_8ugA:10 a=IZKFYfNWVLfQsFoIDbx0:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 10:30:33AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> There are similar lock flags assert in xfs_ilock(), xfs_ilock_nowait(),
> xfs_iunlock(), thus we can factor it out into a helper that is clear.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_inode.c | 60 ++++++++++++++++++----------------------------
>  1 file changed, 23 insertions(+), 37 deletions(-)

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
