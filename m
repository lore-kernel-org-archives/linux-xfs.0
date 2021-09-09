Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D433BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 03:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C3860EE1
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Sep 2021 03:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237357AbhIIDFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbhIIDFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Sep 2021 23:05:43 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18253C061575
        for <linux-xfs@vger.kernel.org>; Wed,  8 Sep 2021 20:04:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so410169pjw.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Sep 2021 20:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=GcKCwP+vC/gHl6g6hxQm6o/nCsXeICQahv13cyx1aGM=;
        b=kvGWNGfLyjptMbiRQJM8SHyGOeg++JiXsDjQ9fMEkQhf1gFKNxILV7Neo61EEsJico
         Nwk5lC5jymRvjox+Y+Tk85fmb/c/wWOW5A0jfSwQ//pwzbXDUj53fNtNbsTOa/L0nrg6
         Igqnt0LOxkWoeZ8fwd3IFEL+J/J5ho3cDu843WYCL8QvPxjQ6a0rH1C4mHHdDs+31YNp
         JK1/54T13P9Rm/kG7Z7iFUFnQORfPz1KFsq1L6qF1pWXCA0q1jZH3lYjvzMSCs4K8pJA
         PwrDh+dLvdU8/XI6avO1yhkvVq4YItkt46DFLJ2DZH5JGLHpUzk0v6Z6ZmbS7hESeSZI
         DNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=GcKCwP+vC/gHl6g6hxQm6o/nCsXeICQahv13cyx1aGM=;
        b=qIpgNmOJyUlZQxF3G85em4QdqUlHdG1t2NGrjHoHB/EgRU+TAwAw1wvTU2H28Vo1SV
         uV59XiGoLOozPGj5j4KuPRBSBLdCHYxQ5Nmh4G1rXKSnvjhztrvNOQFIFtqEqAjLXkqi
         6QXLD6Jc6Nn9DZKGpZPMBqAHSsRaIMyZzKGLo2lENFaF8AWBDpX17DzBRyVS5w0lwaTh
         L+O7kGxR42869gTlF5nKjJLAH/rcDju0UNbnqEcW7G9OBAIzIXGPkuq4MiV5s2bxifHW
         PiYHaBzG96Sc4OuGpay5orWAtLxjac0ME6mRiUUBfeQ7vzJX+F5CZEPeC379BZtCVQ9V
         cBqg==
X-Gm-Message-State: AOAM533b2mK7J9YtXqQl29qAPdQ2Jyh73tIf43P+7JKIFxY8lQSIRBfL
        rkuOO2fGeUjYj4J6GTtU3UvsZbEm/L0=
X-Google-Smtp-Source: ABdhPJxfPrFfGPO3wIgi8v0XxPZwmx6KHfd3wI4kg31sqKs/5xG4hA6bzOHmE4qlodie+7/Bzp/Z3A==
X-Received: by 2002:a17:90b:1d02:: with SMTP id on2mr981817pjb.21.1631156674180;
        Wed, 08 Sep 2021 20:04:34 -0700 (PDT)
Received: from xzhoux.usersys.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i132sm315697pgc.35.2021.09.08.20.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 20:04:33 -0700 (PDT)
Date:   Thu, 9 Sep 2021 11:04:25 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com
Subject: XFS new panic after new merges
Message-ID: <20210909030425.ql6ha5nfydvx7ece@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

After this batch of updates in Linus tree,

eceae1e Merge tag 'configfs-5.15' of git://git.infradead.org/users/hch/configfs
265113f Merge tag 'dlm-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm
111c1aa Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
815409a Merge tag 'ovl-update-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs
412106c Merge tag 'erofs-for-5.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs
89594c7 Merge tag 'fscache-next-20210829' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
90c90cd Merge tag 'xfs-5.15-merge-6' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
57c78a2 Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
bcfeebb Merge branch 'exit-cleanups-for-v5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
4898370 Merge branch 'siginfo-si_trapno-for-v5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace
65266a7 Merge remote-tracking branch 'tip/sched/arm64' into for-next/core
61dc131 Merge tag 'iomap-5.15-merge-2' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git


