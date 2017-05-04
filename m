Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36027 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdEDLNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2017 07:13:41 -0400
Received: by mail-vk0-f49.google.com with SMTP id q78so5164440vke.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 May 2017 04:13:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap> <20170502073501.GB6679@infradead.org>
 <DDDCF9D44B6A4D1493F62FCA5AC73CF6@alyakaslap>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Thu, 4 May 2017 14:13:40 +0300
Message-ID: <CAOcd+r0zJQ=5PtJ4KofEbxiZPbS3xo8x_14tCtvdxcp6mhN8yQ@mail.gmail.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hello,

> # it is still not clear who is holding the lock
Further analysis shows that the xfs_buf lock is being held, because
the buffer is currently being read from disk. The stack that unlocks
the buffer is [1]. The size of each buffer being read is 4Kb.

So bottom line is that sometimes XFS needs to search through thousands
of metadata blocks of 4Kb, and needs to wait while they are being read
from disk. This causes very slow allocation in some cases, further
causing other threads to wait on i_lock/i_mutex, in some cases
triggering hung-task panics.

Anything can be done to remedy this?

Thanks,
Alex.



[1]
Call Trace:
 [<ffffffff81710c85>] dump_stack+0x4e/0x71
 [<ffffffffc0fade1b>] xfs_buf_ioend+0x22b/0x230 [xfs]
 [<ffffffffc0fade35>] xfs_buf_ioend_work+0x15/0x20 [xfs]
 [<ffffffff8108bd56>] process_one_work+0x146/0x410
 [<ffffffff8108c141>] worker_thread+0x121/0x450
 [<ffffffff8108c020>] ? process_one_work+0x410/0x410
 [<ffffffff810911b9>] kthread+0xc9/0xe0
 [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
 [<ffffffff81717918>] ret_from_fork+0x58/0x90
 [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
