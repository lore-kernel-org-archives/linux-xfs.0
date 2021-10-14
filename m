Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E9FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075806109E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhJNXKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:10:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41408 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233989AbhJNXKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 19:10:50 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7C1491056DE7;
        Fri, 15 Oct 2021 10:08:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9q6-006Jej-PD; Fri, 15 Oct 2021 10:08:42 +1100
Date:   Fri, 15 Oct 2021 10:08:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 16/17] xfs: compute absolute maximum nlevels for each
 btree type
Message-ID: <20211014230842.GU2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424270288.756780.11162456027952341571.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424270288.756780.11162456027952341571.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6168b87c
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=lvtgKEt0WkOydU8es00A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:18:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add code for all five btree types so that we can compute the absolute
> maximum possible btree height for each btree type.  This is a setup for
> the next patch, which makes every btree type have its own cursor cache.
> 
> The functions are exported so that we can have xfs_db report the
> absolute maximum btree heights for each btree type, rather than making
> everyone run their own ad-hoc computations.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |    1 +
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   33 ++++++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc_btree.h    |    2 +
>  fs/xfs/libxfs/xfs_bmap.c           |    1 +
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   31 +++++++++++++++++-
>  fs/xfs/libxfs/xfs_bmap_btree.h     |    2 +
>  fs/xfs/libxfs/xfs_fs.h             |    2 +
>  fs/xfs/libxfs/xfs_ialloc.c         |    1 +
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   61 ++++++++++++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    2 +
>  fs/xfs/libxfs/xfs_refcount_btree.c |   45 ++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_refcount_btree.h |    2 +
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   43 +++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    2 +
>  14 files changed, 207 insertions(+), 21 deletions(-)

It's a little more verbose than the previous version, but the clear
explanations of how we are calculating the maximum levels is a big
improvement. Nice!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
