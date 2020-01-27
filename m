Return-Path: <SRS0=drEG=3Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB9DC32771
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 03:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA6720720
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jan 2020 03:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t6dZGErS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgA0DiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 22:38:09 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36054 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgA0DiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 22:38:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id r19so9127508ljg.3
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 19:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=j3XYm9HinwTieKJswZ7Z0EF9eoO6dCPKGQ4C34ekCH8=;
        b=t6dZGErS8/YfF77zaF/OzVeZ8UrjW5wdaBFfbK6SrGwEJVJr9EwEGuU0pP6nGTCr9h
         ovG7xP0kTWKBxB8r895PKrA/xrzMaazjqCl3z2k34yEt9AhqJWQEEe20lC91JOjSZUp8
         s4uoulyQKmmS9WrNdeMRuVjhZ75KtYGTlle6al9FFSdR5B3PpV9QtUZ4wuyl10DR2ns4
         GiuiWXRbL15U+PbfCWoXIeWQKeGR8K7wwGOE351s+2g3tH9bDkhVLpYPhkdjht8yoPnD
         J4Pl5n15q97ZnGL1lkSsnrlGqNdf/0j/ZbQQtvf29uAWSgf4q1MX6gbw21JxiSMmkI3f
         ELMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=j3XYm9HinwTieKJswZ7Z0EF9eoO6dCPKGQ4C34ekCH8=;
        b=h3rD7C+rvl2ryEgT+7kMC4grDYlEtFsveVB1J2BhqLDlAZvrXpfSf3fqLScmHd3b1C
         6HPfkLDQ6xaqf3Be2KXI4Z79yqGipEhLybixU9WcYZ0Z4GQisWPDtzXYeHjQE6d7DAp3
         9kWAGttzLhAaBVwOqlnT1eisp4AOa7hGEjUN5bXsE6UFOEO6LnZtPfQmqFhbWbsyLPIe
         +wxn6AdvV8rxp3/ayca09QHxoo23o6cADlRWxs817/gFy0NkjVAWB2Vwym90JWgdIBp1
         sCSlwzHKmh55U1Nyy7bgOVezV77kk1Wqp+pzNOMXOCJNmGsp+vlH13bjsoNpcfWPDKhL
         bQEg==
X-Gm-Message-State: APjAAAWpz8+MnwXVo1bpRVDDCEnZAlfEF1oIMEPm5mtuxlOqDmseXjb/
        0mqsG1SC+wt5vWUckdY2gPb+quyNF37ElVNIJPxD9mQx
X-Google-Smtp-Source: APXvYqwe8trxYm1Bl7FgvuREupRhXchLXI2SoGJakIaf2DfO9xVjpq4/pCLOzhmaptn9F4DU1vLl2ap+j58HCTFa2Co=
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr9071553ljk.201.1580096286499;
 Sun, 26 Jan 2020 19:38:06 -0800 (PST)
MIME-Version: 1.0
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Mon, 27 Jan 2020 12:37:55 +0900
Message-ID: <CAMym5wu+ypVDQbyFRrjpqCRKyovpT=nitF4O8VNuspDv5rsd-g@mail.gmail.com>
Subject: Some tasks got to hang_task in XFS
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In Rook(*1)/Ceph community, some users encountered hang_task in XFS.
Although we've not reproduced this problem in the newest kernel, could anyone
give us any hint about this problem, if possible?

*1) An Ceph orchestration in Kubernetes

Here is the detail.

Under some workload in Ceph, many processes got to hang_task. We found
that there
are two kinds of processes.

a) In very high CPU load
b) Encountered hang_task in the XFS

In addition,a user got the following two kernel traces.

A (b) process's backtrace with `hung_task_panic=1`.

```
[51717.039319] INFO: task kworker/2:1:5938 blocked for more than 120 seconds.
[51717.039361]       Not tainted 4.15.0-72-generic #81-Ubuntu
[51717.039388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[51717.039426] kworker/2:1     D    0  5938      2 0x80000000
[51717.039471] Workqueue: xfs-sync/rbd0 xfs_log_worker [xfs]
[51717.039472] Call Trace:
[51717.039478]  __schedule+0x24e/0x880
[51717.039504]  ? xlog_sync+0x2d5/0x3c0 [xfs]
[51717.039506]  schedule+0x2c/0x80
[51717.039530]  _xfs_log_force_lsn+0x20e/0x350 [xfs]
[51717.039533]  ? wake_up_q+0x80/0x80
[51717.039556]  __xfs_trans_commit+0x20b/0x280 [xfs]
[51717.039577]  xfs_trans_commit+0x10/0x20 [xfs]
[51717.039600]  xfs_sync_sb+0x6d/0x80 [xfs]
[51717.039623]  xfs_log_worker+0xe7/0x100 [xfs]
[51717.039626]  process_one_work+0x1de/0x420
[51717.039627]  worker_thread+0x32/0x410
[51717.039628]  kthread+0x121/0x140
[51717.039630]  ? process_one_work+0x420/0x420
[51717.039631]  ? kthread_create_worker_on_cpu+0x70/0x70
[51717.039633]  ret_from_fork+0x35/0x40
```

A (b) process's backtrace that is got by `sudo cat /proc/<PID of a D
process>/stack`

```
[<0>] _xfs_log_force_lsn+0x20e/0x350 [xfs]
[<0>] __xfs_trans_commit+0x20b/0x280 [xfs]
[<0>] xfs_trans_commit+0x10/0x20 [xfs]
[<0>] xfs_sync_sb+0x6d/0x80 [xfs]
[<0>] xfs_log_sbcount+0x4b/0x60 [xfs]
[<0>] xfs_unmountfs+0xe7/0x200 [xfs]
[<0>] xfs_fs_put_super+0x3e/0xb0 [xfs]
[<0>] generic_shutdown_super+0x72/0x120
[<0>] kill_block_super+0x2c/0x80
[<0>] deactivate_locked_super+0x48/0x80
[<0>] deactivate_super+0x40/0x60
[<0>] cleanup_mnt+0x3f/0x80
[<0>] __cleanup_mnt+0x12/0x20
[<0>] task_work_run+0x9d/0xc0
[<0>] exit_to_usermode_loop+0xc0/0xd0
[<0>] do_syscall_64+0x121/0x130
[<0>] entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[<0>] 0xffffffffffffffff
```

Here is the result of my investigation:

- I couldn't find any commit that would be related to this problem,
both in the upstream
  master and master and XFS's for-next
- I couldn't find any discussions that would be related to the
above-mentioned backtrace
  in linux-xfs ML
- There would be a problem in the transaction commit of XFS. In both
of two traces,
  (b) processes hung in _xfs_log_force_lsn+0x20e/0x350 [xfs]. This
code is one of
  the following two xlog_wait().

  https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L3366
  https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log.c#L3387

  These processes released CPU voluntarily in the following line.

  https://github.com/torvalds/linux/blob/master/fs/xfs/xfs_log_priv.h#L549

  These two processes should be woken by the other process after that.
  However, unfortunately, it didn't happen.

Test environment:
- kernel: 4.15.0-<x>-generic
- XFS # Anyone hasn't reported this problem with other filesystems yet.

Related discussions:
- Issue of Rook:
  https://github.com/rook/rook/issues/3132
- Issue of Ceph
  https://tracker.ceph.com/issues/40068

Thanks,
Satoru
