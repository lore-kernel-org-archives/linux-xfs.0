Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAE2C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 22:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiEVW7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 18:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiEVW7P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 18:59:15 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C97BD38DA9
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:59:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D72175343E8;
        Mon, 23 May 2022 08:59:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nsuXX-00FDBm-MC; Mon, 23 May 2022 08:59:11 +1000
Date:   Mon, 23 May 2022 08:59:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCHSET 0/4] xfs: last bit of LARP and other fixes for 5.19
Message-ID: <20220522225911.GO1098723@dread.disaster.area>
References: <165323326679.78754.13346434666230687214.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165323326679.78754.13346434666230687214.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628ac041
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RCtCFUqAr45KAwEy:21 a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=gBqoSrqh0VYa57t7MbgA:9 a=CjuIK1q_8ugA:10 a=uzSg_WU2rPbMLo8b3zFZ:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 22, 2022 at 08:27:46AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here's one last round of fixes for UAF bugs and memory leaks that I
> found while testing the logged xattr code.  The first patch is a bug for
> a memory leak in quotacheck that has been popping up here and there for
> the last 10 years, and the rest are previously seen patches rebased
> against where I /think/ Dave's current internal testing tree is right
> now, based on his request on IRC Friday night.

The merge window has opened now, so I'm going to pull the critical
LARP bug fixes out of this (patch 2 and 3) because they are the ones
I've been waiting on to publish for-next before an initial pull
request.  I'll plan the rest for 2nd late merge window pull request
once we've got the main bulk merged later this week.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
