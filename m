Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F69C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 05:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhLPFFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 00:05:40 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43595 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhLPFFj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 00:05:39 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 132638A51E5;
        Thu, 16 Dec 2021 16:05:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxixV-003df3-Hc; Thu, 16 Dec 2021 16:05:37 +1100
Date:   Thu, 16 Dec 2021 16:05:37 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix a bug in the online fsck directory leaf1
 bestcount check
Message-ID: <20211216050537.GA449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697197.3129691.1911552605195534271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961697197.3129691.1911552605195534271.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61bac922
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=AZK8MRsvVoKhbS40:21 a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=YEyCIqqpebTs7pEFxUMA:9 a=CjuIK1q_8ugA:10
        a=wYxC10UHL_r354hrDE_9:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 15, 2021 at 05:09:32PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When xfs_scrub encounters a directory with a leaf1 block, it tries to
> validate that the leaf1 block's bestcount (aka the best free count of
> each directory data block) is the correct size.  Previously, this author
> believed that comparing bestcount to the directory isize (since
> directory data blocks are under isize, and leaf/bestfree blocks are
> above it) was sufficient.
> 
> Unfortunately during testing of online repair, it was discovered that it
> is possible to create a directory with a hole between the last directory
> block and isize.

We have xfs_da3_swap_lastblock() that can leave an -empty- da block
between the last referenced block and isize, but that's not a "hole"
in the file. If you don't mean xfs_da3_swap_lastblock(), then can
you clarify what you mean by a "hole" here and explain to me how the
situation it occurs in comes about? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
