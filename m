Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6007BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 02:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 497FD61100
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 02:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhHSCna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:43:30 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:59414 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235679AbhHSCna (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 22:43:30 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9148C11444A5;
        Thu, 19 Aug 2021 12:42:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGY12-002M38-OL; Thu, 19 Aug 2021 12:42:48 +1000
Date:   Thu, 19 Aug 2021 12:42:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/15] xfs: standardize daddr formatting in ftrace output
Message-ID: <20210819024248.GW3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924376504.761813.17237311452402341703.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924376504.761813.17237311452402341703.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=kdPJ-Cpjg9NoGd9RkLIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Always print disk addr (i.e. 512 byte block) numbers in hexadecimal and
> preceded with the unit "daddr".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_trace.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
