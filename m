Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839D0C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44100619D3
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 01:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhCaBe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 21:34:57 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:52177 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhCaBe1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 21:34:27 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 4B89E1AEB7C;
        Wed, 31 Mar 2021 12:34:26 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lRPkW-008gnv-RB; Wed, 31 Mar 2021 12:34:24 +1100
Date:   Wed, 31 Mar 2021 12:34:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210331013424.GY63242@dread.disaster.area>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671807853.621936.16639622639548774275.stgit@magnolia>
 <20210330004407.GS63242@dread.disaster.area>
 <20210330023656.GK4090233@magnolia>
 <20210330030747.GT63242@dread.disaster.area>
 <20210330040625.GL4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330040625.GL4090233@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=a51jOMAV4lIpu_XfxwcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 09:06:25PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 30, 2021 at 02:07:47PM +1100, Dave Chinner wrote:
> > Next, igrab() takes a reference to the inode which will mark them
> > referenced. THis walk grabs every inode in the filesysetm cache,
> > so marks them all referenced and makes it harder to reclaim them
> > under memory pressure. This perturbs working set behaviour.
> > 
> > inode list walks and igrab/iput don't come for free - they perturb
> > the working set, LRU orders, cause lock contention, long tail
> > latencies, etc. The XFS inode cache walk might not be the prettiest
> > thing, but it doesn't have any of these nasty side effects.
> > 
> > So, in general, I don't think we should be adding new inode list
> > walks anywhere, not even deep in XFS where nobody else might care...
> 
> ...but the current quotaoff behavior has /all/ of these problems too.

Yup, ISTR in the past it didn't even take inode references, but I
may be misremembering...

> I think you and I hashed out on IRC that quotaoff could simply take the
> ILOCK and the i_flags lock of every inode that isn't INEW, RECLAIMING,
> or INACTIVATING; drop the dquots, and drop the locks, and then dqpurge
> would only have to wait for the inodes that are actively being reclaimed
> or inactivated.

I'm pretty sure that we only need to avoid INEW and IRECLAIM.
Anything else that has dquots attached needs to be locked and have
them removed. Those that are marked INEW will not have dquots
attached, and those marked IRECLAIM are in the process of being torn
down so their dquots will be released in short order.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
