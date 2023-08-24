Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899B1C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 05:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbjHXFFb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 01:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbjHXFFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 01:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF2310F9
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 22:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A233963285
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 05:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072A0C433C7;
        Thu, 24 Aug 2023 05:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692853527;
        bh=FAr3L57e2cFlOFgAZ9X0JhblXVzT/v2zZZgWHEBdC94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oIOWFd58zqebdVFu/5P7z1gpqSBFKpUtp7iiA6yOItUQuDlvTpy4r/u9BpLR3bHyq
         4X7okDNalk2c/36k8fguVQyXacZfVafq9L7KBWvG6Pmg/f/8zBjpZwPOgLwRYAszOc
         d6GXB9mLD4F7pzLNXFEhavaMPRU1aw3VpeJ7hbRB2wLhM6fXcfq+5Zmsbjlqn0zuA6
         R4UngFMisWzy4MAAEoDtez6mVInNtsAB4CXYpuqoh6uYyS7/ZRrp8EPeX+ko5y2XUJ
         CnVNnYut15kFu/s6GuZr34aOhf9NJciyz6RXRYRjNV8jXAp66ie81R3cdL/lHI9wLZ
         wLoaz49GXivwQ==
Date:   Wed, 23 Aug 2023 22:05:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <20230824050526.GL11263@frogsfrogsfrogs>
References: <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <27B173AA-8203-42E5-85CC-FB5F380521FB@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27B173AA-8203-42E5-85CC-FB5F380521FB@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 21, 2023 at 10:06:45PM +0000, Wengang Wang wrote:
> 
> 
> > On Aug 17, 2023, at 8:25 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > What things looks to be:
> > 
> > For the file deletion.  log bytes are reserved basing on xfs_mount->tr_itruncate which is:
> > {
> >    tr_logres = 175488,
> >    tr_logcount = 2,
> >    tr_logflags = XFS_TRANS_PERM_LOG_RES,
> > }  
> > You see it’s permanent log reservation with two log operations (two transactions in rolling mode).
> > After calculation (xlog_calc_unit_res(), adding space for various log headers), the final
> > log space needed per transaction changes from  175488 to 180208 bytes. So the total
> > log space needed is 360416 (180208 * 2).   
> > Above log space (360416 bytes) needs to be reserved for both run time inode removing
> > (xfs_inactive_truncate()) and EFI recover (xfs_efi_item_recover()).
> > 
> > RUNTIME
> > ========
> > 
> > For run time inode removing. The first transaction is mainly used for inode fields change.
> > The second transaction is used for intents including extent freeing.
> > 
> > For the first transaction, it has 180208 reserved log bytes (another 180208 bytes reserved
> > for the coming transaction).  
> > The first transaction is committed, writing some bytes to log and releasing the left reserved bytes.
> > 
> > Now we have the second transaction which has 180208 log bytes reserved too. The second
> > transaction is supposed to process intents including extent freeing. With my hacking patch,
> > I blocked the extent freeing 5 hours. So in that 5 hours,  180208 (NOT 360416) log bytes are reserved.
> > 
> > With my test case, other transactions (update timestamps) then happen. As my hacking patch
> > pins the journal tail, those timestamp-updating transactions finally use up (almost) all the left available
> > log space (in memory in on disk).  And finally the on disk (and in memory) available log space
> > goes down near to 180208 bytes. Those 180208 bytes are reserved by above second (extent-free)
> > transaction.
> > 
> > Panic the kernel and remount the xfs volume
> > 
> > LOG RECOVER
> > =============
> > 
> > With log recover, during EFI recover, we use tr_itruncate again to reserve two transactions that needs
> > 360416 log bytes. Reserving 360416 bytes fails (blocks) because we now only have about 180208 available.
> > 
> > THINKING
> > ========
> > Actually during the EFI recover, we only need one transaction to free the extents just like the 2nd
> > transaction at RUNTIME. So it only needs to reserve 180208 rather than 360416 bytes.  We have
> > (a bit) more than 180208 available log bytes  on disk, so the reservation goes and the recovery goes.
> > That is to say: we can fix the log recover part to fix the issue. We can introduce a new xfs_trans_res
> > xfs_mount->tr_ext_free
> > {
> >    tr_logres = 175488,
> >    tr_logcount = 0,
> >    tr_logflags = 0,
> > }
> > and use tr_ext_free instead of tr_itruncate in EFI recover. (didn’t try it).
> > 
> 
> The following patch recovers the problematic XFS volume by my hacked kernel and the also
> the one from customer.
> 
> commit 19fad903e213717a92f8b94fe2c0c68b6a6ee7f7 (HEAD -> 35587163_fix)
> Author: Wengang Wang <wen.gang.wang@oracle.com>
> Date:   Mon Aug 21 15:03:58 2023 -0700
> 
>     xfs: reserve less log space when recovering EFIs
> 
>     Currently tr_itruncate is used for both run time truncating and
>     boot time EFI recovery. tr_itruncate
>     {
>        tr_logres = 175488,
>        tr_logcount = 2,
>        tr_logflags = XFS_TRANS_PERM_LOG_RES,
>     }
> 
>     Is a permanent two-transaction series. Actually only the second transaction
>     is really used to free extents and that needs half of the log space reservation
>     from tr_itruncate.
> 
>     For EFI recovery, the things to do is just to free extents, so it doesn't
>     needs full log space reservation by tr_itruncate. It needs half of it and
>     shouldn't need more than that.
> 
>     Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index f1a5ecf099aa..428984e48d23 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
u> @@ -667,6 +667,7 @@ xfs_efi_item_recover(
>         int                             i;
>         int                             error = 0;
>         bool                            requeue_only = false;
> +       struct xfs_trans_res            tres;
> 
>         /*
>          * First check the validity of the extents described by the
> @@ -683,7 +684,10 @@ xfs_efi_item_recover(
>                 }
>         }
> 
> -       error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> +       tres.tr_logres = M_RES(mp)->tr_itruncate.tr_logres;
> +       tres.tr_logcount = 0;

HAH that was fast.  I'm glad it worked.

> +       tres.tr_logflags = 0;

Though I think we should preserve XFS_TRANS_PERM_LOG_RES since other
parts of the codebase check that the flag was conveyed from the
transaction reservation into tp->t_flags itself.

I think for an upstream patch we'd rather fix all of them, and in a
systemic way.  How about adding this to xfs_log_recover.h:

/*
 * Transform a regular reservation into one suitable for recovery of a
 * log intent item.
 *
 * Intent recovery only runs a single step of the transaction chain and
 * defers the rest to a separate transaction.  Therefore, we reduce
 * logcount to 1 here to avoid livelocks if the log grant space is
 * nearly exhausted due to the recovered intent pinning the tail.  Keep
 * the same logflags to avoid tripping asserts elsewhere.  Struct copies
 * abound below.
 */
static inline struct xfs_trans_res
xlog_recover_resv(const struct xfs_trans_res *template)
{
	struct xfs_trans_res ret = {
		.tr_logres	= template->tr_logres,
		.tr_logcount	= 1,
		.tr_logflags	= template->tr_logflags,
	};

	return ret;
}

and then this becomes:

	struct xfs_trans_res	resv;

	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);

