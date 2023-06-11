Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114BFC77B7A
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Jun 2023 12:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjFKMtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 08:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjFKMts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jun 2023 08:49:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151E1734
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 05:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686487732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=3+hC+tZd5PGsgftQLk/t8s7rLZUNfNLHPBXLR8hQmg8=;
        b=MGWrc6caYh2ucmqy8lMyJqM14Y7cdq5ayr1lWQNJTT5MTgwSFhbbgL50V3KkKnLVxLziQ8
        9lUZYRuZJDd0P4Vr7euqEKJ81VBb5fo8h+JFjN9GikIlMER1W3lYV2iUP5yDtKTPvxm9EL
        WBE03riZ7kbngYFkgaFYwHZJhqGr7Nk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-wVltq5S-O7mJRuzkd-qnwA-1; Sun, 11 Jun 2023 08:48:44 -0400
X-MC-Unique: wVltq5S-O7mJRuzkd-qnwA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1b3b3c69969so8113225ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 05:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686487723; x=1689079723;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3+hC+tZd5PGsgftQLk/t8s7rLZUNfNLHPBXLR8hQmg8=;
        b=K6ie95pVZ+2ffONLMQozPv9iUaQEjTssQuGGXdwRb17Erlh2gZognbO/nF17S7GNIS
         gICojeXaLopJSrMxeoSUtSol25x0WoVqx8hRO79SWWKRTTeFms/Ft5s0d0IYkMvJen5z
         xkujmj81DrXr298pF9uXzA30rR39ML6mO7Q7Bm20oMn6OoJqkkBtL/F9jc3LYDA/yZmd
         tsXFA9qCLKa4eXltF0xCdOgu99b7hh2KSW4i4gHQVk2AXdFG9Rv0pP9TCEZm+KugrovF
         OFZHlP/exmwjCNPHxy4BFY/XAFjLrGemIOGo3Kqpc9suaZV/8ThFqoMffEaDBEfsU1UP
         6nyA==
X-Gm-Message-State: AC+VfDwXDoDCmZnqd9yWH89Xcq4cwI4ZEkIQl12MilXK9sFSrrDkBaRw
        X1rEKvduzAtQktqfKHMdP5+L20GLz7YA7r21zHLRtsx7HNZ0rwTEzW624VZwc+wSrtxKjigVLYB
        fzXiyqenKrZLr4NGBR8ldPTKo04Zd8aA89g/GbG9tGGrmfhHlWvsqs8ibW7oMlJkIdexuvUmG/d
        um3SI=
X-Received: by 2002:a17:902:6b47:b0:1b3:bd82:c5d2 with SMTP id g7-20020a1709026b4700b001b3bd82c5d2mr1831280plt.55.1686487722046;
        Sun, 11 Jun 2023 05:48:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Ru6WiyxOY3PY5jQNahm/T58K/uv1zLr7q33nons6LoSzRO4ZyWyzn0lEXqKLLvd3tdcn8fw==
X-Received: by 2002:a17:902:6b47:b0:1b3:bd82:c5d2 with SMTP id g7-20020a1709026b4700b001b3bd82c5d2mr1831233plt.55.1686487720423;
        Sun, 11 Jun 2023 05:48:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x21-20020a17090300d500b001a221d14179sm6302936plc.302.2023.06.11.05.48.39
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 05:48:40 -0700 (PDT)
Date:   Sun, 11 Jun 2023 20:48:36 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [Bug report] fstests generic/051 (on xfs) hang on latest linux
 v6.5-rc5+
Message-ID: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

When I tried to do fstests regression test this weekend on latest linux
v6.5-rc5+ (HEAD=64569520920a3ca5d456ddd9f4f95fc6ea9b8b45), nearly all
testing jobs on xfs hang on generic/051 (more than 24 hours, still blocked).
No matter 1k or 4k blocksize, general disk or pmem dev, or any architectures,
or any mkfs/mount options testing, all hang there.

Someone console log as below (a bit long), the call trace doesn't contains any
xfs functions, it might be not a xfs bug, but it can't be reproduced on ext4.

Thanks,
Zorro

