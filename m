Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75398C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FFCC61029
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhHDLJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:09:33 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:35121 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235606AbhHDLJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 07:09:32 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id DAF321140F2E;
        Wed,  4 Aug 2021 21:09:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBElw-00EORo-LC; Wed, 04 Aug 2021 21:09:16 +1000
Date:   Wed, 4 Aug 2021 21:09:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, alternative v2] xfs: per-cpu deferred inode inactivation
 queues
Message-ID: <20210804110916.GM2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032030.GT3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AGRJVN0mAXMDKxER9ZQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 03, 2021 at 08:20:30PM -0700, Darrick J. Wong wrote:
> For everyone else following along at home, I've posted the current draft
> version of this whole thing in:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.15

Overall looks good - fixes to freeze problems I hit are found
in other replies to this.

I omitted the commits:

xfs: queue inodegc worker immediately when memory is tight
xfs: throttle inode inactivation queuing on memory reclaim

in my test kernel because I think they are unnecessary.

I think the first is unnecessary because reclaim of inodes from the
VFS is usually in large batches and so early triggers aren't
desirable when we're getting thousands of inodes being evicted by
the superblock shrinker at a time. If we've only got a handful of
inodes queued, then inactivating them early isn't going to make much
of an impact on free memory. I could be wrong, but so far I have no
evidence that expediting inactivation is necessary.

The second patch is the custom shrinker. Again, I just don't think
this is necessary because if there is any amount of inactivation of
evicted inodes needed due to reclaim, we'll already be triggering it
to run via the deferred queue flush thresholds. Hence we don't
really need any mechanism to tell us that there is memory pressure;
the deferred work reacts to eviction from reclaim in exactly the
same way it reacts to eviction from unlink....

I've been running the patchset without these two patches on my 512MB
test VM, and the only OOM kill I get from fstests is g/531. This is
the "many open-but-unlinked" test, which creates 50,000 open
unlinked files per CPU. So for this test VM which has 4 CPUs, that's
200,000 open, dirty iunlinked inodes and a lot of pinned inode
cluster buffers. At ~2kB of memory per unlinked inode (ignoring the
cluster buffers) this would consume about 400MB of the 512MB of RAM
the VM has. It OOM kills the test programs that hold the open files
long before it gets to 200,000 files, so this test never passed
before this patchset on this machine...

I have a couple of extra patches to set up per-cpu hotplug
infrastructure before the deferred inode inactivation patch - I'll
post them after I finish this email. I'm going to leave it running
tests overnight.

Darrick, I'm pretty happy with the way the patchset is behaving now.
If you want to fold in the bug fixes I've posted and add in
the hotplug patches, then I think it's ready to be posted in full
again (if it all passes your testing) for review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
