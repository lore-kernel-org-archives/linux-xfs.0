Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACABBC433ED
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 22:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75D036135E
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Apr 2021 22:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhDCWVo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Apr 2021 18:21:44 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55033 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236649AbhDCWVo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Apr 2021 18:21:44 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 7FF09108018;
        Sun,  4 Apr 2021 08:21:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lSoeA-00A9Q0-Mr; Sun, 04 Apr 2021 08:21:38 +1000
Date:   Sun, 4 Apr 2021 08:21:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT
 flag
Message-ID: <20210403222138.GA63242@dread.disaster.area>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-3-david@fromorbit.com>
 <20210330180617.GR4090233@magnolia>
 <20210330214007.GU63242@dread.disaster.area>
 <20210402070237.GF1739516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402070237.GF1739516@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=ZYLdOg2D4ackx9hD3EwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 08:02:37AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 31, 2021 at 08:40:07AM +1100, Dave Chinner wrote:
> > What
> > should have been done in 6bdcf26ade88 is the XFS_IFEXTENTS format
> > fork should have become XFS_IFEXTENTS|XFS_IFEXTIREC to indicate
> > "extent format, extent tree populated", rather than eliding
> > XFS_IFEXTIREC and redefining XFS_IFEXTENTS to mean "extent tree
> > populated".  i.e. the separate flag to indicate the difference
> > between fork format and in-memory state should have been
> > retained....
> 
> I strongly disagree.  If we want to clean this up the right thing is
> to remove XFS_IFINLINE and XFS_IFBROOT entirely, and just look at the
> if_format field for the extent format.

Sounds great, but regardless of the historical argument, this bug
still needs to be fix, and removing XFS_IFINLINE/XFS_IFBROOT is far
to much for what is effectively a one liner...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