[ 3058.375251] run fstests generic/051 at 2023-06-10 05:24:53 
[ 3060.823847] XFS (sda2): Mounting V5 Filesystem d29dc9fd-f34e-412d-ad57-660089a07846 
[ 3060.861421] XFS (sda2): Ending clean mount 
[ 3060.890745] XFS (sda2): User initiated shutdown received. 
[ 3060.896445] XFS (sda2): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x4b/0x180 [xfs] (fs/xfs/xfs_fsops.c:483).  Shutting down filesystem. 
[ 3060.910587] XFS (sda2): Please unmount the filesystem and rectify the problem(s) 
[ 3060.935623] XFS (sda2): Unmounting Filesystem d29dc9fd-f34e-412d-ad57-660089a07846 
[ 3063.187766] XFS (sda2): Mounting V5 Filesystem 2e3103da-304e-4b5d-889a-9107fbfac9c4 
[ 3063.266929] XFS (sda2): Ending clean mount 
[-- MARK -- Sat Jun 10 09:25:00 2023] 
[ 3089.010524] restraintd[2605]: *** Current Time: Sat Jun 10 05:25:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3094.716728] XFS (sda2): Unmounting Filesystem 2e3103da-304e-4b5d-889a-9107fbfac9c4 
[ 3094.953685] XFS (sda2): Mounting V5 Filesystem 2e3103da-304e-4b5d-889a-9107fbfac9c4 
[ 3094.999476] XFS (sda2): Ending clean mount 
[ 3130.092264] XFS (sda2): User initiated shutdown received. 
[ 3130.097725] XFS (sda2): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
[ 3130.111026] XFS (sda2): Please unmount the filesystem and rectify the problem(s) 
[ 3149.011385] restraintd[2605]: *** Current Time: Sat Jun 10 05:26:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3209.009949] restraintd[2605]: *** Current Time: Sat Jun 10 05:27:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3269.009872] restraintd[2605]: *** Current Time: Sat Jun 10 05:28:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3327.273357] INFO: task fsstress:570762 blocked for more than 122 seconds. 
[ 3327.280311]       Not tainted 6.4.0-rc5+ #1 
[ 3327.284525] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3327.292384] task:fsstress        state:D stack:21664 pid:570762 ppid:570760 flags:0x00000002 
[ 3327.300853] Call Trace: 
[ 3327.303331]  <TASK> 
[ 3327.305463]  __schedule+0x79c/0x1d70 
[ 3327.309086]  ? __pfx___schedule+0x10/0x10 
[ 3327.313125]  ? __lock_acquire+0xbaa/0x1be0 
[ 3327.317257]  ? __lock_release+0x485/0x960 
[ 3327.321302]  schedule+0x130/0x220 
[ 3327.324653]  schedule_timeout+0x22a/0x270 
[ 3327.328691]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3327.333245]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3327.338603]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3327.342991]  __wait_for_common+0x1ca/0x5c0 
[ 3327.347113]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3327.351677]  ? __pfx___wait_for_common+0x10/0x10 
[ 3327.356334]  wait_for_completion_state+0x1d/0x40 
[ 3327.360976]  coredump_wait+0x502/0x750 
[ 3327.364760]  do_coredump+0x2fa/0x1c10 
[ 3327.368447]  ? __pfx___lock_release+0x10/0x10 
[ 3327.372825]  ? __pfx___lock_acquired+0x10/0x10 
[ 3327.377289]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3327.381676]  ? __pfx_do_coredump+0x10/0x10 
[ 3327.385801]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3327.390882]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3327.395179]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3327.400171]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3327.405272]  ? __lock_release+0x485/0x960 
[ 3327.409317]  ? __wait_for_common+0x9e/0x5c0 
[ 3327.413527]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3327.417922]  get_signal+0x12f8/0x1990 
[ 3327.421620]  ? do_send_specific+0xf8/0x280 
[ 3327.425748]  ? __pfx_get_signal+0x10/0x10 
[ 3327.429786]  ? do_send_specific+0x110/0x280 
[ 3327.433996]  ? __pfx_do_send_specific+0x10/0x10 
[ 3327.438558]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3327.443286]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3327.448627]  ? do_tkill+0x186/0x200 
[ 3327.452180]  exit_to_user_mode_loop+0xac/0x160 
[ 3327.456652]  exit_to_user_mode_prepare+0x142/0x150 
[ 3327.461468]  syscall_exit_to_user_mode+0x19/0x50 
[ 3327.466113]  do_syscall_64+0x69/0x90 
[ 3327.469723]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3327.474106]  ? do_syscall_64+0x69/0x90 
[ 3327.477886]  ? do_syscall_64+0x69/0x90 
[ 3327.481662]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3327.486047]  ? do_syscall_64+0x69/0x90 
[ 3327.489828]  ? asm_exc_page_fault+0x22/0x30 
[ 3327.494039]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3327.498422]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3327.503492] RIP: 0033:0x7fe5cfaa157c 
[ 3327.507097] RSP: 002b:00007fffe9f3c6e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3327.514689] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3327.521840] RDX: 0000000000000006 RSI: 000000000008b58a RDI: 000000000008b58a 
[ 3327.528989] RBP: 000000000008b58a R08: 00007fffe9f3c7b0 R09: 00007fe5cfbb14e0 
[ 3327.536161] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3327.543317] R13: 8f5c28f5c28f5c29 R14: 000000000040ac10 R15: 00007fe5cfce86c0 
[ 3327.550487]  </TASK> 
[ 3327.552721] INFO: task fsstress:570763 blocked for more than 123 seconds. 
[ 3327.559533]       Not tainted 6.4.0-rc5+ #1 
[ 3327.563743] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3327.571586] task:fsstress        state:D stack:22832 pid:570763 ppid:570760 flags:0x00000002 
[ 3327.580042] Call Trace: 
[ 3327.582517]  <TASK> 
[ 3327.584643]  __schedule+0x79c/0x1d70 
[ 3327.588248]  ? __pfx___schedule+0x10/0x10 
[ 3327.592282]  ? __lock_acquire+0xbaa/0x1be0 
[ 3327.596407]  ? __lock_release+0x485/0x960 
[ 3327.600446]  schedule+0x130/0x220 
[ 3327.603784]  schedule_timeout+0x22a/0x270 
[ 3327.607813]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3327.612361]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3327.617706]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3327.622091]  __wait_for_common+0x1ca/0x5c0 
[ 3327.626210]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3327.630767]  ? __pfx___wait_for_common+0x10/0x10 
[ 3327.635423]  wait_for_completion_state+0x1d/0x40 
[ 3327.640060]  coredump_wait+0x502/0x750 
[ 3327.643844]  do_coredump+0x2fa/0x1c10 
[ 3327.647533]  ? __pfx___lock_release+0x10/0x10 
[ 3327.651910]  ? __pfx___lock_acquired+0x10/0x10 
[ 3327.656372]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3327.660750]  ? __pfx_do_coredump+0x10/0x10 
[ 3327.664875]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3327.669954]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3327.674252]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3327.679242]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3327.684332]  ? __lock_release+0x485/0x960 
[ 3327.688379]  ? __wait_for_common+0x9e/0x5c0 
[ 3327.692581]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3327.696969]  get_signal+0x12f8/0x1990 
[ 3327.700668]  ? do_send_specific+0xf8/0x280 
[ 3327.704793]  ? __pfx_get_signal+0x10/0x10 
[ 3327.708823]  ? do_send_specific+0x110/0x280 
[ 3327.713032]  ? __pfx_do_send_specific+0x10/0x10 
[ 3327.717591]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3327.722316]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3327.727649]  ? do_tkill+0x186/0x200 
[ 3327.731185]  exit_to_user_mode_loop+0xac/0x160 
[ 3327.735654]  exit_to_user_mode_prepare+0x142/0x150 
[ 3327.740465]  syscall_exit_to_user_mode+0x19/0x50 
[ 3327.745099]  do_syscall_64+0x69/0x90 
[ 3327.748698]  ? __task_pid_nr_ns+0x105/0x3c0 
[ 3327.752916]  ? do_syscall_64+0x69/0x90 
[ 3327.756687]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3327.761066]  ? do_syscall_64+0x69/0x90 
[ 3327.764844]  ? asm_exc_page_fault+0x22/0x30 
[ 3327.769045]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3327.773425]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3327.778506] RIP: 0033:0x7fe5cfaa157c 
[ 3327.782105] RSP: 002b:00007fffe9f3c610 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3327.789689] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3327.796839] RDX: 0000000000000006 RSI: 000000000008b58b RDI: 000000000008b58b 
[ 3327.803990] RBP: 000000000008b58b R08: 00007fffe9f3c6e0 R09: 00007fe5cfbb14e0 
[ 3327.811148] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3327.818296] R13: 8f5c28f5c28f5c29 R14: 000000000040df50 R15: 00007fe5cfce86c0 
[ 3327.825468]  </TASK> 
[ 3327.827679]  
[ 3327.827679] Showing all locks held in the system: 
[ 3327.833882] 1 lock held by rcu_tasks_kthre/13: 
[ 3327.838359]  #0: ffffffffb972c000 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3327.847964] 1 lock held by rcu_tasks_rude_/14: 
[ 3327.852426]  #0: ffffffffb972bd20 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3327.862456] 1 lock held by rcu_tasks_trace/15: 
[ 3327.866918]  #0: ffffffffb972b9e0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3327.877070] 1 lock held by khungtaskd/865: 
[ 3327.881183]  #0: ffffffffb972ccc0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x340 
[ 3327.890188] 1 lock held by systemd-journal/1644: 
[ 3327.894823]  #0: ff11000f34a04ad8 (&rq->__lock){-.-.}-{2:2}, at: finish_task_switch.isra.0+0x146/0xb40 
[ 3327.904184]  
[ 3327.905700] ============================================= 
[ 3327.905700]  
[ 3329.010807] restraintd[2605]: *** Current Time: Sat Jun 10 05:29:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[-- MARK -- Sat Jun 10 09:30:00 2023] 
[ 3389.009908] restraintd[2605]: *** Current Time: Sat Jun 10 05:30:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3450.152225] INFO: task fsstress:570762 blocked for more than 245 seconds. 
[ 3450.159038]       Not tainted 6.4.0-rc5+ #1 
[ 3450.163251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3450.171105] task:fsstress        state:D stack:21664 pid:570762 ppid:570760 flags:0x00000002 
[ 3450.179569] Call Trace: 
[ 3450.182049]  <TASK> 
[ 3450.184182]  __schedule+0x79c/0x1d70 
[ 3450.187791]  ? __pfx___schedule+0x10/0x10 
[ 3450.191823]  ? __lock_acquire+0xbaa/0x1be0 
[ 3450.195958]  ? __lock_release+0x485/0x960 
[ 3450.200004]  schedule+0x130/0x220 
[ 3450.203352]  schedule_timeout+0x22a/0x270 
[ 3450.207391]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3450.211948]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3450.217305]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3450.221693]  __wait_for_common+0x1ca/0x5c0 
[ 3450.225814]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3450.230379]  ? __pfx___wait_for_common+0x10/0x10 
[ 3450.235035]  wait_for_completion_state+0x1d/0x40 
[ 3450.239679]  coredump_wait+0x502/0x750 
[ 3450.243471]  do_coredump+0x2fa/0x1c10 
[ 3450.247160]  ? __pfx___lock_release+0x10/0x10 
[ 3450.251545]  ? __pfx___lock_acquired+0x10/0x10 
[ 3450.256021]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3450.260399]  ? __pfx_do_coredump+0x10/0x10 
[ 3450.264518]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3450.269602]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3450.273899]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3450.278890]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3450.283991]  ? __lock_release+0x485/0x960 
[ 3450.288036]  ? __wait_for_common+0x9e/0x5c0 
[ 3450.292240]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3450.296629]  get_signal+0x12f8/0x1990 
[ 3450.300328]  ? do_send_specific+0xf8/0x280 
[ 3450.304445]  ? __pfx_get_signal+0x10/0x10 
[ 3450.308474]  ? do_send_specific+0x110/0x280 
[ 3450.312677]  ? __pfx_do_send_specific+0x10/0x10 
[ 3450.317236]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3450.321971]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3450.327311]  ? do_tkill+0x186/0x200 
[ 3450.330846]  exit_to_user_mode_loop+0xac/0x160 
[ 3450.335319]  exit_to_user_mode_prepare+0x142/0x150 
[ 3450.340133]  syscall_exit_to_user_mode+0x19/0x50 
[ 3450.344770]  do_syscall_64+0x69/0x90 
[ 3450.348374]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3450.352753]  ? do_syscall_64+0x69/0x90 
[ 3450.356524]  ? do_syscall_64+0x69/0x90 
[ 3450.360299]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3450.364678]  ? do_syscall_64+0x69/0x90 
[ 3450.368448]  ? asm_exc_page_fault+0x22/0x30 
[ 3450.372649]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3450.377028]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3450.382101] RIP: 0033:0x7fe5cfaa157c 
[ 3450.385706] RSP: 002b:00007fffe9f3c6e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3450.393294] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3450.400443] RDX: 0000000000000006 RSI: 000000000008b58a RDI: 000000000008b58a 
[ 3450.407596] RBP: 000000000008b58a R08: 00007fffe9f3c7b0 R09: 00007fe5cfbb14e0 
[ 3450.414751] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3450.421902] R13: 8f5c28f5c28f5c29 R14: 000000000040ac10 R15: 00007fe5cfce86c0 
[ 3450.429089]  </TASK> 
[ 3450.431296] INFO: task fsstress:570763 blocked for more than 246 seconds. 
[ 3450.438112]       Not tainted 6.4.0-rc5+ #1 
[ 3450.442313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3450.450154] task:fsstress        state:D stack:22832 pid:570763 ppid:570760 flags:0x00000002 
[ 3450.458613] Call Trace: 
[ 3450.461086]  <TASK> 
[ 3450.463217]  __schedule+0x79c/0x1d70 
[ 3450.466820]  ? __pfx___schedule+0x10/0x10 
[ 3450.470853]  ? __lock_acquire+0xbaa/0x1be0 
[ 3450.474978]  ? __lock_release+0x485/0x960 
[ 3450.479018]  schedule+0x130/0x220 
[ 3450.482361]  schedule_timeout+0x22a/0x270 
[ 3450.486389]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3450.490941]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3450.496289]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3450.500669]  __wait_for_common+0x1ca/0x5c0 
[ 3450.504795]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3450.509359]  ? __pfx___wait_for_common+0x10/0x10 
[ 3450.514014]  wait_for_completion_state+0x1d/0x40 
[ 3450.518648]  coredump_wait+0x502/0x750 
[ 3450.522429]  do_coredump+0x2fa/0x1c10 
[ 3450.526117]  ? __pfx___lock_release+0x10/0x10 
[ 3450.530495]  ? __pfx___lock_acquired+0x10/0x10 
[ 3450.534959]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3450.539341]  ? __pfx_do_coredump+0x10/0x10 
[ 3450.543472]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3450.548545]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3450.552845]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3450.557835]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3450.562930]  ? __lock_release+0x485/0x960 
[ 3450.566977]  ? __wait_for_common+0x9e/0x5c0 
[ 3450.571182]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3450.575579]  get_signal+0x12f8/0x1990 
[ 3450.579277]  ? do_send_specific+0xf8/0x280 
[ 3450.583406]  ? __pfx_get_signal+0x10/0x10 
[ 3450.587442]  ? do_send_specific+0x110/0x280 
[ 3450.591654]  ? __pfx_do_send_specific+0x10/0x10 
[ 3450.596215]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3450.600939]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3450.606273]  ? do_tkill+0x186/0x200 
[ 3450.609810]  exit_to_user_mode_loop+0xac/0x160 
[ 3450.614278]  exit_to_user_mode_prepare+0x142/0x150 
[ 3450.619100]  syscall_exit_to_user_mode+0x19/0x50 
[ 3450.623744]  do_syscall_64+0x69/0x90 
[ 3450.627348]  ? __task_pid_nr_ns+0x105/0x3c0 
[ 3450.631569]  ? do_syscall_64+0x69/0x90 
[ 3450.635349]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3450.639738]  ? do_syscall_64+0x69/0x90 
[ 3450.643514]  ? asm_exc_page_fault+0x22/0x30 
[ 3450.647727]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3450.652113]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3450.657186] RIP: 0033:0x7fe5cfaa157c 
[ 3450.660784] RSP: 002b:00007fffe9f3c610 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3450.668376] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3450.675531] RDX: 0000000000000006 RSI: 000000000008b58b RDI: 000000000008b58b 
[ 3450.682682] RBP: 000000000008b58b R08: 00007fffe9f3c6e0 R09: 00007fe5cfbb14e0 
[ 3450.689835] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3450.696985] R13: 8f5c28f5c28f5c29 R14: 000000000040df50 R15: 00007fe5cfce86c0 
[ 3450.704151]  </TASK> 
[ 3450.706362]  
[ 3450.706362] Showing all locks held in the system: 
[ 3450.712570] 1 lock held by rcu_tasks_kthre/13: 
[ 3450.717037]  #0: ffffffffb972c000 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3450.726639] 1 lock held by rcu_tasks_rude_/14: 
[ 3450.731106]  #0: ffffffffb972bd20 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3450.741139] 1 lock held by rcu_tasks_trace/15: 
[ 3450.745604]  #0: ffffffffb972b9e0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3450.755747] 1 lock held by khungtaskd/865: 
[ 3450.759872]  #0: ffffffffb972ccc0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x340 
[ 3450.768868] 1 lock held by systemd-journal/1644: 
[ 3450.773512]  #0: ff11000f34a04ad8 (&rq->__lock){-.-.}-{2:2}, at: ep_send_events+0xea/0xa00 
[ 3450.781825]  
[ 3450.783348] ============================================= 
[ 3450.783348]  
[ 3449.011268] restraintd[2605]: *** Current Time: Sat Jun 10 05:31:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3509.010466] restraintd[2605]: *** Current Time: Sat Jun 10 05:32:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3569.010481] restraintd[2605]: *** Current Time: Sat Jun 10 05:33:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3573.031190] INFO: task fsstress:570762 blocked for more than 368 seconds. 
[ 3573.038002]       Not tainted 6.4.0-rc5+ #1 
[ 3573.042222] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3573.050069] task:fsstress        state:D stack:21664 pid:570762 ppid:570760 flags:0x00000002 
[ 3573.058534] Call Trace: 
[ 3573.061014]  <TASK> 
[ 3573.063148]  __schedule+0x79c/0x1d70 
[ 3573.066757]  ? __pfx___schedule+0x10/0x10 
[ 3573.070792]  ? __lock_acquire+0xbaa/0x1be0 
[ 3573.074926]  ? __lock_release+0x485/0x960 
[ 3573.078973]  schedule+0x130/0x220 
[ 3573.082321]  schedule_timeout+0x22a/0x270 
[ 3573.086357]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3573.090911]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3573.096257]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3573.100639]  __wait_for_common+0x1ca/0x5c0 
[ 3573.104759]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3573.109314]  ? __pfx___wait_for_common+0x10/0x10 
[ 3573.113971]  wait_for_completion_state+0x1d/0x40 
[ 3573.118609]  coredump_wait+0x502/0x750 
[ 3573.122390]  do_coredump+0x2fa/0x1c10 
[ 3573.126079]  ? __pfx___lock_release+0x10/0x10 
[ 3573.130458]  ? __pfx___lock_acquired+0x10/0x10 
[ 3573.134921]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3573.139306]  ? __pfx_do_coredump+0x10/0x10 
[ 3573.143425]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3573.148504]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3573.152801]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3573.157792]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3573.162883]  ? __lock_release+0x485/0x960 
[ 3573.166929]  ? __wait_for_common+0x9e/0x5c0 
[ 3573.171136]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3573.175526]  get_signal+0x12f8/0x1990 
[ 3573.179223]  ? do_send_specific+0xf8/0x280 
[ 3573.183344]  ? __pfx_get_signal+0x10/0x10 
[ 3573.187380]  ? do_send_specific+0x110/0x280 
[ 3573.191582]  ? __pfx_do_send_specific+0x10/0x10 
[ 3573.196137]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3573.200865]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3573.206196]  ? do_tkill+0x186/0x200 
[ 3573.209739]  exit_to_user_mode_loop+0xac/0x160 
[ 3573.214205]  exit_to_user_mode_prepare+0x142/0x150 
[ 3573.219027]  syscall_exit_to_user_mode+0x19/0x50 
[ 3573.223665]  do_syscall_64+0x69/0x90 
[ 3573.227264]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3573.231649]  ? do_syscall_64+0x69/0x90 
[ 3573.235422]  ? do_syscall_64+0x69/0x90 
[ 3573.239196]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3573.243575]  ? do_syscall_64+0x69/0x90 
[ 3573.247345]  ? asm_exc_page_fault+0x22/0x30 
[ 3573.251553]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3573.255934]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3573.261000] RIP: 0033:0x7fe5cfaa157c 
[ 3573.264609] RSP: 002b:00007fffe9f3c6e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3573.272198] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3573.279347] RDX: 0000000000000006 RSI: 000000000008b58a RDI: 000000000008b58a 
[ 3573.286499] RBP: 000000000008b58a R08: 00007fffe9f3c7b0 R09: 00007fe5cfbb14e0 
[ 3573.293650] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3573.300799] R13: 8f5c28f5c28f5c29 R14: 000000000040ac10 R15: 00007fe5cfce86c0 
[ 3573.307968]  </TASK> 
[ 3573.310183] INFO: task fsstress:570763 blocked for more than 368 seconds. 
[ 3573.316995]       Not tainted 6.4.0-rc5+ #1 
[ 3573.321200] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3573.329044] task:fsstress        state:D stack:22832 pid:570763 ppid:570760 flags:0x00000002 
[ 3573.337503] Call Trace: 
[ 3573.339971]  <TASK> 
[ 3573.342100]  __schedule+0x79c/0x1d70 
[ 3573.345707]  ? __pfx___schedule+0x10/0x10 
[ 3573.349739]  ? __lock_acquire+0xbaa/0x1be0 
[ 3573.353868]  ? __lock_release+0x485/0x960 
[ 3573.357906]  schedule+0x130/0x220 
[ 3573.361252]  schedule_timeout+0x22a/0x270 
[ 3573.365286]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3573.369837]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3573.375182]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3573.379565]  __wait_for_common+0x1ca/0x5c0 
[ 3573.383679]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3573.388232]  ? __pfx___wait_for_common+0x10/0x10 
[ 3573.392890]  wait_for_completion_state+0x1d/0x40 
[ 3573.397527]  coredump_wait+0x502/0x750 
[ 3573.401307]  do_coredump+0x2fa/0x1c10 
[ 3573.404988]  ? __pfx___lock_release+0x10/0x10 
[ 3573.409368]  ? __pfx___lock_acquired+0x10/0x10 
[ 3573.413830]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3573.418206]  ? __pfx_do_coredump+0x10/0x10 
[ 3573.422329]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3573.427405]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3573.431702]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3573.436691]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3573.441782]  ? __lock_release+0x485/0x960 
[ 3573.445830]  ? __wait_for_common+0x9e/0x5c0 
[ 3573.450031]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3573.454419]  get_signal+0x12f8/0x1990 
[ 3573.458117]  ? do_send_specific+0xf8/0x280 
[ 3573.462233]  ? __pfx_get_signal+0x10/0x10 
[ 3573.466263]  ? do_send_specific+0x110/0x280 
[ 3573.470466]  ? __pfx_do_send_specific+0x10/0x10 
[ 3573.475027]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3573.479757]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3573.485090]  ? do_tkill+0x186/0x200 
[ 3573.488625]  exit_to_user_mode_loop+0xac/0x160 
[ 3573.493098]  exit_to_user_mode_prepare+0x142/0x150 
[ 3573.497913]  syscall_exit_to_user_mode+0x19/0x50 
[ 3573.502550]  do_syscall_64+0x69/0x90 
[ 3573.506145]  ? __task_pid_nr_ns+0x105/0x3c0 
[ 3573.510357]  ? do_syscall_64+0x69/0x90 
[ 3573.514127]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3573.518506]  ? do_syscall_64+0x69/0x90 
[ 3573.522273]  ? asm_exc_page_fault+0x22/0x30 
[ 3573.526478]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3573.530856]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3573.535929] RIP: 0033:0x7fe5cfaa157c 
[ 3573.539534] RSP: 002b:00007fffe9f3c610 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3573.547125] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3573.554276] RDX: 0000000000000006 RSI: 000000000008b58b RDI: 000000000008b58b 
[ 3573.561420] RBP: 000000000008b58b R08: 00007fffe9f3c6e0 R09: 00007fe5cfbb14e0 
[ 3573.568575] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3573.575726] R13: 8f5c28f5c28f5c29 R14: 000000000040df50 R15: 00007fe5cfce86c0 
[ 3573.582896]  </TASK> 
[ 3573.585108]  
[ 3573.585108] Showing all locks held in the system: 
[ 3573.591316] 1 lock held by rcu_tasks_kthre/13: 
[ 3573.595776]  #0: ffffffffb972c000 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3573.605379] 1 lock held by rcu_tasks_rude_/14: 
[ 3573.609845]  #0: ffffffffb972bd20 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3573.619875] 1 lock held by rcu_tasks_trace/15: 
[ 3573.624347]  #0: ffffffffb972b9e0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3573.634490] 1 lock held by khungtaskd/865: 
[ 3573.638611]  #0: ffffffffb972ccc0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x340 
[ 3573.647618]  
[ 3573.649139] ============================================= 
[ 3573.649139]  
[ 3629.010212] restraintd[2605]: *** Current Time: Sat Jun 10 05:34:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[-- MARK -- Sat Jun 10 09:35:00 2023] 
[ 3689.011047] restraintd[2605]: *** Current Time: Sat Jun 10 05:35:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3695.910116] INFO: task fsstress:570762 blocked for more than 491 seconds. 
[ 3695.916930]       Not tainted 6.4.0-rc5+ #1 
[ 3695.921139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3695.928985] task:fsstress        state:D stack:21664 pid:570762 ppid:570760 flags:0x00000002 
[ 3695.937451] Call Trace: 
[ 3695.939919]  <TASK> 
[ 3695.942046]  __schedule+0x79c/0x1d70 
[ 3695.945655]  ? __pfx___schedule+0x10/0x10 
[ 3695.949689]  ? __lock_acquire+0xbaa/0x1be0 
[ 3695.953824]  ? __lock_release+0x485/0x960 
[ 3695.957866]  schedule+0x130/0x220 
[ 3695.961205]  schedule_timeout+0x22a/0x270 
[ 3695.965244]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3695.969805]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3695.975161]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3695.979549]  __wait_for_common+0x1ca/0x5c0 
[ 3695.983669]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3695.988233]  ? __pfx___wait_for_common+0x10/0x10 
[ 3695.992891]  wait_for_completion_state+0x1d/0x40 
[ 3695.997537]  coredump_wait+0x502/0x750 
[ 3696.001328]  do_coredump+0x2fa/0x1c10 
[ 3696.005013]  ? __pfx___lock_release+0x10/0x10 
[ 3696.009393]  ? __pfx___lock_acquired+0x10/0x10 
[ 3696.013868]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3696.018248]  ? __pfx_do_coredump+0x10/0x10 
[ 3696.022373]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3696.027449]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3696.031742]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3696.036733]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3696.041826]  ? __lock_release+0x485/0x960 
[ 3696.045869]  ? __wait_for_common+0x9e/0x5c0 
[ 3696.050069]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3696.054460]  get_signal+0x12f8/0x1990 
[ 3696.058157]  ? do_send_specific+0xf8/0x280 
[ 3696.062276]  ? __pfx_get_signal+0x10/0x10 
[ 3696.066314]  ? do_send_specific+0x110/0x280 
[ 3696.070527]  ? __pfx_do_send_specific+0x10/0x10 
[ 3696.075087]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3696.079814]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3696.085147]  ? do_tkill+0x186/0x200 
[ 3696.088682]  exit_to_user_mode_loop+0xac/0x160 
[ 3696.093152]  exit_to_user_mode_prepare+0x142/0x150 
[ 3696.097966]  syscall_exit_to_user_mode+0x19/0x50 
[ 3696.102606]  do_syscall_64+0x69/0x90 
[ 3696.106205]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3696.110590]  ? do_syscall_64+0x69/0x90 
[ 3696.114362]  ? do_syscall_64+0x69/0x90 
[ 3696.118137]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3696.122515]  ? do_syscall_64+0x69/0x90 
[ 3696.126288]  ? asm_exc_page_fault+0x22/0x30 
[ 3696.130497]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3696.134874]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3696.139952] RIP: 0033:0x7fe5cfaa157c 
[ 3696.143546] RSP: 002b:00007fffe9f3c6e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3696.151129] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3696.158281] RDX: 0000000000000006 RSI: 000000000008b58a RDI: 000000000008b58a 
[ 3696.165431] RBP: 000000000008b58a R08: 00007fffe9f3c7b0 R09: 00007fe5cfbb14e0 
[ 3696.172585] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3696.179732] R13: 8f5c28f5c28f5c29 R14: 000000000040ac10 R15: 00007fe5cfce86c0 
[ 3696.186900]  </TASK> 
[ 3696.189108] INFO: task fsstress:570763 blocked for more than 491 seconds. 
[ 3696.195919]       Not tainted 6.4.0-rc5+ #1 
[ 3696.200126] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3696.207965] task:fsstress        state:D stack:22832 pid:570763 ppid:570760 flags:0x00000002 
[ 3696.216424] Call Trace: 
[ 3696.218894]  <TASK> 
[ 3696.221025]  __schedule+0x79c/0x1d70 
[ 3696.224632]  ? __pfx___schedule+0x10/0x10 
[ 3696.228666]  ? __lock_acquire+0xbaa/0x1be0 
[ 3696.232791]  ? __lock_release+0x485/0x960 
[ 3696.236832]  schedule+0x130/0x220 
[ 3696.240175]  schedule_timeout+0x22a/0x270 
[ 3696.244202]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3696.248754]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3696.254097]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3696.258480]  __wait_for_common+0x1ca/0x5c0 
[ 3696.262594]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3696.267150]  ? __pfx___wait_for_common+0x10/0x10 
[ 3696.271806]  wait_for_completion_state+0x1d/0x40 
[ 3696.276442]  coredump_wait+0x502/0x750 
[ 3696.280223]  do_coredump+0x2fa/0x1c10 
[ 3696.283904]  ? __pfx___lock_release+0x10/0x10 
[ 3696.288283]  ? __pfx___lock_acquired+0x10/0x10 
[ 3696.292746]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3696.297122]  ? __pfx_do_coredump+0x10/0x10 
[ 3696.301243]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3696.306321]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3696.310616]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3696.315600]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3696.320691]  ? __lock_release+0x485/0x960 
[ 3696.324736]  ? __wait_for_common+0x9e/0x5c0 
[ 3696.328948]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3696.333337]  get_signal+0x12f8/0x1990 
[ 3696.337032]  ? do_send_specific+0xf8/0x280 
[ 3696.341151]  ? __pfx_get_signal+0x10/0x10 
[ 3696.345187]  ? do_send_specific+0x110/0x280 
[ 3696.349392]  ? __pfx_do_send_specific+0x10/0x10 
[ 3696.353963]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3696.358691]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3696.364035]  ? do_tkill+0x186/0x200 
[ 3696.367566]  exit_to_user_mode_loop+0xac/0x160 
[ 3696.372038]  exit_to_user_mode_prepare+0x142/0x150 
[ 3696.376855]  syscall_exit_to_user_mode+0x19/0x50 
[ 3696.381492]  do_syscall_64+0x69/0x90 
[ 3696.385086]  ? __task_pid_nr_ns+0x105/0x3c0 
[ 3696.389299]  ? do_syscall_64+0x69/0x90 
[ 3696.393070]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3696.397446]  ? do_syscall_64+0x69/0x90 
[ 3696.401217]  ? asm_exc_page_fault+0x22/0x30 
[ 3696.405421]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3696.409799]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3696.414873] RIP: 0033:0x7fe5cfaa157c 
[ 3696.418471] RSP: 002b:00007fffe9f3c610 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3696.426053] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3696.433205] RDX: 0000000000000006 RSI: 000000000008b58b RDI: 000000000008b58b 
[ 3696.440353] RBP: 000000000008b58b R08: 00007fffe9f3c6e0 R09: 00007fe5cfbb14e0 
[ 3696.447505] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3696.454653] R13: 8f5c28f5c28f5c29 R14: 000000000040df50 R15: 00007fe5cfce86c0 
[ 3696.461826]  </TASK> 
[ 3696.464034]  
[ 3696.464034] Showing all locks held in the system: 
[ 3696.470235] 1 lock held by rcu_tasks_kthre/13: 
[ 3696.474703]  #0: ffffffffb972c000 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3696.484298] 1 lock held by rcu_tasks_rude_/14: 
[ 3696.488757]  #0: ffffffffb972bd20 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3696.498790] 1 lock held by rcu_tasks_trace/15: 
[ 3696.503249]  #0: ffffffffb972b9e0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3696.513394] 1 lock held by khungtaskd/865: 
[ 3696.517516]  #0: ffffffffb972ccc0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x340 
[ 3696.526526]  
[ 3696.528044] ============================================= 
[ 3696.528044]  
[ 3749.010553] restraintd[2605]: *** Current Time: Sat Jun 10 05:36:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3809.009825] restraintd[2605]: *** Current Time: Sat Jun 10 05:37:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3818.789022] INFO: task fsstress:570762 blocked for more than 614 seconds. 
[ 3818.795829]       Not tainted 6.4.0-rc5+ #1 
[ 3818.800036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3818.807891] task:fsstress        state:D stack:21664 pid:570762 ppid:570760 flags:0x00000002 
[ 3818.816352] Call Trace: 
[ 3818.818821]  <TASK> 
[ 3818.820946]  __schedule+0x79c/0x1d70 
[ 3818.824557]  ? __pfx___schedule+0x10/0x10 
[ 3818.828592]  ? __lock_acquire+0xbaa/0x1be0 
[ 3818.832725]  ? __lock_release+0x485/0x960 
[ 3818.836772]  schedule+0x130/0x220 
[ 3818.840120]  schedule_timeout+0x22a/0x270 
[ 3818.844150]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3818.848707]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3818.854062]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3818.858452]  __wait_for_common+0x1ca/0x5c0 
[ 3818.862572]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3818.867132]  ? __pfx___wait_for_common+0x10/0x10 
[ 3818.871789]  wait_for_completion_state+0x1d/0x40 
[ 3818.876428]  coredump_wait+0x502/0x750 
[ 3818.880221]  do_coredump+0x2fa/0x1c10 
[ 3818.883908]  ? __pfx___lock_release+0x10/0x10 
[ 3818.888294]  ? __pfx___lock_acquired+0x10/0x10 
[ 3818.892768]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3818.897152]  ? __pfx_do_coredump+0x10/0x10 
[ 3818.901280]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3818.906359]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3818.910657]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3818.915642]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3818.920740]  ? __lock_release+0x485/0x960 
[ 3818.924784]  ? __wait_for_common+0x9e/0x5c0 
[ 3818.928992]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3818.933382]  get_signal+0x12f8/0x1990 
[ 3818.937079]  ? do_send_specific+0xf8/0x280 
[ 3818.941205]  ? __pfx_get_signal+0x10/0x10 
[ 3818.945244]  ? do_send_specific+0x110/0x280 
[ 3818.949457]  ? __pfx_do_send_specific+0x10/0x10 
[ 3818.954018]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3818.958746]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3818.964086]  ? do_tkill+0x186/0x200 
[ 3818.967617]  exit_to_user_mode_loop+0xac/0x160 
[ 3818.972082]  exit_to_user_mode_prepare+0x142/0x150 
[ 3818.976904]  syscall_exit_to_user_mode+0x19/0x50 
[ 3818.981544]  do_syscall_64+0x69/0x90 
[ 3818.985146]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3818.989530]  ? do_syscall_64+0x69/0x90 
[ 3818.993312]  ? do_syscall_64+0x69/0x90 
[ 3818.997081]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3819.001465]  ? do_syscall_64+0x69/0x90 
[ 3819.005242]  ? asm_exc_page_fault+0x22/0x30 
[ 3819.009453]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3819.013839]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3819.018912] RIP: 0033:0x7fe5cfaa157c 
[ 3819.022515] RSP: 002b:00007fffe9f3c6e0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3819.030103] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3819.037257] RDX: 0000000000000006 RSI: 000000000008b58a RDI: 000000000008b58a 
[ 3819.044415] RBP: 000000000008b58a R08: 00007fffe9f3c7b0 R09: 00007fe5cfbb14e0 
[ 3819.051564] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3819.058709] R13: 8f5c28f5c28f5c29 R14: 000000000040ac10 R15: 00007fe5cfce86c0 
[ 3819.065896]  </TASK> 
[ 3819.068107] INFO: task fsstress:570763 blocked for more than 614 seconds. 
[ 3819.074916]       Not tainted 6.4.0-rc5+ #1 
[ 3819.079121] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message. 
[ 3819.086961] task:fsstress        state:D stack:22832 pid:570763 ppid:570760 flags:0x00000002 
[ 3819.095411] Call Trace: 
[ 3819.097897]  <TASK> 
[ 3819.100025]  __schedule+0x79c/0x1d70 
[ 3819.103629]  ? __pfx___schedule+0x10/0x10 
[ 3819.107660]  ? __lock_acquire+0xbaa/0x1be0 
[ 3819.111787]  ? __lock_release+0x485/0x960 
[ 3819.115828]  schedule+0x130/0x220 
[ 3819.119172]  schedule_timeout+0x22a/0x270 
[ 3819.123208]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3819.127760]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20 
[ 3819.133107]  ? _raw_spin_unlock_irq+0x2a/0x50 
[ 3819.137490]  __wait_for_common+0x1ca/0x5c0 
[ 3819.141612]  ? __pfx_schedule_timeout+0x10/0x10 
[ 3819.146176]  ? __pfx___wait_for_common+0x10/0x10 
[ 3819.150829]  wait_for_completion_state+0x1d/0x40 
[ 3819.155464]  coredump_wait+0x502/0x750 
[ 3819.159248]  do_coredump+0x2fa/0x1c10 
[ 3819.162933]  ? __pfx___lock_release+0x10/0x10 
[ 3819.167312]  ? __pfx___lock_acquired+0x10/0x10 
[ 3819.171779]  ? do_raw_spin_trylock+0xb5/0x180 
[ 3819.176162]  ? __pfx_do_coredump+0x10/0x10 
[ 3819.180287]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3819.185364]  ? do_raw_spin_unlock+0x55/0x1f0 
[ 3819.189661]  ? _raw_spin_unlock_irqrestore+0x42/0x70 
[ 3819.194654]  ? __debug_check_no_obj_freed+0x1e8/0x3c0 
[ 3819.199747]  ? __lock_release+0x485/0x960 
[ 3819.203795]  ? __wait_for_common+0x9e/0x5c0 
[ 3819.207998]  ? __pfx_dequeue_signal+0x10/0x10 
[ 3819.212397]  get_signal+0x12f8/0x1990 
[ 3819.216094]  ? do_send_specific+0xf8/0x280 
[ 3819.220222]  ? __pfx_get_signal+0x10/0x10 
[ 3819.224258]  ? do_send_specific+0x110/0x280 
[ 3819.228470]  ? __pfx_do_send_specific+0x10/0x10 
[ 3819.233032]  arch_do_signal_or_restart+0x77/0x2f0 
[ 3819.237761]  ? __pfx_arch_do_signal_or_restart+0x10/0x10 
[ 3819.243101]  ? do_tkill+0x186/0x200 
[ 3819.246636]  exit_to_user_mode_loop+0xac/0x160 
[ 3819.251104]  exit_to_user_mode_prepare+0x142/0x150 
[ 3819.255927]  syscall_exit_to_user_mode+0x19/0x50 
[ 3819.260571]  do_syscall_64+0x69/0x90 
[ 3819.264173]  ? __task_pid_nr_ns+0x105/0x3c0 
[ 3819.268387]  ? do_syscall_64+0x69/0x90 
[ 3819.272164]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3819.276554]  ? do_syscall_64+0x69/0x90 
[ 3819.280332]  ? asm_exc_page_fault+0x22/0x30 
[ 3819.284544]  ? lockdep_hardirqs_on+0x79/0x100 
[ 3819.288930]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
[ 3819.294005] RIP: 0033:0x7fe5cfaa157c 
[ 3819.297609] RSP: 002b:00007fffe9f3c610 EFLAGS: 00000246 ORIG_RAX: 00000000000000ea 
[ 3819.305200] RAX: 0000000000000000 RBX: 00007fe5cfce8740 RCX: 00007fe5cfaa157c 
[ 3819.312356] RDX: 0000000000000006 RSI: 000000000008b58b RDI: 000000000008b58b 
[ 3819.319508] RBP: 000000000008b58b R08: 00007fffe9f3c6e0 R09: 00007fe5cfbb14e0 
[ 3819.326662] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000006 
[ 3819.333813] R13: 8f5c28f5c28f5c29 R14: 000000000040df50 R15: 00007fe5cfce86c0 
[ 3819.340992]  </TASK> 
[ 3819.343201] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings 
[ 3819.351395]  
[ 3819.351395] Showing all locks held in the system: 
[ 3819.357596] 1 lock held by rcu_tasks_kthre/13: 
[ 3819.362067]  #0: ffffffffb972c000 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3819.371670] 1 lock held by rcu_tasks_rude_/14: 
[ 3819.376142]  #0: ffffffffb972bd20 (rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3819.386170] 1 lock held by rcu_tasks_trace/15: 
[ 3819.390638]  #0: ffffffffb972b9e0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x26/0x5c0 
[ 3819.400783] 1 lock held by khungtaskd/865: 
[ 3819.404901]  #0: ffffffffb972ccc0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x51/0x340 
[ 3819.413920]  
[ 3819.415443] ============================================= 
[ 3819.415443]  
[ 3869.010274] restraintd[2605]: *** Current Time: Sat Jun 10 05:38:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[ 3929.010015] restraintd[2605]: *** Current Time: Sat Jun 10 05:39:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
...
...
[100469.009966] restraintd[2605]: *** Current Time: Sun Jun 11 08:28:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023 
[100529.010810] restraintd[2605]: *** Current Time: Sun Jun 11 08:29:25 2023  Localwatchdog at: Mon Jun 12 04:37:25 2023
...
...

