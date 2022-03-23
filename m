Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034B5C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 20:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbiCWUxM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 16:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbiCWUxL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 16:53:11 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26F268B6DD
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 13:51:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 200D810E50AD;
        Thu, 24 Mar 2022 07:51:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nX7xC-009318-UY; Thu, 24 Mar 2022 07:51:38 +1100
Date:   Thu, 24 Mar 2022 07:51:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220323205138.GW1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462392.550479.11627083041484347485.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779462392.550479.11627083041484347485.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623b885c
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=SZdB77bO8ckbU1GD5WsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:43AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_reserve_blocks controls the size of the user-visible free space
> reserve pool.  Given the difference between the current and requested
> pool sizes, it will try to reserve free space from fdblocks.  However,
> the amount requested from fdblocks is also constrained by the amount of
> space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> 
> In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> out the "free space" used by the free space btrees, because some portion
> of the free space btrees hold in reserve space for future btree
> expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> of blocks that it could request from xfs_mod_fdblocks was not updated to
> include m_allocbt_blks, so if space is extremely low, the caller hangs.
> 
> Fix this by creating a function to estimate the number of blocks that
> can be reserved from fdblocks, which needs to exclude the set-aside and
> m_allocbt_blks.
> 
> Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> with an fstests configuration that specifies a 1k blocksize and a
> specially crafted log size that will consume 7/8 of the space (17920
> blocks, specifically) in that AG.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
