Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47034C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 22:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355274AbiCXWPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 18:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiCXWPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 18:15:42 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6671A1441
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 15:14:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B3432533F74;
        Fri, 25 Mar 2022 09:14:08 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXViY-009TBO-PJ; Fri, 25 Mar 2022 09:14:06 +1100
Date:   Fri, 25 Mar 2022 09:14:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220324221406.GL1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321051750.400056-16-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623ced31
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=gZcPHtI0QFPIeBUmpnEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 10:47:46AM +0530, Chandan Babu R wrote:
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in length and each block
> is 1KB in size.
> 
> With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> 1KB sized blocks, a file can reach upto,
> (2^31) * 1KB = 2TB
> 
> This is much larger than the theoretical maximum size of a directory
> i.e. 32GB * 3 = 96GB.
> 
> Since a directory's inode can never overflow its data fork extent counter,
> this commit replaces checking the return value of
> xfs_iext_count_may_overflow() with calls to ASSERT(error == 0).

I'd really prefer that we don't add noise like this to a bunch of
call sites.  If directories can't overflow the extent count in
normal operation, then why are we even calling
xfs_iext_count_may_overflow() in these paths? i.e. an overflow would
be a sign of an inode corruption, and we should have flagged that
long before we do an operation that might overflow the extent count.

So, really, I think you should document the directory size
constraints at the site where we define all the large extent count
values in xfs_format.h, remove the xfs_iext_count_may_overflow()
checks from the directory code and replace them with a simple inode
verifier check that we haven't got more than 100GB worth of
individual extents in the data fork for directory inodes....

Then all this directory specific "can't possibly overflow" overflow
checks can go away completely.  The best code is no code :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
