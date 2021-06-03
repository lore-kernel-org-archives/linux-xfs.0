Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D6DC47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE322613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 04:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbhFCEWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 00:22:53 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:35533 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhFCEWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 00:22:53 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3421F103915;
        Thu,  3 Jun 2021 14:21:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loeqx-008LqQ-Da; Thu, 03 Jun 2021 14:21:07 +1000
Date:   Thu, 3 Jun 2021 14:21:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
Message-ID: <20210603042107.GO664593@dread.disaster.area>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268996135.2724138.14276025100886638786.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162268996135.2724138.14276025100886638786.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=tBTmdxqRcqwpKLYLwYAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 08:12:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running some fuzz tests on inode metadata, I noticed that the
> filesystem health report (as provided by xfs_spaceman) failed to report
> the file corruption even when spaceman was run immediately after running
> xfs_scrub to detect the corruption.  That isn't the intended behavior;
> one ought to be able to run scrub to detect errors in the ondisk
> metadata and be able to access to those reports for some time after the
> scrub.
> 
> After running the same sequence through an instrumented kernel, I
> discovered the reason why -- scrub igets the file, scans it, marks it
> sick, and ireleases the inode.  When the VFS lets go of the incore
> inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
> inode before it moves to RECLAIM state, iget reinitializes the VFS
> state, clears the sick and checked masks, and hands back the inode.  At
> this point, the caller has the exact same incore inode, but with all the
> health state erased.
> 
> In other words, we're erasing the incore inode's health state flags when
> we've decided NOT to sever the link between the incore inode and the
> ondisk inode.  This is wrong, so we need to remove the lines that zero
> the fields from xfs_iget_cache_hit.
> 
> As a precaution, we add the same lines into xfs_reclaim_inode just after
> we sever the link between incore and ondisk inode.  Strictly speaking
> this isn't necessary because once an inode has gone through reclaim it
> must go through xfs_inode_alloc (which also zeroes the state) and
> xfs_iget is careful to check for mismatches between the inode it pulls
> out of the radix tree and the one it wants.
> 
> Fixes: 6772c1f11206 ("xfs: track metadata health status")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Though I do wonder how long such state will hang around, because
once the inode is IRECLAIMABLE and clean it is only a matter of
seconds before the background inode reclaimer will free it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
