Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA49C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E4A60F70
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhHEFkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:40:52 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33976 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhHEFkw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:40:52 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BC89F80BBE2;
        Thu,  5 Aug 2021 15:40:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBW7Q-00Egfy-8n; Thu, 05 Aug 2021 15:40:36 +1000
Date:   Thu, 5 Aug 2021 15:40:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 11/14] xfs: don't run speculative preallocation gc when
 fs is frozen
Message-ID: <20210805054036.GB2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812924340.2589546.13912967141285396653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812924340.2589546.13912967141285396653.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=lZ_SRZJJfig_kaGqUsYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:07:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have the infrastructure to switch background workers on and
> off at will, fix the block gc worker code so that we don't actually run
> the worker when the filesystem is frozen, same as we do for deferred
> inactivation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/common.c |    9 +++++----
>  fs/xfs/xfs_icache.c   |   27 +++++++++++++++++++++++----
>  fs/xfs/xfs_mount.c    |    1 +
>  fs/xfs/xfs_mount.h    |    8 ++++++++
>  fs/xfs/xfs_super.c    |    9 ++++++---
>  fs/xfs/xfs_trace.h    |    6 +++++-
>  6 files changed, 48 insertions(+), 12 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