xfstests on xfs start to panic some times when running xfs/006 or xfs/264.

It's reproducible but not always. Sometimes on some servers 100 loops of
these tests pass. Sometimes it panics on the first run of xfs/006.

Due to it's not always reproducible, bisecting is not an option. And it's
hard to say it can not be reproduced on any condition. So far it can be
reproduced via these mkfs options:

crc=1 finobt=1,sparse=1,rmapbt=0 reflink=1,bigtime=0,inobtcount=0
or
crc=1 finobt=1,sparse=1,rmapbt=1 reflink=1,bigtime=0,inobtcount=0
or
crc=1 finobt=1,sparse=1,rmapbt=0 reflink=1,bigtime=1,inobtcount=1
or
crc=1 finobt=1,sparse=1,rmapbt=1 reflink=1,bigtime=1,inobtcount=1

Thanks zorro's help on debugging.

Attaching some debug info, I can send more if you need.

Thanks,
Murphy

# xfs_info output

meta-data=/dev/sda5              isize=512    agcount=16, agsize=245696 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=3931136, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=5184, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
meta-data=/dev/sda4              isize=512    agcount=16, agsize=245696 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=3931136, imaxpct=25
         =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=5184, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# panic console output

[  514.174583] run fstests xfs/006 at 2021-09-08 05:07:23 
[  515.075816] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log. 
[  515.139517] device-mapper: uevent: version 1.0.3 
[  515.160591] device-mapper: ioctl: 4.45.0-ioctl (2021-03-22) initialised: dm-devel@redhat.com 
[  515.595944] XFS (dm-0): Mounting V5 Filesystem 
[  515.642351] XFS (dm-0): Ending clean mount 
[  515.667439] xfs filesystem being mounted at /mnt/xfstests/scratch supports timestamps until 2038 (0x7fffffff) 
[  515.899072] XFS (dm-0): xlog_verify_grant_tail: space > BBTOB(tail_blocks) 
[  516.439917] Buffer I/O error on dev dm-0, logical block 31457152, async page read 
[  516.476888] Buffer I/O error on dev dm-0, logical block 31457153, async page read 
[  516.513741] Buffer I/O error on dev dm-0, logical block 31457154, async page read 
[  516.550635] Buffer I/O error on dev dm-0, logical block 31457155, async page read 
[  516.584744] Buffer I/O error on dev dm-0, logical block 31457156, async page read 
[  516.618025] Buffer I/O error on dev dm-0, logical block 31457157, async page read 
[  516.652346] Buffer I/O error on dev dm-0, logical block 31457158, async page read 
[  516.686287] Buffer I/O error on dev dm-0, logical block 31457159, async page read 
[  516.817762] XFS (dm-0): Unmounting Filesystem 
[  516.870615] XFS (dm-0): log I/O error -5 
[  516.894791] BUG: unable to handle page fault for address: ffffffffb804b420 
[  516.925708] #PF: supervisor write access in kernel mode 
[  516.949221] #PF: error_code(0x0002) - not-present page 
[  516.973270] PGD 825015067 P4D 825015067 PUD 825016063 PMD 10b528063 PTE 800ffff7da5b4062 
[  517.014986] Oops: 0002 [#1] SMP PTI 
[  517.030764] CPU: 29 PID: 983 Comm: kworker/29:1H Kdump: loaded Tainted: G          I       5.14.0+ #1 
[  517.072364] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 07/01/2015 
[  517.102164] Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs] 
[  517.126689] RIP: 0010:native_queued_spin_lock_slowpath.part.0+0x15f/0x190 
[  517.157762] Code: f3 90 48 8b 31 48 85 f6 74 f6 eb d9 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 94 02 00 48 03 04 f5 80 5a 40 b7 <48> 89 08 8b 41 08 85 c0 75 09 f3 90 8b 41 08 85 c0 74 f7 48 8b 31 
[  517.242726] RSP: 0018:ffffa30ec522fb90 EFLAGS: 00010282 
[  517.266249] RAX: ffffffffb804b420 RBX: 0000000100009000 RCX: ffff91f2af969400 
[  517.298608] RDX: ffff91ebc12b18c0 RSI: 000000000000135b RDI: ffff91ebc12b18c0 
[  517.330983] RBP: ffff91ef112af4a0 R08: 0000000000780000 R09: ffff91eec0d34b28 
[  517.363119] R10: 00000000000001ad R11: 000000000086a1d9 R12: ffff91ebc12b1880 
[  517.395630] R13: ffff91ebc12b18c0 R14: 0000000000000008 R15: ffff91ef111ae000 
[  517.427924] FS:  0000000000000000(0000) GS:ffff91f2af940000(0000) knlGS:0000000000000000 
[  517.464344] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  517.491411] CR2: ffffffffb804b420 CR3: 0000000480814003 CR4: 00000000001706e0 
[  517.526491] Call Trace: 
[  517.538343]  _raw_spin_lock+0x1a/0x20 
[  517.556233]  xfs_trans_ail_delete+0x29/0x100 [xfs] 
[  517.577945]  xfs_buf_item_done+0x24/0x30 [xfs] 
[  517.598086]  xfs_buf_ioend+0x72/0x1d0 [xfs] 
[  517.616961]  xfs_trans_committed_bulk+0x18e/0x300 [xfs] 
[  517.640970]  ? select_idle_sibling+0x3f4/0x4d0 
[  517.661445]  ? enqueue_task+0x4b/0x140 
[  517.678393]  ? check_preempt_curr+0x2f/0x70 
[  517.697236]  ? ttwu_do_wakeup+0x17/0x150 
[  517.714940]  ? try_to_wake_up+0x1cd/0x4d0 
[  517.732945]  ? __wake_up_common_lock+0x8a/0xc0 
[  517.752906]  ? __raw_callee_save___native_queued_spin_unlock+0x11/0x1e 
[  517.782397]  xlog_cil_committed+0x15d/0x190 [xfs] 
[  517.803609]  xlog_cil_process_committed+0x57/0x80 [xfs] 
[  517.827306]  xlog_state_shutdown_callbacks+0xd0/0xf0 [xfs] 
[  517.852174]  xlog_force_shutdown+0xe5/0x160 [xfs] 
[  517.873427]  xfs_do_force_shutdown+0x51/0x130 [xfs] 
[  517.895689]  xlog_ioend_work+0x60/0xb0 [xfs] 
[  517.914951]  process_one_work+0x1eb/0x390 
[  517.932968]  worker_thread+0x53/0x3d0 
[  517.949055]  ? process_one_work+0x390/0x390 
[  517.967971]  kthread+0x10f/0x130 
[  517.982565]  ? set_kthread_struct+0x40/0x40 
[  518.003240]  ret_from_fork+0x22/0x30 
[  518.021094] Modules linked in: dm_mod tls rfkill iTCO_wdt iTCO_vendor_support intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm mgag200 i2c_algo_bit irqbypass drm_kms_helper ipmi_ssif rapl intel_cstate syscopyarea intel_uncore sysfillrect acpi_ipmi sunrpc pcspkr sysimgblt fb_sys_fops lpc_ich cec hpilo ipmi_si ipmi_devintf ioatdma ipmi_msghandler acpi_power_meter dca drm fuse xfs libcrc32c sr_mod cdrom ata_generic sd_mod t10_pi sg ata_piix crct10dif_pclmul crc32_pclmul crc32c_intel libata ghash_clmulni_intel serio_raw tg3 hpsa hpwdt scsi_transport_sas 
[  518.265394] CR2: ffffffffb804b420 
