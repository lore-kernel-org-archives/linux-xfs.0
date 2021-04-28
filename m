Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F635C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434CB613FB
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 07:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbhD1Hd3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:33:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29519 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237055AbhD1Hd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 03:33:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619595161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=plBrPmaOYUZcFGpPDxdwzsJhMPTiet6x2iNIdQNk6pQ=;
        b=LlhITI9F8uX6k7hizP1sEZoasboM6z7pbfLstdVrjfhRt0WRfTKN0rNUnV0JVDAGLevccq
        vnrDw2d7BHrhP8D1nrWRotzq0MZhh3czzv4PUBh1VSgXDPR9AeD3yU2QzEu/+9L4QQHTrE
        PZgahBdCcN854/GIP+7haa0iraCvqxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-jKidKecaPMe9FgqzlOMCnw-1; Wed, 28 Apr 2021 03:32:39 -0400
X-MC-Unique: jKidKecaPMe9FgqzlOMCnw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C82A1020C39;
        Wed, 28 Apr 2021 07:32:38 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D848E2CD;
        Wed, 28 Apr 2021 07:32:27 +0000 (UTC)
Date:   Wed, 28 Apr 2021 15:49:50 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <20210428074950.GY13946@localhost.localdomain>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
 <20210427030715.GE1251862@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427030715.GE1251862@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 26, 2021 at 08:07:15PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Keep the mount superblock counters up to date for !lazysbcount
> > filesystems so that when we log the superblock they do not need
> > updating in any way because they are already correct.
> > 
> > It's found by what Zorro reported:
> > 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> > 2. mount $dev $mnt
> > 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> > 4. umount $mnt
> > 5. xfs_repair -n $dev
> > and I've seen no problem with this patch.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > 
> > As per discussion earilier [1], use the way Dave suggested instead.
> > Also update the line to
> > 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > so it can fix the case above.
> > 
> > with XFS debug off, xfstests auto testcases fail on my loop-device-based
> > testbed with this patch and Darrick's [2]:
> > 
> > generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
> > xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515
> 
> Hmm, with the following four patches applied:
> 
> https://lore.kernel.org/linux-xfs/20210427000204.GC3122264@magnolia/T/#u
> https://lore.kernel.org/linux-xfs/20210425225110.GD63242@dread.disaster.area/T/#t
> https://lore.kernel.org/linux-xfs/20210427011201.4175506-1-hsiangkao@redhat.com/T/#u
> https://lore.kernel.org/linux-xfs/20210427030232.GE3122264@magnolia/T/#u

Hi,

I've given above 4 patches a regression test, include:
1) xfstests with different blocksize, on v5 v4 or v4+!lazy-count xfs, on different
arches(aarch64, x86_64, ppc64le). (Even with DAX enabled)
2) LTP on v5 v4 or v4+!lazy-count xfs, on different arches.
3) Some Red Hat internal fs functional and stress test (fio, racing, fsx, powerfailure,
pjd-fstest, known bug reproducers, etc ...)

I didn't find any critical issues. Some failures/warning I hit looks not from
filesystem, or not regression issue from these patches. xfs/491 and xfs/492
failed as you metioned below.

There's a kernel panic[1] on ppc64le by xfs/353, I can't make sure about that.
I hit it once, and reproduced it once on ppc64le. But I only hit it with lazy-count=0,
I can't(haven't) reproduce it on lazy-count enabled XFS.

More testing jobs which need longer time are still running, I'll feedback if I find
something wrong.

Thanks,
Zorro

