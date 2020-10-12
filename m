Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D85C433E7
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 12:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F221208D5
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 12:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d1ZReB7c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbgJLMfO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 08:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388334AbgJLMfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 08:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602506109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0Snu3FtJ3SkgYoJFDyfNe7ihMtGy7JQTQt2hVbrnMM=;
        b=d1ZReB7cr0IN1GZ4OA/MVD0RFDj4n5ieePMdN7VbYc4c+5CRd4dyxRrsDJL55CnANBXHl/
        ZZ3E3haohFYZ7q+9bmvrJ3uamQFyVHU14mlu+iYMXFq3TUBfphjw5kOI1ZOJDLw0NxC+2v
        GPniO1fclnzMfife5Dfu1W9GbzNBTnc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-sXHBhFLjMlSfmGcpjCwKbg-1; Mon, 12 Oct 2020 08:35:05 -0400
X-MC-Unique: sXHBhFLjMlSfmGcpjCwKbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC25186DD2B;
        Mon, 12 Oct 2020 12:35:03 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 567E95C225;
        Mon, 12 Oct 2020 12:35:03 +0000 (UTC)
Date:   Mon, 12 Oct 2020 08:35:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Johann Kieleich <kieleich@gmx.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS deadlock in 5.8.14-arch
Message-ID: <20201012123501.GC917726@bfoster>
References: <trinity-0d35cf8b-dd96-4b43-9ebf-48eda251522b-1602498977339@3c-app-gmx-bap12>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-0d35cf8b-dd96-4b43-9ebf-48eda251522b-1602498977339@3c-app-gmx-bap12>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 12, 2020 at 12:36:17PM +0200, Johann Kieleich wrote:
> Hello,
> 
> when copying 10GB of files (from/to XFS on LVM on LUKS on RAID), system hung and did not recover for >1 hour.
>  
> Other file access hung too. Had to REISUB. Some file corruption afterwards.
>  
> Is this a known issue? It only happened once, so far I am unable to reproduce it.
> 
> Kind regards
> Johann
>  
> ------------
> 
> Oct 11 15:15:43 kernel: INFO: task cp:9636 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: cp              D    0  9636   9616 0x00000000
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_create+0x476/0x560 [xfs]
> Oct 11 15:15:43 kernel:  xfs_generic_create+0x269/0x340 [xfs]
> Oct 11 15:15:43 kernel:  ? d_splice_alias+0x165/0x450
> Oct 11 15:15:43 kernel:  path_openat+0xdea/0x10f0
> Oct 11 15:15:43 kernel:  do_filp_open+0x9c/0x140
> Oct 11 15:15:43 kernel:  do_sys_openat2+0xbb/0x170
> Oct 11 15:15:43 kernel:  __x64_sys_openat+0x54/0x90
> Oct 11 15:15:43 kernel:  do_syscall_64+0x44/0x70
> Oct 11 15:15:43 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Oct 11 15:15:43 kernel: RIP: 0033:0x7f088f47dc1b
> Oct 11 15:15:43 kernel: Code: Bad RIP value.
> Oct 11 15:15:43 kernel: RSP: 002b:00007ffed49d4280 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> Oct 11 15:15:43 kernel: RAX: ffffffffffffffda RBX: 00007ffed49d4860 RCX: 00007f088f47dc1b
> Oct 11 15:15:43 kernel: RDX: 00000000000000c1 RSI: 00005593f03038a0 RDI: 00000000ffffff9c
> Oct 11 15:15:43 kernel: RBP: 00005593f03038a0 R08: 0000000000000001 R09: 0000000000000000
> Oct 11 15:15:43 kernel: R10: 0000000000000180 R11: 0000000000000246 R12: 00000000000000c1
> Oct 11 15:15:43 kernel: R13: 0000000000000000 R14: 00005593f03038a0 R15: 0000000000000003

These all appear to be stuck in the CIL blocking space limit path. That
seems like an odd place to get stuck due to the wakeup being early in a
push, but I suppose if a previous CIL push is in progress and stuck on
log buffer space or a previous commit, that might prevent the CIL push
worker from cycling back for the current ctx.

It's hard to say for sure.. not sure there's enough here to really say
what's going on. I don't see anything push related in the hung task
reports. Is there more to the log that has been snipped out? Do you
have any indication of whether the filesystem was completely locked up
or just the set of tasks associated with the copy? For example, had you
run any operations after the problem manifested that did or didn't hang?
If you happen to reproduce again, a blocked task dump ('echo w >
/proc/sysrq-trigger') or a kdump would probably be a good start..

Brian

> Oct 11 15:15:43 kernel: INFO: task kworker/2:5:9646 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:5     D    0  9646      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:13:9654 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:13    D    0  9654      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:36:9677 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:36    D    0  9677      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:37:9678 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:37    D    0  9678      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:38:9679 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:38    D    0  9679      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:53:9694 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:53    D    0  9694      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:77:9718 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:77    D    0  9718      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:82:9723 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:82    D    0  9723      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> Oct 11 15:15:43 kernel: INFO: task kworker/2:96:9737 blocked for more than 122 seconds.
> Oct 11 15:15:43 kernel:       Tainted: G     U            5.8.14-arch1-1 #1
> Oct 11 15:15:43 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 11 15:15:43 kernel: kworker/2:96    D    0  9737      2 0x00004000
> Oct 11 15:15:43 kernel: Workqueue: xfs-conv/dm-76 xfs_end_io [xfs]
> Oct 11 15:15:43 kernel: Call Trace:
> Oct 11 15:15:43 kernel:  __schedule+0x2a6/0x810
> Oct 11 15:15:43 kernel:  ? __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  schedule+0x46/0xf0
> Oct 11 15:15:43 kernel:  xfs_log_commit_cil+0x6d2/0x870 [xfs]
> Oct 11 15:15:43 kernel:  ? wake_up_q+0xa0/0xa0
> Oct 11 15:15:43 kernel:  __xfs_trans_commit+0xa1/0x350 [xfs]
> Oct 11 15:15:43 kernel:  xfs_iomap_write_unwritten+0xf7/0x330 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_ioend+0xc6/0x110 [xfs]
> Oct 11 15:15:43 kernel:  xfs_end_io+0xbd/0xf0 [xfs]
> Oct 11 15:15:43 kernel:  process_one_work+0x1da/0x3d0
> Oct 11 15:15:43 kernel:  worker_thread+0x4d/0x3d0
> Oct 11 15:15:43 kernel:  ? rescuer_thread+0x410/0x410
> Oct 11 15:15:43 kernel:  kthread+0x142/0x160
> Oct 11 15:15:43 kernel:  ? __kthread_bind_mask+0x60/0x60
> Oct 11 15:15:43 kernel:  ret_from_fork+0x1f/0x30
> 
> ----------
> 

