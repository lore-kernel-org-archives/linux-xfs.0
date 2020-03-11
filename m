Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3A5C10F27
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A094208C4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 05:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbgCKFzX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 01:55:23 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37504 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbgCKFzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 01:55:23 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 674917EA08E;
        Wed, 11 Mar 2020 16:55:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jBuKt-0007NY-C1; Wed, 11 Mar 2020 16:55:19 +1100
Date:   Wed, 11 Mar 2020 16:55:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: scrub should mark dir corrupt if entry points
 to unallocated inode
Message-ID: <20200311055519.GD10776@dread.disaster.area>
References: <158388768123.939608.12366470947594416375.stgit@magnolia>
 <158388770010.939608.11408184090778445318.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158388770010.939608.11408184090778445318.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=HjFt0EeTI3zggXWsLM0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 10, 2020 at 05:48:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_dir_check_ftype, we should mark the directory corrupt if we try
> to _iget a directory entry's inode pointer and the inode btree says the
> inode is not allocated.  This involves changing the IGET call to force
> the inobt lookup to return EINVAL if the inode isn't allocated; and
> rearranging the code so that we always perform the iget.
> 
> We can also remove the !hasftype code from the function, because any
> DT_ flags we encounter on those filesystems were synthesized in core,
> not read in from disk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/dir.c |   39 ++++++++++++++++++++++-----------------
>  1 file changed, 22 insertions(+), 17 deletions(-)

That's much neater.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
