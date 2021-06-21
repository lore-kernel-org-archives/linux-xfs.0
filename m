Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51166C48BDF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 02:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 254136113E
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 02:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUCyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Jun 2021 22:54:54 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:43529 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhFUCyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Jun 2021 22:54:53 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id AC2F11B0755;
        Mon, 21 Jun 2021 12:52:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvA2r-00FANh-9l; Mon, 21 Jun 2021 12:52:17 +1000
Date:   Mon, 21 Jun 2021 12:52:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next **REBASED** to 2909e02fec6c
Message-ID: <20210621025217.GS664593@dread.disaster.area>
References: <20210619204825.GH158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210619204825.GH158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=zdcQP4g_jC9tkl4xrf8A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 19, 2021 at 01:48:25PM -0700, Darrick J. Wong wrote:
> Dave Chinner (43):
>       [0a683794ace2] xfs: split up xfs_buf_allocate_memory
>       [07b5c5add42a] xfs: use xfs_buf_alloc_pages for uncached buffers
>       [c9fa563072e1] xfs: use alloc_pages_bulk_array() for buffers
>       [02c511738688] xfs: merge _xfs_buf_get_pages()
>       [e7d236a6fe51] xfs: move page freeing into _xfs_buf_free_pages()
>       [9bbafc71919a] xfs: move xfs_perag_get/put to xfs_ag.[ch]
>       [61aa005a5bd7] xfs: prepare for moving perag definitions and support to libxfs
>       [07b6403a6873] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
>       [f250eedcf762] xfs: make for_each_perag... a first class citizen
>       [934933c3eec9] xfs: convert raw ag walks to use for_each_perag
>       [6f4118fc6482] xfs: convert xfs_iwalk to use perag references
>       [7f8d3b3ca6fe] xfs: convert secondary superblock walk to use perags
>       [45d066211756] xfs: pass perags through to the busy extent code
>       [30933120ad79] xfs: push perags through the ag reservation callouts
>       [58d43a7e3263] xfs: pass perags around in fsmap data dev functions
>       [be9fb17d88f0] xfs: add a perag to the btree cursor
>       [fa9c3c197329] xfs: convert rmap btree cursor to using a perag
>       [a81a06211fb4] xfs: convert refcount btree cursor to use perags
>       [289d38d22cd8] xfs: convert allocbt cursors to use perags
>       [7b13c5155182] xfs: use perag for ialloc btree cursors
>       [50f02fe3338d] xfs: remove agno from btree cursor
>       [4268547305c9] xfs: simplify xfs_dialloc_select_ag() return values
>       [89b1f55a2951] xfs: collapse AG selection for inode allocation
>       [b652afd93703] xfs: get rid of xfs_dir_ialloc()
>       [309161f6603c] xfs: inode allocation can use a single perag instance
>       [8237fbf53d6f] xfs: clean up and simplify xfs_dialloc()
>       [f40aadb2bb64] xfs: use perag through unlink processing
>       [509201163fca] xfs: remove xfs_perag_t
>       [977ec4ddf0b7] xfs: don't take a spinlock unconditionally in the DIO fastpath
>       [289ae7b48c2c] xfs: get rid of xb_to_gfp()
>       [8bcac7448a94] xfs: merge xfs_buf_allocate_memory
>       [9ba0889e2272] xfs: drop the AGI being passed to xfs_check_agi_freecount
>       [90e2c1c20ac6] xfs: perag may be null in xfs_imap()
>       [a6a65fef5ef8] xfs: log stripe roundoff is a property of the log
>       [25f25648e57c] xfs: separate CIL commit record IO

Ugh. I'm still getting hangs on the wait added by this code:

+	/*
+	 * If the checkpoint spans multiple iclogs, wait for all previous
+	 * iclogs to complete before we submit the commit_iclog.
+	 */
+	if (ctx->start_lsn != commit_lsn) {
+		spin_lock(&log->l_icloglock);
+		xlog_wait_on_iclog(commit_iclog->ic_prev);
+	}
+

That's the hang the first two patches of my fixup series addressed.
I note that:

>       [9b845604a4d5] xfs: remove xfs_blkdev_issue_flush
>       [e45cc747a6fd] xfs: async blkdev cache flush
>       [d7693a7f4ef9] xfs: CIL checkpoint flushes caches unconditionally
>       [6a5c6f5ef0a4] xfs: remove need_start_rec parameter from xlog_write()
>       [feb616896031] xfs: journal IO cache flush reductions
>       [e30fbb337045] xfs: Fix CIL throttle hang when CIL space used going backwards
>       [742140d2a486] xfs: xfs_log_force_lsn isn't passed a LSN
>       [0f4976a8b389] xfs: add iclog state trace events

You included the trace events patch, but not the patch containing
the bug fix for commit_iclog->ic_prev pointing to a future iclog
instead of a past iclog....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
