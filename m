Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03795C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 05:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D652D6124B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 05:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhHXFF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 01:05:26 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38614 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230121AbhHXFF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 01:05:26 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CC8F284CC6;
        Tue, 24 Aug 2021 15:04:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mIOc0-004IDI-S3; Tue, 24 Aug 2021 15:04:36 +1000
Date:   Tue, 24 Aug 2021 15:04:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix I_DONTCACHE
Message-ID: <20210824050436.GL3657114@dread.disaster.area>
References: <20210824023208.392670-1-david@fromorbit.com>
 <20210824025841.GE12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824025841.GE12640@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=t7ZWxMCmQC_MaV9UvIsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 07:58:41PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 24, 2021 at 12:32:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Yup, the VFS hoist broke it, and nobody noticed. Bulkstat workloads
> > make it clear that it doesn't work as it should.
> 
> Is there an easy way to test the dontcache behavior so that we don't
> screw this up again?
> 
> /me's brain is fried, will study this in more detail in the morning.

Perhaps. We can measure how many xfs inodes are cached via the
filesystem stats e.g.

$ pminfo -t xfs.vnodes.active
xfs.vnodes.active [number of vnodes not on free lists]
$ sudo grep xfs_inode /proc/slabinfo | awk '{ print $2 }'
243440
$ pminfo -f xfs.vnodes.active

xfs.vnodes.active
    value 243166
$

And so we should be able to run a bulkstat from fstests on a
filesystem with a known amount of files in it and measure the number
of cached inodes before/after...

I noticed this because I recently re-added the threaded per-ag
bulkstat scan to my scalability workload (via the xfs_io bulkstat
command) after I dropped it ages ago because per-ag threading of
fstests::src/bulkstat.c was really messy. It appears nobody has
been paying attention to bulkstat memory usage (and therefore
I_DONTCACHE behaviour) for some time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
