Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7365BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 22:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiCJW0o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242959AbiCJW0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 17:26:44 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B95A5164D1E
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 14:25:42 -0800 (PST)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A93E310E3E5A;
        Fri, 11 Mar 2022 09:25:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nSRE4-003x0c-Qt; Fri, 11 Mar 2022 09:25:40 +1100
Date:   Fri, 11 Mar 2022 09:25:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: constify the name argument to various directory
 functions
Message-ID: <20220310222540.GE3927073@dread.disaster.area>
References: <164694922267.1119724.17942999738634110525.stgit@magnolia>
 <164694922826.1119724.12550266189537977635.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164694922826.1119724.12550266189537977635.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=622a7ae6
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=liVbbrTZaW0QhWqF2mwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 10, 2022 at 01:53:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Various directory functions do not modify their @name parameter,
> so mark it const to make that clear.  This will enable us to mark
> the global xfs_name_dotdot variable as const to prevent mischief.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_dir2.c      |   30 +++++++++++++++---------------
>  fs/xfs/libxfs/xfs_dir2.h      |    6 +++---
>  fs/xfs/libxfs/xfs_dir2_priv.h |    5 +++--
>  fs/xfs/xfs_inode.c            |    6 +++---
>  fs/xfs/xfs_inode.h            |    2 +-
>  fs/xfs/xfs_trace.h            |    4 ++--
>  6 files changed, 27 insertions(+), 26 deletions(-)

Looks good. And a couple less typedefs, too, as an added bonus :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
