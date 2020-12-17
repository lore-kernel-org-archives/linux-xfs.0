Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E61AC4361B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 02:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D73C23405
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Dec 2020 02:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLQCwH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 21:52:07 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:43079 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727396AbgLQCwG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Dec 2020 21:52:06 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id CA7911055D4;
        Thu, 17 Dec 2020 13:51:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kpjNy-004ltk-Us; Thu, 17 Dec 2020 13:51:22 +1100
Date:   Thu, 17 Dec 2020 13:51:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove xfs_buf_t typedef
Message-ID: <20201217025122.GO632069@dread.disaster.area>
References: <20201217003854.GD6918@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217003854.GD6918@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=brpUl30mPXIxXrqNKDUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 16, 2020 at 04:38:54PM -0800, Darrick J. Wong wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Prepare for kernel xfs_buf  alignment by getting rid of the
> xfs_buf_t typedef from userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick: port the kernel now the 5.11 stuff has stabilized]
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |   16 ++++++++--------
>  fs/xfs/libxfs/xfs_bmap.c     |    6 +++---
>  fs/xfs/libxfs/xfs_btree.c    |   10 +++++-----
>  fs/xfs/libxfs/xfs_ialloc.c   |    4 ++--
>  fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
>  fs/xfs/xfs_buf.c             |   24 ++++++++++++------------
>  fs/xfs/xfs_buf.h             |   14 +++++++-------
>  fs/xfs/xfs_buf_item.c        |    4 ++--
>  fs/xfs/xfs_fsops.c           |    2 +-
>  fs/xfs/xfs_log_recover.c     |    8 ++++----
>  fs/xfs/xfs_rtalloc.c         |   20 ++++++++++----------
>  fs/xfs/xfs_rtalloc.h         |    4 ++--
>  fs/xfs/xfs_symlink.c         |    4 ++--
>  fs/xfs/xfs_trans.c           |    2 +-
>  fs/xfs/xfs_trans_buf.c       |   16 ++++++++--------
>  15 files changed, 78 insertions(+), 78 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
