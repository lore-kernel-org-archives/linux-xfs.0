Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:56607 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdJEQYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 12:24:30 -0400
Received: by mail-pf0-f180.google.com with SMTP id g65so8162889pfe.13
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2017 09:24:30 -0700 (PDT)
Subject: Re: Circular locking dependency with pblk
References: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <daf6d403-1199-b5d8-2e35-59f361ed1360@kernel.dk>
Date: Thu, 5 Oct 2017 10:24:27 -0600
MIME-Version: 1.0
In-Reply-To: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <jg@lightnvm.io>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: darrick.wong@oracle.com, Christoph Hellwig <hch@infradead.org>

On 10/05/2017 04:53 AM, Javier González wrote:
> Hi,
> 
> lockdep is reporting a circular dependency when using XFS and pblk,
> which I am a bit confused about.
> 
> This happens when XFS sends a number of nested reads and (at least) one
> of them hits partially pblk's cache. In this case, pblk will retrieve
> the cached lbas and form a new bio, which is submitted _synchronously_
> to the media using struct completion. The original bio is then populated
> with the read data.
> 
> What lockdep complains about, is that the unlocking operation in
> complete() has a circular dependency with ionode->i_rwsem when they both
> happen on the same core, which is different from the core that issued
> wait_for_completion_io_timeout() and is waiting for the partial read.
> However, AFAIU complete() happens in interrupt context, so this should
> not be a problem.

But the very trace you are posting shows the completion being down
inline, since we catch it at submission time:

> [ 8558.256328]  complete+0x29/0x60
> [ 8558.259469]  pblk_end_io_sync+0x12/0x20
> [ 8558.263297]  nvm_end_io+0x2b/0x30
> [ 8558.266607]  nvme_nvm_end_io+0x2e/0x50
> [ 8558.270351]  blk_mq_end_request+0x3e/0x70
> [ 8558.274360]  nvme_complete_rq+0x1c/0xd0
> [ 8558.278194]  nvme_pci_complete_rq+0x7b/0x130
> [ 8558.282459]  __blk_mq_complete_request+0xa3/0x160
> [ 8558.287156]  blk_mq_complete_request+0x16/0x20
> [ 8558.291592]  nvme_process_cq+0xf8/0x1e0
> [ 8558.295424]  nvme_queue_rq+0x16e/0x9a0
> [ 8558.299172]  blk_mq_dispatch_rq_list+0x19e/0x330
> [ 8558.303787]  ? blk_mq_flush_busy_ctxs+0x91/0x130
> [ 8558.308400]  blk_mq_sched_dispatch_requests+0x19d/0x1d0
> [ 8558.313617]  __blk_mq_run_hw_queue+0x12e/0x1d0
> [ 8558.318053]  __blk_mq_delay_run_hw_queue+0xb9/0xd0
> [ 8558.322837]  blk_mq_run_hw_queue+0x14/0x20
> [ 8558.326928]  blk_mq_sched_insert_request+0xa4/0x180
> [ 8558.331797]  blk_execute_rq_nowait+0x72/0xf0
> [ 8558.336061]  nvme_nvm_submit_io+0xd9/0x130
> [ 8558.340151]  nvm_submit_io+0x3c/0x70
> [ 8558.343723]  pblk_submit_io+0x1b/0x20> [ 8558.347379]  pblk_submit_read+0x1ec/0x3a0

[snip]

This happens since we call nvme_process_cq() after submitting IO,
just in case there's something we can complete.

-- 
Jens Axboe