which should simplify fixing this for the other recovery functions?

--D

> +       error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);

>         if (error)
>                 return error;
>         efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
> 
> thanks,
> wengang
> 
> > thanks,
> > wengang
> > 
> >> On Jul 28, 2023, at 10:56 AM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> >> 
> >> 
> >> 
> >>> On Jul 25, 2023, at 9:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> 
> >>> On Mon, Jul 24, 2023 at 06:03:02PM +0000, Wengang Wang wrote:
> >>>>> On Jul 23, 2023, at 5:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>>> On Fri, Jul 21, 2023 at 07:36:03PM +0000, Wengang Wang wrote:
> >>>>>> FYI:
> >>>>>> 
> >>>>>> I am able reproduce the XFS mount hang issue with hacked kernels based on
> >>>>>> both 4.14.35 kernel or 6.4.0 kernel.
> >>>>>> Reproduce steps:
> >>>>>> 
> >>>>>> 1. create a XFS with 10MiB log size (small so easier to reproduce). The following
> >>>>>> steps all aim at this XFS volume.
> >>>>> 
> >>>>> Actually, make that a few milliseconds.... :)
> >>>> 
> >>>> :)
> >>>> 
> >>>>> mkfs/xfs_info output would be appreciated.
> >>>> 
> >>>> sure,
> >>>> # xfs_info 20GB.bk2
> >>>> meta-data=20GB.bk2               isize=256    agcount=4, agsize=1310720 blks
> >>>>       =                       sectsz=512   attr=2, projid32bit=1
> >>>>       =                       crc=0        finobt=0, sparse=0, rmapbt=0
> >>>>       =                       reflink=0
> >>> 
> >>> Hmmmm. Why are you only testing v4 filesystems? They are deprecated
> >>> and support is largely due to be dropped from upstream in 2025...
> >>> 
> >> 
> >> Ha, it just happened to be so.
> >> I was trying to reproduce it in the same environment as customer has —
> >> that’s OracleLinux7. The default behavior of mkfs.xfs in OL7 is to format
> >> v4 filesystems.  I created the xfs image in a file on OL7 and copied the image
> >> file to a 6.4.0 kernel machine. That’s why you see v4 filesystem here.
> >> 
> >>> Does the same problem occur with a v5 filesystems?
> >> 
> >> Will test and report back.
> >> 
> >>> 
> >>>>>> 5. Checking the on disk left free log space, it’s 181760 bytes for both 4.14.35
> >>>>>> kernel and 6.4.0 kernel.
> >>>>> 
> >>>>> Which is is clearly wrong. It should be at least 360416 bytes (i.e
> >>>>> tr_itrunc), because that's what the EFI being processed that pins
> >>>>> the tail of the log is supposed to have reserved when it was
> >>>>> stalled.
> >>>> 
> >>>> Yep, exactly.
> >>>> 
> >>>>> So where has the ~180kB of leaked space come from?
> >>>>> 
> >>>>> Have you traced the grant head reservations to find out
> >>>>> what the runtime log space and grant head reservations actually are?
> >>>> I have the numbers in vmcore (ignore the WARNs),
> >>> 
> >>> That's not what I'm asking. You've dumped the values at the time of
> >>> the hang, not traced the runtime reservations that have been made.
> >>> 
> >>>>> i.e. we have full tracing of the log reservation accounting via
> >>>>> tracepoints in the kernel. If there is a leak occurring, you need to
> >>>>> capture a trace of all the reservation accounting operations and
> >>>>> post process the output to find out what operation is leaking
> >>>>> reserved space. e.g.
> >>>>> 
> >>>>> # trace-cmd record -e xfs_log\* -e xlog\* -e printk touch /mnt/scratch/foo
> >>>>> ....
> >>>>> # trace-cmd report > s.t
> >>>>> # head -3 s.t
> >>>>> cpus=16
> >>>>>       touch-289000 [008] 430907.633820: xfs_log_reserve:      dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 1024 grant_write_cycle 1 grant_write_bytes 1024 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> >>>>>       touch-289000 [008] 430907.633829: xfs_log_reserve_exit: dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 482800 grant_write_cycle 1 grant_write_bytes 482800 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> >>>>> 
> >>>>> #
> >>>>> 
> >>>>> So this tells us the transaction reservation unit size, the count of
> >>>>> reservations, the current reserve and grant head locations, and the
> >>>>> current head and tail of the log at the time the transaction
> >>>>> reservation is started and then after it completes.
> >>>> 
> >>>> Will do that and report back. You want full log or only some typical
> >>>> ones? Full log would be big, how shall I share? 
> >>> 
> >>> I don't want to see the log. It'll be huge - I regularly generate
> >>> traces containing gigabytes of log accounting traces like this from
> >>> a single workload.
> >>> 
> >>> What I'm asking you to do is run the tracing and then post process
> >>> the values from the trace to determine what operation is using more
> >>> space than is being freed back to the log.
> >>> 
> >>> I generally do this with grep, awk and sed. some people use python
> >>> or perl. But either way it's a *lot* of work - in the past I have
> >>> spent _weeks_ on trace analysis to find a 4 byte leak in the log
> >>> space accounting. DOing things like graphing the head, tail and grant
> >>> spaces over time tend to show if this is a gradual leak versus a
> >>> sudden step change. If it's a sudden step change, then you can
> >>> isolate it in the trace and work out what happened. If it's a
> >>> gradual change, then you need to start looking for accounting
> >>> discrepancies...
> >>> 
> >>> e.g. a transaction records 32 bytes used in the item, so it releases
> >>> t_unit - 32 bytes at commit. However, the CIL may then only track 28
> >>> bytes of space for the item in the journal and we leak 4 bytes of
> >>> reservation on every on of those items committed.
> >>> 
> >>> These sorts of leaks typically only add up to being somethign
> >>> significant in situations where the log is flooded with tiny inode
> >>> timestamp changes - 4 bytes iper item doesn't really matter when you
> >>> only have a few thousand items in the log, but when you have
> >>> hundreds of thousands of tiny items in the log...
> >>> 
> >> 
> >> OK. will work more on this.
> >> # I am going to start a two-week vacation, and will then continue on this when back.
> >> 
> >> thanks,
> >> wengang
> > 
> > 
> 
