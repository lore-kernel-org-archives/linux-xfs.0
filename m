Return-Path: <SRS0=J5MO=ZF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B9CC43331
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 10:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7919E2245C
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Nov 2019 10:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKoevPb2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfKMKFO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Nov 2019 05:05:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45538 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfKMKFN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Nov 2019 05:05:13 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so1583915wrs.12
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 02:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zO+IXfYeDAetO1b/p7JoTE5NPowdtqfKiPF7sx1KaJ4=;
        b=iKoevPb2vpi4mUkzp0kIfIkdqD//8/4pU/ZgdQhg95gG8r+QXITdgdV49l7D9v+E1J
         qqD+U03CBB33cG7d0AgQQPXribX+8o7DBD/ys9joH6rbD8bQO/Tq5AweDjx3PH3Fpyaq
         gl+vgSaZXiA7jIeOfqyG16ItYTVQX+OWuL0eLx47Fb2ipSYT1V9PsT7B0xtFuh+sZyzt
         cdCiidIBHKjVXrO6fjJ44gMIcThxCPpM1EfwmQ7Abz1sMAAyQ6bX/MLHhbBr6W45GJac
         e1GtdeTEgUPJk02+8xcwa+aWRO+Am445TTNJLt1CT21SasaUDG/a/tOaX/Qa9jY13W3v
         MwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zO+IXfYeDAetO1b/p7JoTE5NPowdtqfKiPF7sx1KaJ4=;
        b=QXPjCTzAzQogL9pDoBuqZgmQIzM/dviojnb9ph5ez9nYn6E2pFQX+dAuL/Ub4TnOWj
         bP93ZBeaVhJyud6xGGj+0o88UxfxQobZxjPR6x+HqU8dclestuvhTJPTZdQMEv25DNzP
         ZKgokn5zjYrnwKeXs7jrq1cak+YVb3hwGkkmVRiI9SpCTuOvHTqc+IB0xy24ZKeenhq6
         b532C9rBs+oMfGQCggOzkUbUlIGZmUkzEHLY0EJ7ytWB3SdA2XyeFTw22+vemTNhlMsM
         XBQVgAz24K0Pqtrh06STGVYnu63HjQdAUkleUwd6qTOiKrvr+ec7cctxZT+x1yExllau
         1XzQ==
X-Gm-Message-State: APjAAAXPSyjzIBmiThpzYG6w5j7m1Bwk7RxEtrop3aOUT6PXClrN80uq
        Mb8C7LJfTM0+wkr1x4dBnxUO/4yg8GzX5SLz+94seQ==
X-Google-Smtp-Source: APXvYqzldkVnPh62Za8jyjRFxYlkTPdwwRmP8RpL4JSPl+fC2qD9Svb/UNgybiwlkOKs89jJF8XS/uEc61cMGDhDLA4=
X-Received: by 2002:a05:6000:1612:: with SMTP id u18mr17936wrb.306.1573639507015;
 Wed, 13 Nov 2019 02:05:07 -0800 (PST)
MIME-Version: 1.0
References: <CALjAwxiuTYAVvGGUXLx6Bo-zNuW5+WXL=A8DqR5oD6D5tsKwng@mail.gmail.com>
 <20191105085446.abx27ahchg2k7d2w@orion> <CALjAwxiNExFd_eeMAFNLrMU8EKn0FNWrRrgeMWj-CCT4s7DRjA@mail.gmail.com>
 <20191105103652.n5zwf6ty3wvhti5f@orion>
In-Reply-To: <20191105103652.n5zwf6ty3wvhti5f@orion>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Wed, 13 Nov 2019 10:04:39 +0000
Message-ID: <CALjAwxhK1OSioY1xChRRb6ruk7bGSJXMtMDRcCn=XgSmtOdFKg@mail.gmail.com>
Subject: Re: Tasks blocking forever with XFS stack traces
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 5 Nov 2019 at 10:37, Carlos Maiolino <cmaiolino@redhat.com> wrote:
>
> I can't say anything if there is any bug related with the issue first because I
> honestly don't remember, second because you are using an old distro kernel which
> I have no idea to know which bug fixes have been backported or not. Maybe
> somebody else can remember of any bug that might be related, but the amount of
> threads you have waiting for log IO, and that misconfigured striping for the log
> smells smoke to me.
>
> I let you know if I can identify anything else later.

