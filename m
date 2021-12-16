Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31813C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 22:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbhLPWEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:04:11 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42068 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236184AbhLPWEI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 17:04:08 -0500
Received: from dread.disaster.area (pa49-181-243-119.pa.nsw.optusnet.com.au [49.181.243.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4AD8D8A53EC;
        Fri, 17 Dec 2021 09:04:06 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mxyr7-003v8F-3W; Fri, 17 Dec 2021 09:04:05 +1100
Date:   Fri, 17 Dec 2021 09:04:05 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix a bug in the online fsck directory leaf1
 bestcount check
Message-ID: <20211216220405.GF449541@dread.disaster.area>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697197.3129691.1911552605195534271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163961697197.3129691.1911552605195534271.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61bbb7d6
        a=BEa52nrBdFykVEm6RU8P4g==:117 a=BEa52nrBdFykVEm6RU8P4g==:17
        a=AZK8MRsvVoKhbS40:21 a=kj9zAlcOel0A:10 a=IOMw9HtfNCkA:10 a=VwQbUJbxAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=YEyCIqqpebTs7pEFxUMA:9
        a=CjuIK1q_8ugA:10 a=wYxC10UHL_r354hrDE_9:22 a=AjGcO6oz07-iQ99wixmX:22
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
> block and isize.  The directory code seems to handle this situation just
> fine and xfs_repair doesn't complain, which effectively makes this quirk
> part of the disk format.
> 
> Fix the check to work properly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

With the "we're not sure how this happens" discussion out of the
way, the change to handle the empty space between the last block and
isize looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
