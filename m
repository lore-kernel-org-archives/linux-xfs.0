Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73538C27C40
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 04:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbjHXEwm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 00:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239356AbjHXEwi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 00:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EADAEC
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 21:52:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B07196181D
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 04:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057B6C433C8;
        Thu, 24 Aug 2023 04:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692852755;
        bh=/iGYt8LSivNZNNxoJRCdBbj1T1D8gF7MUHTGrJiIJLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iGVDg32cu8H4i2P27gDjncVyss5fjjTAkAnt1poXDkC63CDvXJX0zc4+MHqNfqXns
         M/mirJioEQ+yK6J2SL55ca/X7LgTS5FZX1kOIf7U+dNmzUNJRLAACv4llnLGbEaSQG
         9ez9Zo6IMdQErO0guwT+LIFRJSNaEitBxpIVJtJbKbXxkNrLtuC4+SRtOQO3g0Ud5V
         H/MrVCGv04ZkOWgJetWmSPIuoNWpKa9eywpa2EyDRB6BKUmaZWoZzXvLpH9pu2wG4t
         zfyvVjKOx55TrFasDBS2lVSQQ0ObSbtQewCrRwksB3ra3v+YHt3pxboj98W+sfgMnp
         SQ46yWRJr4+SQ==
Date:   Wed, 23 Aug 2023 21:52:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <20230824045234.GK11263@frogsfrogsfrogs>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 18, 2023 at 03:25:46AM +0000, Wengang Wang wrote:
> What things looks to be:
> 
> For the file deletion.  log bytes are reserved basing on xfs_mount->tr_itruncate which is:
> {
>     tr_logres = 175488,
>     tr_logcount = 2,
>     tr_logflags = XFS_TRANS_PERM_LOG_RES,
> }  
> You see it’s permanent log reservation with two log operations (two transactions in rolling mode).
> After calculation (xlog_calc_unit_res(), adding space for various log headers), the final
> log space needed per transaction changes from  175488 to 180208 bytes. So the total
> log space needed is 360416 (180208 * 2).   
> Above log space (360416 bytes) needs to be reserved for both run time inode removing
> (xfs_inactive_truncate()) and EFI recover (xfs_efi_item_recover()).
> 
> RUNTIME
> ========
> 
> For run time inode removing. The first transaction is mainly used for inode fields change.
> The second transaction is used for intents including extent freeing.
> 
> For the first transaction, it has 180208 reserved log bytes (another 180208 bytes reserved
> for the coming transaction).  
> The first transaction is committed, writing some bytes to log and releasing the left reserved bytes.
> 
> Now we have the second transaction which has 180208 log bytes reserved too. The second
> transaction is supposed to process intents including extent freeing. With my hacking patch,
> I blocked the extent freeing 5 hours. So in that 5 hours,  180208 (NOT 360416) log bytes are reserved.
> 
> With my test case, other transactions (update timestamps) then happen. As my hacking patch
> pins the journal tail, those timestamp-updating transactions finally use up (almost) all the left available
> log space (in memory in on disk).  And finally the on disk (and in memory) available log space
> goes down near to 180208 bytes. Those 180208 bytes are reserved by above second (extent-free)
> transaction.
> 
> Panic the kernel and remount the xfs volume
> 
> LOG RECOVER
> =============
> 
> With log recover, during EFI recover, we use tr_itruncate again to reserve two transactions that needs
> 360416 log bytes. Reserving 360416 bytes fails (blocks) because we now only have about 180208 available.
> 
> THINKING
> ========
> Actually during the EFI recover, we only need one transaction to free the extents just like the 2nd
> transaction at RUNTIME. So it only needs to reserve 180208 rather than 360416 bytes.  We have
> (a bit) more than 180208 available log bytes  on disk, so the reservation goes and the recovery goes.
> That is to say: we can fix the log recover part to fix the issue. We can introduce a new xfs_trans_res
> xfs_mount->tr_ext_free
> {
>     tr_logres = 175488,
>     tr_logcount = 0,
>     tr_logflags = 0,
> }
> and use tr_ext_free instead of tr_itruncate in EFI recover. (didn’t try it).

