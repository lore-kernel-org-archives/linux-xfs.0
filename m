Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A823C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 00:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350CF60232
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 00:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbhJMA7m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 20:59:42 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:46105 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236401AbhJMA6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 20:58:55 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 76D8E106151;
        Wed, 13 Oct 2021 11:56:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maSZd-005aDN-0X; Wed, 13 Oct 2021 11:56:49 +1100
Date:   Wed, 13 Oct 2021 11:56:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/15] xfs: remove xfs_btree_cur.bc_blocklog
Message-ID: <20211013005649.GS2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408155929.4151249.7734053676233395860.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408155929.4151249.7734053676233395860.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61662ed3
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=egd6BpzjMmoG2WSNl1oA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:32:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This field isn't used by anyone, so get rid of it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |    1 -
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    1 -
>  fs/xfs/libxfs/xfs_btree.h          |    1 -
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 --
>  fs/xfs/libxfs/xfs_refcount_btree.c |    1 -
>  fs/xfs/libxfs/xfs_rmap_btree.c     |    1 -
>  6 files changed, 7 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
