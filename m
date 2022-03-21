Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BF4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 18:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349986AbiCUSgz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 14:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiCUSgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 14:36:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D60E7CDEE
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 11:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647887726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a37impsX6wzNGXGytOmvSomiLA+jFVzdnm7sWreYzWs=;
        b=cUyZi8IQ+oxo0Trk+Ma105D0hqhFug9SIkZ+r/Njv50AdUJ/dcok0Z/+uhDCR9YCPddGhU
        +9ApSJC03sBa16Yyrpg+ha1tPySja5Z0R04L25PAe9CH8QCU57DnMRWV2u8J8iURU4WGto
        BMXVgcBjdRCu3F2a3CcWBIfJxvPebiw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-T1NHPwIsNuOSYWtbJmXgeA-1; Mon, 21 Mar 2022 14:35:25 -0400
X-MC-Unique: T1NHPwIsNuOSYWtbJmXgeA-1
Received: by mail-qt1-f197.google.com with SMTP id bq21-20020a05622a1c1500b002e06d6279d5so9903134qtb.7
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 11:35:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a37impsX6wzNGXGytOmvSomiLA+jFVzdnm7sWreYzWs=;
        b=PMEVbrlGV794Ok4CQomt/l6qzSLYqLb6NkmeGMJSgl7B9jPm9hWM+3MUpqZsiLqtW2
         AzTdePItYTZUKC9WvIcTZDz5fJrMfsveRlE2OCY8eEL7ouGf/vcGh8pEKf2ZLw0q3h+P
         ywZds+q6Y36fgRLnwVDUVTFYKNT6PjjdRQlIE1G/CzNEbTd6tL+syT6LY9orz+5ROrEj
         FIldXPCkb+Vg25GoeqheC9GCIReZHSF7smVW2rm3l7cMvvKCikm+bQzZlIoLwbelgta7
         Lcq7DJUA7Rq4Sw3FWP0W9IlxnMRusr/mit9z4Dx1D64n6QX6oqFtpp++hKi2DSZhkeK3
         +9Eg==
X-Gm-Message-State: AOAM532R6aQ7jN0HwmHDdNB4e4aNUnmkyElCmtk9vKoa3iJ4KUMNhZtO
        l1pOswekllHBbrpXv/6Mv3PHe+ZvdUMBO9NNSDyVpLo4c5hKO1OUk0gKYnkPCLOMgJbVXW17A0p
        1pjVSHfM8EfN8DQ9FXDJm
X-Received: by 2002:ad4:5743:0:b0:435:9b32:a6b0 with SMTP id q3-20020ad45743000000b004359b32a6b0mr17069451qvx.122.1647887724233;
        Mon, 21 Mar 2022 11:35:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIdUz2MfH1GF4hkLXNxVJqUdmd6B6tDNju0q99Gr1XZgJOOChPzkkHTbad/fwtURhBx6Pjcw==
X-Received: by 2002:ad4:5743:0:b0:435:9b32:a6b0 with SMTP id q3-20020ad45743000000b004359b32a6b0mr17069420qvx.122.1647887723691;
        Mon, 21 Mar 2022 11:35:23 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id k13-20020a05622a03cd00b002e21621c243sm2118861qtx.39.2022.03.21.11.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 11:35:23 -0700 (PDT)
Date:   Mon, 21 Mar 2022 14:35:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <YjjFaU/uGHALNVlx@bfoster>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <YjSvG0wgm6epCa8X@bfoster>
 <20220318214253.GG1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220318214253.GG1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 19, 2022 at 08:42:53AM +1100, Dave Chinner wrote:
