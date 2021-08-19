Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AC4C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 02:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED33610A5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 02:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhHSCwI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 22:52:08 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:42749 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235933AbhHSCv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 22:51:57 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id C261C104BB6;
        Thu, 19 Aug 2021 12:51:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGY9F-002M9Y-0j; Thu, 19 Aug 2021 12:51:17 +1000
Date:   Thu, 19 Aug 2021 12:51:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: disambiguate units for ftrace fields tagged
 "offset"
Message-ID: <20210819025117.GY3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924377603.761813.4113528501236797725.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924377603.761813.4113528501236797725.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=8DgYw9koJ10MkES7mKYA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:42:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints describe fields as "offset".  That name doesn't
> describe any units, which makes the fields not very useful.  Rename the
> fields to capture units and ensure the format is hexadecimal.
> 
> "fileoff" means file offset, in units of fs blocks
> "pos" means file offset, in bytes
> "forkoff" means inode fork offset, in bytes
> 
> The one remaining "offset" value is for iclogs, since that's the byte
> offset of the end of where we've written into the current iclog.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/trace.h |    6 +++---
>  fs/xfs/xfs_trace.h   |   29 ++++++++++++++---------------
>  2 files changed, 17 insertions(+), 18 deletions(-)

....

> @@ -2145,7 +2145,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
>  		__entry->fork_off = XFS_IFORK_BOFF(ip);
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx (%s), %s format, num_extents %d, "
> -		  "broot size %d, fork offset %d",
> +		  "broot size %d, forkoff %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_symbolic(__entry->which, XFS_SWAPEXT_INODES),

Format should be 0x%x?

Otherwise looks fine. With that fixed,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
