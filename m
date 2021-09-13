Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501F5C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 21:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3841860EE5
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 21:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348267AbhIMVQx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 17:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245422AbhIMVQr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 17:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 084DA610CE;
        Mon, 13 Sep 2021 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631567730;
        bh=Ma2XV+8V8lshMn5e/qvSYYd7GqoIBVzNHRDD8gAPBxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XpuZo5eVbDLOVIeWuAR1gZ16vHG5iYKZKng9aCxmy8BEo/c7gGgCJS2kbNPPZwzLy
         JKwX68iGfOFUuNlW5RO7B/u3Q8guLPHQt4PqBFfAAnVKbeUFDB/lE/vVaIsoJEW3b0
         1SBSmNU7eV8i4C4FEvCcDUPpFW40Rsv6eqp8zS0GHLo7cNt8zoJggkVXFizqTRIQ8d
         yHULXVFfjXLVPFVWSlYF5o3gg7u3W4SXnyqfTKbITAOjlqU/Q0l3AaL+jXJFSRt57i
         SGgyFLNIe6vaYk1WqCV7yDxqy0+ZTRl6zAhJ4sWhHsHrx3kXMypjsXy/ERVSfVfilf
         hswqkO6xlBgpg==
Date:   Mon, 13 Sep 2021 14:15:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-xfs@vger.kernel.org, zlang@redhat.com
Subject: Re: XFS new panic after new merges
Message-ID: <20210913211529.GJ638503@magnolia>
References: <20210909030425.ql6ha5nfydvx7ece@xzhoux.usersys.redhat.com>
 <20210909121704.p2fymsus3pwufem3@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909121704.p2fymsus3pwufem3@xzhoux.usersys.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 09, 2021 at 08:17:04PM +0800, Murphy Zhou wrote:
