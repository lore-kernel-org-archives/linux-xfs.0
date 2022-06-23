Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DB4C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 18:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiFWSxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 14:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239285AbiFWSvS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 14:51:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD771FA397
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 10:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2178FB8247F
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 17:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF442C3411B;
        Thu, 23 Jun 2022 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656006955;
        bh=6swOYMi2dhi7ZHnScFXiI7eMII0IgZgBYdHIPizGC2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J6nyqFF8r5fjAxFup4iLlrByXZBwTWA8hdaMc7MSIec21R3YW1V+l/IpeFnhvNmLl
         NXT3alEi2h+1rq0Z+yK24BUghXqYGS5JRKlYFB4V3WC476l2XfI78Psjc7lTWc101Y
         l6azX9JHKNIxjzv6uHk2lM5oD8XJC/3Feku8/stm+43/z+qITbAaVRHPaq3M/jU+5F
         +iUTS5NnAivBIysnO4YhBgcquk9O13bYpofFiSA/GypKZYWB+HLapxbT3I8Sg8pa3M
         rmZ2kqZxQ6PBkebkouXYhk04zDCszgxWpCM/EaYFw/KExmqOjkPngHjheBEy/E0mB/
         gJFtk+aCkK0Qw==
Date:   Thu, 23 Jun 2022 10:55:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: always free xattri_leaf_bp when cancelling a
 deferred op
Message-ID: <YrSpKxlrX/MiXMrB@magnolia>
References: <YrPQ1fAVh4RqPfNh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrPQ1fAVh4RqPfNh@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 07:32:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running the following fstest with logged xattrs DISabled, I
> noticed the following unmount hang:
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
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_attr_item.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 135d44133477..a2975f0ac280 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -455,6 +455,8 @@ static inline void
>  xfs_attr_free_item(
>  	struct xfs_attr_intent		*attr)
>  {
> +	ASSERT(attr->xattri_leaf_bp == NULL);
> +
>  	if (attr->xattri_da_state)
>  		xfs_da_state_free(attr->xattri_da_state);
>  	xfs_attri_log_nameval_put(attr->xattri_nameval);
> @@ -509,6 +511,10 @@ xfs_attr_cancel_item(
>  	struct xfs_attr_intent		*attr;
>  
>  	attr = container_of(item, struct xfs_attr_intent, xattri_list);
> +	if (attr->xattri_leaf_bp) {
> +		xfs_buf_relse(attr->xattri_leaf_bp);
> +		attr->xattri_leaf_bp = NULL;
> +	}
>  	xfs_attr_free_item(attr);
>  }
>  
> @@ -670,8 +676,10 @@ xfs_attri_item_recover(
>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
>  
>  out_unlock:
> -	if (attr->xattri_leaf_bp)
> +	if (attr->xattri_leaf_bp) {
>  		xfs_buf_relse(attr->xattri_leaf_bp);
> +		attr->xattri_leaf_bp = NULL;

Self NAK, we only want to set this to NULL if we're /not/ continuing the
attr intent.  I'll post a v2 and a cleanup patch to make the end of this
function less confusing.

--D

> +	}
>  
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
