Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AEFCC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 01:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiE0BZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 21:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiE0BZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 21:25:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E016517EE
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 18:25:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6AE0A53458A;
        Fri, 27 May 2022 11:25:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nuOjV-00Gq6D-7r; Fri, 27 May 2022 11:25:41 +1000
Date:   Fri, 27 May 2022 11:25:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: don't leak xfs_buf_cancel structures when
 recovery fails
Message-ID: <20220527012541.GM1098723@dread.disaster.area>
References: <165337054460.992964.11039203493792530929.stgit@magnolia>
 <165337055599.992964.776146682315663613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165337055599.992964.776146682315663613.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62902897
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=cSTiXQOnDD01wV3SOUAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 10:35:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If log recovery fails, we free the memory used by the buffer
> cancellation buckets, but we don't actually traverse each bucket list to
> free the individual xfs_buf_cancel objects.  This leads to a memory
> leak, as reported by kmemleak in xfs/051:
> 
> unreferenced object 0xffff888103629560 (size 32):
>   comm "mount", pid 687045, jiffies 4296935916 (age 10.752s)
>   hex dump (first 32 bytes):
>     08 d3 0a 01 00 00 00 00 08 00 00 00 01 00 00 00  ................
>     d0 f5 0b 92 81 88 ff ff 80 64 64 25 81 88 ff ff  .........dd%....
>   backtrace:
>     [<ffffffffa0317c83>] kmem_alloc+0x73/0x140 [xfs]
>     [<ffffffffa03234a9>] xlog_recover_buf_commit_pass1+0x139/0x200 [xfs]
>     [<ffffffffa032dc27>] xlog_recover_commit_trans+0x307/0x350 [xfs]
>     [<ffffffffa032df15>] xlog_recovery_process_trans+0xa5/0xe0 [xfs]
>     [<ffffffffa032e12d>] xlog_recover_process_data+0x8d/0x140 [xfs]
>     [<ffffffffa032e49d>] xlog_do_recovery_pass+0x19d/0x740 [xfs]
>     [<ffffffffa032f22d>] xlog_do_log_recovery+0x6d/0x150 [xfs]
>     [<ffffffffa032f343>] xlog_do_recover+0x33/0x1d0 [xfs]
>     [<ffffffffa032faba>] xlog_recover+0xda/0x190 [xfs]
>     [<ffffffffa03194bc>] xfs_log_mount+0x14c/0x360 [xfs]
>     [<ffffffffa030bfed>] xfs_mountfs+0x50d/0xa60 [xfs]
>     [<ffffffffa03124b5>] xfs_fs_fill_super+0x6a5/0x950 [xfs]
>     [<ffffffff812b92a5>] get_tree_bdev+0x175/0x280
>     [<ffffffff812b7c3a>] vfs_get_tree+0x1a/0x80
>     [<ffffffff812e366f>] path_mount+0x6ff/0xaa0
>     [<ffffffff812e3b13>] __x64_sys_mount+0x103/0x140
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf_item_recover.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
