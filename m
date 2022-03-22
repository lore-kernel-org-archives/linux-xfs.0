Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E921BC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbiCVVnq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbiCVVnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 17:43:35 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8B7A5F27A
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 14:41:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E199F53380C;
        Wed, 23 Mar 2022 08:41:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWmGI-008fMV-1H; Wed, 23 Mar 2022 08:41:54 +1100
Date:   Wed, 23 Mar 2022 08:41:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] log I/O completion GPF via xfs/006 and xfs/264 on
 5.17.0-rc8
Message-ID: <20220322214154.GP1544202@dread.disaster.area>
References: <YjSNTd+U3HBq/Gsv@bfoster>
 <YjSvG0wgm6epCa8X@bfoster>
 <20220318214253.GG1544202@dread.disaster.area>
 <YjjFaU/uGHALNVlx@bfoster>
 <20220321221433.GJ1544202@dread.disaster.area>
 <YjneHEoFRDXu+EcA@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YjneHEoFRDXu+EcA@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623a42a4
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zDMyzNlgUVkXl21tx38A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 10:33:00AM -0400, Brian Foster wrote:
> On Tue, Mar 22, 2022 at 09:14:33AM +1100, Dave Chinner wrote:
> > On Mon, Mar 21, 2022 at 02:35:21PM -0400, Brian Foster wrote:
> > > On Sat, Mar 19, 2022 at 08:42:53AM +1100, Dave Chinner wrote:
> > > > On Fri, Mar 18, 2022 at 12:11:07PM -0400, Brian Foster wrote:
> > > > > On Fri, Mar 18, 2022 at 09:46:53AM -0400, Brian Foster wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I'm not sure if this is known and/or fixed already, but it didn't look
> > > > > > familiar so here is a report. I hit a splat when testing Willy's
> > > > > > prospective folio bookmark change and it turns out it replicates on
> > > > > > Linus' current master (551acdc3c3d2). This initially reproduced on
> > > > > > xfs/264 (mkfs defaults) and I saw a soft lockup warning variant via
> > > > > > xfs/006, but when I attempted to reproduce the latter a second time I
> > > > > > hit what looks like the same problem as xfs/264. Both tests seem to
> > > > > > involve some form of error injection, so possibly the same underlying
> > > > > > problem. The GPF splat from xfs/264 is below.
> > > > > > 
> > > > > 
> > > > > Darrick pointed out this [1] series on IRC (particularly the final
> > > > > patch) so I gave that a try. I _think_ that addresses the GPF issue
> > > > > given it was nearly 100% reproducible before and I didn't see it in a
> > > > > few iterations, but once I started a test loop for a longer test I ran
> > > > > into the aforementioned soft lockup again. A snippet of that one is
> > > > > below [2]. When this occurs, the task appears to be stuck (i.e. the
> > > > > warning repeats) indefinitely.
> > > > > 
> > > > > Brian
> > > > > 
> > > > > [1] https://lore.kernel.org/linux-xfs/20220317053907.164160-1-david@fromorbit.com/
> > > > > [2] Soft lockup warning from xfs/264 with patches from [1] applied:
> > > > > 
> > > > > watchdog: BUG: soft lockup - CPU#52 stuck for 134s! [kworker/52:1H:1881]
> > > > > Modules linked in: rfkill rpcrdma sunrpc intel_rapl_msr intel_rapl_common rdma_ucm ib_srpt ib_isert iscsi_target_mod i10nm_edac target_core_mod x86_pkg_temp_thermal intel_powerclamp ib_iser coretemp libiscsi scsi_transport_iscsi kvm_intel rdma_cm ib_umad ipmi_ssif ib_ipoib iw_cm ib_cm kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul acpi_ipmi mlx5_ib ghash_clmulni_intel bnxt_re ipmi_si rapl intel_cstate ib_uverbs ipmi_devintf mei_me isst_if_mmio isst_if_mbox_pci i2c_i801 nd_pmem ib_core intel_uncore wmi_bmof pcspkr isst_if_common mei i2c_smbus intel_pch_thermal ipmi_msghandler nd_btt dax_pmem acpi_power_meter xfs libcrc32c sd_mod sg mlx5_core lpfc mgag200 i2c_algo_bit drm_shmem_helper nvmet_fc drm_kms_helper nvmet nvme_fc mlxfw nvme_fabrics syscopyarea sysfillrect pci_hyperv_intf sysimgblt fb_sys_fops nvme_core ahci tls t10_pi libahci crc32c_intel psample scsi_transport_fc bnxt_en drm megaraid_sas tg3 libata wmi nfit libnvdimm dm_mirror dm_region_hash
> > > > >  dm_log dm_mod
> > > > > CPU: 52 PID: 1881 Comm: kworker/52:1H Tainted: G S           L    5.17.0-rc8+ #17
> > > > > Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
> > > > > Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> > > > > RIP: 0010:native_queued_spin_lock_slowpath+0x1b0/0x1e0
> > > > > Code: c1 e9 12 83 e0 03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 40 0d 03 00 48 03 04 cd e0 ba 00 8c 48 89 10 8b 42 08 85 c0 75 09 f3 90 <8b> 42 08 85 c0 74 f7 48 8b 0a 48 85 c9 0f 84 6b ff ff ff 0f 0d 09
> > > > > RSP: 0018:ff4ed0b360e4bb48 EFLAGS: 00000246
> > > > > RAX: 0000000000000000 RBX: ff3413f05c684540 RCX: 0000000000001719
> > > > > RDX: ff34142ebfeb0d40 RSI: ffffffff8bf826f6 RDI: ffffffff8bf54147
> > > > > RBP: ff34142ebfeb0d40 R08: ff34142ebfeb0a68 R09: 00000000000001bc
> > > > > R10: 00000000000001d1 R11: 0000000000000abd R12: 0000000000d40000
> > > > > R13: 0000000000000008 R14: ff3413f04cd84000 R15: ff3413f059404400
> > > > > FS:  0000000000000000(0000) GS:ff34142ebfe80000(0000) knlGS:0000000000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: 00007f9200514f70 CR3: 0000000216c16005 CR4: 0000000000771ee0
> > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > PKRU: 55555554
> > > > > Call Trace:
> > > > >  <TASK>
> > > > >  _raw_spin_lock+0x2c/0x30
> > > > >  xfs_trans_ail_delete+0x2a/0xd0 [xfs]
> > > > 
> > > > So what is running around in a tight circle holding the AIL lock?
> > > > 
> > > > Or what assert failed before this while holding the AIL lock?
> > > > 
> > > 
> > > I don't have much information beyond the test and resulting bug. There
> > > are no assert failures before the bug occurs. An active CPU task dump
> > > shows the stack from the soft lockup warning, the task running the dump
> > > itself, and all other (94/96) CPUs appear idle. I tried the appended
> > > patch on top of latest for-next (which now includes the other log
> > > shutdown fix) and the problem still occurs.
> > 
> > Yeah, I got another assert fail in xfs_ail_check() last night from:
> > 
> >   xfs_ail_check+0xa8/0x180
> >   xfs_ail_delete_one+0x3b/0xf0
> >   xfs_buf_inode_iodone+0x329/0x3f0
> >   xfs_buf_ioend+0x1f8/0x530
> >   xfs_buf_ioend_work+0x15/0x20
> > 
> > Finding an item that didn't have IN_AIL set on it. I think I've
> > found another mount vs log shutdown case that can result in dirty
> > aborted inodes that aren't in the AIL being flushed and bad things
> > happen when we then try to remove them from the AIL and they aren't
> > there...
> > 
> > Whether that is this problem or not, I don't know, but the assert
> > failures do end up with other threads spinning on the AIL lock
> > because of the assert failures under the AIL lock...
> > 
> 
> Some updates.. I tried to reproduce with lock debugging and whatnot
> enabled but the problem was no longer reproducible, probably due to
> disruption of timing. When I went back to a reproducing kernel, I ended
> up seeing a page fault variant crash via xfs/006 instead of the soft
> lockup. This occurred shortly after the unmount attempt started, so I
> retried again with KASAN enabled but ran into the same heisenbug
> behavior. From there, I replaced the generic debug mechanisms with a
> custom mount flag to set in xfs_trans_ail_destroy() immediately after
> freeing the xfs_ail object and assert check on entry of
> xfs_trans_ail_delete(). The next xfs/006 failure produced the splat
> below [2]. I suspect that is the smoking gun [1] and perhaps we've
> somehow broken serialization between in-core object teardown and
> outstanding log I/O completion after the filesystem happens to shutdown.