Hmm.  The log intent item recovery functions (e.g. xfs_efi_item_recover)
take the recovered log item and perform *exactly* one step of the
transaction chain.  If there's more work to do, the
xfs_defer_ops_capture_and_commit machinery captures the defer ops, block
reservation, and transaction reservation for later.

Later, in xlog_finish_defer_ops, we "rehydrate" the old transaction and
block reservation, attach the defer ops, and finish the chain:

		/*
		 * Create a new transaction reservation from the
		 * captured information.  Set logcount to 1 to force the
		 * new transaction to regrant every roll so that we can
		 * make forward progress in recovery no matter how full
		 * the log might be.
		 */
		resv.tr_logres = dfc->dfc_logres;
		resv.tr_logcount = 1;
		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;

		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
				dfc->dfc_rtxres, XFS_TRANS_RESERVE,
				&tp);
		if (error) {
			xlog_force_shutdown(mp->m_log,
					SHUTDOWN_LOG_IO_ERROR);
			return error;
		}

		/*
		 * Transfer to this new transaction all the dfops we
		 * captured from recovering a single intent item.
		 */
		list_del_init(&dfc->dfc_list);
		xfs_defer_ops_continue(dfc, tp, &dres);
		error = xfs_trans_commit(tp);

Since xfs_efi_item_recover is only performing one step of what could be
a chain of deferred updates, it never rolls the transaction that it
creates.  It therefore only requires the amount of grant space that
you'd get with tr_logcount == 1.  It is therefore a bit silly that we
ask for more than that, and in bad cases like this, hang log recovery
needlessly.

Which is exactly what you theorized above.  Ok, I'm starting to be
convinced... :)

I wonder, if you add this to the variable declarations in
xfs_efi_item_recover (or xfs_efi_recover if we're actually talking about
UEK5 here):

	struct xfs_trans_resv	resv = M_RES(mp)->tr_itruncate;

and then change the xfs_trans_alloc call to:

	resv.tr_logcount = 1;
	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);

Does that solve the problem?

--D

