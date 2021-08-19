Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9E7C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 872BF61058
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhHSDZj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:25:39 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:35560 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235999AbhHSDZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 23:25:38 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6B5D684CCD;
        Thu, 19 Aug 2021 13:25:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGYfq-002Mgf-S9; Thu, 19 Aug 2021 13:24:58 +1000
Date:   Thu, 19 Aug 2021 13:24:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/15] xfs: start documenting common units and tags used
 in tracepoints
Message-ID: <20210819032458.GG3657114@dread.disaster.area>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <20210819030728.GN12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819030728.GN12640@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=msAVn9ySAAWg-8JqLQwA:9 a=lzOH6EJu9vI5SHi-:21
        a=ZN9JvjVBrfj9LNvM:21 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 08:07:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Because there are a lot of tracepoints that express numeric data with
> an associated unit and tag, document what they are to help everyone else
> keep these thigns straight.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Thanks for adding this quickly. :)

> ---
>  fs/xfs/scrub/trace.h |    4 ++++
>  fs/xfs/xfs_trace.h   |   24 ++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> index e9b81b7645c1..20f34548bfe5 100644
> --- a/fs/xfs/scrub/trace.h
> +++ b/fs/xfs/scrub/trace.h
> @@ -2,6 +2,10 @@
>  /*
>   * Copyright (C) 2017 Oracle.  All Rights Reserved.
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + *
> + * NOTE: none of these tracepoints shall be considered a stable kernel ABI
> + * as they can change at any time.  See xfs_trace.h for documentation of
> + * specific units found in tracepoint output.
>   */
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM xfs_scrub
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a72cd56afc8c..c46dd4fea3e3 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2,6 +2,30 @@
>  /*
>   * Copyright (c) 2009, Christoph Hellwig
>   * All Rights Reserved.
> + *
> + * NOTE: none of these tracepoints shall be considered a stable kernel ABI
> + * as they can change at any time.
> + *
> + * Current conventions for printing numbers measuring specific units:
> + *
> + * ino: filesystem inode number
> + * agino: per-AG inode number
> + * agno: allocation group number
> + * agbno: per-AG block number in fs blocks
> + * owner: reverse-mapping owner, usually inodes
> + * daddr: physical block number in 512b blocks
> + * startblock: physical block number for file mappings.  This is either a
> + *             segmented fsblock for data device mappings, or a rfsblock
> + *             for realtime device mappings
> + * fileoff: file offset, in fs blocks
> + * pos: file offset, in bytes
> + * forkoff: inode fork offset, in bytes
> + * icount: number of inode records

ireccount?

> + * disize: ondisk file size, in bytes
> + * isize: incore file size, in bytes
> + * fsbcount: number of blocks in an extent, in fs blocks
> + * bbcount: number of blocks in a physical extent, in 512b blocks
> + * bytecount: number of bytes
>   */
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM xfs

Only thing I'd add to this comment is that hexadecimal is the
preferred output format for all these types.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
