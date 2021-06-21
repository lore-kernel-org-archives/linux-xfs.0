Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A27C4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 17:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D92626102A
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 17:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFURHt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 13:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhFURH1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 13:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199E660FF2;
        Mon, 21 Jun 2021 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624295113;
        bh=l+90CaGN2OLMQc9JSHM2OkLoXN376MUxahfyz4PKo5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kP0EHDDkFhct3kbExsm0UHNYKW0GRV3l0m0XGPiXlZ0AEkVi3K2F66hDgTurKnIgA
         2B3RqxUZ9+2OSez9TMricO2Et3MTAeElW74aDLsJBUK58qdmH0IbVLwfCrcNgR8SWc
         kqiHMoum5hYmYdOwLrE6l7ZlkKf+TGdb4HhJwP1obOuo2Im8qur+7VTOt5VAcurWdO
         VljB6OUNT6o+gb2+PfODsqYT4UCUS5dkmNldqchnh+SqauDudI6XPLX+3fqYxMvMEN
         /T0mw8X2YlAcPRxXBwR6kygNquDue8/ldGy27Q/tMY+Wnsccrr/fflT5NByiunVV93
         WU7BycpQnqWxQ==
Date:   Mon, 21 Jun 2021 10:05:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next **REBASED** to 2909e02fec6c
Message-ID: <20210621170512.GC3619569@locust>
References: <20210619204825.GH158209@locust>
 <20210621025217.GS664593@dread.disaster.area>
 <20210621042731.GH158232@locust>
 <20210621052317.GT664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621052317.GT664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 03:23:17PM +1000, Dave Chinner wrote:
> On Sun, Jun 20, 2021 at 09:27:31PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 21, 2021 at 12:52:17PM +1000, Dave Chinner wrote:
> > > On Sat, Jun 19, 2021 at 01:48:25PM -0700, Darrick J. Wong wrote:
> > > > Dave Chinner (43):
> > > >       [0a683794ace2] xfs: split up xfs_buf_allocate_memory
> > > >       [07b5c5add42a] xfs: use xfs_buf_alloc_pages for uncached buffers
> > > >       [c9fa563072e1] xfs: use alloc_pages_bulk_array() for buffers
> > > >       [02c511738688] xfs: merge _xfs_buf_get_pages()
> > > >       [e7d236a6fe51] xfs: move page freeing into _xfs_buf_free_pages()
> > > >       [9bbafc71919a] xfs: move xfs_perag_get/put to xfs_ag.[ch]
> > > >       [61aa005a5bd7] xfs: prepare for moving perag definitions and support to libxfs
> > > >       [07b6403a6873] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
> > > >       [f250eedcf762] xfs: make for_each_perag... a first class citizen
> > > >       [934933c3eec9] xfs: convert raw ag walks to use for_each_perag
> > > >       [6f4118fc6482] xfs: convert xfs_iwalk to use perag references
> > > >       [7f8d3b3ca6fe] xfs: convert secondary superblock walk to use perags
> > > >       [45d066211756] xfs: pass perags through to the busy extent code
> > > >       [30933120ad79] xfs: push perags through the ag reservation callouts
> > > >       [58d43a7e3263] xfs: pass perags around in fsmap data dev functions
> > > >       [be9fb17d88f0] xfs: add a perag to the btree cursor
> > > >       [fa9c3c197329] xfs: convert rmap btree cursor to using a perag
> > > >       [a81a06211fb4] xfs: convert refcount btree cursor to use perags
> > > >       [289d38d22cd8] xfs: convert allocbt cursors to use perags
> > > >       [7b13c5155182] xfs: use perag for ialloc btree cursors
> > > >       [50f02fe3338d] xfs: remove agno from btree cursor
> > > >       [4268547305c9] xfs: simplify xfs_dialloc_select_ag() return values
> > > >       [89b1f55a2951] xfs: collapse AG selection for inode allocation
> > > >       [b652afd93703] xfs: get rid of xfs_dir_ialloc()
> > > >       [309161f6603c] xfs: inode allocation can use a single perag instance
> > > >       [8237fbf53d6f] xfs: clean up and simplify xfs_dialloc()
> > > >       [f40aadb2bb64] xfs: use perag through unlink processing
> > > >       [509201163fca] xfs: remove xfs_perag_t
> > > >       [977ec4ddf0b7] xfs: don't take a spinlock unconditionally in the DIO fastpath
> > > >       [289ae7b48c2c] xfs: get rid of xb_to_gfp()
> > > >       [8bcac7448a94] xfs: merge xfs_buf_allocate_memory
> > > >       [9ba0889e2272] xfs: drop the AGI being passed to xfs_check_agi_freecount
> > > >       [90e2c1c20ac6] xfs: perag may be null in xfs_imap()
> > > >       [a6a65fef5ef8] xfs: log stripe roundoff is a property of the log
> > > >       [25f25648e57c] xfs: separate CIL commit record IO
> > > 
> > > Ugh. I'm still getting hangs on the wait added by this code:
> > > 
> > > +	/*
> > > +	 * If the checkpoint spans multiple iclogs, wait for all previous
> > > +	 * iclogs to complete before we submit the commit_iclog.
> > > +	 */
> > > +	if (ctx->start_lsn != commit_lsn) {
> > > +		spin_lock(&log->l_icloglock);
> > > +		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > > +	}
> > > +
> > > 
> > > That's the hang the first two patches of my fixup series addressed.
> > > I note that:
> > > 
> > > >       [9b845604a4d5] xfs: remove xfs_blkdev_issue_flush
> > > >       [e45cc747a6fd] xfs: async blkdev cache flush
> > > >       [d7693a7f4ef9] xfs: CIL checkpoint flushes caches unconditionally
> > > >       [6a5c6f5ef0a4] xfs: remove need_start_rec parameter from xlog_write()
> > > >       [feb616896031] xfs: journal IO cache flush reductions
> > > >       [e30fbb337045] xfs: Fix CIL throttle hang when CIL space used going backwards
> > > >       [742140d2a486] xfs: xfs_log_force_lsn isn't passed a LSN
> > > >       [0f4976a8b389] xfs: add iclog state trace events
> > > 
> > > You included the trace events patch, but not the patch containing
> > > the bug fix for commit_iclog->ic_prev pointing to a future iclog
> > > instead of a past iclog....
> > 
> > Doh, I didn't think the trace patch was all that controversial. :(
> 
> The trace patch isn't controversial, just pointing out something I
> didn't expect. I thought it was a straight revert and the rest of
> the work would come when it's all sorted...

It started as a straight revert, but then it occurred to me that adding
tracepoints isn't usually a big deal, so why not add it so you don't
have to submit it again later?

> > So, uh, since we got a week extension, which patches do I need to get
> > things ship-shape for 5.14?
> 
> Not sure yet - I still don't have a clear handle on why shutdown is
> hanging in xlog_wait_on_iclog() - it hung with the LSN fixup in
> place so there's another shutdown action here that I haven't grokked
> yet. I'll let you know when I've got to the bottom of it.

Ok.  $spouse and I decided to take a vacation for a few days, so I won't
be online (after today) until Friday.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
