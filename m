Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA62DC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jul 2022 01:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGKB3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Jul 2022 21:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiGKB3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jul 2022 21:29:30 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17EBF6468
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 18:29:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BA43710E7D89;
        Mon, 11 Jul 2022 11:29:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oAiEm-00H1Y9-JN; Mon, 11 Jul 2022 11:29:24 +1000
Date:   Mon, 11 Jul 2022 11:29:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/5] xfs: use XFS_IFORK_Q to determine the presence of an
 xattr fork
Message-ID: <20220711012924.GA3861211@dread.disaster.area>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <165740693336.73293.17695549419343140476.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165740693336.73293.17695549419343140476.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62cb7cf7
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=I6emTIGmVwxcu5m8Oa8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 09, 2022 at 03:48:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Modify xfs_ifork_ptr to return a NULL pointer if the caller asks for the
> attribute fork but i_forkoff is zero.  This eliminates the ambiguity
> between i_forkoff and i_af.if_present, which should make it easier to
> understand the lifetime of attr forks.
> 
> While we're at it, remove the if_present checks around calls to
> xfs_idestroy_fork and xfs_ifork_zap_attr since they can both handle attr
> forks that have already been torn down.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |    2 --
>  fs/xfs/libxfs/xfs_attr.h       |    2 +-
>  fs/xfs/libxfs/xfs_bmap.c       |    1 -
>  fs/xfs/libxfs/xfs_inode_buf.c  |    1 -
>  fs/xfs/libxfs/xfs_inode_fork.c |    7 +------
>  fs/xfs/libxfs/xfs_inode_fork.h |    1 -
>  fs/xfs/xfs_attr_inactive.c     |   11 ++++-------
>  fs/xfs/xfs_attr_list.c         |    1 -
>  fs/xfs/xfs_icache.c            |    8 +++-----
>  fs/xfs/xfs_inode.c             |    5 ++---
>  fs/xfs/xfs_inode.h             |    2 +-
>  11 files changed, 12 insertions(+), 29 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
