Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13811C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 23:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiFWXJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 19:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiFWXJu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 19:09:50 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F17E14F9D7
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 16:09:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 263415ECE79;
        Fri, 24 Jun 2022 09:09:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4VxL-00AH6F-7U; Fri, 24 Jun 2022 09:09:47 +1000
Date:   Fri, 24 Jun 2022 09:09:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 1/2] xfs: always free xattri_leaf_bp when cancelling a
 deferred op
Message-ID: <20220623230947.GV227878@dread.disaster.area>
References: <165601679540.2928801.11814839944987662641.stgit@magnolia>
 <165601680110.2928801.13403149388824105760.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165601680110.2928801.13403149388824105760.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b4f2bd
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=8r5lCEU8nhO-NPKkn9cA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 01:40:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running the following fstest with logged xattrs DISabled, I
> noticed the following:
> 
> # FSSTRESS_AVOID="-z -f unlink=1 -f rmdir=1 -f creat=2 -f mkdir=2 -f
> getfattr=3 -f listfattr=3 -f attr_remove=4 -f removefattr=4 -f
> setfattr=20 -f attr_set=60" ./check generic/475
> 
> INFO: task u9:1:40 blocked for more than 61 seconds.
>       Tainted: G           O      5.19.0-rc2-djwx #rc2
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:u9:1            state:D stack:12872 pid:   40 ppid:     2 flags:0x00004000
> Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
> Call Trace:
>  <TASK>
>  __schedule+0x2db/0x1110
>  schedule+0x58/0xc0
>  schedule_timeout+0x115/0x160
>  __down_common+0x126/0x210
>  down+0x54/0x70
>  xfs_buf_lock+0x2d/0xe0 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
>  xfs_buf_item_unpin+0x227/0x3a0 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
>  xfs_trans_committed_bulk+0x18e/0x320 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
>  xlog_cil_committed+0x2ea/0x360 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
>  xlog_cil_push_work+0x60f/0x690 [xfs 0532c1cb1d67dd81d15cb79ac6e415c8dec58f73]
>  process_one_work+0x1df/0x3c0
>  worker_thread+0x53/0x3b0
>  kthread+0xea/0x110
>  ret_from_fork+0x1f/0x30
>  </TASK>
> 
> This appears to be the result of shortform_to_leaf creating a new leaf
> buffer as part of adding an xattr to a file.  The new leaf buffer is
> held and attached to the xfs_attr_intent structure, but then the
> filesystem shuts down.  Instead of the usual path (which adds the attr
> to the held leaf buffer which releases the hold), we instead cancel the
> entire deferred operation.
> 
> Unfortunately, xfs_attr_cancel_item doesn't release any attached leaf
> buffers, so we leak the locked buffer.  The CIL cannot do anything
> about that, and hangs.  Fix this by teaching it to release leaf buffers,
> and make XFS a little more careful about not leaving a dangling
> reference.
> 
> The prologue of xfs_attri_item_recover is (in this author's opinion) a
> little hard to figure out, so I'll clean that up in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_item.c |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
