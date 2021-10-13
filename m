Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37895C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 07:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BB546103C
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 07:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbhJMHae (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 03:30:34 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47810 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238446AbhJMHae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 03:30:34 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id ADF8710552EB;
        Wed, 13 Oct 2021 18:28:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maYgg-005gi0-5q; Wed, 13 Oct 2021 18:28:30 +1100
Date:   Wed, 13 Oct 2021 18:28:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 13/15] xfs: widen btree maxlevels computation to handle
 64-bit record counts
Message-ID: <20211013072830.GF2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408162537.4151249.5138465633448556647.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408162537.4151249.5138465633448556647.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61668a9e
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=2siaQ3fK4hl32L4kpwMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:33:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rework xfs_btree_compute_maxlevels to handle larger record counts, since
> we're about to add support for very large data forks.  Eventually the
> realtime reverse mapping btree will need this too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   16 ++++++++--------
>  fs/xfs/libxfs/xfs_btree.h |    3 ++-
>  2 files changed, 10 insertions(+), 9 deletions(-)

Looks good. howmany_64() uses do_div() properly so there shouldn't
be any issues with this on 32 bit platforms.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