OK, so the AIL has been torn down, then we are getting log IO
completing and being failed, trying to remove a buffer item from the
AIL?

xfs_log_unmount() does:

xfs_log_unmount(
        struct xfs_mount        *mp)
{
        xfs_log_clean(mp);

        xfs_buftarg_drain(mp->m_ddev_targp);

        xfs_trans_ail_destroy(mp);

And so the AIL cannot be destroyed if there are any active buffers
still in the system (e.g. being logged) - it will block until
xfs_buftarg_drain() returns with an empty buffer cache.

Which means this buffer is likely the superblock buffer - the only
buffer in the filesystem that isn't cached in the buffer cache but
is logged.

So I suspect we have:

xfs_log_unmount()
  xfs_log_clean()
    xfs_log_quiesce()
      xfs_log_cover()
      	xfs_sync_sb()
	xfs_ail_push_all_sync()
	

failing to push the superblock buffer into the AIL, so
xfs_log_cover() returns while the log IO is still in progress.
We then write an unmount record, which can silently fail to force
the iclog and so we get through xfs_log_clean() while the superblock
buffer is still attached to an iclog...

The buffer cache is empty, and then We then tear down the AIL,
only to have iclog callbacks run, fail the superblock buffer item
which is in the and try to remove the superblock
buffer from the AIL as it's releasing the last reference to the
buf log item...

This is convoluted, but I think it can happen if we get a iclog IO
error on the log force from xfs_sync_sb(). I think the key thing
is how the log is shut down and wakeups processed in
xlog_force_shutdown....

> [1] I've not reproduced the soft lockup variant with this hack in place,
> but if the problem is a UAF then I'd expect the resulting behavior to be
> somewhat erratic/unpredictable.
> 
> [2] xfs/006 custom assert and BUG splat:
> 
> XFS: Assertion failed: !mp->m_freed_ail, file: fs/xfs/xfs_trans_ail.c, line: 879
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 1289 at fs/xfs/xfs_message.c:97 asswarn+0x1a/0x1d [xfs]
> Modules linked in: rfkill rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm intel_rapl_msr iTCO_wdt iTCO_vendor_support inth
>  dm_log dm_mod
> CPU: 2 PID: 1289 Comm: kworker/2:1H Tainted: G S                5.17.0-rc6+ #29
> Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.2.4 05/28/2021
> Workqueue: xfs-log/dm-5 xlog_ioend_work [xfs]
> RIP: 0010:asswarn+0x1a/0x1d [xfs]
> Code: e8 e8 13 8c c4 48 83 c4 60 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 c0 a0 d8 c0 e8 19 fd ff ff <0f> 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 c0 a0
> RSP: 0018:ff5757be8f37fb70 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ff4847238f4b2940 RCX: 0000000000000000
> RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0d7e076
> RBP: ff4847341d6a0f80 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000000a R11: f000000000000000 R12: 0000000200002600
> R13: ff484724b1c35000 R14: 0000000000000008 R15: ff4847238f4b2940
> FS:  0000000000000000(0000) GS:ff484761ffc40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f55c21f0f70 CR3: 0000000142c9c002 CR4: 0000000000771ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  xfs_trans_ail_delete+0x102/0x130 [xfs]
>  xfs_buf_item_done+0x22/0x30 [xfs]
>  xfs_buf_ioend+0x73/0x4d0 [xfs]
>  xfs_trans_committed_bulk+0x17e/0x2f0 [xfs]
>  ? enqueue_task_fair+0x91/0x680
>  ? remove_entity_load_avg+0x2e/0x70
>  ? __wake_up_common_lock+0x87/0xc0
>  xlog_cil_committed+0x2a9/0x300 [xfs]
>  ? __wake_up_common_lock+0x87/0xc0
>  xlog_cil_process_committed+0x69/0x80 [xfs]
>  xlog_state_shutdown_callbacks+0xce/0xf0 [xfs]
>  xlog_force_shutdown+0xdf/0x150 [xfs]
>  xfs_do_force_shutdown+0x5f/0x150 [xfs]
>  xlog_ioend_work+0x71/0x80 [xfs]

OK, so this is processing an EIO error to a log write, and it's
triggering a force shutdown. THis cause the log to be shut down,
and then it is running attached iclog callbacks from the shutdown
context. That means the fs and log has already been marked as
xfs_is_shutdown/xlog_is_shutdown and so high level code will abort
(e.g. xfs_trans_commit(), xfs_log_force(), etc) with an error
because of shutdown. That's the first thing we need for
xfs_sync_sb() to exit without waiting for the superblock buffer to
be comitted to disk above.

The second is xlog_state_shutdown_callbacks() doing this:

{
        struct xlog_in_core     *iclog;
        LIST_HEAD(cb_list);

        spin_lock(&log->l_icloglock);
        iclog = log->l_iclog;
        do {
                if (atomic_read(&iclog->ic_refcnt)) {
                        /* Reference holder will re-run iclog callbacks. */
                        continue;
                }
                list_splice_init(&iclog->ic_callbacks, &cb_list);
>>>>>>           wake_up_all(&iclog->ic_write_wait);
>>>>>>           wake_up_all(&iclog->ic_force_wait);
        } while ((iclog = iclog->ic_next) != log->l_iclog);

        wake_up_all(&log->l_flush_wait);
        spin_unlock(&log->l_icloglock);

>>>>>>  xlog_cil_process_committed(&cb_list);
}

It wakes forces waiters before shutdown processes all the pending
callbacks.  That means the xfs_sync_sb() waiting on a sync
transaction in xfs_log_force() on iclog->ic_force_wait will get
woken before the callbacks attached to that iclog are run. Normally
this is just fine because the force waiter has nothing to do with
AIL operations. But in the case of this unmount path, the log force
waiter goes on to tear down the AIL because the log is now shut down
and nothing ever blocks it again from the wait point in
xfs_log_cover().

Hence it's a race to see who gets to the AIL first - the unmount
code or xlog_cil_process_committed() killing the superblock buffer.

So that's the bug, and it has nothing to do with any of the other
shutdown issues I'm trying to sort out right now. I'll add it to the
list.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
