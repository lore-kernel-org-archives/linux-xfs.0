Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00B3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A718C6109E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhJNXNn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:13:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:40527 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhJNXNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 19:13:42 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id F30E95E9C28;
        Fri, 15 Oct 2021 10:11:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9st-006Jgq-D7; Fri, 15 Oct 2021 10:11:35 +1100
Date:   Fri, 15 Oct 2021 10:11:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 17/17] xfs: use separate btree cursor cache for each
 btree type
Message-ID: <20211014231135.GV2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424270836.756780.5038212434647220692.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424270836.756780.5038212434647220692.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6168b928
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=JO-3xcBYrZfX1u__6vEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:18:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have the infrastructure to track the max possible height of
> each btree type, we can create a separate slab cache for cursors of each
> type of btree.  For smaller indices like the free space btrees, this
> means that we can pack more cursors into a slab page, improving slab
> utilization.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   23 +++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.h    |    3 ++
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   23 +++++++++++++++++
>  fs/xfs/libxfs/xfs_bmap_btree.h     |    3 ++
>  fs/xfs/libxfs/xfs_btree.c          |   48 ++++++++++++++++++++++++++++++++----
>  fs/xfs/libxfs/xfs_btree.h          |   20 ++++++---------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   23 +++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 ++
>  fs/xfs/libxfs/xfs_refcount_btree.c |   23 +++++++++++++++++
>  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   23 +++++++++++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++
>  fs/xfs/xfs_super.c                 |   13 +++++-----
>  13 files changed, 182 insertions(+), 29 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
