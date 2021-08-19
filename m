Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0129C4320E
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95CA460240
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236206AbhHSDUj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:20:39 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:46882 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236054AbhHSDUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 23:20:38 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 22EEF101302;
        Thu, 19 Aug 2021 13:20:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGYb1-002Mcp-8j; Thu, 19 Aug 2021 13:19:59 +1000
Date:   Thu, 19 Aug 2021 13:19:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: standardize inode generation formatting in
 ftrace output
Message-ID: <20210819031959.GE3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924380913.761813.13285817199891223797.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924380913.761813.13285817199891223797.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=G9-ACEaBXAYKuGx82t8A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print inode generation in hexadecimal and preceded with the unit
> "gen".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.h |    2 +-
>  fs/xfs/xfs_trace.h   |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

simple one :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