> On Fri, Mar 18, 2022 at 12:11:07PM -0400, Brian Foster wrote:
> > On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > > Hi,
> > >=20
> > > I'm not sure if this is known and/or fixed already, but it didn't look
> > > familiar so here is a report. I hit a splat when testing Willy's
> > > prospective folio bookmark change and it turns out it replicates on
> > > Linus' current master (551acdc3c3d2). This initially reproduced on
> > > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> > > xfs/006, but when I attempted to reproduce the latter a second time I
> > > hit what looks like the same problem as xfs/264. Both tests seem to
> > > involve some form of error injection, so possibly the same underlying
> > > problem. The GPF splat from xfs/264 is below.
> > >=20
> >=20
> > Darrick pointed out this [1] series on IRC (particularly the final
> > patch) so I gave that a try. I _think_ that addresses the GPF issue
> > given it was nearly 100% reproducible before and I didn't see it in a
> > few iterations, but once I started a test loop for a longer test I ran
> > into the aforementioned soft lockup again. A snippet of that one is
> > below [2]. When this occurs, the task appears to be stuck (i.e. the
> > warning repeats) indefinitely.
> >=20
> > Brian
> >=20
> > [1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david@fro=
morbit.com/
> > [2] Soft lockup warning from xfs/264 with patches from [1] applied:
> >=20
> > watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:1881]
> > Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_comm=
on rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mod x8=
6_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_transpor=
t_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iTCO_w=
dt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipmi ml=
x5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs ipmi_=
devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core intel=
_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal ipmi=
_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg mlx5_c=
ore lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper nvme=
t nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sysimg=
blt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample scsi=
_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm_mir=
ror dm_region_hash
> >  dm_log dm_mod
> > CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5.17.=
0-rc8+ #17
> > Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
> > Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> > RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
> > Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00=
 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 =
c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
> > RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
> > RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
> > RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
> > R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
> > R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
> > FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  _raw_spin_lock+0x2c/0x30
> >  xfs_trans_ail_delete+0x2a/0xd0 [xfs]
>=20
> So what is running around in a tight circle holding the AIL lock?
>=20
> Or what assert failed before this while holding the AIL lock?
>=20

I don't have much information beyond the test and resulting bug. There
are no assert failures before the bug occurs. An active CPU task dump
shows the stack from the soft lockup warning, the task running the dump
itself, and all other (94/96) CPUs appear idle. I tried the appended
patch on top of latest for-next (which now includes the other log
shutdown fix) and the problem still occurs.

Brian

