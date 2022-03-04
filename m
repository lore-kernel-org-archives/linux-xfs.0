Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6632FC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 01:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiCDBbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiCDBbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 20:31:21 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B7A24616E
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 17:30:35 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 50FBB52FB09;
        Fri,  4 Mar 2022 12:30:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPwm9-001Es4-O6; Fri, 04 Mar 2022 12:30:33 +1100
Date:   Fri, 4 Mar 2022 12:30:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 03/17] xfs: Use xfs_extnum_t instead of basic data
 types
Message-ID: <20220304013033.GA59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-4-chandan.babu@oracle.com>
 <20220304005934.GY59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304005934.GY59715@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62216bba
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=bnPPVKLS_TRw6zqaRnMA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 04, 2022 at 11:59:34AM +1100, Dave Chinner wrote:
> On Tue, Mar 01, 2022 at 04:09:24PM +0530, Chandan Babu R wrote:
> > xfs_extnum_t is the type to use to declare variables which have values
> > obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
> > types (e.g. uint32_t) with xfs_extnum_t for such variables.
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c       | 2 +-
> >  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
> >  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
> >  fs/xfs/scrub/inode.c           | 2 +-
> >  fs/xfs/xfs_trace.h             | 2 +-
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> Nice little cleanup.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Something to think about for a followup - how do we ensure we catch
> this sort type mismatch in future as it could end up with overflow
> bugs?

Ah, never mind, later patches in the series look to address this...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
