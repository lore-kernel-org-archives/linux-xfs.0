Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED65C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0876460F42
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhHEFpP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:45:15 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:59944 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235109AbhHEFpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:45:15 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id DE6EB840C8;
        Thu,  5 Aug 2021 15:44:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBWBf-00Egj5-Bx; Thu, 05 Aug 2021 15:44:59 +1000
Date:   Thu, 5 Aug 2021 15:44:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 14/14] xfs: throttle inode inactivation queuing on memory
 reclaim
Message-ID: <20210805054459.GD2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812925986.2589546.10269888087074473602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812925986.2589546.10269888087074473602.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=5T0nl2nWFVmoE2AfW4IA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:07:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we defer inode inactivation, we've decoupled the process of
> unlinking or closing an inode from the process of inactivating it.  In
> theory this should lead to better throughput since we now inactivate the
> queued inodes in batches instead of one at a time.
> 
> Unfortunately, one of the primary risks with this decoupling is the loss
> of rate control feedback between the frontend and background threads.
> In other words, a rm -rf /* thread can run the system out of memory if
> it can queue inodes for inactivation and jump to a new CPU faster than
> the background threads can actually clear the deferred work.  The
> workers can get scheduled off the CPU if they have to do IO, etc.
> 
> To solve this problem, we configure a shrinker so that it will activate
> the /second/ time the shrinkers are called.  The custom shrinker will
> queue all percpu deferred inactivation workers immediately and set a
> flag to force frontend callers who are releasing a vfs inode to wait for
> the inactivation workers.
> 
> On my test VM with 560M of RAM and a 2TB filesystem, this seems to solve
> most of the OOMing problem when deleting 10 million inodes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_icache.h |    1 +
>  fs/xfs/xfs_mount.c  |    9 ++++-
>  fs/xfs/xfs_mount.h  |    3 ++
>  fs/xfs/xfs_trace.h  |   37 ++++++++++++++++++-
>  5 files changed, 147 insertions(+), 5 deletions(-)

I'm still not really convinced this is the right way to go here, but
it doesn't hurt much so lets run with it for now. When I rework the
inode reclaim shrinker hooks I'll revisit this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