> >  xfs_buf_item_done+0x22/0x30 [xfs]
> >  xfs_buf_ioend+0x71/0x5e0 [xfs]
> >  xfs_trans_committed_bulk+0x167/0x2c0 [xfs]
> >  ? enqueue_entity+0x121/0x4d0
> >  ? enqueue_task_fair+0x417/0x530
> >  ? resched_curr+0x23/0xc0
> >  ? check_preempt_curr+0x3f/0x70
> >  ? _raw_spin_unlock_irqrestore+0x1f/0x31
> >  ? __wake_up_common_lock+0x87/0xc0
> >  xlog_cil_committed+0x29c/0x2d0 [xfs]
> >  ? _raw_spin_unlock_irqrestore+0x1f/0x31
> >  ? __wake_up_common_lock+0x87/0xc0
> >  xlog_cil_process_committed+0x69/0x80 [xfs]
> >  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
> >  xlog_force_shutdown+0xd0/0x110 [xfs]
>=20
> The stack trace here looks mangled - it's missing functions between
> xfs_trans_committed_bulk() and xfs_buf_ioend()
>=20
> xfs_trans_committed_bulk(abort =3D true)
>   xfs_trans_committed_bulk
>     lip->li_iop->iop_unpin(remove =3D true)
>       xfs_buf_item_unpin()
>         xfs_buf_ioend_fail()
> 	  xfs_buf_ioend()
> 	    xfs_buf_item_done()
>=20
> Unless, of course, the xfs_buf_ioend symbol is wrongly detected
> because it's the last function call in xfs_buf_item_unpin(). That
> would give a stack of
>=20
> xfs_trans_committed_bulk(abort =3D true)
>   xfs_trans_committed_bulk
>     lip->li_iop->iop_unpin(remove =3D true)
>       xfs_buf_item_unpin()
>         xfs_buf_item_done()
>=20
> Which is the stale inode buffer release path. Which has a problem
> as I mention here:
>=20
> https://lore.kernel.org/linux-xfs/20220317053907.164160-8-david@fromorbit=
=2Ecom/
>=20
> @@ -720,6 +721,17 @@ xfs_iflush_ail_updates(
>  		if (INODE_ITEM(lip)->ili_flush_lsn !=3D lip->li_lsn)
>  			continue;
> =20
> +		/*
> +		 * dgc: Not sure how this happens, but it happens very
> +		 * occassionaly via generic/388.  xfs_iflush_abort() also
> +		 * silently handles this same "under writeback but not in AIL at
> +		 * shutdown" condition via xfs_trans_ail_delete().
> +		 */
> +		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> +			ASSERT(xlog_is_shutdown(lip->li_log));
> +			continue;
> +		}
> +
>=20
> THe symptoms that this worked around were double AIL unlocks, AIL
> list corruptions, and bp->b_li_list corruptions leading to
> xfs_buf_inode_iodone() getting stuck in an endless loop whilst
> holding the AIL lock, leading to soft lookups exactly like this one.
>=20
> I now know what is causing this problem - it is xfs_iflush_abort()
> being called from xfs_inode_reclaim() that removes the inode from
> buffer list without holding the buffer lock.
>=20
> Hence a traversal in xfs_iflush_cluster or xfs_buf_inode_iodone
> can store the next inode in the list in n, n then gets aborted by
> reclaim and removed from the lsit, and then the list traversal moves
> onto n, and it's now an empty list because it was removed. Hence
> the list traversal gets stuck forever on n because n->next =3D n.....
>=20
> If this sort of thing happens in xfs_iflush_ail_updates(), we can
> either do a double AIL removal which fires an assert with the AIL
> lock held, or we get stuck spinning on n with
> the AIL lock held. Either way, they both lead to softlockups on the
> AIL lock like this one.
>=20
> 'echo l > sysrq-trigger' is your friend in these situations - you'll
> see if there's a process spinning with the lock held on some other
> CPU...
>=20
> This situation is a regression introduced in the async inode reclaim
> patch series:
>=20
> https://lore.kernel.org/linux-xfs/20200622081605.1818434-1-david@fromorbi=
t.com/
>=20
> And is a locking screwup with xfs_iflush_abort() being called
> without holding the inode cluster buffer lock. It was a thinko
> w.r.t. list removal and traversal using the inode item lock. The bug
> has been there since June 2020, and it's only now that we have
> peeled back the shutdown onion a couple of layers further that it is
> manifesting.
>=20
> I have a prototype patch (below) to fix this - the locking is not
> pretty, but the AIL corruptions and soft lockups have gone away in
> my testing only to be replaced with a whole new set of g/388
> failures *I have never seen before*.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20
>=20
> xfs: locking on b_io_list is broken for inodes
>=20
> From: Dave Chinner <dchinner@redhat.com>
>=20
> Most buffer io list operations are run with the bp->b_lock held, but
> xfs_iflush_abort() can be called without the buffer lock being held
> resulting in inodes being removed from the buffer list while other
> list operations are occurring. This causes problems with corrupted
> bp->b_io_list inode lists during filesystem shutdown, leading to
> traversals that never end, double removals from the AIL, etc.
>=20
> Fix this by passing the buffer to xfs_iflush_abort() if we have
> it locked. If the inode is attached to the buffer, we're going to
> have to remove it from the buffer list and we'd have to get the
> buffer off the inode log item to do that anyway.
>=20
> If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
> then we can determine if the inode has a log item and if it is
> attached to a buffer before we do anything else. If it does have an
> attached buffer, we can lock it safely (because the inode has a
> reference to it) and then perform the inode abort.
>=20
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c     |   2 +-
>  fs/xfs/xfs_inode.c      |   4 +-
>  fs/xfs/xfs_inode_item.c | 123 ++++++++++++++++++++++++++++++++----------=
------
>  fs/xfs/xfs_inode_item.h |   2 +-
>  4 files changed, 87 insertions(+), 44 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4148cdf7ce4a..ec907be2d5b1 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -883,7 +883,7 @@ xfs_reclaim_inode(
>  	 */
>  	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
> -		xfs_iflush_abort(ip);
> +		xfs_iflush_abort(ip, NULL);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index aab55a06ece7..de8815211a7a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3612,7 +3612,7 @@ xfs_iflush_cluster(
> =20
>  	/*
>  	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> -	 * can remove itself from the list.
> +	 * will remove itself from the list.
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip =3D (struct xfs_inode_log_item *)lip;
> @@ -3662,7 +3662,7 @@ xfs_iflush_cluster(
>  		 */
>  		if (xlog_is_shutdown(mp->m_log)) {
>  			xfs_iunpin_wait(ip);
> -			xfs_iflush_abort(ip);
> +			xfs_iflush_abort(ip, bp);
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			error =3D -EIO;
>  			continue;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 11158fa81a09..89fa1fd9ed5b 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -721,17 +721,6 @@ xfs_iflush_ail_updates(
>  		if (INODE_ITEM(lip)->ili_flush_lsn !=3D lip->li_lsn)
>  			continue;
> =20
> -		/*
> -		 * dgc: Not sure how this happens, but it happens very
> -		 * occassionaly via generic/388.  xfs_iflush_abort() also
> -		 * silently handles this same "under writeback but not in AIL at
> -		 * shutdown" condition via xfs_trans_ail_delete().
> -		 */
> -		if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
> -			ASSERT(xlog_is_shutdown(lip->li_log));
> -			continue;
> -		}
> -
>  		lsn =3D xfs_ail_delete_one(ailp, lip);
>  		if (!tail_lsn && lsn)
>  			tail_lsn =3D lsn;
> @@ -799,7 +788,7 @@ xfs_buf_inode_iodone(
>  		struct xfs_inode_log_item *iip =3D INODE_ITEM(lip);
> =20
>  		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> -			xfs_iflush_abort(iip->ili_inode);
> +			xfs_iflush_abort(iip->ili_inode, bp);
>  			continue;
>  		}
>  		if (!iip->ili_last_fields)
> @@ -834,44 +823,98 @@ xfs_buf_inode_io_fail(
>  }
> =20
>  /*
> - * This is the inode flushing abort routine.  It is called when
> - * the filesystem is shutting down to clean up the inode state.  It is
> - * responsible for removing the inode item from the AIL if it has not be=
en
> - * re-logged and clearing the inode's flush state.
> + * Abort flushing the inode.
> + *
> + * There are two cases where this is called. The first is when the inode=
 cluster
> + * buffer has been removed and the inodes attached to it have been marked
> + * XFS_ISTALE. Inode cluster buffer IO completion will be called on the =
buffer to mark the stale
> + * inodes clean and remove them from the AIL without doing IO on them. T=
he inode
> + * should always have a log item attached if it is ISTALE, and we should=
 always
> + * be passed the locked buffer the inodes are attached to.
> + *
> + * The second case is log shutdown. When the log has been shut down, we =
need
> + * to abort any flush that is in progress, mark the inode clean and remo=
ve it
> + * from the AIL. We may get passed clean inodes without log items, as we=
ll as
> + * clean inodes with log items that aren't attached to cluster buffers. =
And
> + * depending on whether we are called from, we may or may not have a loc=
ked
> + * buffer passed to us.
> + *
> + * If we don't have a locked buffer, we try to get it from the inode log=
 item.
> + * If there is a buffer attached to the ili, then we have a reference to=
 the
> + * buffer and we can safely lock it, then remove the inode from the buff=
er.
>   */
>  void
>  xfs_iflush_abort(
> -	struct xfs_inode	*ip)
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*locked_bp)
>  {
>  	struct xfs_inode_log_item *iip =3D ip->i_itemp;
> -	struct xfs_buf		*bp =3D NULL;
> +	struct xfs_buf		*ibp;
> =20
> -	if (iip) {
> -		/*
> -		 * Clear the failed bit before removing the item from the AIL so
> -		 * xfs_trans_ail_delete() doesn't try to clear and release the
> -		 * buffer attached to the log item before we are done with it.
> -		 */
> -		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> -		xfs_trans_ail_delete(&iip->ili_item, 0);
> +	if (!iip) {
> +		/* clean inode, nothing to do */
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		return;
> +	}
> =20
> -		/*
> -		 * Clear the inode logging fields so no more flushes are
> -		 * attempted.
> -		 */
> -		spin_lock(&iip->ili_lock);
> -		iip->ili_last_fields =3D 0;
> -		iip->ili_fields =3D 0;
> -		iip->ili_fsync_fields =3D 0;
> -		iip->ili_flush_lsn =3D 0;
> -		bp =3D iip->ili_item.li_buf;
> -		iip->ili_item.li_buf =3D NULL;
> -		list_del_init(&iip->ili_item.li_bio_list);
> +	/*
> +	 * Capture the associated buffer and lock it if the caller didn't
> +	 * pass us the locked buffer to begin with.
> +	 */
> +	spin_lock(&iip->ili_lock);
> +	ibp =3D iip->ili_item.li_buf;
> +	if (!locked_bp && ibp) {
> +		xfs_buf_hold(ibp);
>  		spin_unlock(&iip->ili_lock);
> +		xfs_buf_lock(ibp);
> +		spin_lock(&iip->ili_lock);
> +		if (!iip->ili_item.li_buf) {
> +			/*
> +			 * Raced with another removal, hold the only reference
> +			 * to ibp now.
> +			 */
> +			ASSERT(list_empty(&iip->ili_item.li_bio_list));
> +		} else {
> +			/*
> +			 * Got two references to ibp, drop one now. The other
> +			 * ges dropped when we are done.
> +			 */
> +			ASSERT(iip->ili_item.li_buf =3D=3D ibp);
> +			xfs_buf_rele(ibp);
> +		}
> +	} else {
> +		ASSERT(!ibp || ibp =3D=3D locked_bp);
>  	}
> +
> +	/*
> +	 * Clear the inode logging fields so no more flushes are attempted.
> +	 * If we are on a buffer list, it is now safe to remove it because
> +	 * the buffer is guaranteed to be locked.
> +	 */
> +	iip->ili_last_fields =3D 0;
> +	iip->ili_fields =3D 0;
> +	iip->ili_fsync_fields =3D 0;
> +	iip->ili_flush_lsn =3D 0;
> +	iip->ili_item.li_buf =3D NULL;
> +	list_del_init(&iip->ili_item.li_bio_list);
> +	spin_unlock(&iip->ili_lock);
> +
> +	/*
> +	 * Clear the failed bit before removing the item from the AIL so
> +	 * xfs_trans_ail_delete() doesn't try to clear and release the buffer
> +	 * attached to the log item before we are done with it.
> +	 */
> +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> +	xfs_trans_ail_delete(&iip->ili_item, 0);
> +
>  	xfs_iflags_clear(ip, XFS_IFLUSHING);
> -	if (bp)
> -		xfs_buf_rele(bp);
> +
> +	/* we can now release the buffer reference the inode log item held. */
> +	if (ibp) {
> +		if (!locked_bp)
> +			xfs_buf_unlock(ibp);
> +		xfs_buf_rele(ibp);
> +	}
>  }
> =20
>  /*
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 1a302000d604..01e5845c7f3d 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -43,7 +43,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
> =20
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
> -extern void xfs_iflush_abort(struct xfs_inode *);
> +extern void xfs_iflush_abort(struct xfs_inode *, struct xfs_buf *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
> =20
>=20

