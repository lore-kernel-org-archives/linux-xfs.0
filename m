Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0046C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC68761100
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhHSDMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:12:37 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45279 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhHSDMh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 23:12:37 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 849D680B406;
        Thu, 19 Aug 2021 13:12:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGYTH-002MWj-GZ; Thu, 19 Aug 2021 13:11:59 +1000
Date:   Thu, 19 Aug 2021 13:11:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/15] xfs: disambiguate units for ftrace fields tagged
 "count"
Message-ID: <20210819031159.GA3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378705.761813.11309968953103960937.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924378705.761813.11309968953103960937.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=t6patY7d_hTwElMODpUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:43:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Some of our tracepoints have a field known as "count".  That name
> doesn't describe any units, which makes the fields not very useful.
> Rename the fields to capture units and ensure the format is hexadecimal
> when we're referring to blocks, extents, or IO operations.
> 
> "blockcount" are in units of fs blocks
> "bytecount" are in units of bytes
> "icount" are in units of inode records

This is where fsbcount and bbcount really look like a reasonable way
of encoding the unit into the description... :)

Also, having noted in the previous patch that the icreate record
trace point has a count of inodes as "count", perhaps this icount
would be better as "ireccount" so that icount can be used as a count
of inodes...

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_trace.h |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 7ae654f7ae82..07da753588d5 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
> -		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
> +		  "fileoff 0x%llx startblock 0x%llx blockcount 0x%llx flag %d caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
> @@ -806,7 +806,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
>  		__entry->pincount = atomic_read(&ip->i_pincount);
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
> +	TP_printk("dev %d:%d ino 0x%llx icount %d pincount %d caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->count,

I don't think this is correct. This count is the current active
reference count of the inode, not a count of inode records...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
