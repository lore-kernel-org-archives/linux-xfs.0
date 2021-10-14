Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1057C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EC1561053
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhJNXBB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:01:01 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:49959 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbhJNXBA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 19:01:00 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1C5E7104A8E;
        Fri, 15 Oct 2021 09:58:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9gb-006JXS-KB; Fri, 15 Oct 2021 09:58:53 +1100
Date:   Fri, 15 Oct 2021 09:58:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 13/17] xfs: clean up
 xfs_btree_{calc_size,compute_maxlevels}
Message-ID: <20211014225853.GS2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424268640.756780.16867563565459554272.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424268640.756780.16867563565459554272.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6168b62e
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=7gw-KeZbURMNs3ZGAIwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:18:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During review of the next patch, Dave remarked that he found these two
> btree geometry calculation functions lacking in documentation and that
> they performed more work than was really necessary.
> 
> These functions take the same parameters and have nearly the same logic;
> the only real difference is in the return values.  Reword the function
> comment to make it clearer what each function does, and move them to be
> adjacent to reinforce their relation.
> 
> Clean up both of them to stop opencoding the howmany functions, stop
> using the uint typedefs, and make them both support computations for
> more than 2^32 leaf records, since we're going to need all of the above
> for files with large data forks and large rmap btrees.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   67 ++++++++++++++++++++++-----------------------
>  fs/xfs/libxfs/xfs_btree.h |    6 +++-
>  2 files changed, 37 insertions(+), 36 deletions(-)

Nice! that's soooo much easier for my simple brain to understand. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
