Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEDCC43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 01:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348930AbiFFBUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 21:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348898AbiFFBUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 21:20:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B9ED4C786
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 18:20:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D3F535EC9D3;
        Mon,  6 Jun 2022 11:20:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ny1Pk-003BYe-Lh; Mon, 06 Jun 2022 11:20:16 +1000
Date:   Mon, 6 Jun 2022 11:20:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
Message-ID: <20220606012016.GO1098723@dread.disaster.area>
References: <YpzbX/5sgRIcN2LC@magnolia>
 <20220605222940.GL1098723@dread.disaster.area>
 <Yp1EGf+d/rzCgvJ4@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp1EGf+d/rzCgvJ4@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=629d5653
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=E48u2gFMcETMmvs15YQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 05, 2022 at 05:02:33PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 06, 2022 at 08:29:40AM +1000, Dave Chinner wrote:
> > On Sun, Jun 05, 2022 at 09:35:43AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > It is vitally important that we preserve the state of the NREXT64 inode
> > > flag when we're changing the other flags2 fields.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_ioctl.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Fixes tag?
> 
> Does this really need one?  NREXT64 is still experimental, none of this
> code is in any released kernel,

In my opinion, absolutely not.

But after just spending a large part of the last cycle fielding
unjustified complaint after complaint that we didn't get everything
exactly perfect for every possible unforseen future uses for commit
messages and cover letters....

> and I'm not even sure what would be a
> good target -- the patch that introduced XFS_DIFLAG_NREXT64?

9b7d16e34bbe xfs: Introduce XFS_DIFLAG2_NREXT64 and associated helpers

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
