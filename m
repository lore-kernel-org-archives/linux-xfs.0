Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4043C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5D6D610F8
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhJNWwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:52:01 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:51867 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhJNWwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 18:52:01 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 3E48C10688B3;
        Fri, 15 Oct 2021 09:49:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9Xt-006JHf-Ne; Fri, 15 Oct 2021 09:49:53 +1100
Date:   Fri, 15 Oct 2021 09:49:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/17] xfs: prepare xfs_btree_cur for dynamic cursor
 heights
Message-ID: <20211014224953.GP2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424264796.756780.1894573242070893253.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424264796.756780.1894573242070893253.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6168b412
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=YKkXqewIMkoRxihXdugA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:17:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Split out the btree level information into a separate struct and put it
> at the end of the cursor structure as a VLA.  Files with huge data forks
> (and in the future, the realtime rmap btree) will require the ability to
> support many more levels than a per-AG btree cursor, which means that
> we're going to create per-btree type cursor caches to conserve memory
> for the more common case.
> 
> Note that a subsequent patch actually introduces dynamic cursor heights.
> This one merely rearranges the structure to prepare for that.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    6 +-
>  fs/xfs/libxfs/xfs_bmap.c  |   10 +--
>  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++----------------------
>  fs/xfs/libxfs/xfs_btree.h |   33 +++++++--
>  fs/xfs/scrub/bitmap.c     |   22 +++---
>  fs/xfs/scrub/bmap.c       |    2 -
>  fs/xfs/scrub/btree.c      |   47 +++++++------
>  fs/xfs/scrub/trace.c      |    4 +
>  fs/xfs/scrub/trace.h      |   10 +--
>  fs/xfs/xfs_super.c        |    2 -
>  fs/xfs/xfs_trace.h        |    2 -
>  11 files changed, 167 insertions(+), 139 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
