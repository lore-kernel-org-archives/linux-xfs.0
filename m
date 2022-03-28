Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A964C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 01:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiC1BW2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Mar 2022 21:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiC1BW1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Mar 2022 21:22:27 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2F594F455
        for <linux-xfs@vger.kernel.org>; Sun, 27 Mar 2022 18:20:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4274610E65D7;
        Mon, 28 Mar 2022 12:20:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYe3p-00AiTQ-N6; Mon, 28 Mar 2022 12:20:45 +1100
Date:   Mon, 28 Mar 2022 12:20:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: remove infinite loop when reserving free block
 pool
Message-ID: <20220328012045.GS1544202@dread.disaster.area>
References: <164840029642.54920.17464512987764939427.stgit@magnolia>
 <164840031362.54920.15815650183086189788.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164840031362.54920.15815650183086189788.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62410d6f
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=o92VAm4cLhzUf4l5G6YA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 27, 2022 at 09:58:33AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
> should be rare (people should just use the defaults!) so we really don't
> need to try so hard.  Simplify the logic here by removing the infinite
> loop.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good. Callers are already expected to handle failure because
ENOSPC, so removing the loop and returning ENOSPC on failure is fine
by me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
