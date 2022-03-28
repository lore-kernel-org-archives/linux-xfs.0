Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26860C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 01:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235396AbiC1BYX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 21:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiC1BYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 21:24:23 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C7394F459
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 18:22:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C408C10E6B08;
        Mon, 28 Mar 2022 12:22:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYe5h-00AiUx-O7; Mon, 28 Mar 2022 12:22:41 +1100
Date:   Mon, 28 Mar 2022 12:22:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 5/6] xfs: fix overfilling of reserve pool
Message-ID: <20220328012241.GU1544202@dread.disaster.area>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840032479.54920.10404960270844945481.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840032479.54920.10404960270844945481.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62410de3
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=xX8A-mVNdzcDI1DFrjMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 27, 2022 at 09:58:44AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Due to cycling of m_sb_lock, it's possible for multiple callers of
> xfs_reserve_blocks to race at changing the pool size, subtracting blocks
> from fdblocks, and actually putting it in the pool.  The result of all
> this is that we can overfill the reserve pool to hilarious levels.
> 
> xfs_mod_fdblocks, when called with a positive value, already knows how
> to take freed blocks and either fill the reserve until it's full, or put
> them in fdblocks.  Use that instead of setting m_resblks_avail directly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Another corner case fixed :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