> On Thu, Sep 09, 2021 at 11:04:25AM +0800, Murphy Zhou wrote:
> > Hi,
> > 
> > After this batch of updates in Linus tree,
> > 
> > eceae1e Merge tag 'configfs-5.15' of git://git.infradead.org/users/hch/configfs
> > 265113f Merge tag 'dlm-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
> > 111c1aa Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> > 815409a Merge tag 'ovl-update-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs
> > 412106c Merge tag 'erofs-for-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs
> > 89594c7 Merge tag 'fscache-next-20210829' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
> > 90c90cd Merge tag 'xfs-5.15-merge-6' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
> > 57c78a2 Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
> > bcfeebb Merge branch 'exit-cleanups-for-v5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
> > 4898370 Merge branch 'siginfo-si_trapno-for-v5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
> > 65266a7 Merge remote-tracking branch 'tip/sched/arm64' into for-next/core
> > 61dc131 Merge tag 'iomap-5.15-merge-2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > 
> > 
> > xfstests on xfs start to panic some times when running xfs/006 or xfs/264.
> > 
> > It's reproducible but not always. Sometimes on some servers 100 loops of
> > these tests pass. Sometimes it panics on the first run of xfs/006.
> > 
> > Due to it's not always reproducible, bisecting is not an option. And it's
> > hard to say it can not be reproduced on any condition. So far it can be
> > reproduced via these mkfs options:
> > 
> > crc=1 finobt=1,sparse=1,rmapbt=0 reflink=1,bigtime=0,inobtcount=0
> > or
> > crc=1 finobt=1,sparse=1,rmapbt=1 reflink=1,bigtime=0,inobtcount=0
> > or
> > crc=1 finobt=1,sparse=1,rmapbt=0 reflink=1,bigtime=1,inobtcount=1
> > or
> > crc=1 finobt=1,sparse=1,rmapbt=1 reflink=1,bigtime=1,inobtcount=1
> 
> Reproduced with:
> crc=0 finobt=0,sparse=0,rmapbt=0 reflink=0,bigtime=0,inobtcount=0
> 
> #xfs info:
> meta-data=/dev/sda4              isize=256    agcount=16, agsize=245696 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=3931136, imaxpct=25
>          =                       sunit=64     swidth=192 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=64 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # call traces:
> [  936.833349] run fstests xfs/264 at 2021-09-09 05:30:38 
> [  939.619013] XFS (dm-0): Mounting V4 Filesystem 
> [  939.754638] XFS (dm-0): Ending clean mount 
> [  939.773517] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff) 
> [  940.054513] XFS (dm-0): xlog_verify_grant_tail: space > BBTOB(tail_blocks) 
> [  947.346567] Buffer I/O error on dev dm-0, logical block 31457152, async page read 
> [  947.382053] Buffer I/O error on dev dm-0, logical block 31457153, async page read 
> [  947.416477] Buffer I/O error on dev dm-0, logical block 31457154, async page read 
> [  947.450734] Buffer I/O error on dev dm-0, logical block 31457155, async page read 
> [  947.484872] Buffer I/O error on dev dm-0, logical block 31457156, async page read 
> [  947.518948] Buffer I/O error on dev dm-0, logical block 31457157, async page read 
> [  947.553457] Buffer I/O error on dev dm-0, logical block 31457158, async page read 
> [  947.587913] Buffer I/O error on dev dm-0, logical block 31457159, async page read 
> [  947.711538] XFS (dm-0): Unmounting Filesystem 
> [  947.775594] XFS (dm-0): log I/O error -5 
> [  947.793587] XFS (dm-0): Log I/O Error (0x2) detected at xlog_ioend_work+0x60/0xb0 [xfs] (fs/xfs/xfs_log.c:1377).  Shutting down filesystem. 
> [  947.850642] XFS (dm-0): Please unmount the filesystem and rectify the problem(s) 
> [  947.969751] XFS (dm-0): Mounting V4 Filesystem 
> [  948.281026] XFS (dm-0): Starting recovery (logdev: internal) 
> [  948.415502] XFS (dm-0): Ending recovery (logdev: internal) 
> [  948.440958] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff) 
> [  948.490144] XFS (dm-0): Unmounting Filesystem 
> [  948.547763] XFS (dm-0): Mounting V4 Filesystem 
> [  948.697482] XFS (dm-0): Ending clean mount 
> [  948.716031] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff) 
> [  948.956457] XFS (dm-0): xlog_verify_grant_tail: space > BBTOB(tail_blocks) 
> [  959.464801] Buffer I/O error on dev dm-0, logical block 31457152, async page read 
> [  959.499451] Buffer I/O error on dev dm-0, logical block 31457153, async page read 
> [  959.533860] Buffer I/O error on dev dm-0, logical block 31457154, async page read 
> [  959.568015] Buffer I/O error on dev dm-0, logical block 31457155, async page read 
> [  959.601914] Buffer I/O error on dev dm-0, logical block 31457156, async page read 
> [  959.636180] Buffer I/O error on dev dm-0, logical block 31457157, async page read 
> [  959.670276] Buffer I/O error on dev dm-0, logical block 31457158, async page read 
> [  959.704800] Buffer I/O error on dev dm-0, logical block 31457159, async page read 
> [  959.828239] XFS (dm-0): Unmounting Filesystem 
> [  959.884350] XFS (dm-0): log I/O error -5 
> [  959.908497] BUG: unable to handle page fault for address: 0000000000784ca0 

Interesting... if you enable KASAN, does it have anything helpful to
report?  This kind of looks like the xfs_log_item could have been
recycled before we finished shutting down the log...?

--D

