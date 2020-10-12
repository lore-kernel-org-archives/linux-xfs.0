Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B952C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 10:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEA4920790
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 10:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="LINbe7Vw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgJLKg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 06:36:29 -0400
Received: from mout.gmx.net ([212.227.17.21]:54043 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387463AbgJLKg3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Oct 2020 06:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602498977;
        bh=Yi738DhoGnMfwh7+7u21N3OypigRMbKpNxNr2sIDHW8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=LINbe7Vw8Mm9HrFMnGMANgZL5qwN2CfoFhb4KCV8aZDFoY/0VXlD2SRzahsZRApN1
         06oQNP4kmThGyyUktG3JKU++u7iepxJYiiC2s2I0gyYuRIe9nrigcpw5PbTLilLJXa
         QgROlTbBILkDiCIAH3nylQirgxoAttranN5FfVXg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [85.212.205.189] ([85.212.205.189]) by web-mail.gmx.net
 (3c-app-gmx-bap12.server.lan [172.19.172.82]) (via HTTP); Mon, 12 Oct 2020
 12:36:17 +0200
MIME-Version: 1.0
Message-ID: <trinity-0d35cf8b-dd96-4b43-9ebf-48eda251522b-1602498977339@3c-app-gmx-bap12>
From:   Johann Kieleich <kieleich@gmx.de>
To:     linux-xfs@vger.kernel.org
Cc:     kieleich@gmx.de
Subject: XFS deadlock in 5.8.14-arch
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 12 Oct 2020 12:36:17 +0200
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
X-Provags-ID: V03:K1:sNt7sdt1N3dYE9fMM3T/MmK5ww/yqeoAAhujZ2tYKVnsZ5HYlLVG9fJ0KtyWZajartHFn
 T1HNC0sUqXFz5+5D5wdN3O5tdZzKQ1yxMWbtEdN9yU1BY9/PnhLvfwjqZsrD0CyjQqwIG2kD2S49
 A/RbrkDnT1SlwzFgzrL03ymgmlnYQTYFwEQ4GpRmst5F6dmbB/a/rgoEj9IzHQX1iQQAOE48ZCuh
 Sapb0Hk7OU0GlL3QL4oxFX9oIueSn8tbJwxWrr1LfTuEDci6XwmOqjMpASKWCdFQ7v82jQka3hsz
 s8=
X-UI-Out-Filterresults: notjunk:1;V03:K0:mzW+7Sm4lJU=:93/+YEy+aTiBQZry8k6H31
 pBmUAlUT0K59/FbhlBNQ2vR6VXIM9023WzVEX2z2Y3GCPXC01PnFS6eF6XcNFQtnzA+84AmS+
 OxbKpR2hS3oVw9f3ogvd9zdBHhPS2HgGYCcoPRm+qMnAsrtX0fRyokV006xI1DutQxmvyXYUe
 IZ5xVIvMRU0DVMLWqt0VZjhxcsoY7FGVpWRgLZsruQuFFz3Ps4h5oFsH5plE23PCsefBZQUKS
 n40cFLks+ZWm9hccoKiFH1VgEvLRpYwRdPWzXHJr0h14YELs+SGmfNMl3nSHcfaVwDYZFF6w+
 sgVJg6gWOhQbRNqw4dGLt+as703N6p1niqQIie4Xq2k0lpNeFzDz46Y/ZKLHcP3nYLsqaxeKt
 aloZB8SUWXAnqHf0dFNxEUN8qwP0uofdS+tIrJ4TmRgAS6DQk7hA5+gASRqVJQIbcjJ2j7hQX
 8pV3uhVobWKps+z50ioJ6LmdGOHJBl8fJQIve2a4ZMACaTHhTt8afCzJMSD+v7hh5hqVsbJCs
 IGdXycGW4u8Gvn9sDHSddFvR0SkPFo1bpzbWXsO28cQ+8ZlqdgzDhudUCneH/xQDRg56xFpZ4
 08Rx2JlQB73H4/dGmIesEilWgLGZvFR0uB2K/suSChnmK4WzT08jNDbWvLTUnCqLNwJkEigY4
 afOdW7JiQogIn0XvpT+1DEoQZX9aJk5xpvwJJNL5MiEorx9xii+rVzpfrmuGhvjFGwSk=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

when copying 10GB of files (from/to XFS on LVM on LUKS on RAID), system hu=
ng and did not recover for >1 hour=2E
=C2=A0
Other file access hung too=2E Had to REISUB=2E Some file corruption afterw=
ards=2E
=C2=A0
Is this a known issue?=C2=A0It only happened once, so far I am unable to r=
eproduce it=2E

Kind=C2=A0regards
Johann
=C2=A0
------------

Oct 11 15:15:43 kernel: INFO: task cp:9636 blocked for more than 122 secon=
ds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: cp              D    0  9636   9616 0x00000000
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_create+0x476/0x560 [xfs]
Oct 11 15:15:43 kernel:  xfs_generic_create+0x269/0x340 [xfs]
Oct 11 15:15:43 kernel:  ? d_splice_alias+0x165/0x450
Oct 11 15:15:43 kernel:  path_openat+0xdea/0x10f0
Oct 11 15:15:43 kernel:  do_filp_open+0x9c/0x140
Oct 11 15:15:43 kernel:  do_sys_openat2+0xbb/0x170
Oct 11 15:15:43 kernel:  __x64_sys_openat+0x54/0x90
Oct 11 15:15:43 kernel:  do_syscall_64+0x44/0x70
Oct 11 15:15:43 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Oct 11 15:15:43 kernel: RIP: 0033:0x7f088f47dc1b
Oct 11 15:15:43 kernel: Code: Bad RIP value=2E
Oct 11 15:15:43 kernel: RSP: 002b:00007ffed49d4280 EFLAGS: 00000246 ORIG_R=
AX: 0000000000000101
Oct 11 15:15:43 kernel: RAX: ffffffffffffffda RBX: 00007ffed49d4860 RCX: 0=
0007f088f47dc1b
Oct 11 15:15:43 kernel: RDX: 00000000000000c1 RSI: 00005593f03038a0 RDI: 0=
0000000ffffff9c
Oct 11 15:15:43 kernel: RBP: 00005593f03038a0 R08: 0000000000000001 R09: 0=
000000000000000
Oct 11 15:15:43 kernel: R10: 0000000000000180 R11: 0000000000000246 R12: 0=
0000000000000c1
Oct 11 15:15:43 kernel: R13: 0000000000000000 R14: 00005593f03038a0 R15: 0=
000000000000003
Oct 11 15:15:43 kernel: INFO: task kworker/2:5:9646 blocked for more than =
122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:5     D    0  9646      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:13:9654 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:13    D    0  9654      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:36:9677 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:36    D    0  9677      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:37:9678 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:37    D    0  9678      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:38:9679 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:38    D    0  9679      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:53:9694 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:53    D    0  9694      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:77:9718 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:77    D    0  9718      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:82:9723 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:82    D    0  9723      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
Oct 11 15:15:43 kernel: INFO: task kworker/2:96:9737 blocked for more than=
 122 seconds=2E
Oct 11 15:15:43 kernel:       Tainted: G     U            5=2E8=2E14-arch1=
-1 #1
Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"=
 disables this message=2E
Oct 11 15:15:43 kernel: kworker/2:96    D    0  9737      2 0x00004000
Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
Oct 11 15:15:43 kernel: Call Trace:
Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
Oct 11 15:15:43 kernel:  kthread+0x142/0x160
Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30

----------