So just to let anyone who might be following this know, going to a 5.0
kernel didn't solve the issue:

Nov 12 16:45:02 <host> kernel: [27678.931551] INFO: task
kworker/50:0:20430 blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.931613]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.931667] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.931723] kworker/50:0    D    0
20430      2 0x80000080
Nov 12 16:45:02 <host> kernel: [27678.931801] Workqueue:
xfs-sync/md126 xfs_log_worker [xfs]
Nov 12 16:45:02 <host> kernel: [27678.931804] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.931814]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.931819]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.931823]  schedule_timeout+0x1db/0x360
Nov 12 16:45:02 <host> kernel: [27678.931829]  ? ttwu_do_activate+0x77/0x80
Nov 12 16:45:02 <host> kernel: [27678.931833]  wait_for_completion+0xba/0x140
Nov 12 16:45:02 <host> kernel: [27678.931837]  ? wake_up_q+0x80/0x80
Nov 12 16:45:02 <host> kernel: [27678.931843]  __flush_work+0x15c/0x210
Nov 12 16:45:02 <host> kernel: [27678.931847]  ?
worker_detach_from_pool+0xb0/0xb0
Nov 12 16:45:02 <host> kernel: [27678.931850]  flush_work+0x10/0x20
Nov 12 16:45:02 <host> kernel: [27678.931915]
xlog_cil_force_lsn+0x7b/0x210 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.931920]  ? __switch_to_asm+0x41/0x70
Nov 12 16:45:02 <host> kernel: [27678.931924]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.931928]  ? __switch_to_asm+0x41/0x70
Nov 12 16:45:02 <host> kernel: [27678.931931]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.931935]  ? __switch_to_asm+0x41/0x70
Nov 12 16:45:02 <host> kernel: [27678.931938]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.931992]  ? xfs_log_worker+0x34/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932043]  xfs_log_force+0x95/0x2e0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932047]  ? __switch_to+0x96/0x4e0
Nov 12 16:45:02 <host> kernel: [27678.932051]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.932054]  ? __switch_to_asm+0x41/0x70
Nov 12 16:45:02 <host> kernel: [27678.932058]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.932107]  xfs_log_worker+0x34/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932111]  process_one_work+0x1fd/0x400
Nov 12 16:45:02 <host> kernel: [27678.932114]  worker_thread+0x34/0x410
Nov 12 16:45:02 <host> kernel: [27678.932120]  kthread+0x121/0x140
Nov 12 16:45:02 <host> kernel: [27678.932123]  ? process_one_work+0x400/0x400
Nov 12 16:45:02 <host> kernel: [27678.932127]  ? kthread_park+0xb0/0xb0
Nov 12 16:45:02 <host> kernel: [27678.932132]  ret_from_fork+0x35/0x40
Nov 12 16:45:02 <host> kernel: [27678.932146] INFO: task
kworker/u161:0:46903 blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.932200]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.932253] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.932309] kworker/u161:0  D    0
46903      2 0x80000080
Nov 12 16:45:02 <host> kernel: [27678.932316] Workqueue: writeback
wb_workfn (flush-9:126)
Nov 12 16:45:02 <host> kernel: [27678.932319] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.932323]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.932373]  ? xfs_map_blocks+0xab/0x450 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932376]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.932380]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.932386]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.932390]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.932393]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.932445]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932492]  xfs_map_blocks+0xab/0x450 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932497]  ? wait_woken+0x80/0x80
Nov 12 16:45:02 <host> kernel: [27678.932503]  ? blk_queue_split+0x10c/0x640
Nov 12 16:45:02 <host> kernel: [27678.932509]  ? kmem_cache_alloc+0x15f/0x1c0
Nov 12 16:45:02 <host> kernel: [27678.932561]  ? kmem_zone_alloc+0x6c/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932607]
xfs_do_writepage+0x110/0x410 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932614]  write_cache_pages+0x1bc/0x480
Nov 12 16:45:02 <host> kernel: [27678.932658]  ?
xfs_vm_writepages+0xa0/0xa0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932662]  ? submit_bio+0x73/0x140
Nov 12 16:45:02 <host> kernel: [27678.932703]  ?
xfs_setfilesize_trans_alloc.isra.16+0x41/0x90 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932745]  xfs_vm_writepages+0x6b/0xa0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.932750]  do_writepages+0x4b/0xe0
Nov 12 16:45:02 <host> kernel: [27678.932754]
__writeback_single_inode+0x40/0x330
Nov 12 16:45:02 <host> kernel: [27678.932756]  ?
__writeback_single_inode+0x40/0x330
Nov 12 16:45:02 <host> kernel: [27678.932759]  writeback_sb_inodes+0x1e6/0x510
Nov 12 16:45:02 <host> kernel: [27678.932763]  __writeback_inodes_wb+0x67/0xb0
Nov 12 16:45:02 <host> kernel: [27678.932766]  wb_writeback+0x265/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.932770]  ? strp_read_sock+0x70/0xa0
Nov 12 16:45:02 <host> kernel: [27678.932772]  wb_workfn+0x180/0x400
Nov 12 16:45:02 <host> kernel: [27678.932775]  ? wb_workfn+0x180/0x400
Nov 12 16:45:02 <host> kernel: [27678.932779]  process_one_work+0x1fd/0x400
Nov 12 16:45:02 <host> kernel: [27678.932783]  worker_thread+0x34/0x410
Nov 12 16:45:02 <host> kernel: [27678.932787]  kthread+0x121/0x140
Nov 12 16:45:02 <host> kernel: [27678.932790]  ? process_one_work+0x400/0x400
Nov 12 16:45:02 <host> kernel: [27678.932794]  ? kthread_park+0xb0/0xb0
Nov 12 16:45:02 <host> kernel: [27678.932799]  ret_from_fork+0x35/0x40
Nov 12 16:45:02 <host> kernel: [27678.932843] INFO: task
kworker/58:0:48437 blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.932895]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.932948] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.933002] kworker/58:0    D    0
48437      2 0x80000080
Nov 12 16:45:02 <host> kernel: [27678.933059] Workqueue: xfs-cil/md126
xlog_cil_push_work [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933061] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.933065]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.933117]  ? xlog_bdstrat+0x37/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933120]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.933170]
xlog_state_get_iclog_space+0x105/0x2d0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933174]  ? wake_up_q+0x80/0x80
Nov 12 16:45:02 <host> kernel: [27678.933224]  xlog_write+0x163/0x6e0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933273]  xlog_cil_push+0x2a7/0x400 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933322]
xlog_cil_push_work+0x15/0x20 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933326]  process_one_work+0x1fd/0x400
Nov 12 16:45:02 <host> kernel: [27678.933329]  worker_thread+0x34/0x410
Nov 12 16:45:02 <host> kernel: [27678.933334]  kthread+0x121/0x140
Nov 12 16:45:02 <host> kernel: [27678.933337]  ? process_one_work+0x400/0x400
Nov 12 16:45:02 <host> kernel: [27678.933341]  ? kthread_park+0xb0/0xb0
Nov 12 16:45:02 <host> kernel: [27678.933345]  ret_from_fork+0x35/0x40
Nov 12 16:45:02 <host> kernel: [27678.933354] INFO: task ninja:53333
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.933401]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.933453] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.933508] ninja           D    0
53333  53327 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.933511] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.933515]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.933565]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933568]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.933572]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.933577]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.933580]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.933631]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933635]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.933684]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933730]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933762]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933814]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.933818]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.933823]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.933827]  ?
legitimize_path.isra.31+0x2e/0x60
Nov 12 16:45:02 <host> kernel: [27678.933832]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.933837]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.933840]  filename_lookup+0x130/0x190
Nov 12 16:45:02 <host> kernel: [27678.933846]  ?
iomap_file_buffered_write+0x6e/0xa0
Nov 12 16:45:02 <host> kernel: [27678.933850]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.933854]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.933858]  ? __audit_getname+0x97/0xb0
Nov 12 16:45:02 <host> kernel: [27678.933861]  user_path_at_empty+0x36/0x40
Nov 12 16:45:02 <host> kernel: [27678.933864]  ? user_path_at_empty+0x36/0x40
Nov 12 16:45:02 <host> kernel: [27678.933867]  vfs_statx+0x76/0xe0
Nov 12 16:45:02 <host> kernel: [27678.933871]  __do_sys_newstat+0x3d/0x70
Nov 12 16:45:02 <host> kernel: [27678.933876]  ? syscall_trace_enter+0x1da/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.933880]  __x64_sys_newstat+0x16/0x20
Nov 12 16:45:02 <host> kernel: [27678.933884]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.933889]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.933892] RIP: 0033:0x7f0a393fc775
Nov 12 16:45:02 <host> kernel: [27678.933900] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.933902] RSP:
002b:00007ffdaaa336b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000004
Nov 12 16:45:02 <host> kernel: [27678.933905] RAX: ffffffffffffffda
RBX: 00007ffdaaa33740 RCX: 00007f0a393fc775
Nov 12 16:45:02 <host> kernel: [27678.933906] RDX: 00007ffdaaa33740
RSI: 00007ffdaaa33740 RDI: 0000556f5acdf100
Nov 12 16:45:02 <host> kernel: [27678.933908] RBP: 00007ffdaaa336d0
R08: 00007ffdaaa33866 R09: 0000000000000036
Nov 12 16:45:02 <host> kernel: [27678.933909] R10: 00007ffdaaa33867
R11: 0000000000000246 R12: 00007ffdaaa33820
Nov 12 16:45:02 <host> kernel: [27678.933911] R13: 00007ffdaaa33840
R14: 0000000000000000 R15: 0000000057d60100
Nov 12 16:45:02 <host> kernel: [27678.933920] INFO: task c++:56846
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.933967]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.934019] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.934074] c++             D    0
56846  56844 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.934077] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.934081]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.934084]  ? __switch_to+0x309/0x4e0
Nov 12 16:45:02 <host> kernel: [27678.934087]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.934091]  schedule_timeout+0x1db/0x360
Nov 12 16:45:02 <host> kernel: [27678.934093]  ? __schedule+0x2c8/0x870
Nov 12 16:45:02 <host> kernel: [27678.934097]  wait_for_completion+0xba/0x140
Nov 12 16:45:02 <host> kernel: [27678.934101]  ? wake_up_q+0x80/0x80
Nov 12 16:45:02 <host> kernel: [27678.934104]  __flush_work+0x15c/0x210
Nov 12 16:45:02 <host> kernel: [27678.934107]  ?
worker_detach_from_pool+0xb0/0xb0
Nov 12 16:45:02 <host> kernel: [27678.934111]  flush_work+0x10/0x20
Nov 12 16:45:02 <host> kernel: [27678.934162]
xlog_cil_force_lsn+0x7b/0x210 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934211]  ? xfs_buf_lock+0xe9/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934261]  xfs_log_force+0x95/0x2e0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934309]  ?
xfs_buf_find.isra.29+0x1fa/0x600 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934355]  xfs_buf_lock+0xe9/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934399]
xfs_buf_find.isra.29+0x1fa/0x600 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934442]  xfs_buf_get_map+0x43/0x2b0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934496]
xfs_trans_get_buf_map+0xec/0x170 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934534]  xfs_da_get_buf+0xbd/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934574]
xfs_dir3_data_init+0x6e/0x210 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934613]
xfs_dir2_sf_to_block+0x12e/0x6e0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934649]  ?
xfs_dir2_sf_to_block+0x12e/0x6e0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934700]  ? kmem_zone_alloc+0x6c/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934750]  ? kmem_zone_alloc+0x6c/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934797]  ?
xlog_grant_head_check+0x54/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934838]
xfs_dir2_sf_addname+0xd9/0x6c0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934843]  ? __kmalloc+0x178/0x210
Nov 12 16:45:02 <host> kernel: [27678.934891]  ? kmem_alloc+0x6c/0xf0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934930]
xfs_dir_createname+0x182/0x1d0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.934979]  xfs_rename+0x771/0x8d0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935029]  xfs_vn_rename+0xd3/0x140 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935033]  vfs_rename+0x383/0x920
Nov 12 16:45:02 <host> kernel: [27678.935037]  do_renameat2+0x4ca/0x590
Nov 12 16:45:02 <host> kernel: [27678.935041]  __x64_sys_rename+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.935045]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.935050]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.935052] RIP: 0033:0x7f5dc9e25d37
Nov 12 16:45:02 <host> kernel: [27678.935057] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.935059] RSP:
002b:00007ffdcc39b908 EFLAGS: 00000213 ORIG_RAX: 0000000000000052
Nov 12 16:45:02 <host> kernel: [27678.935061] RAX: ffffffffffffffda
RBX: 00007ffdcc39b934 RCX: 00007f5dc9e25d37
Nov 12 16:45:02 <host> kernel: [27678.935063] RDX: 000055aee60eb010
RSI: 000055aee60f02d0 RDI: 000055aee60f01c0
Nov 12 16:45:02 <host> kernel: [27678.935064] RBP: 00007ffdcc39b9d0
R08: 0000000000000000 R09: 000055aee61321c0
Nov 12 16:45:02 <host> kernel: [27678.935066] R10: 000055aee60eb010
R11: 0000000000000213 R12: 0000000000000004
Nov 12 16:45:02 <host> kernel: [27678.935068] R13: 0000000000006e90
R14: 000055aee60f00d0 R15: 0000000000006e90
Nov 12 16:45:02 <host> kernel: [27678.935071] INFO: task c++:56847
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.935118]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.935170] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.935269] c++             D    0
56847  56845 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.935287] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.935293]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.935347]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935356]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.935364]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.935372]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.935381]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.935436]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935448]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.935501]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935551]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935588]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935643]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.935652]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.935664]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.935675]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.935684]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.935692]  path_openat+0x38f/0x1700
Nov 12 16:45:02 <host> kernel: [27678.935702]  ? insert_pfn+0x152/0x240
Nov 12 16:45:02 <host> kernel: [27678.935709]  ? vmf_insert_pfn_prot+0x9b/0x120
Nov 12 16:45:02 <host> kernel: [27678.935716]  do_filp_open+0x9b/0x110
Nov 12 16:45:02 <host> kernel: [27678.935723]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.935734]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.935746]  ? __alloc_fd+0x46/0x170
Nov 12 16:45:02 <host> kernel: [27678.935756]  do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.935764]  ? do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.935773]  __x64_sys_openat+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.935783]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.935793]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.935801] RIP: 0033:0x7fe4f94a5c8e
Nov 12 16:45:02 <host> kernel: [27678.935813] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.935818] RSP:
002b:00007ffc4c6e2550 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
Nov 12 16:45:02 <host> kernel: [27678.935828] RAX: ffffffffffffffda
RBX: 000000000003a2f8 RCX: 00007fe4f94a5c8e
Nov 12 16:45:02 <host> kernel: [27678.935836] RDX: 00000000000000c2
RSI: 0000557e925fdc80 RDI: 00000000ffffff9c
Nov 12 16:45:02 <host> kernel: [27678.935841] RBP: 0000000000000000
R08: 00007ffc4c7250a0 R09: 00007ffc4c725080
Nov 12 16:45:02 <host> kernel: [27678.935847] R10: 0000000000000180
R11: 0000000000000246 R12: 0000557e925fdc80
Nov 12 16:45:02 <host> kernel: [27678.935854] R13: 0000557e925fdcda
R14: 00007fe4f9551c80 R15: 8421084210842109
Nov 12 16:45:02 <host> kernel: [27678.935863] INFO: task c++:56849
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.935917]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.935971] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.936028] c++             D    0
56849  56848 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.936031] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.936035]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.936084]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936087]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.936091]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.936095]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.936099]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.936149]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936154]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.936202]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936250]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936283]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936335]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936340]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.936344]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.936348]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.936352]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.936356]  path_openat+0x38f/0x1700
Nov 12 16:45:02 <host> kernel: [27678.936360]  ? insert_pfn+0x152/0x240
Nov 12 16:45:02 <host> kernel: [27678.936364]  ? vmf_insert_pfn_prot+0x9b/0x120
Nov 12 16:45:02 <host> kernel: [27678.936368]  do_filp_open+0x9b/0x110
Nov 12 16:45:02 <host> kernel: [27678.936371]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.936375]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.936379]  ? __alloc_fd+0x46/0x170
Nov 12 16:45:02 <host> kernel: [27678.936383]  do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.936386]  ? do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.936390]  __x64_sys_openat+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.936394]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.936399]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.936401] RIP: 0033:0x7fe5c6575c8e
Nov 12 16:45:02 <host> kernel: [27678.936407] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.936409] RSP:
002b:00007fffbd824140 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
Nov 12 16:45:02 <host> kernel: [27678.936411] RAX: ffffffffffffffda
RBX: 000000000003a2f8 RCX: 00007fe5c6575c8e
Nov 12 16:45:02 <host> kernel: [27678.936413] RDX: 00000000000000c2
RSI: 0000561423cc41c0 RDI: 00000000ffffff9c
Nov 12 16:45:02 <host> kernel: [27678.936414] RBP: 0000000000000000
R08: 00007fffbd8f80a0 R09: 00007fffbd8f8080
Nov 12 16:45:02 <host> kernel: [27678.936416] R10: 0000000000000180
R11: 0000000000000246 R12: 0000561423cc41c0
Nov 12 16:45:02 <host> kernel: [27678.936417] R13: 0000561423cc4218
R14: 00007fe5c6621c80 R15: 8421084210842109
Nov 12 16:45:02 <host> kernel: [27678.936421] INFO: task c++:56851
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.936474]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.936535] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.936596] c++             D    0
56851  56850 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.936605] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.936615]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.936623]  ? __switch_to_asm+0x41/0x70
Nov 12 16:45:02 <host> kernel: [27678.936631]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.936683]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936692]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.936703]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.936712]  ? __switch_to_asm+0x35/0x70
Nov 12 16:45:02 <host> kernel: [27678.936722]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.936731]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.936787]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936796]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.936852]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936903]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936943]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.936998]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937002]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.937006]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.937012]  ? inode_permission+0x63/0x1a0
Nov 12 16:45:02 <host> kernel: [27678.937016]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.937020]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.937023]  filename_parentat+0x147/0x190
Nov 12 16:45:02 <host> kernel: [27678.937028]  ? radix_tree_lookup+0xd/0x10
Nov 12 16:45:02 <host> kernel: [27678.937032]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.937036]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.937040]  do_renameat2+0xc6/0x590
Nov 12 16:45:02 <host> kernel: [27678.937042]  ? do_renameat2+0xc6/0x590
Nov 12 16:45:02 <host> kernel: [27678.937046]  ?
__audit_syscall_entry+0xdd/0x130
Nov 12 16:45:02 <host> kernel: [27678.937050]  __x64_sys_rename+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.937054]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.937058]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.937060] RIP: 0033:0x7f83b31c6d37
Nov 12 16:45:02 <host> kernel: [27678.937065] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.937067] RSP:
002b:00007ffd60610948 EFLAGS: 00000213 ORIG_RAX: 0000000000000052
Nov 12 16:45:02 <host> kernel: [27678.937069] RAX: ffffffffffffffda
RBX: 00007ffd60610974 RCX: 00007f83b31c6d37
Nov 12 16:45:02 <host> kernel: [27678.937070] RDX: 000056474e2f3010
RSI: 000056474e2f82d0 RDI: 000056474e2f81c0
Nov 12 16:45:02 <host> kernel: [27678.937074] RBP: 00007ffd60610a10
R08: 0000000000000000 R09: 000056474e33cc20
Nov 12 16:45:02 <host> kernel: [27678.937075] R10: 000056474e2f3010
R11: 0000000000000213 R12: 0000000000000004
Nov 12 16:45:02 <host> kernel: [27678.937077] R13: 0000000000003720
R14: 000056474e2f80d0 R15: 0000000000003720
Nov 12 16:45:02 <host> kernel: [27678.937081] INFO: task c++:56853
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.937127]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.937179] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.937234] c++             D    0
56853  56852 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.937237] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.937241]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.937289]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937292]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.937296]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.937301]  ? xas_store+0x1e1/0x5b0
Nov 12 16:45:02 <host> kernel: [27678.937305]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.937309]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.937358]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937368]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.937424]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937476]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937514]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937571]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.937581]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.937605]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.937614]  ? inode_permission+0x63/0x1a0
Nov 12 16:45:02 <host> kernel: [27678.937623]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.937631]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.937638]  filename_parentat+0x147/0x190
Nov 12 16:45:02 <host> kernel: [27678.937646]  ? radix_tree_lookup+0xd/0x10
Nov 12 16:45:02 <host> kernel: [27678.937652]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.937661]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.937669]  do_renameat2+0xc6/0x590
Nov 12 16:45:02 <host> kernel: [27678.937676]  ? do_renameat2+0xc6/0x590
Nov 12 16:45:02 <host> kernel: [27678.937683]  ?
__audit_syscall_entry+0xdd/0x130
Nov 12 16:45:02 <host> kernel: [27678.937690]  __x64_sys_rename+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.937694]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.937699]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.937701] RIP: 0033:0x7faba8af6d37
Nov 12 16:45:02 <host> kernel: [27678.937705] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.937707] RSP:
002b:00007fff0e234358 EFLAGS: 00000213 ORIG_RAX: 0000000000000052
Nov 12 16:45:02 <host> kernel: [27678.937709] RAX: ffffffffffffffda
RBX: 00007fff0e234384 RCX: 00007faba8af6d37
Nov 12 16:45:02 <host> kernel: [27678.937710] RDX: 0000564342653010
RSI: 00005643426577a0 RDI: 0000564342659c80
Nov 12 16:45:02 <host> kernel: [27678.937712] RBP: 00007fff0e234420
R08: 0000000000000000 R09: 0000564342699f20
Nov 12 16:45:02 <host> kernel: [27678.937713] R10: 0000564342653010
R11: 0000000000000213 R12: 0000000000000004
Nov 12 16:45:02 <host> kernel: [27678.937715] R13: 000000000000f160
R14: 0000564342658030 R15: 000000000000f160
Nov 12 16:45:02 <host> kernel: [27678.937719] INFO: task c++:56855
blocked for more than 120 seconds.
Nov 12 16:45:02 <host> kernel: [27678.937765]       Tainted: G
  OE     5.0.0-32-generic #34~18.04.2-Ubuntu
