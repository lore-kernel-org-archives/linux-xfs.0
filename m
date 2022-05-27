Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29977C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiE0B04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiE0B0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:26:55 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9B6313CEC
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:26:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2EA8F534533;
        Fri, 27 May 2022 11:26:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOkc-00Gq76-L1; Fri, 27 May 2022 11:26:50 +1000
Date:   Fri, 27 May 2022 11:26:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/5] xfs: implement per-mount warnings for scrub and
 shrink usage
Message-ID: <20220527012650.GP1098723@dread.disaster.area>
References: <165337058023.994444.12794741176651030531.stgit@magnolia>
 <165337059142.994444.15610566270833642160.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337059142.994444.15610566270833642160.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=629028dc
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=pmcgEBzOUx-m1b5ptJEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:36:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, we don't have a consistent story around logging when an
> EXPERIMENTAL feature gets turned on at runtime -- online fsck and shrink
> log a message once per day across all mounts, and the recently merged
> LARP mode only ever does it once per insmod cycle or reboot.
> 
> Because EXPERIMENTAL tags are supposed to go away eventually, convert
> the existing daily warnings into state flags that travel with the mount,
> and warn once per mount.  Making this an opstate flag means that we'll
> be able to capture the experimental usage in the ftrace output too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/scrub.c |   17 ++---------------
>  fs/xfs/xfs_fsops.c   |    7 +------
>  fs/xfs/xfs_message.h |    6 ++++++
>  fs/xfs/xfs_mount.h   |   15 ++++++++++++++-
>  4 files changed, 23 insertions(+), 22 deletions(-)

nice - I like the xfs_warn_mount() wrapper.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