[  964.972840] XFS (sda3): AG 0: Corrupt btree 0 pointer at level 1 index 0. 
[  964.972903] XFS (sda3): AG 0: Corrupt btree 0 pointer at level 1 index 0. 
[-- MARK -- Wed Apr 28 06:30:00 2021] 
[  974.500326] Kernel attempted to read user page (10) - exploit attempt? (uid: 0) 
[  974.500356] BUG: Kernel NULL pointer dereference on read at 0x00000010 
[  974.500365] Faulting instruction address: 0xc008000001cf6598 
[  974.500374] Oops: Kernel access of bad area, sig: 11 [#1] 
[  974.500379] LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries 
[  974.500386] Modules linked in: bonding tls rfkill sunrpc uio_pdrv_genirq uio pseries_rng drm fuse drm_panel_orientation_quirks ip_tables xfs libcrc32c sd_mod t10_pi ibmvscsi xts ibmveth scsi_transport_srp vmx_crypto 
[  974.500422] CPU: 2 PID: 242710 Comm: xfs_scrub Not tainted 5.12.0-rc4+ #1 
[  974.500429] NIP:  c008000001cf6598 LR: c008000001df3b9c CTR: 0000000000000000 
[  974.500435] REGS: c0000000afb1f5e0 TRAP: 0300   Not tainted  (5.12.0-rc4+) 
[  974.500441] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002800  XER: 00000004 
[  974.500457] CFAR: c00000000000fd30 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0  
[  974.500457] GPR00: c008000001df3b9c c0000000afb1f880 c008000001e79600 0000000000000000  
[  974.500457] GPR04: c0000000afb1f8b8 0000000000000003 c0000000afb1f924 0000000000000079  
[  974.500457] GPR08: 000000000000000c 0000000000000000 0000000000000000 0000000000000000  
[  974.500457] GPR12: 0000000024002800 c00000001ecad680 0000000000000000 0000000000000000  
[  974.500457] GPR16: 0000000000000000 0000000000000000 0000000000000000 00007fffc1bae262  
[  974.500457] GPR20: 0000000000000000 0000000000000001 c000000020f08600 0000000000000009  
[  974.500457] GPR24: 0000000000000000 c0000000afb1fac0 c000000024eb1b00 c0000000afb1f924  
[  974.500457] GPR28: c008000001cea7c0 0000000000000000 0000000000000003 c00000000d0cb800  
[  974.500536] NIP [c008000001cf6598] xfs_btree_visit_blocks+0x60/0x220 [xfs] 
[  974.500635] LR [c008000001df3b9c] xchk_fscount_aggregate_agcounts+0x304/0x500 [xfs] 
[  974.500733] Call Trace: 
[  974.500736] [c0000000afb1f880] [c008000001deee38] xchk_ag_btcur_init+0x180/0x2e0 [xfs] (unreliable) 
[  974.500838] [c0000000afb1f900] [c008000001df3b9c] xchk_fscount_aggregate_agcounts+0x304/0x500 [xfs] 
[  974.500929] [c0000000afb1f990] [c008000001df3f38] xchk_fscounters+0xf0/0x270 [xfs] 
[  974.500999] [c0000000afb1fa10] [c008000001df9d68] xfs_scrub_metadata+0x290/0x650 [xfs] 
[  974.501070] [c0000000afb1fb50] [c008000001d7020c] xfs_ioc_scrub_metadata+0x74/0x100 [xfs] 
[  974.501139] [c0000000afb1fbd0] [c008000001d747dc] xfs_file_ioctl+0xbb4/0x1408 [xfs] 
[  974.501207] [c0000000afb1fd60] [c0000000005dea34] sys_ioctl+0x134/0x190 
[  974.501215] [c0000000afb1fdb0] [c000000000032e84] system_call_exception+0x154/0x290 
[  974.501222] [c0000000afb1fe10] [c00000000000cd70] system_call_vectored_common+0xf0/0x268 
[  974.501228] --- interrupt: 3000 at 0x7fffbaa286c4 
[  974.501232] NIP:  00007fffbaa286c4 LR: 0000000000000000 CTR: 0000000000000000 
[  974.501237] REGS: c0000000afb1fe80 TRAP: 3000   Not tainted  (5.12.0-rc4+) 
[  974.501241] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 24002804  XER: 00000000 
[  974.501258] IRQMASK: 0  
[  974.501258] GPR00: 0000000000000036 00007fffc1bab540 00007fffbab17200 0000000000000003  
[  974.501258] GPR04: 00000000c040583c 00007fffc1bab6b0 000000000000004d 0000000000000053  
[  974.501258] GPR08: 0000000000100000 0000000000000000 0000000000000000 0000000000000000  
[  974.501258] GPR12: 0000000000000000 00007fffbac3b070 0000000000000000 0000000000000000  
[  974.501258] GPR16: 0000000000000000 0000000000000000 0000000000000000 00007fffc1bae262  
[  974.501258] GPR20: 000000001001d9c8 000000001001d998 0000000010040558 000000001001c3d0  
[  974.501258] GPR24: 000000000000000b 00007fffc1baba80 00007fffbab11770 0000000000000000  
[  974.501258] GPR28: 0000000000000000 00007fffc1bab8e0 00007fffc1bab6b0 0000000000000007  
[  974.501315] NIP [00007fffbaa286c4] 0x7fffbaa286c4 
[  974.501319] LR [0000000000000000] 0x0 
[  974.501322] --- interrupt: 3000 
[  974.501325] Instruction dump: 
[  974.501329] 7c7d1b78 39400000 7cbe2b78 7cdb3378 f8010010 91810008 f821ff81 e92d1100  
[  974.501340] f9210048 39200000 38810038 f9410040 <e9230010> e9890068 f8410018 7d8903a6  
[  974.501353] ---[ end trace bfc97417fdf1b1b9 ]--- 
[  974.509997]  
[  974.510000] BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49 
[  974.510005] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 242710, name: xfs_scrub 
[  974.510010] INFO: lockdep is turned off. 
[  974.510013] irq event stamp: 8494 
[  974.510016] hardirqs last  enabled at (8493): [<c000000000fcca94>] _raw_spin_unlock_irqrestore+0x94/0xd0 
[  974.510023] hardirqs last disabled at (8494): [<c00000000009948c>] interrupt_enter_prepare.constprop.0+0xac/0x180 
[  974.510031] softirqs last  enabled at (7526): [<c008000001d52064>] __rhashtable_insert_fast.constprop.0+0x3dc/0x7c0 [xfs] 
[  974.510099] softirqs last disabled at (7524): [<c008000001d51da0>] __rhashtable_insert_fast.constprop.0+0x118/0x7c0 [xfs] 
[  974.510166] CPU: 2 PID: 242710 Comm: xfs_scrub Tainted: G      D           5.12.0-rc4+ #1 
[  974.510171] Call Trace: 
[  974.510173] [c0000000afb1f260] [c0000000008b38e4] dump_stack+0xe8/0x144 (unreliable) 
[  974.510182] [c0000000afb1f2b0] [c0000000001b3098] ___might_sleep+0x2e8/0x300 
[  974.510188] [c0000000afb1f340] [c0000000001803fc] exit_signals+0x4c/0x490 
[  974.510195] [c0000000afb1f390] [c00000000016aabc] do_exit+0xfc/0x720 
[  974.510201] [c0000000afb1f420] [c00000000002c75c] oops_end+0x18c/0x1c0 
[  974.510208] [c0000000afb1f4a0] [c000000000092940] __bad_page_fault+0x178/0x198 
[  974.510215] [c0000000afb1f510] [c00000000009268c] hash__do_page_fault+0xac/0xb0 
[  974.510221] [c0000000afb1f540] [c00000000009b488] do_hash_fault+0x58/0x80 
[  974.510227] [c0000000afb1f570] [c000000000008994] data_access_common_virt+0x194/0x1f0 
[  974.510233] --- interrupt: 300 at xfs_btree_visit_blocks+0x60/0x220 [xfs] 
[  974.510293] NIP:  c008000001cf6598 LR: c008000001df3b9c CTR: 0000000000000000 
[  974.510298] REGS: c0000000afb1f5e0 TRAP: 0300   Tainted: G      D            (5.12.0-rc4+) 
[  974.510302] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002800  XER: 00000004 
[  974.510314] CFAR: c00000000000fd30 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0  
[  974.510314] GPR00: c008000001df3b9c c0000000afb1f880 c008000001e79600 0000000000000000  
[  974.510314] GPR04: c0000000afb1f8b8 0000000000000003 c0000000afb1f924 0000000000000079  
[  974.510314] GPR08: 000000000000000c 0000000000000000 0000000000000000 0000000000000000  
[  974.510314] GPR12: 0000000024002800 c00000001ecad680 0000000000000000 0000000000000000  
[  974.510314] GPR16: 0000000000000000 0000000000000000 0000000000000000 00007fffc1bae262  
[  974.510314] GPR20: 0000000000000000 0000000000000001 c000000020f08600 0000000000000009  
[  974.510314] GPR24: 0000000000000000 c0000000afb1fac0 c000000024eb1b00 c0000000afb1f924  
[  974.510314] GPR28: c008000001cea7c0 0000000000000000 0000000000000003 c00000000d0cb800  
[  974.510376] NIP [c008000001cf6598] xfs_btree_visit_blocks+0x60/0x220 [xfs] 
[  974.510436] LR [c008000001df3b9c] xchk_fscount_aggregate_agcounts+0x304/0x500 [xfs] 
[  974.510506] --- interrupt: 300 
[  974.510509] [c0000000afb1f880] [c008000001deee38] xchk_ag_btcur_init+0x180/0x2e0 [xfs] (unreliable) 
[  974.510581] [c0000000afb1f900] [c008000001df3b9c] xchk_fscount_aggregate_agcounts+0x304/0x500 [xfs] 
[  974.510652] [c0000000afb1f990] [c008000001df3f38] xchk_fscounters+0xf0/0x270 [xfs] 
[  974.510723] [c0000000afb1fa10] [c008000001df9d68] xfs_scrub_metadata+0x290/0x650 [xfs] 
[  974.510793] [c0000000afb1fb50] [c008000001d7020c] xfs_ioc_scrub_metadata+0x74/0x100 [xfs] 
[  974.510861] [c0000000afb1fbd0] [c008000001d747dc] xfs_file_ioctl+0xbb4/0x1408 [xfs] 
[  974.510930] [c0000000afb1fd60] [c0000000005dea34] sys_ioctl+0x134/0x190 
[  974.510936] [c0000000afb1fdb0] [c000000000032e84] system_call_exception+0x154/0x290 
[  974.510942] [c0000000afb1fe10] [c00000000000cd70] system_call_vectored_common+0xf0/0x268 
[  974.510948] --- interrupt: 3000 at 0x7fffbaa286c4 
[  974.510952] NIP:  00007fffbaa286c4 LR: 0000000000000000 CTR: 0000000000000000 
[  974.510956] REGS: c0000000afb1fe80 TRAP: 3000   Tainted: G      D            (5.12.0-rc4+) 
[  974.510961] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 24002804  XER: 00000000 
[  974.510977] IRQMASK: 0  
[  974.510977] GPR00: 0000000000000036 00007fffc1bab540 00007fffbab17200 0000000000000003  
[  974.510977] GPR04: 00000000c040583c 00007fffc1bab6b0 000000000000004d 0000000000000053  
[  974.510977] GPR08: 0000000000100000 0000000000000000 0000000000000000 0000000000000000  
[  974.510977] GPR12: 0000000000000000 00007fffbac3b070 0000000000000000 0000000000000000  
[  974.510977] GPR16: 0000000000000000 0000000000000000 0000000000000000 00007fffc1bae262  
[  974.510977] GPR20: 000000001001d9c8 000000001001d998 0000000010040558 000000001001c3d0  
[  974.510977] GPR24: 000000000000000b 00007fffc1baba80 00007fffbab11770 0000000000000000  
[  974.510977] GPR28: 0000000000000000 00007fffc1bab8e0 00007fffc1bab6b0 0000000000000007  
[  974.511034] NIP [00007fffbaa286c4] 0x7fffbaa286c4 
[  974.511037] LR [0000000000000000] 0x0 
[  974.511040] --- interrupt: 3000 
[  985.036042] restraintd[708]: *** Current Time: Wed Apr 28 02:30:16 2021  Localwatchdog at: Thu Apr 29 14:16:15 2021 
[ 1045.030366] restraintd[708]: *** Current Time: Wed Apr 28 02:31:16 2021  Localwatchdog at: Thu Apr 29 14:16:15 2021 

> 
> I /think/ all the obvious problems with !lazysbcount filesystems are
> fixed.  The exceptions AFAICT are xfs/491 and xfs/492, which fuzz the
> summary counters; we'll deal with those later.



> 
> --D
> 
> > 
> > MKFS_OPTIONS="-mcrc=0 -llazy-count=0"
> > 
> > and these testcases above still fail without these patches or with
> > XFS debug on, so I've seen no regression due to this patch.
> > 
> > [1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
> > [2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/
> > 
> >  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
> >  fs/xfs/xfs_trans.c     |  3 +++
> >  2 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index 60e6d255e5e2..dfbbcbd448c1 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -926,9 +926,19 @@ xfs_log_sb(
> >  	struct xfs_mount	*mp = tp->t_mountp;
> >  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
> >  
> > -	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > -	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	/*
> > +	 * Lazy sb counters don't update the in-core superblock so do that now.
> > +	 * If this is at unmount, the counters will be exactly correct, but at
> > +	 * any other time they will only be ballpark correct because of
> > +	 * reservations that have been taken out percpu counters. If we have an
> > +	 * unclean shutdown, this will be corrected by log recovery rebuilding
> > +	 * the counters from the AGF block counts.
> > +	 */
> > +	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> > +		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> > +		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> > +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> > +	}
> >  
> >  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> >  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index bcc978011869..1e37aa8eca5a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
> >  
> >  	/* apply remaining deltas */
> >  	spin_lock(&mp->m_sb_lock);
> > +	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> > +	mp->m_sb.sb_icount += idelta;
> > +	mp->m_sb.sb_ifree += ifreedelta;
> >  	mp->m_sb.sb_frextents += rtxdelta;
> >  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
> >  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> > -- 
> > 2.27.0
> > 
> 