Nov 12 16:45:02 <host> kernel: [27678.939382] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 12 16:45:02 <host> kernel: [27678.940988] c++             D    0
56855  56854 0x000003a0
Nov 12 16:45:02 <host> kernel: [27678.940991] Call Trace:
Nov 12 16:45:02 <host> kernel: [27678.940995]  __schedule+0x2c0/0x870
Nov 12 16:45:02 <host> kernel: [27678.941048]  ?
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941052]  schedule+0x2c/0x70
Nov 12 16:45:02 <host> kernel: [27678.941055]  rwsem_down_read_failed+0xe8/0x180
Nov 12 16:45:02 <host> kernel: [27678.941062]
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.941066]  ?
call_rwsem_down_read_failed+0x18/0x30
Nov 12 16:45:02 <host> kernel: [27678.941116]  ? xfs_trans_roll+0xe0/0xe0 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941121]  down_read+0x20/0x40
Nov 12 16:45:02 <host> kernel: [27678.941169]  xfs_ilock+0xd5/0x100 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941217]
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941251]  xfs_attr_get+0xbe/0x120 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941303]  xfs_xattr_get+0x4b/0x70 [xfs]
Nov 12 16:45:02 <host> kernel: [27678.941307]  __vfs_getxattr+0x59/0x80
Nov 12 16:45:02 <host> kernel: [27678.941312]  get_vfs_caps_from_disk+0x6a/0x170
Nov 12 16:45:02 <host> kernel: [27678.941317]  audit_copy_inode+0x6d/0xb0
Nov 12 16:45:02 <host> kernel: [27678.941322]  __audit_inode+0x17b/0x2f0
Nov 12 16:45:02 <host> kernel: [27678.941325]  path_openat+0x38f/0x1700
Nov 12 16:45:02 <host> kernel: [27678.941330]  ? insert_pfn+0x152/0x240
Nov 12 16:45:02 <host> kernel: [27678.941334]  ? vmf_insert_pfn_prot+0x9b/0x120
Nov 12 16:45:02 <host> kernel: [27678.941337]  do_filp_open+0x9b/0x110
Nov 12 16:45:02 <host> kernel: [27678.941341]  ? __check_object_size+0xdb/0x1b0
Nov 12 16:45:02 <host> kernel: [27678.941345]  ? path_get+0x27/0x30
Nov 12 16:45:02 <host> kernel: [27678.941349]  ? __alloc_fd+0x46/0x170
Nov 12 16:45:02 <host> kernel: [27678.941353]  do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.941356]  ? do_sys_open+0x1bb/0x2d0
Nov 12 16:45:02 <host> kernel: [27678.941360]  __x64_sys_openat+0x20/0x30
Nov 12 16:45:02 <host> kernel: [27678.941364]  do_syscall_64+0x5a/0x120
Nov 12 16:45:02 <host> kernel: [27678.941369]
entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 12 16:45:02 <host> kernel: [27678.941371] RIP: 0033:0x7f8bc5732c8e
Nov 12 16:45:02 <host> kernel: [27678.941376] Code: Bad RIP value.
Nov 12 16:45:02 <host> kernel: [27678.941379] RSP:
002b:00007ffe3e6fa850 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
Nov 12 16:45:02 <host> kernel: [27678.941382] RAX: ffffffffffffffda
RBX: 000000000003a2f8 RCX: 00007f8bc5732c8e
Nov 12 16:45:02 <host> kernel: [27678.941383] RDX: 00000000000000c2
RSI: 000055b674710770 RDI: 00000000ffffff9c
Nov 12 16:45:02 <host> kernel: [27678.941385] RBP: 0000000000000000
R08: 00007ffe3e7960a0 R09: 00007ffe3e796080
Nov 12 16:45:02 <host> kernel: [27678.941386] R10: 0000000000000180
R11: 0000000000000246 R12: 000055b674710770
Nov 12 16:45:02 <host> kernel: [27678.941388] R13: 000055b6747107cd
R14: 00007f8bc57dec80 R15: 8421084210842109

--
Sitsofe | http://sucs.org/~sits/
