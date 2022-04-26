Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BE3C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 04:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241366AbiDZEhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiDZEhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 00:37:15 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CA1B67D0D
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 21:34:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3761810E5E01;
        Tue, 26 Apr 2022 14:34:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njCtr-004cjM-46; Tue, 26 Apr 2022 14:34:07 +1000
Date:   Tue, 26 Apr 2022 14:34:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "djwong@kernel.org" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: revert "xfs: actually bump warning counts when we
 send warnings"
Message-ID: <20220426043407.GO1544202@dread.disaster.area>
References: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
 <F4048726-FCF6-4E66-8233-4F9C0D20E15D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F4048726-FCF6-4E66-8233-4F9C0D20E15D@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62677641
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=IkcTkHD0fZMA:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=7_1_D8hfdyh2uTFUFSEA:9 a=QEXdDO2ut3YA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 04:25:54AM +0000, Catherine Hoang wrote:
> > On Apr 25, 2022, at 6:33 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > 
> > This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.
> > 
> > XFS quota has had the concept of a "quota warning limit" since
> > the earliest Irix implementation, but a mechanism for incrementing
> > the warning counter was never implemented, as documented in the
> > xfs_quota(8) man page. We do know from the historical archive that
> > it was never incremented at runtime during quota reservation
> > operations.
> > 
> > With this commit, the warning counter quickly increments for every
> > allocation attempt after the user has crossed a quote soft
> > limit threshold, and this in turn transitions the user to hard
> > quota failures, rendering soft quota thresholds and timers useless.
> > This was reported as a regression by users.
> > 
> > Because the intended behavior of this warning counter has never been
> > understood or documented, and the result of this change is a regression
> > in soft quota functionality, revert this commit to make soft quota
> > limits and timers operable again.
> > 
> > Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> This looks fine to me. I’m also happy to work on removing the rest of the
> quota warning infrastructure.
> 
> Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>

Thanks, Catherine!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