> [  959.939059] #PF: supervisor write access in kernel mode 
> [  959.962998] #PF: error_code(0x0002) - not-present page 
> [  959.987047] PGD 0 P4D 0  
> [  959.998392] Oops: 0002 [#1] SMP PTI 
> [  960.014227] CPU: 6 PID: 278 Comm: kworker/6:1H Kdump: loaded Not tainted 5.14.0+ #1 
> [  960.049489] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 09/18/2013 
> [  960.079784] Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs] 
> [  960.104130] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x15f/0x190 
> [  960.134590] Code: f3 90 48 8b 31 48 85 f6 74 f6 eb d9 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 40 94 02 00 48 03 04 f5 80 2a 21 83 <48> 89 08 8b 41 08 85 c0 75 09 f3 90 8b 41 08 85 c0 74 f7 48 8b 31 
> [  960.220279] RSP: 0018:ffffba7203a5fb90 EFLAGS: 00010206 
> [  960.244282] RAX: 0000000000784ca0 RBX: 0000000b00003800 RCX: ffff9827ef629440 
> [  960.278921] RDX: ffff982432186cc0 RSI: 0000000000003aa5 RDI: ffff982432186cc0 
> [  960.311690] RBP: ffff982430072b58 R08: 00000000001c0000 R09: ffff98240052e3e8 
> [  960.344228] R10: 0000000000000035 R11: 00000000006b2112 R12: ffff982432186c80 
> [  960.377161] R13: ffff982432186cc0 R14: 0000000000000008 R15: ffff9820c424f000 
> [  960.409632] FS:  0000000000000000(0000) GS:ffff9827ef600000(0000) knlGS:0000000000000000 
> [  960.446075] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> [  960.472285] CR2: 0000000000784ca0 CR3: 00000004431cc002 CR4: 00000000001706e0 
> [  960.505219] Call Trace: 
> [  960.516170]  _raw_spin_lock+0x1a/0x20 
> [  960.532960]  xfs_trans_ail_delete+0x29/0x100 [xfs] 
> [  960.554808]  xfs_buf_item_done+0x24/0x30 [xfs] 
> [  960.575268]  xfs_buf_ioend+0x72/0x1d0 [xfs] 
> [  960.594423]  xfs_trans_committed_bulk+0x18e/0x300 [xfs] 
> [  960.618208]  ? select_idle_sibling+0x3f4/0x4d0 
> [  960.638689]  ? enqueue_task+0x4b/0x140 
> [  960.655919]  ? check_preempt_curr+0x2f/0x70 
> [  960.675101]  ? ttwu_do_wakeup+0x17/0x150 
> [  960.693280]  ? try_to_wake_up+0x1cd/0x4d0 
> [  960.711314]  ? __wake_up_common_lock+0x8a/0xc0 
> [  960.731621]  ? __raw_callee_save___native_queued_spin_unlock+0x11/0x1e 
> [  960.761348]  xlog_cil_committed+0x15d/0x190 [xfs] 
> [  960.782956]  xlog_cil_process_committed+0x57/0x80 [xfs] 
> [  960.806288]  xlog_state_shutdown_callbacks+0xd0/0xf0 [xfs] 
> [  960.831350]  xlog_force_shutdown+0xe5/0x160 [xfs] 
> [  960.852604]  xfs_do_force_shutdown+0x51/0x130 [xfs] 
> [  960.874967]  xlog_ioend_work+0x60/0xb0 [xfs] 
> [  960.894218]  process_one_work+0x1eb/0x390 
> [  960.912442]  worker_thread+0x53/0x3d0 
> [  960.928900]  ? process_one_work+0x390/0x390 
> [  960.947735]  kthread+0x10f/0x130 
> [  960.962145]  ? set_kthread_struct+0x40/0x40 
> [  960.980946]  ret_from_fork+0x22/0x30 
> [  960.996965] Modules linked in: dm_mod tls rfkill intel_rapl_msr intel_rapl_common iTCO_wdt sb_edac iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass rapl mgag200 intel_cstate i2c_algo_bit drm_kms_helper intel_uncore pcspkr syscopyarea sysfillrect sysimgblt sunrpc ipmi_ssif fb_sys_fops lpc_ich cec hpilo ioatdma acpi_ipmi dca ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c ata_generic sd_mod t10_pi sg ata_piix crct10dif_pclmul crc32_pclmul crc32c_intel libata ghash_clmulni_intel tg3 serio_raw hpsa hpwdt scsi_transport_sas 
> [  961.246844] CR2: 0000000000784ca0 