> thanks,
> wengang
> 
> > On Jul 28, 2023, at 10:56 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > 
> > 
> >> On Jul 25, 2023, at 9:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> 
> >> On Mon, Jul 24, 2023 at 06:03:02PM +0000, Wengang Wang wrote:
> >>>> On Jul 23, 2023, at 5:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>> On Fri, Jul 21, 2023 at 07:36:03PM +0000, Wengang Wang wrote:
> >>>>> FYI:
> >>>>> 
> >>>>> I am able reproduce the XFS mount hang issue with hacked kernels based on
> >>>>> both 4.14.35 kernel or 6.4.0 kernel.
> >>>>> Reproduce steps:
> >>>>> 
> >>>>> 1. create a XFS with 10MiB log size (small so easier to reproduce). The following
> >>>>> steps all aim at this XFS volume.
> >>>> 
> >>>> Actually, make that a few milliseconds.... :)
> >>> 
> >>> :)
> >>> 
> >>>> mkfs/xfs_info output would be appreciated.
> >>> 
> >>> sure,
> >>> # xfs_info 20GB.bk2
> >>> meta-data=20GB.bk2               isize=256    agcount=4, agsize=1310720 blks
> >>>        =                       sectsz=512   attr=2, projid32bit=1
> >>>        =                       crc=0        finobt=0, sparse=0, rmapbt=0
> >>>        =                       reflink=0
> >> 
> >> Hmmmm. Why are you only testing v4 filesystems? They are deprecated
> >> and support is largely due to be dropped from upstream in 2025...
> >> 
> > 
> > Ha, it just happened to be so.
> > I was trying to reproduce it in the same environment as customer has —
> > that’s OracleLinux7. The default behavior of mkfs.xfs in OL7 is to format
> > v4 filesystems.  I created the xfs image in a file on OL7 and copied the image
> > file to a 6.4.0 kernel machine. That’s why you see v4 filesystem here.
> > 
> >> Does the same problem occur with a v5 filesystems?
> > 
> > Will test and report back.
> > 
> >> 
> >>>>> 5. Checking the on disk left free log space, it’s 181760 bytes for both 4.14.35
> >>>>> kernel and 6.4.0 kernel.
> >>>> 
> >>>> Which is is clearly wrong. It should be at least 360416 bytes (i.e
> >>>> tr_itrunc), because that's what the EFI being processed that pins
> >>>> the tail of the log is supposed to have reserved when it was
> >>>> stalled.
> >>> 
> >>> Yep, exactly.
> >>> 
> >>>> So where has the ~180kB of leaked space come from?
> >>>> 
> >>>> Have you traced the grant head reservations to find out
> >>>> what the runtime log space and grant head reservations actually are?
> >>> I have the numbers in vmcore (ignore the WARNs),
> >> 
> >> That's not what I'm asking. You've dumped the values at the time of
> >> the hang, not traced the runtime reservations that have been made.
> >> 
> >>>> i.e. we have full tracing of the log reservation accounting via
> >>>> tracepoints in the kernel. If there is a leak occurring, you need to
> >>>> capture a trace of all the reservation accounting operations and
> >>>> post process the output to find out what operation is leaking
> >>>> reserved space. e.g.
> >>>> 
> >>>> # trace-cmd record -e xfs_log\* -e xlog\* -e printk touch /mnt/scratch/foo
> >>>> ....
> >>>> # trace-cmd report > s.t
> >>>> # head -3 s.t
> >>>> cpus=16
> >>>>        touch-289000 [008] 430907.633820: xfs_log_reserve:      dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 1024 grant_write_cycle 1 grant_write_bytes 1024 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> >>>>        touch-289000 [008] 430907.633829: xfs_log_reserve_exit: dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 482800 grant_write_cycle 1 grant_write_bytes 482800 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> >>>> 
> >>>> #
> >>>> 
> >>>> So this tells us the transaction reservation unit size, the count of
> >>>> reservations, the current reserve and grant head locations, and the
> >>>> current head and tail of the log at the time the transaction
> >>>> reservation is started and then after it completes.
> >>> 
> >>> Will do that and report back. You want full log or only some typical
> >>> ones? Full log would be big, how shall I share? 
> >> 
> >> I don't want to see the log. It'll be huge - I regularly generate
> >> traces containing gigabytes of log accounting traces like this from
> >> a single workload.
> >> 
> >> What I'm asking you to do is run the tracing and then post process
> >> the values from the trace to determine what operation is using more
> >> space than is being freed back to the log.
> >> 
> >> I generally do this with grep, awk and sed. some people use python
> >> or perl. But either way it's a *lot* of work - in the past I have
> >> spent _weeks_ on trace analysis to find a 4 byte leak in the log
> >> space accounting. DOing things like graphing the head, tail and grant
> >> spaces over time tend to show if this is a gradual leak versus a
> >> sudden step change. If it's a sudden step change, then you can
> >> isolate it in the trace and work out what happened. If it's a
> >> gradual change, then you need to start looking for accounting
> >> discrepancies...
> >> 
> >> e.g. a transaction records 32 bytes used in the item, so it releases
> >> t_unit - 32 bytes at commit. However, the CIL may then only track 28
> >> bytes of space for the item in the journal and we leak 4 bytes of
> >> reservation on every on of those items committed.
> >> 
> >> These sorts of leaks typically only add up to being somethign
> >> significant in situations where the log is flooded with tiny inode
> >> timestamp changes - 4 bytes iper item doesn't really matter when you
> >> only have a few thousand items in the log, but when you have
> >> hundreds of thousands of tiny items in the log...
> >> 
> > 
> > OK. will work more on this.
> > # I am going to start a two-week vacation, and will then continue on this when back.
> > 
> > thanks,
> > wengang
> 
> 
