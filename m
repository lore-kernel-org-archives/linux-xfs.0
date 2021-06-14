Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD77C2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 12:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC325613F1
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 12:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhFNM6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 08:58:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232894AbhFNM6K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 08:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623675367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1FqrlbD2ZwZQR+e/Ha5nl6NPTWMkBx1GxgdUCErsxpM=;
        b=aMftySduvLBgvi4xZ3j0/mf77apktaHA8Z7ogG+v8Dz6zWs2zrIsU0xNYU68tfeWCP1H8J
        0ndkK3NYGrDl4T7kEaGP7lTD8iq6XhRZx5EHyA/IXOhn4fAT6miLV2Zia1mmOWA/TqLUB+
        6DvWYwx9VtYlRU3g2gZR/HFqjRxqUjA=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-Co1UcqdROR6Bd2qXD0h3-g-1; Mon, 14 Jun 2021 08:56:04 -0400
X-MC-Unique: Co1UcqdROR6Bd2qXD0h3-g-1
Received: by mail-ot1-f71.google.com with SMTP id l13-20020a9d734d0000b02903db3d2b53faso7201897otk.6
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 05:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1FqrlbD2ZwZQR+e/Ha5nl6NPTWMkBx1GxgdUCErsxpM=;
        b=X8f8ZnLXm5G4G2gd9MVzMDLMuqxAo48pAHnylY0m0ZusQozBE9xWRaKDwqZZHkFhBH
         9GqXaF5O7IgxnVINQqpw/hIbbXnbbN5L0giJbCiLvmTM6bHbx3apy+tTopHepdLqOl/o
         F4lsGTM7pTIg8L8EcGLpnM55EwSsdxQ26seF9Gch5LP/6SSpDb2XhQ6MkzWL+UQtCN1c
         Q5Mli0zLv8+X+ef1vPfcQ9tBhN9mF+AblPtw7wZFFoz7flKKYslBZwI+La8khD3bM7iy
         PVRjeoWLfd/oe2N6XSWjl7qmUGTtMi+18g+SfiExd5lSHzqEzYudHDnnfOSpef/IHcH8
         92wg==
X-Gm-Message-State: AOAM532YyDwYw2FW/B2ZJd7SLOiMm/O+qrYNt7ZhN73JZf+eGtxj9AtW
        PSOgghI7A1b0HHzUyZtfxTgZ7GVWYWyW14x6TV9rdthhpnfrVLwzCLgHtkf0OFme9nOPAgHw1Zv
        UJGE6VZjLYo0/3HkcPM7/
X-Received: by 2002:a05:6808:1511:: with SMTP id u17mr13192350oiw.53.1623675363332;
        Mon, 14 Jun 2021 05:56:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrrW8sRN80xtYDkUlYmLzJDTF6xeqmn+jxGdj2UWuTwBmYuKEM6K3HYQFdBHk+hAs4T9IXBw==
X-Received: by 2002:a05:6808:1511:: with SMTP id u17mr13192347oiw.53.1623675363205;
        Mon, 14 Jun 2021 05:56:03 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id v82sm2937590oia.27.2021.06.14.05.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:56:02 -0700 (PDT)
Date:   Mon, 14 Jun 2021 08:56:00 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <YMdR4E+0cERrmTZi@bfoster>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
 <20210611223332.GS664593@dread.disaster.area>
 <YMdMehWQoBJC9l0W@bfoster>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wKueIIN5GUuwFT+3"
Content-Disposition: inline
In-Reply-To: <YMdMehWQoBJC9l0W@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--wKueIIN5GUuwFT+3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 14, 2021 at 08:32:58AM -0400, Brian Foster wrote:
> On Sat, Jun 12, 2021 at 08:33:32AM +1000, Dave Chinner wrote:
> > On Fri, Jun 11, 2021 at 03:02:39PM -0400, Brian Foster wrote:
> > > On Thu, Jun 10, 2021 at 11:14:32AM -0400, Brian Foster wrote:
...
> 
> I've also now been hitting a deadlock issue more frequently with the
> same test. I'll provide more on that in a separate mail..
> 

So I originally thought this one was shutdown related (there still may
be a shutdown hang, I was quickly working around other issues to give
priority to the corruption issue), but what I'm seeing actually looks
like a log reservation deadlock. More specifically, it looks like a
stuck CIL push and everything else backed up behind it.

I suspect this is related to the same patch (it does show 4 concurrent
CIL push tasks, fwiw), but I'm not 100% certain atm. I'll repeat some
tests on the prior commit to try and confirm or rule that out. In the
meantime, dmesg with blocked task output is attached.

Brian

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 



--wKueIIN5GUuwFT+3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="019-deadlock.dmesg"

[49989.354537] sysrq: Show Blocked State
[49989.362009] task:kworker/u161:4  state:D stack:    0 pid:105326 ppid:     2 flags:0x00004000
[49989.370464] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[49989.376278] Call Trace:
[49989.378744]  __schedule+0x38b/0xc50
[49989.382250]  ? lock_release+0x1cd/0x2a0
[49989.386097]  schedule+0x5b/0xc0
[49989.389251]  xlog_wait_on_iclog+0xeb/0x100 [xfs]
[49989.393932]  ? wake_up_q+0xa0/0xa0
[49989.397353]  xlog_cil_push_work+0x5cb/0x630 [xfs]
[49989.402123]  ? sched_clock_cpu+0xc/0xb0
[49989.405971]  ? lock_acquire+0x15d/0x380
[49989.409823]  ? lock_release+0x1cd/0x2a0
[49989.413662]  ? lock_acquire+0x15d/0x380
[49989.417502]  ? lock_release+0x1cd/0x2a0
[49989.421353]  ? finish_task_switch.isra.0+0xa0/0x2c0
[49989.426238]  process_one_work+0x26e/0x560
[49989.430271]  worker_thread+0x52/0x3b0
[49989.433942]  ? process_one_work+0x560/0x560
[49989.438138]  kthread+0x12c/0x150
[49989.441380]  ? __kthread_bind_mask+0x60/0x60
[49989.445658]  ret_from_fork+0x22/0x30
[49989.449302] task:kworker/3:0     state:D stack:    0 pid:173625 ppid:     2 flags:0x00004000
[49989.457739] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.462975] Call Trace:
[49989.465428]  __schedule+0x38b/0xc50
[49989.468930]  schedule+0x5b/0xc0
[49989.472082]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.476951]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.481892]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.486315]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.490991]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49989.495517]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49989.500456]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49989.505829]  ? lock_release+0x1cd/0x2a0
[49989.509668]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49989.514600]  iomap_dio_complete+0x45/0x130
[49989.518707]  ? aio_poll_complete_work+0x1b0/0x1b0
[49989.523422]  iomap_dio_complete_work+0x17/0x30
[49989.527876]  process_one_work+0x26e/0x560
[49989.531890]  worker_thread+0x52/0x3b0
[49989.535570]  ? process_one_work+0x560/0x560
[49989.539757]  kthread+0x12c/0x150
[49989.542989]  ? __kthread_bind_mask+0x60/0x60
[49989.547264]  ret_from_fork+0x22/0x30
[49989.550861] task:kworker/3:7     state:D stack:    0 pid:173759 ppid:     2 flags:0x00004000
[49989.559301] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.564536] Call Trace:
[49989.566987]  __schedule+0x38b/0xc50
[49989.570479]  schedule+0x5b/0xc0
[49989.573626]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.578479]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.583419]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.587837]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.592518]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49989.597024]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49989.601966]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49989.607337]  ? lock_release+0x1cd/0x2a0
[49989.611177]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49989.616112]  iomap_dio_complete+0x45/0x130
[49989.620214]  ? aio_poll_complete_work+0x1b0/0x1b0
[49989.624921]  iomap_dio_complete_work+0x17/0x30
[49989.629368]  process_one_work+0x26e/0x560
[49989.633382]  worker_thread+0x52/0x3b0
[49989.637055]  ? process_one_work+0x560/0x560
[49989.641240]  kthread+0x12c/0x150
[49989.644474]  ? __kthread_bind_mask+0x60/0x60
[49989.648754]  ret_from_fork+0x22/0x30
[49989.652338] task:kworker/3:8     state:D stack:    0 pid:173760 ppid:     2 flags:0x00004000
[49989.660775] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.666008] Call Trace:
[49989.668463]  __schedule+0x38b/0xc50
[49989.671963]  schedule+0x5b/0xc0
[49989.675107]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.679964]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.684919]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.689338]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.694018]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49989.698526]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49989.703464]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49989.708830]  ? lock_release+0x1cd/0x2a0
[49989.712679]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49989.717610]  iomap_dio_complete+0x45/0x130
[49989.721716]  ? aio_poll_complete_work+0x1b0/0x1b0
[49989.726431]  iomap_dio_complete_work+0x17/0x30
[49989.730885]  process_one_work+0x26e/0x560
[49989.734898]  worker_thread+0x52/0x3b0
[49989.738564]  ? process_one_work+0x560/0x560
[49989.742749]  kthread+0x12c/0x150
[49989.745983]  ? __kthread_bind_mask+0x60/0x60
[49989.750264]  ret_from_fork+0x22/0x30
[49989.753858] task:kworker/5:32    state:D stack:    0 pid:173784 ppid:     2 flags:0x00004000
[49989.762293] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.767527] Call Trace:
[49989.769981]  __schedule+0x38b/0xc50
[49989.773481]  schedule+0x5b/0xc0
[49989.776634]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.781488]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.786428]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.790848]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.795528]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49989.800036]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49989.804973]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49989.810340]  ? lock_release+0x1cd/0x2a0
[49989.814194]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49989.819127]  iomap_dio_complete+0x45/0x130
[49989.823235]  ? aio_poll_complete_work+0x1b0/0x1b0
[49989.827948]  iomap_dio_complete_work+0x17/0x30
[49989.832395]  process_one_work+0x26e/0x560
[49989.836415]  worker_thread+0x52/0x3b0
[49989.840082]  ? process_one_work+0x560/0x560
[49989.844268]  kthread+0x12c/0x150
[49989.847506]  ? __kthread_bind_mask+0x60/0x60
[49989.851780]  ret_from_fork+0x22/0x30
[49989.855365] task:kworker/3:9     state:D stack:    0 pid:173819 ppid:     2 flags:0x00004000
[49989.863801] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.869027] Call Trace:
[49989.871480]  __schedule+0x38b/0xc50
[49989.874981]  schedule+0x5b/0xc0
[49989.878134]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.882988]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.887930]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.892365]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.897045]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49989.901550]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49989.906491]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49989.911857]  ? lock_release+0x1cd/0x2a0
[49989.915705]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49989.920636]  iomap_dio_complete+0x45/0x130
[49989.924742]  ? aio_poll_complete_work+0x1b0/0x1b0
[49989.929448]  iomap_dio_complete_work+0x17/0x30
[49989.933894]  process_one_work+0x26e/0x560
[49989.937907]  worker_thread+0x52/0x3b0
[49989.941573]  ? process_one_work+0x560/0x560
[49989.945759]  kthread+0x12c/0x150
[49989.948999]  ? __kthread_bind_mask+0x60/0x60
[49989.953280]  ret_from_fork+0x22/0x30
[49989.956866] task:kworker/3:22    state:D stack:    0 pid:173876 ppid:     2 flags:0x00004000
[49989.965300] Workqueue: dio/dm-5 iomap_dio_complete_work
[49989.970528] Call Trace:
[49989.972980]  __schedule+0x38b/0xc50
[49989.976472]  schedule+0x5b/0xc0
[49989.979618]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49989.984470]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49989.989410]  xfs_log_reserve+0xf6/0x310 [xfs]
[49989.993831]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49989.998511]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.003019]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.007958]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.013330]  ? lock_release+0x1cd/0x2a0
[49990.017169]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.022102]  iomap_dio_complete+0x45/0x130
[49990.026208]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.030921]  iomap_dio_complete_work+0x17/0x30
[49990.035369]  process_one_work+0x26e/0x560
[49990.039390]  worker_thread+0x52/0x3b0
[49990.043056]  ? process_one_work+0x560/0x560
[49990.047242]  kthread+0x12c/0x150
[49990.050482]  ? __kthread_bind_mask+0x60/0x60
[49990.054756]  ret_from_fork+0x22/0x30
[49990.058381] task:kworker/5:60    state:D stack:    0 pid:173994 ppid:     2 flags:0x00004000
[49990.066820] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.072053] Call Trace:
[49990.074505]  __schedule+0x38b/0xc50
[49990.077999]  schedule+0x5b/0xc0
[49990.081145]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.085998]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.090938]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.095359]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.100037]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.104552]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.109491]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.114857]  ? lock_release+0x1cd/0x2a0
[49990.118703]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.123644]  iomap_dio_complete+0x45/0x130
[49990.127742]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.132452]  iomap_dio_complete_work+0x17/0x30
[49990.136902]  process_one_work+0x26e/0x560
[49990.140916]  worker_thread+0x52/0x3b0
[49990.144581]  ? process_one_work+0x560/0x560
[49990.148768]  kthread+0x12c/0x150
[49990.152009]  ? __kthread_bind_mask+0x60/0x60
[49990.156290]  ret_from_fork+0x22/0x30
[49990.159876] task:kworker/5:64    state:D stack:    0 pid:173998 ppid:     2 flags:0x00004000
[49990.168310] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.173536] Call Trace:
[49990.175990]  __schedule+0x38b/0xc50
[49990.179489]  schedule+0x5b/0xc0
[49990.182635]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.187488]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.192431]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.196850]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.201529]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.206055]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.210991]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.216373]  ? lock_release+0x1cd/0x2a0
[49990.220214]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.225145]  iomap_dio_complete+0x45/0x130
[49990.229252]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.233967]  iomap_dio_complete_work+0x17/0x30
[49990.238412]  process_one_work+0x26e/0x560
[49990.242424]  worker_thread+0x52/0x3b0
[49990.246090]  ? process_one_work+0x560/0x560
[49990.250276]  kthread+0x12c/0x150
[49990.253510]  ? __kthread_bind_mask+0x60/0x60
[49990.257790]  ret_from_fork+0x22/0x30
[49990.261375] task:kworker/7:40    state:D stack:    0 pid:174047 ppid:     2 flags:0x00004000
[49990.269821] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.275053] Call Trace:
[49990.277507]  __schedule+0x38b/0xc50
[49990.281008]  schedule+0x5b/0xc0
[49990.284154]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.289005]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.293946]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.298367]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.303045]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.307551]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.312493]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.317865]  ? lock_release+0x1cd/0x2a0
[49990.321705]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.326639]  iomap_dio_complete+0x45/0x130
[49990.330744]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.335458]  iomap_dio_complete_work+0x17/0x30
[49990.339903]  process_one_work+0x26e/0x560
[49990.343916]  worker_thread+0x52/0x3b0
[49990.347582]  ? process_one_work+0x560/0x560
[49990.351769]  kthread+0x12c/0x150
[49990.355010]  ? __kthread_bind_mask+0x60/0x60
[49990.359292]  ret_from_fork+0x22/0x30
[49990.362884] task:kworker/3:46    state:D stack:    0 pid:174164 ppid:     2 flags:0x00004000
[49990.371320] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.376555] Call Trace:
[49990.379007]  __schedule+0x38b/0xc50
[49990.382500]  schedule+0x5b/0xc0
[49990.385645]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.390499]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.395439]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.399857]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.404539]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.409046]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.413982]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.419349]  ? lock_release+0x1cd/0x2a0
[49990.423189]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.428118]  iomap_dio_complete+0x45/0x130
[49990.432217]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.436925]  iomap_dio_complete_work+0x17/0x30
[49990.441377]  process_one_work+0x26e/0x560
[49990.445391]  worker_thread+0x52/0x3b0
[49990.449057]  ? process_one_work+0x560/0x560
[49990.453244]  kthread+0x12c/0x150
[49990.456482]  ? __kthread_bind_mask+0x60/0x60
[49990.460756]  ret_from_fork+0x22/0x30
[49990.464340] task:kworker/3:48    state:D stack:    0 pid:174166 ppid:     2 flags:0x00004000
[49990.472777] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.478010] Call Trace:
[49990.480465]  __schedule+0x38b/0xc50
[49990.483965]  schedule+0x5b/0xc0
[49990.487111]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.491963]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.496903]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.501342]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.506021]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.510527]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.515473]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.520840]  ? lock_release+0x1cd/0x2a0
[49990.524680]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.529610]  iomap_dio_complete+0x45/0x130
[49990.533708]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.538415]  iomap_dio_complete_work+0x17/0x30
[49990.542859]  process_one_work+0x26e/0x560
[49990.546876]  worker_thread+0x52/0x3b0
[49990.550550]  ? process_one_work+0x560/0x560
[49990.554742]  kthread+0x12c/0x150
[49990.557975]  ? __kthread_bind_mask+0x60/0x60
[49990.562256]  ret_from_fork+0x22/0x30
[49990.565844] task:kworker/3:65    state:D stack:    0 pid:174182 ppid:     2 flags:0x00004000
[49990.574275] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.579503] Call Trace:
[49990.581954]  __schedule+0x38b/0xc50
[49990.585448]  schedule+0x5b/0xc0
[49990.588593]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.593446]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.598386]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.602807]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.607486]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.611993]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.616933]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.622298]  ? lock_release+0x1cd/0x2a0
[49990.626155]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.631085]  iomap_dio_complete+0x45/0x130
[49990.635193]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.639907]  iomap_dio_complete_work+0x17/0x30
[49990.644360]  process_one_work+0x26e/0x560
[49990.648376]  worker_thread+0x52/0x3b0
[49990.652049]  ? process_one_work+0x560/0x560
[49990.656244]  kthread+0x12c/0x150
[49990.659483]  ? __kthread_bind_mask+0x60/0x60
[49990.663757]  ret_from_fork+0x22/0x30
[49990.667361] task:kworker/13:48   state:D stack:    0 pid:174572 ppid:     2 flags:0x00004000
[49990.675793] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.681021] Call Trace:
[49990.683473]  __schedule+0x38b/0xc50
[49990.686974]  schedule+0x5b/0xc0
[49990.690121]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.694982]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.699923]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.704359]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.709056]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.713563]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.718519]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.723883]  ? lock_release+0x1cd/0x2a0
[49990.727722]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.732654]  iomap_dio_complete+0x45/0x130
[49990.736753]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.741477]  iomap_dio_complete_work+0x17/0x30
[49990.745923]  process_one_work+0x26e/0x560
[49990.749935]  worker_thread+0x52/0x3b0
[49990.753602]  ? process_one_work+0x560/0x560
[49990.757797]  kthread+0x12c/0x150
[49990.761055]  ? __kthread_bind_mask+0x60/0x60
[49990.765336]  ret_from_fork+0x22/0x30
[49990.768933] task:kworker/13:80   state:D stack:    0 pid:174603 ppid:     2 flags:0x00004000
[49990.777375] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.782606] Call Trace:
[49990.785059]  __schedule+0x38b/0xc50
[49990.788559]  schedule+0x5b/0xc0
[49990.791706]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.796561]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.801501]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.805919]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.810617]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.815123]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.820073]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.825445]  ? lock_release+0x1cd/0x2a0
[49990.829283]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.834216]  iomap_dio_complete+0x45/0x130
[49990.838314]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.843022]  iomap_dio_complete_work+0x17/0x30
[49990.847475]  process_one_work+0x26e/0x560
[49990.851487]  worker_thread+0x52/0x3b0
[49990.855153]  ? process_one_work+0x560/0x560
[49990.859339]  kthread+0x12c/0x150
[49990.862588]  ? __kthread_bind_mask+0x60/0x60
[49990.866860]  ret_from_fork+0x22/0x30
[49990.870455] task:kworker/13:106  state:D stack:    0 pid:174629 ppid:     2 flags:0x00004000
[49990.878889] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.884114] Call Trace:
[49990.886569]  __schedule+0x38b/0xc50
[49990.890080]  schedule+0x5b/0xc0
[49990.893233]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.898120]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49990.903060]  xfs_log_reserve+0xf6/0x310 [xfs]
[49990.907490]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49990.912178]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49990.916694]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49990.921634]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49990.927013]  ? lock_release+0x1cd/0x2a0
[49990.930855]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49990.935793]  iomap_dio_complete+0x45/0x130
[49990.939891]  ? aio_poll_complete_work+0x1b0/0x1b0
[49990.944599]  iomap_dio_complete_work+0x17/0x30
[49990.949061]  process_one_work+0x26e/0x560
[49990.953083]  worker_thread+0x52/0x3b0
[49990.956756]  ? process_one_work+0x560/0x560
[49990.960942]  kthread+0x12c/0x150
[49990.964178]  ? __kthread_bind_mask+0x60/0x60
[49990.968474]  ret_from_fork+0x22/0x30
[49990.972063] task:kworker/0:5     state:D stack:    0 pid:174694 ppid:     2 flags:0x00004000
[49990.980494] Workqueue: dio/dm-5 iomap_dio_complete_work
[49990.985721] Call Trace:
[49990.988181]  __schedule+0x38b/0xc50
[49990.991674]  schedule+0x5b/0xc0
[49990.994820]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49990.999692]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.004639]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.009061]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.013773]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.018304]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.023247]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.028620]  ? lock_release+0x1cd/0x2a0
[49991.032470]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.037409]  iomap_dio_complete+0x45/0x130
[49991.041514]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.046236]  iomap_dio_complete_work+0x17/0x30
[49991.050683]  process_one_work+0x26e/0x560
[49991.054697]  worker_thread+0x52/0x3b0
[49991.058370]  ? process_one_work+0x560/0x560
[49991.062557]  kthread+0x12c/0x150
[49991.065798]  ? __kthread_bind_mask+0x60/0x60
[49991.070079]  ret_from_fork+0x22/0x30
[49991.073672] task:kworker/0:8     state:D stack:    0 pid:174697 ppid:     2 flags:0x00004000
[49991.082108] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.087341] Call Trace:
[49991.089796]  __schedule+0x38b/0xc50
[49991.093298]  schedule+0x5b/0xc0
[49991.096451]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.101321]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.106260]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.110689]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.115387]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.119912]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.124861]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.130248]  ? lock_release+0x1cd/0x2a0
[49991.134088]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.139021]  iomap_dio_complete+0x45/0x130
[49991.143127]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.147842]  iomap_dio_complete_work+0x17/0x30
[49991.152298]  process_one_work+0x26e/0x560
[49991.156327]  worker_thread+0x52/0x3b0
[49991.159991]  ? process_one_work+0x560/0x560
[49991.164179]  kthread+0x12c/0x150
[49991.167420]  ? __kthread_bind_mask+0x60/0x60
[49991.171700]  ret_from_fork+0x22/0x30
[49991.175286] task:kworker/0:12    state:D stack:    0 pid:174701 ppid:     2 flags:0x00004000
[49991.183720] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.188954] Call Trace:
[49991.191407]  __schedule+0x38b/0xc50
[49991.194909]  schedule+0x5b/0xc0
[49991.198054]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.202917]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.207865]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.212292]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.216973]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.221481]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.226420]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.231793]  ? lock_release+0x1cd/0x2a0
[49991.235633]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.240564]  iomap_dio_complete+0x45/0x130
[49991.244687]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.249395]  iomap_dio_complete_work+0x17/0x30
[49991.253850]  process_one_work+0x26e/0x560
[49991.257871]  worker_thread+0x52/0x3b0
[49991.261543]  ? process_one_work+0x560/0x560
[49991.265731]  kthread+0x12c/0x150
[49991.268972]  ? __kthread_bind_mask+0x60/0x60
[49991.273254]  ret_from_fork+0x22/0x30
[49991.276845] task:kworker/0:30    state:D stack:    0 pid:174719 ppid:     2 flags:0x00004000
[49991.285283] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.290515] Call Trace:
[49991.292969]  __schedule+0x38b/0xc50
[49991.296490]  schedule+0x5b/0xc0
[49991.299641]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.304495]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.309453]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.313890]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.318569]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.323083]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.328043]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.333422]  ? lock_release+0x1cd/0x2a0
[49991.337264]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.342194]  iomap_dio_complete+0x45/0x130
[49991.346293]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.351024]  iomap_dio_complete_work+0x17/0x30
[49991.355470]  process_one_work+0x26e/0x560
[49991.359485]  worker_thread+0x52/0x3b0
[49991.363157]  ? process_one_work+0x560/0x560
[49991.367344]  kthread+0x12c/0x150
[49991.370584]  ? __kthread_bind_mask+0x60/0x60
[49991.374856]  ret_from_fork+0x22/0x30
[49991.378452] task:kworker/13:157  state:D stack:    0 pid:174868 ppid:     2 flags:0x00004000
[49991.386885] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.392128] Call Trace:
[49991.394591]  __schedule+0x38b/0xc50
[49991.398091]  schedule+0x5b/0xc0
[49991.401238]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.406090]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.411047]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.415469]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.420147]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.424655]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.429593]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.434957]  ? lock_release+0x1cd/0x2a0
[49991.438799]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.443729]  iomap_dio_complete+0x45/0x130
[49991.447836]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.452552]  iomap_dio_complete_work+0x17/0x30
[49991.457013]  process_one_work+0x26e/0x560
[49991.461026]  worker_thread+0x52/0x3b0
[49991.464693]  ? process_one_work+0x560/0x560
[49991.468886]  kthread+0x12c/0x150
[49991.472127]  ? __kthread_bind_mask+0x60/0x60
[49991.476399]  ret_from_fork+0x22/0x30
[49991.479984] task:kworker/13:159  state:D stack:    0 pid:174874 ppid:     2 flags:0x00004000
[49991.488438] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.493673] Call Trace:
[49991.496125]  __schedule+0x38b/0xc50
[49991.499619]  schedule+0x5b/0xc0
[49991.502772]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.507635]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.512590]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.517030]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.521706]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.526225]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.531163]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.536535]  ? lock_release+0x1cd/0x2a0
[49991.540375]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.545306]  iomap_dio_complete+0x45/0x130
[49991.549405]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.554122]  iomap_dio_complete_work+0x17/0x30
[49991.558574]  process_one_work+0x26e/0x560
[49991.562596]  worker_thread+0x52/0x3b0
[49991.566262]  ? process_one_work+0x560/0x560
[49991.570449]  kthread+0x12c/0x150
[49991.573689]  ? __kthread_bind_mask+0x60/0x60
[49991.577970]  ret_from_fork+0x22/0x30
[49991.581566] task:kworker/17:10   state:D stack:    0 pid:175048 ppid:     2 flags:0x00004000
[49991.589999] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.595226] Call Trace:
[49991.597677]  __schedule+0x38b/0xc50
[49991.601182]  schedule+0x5b/0xc0
[49991.604333]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.609203]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.614153]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.618582]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.623261]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.627785]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.632733]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.638107]  ? lock_release+0x1cd/0x2a0
[49991.641955]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.646903]  iomap_dio_complete+0x45/0x130
[49991.651002]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.655716]  iomap_dio_complete_work+0x17/0x30
[49991.660162]  process_one_work+0x26e/0x560
[49991.664176]  worker_thread+0x52/0x3b0
[49991.667849]  ? process_one_work+0x560/0x560
[49991.672042]  kthread+0x12c/0x150
[49991.675275]  ? __kthread_bind_mask+0x60/0x60
[49991.679557]  ret_from_fork+0x22/0x30
[49991.683151] task:kworker/17:27   state:D stack:    0 pid:175065 ppid:     2 flags:0x00004000
[49991.691585] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.696812] Call Trace:
[49991.699266]  __schedule+0x38b/0xc50
[49991.702766]  schedule+0x5b/0xc0
[49991.705920]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.710783]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.715722]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.720161]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.724857]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.729365]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.734320]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.739709]  ? lock_release+0x1cd/0x2a0
[49991.743550]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.748489]  iomap_dio_complete+0x45/0x130
[49991.752587]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.757294]  iomap_dio_complete_work+0x17/0x30
[49991.761750]  process_one_work+0x26e/0x560
[49991.765770]  worker_thread+0x52/0x3b0
[49991.769434]  ? process_one_work+0x560/0x560
[49991.773631]  kthread+0x12c/0x150
[49991.776871]  ? __kthread_bind_mask+0x60/0x60
[49991.781162]  ret_from_fork+0x22/0x30
[49991.784755] task:kworker/17:42   state:D stack:    0 pid:175080 ppid:     2 flags:0x00004000
[49991.793200] Workqueue: dio/dm-5 iomap_dio_complete_work
[49991.798434] Call Trace:
[49991.800896]  __schedule+0x38b/0xc50
[49991.804397]  schedule+0x5b/0xc0
[49991.807551]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49991.812405]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49991.817344]  xfs_log_reserve+0xf6/0x310 [xfs]
[49991.821770]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49991.826451]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49991.830957]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49991.835899]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49991.841272]  ? lock_release+0x1cd/0x2a0
[49991.845119]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49991.850051]  iomap_dio_complete+0x45/0x130
[49991.854157]  ? aio_poll_complete_work+0x1b0/0x1b0
[49991.858863]  iomap_dio_complete_work+0x17/0x30
[49991.863310]  process_one_work+0x26e/0x560
[49991.867331]  worker_thread+0x52/0x3b0
[49991.870997]  ? process_one_work+0x560/0x560
[49991.875202]  kthread+0x12c/0x150
[49991.878448]  ? __kthread_bind_mask+0x60/0x60
[49991.882723]  ret_from_fork+0x22/0x30
[49991.886325] task:kworker/u161:1  state:D stack:    0 pid:176616 ppid:     2 flags:0x00004000
[49991.894760] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[49991.900487] Call Trace:
[49991.902940]  __schedule+0x38b/0xc50
[49991.906432]  ? lock_release+0x1cd/0x2a0
[49991.910272]  schedule+0x5b/0xc0
[49991.913419]  xlog_state_get_iclog_space+0x167/0x340 [xfs]
[49991.918879]  ? wake_up_q+0xa0/0xa0
[49991.922293]  xlog_write+0x159/0xa10 [xfs]
[49991.926385]  xlog_cil_push_work+0x2dd/0x630 [xfs]
[49991.931151]  ? update_irq_load_avg+0x1df/0x480
[49991.935603]  ? sched_clock_cpu+0xc/0xb0
[49991.939444]  ? lock_acquire+0x15d/0x380
[49991.943285]  ? lock_acquire+0x15d/0x380
[49991.947130]  ? lock_release+0x1cd/0x2a0
[49991.950970]  ? lock_acquire+0x15d/0x380
[49991.954816]  ? lock_release+0x1cd/0x2a0
[49991.958674]  ? finish_task_switch.isra.0+0xa0/0x2c0
[49991.963563]  process_one_work+0x26e/0x560
[49991.967583]  worker_thread+0x52/0x3b0
[49991.971249]  ? process_one_work+0x560/0x560
[49991.975435]  kthread+0x12c/0x150
[49991.978668]  ? __kthread_bind_mask+0x60/0x60
[49991.982967]  ret_from_fork+0x22/0x30
[49991.986569] task:kworker/3:120   state:D stack:    0 pid:177583 ppid:     2 flags:0x00004000
[49991.995004] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.000239] Call Trace:
[49992.002692]  __schedule+0x38b/0xc50
[49992.006191]  schedule+0x5b/0xc0
[49992.009353]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.014217]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.019158]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.023595]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.028274]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.032806]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.037755]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.043129]  ? lock_release+0x1cd/0x2a0
[49992.046976]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.051914]  iomap_dio_complete+0x45/0x130
[49992.056015]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.060730]  iomap_dio_complete_work+0x17/0x30
[49992.065183]  process_one_work+0x26e/0x560
[49992.069197]  worker_thread+0x52/0x3b0
[49992.072862]  ? process_one_work+0x560/0x560
[49992.077056]  kthread+0x12c/0x150
[49992.080288]  ? __kthread_bind_mask+0x60/0x60
[49992.084596]  ret_from_fork+0x22/0x30
[49992.088189] task:kworker/3:127   state:D stack:    0 pid:177590 ppid:     2 flags:0x00004000
[49992.096634] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.101859] Call Trace:
[49992.104314]  __schedule+0x38b/0xc50
[49992.107814]  schedule+0x5b/0xc0
[49992.110976]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.115827]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.120770]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.125191]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.129889]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.134404]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.139343]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.144723]  ? lock_release+0x1cd/0x2a0
[49992.148572]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.153510]  iomap_dio_complete+0x45/0x130
[49992.157609]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.162315]  iomap_dio_complete_work+0x17/0x30
[49992.166763]  process_one_work+0x26e/0x560
[49992.170783]  worker_thread+0x52/0x3b0
[49992.174448]  ? process_one_work+0x560/0x560
[49992.178634]  kthread+0x12c/0x150
[49992.181867]  ? __kthread_bind_mask+0x60/0x60
[49992.186156]  ret_from_fork+0x22/0x30
[49992.189741] task:kworker/17:68   state:D stack:    0 pid:177770 ppid:     2 flags:0x00004000
[49992.198197] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.203428] Call Trace:
[49992.205883]  __schedule+0x38b/0xc50
[49992.209383]  schedule+0x5b/0xc0
[49992.212537]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.217392]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.222349]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.226785]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.231466]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.235970]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.240911]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.246284]  ? lock_release+0x1cd/0x2a0
[49992.250122]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.255055]  iomap_dio_complete+0x45/0x130
[49992.259155]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.263877]  iomap_dio_complete_work+0x17/0x30
[49992.268333]  process_one_work+0x26e/0x560
[49992.272353]  worker_thread+0x52/0x3b0
[49992.276025]  ? process_one_work+0x560/0x560
[49992.280222]  kthread+0x12c/0x150
[49992.283463]  ? __kthread_bind_mask+0x60/0x60
[49992.287745]  ret_from_fork+0x22/0x30
[49992.291336] task:kworker/15:50   state:D stack:    0 pid:178032 ppid:     2 flags:0x00004000
[49992.299773] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.305017] Call Trace:
[49992.307468]  __schedule+0x38b/0xc50
[49992.310962]  schedule+0x5b/0xc0
[49992.314116]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.318969]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.323907]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.328328]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.333008]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.337524]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.342465]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.347846]  ? lock_release+0x1cd/0x2a0
[49992.351694]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.356623]  iomap_dio_complete+0x45/0x130
[49992.360739]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.365456]  iomap_dio_complete_work+0x17/0x30
[49992.369910]  process_one_work+0x26e/0x560
[49992.373931]  worker_thread+0x52/0x3b0
[49992.377614]  ? process_one_work+0x560/0x560
[49992.381801]  kthread+0x12c/0x150
[49992.385042]  ? __kthread_bind_mask+0x60/0x60
[49992.389328]  ret_from_fork+0x22/0x30
[49992.392917] task:kworker/15:57   state:D stack:    0 pid:178039 ppid:     2 flags:0x00004000
[49992.401360] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.406593] Call Trace:
[49992.409048]  __schedule+0x38b/0xc50
[49992.412559]  schedule+0x5b/0xc0
[49992.415709]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.420565]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.425515]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.429933]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.434623]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.439139]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.444093]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.449466]  ? lock_release+0x1cd/0x2a0
[49992.453308]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.458264]  iomap_dio_complete+0x45/0x130
[49992.462371]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.467083]  iomap_dio_complete_work+0x17/0x30
[49992.471531]  process_one_work+0x26e/0x560
[49992.475543]  worker_thread+0x52/0x3b0
[49992.479210]  ? process_one_work+0x560/0x560
[49992.483412]  kthread+0x12c/0x150
[49992.486645]  ? __kthread_bind_mask+0x60/0x60
[49992.490927]  ret_from_fork+0x22/0x30
[49992.494530] task:kworker/17:106  state:D stack:    0 pid:178551 ppid:     2 flags:0x00004000
[49992.502963] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.508188] Call Trace:
[49992.510643]  __schedule+0x38b/0xc50
[49992.514152]  schedule+0x5b/0xc0
[49992.517297]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.522170]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.527108]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.531545]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.536234]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.540749]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.545688]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.551054]  ? lock_release+0x1cd/0x2a0
[49992.554903]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.559832]  iomap_dio_complete+0x45/0x130
[49992.563930]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.568655]  iomap_dio_complete_work+0x17/0x30
[49992.573108]  process_one_work+0x26e/0x560
[49992.577141]  worker_thread+0x52/0x3b0
[49992.580815]  ? process_one_work+0x560/0x560
[49992.585010]  kthread+0x12c/0x150
[49992.588249]  ? __kthread_bind_mask+0x60/0x60
[49992.592522]  ret_from_fork+0x22/0x30
[49992.596116] task:kworker/3:189   state:D stack:    0 pid:178661 ppid:     2 flags:0x00004000
[49992.604550] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.609778] Call Trace:
[49992.612249]  __schedule+0x38b/0xc50
[49992.615758]  schedule+0x5b/0xc0
[49992.618909]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.623773]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.628730]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.633150]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.637856]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.642364]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.647312]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.652701]  ? lock_release+0x1cd/0x2a0
[49992.656548]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.661481]  iomap_dio_complete+0x45/0x130
[49992.665587]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.670293]  iomap_dio_complete_work+0x17/0x30
[49992.674738]  process_one_work+0x26e/0x560
[49992.678754]  worker_thread+0x52/0x3b0
[49992.682425]  ? process_one_work+0x560/0x560
[49992.686611]  kthread+0x12c/0x150
[49992.689844]  ? __kthread_bind_mask+0x60/0x60
[49992.694119]  ret_from_fork+0x22/0x30
[49992.697712] task:kworker/7:123   state:D stack:    0 pid:178852 ppid:     2 flags:0x00004000
[49992.706147] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.711381] Call Trace:
[49992.713842]  __schedule+0x38b/0xc50
[49992.717336]  schedule+0x5b/0xc0
[49992.720490]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.725342]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.730301]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.734720]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.739399]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.743916]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.748856]  ? next_online_pgdat+0x2a/0x50
[49992.752963]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.758334]  ? lock_release+0x1cd/0x2a0
[49992.762174]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.767105]  iomap_dio_complete+0x45/0x130
[49992.771205]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.775918]  iomap_dio_complete_work+0x17/0x30
[49992.780382]  process_one_work+0x26e/0x560
[49992.784396]  worker_thread+0x52/0x3b0
[49992.788068]  ? process_one_work+0x560/0x560
[49992.792256]  kthread+0x12c/0x150
[49992.795497]  ? __kthread_bind_mask+0x60/0x60
[49992.799777]  ret_from_fork+0x22/0x30
[49992.803372] task:kworker/5:153   state:D stack:    0 pid:181122 ppid:     2 flags:0x00004000
[49992.811807] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.817050] Call Trace:
[49992.819502]  __schedule+0x38b/0xc50
[49992.822996]  schedule+0x5b/0xc0
[49992.826160]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.831009]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.835951]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.840385]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.845076]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.849583]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.854534]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.859923]  ? lock_release+0x1cd/0x2a0
[49992.863780]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.868735]  iomap_dio_complete+0x45/0x130
[49992.872842]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.877559]  iomap_dio_complete_work+0x17/0x30
[49992.882011]  process_one_work+0x26e/0x560
[49992.886025]  worker_thread+0x52/0x3b0
[49992.889691]  ? process_one_work+0x560/0x560
[49992.893877]  kthread+0x12c/0x150
[49992.897110]  ? __kthread_bind_mask+0x60/0x60
[49992.901407]  ret_from_fork+0x22/0x30
[49992.905002] task:kworker/17:123  state:D stack:    0 pid:181262 ppid:     2 flags:0x00004000
[49992.913437] Workqueue: dio/dm-5 iomap_dio_complete_work
[49992.918663] Call Trace:
[49992.921115]  __schedule+0x38b/0xc50
[49992.924608]  schedule+0x5b/0xc0
[49992.927763]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49992.932623]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49992.937581]  xfs_log_reserve+0xf6/0x310 [xfs]
[49992.942002]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49992.946680]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49992.951207]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49992.956162]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49992.961535]  ? lock_release+0x1cd/0x2a0
[49992.965384]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49992.970315]  iomap_dio_complete+0x45/0x130
[49992.974422]  ? aio_poll_complete_work+0x1b0/0x1b0
[49992.979136]  iomap_dio_complete_work+0x17/0x30
[49992.983582]  process_one_work+0x26e/0x560
[49992.987597]  worker_thread+0x52/0x3b0
[49992.991270]  ? process_one_work+0x560/0x560
[49992.995463]  kthread+0x12c/0x150
[49992.998706]  ? __kthread_bind_mask+0x60/0x60
[49993.002986]  ret_from_fork+0x22/0x30
[49993.006579] task:kworker/17:137  state:D stack:    0 pid:181276 ppid:     2 flags:0x00004000
[49993.015017] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.020249] Call Trace:
[49993.022704]  __schedule+0x38b/0xc50
[49993.026206]  schedule+0x5b/0xc0
[49993.029356]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.034228]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.039169]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.043590]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.048270]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.052794]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.057733]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.063104]  ? lock_release+0x1cd/0x2a0
[49993.066944]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.071883]  iomap_dio_complete+0x45/0x130
[49993.075982]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.080688]  iomap_dio_complete_work+0x17/0x30
[49993.085134]  process_one_work+0x26e/0x560
[49993.089148]  worker_thread+0x52/0x3b0
[49993.092821]  ? process_one_work+0x560/0x560
[49993.097008]  kthread+0x12c/0x150
[49993.100249]  ? __kthread_bind_mask+0x60/0x60
[49993.104548]  ret_from_fork+0x22/0x30
[49993.108141] task:kworker/17:140  state:D stack:    0 pid:181279 ppid:     2 flags:0x00004000
[49993.116584] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.121810] Call Trace:
[49993.124264]  __schedule+0x38b/0xc50
[49993.127765]  schedule+0x5b/0xc0
[49993.130918]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.135779]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.140720]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.145159]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.149856]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.154363]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.159336]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.164725]  ? lock_release+0x1cd/0x2a0
[49993.168567]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.173497]  iomap_dio_complete+0x45/0x130
[49993.177595]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.182320]  iomap_dio_complete_work+0x17/0x30
[49993.186775]  process_one_work+0x26e/0x560
[49993.190796]  worker_thread+0x52/0x3b0
[49993.194470]  ? process_one_work+0x560/0x560
[49993.198665]  kthread+0x12c/0x150
[49993.201904]  ? __kthread_bind_mask+0x60/0x60
[49993.206188]  ret_from_fork+0x22/0x30
[49993.209777] task:kworker/3:195   state:D stack:    0 pid:181289 ppid:     2 flags:0x00004000
[49993.218225] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.223459] Call Trace:
[49993.225910]  __schedule+0x38b/0xc50
[49993.229421]  schedule+0x5b/0xc0
[49993.232574]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.237430]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.242368]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.246788]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.251477]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.255984]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.260923]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.266294]  ? lock_release+0x1cd/0x2a0
[49993.270134]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.275066]  iomap_dio_complete+0x45/0x130
[49993.279166]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.283890]  iomap_dio_complete_work+0x17/0x30
[49993.288351]  process_one_work+0x26e/0x560
[49993.292365]  worker_thread+0x52/0x3b0
[49993.296031]  ? process_one_work+0x560/0x560
[49993.300226]  kthread+0x12c/0x150
[49993.303465]  ? __kthread_bind_mask+0x60/0x60
[49993.307756]  ret_from_fork+0x22/0x30
[49993.311347] task:kworker/5:165   state:D stack:    0 pid:181411 ppid:     2 flags:0x00004000
[49993.319785] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.325037] Call Trace:
[49993.327490]  __schedule+0x38b/0xc50
[49993.330991]  schedule+0x5b/0xc0
[49993.334146]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.338996]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.343939]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.348356]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.353036]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.357544]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.362484]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.367866]  ? lock_release+0x1cd/0x2a0
[49993.371714]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.376663]  iomap_dio_complete+0x45/0x130
[49993.380769]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.385475]  iomap_dio_complete_work+0x17/0x30
[49993.389920]  process_one_work+0x26e/0x560
[49993.393934]  worker_thread+0x52/0x3b0
[49993.397599]  ? process_one_work+0x560/0x560
[49993.401785]  kthread+0x12c/0x150
[49993.405018]  ? __kthread_bind_mask+0x60/0x60
[49993.409300]  ret_from_fork+0x22/0x30
[49993.412897] task:kworker/13:186  state:D stack:    0 pid:184018 ppid:     2 flags:0x00004000
[49993.421353] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.426580] Call Trace:
[49993.429034]  __schedule+0x38b/0xc50
[49993.432536]  schedule+0x5b/0xc0
[49993.435689]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.440542]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.445481]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.449903]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.454578]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.459079]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.464020]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.469393]  ? lock_release+0x1cd/0x2a0
[49993.473240]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.478172]  iomap_dio_complete+0x45/0x130
[49993.482277]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.486984]  iomap_dio_complete_work+0x17/0x30
[49993.491430]  process_one_work+0x26e/0x560
[49993.495446]  worker_thread+0x52/0x3b0
[49993.499116]  ? process_one_work+0x560/0x560
[49993.503304]  kthread+0x12c/0x150
[49993.506543]  ? __kthread_bind_mask+0x60/0x60
[49993.510833]  ret_from_fork+0x22/0x30
[49993.514422] task:kworker/0:124   state:D stack:    0 pid:186072 ppid:     2 flags:0x00004000
[49993.522879] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.528108] Call Trace:
[49993.530559]  __schedule+0x38b/0xc50
[49993.534068]  schedule+0x5b/0xc0
[49993.537214]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.542069]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.547027]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.551463]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.556144]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.560667]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.565607]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.570978]  ? lock_release+0x1cd/0x2a0
[49993.574819]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.579758]  iomap_dio_complete+0x45/0x130
[49993.583858]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.588588]  iomap_dio_complete_work+0x17/0x30
[49993.593051]  process_one_work+0x26e/0x560
[49993.597065]  worker_thread+0x52/0x3b0
[49993.600748]  ? process_one_work+0x560/0x560
[49993.604934]  kthread+0x12c/0x150
[49993.608174]  ? __kthread_bind_mask+0x60/0x60
[49993.612455]  ret_from_fork+0x22/0x30
[49993.616050] task:kworker/0:134   state:D stack:    0 pid:186618 ppid:     2 flags:0x00004000
[49993.624486] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.629727] Call Trace:
[49993.632199]  __schedule+0x38b/0xc50
[49993.635708]  schedule+0x5b/0xc0
[49993.638852]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.643708]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.648647]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.653066]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.657764]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.662270]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.667228]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.672600]  ? lock_release+0x1cd/0x2a0
[49993.676447]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.681386]  iomap_dio_complete+0x45/0x130
[49993.685489]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.690203]  iomap_dio_complete_work+0x17/0x30
[49993.694657]  process_one_work+0x26e/0x560
[49993.698679]  worker_thread+0x52/0x3b0
[49993.702351]  ? process_one_work+0x560/0x560
[49993.706537]  kthread+0x12c/0x150
[49993.709779]  ? __kthread_bind_mask+0x60/0x60
[49993.714061]  ret_from_fork+0x22/0x30
[49993.717651] task:kworker/0:137   state:D stack:    0 pid:186621 ppid:     2 flags:0x00004000
[49993.726088] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.731314] Call Trace:
[49993.733768]  __schedule+0x38b/0xc50
[49993.737270]  schedule+0x5b/0xc0
[49993.740422]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.745295]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.750235]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.754653]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.759334]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.763839]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49993.768788]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49993.774152]  ? lock_release+0x1cd/0x2a0
[49993.777993]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49993.782942]  iomap_dio_complete+0x45/0x130
[49993.787046]  ? aio_poll_complete_work+0x1b0/0x1b0
[49993.791754]  iomap_dio_complete_work+0x17/0x30
[49993.796228]  process_one_work+0x26e/0x560
[49993.800247]  worker_thread+0x52/0x3b0
[49993.803921]  ? process_one_work+0x560/0x560
[49993.808107]  kthread+0x12c/0x150
[49993.811347]  ? __kthread_bind_mask+0x60/0x60
[49993.815621]  ret_from_fork+0x22/0x30
[49993.819216] task:kworker/u162:6  state:D stack:    0 pid:189040 ppid:     2 flags:0x00004000
[49993.827648] Workqueue: writeback wb_workfn (flush-253:5)
[49993.832969] Call Trace:
[49993.835423]  __schedule+0x38b/0xc50
[49993.838916]  schedule+0x5b/0xc0
[49993.842062]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.846932]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.851895]  xfs_log_reserve+0xf6/0x310 [xfs]
[49993.856317]  ? lock_release+0x1cd/0x2a0
[49993.860158]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49993.864838]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49993.869343]  xfs_bmapi_convert_delalloc+0xb1/0x470 [xfs]
[49993.874713]  xfs_map_blocks+0x1b2/0x5c0 [xfs]
[49993.879131]  iomap_do_writepage+0x161/0x860
[49993.883325]  write_cache_pages+0x18d/0x440
[49993.887431]  ? iomap_readahead_actor+0x1d0/0x1d0
[49993.892059]  iomap_writepages+0x1c/0x40
[49993.895904]  xfs_vm_writepages+0x6f/0x90 [xfs]
[49993.900405]  do_writepages+0x28/0xa0
[49993.903992]  ? lock_acquire+0x15d/0x380
[49993.907839]  ? lock_release+0x1cd/0x2a0
[49993.911678]  ? trace_hardirqs_on+0x1b/0xd0
[49993.915785]  ? lock_release+0x1cd/0x2a0
[49993.919625]  __writeback_single_inode+0x54/0x520
[49993.924254]  writeback_sb_inodes+0x1e3/0x4e0
[49993.928538]  __writeback_inodes_wb+0x4c/0xe0
[49993.932816]  wb_writeback+0x283/0x400
[49993.936483]  wb_workfn+0x2da/0x630
[49993.939898]  ? lock_acquire+0x15d/0x380
[49993.943745]  process_one_work+0x26e/0x560
[49993.947767]  worker_thread+0x52/0x3b0
[49993.951449]  ? process_one_work+0x560/0x560
[49993.955643]  kthread+0x12c/0x150
[49993.958885]  ? __kthread_bind_mask+0x60/0x60
[49993.963165]  ret_from_fork+0x22/0x30
[49993.966751] task:kworker/7:156   state:D stack:    0 pid:189055 ppid:     2 flags:0x00004000
[49993.975195] Workqueue: dio/dm-5 iomap_dio_complete_work
[49993.980446] Call Trace:
[49993.982899]  __schedule+0x38b/0xc50
[49993.986401]  schedule+0x5b/0xc0
[49993.989555]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49993.994408]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49993.999349]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.003767]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.008448]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.012973]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.017910]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.023283]  ? lock_release+0x1cd/0x2a0
[49994.027123]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.032065]  iomap_dio_complete+0x45/0x130
[49994.036172]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.040886]  iomap_dio_complete_work+0x17/0x30
[49994.045340]  process_one_work+0x26e/0x560
[49994.049353]  worker_thread+0x52/0x3b0
[49994.053026]  ? process_one_work+0x560/0x560
[49994.057212]  kthread+0x12c/0x150
[49994.060445]  ? __kthread_bind_mask+0x60/0x60
[49994.064735]  ret_from_fork+0x22/0x30
[49994.068345] task:kworker/7:159   state:D stack:    0 pid:189058 ppid:     2 flags:0x00004000
[49994.076783] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.082024] Call Trace:
[49994.084477]  __schedule+0x38b/0xc50
[49994.087969]  schedule+0x5b/0xc0
[49994.091116]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.095987]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.100943]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.105372]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.110070]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.114577]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.119516]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.124888]  ? lock_release+0x1cd/0x2a0
[49994.128737]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.133675]  iomap_dio_complete+0x45/0x130
[49994.137775]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.142499]  iomap_dio_complete_work+0x17/0x30
[49994.146951]  process_one_work+0x26e/0x560
[49994.150966]  worker_thread+0x52/0x3b0
[49994.154640]  ? process_one_work+0x560/0x560
[49994.158843]  kthread+0x12c/0x150
[49994.162086]  ? __kthread_bind_mask+0x60/0x60
[49994.166364]  ret_from_fork+0x22/0x30
[49994.169967] task:kworker/0:174   state:D stack:    0 pid:191466 ppid:     2 flags:0x00004000
[49994.178404] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.183638] Call Trace:
[49994.186090]  __schedule+0x38b/0xc50
[49994.189582]  schedule+0x5b/0xc0
[49994.192737]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.197590]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.202530]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.206960]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.211657]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.216171]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.221110]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.226493]  ? lock_release+0x1cd/0x2a0
[49994.230342]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.235297]  iomap_dio_complete+0x45/0x130
[49994.239397]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.244112]  iomap_dio_complete_work+0x17/0x30
[49994.248565]  process_one_work+0x26e/0x560
[49994.252579]  worker_thread+0x52/0x3b0
[49994.256253]  ? process_one_work+0x560/0x560
[49994.260441]  kthread+0x12c/0x150
[49994.263688]  ? __kthread_bind_mask+0x60/0x60
[49994.267961]  ret_from_fork+0x22/0x30
[49994.271566] task:kworker/5:189   state:D stack:    0 pid:198195 ppid:     2 flags:0x00004000
[49994.280007] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.285232] Call Trace:
[49994.287693]  __schedule+0x38b/0xc50
[49994.291186]  schedule+0x5b/0xc0
[49994.294331]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.299186]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.304125]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.308547]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.313225]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.317750]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.322690]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.328061]  ? lock_release+0x1cd/0x2a0
[49994.331900]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.336857]  iomap_dio_complete+0x45/0x130
[49994.340967]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.345671]  iomap_dio_complete_work+0x17/0x30
[49994.350126]  process_one_work+0x26e/0x560
[49994.354139]  worker_thread+0x52/0x3b0
[49994.357804]  ? process_one_work+0x560/0x560
[49994.362008]  kthread+0x12c/0x150
[49994.365250]  ? __kthread_bind_mask+0x60/0x60
[49994.369529]  ret_from_fork+0x22/0x30
[49994.373117] task:kworker/5:197   state:D stack:    0 pid:198203 ppid:     2 flags:0x00004000
[49994.381550] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.386784] Call Trace:
[49994.389237]  __schedule+0x38b/0xc50
[49994.392730]  schedule+0x5b/0xc0
[49994.395901]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.400754]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.405712]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.410133]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.414820]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.419328]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.424277]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.429641]  ? lock_release+0x1cd/0x2a0
[49994.433489]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.438428]  iomap_dio_complete+0x45/0x130
[49994.442528]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.447249]  iomap_dio_complete_work+0x17/0x30
[49994.451695]  process_one_work+0x26e/0x560
[49994.455718]  worker_thread+0x52/0x3b0
[49994.459400]  ? process_one_work+0x560/0x560
[49994.463596]  kthread+0x12c/0x150
[49994.466835]  ? __kthread_bind_mask+0x60/0x60
[49994.471108]  ret_from_fork+0x22/0x30
[49994.474691] task:kworker/5:203   state:D stack:    0 pid:198209 ppid:     2 flags:0x00004000
[49994.483147] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.488380] Call Trace:
[49994.490835]  __schedule+0x38b/0xc50
[49994.494344]  schedule+0x5b/0xc0
[49994.497499]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.502352]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.507299]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.511720]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.516398]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.520905]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.525846]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.531211]  ? lock_release+0x1cd/0x2a0
[49994.535076]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.540006]  iomap_dio_complete+0x45/0x130
[49994.544105]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.548828]  iomap_dio_complete_work+0x17/0x30
[49994.553301]  process_one_work+0x26e/0x560
[49994.557313]  worker_thread+0x52/0x3b0
[49994.560978]  ? process_one_work+0x560/0x560
[49994.565164]  kthread+0x12c/0x150
[49994.568413]  ? __kthread_bind_mask+0x60/0x60
[49994.572688]  ret_from_fork+0x22/0x30
[49994.576279] task:kworker/5:204   state:D stack:    0 pid:198210 ppid:     2 flags:0x00004000
[49994.584725] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.589968] Call Trace:
[49994.592421]  __schedule+0x38b/0xc50
[49994.595922]  schedule+0x5b/0xc0
[49994.599076]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.603945]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.608887]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.613306]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.617985]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.622492]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.627434]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.632807]  ? lock_release+0x1cd/0x2a0
[49994.636654]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.641584]  iomap_dio_complete+0x45/0x130
[49994.645684]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.650399]  iomap_dio_complete_work+0x17/0x30
[49994.654862]  process_one_work+0x26e/0x560
[49994.658883]  worker_thread+0x52/0x3b0
[49994.662550]  ? process_one_work+0x560/0x560
[49994.666743]  kthread+0x12c/0x150
[49994.669975]  ? __kthread_bind_mask+0x60/0x60
[49994.674247]  ret_from_fork+0x22/0x30
[49994.677842] task:kworker/5:231   state:D stack:    0 pid:198249 ppid:     2 flags:0x00004000
[49994.686279] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.691510] Call Trace:
[49994.693973]  __schedule+0x38b/0xc50
[49994.697483]  schedule+0x5b/0xc0
[49994.700637]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.705500]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.710455]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.714893]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.719590]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.724097]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.729039]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.734428]  ? lock_release+0x1cd/0x2a0
[49994.738275]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.743206]  iomap_dio_complete+0x45/0x130
[49994.747323]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.752029]  iomap_dio_complete_work+0x17/0x30
[49994.756484]  process_one_work+0x26e/0x560
[49994.760506]  worker_thread+0x52/0x3b0
[49994.764177]  ? process_one_work+0x560/0x560
[49994.768364]  kthread+0x12c/0x150
[49994.771606]  ? __kthread_bind_mask+0x60/0x60
[49994.775888]  ret_from_fork+0x22/0x30
[49994.779481] task:kworker/5:233   state:D stack:    0 pid:198251 ppid:     2 flags:0x00004000
[49994.787943] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.793178] Call Trace:
[49994.795638]  __schedule+0x38b/0xc50
[49994.799140]  schedule+0x5b/0xc0
[49994.802292]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.807156]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.812114]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.816551]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.821231]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.825736]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.830676]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.836050]  ? lock_release+0x1cd/0x2a0
[49994.839896]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.844827]  iomap_dio_complete+0x45/0x130
[49994.848934]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.853641]  iomap_dio_complete_work+0x17/0x30
[49994.858088]  process_one_work+0x26e/0x560
[49994.862109]  worker_thread+0x52/0x3b0
[49994.865775]  ? process_one_work+0x560/0x560
[49994.869970]  kthread+0x12c/0x150
[49994.873211]  ? __kthread_bind_mask+0x60/0x60
[49994.877508]  ret_from_fork+0x22/0x30
[49994.881093] task:kworker/0:201   state:D stack:    0 pid:198411 ppid:     2 flags:0x00004000
[49994.889528] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.894764] Call Trace:
[49994.897217]  __schedule+0x38b/0xc50
[49994.900718]  schedule+0x5b/0xc0
[49994.903870]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49994.908741]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49994.913682]  xfs_log_reserve+0xf6/0x310 [xfs]
[49994.918101]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49994.922799]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49994.927323]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49994.932282]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49994.937661]  ? lock_release+0x1cd/0x2a0
[49994.941502]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49994.946433]  iomap_dio_complete+0x45/0x130
[49994.950540]  ? aio_poll_complete_work+0x1b0/0x1b0
[49994.955245]  iomap_dio_complete_work+0x17/0x30
[49994.959699]  process_one_work+0x26e/0x560
[49994.963732]  worker_thread+0x52/0x3b0
[49994.967403]  ? process_one_work+0x560/0x560
[49994.971591]  kthread+0x12c/0x150
[49994.974830]  ? __kthread_bind_mask+0x60/0x60
[49994.979113]  ret_from_fork+0x22/0x30
[49994.982709] task:kworker/17:202  state:D stack:    0 pid:200676 ppid:     2 flags:0x00004000
[49994.991153] Workqueue: dio/dm-5 iomap_dio_complete_work
[49994.996393] Call Trace:
[49994.998846]  __schedule+0x38b/0xc50
[49995.002373]  schedule+0x5b/0xc0
[49995.005518]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.010373]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.015329]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.019757]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.024439]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.028945]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.033885]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.039276]  ? lock_release+0x1cd/0x2a0
[49995.043124]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.048071]  iomap_dio_complete+0x45/0x130
[49995.052168]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.056895]  iomap_dio_complete_work+0x17/0x30
[49995.061348]  process_one_work+0x26e/0x560
[49995.065361]  worker_thread+0x52/0x3b0
[49995.069036]  ? process_one_work+0x560/0x560
[49995.073228]  kthread+0x12c/0x150
[49995.076471]  ? __kthread_bind_mask+0x60/0x60
[49995.080751]  ret_from_fork+0x22/0x30
[49995.084344] task:kworker/17:205  state:D stack:    0 pid:200679 ppid:     2 flags:0x00004000
[49995.092780] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.098015] Call Trace:
[49995.100468]  __schedule+0x38b/0xc50
[49995.103961]  schedule+0x5b/0xc0
[49995.107114]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.111968]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.116908]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.121331]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.126007]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.130516]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.135454]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.140845]  ? lock_release+0x1cd/0x2a0
[49995.144694]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.149623]  iomap_dio_complete+0x45/0x130
[49995.153723]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.158436]  iomap_dio_complete_work+0x17/0x30
[49995.162881]  process_one_work+0x26e/0x560
[49995.166896]  worker_thread+0x52/0x3b0
[49995.170570]  ? process_one_work+0x560/0x560
[49995.174765]  kthread+0x12c/0x150
[49995.178005]  ? __kthread_bind_mask+0x60/0x60
[49995.182278]  ret_from_fork+0x22/0x30
[49995.185876] task:kworker/17:218  state:D stack:    0 pid:202655 ppid:     2 flags:0x00004000
[49995.194323] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.199558] Call Trace:
[49995.202013]  __schedule+0x38b/0xc50
[49995.205515]  schedule+0x5b/0xc0
[49995.208667]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.213522]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.218460]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.222889]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.227585]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.232103]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.237058]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.242448]  ? lock_release+0x1cd/0x2a0
[49995.246286]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.251228]  iomap_dio_complete+0x45/0x130
[49995.255325]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.260033]  iomap_dio_complete_work+0x17/0x30
[49995.264487]  process_one_work+0x26e/0x560
[49995.268501]  worker_thread+0x52/0x3b0
[49995.272175]  ? process_one_work+0x560/0x560
[49995.276370]  kthread+0x12c/0x150
[49995.279609]  ? __kthread_bind_mask+0x60/0x60
[49995.283881]  ret_from_fork+0x22/0x30
[49995.287467] task:kworker/17:226  state:D stack:    0 pid:202663 ppid:     2 flags:0x00004000
[49995.295913] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.301145] Call Trace:
[49995.303601]  __schedule+0x38b/0xc50
[49995.307100]  schedule+0x5b/0xc0
[49995.310254]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.315116]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.320055]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.324492]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.329173]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.333707]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.338654]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.344027]  ? lock_release+0x1cd/0x2a0
[49995.347873]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.352804]  iomap_dio_complete+0x45/0x130
[49995.356903]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.361621]  iomap_dio_complete_work+0x17/0x30
[49995.366084]  process_one_work+0x26e/0x560
[49995.370114]  worker_thread+0x52/0x3b0
[49995.373806]  ? process_one_work+0x560/0x560
[49995.378009]  kthread+0x12c/0x150
[49995.381248]  ? __kthread_bind_mask+0x60/0x60
[49995.385521]  ret_from_fork+0x22/0x30
[49995.389143] task:kworker/0:212   state:D stack:    0 pid:206986 ppid:     2 flags:0x00004000
[49995.397585] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.402812] Call Trace:
[49995.405263]  __schedule+0x38b/0xc50
[49995.408766]  schedule+0x5b/0xc0
[49995.411917]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.416773]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.421713]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.426133]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.430811]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.435319]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.440258]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.445624]  ? lock_release+0x1cd/0x2a0
[49995.449471]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.454401]  iomap_dio_complete+0x45/0x130
[49995.458501]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.463216]  iomap_dio_complete_work+0x17/0x30
[49995.467669]  process_one_work+0x26e/0x560
[49995.471700]  worker_thread+0x52/0x3b0
[49995.475374]  ? process_one_work+0x560/0x560
[49995.479561]  kthread+0x12c/0x150
[49995.482801]  ? __kthread_bind_mask+0x60/0x60
[49995.487092]  ret_from_fork+0x22/0x30
[49995.490683] task:kworker/0:221   state:D stack:    0 pid:206995 ppid:     2 flags:0x00004000
[49995.499136] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.504363] Call Trace:
[49995.506825]  __schedule+0x38b/0xc50
[49995.510326]  schedule+0x5b/0xc0
[49995.513479]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.518333]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.523290]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.527710]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.532390]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.536916]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.541870]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.547241]  ? lock_release+0x1cd/0x2a0
[49995.551084]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.556016]  iomap_dio_complete+0x45/0x130
[49995.560121]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.564846]  iomap_dio_complete_work+0x17/0x30
[49995.569292]  process_one_work+0x26e/0x560
[49995.573313]  worker_thread+0x52/0x3b0
[49995.576979]  ? process_one_work+0x560/0x560
[49995.581166]  kthread+0x12c/0x150
[49995.584404]  ? __kthread_bind_mask+0x60/0x60
[49995.588687]  ret_from_fork+0x22/0x30
[49995.592280] task:kworker/u161:5  state:D stack:    0 pid:207016 ppid:     2 flags:0x00004000
[49995.600714] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[49995.606453] Call Trace:
[49995.608906]  __schedule+0x38b/0xc50
[49995.612407]  ? lock_release+0x1cd/0x2a0
[49995.616254]  schedule+0x5b/0xc0
[49995.619398]  xlog_state_get_iclog_space+0x167/0x340 [xfs]
[49995.624878]  ? wake_up_q+0xa0/0xa0
[49995.628292]  xlog_write+0x159/0xa10 [xfs]
[49995.632384]  xlog_cil_push_work+0x2dd/0x630 [xfs]
[49995.637152]  ? update_irq_load_avg+0x1df/0x480
[49995.641602]  ? sched_clock_cpu+0xc/0xb0
[49995.645443]  ? lock_acquire+0x15d/0x380
[49995.649291]  ? lock_release+0x1cd/0x2a0
[49995.653137]  ? lock_acquire+0x15d/0x380
[49995.656977]  ? lock_release+0x1cd/0x2a0
[49995.660814]  ? finish_task_switch.isra.0+0xa0/0x2c0
[49995.665716]  process_one_work+0x26e/0x560
[49995.669744]  worker_thread+0x52/0x3b0
[49995.673418]  ? process_one_work+0x560/0x560
[49995.677612]  kthread+0x12c/0x150
[49995.680853]  ? __kthread_bind_mask+0x60/0x60
[49995.685135]  ret_from_fork+0x22/0x30
[49995.688726] task:kworker/3:213   state:D stack:    0 pid:207036 ppid:     2 flags:0x00004000
[49995.697164] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.702399] Call Trace:
[49995.704860]  __schedule+0x38b/0xc50
[49995.708361]  schedule+0x5b/0xc0
[49995.711515]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.716368]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.721309]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.725737]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.730415]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.734923]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.739873]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.745243]  ? lock_release+0x1cd/0x2a0
[49995.749092]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.754025]  iomap_dio_complete+0x45/0x130
[49995.758132]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.762845]  iomap_dio_complete_work+0x17/0x30
[49995.767293]  process_one_work+0x26e/0x560
[49995.771313]  worker_thread+0x52/0x3b0
[49995.774986]  ? process_one_work+0x560/0x560
[49995.779173]  kthread+0x12c/0x150
[49995.782415]  ? __kthread_bind_mask+0x60/0x60
[49995.786703]  ret_from_fork+0x22/0x30
[49995.790286] task:kworker/3:215   state:D stack:    0 pid:207038 ppid:     2 flags:0x00004000
[49995.798724] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.803958] Call Trace:
[49995.806412]  __schedule+0x38b/0xc50
[49995.809913]  schedule+0x5b/0xc0
[49995.813065]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.817938]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.822895]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.827314]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.832011]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.836518]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.841474]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.846840]  ? lock_release+0x1cd/0x2a0
[49995.850688]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.855629]  iomap_dio_complete+0x45/0x130
[49995.859735]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.864440]  iomap_dio_complete_work+0x17/0x30
[49995.868888]  process_one_work+0x26e/0x560
[49995.872908]  worker_thread+0x52/0x3b0
[49995.876573]  ? process_one_work+0x560/0x560
[49995.880761]  kthread+0x12c/0x150
[49995.884002]  ? __kthread_bind_mask+0x60/0x60
[49995.888281]  ret_from_fork+0x22/0x30
[49995.891867] task:kworker/5:238   state:D stack:    0 pid:207109 ppid:     2 flags:0x00004000
[49995.900313] Workqueue: dio/dm-5 iomap_dio_complete_work
[49995.905555] Call Trace:
[49995.908008]  __schedule+0x38b/0xc50
[49995.911509]  schedule+0x5b/0xc0
[49995.914662]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49995.919517]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49995.924464]  xfs_log_reserve+0xf6/0x310 [xfs]
[49995.928885]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49995.933564]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49995.938071]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49995.943009]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49995.948376]  ? lock_release+0x1cd/0x2a0
[49995.952231]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49995.957164]  iomap_dio_complete+0x45/0x130
[49995.961271]  ? aio_poll_complete_work+0x1b0/0x1b0
[49995.965985]  iomap_dio_complete_work+0x17/0x30
[49995.970429]  process_one_work+0x26e/0x560
[49995.974443]  worker_thread+0x52/0x3b0
[49995.978107]  ? process_one_work+0x560/0x560
[49995.982296]  kthread+0x12c/0x150
[49995.985536]  ? __kthread_bind_mask+0x60/0x60
[49995.989817]  ret_from_fork+0x22/0x30
[49995.993418] task:kworker/u161:6  state:D stack:    0 pid:207192 ppid:     2 flags:0x00004000
[49996.001855] Workqueue: xfs-cil/dm-5 xlog_cil_push_work [xfs]
[49996.007574] Call Trace:
[49996.010027]  __schedule+0x38b/0xc50
[49996.013527]  ? lock_release+0x1cd/0x2a0
[49996.017377]  schedule+0x5b/0xc0
[49996.020529]  xlog_state_get_iclog_space+0x167/0x340 [xfs]
[49996.025989]  ? wake_up_q+0xa0/0xa0
[49996.029397]  xlog_write+0x159/0xa10 [xfs]
[49996.033479]  xlog_cil_push_work+0x2dd/0x630 [xfs]
[49996.038264]  ? lock_acquire+0x15d/0x380
[49996.042111]  ? lock_release+0x1cd/0x2a0
[49996.045958]  ? lock_acquire+0x15d/0x380
[49996.049805]  ? lock_release+0x1cd/0x2a0
[49996.053651]  ? finish_task_switch.isra.0+0xa0/0x2c0
[49996.058551]  process_one_work+0x26e/0x560
[49996.062570]  worker_thread+0x52/0x3b0
[49996.066238]  ? process_one_work+0x560/0x560
[49996.070431]  kthread+0x12c/0x150
[49996.073673]  ? __kthread_bind_mask+0x60/0x60
[49996.077954]  ret_from_fork+0x22/0x30
[49996.081549] task:kworker/15:227  state:D stack:    0 pid:217952 ppid:     2 flags:0x00004000
[49996.089984] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.095219] Call Trace:
[49996.097679]  __schedule+0x38b/0xc50
[49996.101179]  schedule+0x5b/0xc0
[49996.104324]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.109196]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.114135]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.118554]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.123235]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.127760]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.132701]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.138073]  ? lock_release+0x1cd/0x2a0
[49996.141939]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.146894]  iomap_dio_complete+0x45/0x130
[49996.150994]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.155708]  iomap_dio_complete_work+0x17/0x30
[49996.160171]  process_one_work+0x26e/0x560
[49996.164186]  worker_thread+0x52/0x3b0
[49996.167856]  ? process_one_work+0x560/0x560
[49996.172044]  kthread+0x12c/0x150
[49996.175277]  ? __kthread_bind_mask+0x60/0x60
[49996.179549]  ret_from_fork+0x22/0x30
[49996.183134] task:kworker/15:246  state:D stack:    0 pid:217971 ppid:     2 flags:0x00004000
[49996.191570] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.196804] Call Trace:
[49996.199258]  __schedule+0x38b/0xc50
[49996.202758]  schedule+0x5b/0xc0
[49996.205903]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.210774]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.215716]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.220135]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.224814]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.229320]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.234259]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.239624]  ? lock_release+0x1cd/0x2a0
[49996.243464]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.248394]  iomap_dio_complete+0x45/0x130
[49996.252494]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.257207]  iomap_dio_complete_work+0x17/0x30
[49996.261663]  process_one_work+0x26e/0x560
[49996.265676]  worker_thread+0x52/0x3b0
[49996.269341]  ? process_one_work+0x560/0x560
[49996.273528]  kthread+0x12c/0x150
[49996.276769]  ? __kthread_bind_mask+0x60/0x60
[49996.281049]  ret_from_fork+0x22/0x30
[49996.284643] task:kworker/7:233   state:D stack:    0 pid:218016 ppid:     2 flags:0x00004000
[49996.293096] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.298330] Call Trace:
[49996.300783]  __schedule+0x38b/0xc50
[49996.304284]  schedule+0x5b/0xc0
[49996.307429]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.312300]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.317251]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.321686]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.326366]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.330872]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.335831]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.341210]  ? lock_release+0x1cd/0x2a0
[49996.345052]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.349991]  iomap_dio_complete+0x45/0x130
[49996.354107]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.358814]  iomap_dio_complete_work+0x17/0x30
[49996.363278]  process_one_work+0x26e/0x560
[49996.367299]  worker_thread+0x52/0x3b0
[49996.370971]  ? process_one_work+0x560/0x560
[49996.375157]  kthread+0x12c/0x150
[49996.378391]  ? __kthread_bind_mask+0x60/0x60
[49996.382671]  ret_from_fork+0x22/0x30
[49996.386298] task:kworker/13:9    state:D stack:    0 pid:233919 ppid:     2 flags:0x00004000
[49996.394735] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.399960] Call Trace:
[49996.402421]  __schedule+0x38b/0xc50
[49996.405915]  schedule+0x5b/0xc0
[49996.409070]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.413940]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.418897]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.423318]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.427998]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.432519]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.437461]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.442852]  ? lock_release+0x1cd/0x2a0
[49996.446698]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.451638]  iomap_dio_complete+0x45/0x130
[49996.455737]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.460443]  iomap_dio_complete_work+0x17/0x30
[49996.464889]  process_one_work+0x26e/0x560
[49996.468903]  worker_thread+0x52/0x3b0
[49996.472576]  ? process_one_work+0x560/0x560
[49996.476762]  kthread+0x12c/0x150
[49996.480002]  ? __kthread_bind_mask+0x60/0x60
[49996.484283]  ret_from_fork+0x22/0x30
[49996.487868] task:kworker/13:20   state:D stack:    0 pid:233924 ppid:     2 flags:0x00004000
[49996.496303] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.501530] Call Trace:
[49996.503982]  __schedule+0x38b/0xc50
[49996.507476]  schedule+0x5b/0xc0
[49996.510629]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.515484]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.520440]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.524877]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.529557]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.534083]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.539022]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.544393]  ? lock_release+0x1cd/0x2a0
[49996.548244]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.553173]  iomap_dio_complete+0x45/0x130
[49996.557271]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.561978]  iomap_dio_complete_work+0x17/0x30
[49996.566432]  process_one_work+0x26e/0x560
[49996.570447]  worker_thread+0x52/0x3b0
[49996.574120]  ? process_one_work+0x560/0x560
[49996.578305]  kthread+0x12c/0x150
[49996.581537]  ? __kthread_bind_mask+0x60/0x60
[49996.585810]  ret_from_fork+0x22/0x30
[49996.589415] task:kworker/5:2     state:D stack:    0 pid:236035 ppid:     2 flags:0x00004000
[49996.597848] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.603082] Call Trace:
[49996.605536]  __schedule+0x38b/0xc50
[49996.609055]  schedule+0x5b/0xc0
[49996.612208]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.617081]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.622019]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.626440]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.631125]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.635644]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.640591]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.645965]  ? lock_release+0x1cd/0x2a0
[49996.649811]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.654741]  iomap_dio_complete+0x45/0x130
[49996.658842]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.663548]  iomap_dio_complete_work+0x17/0x30
[49996.668001]  process_one_work+0x26e/0x560
[49996.672025]  worker_thread+0x52/0x3b0
[49996.675697]  ? process_one_work+0x560/0x560
[49996.679892]  kthread+0x12c/0x150
[49996.683125]  ? __kthread_bind_mask+0x60/0x60
[49996.687406]  ret_from_fork+0x22/0x30
[49996.690999] task:kworker/5:4     state:D stack:    0 pid:236036 ppid:     2 flags:0x00004000
[49996.699434] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.704676] Call Trace:
[49996.707131]  __schedule+0x38b/0xc50
[49996.710623]  schedule+0x5b/0xc0
[49996.713778]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.718636]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.723571]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.728009]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.732706]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.737230]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.742186]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.747551]  ? lock_release+0x1cd/0x2a0
[49996.751416]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.756346]  iomap_dio_complete+0x45/0x130
[49996.760465]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.765177]  iomap_dio_complete_work+0x17/0x30
[49996.769632]  process_one_work+0x26e/0x560
[49996.773645]  worker_thread+0x52/0x3b0
[49996.777321]  ? process_one_work+0x560/0x560
[49996.781513]  kthread+0x12c/0x150
[49996.784753]  ? __kthread_bind_mask+0x60/0x60
[49996.789037]  ret_from_fork+0x22/0x30
[49996.792630] task:kworker/5:33    state:D stack:    0 pid:236092 ppid:     2 flags:0x00004000
[49996.801090] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.806317] Call Trace:
[49996.808770]  __schedule+0x38b/0xc50
[49996.812271]  schedule+0x5b/0xc0
[49996.815425]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.820279]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.825218]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.829637]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.834327]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.838852]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.843790]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.849162]  ? lock_release+0x1cd/0x2a0
[49996.853012]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.857959]  iomap_dio_complete+0x45/0x130
[49996.862057]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.866763]  iomap_dio_complete_work+0x17/0x30
[49996.871229]  process_one_work+0x26e/0x560
[49996.875251]  worker_thread+0x52/0x3b0
[49996.878923]  ? process_one_work+0x560/0x560
[49996.883115]  kthread+0x12c/0x150
[49996.886350]  ? __kthread_bind_mask+0x60/0x60
[49996.890632]  ret_from_fork+0x22/0x30
[49996.894219] task:kworker/15:6    state:D stack:    0 pid:236132 ppid:     2 flags:0x00004000
[49996.902652] Workqueue: dio/dm-5 iomap_dio_complete_work
[49996.907886] Call Trace:
[49996.910341]  __schedule+0x38b/0xc50
[49996.913840]  schedule+0x5b/0xc0
[49996.916985]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49996.921859]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49996.926798]  xfs_log_reserve+0xf6/0x310 [xfs]
[49996.931217]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49996.935897]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49996.940404]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49996.945345]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49996.950717]  ? lock_release+0x1cd/0x2a0
[49996.954573]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49996.959512]  iomap_dio_complete+0x45/0x130
[49996.963620]  ? aio_poll_complete_work+0x1b0/0x1b0
[49996.968344]  iomap_dio_complete_work+0x17/0x30
[49996.972798]  process_one_work+0x26e/0x560
[49996.976812]  worker_thread+0x52/0x3b0
[49996.980486]  ? process_one_work+0x560/0x560
[49996.984679]  kthread+0x12c/0x150
[49996.987913]  ? __kthread_bind_mask+0x60/0x60
[49996.992193]  ret_from_fork+0x22/0x30
[49996.995805] task:kworker/5:91    state:D stack:    0 pid:236160 ppid:     2 flags:0x00004000
[49997.004258] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.009491] Call Trace:
[49997.011952]  __schedule+0x38b/0xc50
[49997.015444]  schedule+0x5b/0xc0
[49997.018591]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.023462]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.028411]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.032830]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.037509]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.042034]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.046983]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.052355]  ? lock_release+0x1cd/0x2a0
[49997.056211]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.061144]  iomap_dio_complete+0x45/0x130
[49997.065249]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.069958]  iomap_dio_complete_work+0x17/0x30
[49997.074410]  process_one_work+0x26e/0x560
[49997.078423]  worker_thread+0x52/0x3b0
[49997.082090]  ? process_one_work+0x560/0x560
[49997.086282]  kthread+0x12c/0x150
[49997.089515]  ? __kthread_bind_mask+0x60/0x60
[49997.093798]  ret_from_fork+0x22/0x30
[49997.097392] task:kworker/5:121   state:D stack:    0 pid:236171 ppid:     2 flags:0x00004000
[49997.105835] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.111059] Call Trace:
[49997.113513]  __schedule+0x38b/0xc50
[49997.117013]  schedule+0x5b/0xc0
[49997.120159]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.125034]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.129969]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.134391]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.139069]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.143577]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.148518]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.153890]  ? lock_release+0x1cd/0x2a0
[49997.157738]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.162670]  iomap_dio_complete+0x45/0x130
[49997.166776]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.171482]  iomap_dio_complete_work+0x17/0x30
[49997.175937]  process_one_work+0x26e/0x560
[49997.179951]  worker_thread+0x52/0x3b0
[49997.183622]  ? process_one_work+0x560/0x560
[49997.187827]  kthread+0x12c/0x150
[49997.191060]  ? __kthread_bind_mask+0x60/0x60
[49997.195341]  ret_from_fork+0x22/0x30
[49997.198951] task:kworker/13:42   state:D stack:    0 pid:238670 ppid:     2 flags:0x00004000
[49997.207386] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.212611] Call Trace:
[49997.215066]  __schedule+0x38b/0xc50
[49997.218565]  schedule+0x5b/0xc0
[49997.221711]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.226566]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.231522]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.235971]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.240664]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.245174]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.250138]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.255511]  ? lock_release+0x1cd/0x2a0
[49997.259358]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.264292]  iomap_dio_complete+0x45/0x130
[49997.268398]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.273114]  iomap_dio_complete_work+0x17/0x30
[49997.277566]  process_one_work+0x26e/0x560
[49997.281581]  worker_thread+0x52/0x3b0
[49997.285254]  ? process_one_work+0x560/0x560
[49997.289440]  kthread+0x12c/0x150
[49997.292682]  ? __kthread_bind_mask+0x60/0x60
[49997.296961]  ret_from_fork+0x22/0x30
[49997.300564] task:kworker/0:50    state:D stack:    0 pid:238736 ppid:     2 flags:0x00004000
[49997.308999] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.314226] Call Trace:
[49997.316679]  __schedule+0x38b/0xc50
[49997.320179]  schedule+0x5b/0xc0
[49997.323324]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.328179]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.333137]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.337555]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.342234]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.346760]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.346819]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.357027]  ? lock_release+0x1cd/0x2a0
[49997.360868]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.365816]  iomap_dio_complete+0x45/0x130
[49997.369917]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.374639]  iomap_dio_complete_work+0x17/0x30
[49997.379111]  process_one_work+0x26e/0x560
[49997.383123]  worker_thread+0x52/0x3b0
[49997.386788]  ? process_one_work+0x560/0x560
[49997.390976]  kthread+0x12c/0x150
[49997.394216]  ? __kthread_bind_mask+0x60/0x60
[49997.398487]  ret_from_fork+0x22/0x30
[49997.402072] task:kworker/0:80    state:D stack:    0 pid:238737 ppid:     2 flags:0x00004000
[49997.410508] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.415741] Call Trace:
[49997.418205]  __schedule+0x38b/0xc50
[49997.421707]  schedule+0x5b/0xc0
[49997.424861]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.429729]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.434671]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.439091]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.443770]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.448276]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.453226]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.458598]  ? lock_release+0x1cd/0x2a0
[49997.462464]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.467394]  iomap_dio_complete+0x45/0x130
[49997.471503]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.476216]  iomap_dio_complete_work+0x17/0x30
[49997.480662]  process_one_work+0x26e/0x560
[49997.484677]  worker_thread+0x52/0x3b0
[49997.488350]  ? process_one_work+0x560/0x560
[49997.492545]  kthread+0x12c/0x150
[49997.495784]  ? __kthread_bind_mask+0x60/0x60
[49997.500067]  ret_from_fork+0x22/0x30
[49997.503664] task:kworker/17:75   state:D stack:    0 pid:240948 ppid:     2 flags:0x00004000
[49997.512122] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.517355] Call Trace:
[49997.519809]  __schedule+0x38b/0xc50
[49997.523320]  schedule+0x5b/0xc0
[49997.526472]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.531326]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.536265]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.540703]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.545383]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.549891]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.554848]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.560229]  ? lock_release+0x1cd/0x2a0
[49997.564078]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.569015]  iomap_dio_complete+0x45/0x130
[49997.573116]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.577830]  iomap_dio_complete_work+0x17/0x30
[49997.582274]  process_one_work+0x26e/0x560
[49997.586291]  worker_thread+0x52/0x3b0
[49997.589964]  ? process_one_work+0x560/0x560
[49997.594157]  kthread+0x12c/0x150
[49997.597416]  ? __kthread_bind_mask+0x60/0x60
[49997.601697]  ret_from_fork+0x22/0x30
[49997.605286] task:kworker/13:75   state:D stack:    0 pid:241028 ppid:     2 flags:0x00004000
[49997.613727] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.618977] Call Trace:
[49997.621430]  __schedule+0x38b/0xc50
[49997.624925]  schedule+0x5b/0xc0
[49997.628077]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.632931]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.637872]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.642292]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.646970]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.651478]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.656426]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.661799]  ? lock_release+0x1cd/0x2a0
[49997.665645]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.670577]  iomap_dio_complete+0x45/0x130
[49997.674684]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.679390]  iomap_dio_complete_work+0x17/0x30
[49997.683835]  process_one_work+0x26e/0x560
[49997.687850]  worker_thread+0x52/0x3b0
[49997.691522]  ? process_one_work+0x560/0x560
[49997.695711]  kthread+0x12c/0x150
[49997.698952]  ? __kthread_bind_mask+0x60/0x60
[49997.703231]  ret_from_fork+0x22/0x30
[49997.706816] task:kworker/13:76   state:D stack:    0 pid:241029 ppid:     2 flags:0x00004000
[49997.715262] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.720495] Call Trace:
[49997.722948]  __schedule+0x38b/0xc50
[49997.726449]  schedule+0x5b/0xc0
[49997.729595]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.734447]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.739413]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.743835]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.748514]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.753022]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.757995]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.763369]  ? lock_release+0x1cd/0x2a0
[49997.767217]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.772155]  iomap_dio_complete+0x45/0x130
[49997.776254]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.780960]  iomap_dio_complete_work+0x17/0x30
[49997.785406]  process_one_work+0x26e/0x560
[49997.789419]  worker_thread+0x52/0x3b0
[49997.793084]  ? process_one_work+0x560/0x560
[49997.797269]  kthread+0x12c/0x150
[49997.800511]  ? __kthread_bind_mask+0x60/0x60
[49997.804793]  ret_from_fork+0x22/0x30
[49997.808394] task:kworker/13:100  state:D stack:    0 pid:241043 ppid:     2 flags:0x00004000
[49997.816830] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.822056] Call Trace:
[49997.824510]  __schedule+0x38b/0xc50
[49997.828011]  schedule+0x5b/0xc0
[49997.831162]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.836018]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.840966]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.845387]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.850067]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.854589]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.859538]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.864902]  ? lock_release+0x1cd/0x2a0
[49997.868741]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.873680]  iomap_dio_complete+0x45/0x130
[49997.877781]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.882506]  iomap_dio_complete_work+0x17/0x30
[49997.886957]  process_one_work+0x26e/0x560
[49997.890971]  worker_thread+0x52/0x3b0
[49997.894636]  ? process_one_work+0x560/0x560
[49997.898831]  kthread+0x12c/0x150
[49997.902064]  ? __kthread_bind_mask+0x60/0x60
[49997.906346]  ret_from_fork+0x22/0x30
[49997.909940] task:kworker/13:103  state:D stack:    0 pid:241046 ppid:     2 flags:0x00004000
[49997.918389] Workqueue: dio/dm-5 iomap_dio_complete_work
[49997.923616] Call Trace:
[49997.926070]  __schedule+0x38b/0xc50
[49997.929564]  schedule+0x5b/0xc0
[49997.932724]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49997.937578]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49997.942527]  xfs_log_reserve+0xf6/0x310 [xfs]
[49997.946948]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49997.951628]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49997.956135]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49997.961073]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49997.966447]  ? lock_release+0x1cd/0x2a0
[49997.970294]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49997.975226]  iomap_dio_complete+0x45/0x130
[49997.979333]  ? aio_poll_complete_work+0x1b0/0x1b0
[49997.984049]  iomap_dio_complete_work+0x17/0x30
[49997.988501]  process_one_work+0x26e/0x560
[49997.992514]  worker_thread+0x52/0x3b0
[49997.996181]  ? process_one_work+0x560/0x560
[49998.000366]  kthread+0x12c/0x150
[49998.003606]  ? __kthread_bind_mask+0x60/0x60
[49998.007880]  ret_from_fork+0x22/0x30
[49998.011472] task:kworker/13:104  state:D stack:    0 pid:241047 ppid:     2 flags:0x00004000
[49998.019908] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.025134] Call Trace:
[49998.027587]  __schedule+0x38b/0xc50
[49998.031089]  schedule+0x5b/0xc0
[49998.034243]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.039097]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.044038]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.048455]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.053135]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.057642]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.062583]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.067954]  ? lock_release+0x1cd/0x2a0
[49998.071793]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.076727]  iomap_dio_complete+0x45/0x130
[49998.080833]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.085539]  iomap_dio_complete_work+0x17/0x30
[49998.089984]  process_one_work+0x26e/0x560
[49998.093999]  worker_thread+0x52/0x3b0
[49998.097671]  ? process_one_work+0x560/0x560
[49998.101861]  kthread+0x12c/0x150
[49998.105098]  ? __kthread_bind_mask+0x60/0x60
[49998.109371]  ret_from_fork+0x22/0x30
[49998.112979] task:kworker/15:78   state:D stack:    0 pid:243659 ppid:     2 flags:0x00004000
[49998.121418] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.126653] Call Trace:
[49998.129106]  __schedule+0x38b/0xc50
[49998.132607]  schedule+0x5b/0xc0
[49998.135759]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.140620]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.145561]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.149983]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.154660]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.159170]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.164108]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.169484]  ? lock_release+0x1cd/0x2a0
[49998.173330]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.178271]  iomap_dio_complete+0x45/0x130
[49998.182377]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.187091]  iomap_dio_complete_work+0x17/0x30
[49998.191537]  process_one_work+0x26e/0x560
[49998.195551]  worker_thread+0x52/0x3b0
[49998.199224]  ? process_one_work+0x560/0x560
[49998.203409]  kthread+0x12c/0x150
[49998.206643]  ? __kthread_bind_mask+0x60/0x60
[49998.210926]  ret_from_fork+0x22/0x30
[49998.214528] task:kworker/13:155  state:D stack:    0 pid:246216 ppid:     2 flags:0x00004000
[49998.222960] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.228187] Call Trace:
[49998.230641]  __schedule+0x38b/0xc50
[49998.234141]  schedule+0x5b/0xc0
[49998.237287]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.242157]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.247096]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.251516]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.256196]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.260705]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.265643]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.271016]  ? lock_release+0x1cd/0x2a0
[49998.274856]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.279796]  iomap_dio_complete+0x45/0x130
[49998.283902]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.288610]  iomap_dio_complete_work+0x17/0x30
[49998.293064]  process_one_work+0x26e/0x560
[49998.297087]  worker_thread+0x52/0x3b0
[49998.300759]  ? process_one_work+0x560/0x560
[49998.304944]  kthread+0x12c/0x150
[49998.308179]  ? __kthread_bind_mask+0x60/0x60
[49998.312459]  ret_from_fork+0x22/0x30
[49998.316055] task:kworker/17:80   state:D stack:    0 pid:248320 ppid:     2 flags:0x00004000
[49998.324499] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.329731] Call Trace:
[49998.332185]  __schedule+0x38b/0xc50
[49998.335685]  schedule+0x5b/0xc0
[49998.338830]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.343682]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.348624]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.353042]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.357723]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.362230]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.367170]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.372543]  ? lock_release+0x1cd/0x2a0
[49998.376390]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.381321]  iomap_dio_complete+0x45/0x130
[49998.385421]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.390137]  iomap_dio_complete_work+0x17/0x30
[49998.394590]  process_one_work+0x26e/0x560
[49998.398602]  worker_thread+0x52/0x3b0
[49998.402269]  ? process_one_work+0x560/0x560
[49998.406463]  kthread+0x12c/0x150
[49998.409703]  ? __kthread_bind_mask+0x60/0x60
[49998.413977]  ret_from_fork+0x22/0x30
[49998.417570] task:kworker/13:164  state:D stack:    0 pid:248334 ppid:     2 flags:0x00004000
[49998.426005] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.431232] Call Trace:
[49998.433684]  __schedule+0x38b/0xc50
[49998.437176]  schedule+0x5b/0xc0
[49998.440321]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.445176]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.450116]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.454535]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.459215]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.463720]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.468661]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.474035]  ? lock_release+0x1cd/0x2a0
[49998.477883]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.482824]  iomap_dio_complete+0x45/0x130
[49998.486929]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.491636]  iomap_dio_complete_work+0x17/0x30
[49998.496091]  process_one_work+0x26e/0x560
[49998.500113]  worker_thread+0x52/0x3b0
[49998.503785]  ? process_one_work+0x560/0x560
[49998.507972]  kthread+0x12c/0x150
[49998.511212]  ? __kthread_bind_mask+0x60/0x60
[49998.515486]  ret_from_fork+0x22/0x30
[49998.519086] task:kworker/3:98    state:D stack:    0 pid:250612 ppid:     2 flags:0x00004000
[49998.527522] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.532748] Call Trace:
[49998.535203]  __schedule+0x38b/0xc50
[49998.538704]  schedule+0x5b/0xc0
[49998.541858]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.546710]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.551649]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.556070]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.560749]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.565256]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.570196]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.575569]  ? lock_release+0x1cd/0x2a0
[49998.579409]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.584349]  iomap_dio_complete+0x45/0x130
[49998.588455]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.593160]  iomap_dio_complete_work+0x17/0x30
[49998.597610]  process_one_work+0x26e/0x560
[49998.601631]  worker_thread+0x52/0x3b0
[49998.605304]  ? process_one_work+0x560/0x560
[49998.609498]  kthread+0x12c/0x150
[49998.612738]  ? __kthread_bind_mask+0x60/0x60
[49998.617012]  ret_from_fork+0x22/0x30
[49998.620606] task:kworker/7:91    state:D stack:    0 pid:250623 ppid:     2 flags:0x00004000
[49998.629042] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.634275] Call Trace:
[49998.636729]  __schedule+0x38b/0xc50
[49998.640229]  schedule+0x5b/0xc0
[49998.643384]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.648238]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.653176]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.657597]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.662275]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.666783]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.671721]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.677093]  ? lock_release+0x1cd/0x2a0
[49998.680935]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.685876]  iomap_dio_complete+0x45/0x130
[49998.689982]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.694688]  iomap_dio_complete_work+0x17/0x30
[49998.699133]  process_one_work+0x26e/0x560
[49998.703148]  worker_thread+0x52/0x3b0
[49998.706820]  ? process_one_work+0x560/0x560
[49998.711005]  kthread+0x12c/0x150
[49998.714239]  ? __kthread_bind_mask+0x60/0x60
[49998.718513]  ret_from_fork+0x22/0x30
[49998.722134] task:kworker/39:104  state:D stack:    0 pid:256748 ppid:     2 flags:0x00004000
[49998.730567] Workqueue: xfs-sync/dm-5 xfs_log_worker [xfs]
[49998.736027] Call Trace:
[49998.738478]  __schedule+0x38b/0xc50
[49998.741973]  schedule+0x5b/0xc0
[49998.745127]  schedule_timeout+0x15e/0x1d0
[49998.749148]  ? __mutex_lock+0x6b/0x740
[49998.752910]  ? flush_workqueue+0xb6/0x590
[49998.756930]  ? flush_workqueue+0xb6/0x590
[49998.760950]  ? lock_release+0x1cd/0x2a0
[49998.764790]  ? trace_hardirqs_on+0x1b/0xd0
[49998.768899]  wait_for_completion+0x79/0xc0
[49998.773006]  flush_workqueue+0x1b0/0x590
[49998.776932]  ? verify_cpu+0xf0/0x100
[49998.780521]  xlog_cil_push_now+0xc4/0x100 [xfs]
[49998.785113]  xlog_cil_force_seq+0x86/0x2b0 [xfs]
[49998.789792]  ? lock_release+0x1cd/0x2a0
[49998.793632]  xfs_log_force+0x91/0x230 [xfs]
[49998.797878]  xfs_log_worker+0x35/0x80 [xfs]
[49998.802125]  process_one_work+0x26e/0x560
[49998.806148]  worker_thread+0x52/0x3b0
[49998.809819]  ? process_one_work+0x560/0x560
[49998.814008]  kthread+0x12c/0x150
[49998.817248]  ? __kthread_bind_mask+0x60/0x60
[49998.821528]  ret_from_fork+0x22/0x30
[49998.825136] task:kworker/7:122   state:D stack:    0 pid:261263 ppid:     2 flags:0x00004000
[49998.833575] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.838799] Call Trace:
[49998.841254]  __schedule+0x38b/0xc50
[49998.844755]  schedule+0x5b/0xc0
[49998.847901]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.852754]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.857693]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.862112]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.866794]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.871300]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.876239]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.881615]  ? lock_release+0x1cd/0x2a0
[49998.885462]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.890401]  iomap_dio_complete+0x45/0x130
[49998.894508]  ? aio_poll_complete_work+0x1b0/0x1b0
[49998.899221]  iomap_dio_complete_work+0x17/0x30
[49998.903667]  process_one_work+0x26e/0x560
[49998.907680]  worker_thread+0x52/0x3b0
[49998.911347]  ? process_one_work+0x560/0x560
[49998.915531]  kthread+0x12c/0x150
[49998.918764]  ? __kthread_bind_mask+0x60/0x60
[49998.923037]  ret_from_fork+0x22/0x30
[49998.926623] task:kworker/7:165   state:D stack:    0 pid:261283 ppid:     2 flags:0x00004000
[49998.935059] Workqueue: dio/dm-5 iomap_dio_complete_work
[49998.940293] Call Trace:
[49998.942746]  __schedule+0x38b/0xc50
[49998.946248]  schedule+0x5b/0xc0
[49998.949402]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49998.954252]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49998.959194]  xfs_log_reserve+0xf6/0x310 [xfs]
[49998.963614]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49998.968294]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49998.972801]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49998.977739]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49998.983110]  ? lock_release+0x1cd/0x2a0
[49998.986953]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49998.991892]  iomap_dio_complete+0x45/0x130
[49998.995991]  ? aio_poll_complete_work+0x1b0/0x1b0
[49999.000704]  iomap_dio_complete_work+0x17/0x30
[49999.005152]  process_one_work+0x26e/0x560
[49999.009174]  worker_thread+0x52/0x3b0
[49999.012848]  ? process_one_work+0x560/0x560
[49999.017042]  kthread+0x12c/0x150
[49999.020282]  ? __kthread_bind_mask+0x60/0x60
[49999.024556]  ret_from_fork+0x22/0x30
[49999.028147] task:kworker/7:168   state:D stack:    0 pid:261286 ppid:     2 flags:0x00004000
[49999.036585] Workqueue: dio/dm-5 iomap_dio_complete_work
[49999.041818] Call Trace:
[49999.044273]  __schedule+0x38b/0xc50
[49999.047773]  schedule+0x5b/0xc0
[49999.050926]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.055779]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.060720]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.065139]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.069821]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.074327]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49999.079267]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49999.084638]  ? lock_release+0x1cd/0x2a0
[49999.088478]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49999.093409]  iomap_dio_complete+0x45/0x130
[49999.097509]  ? aio_poll_complete_work+0x1b0/0x1b0
[49999.102225]  iomap_dio_complete_work+0x17/0x30
[49999.106677]  process_one_work+0x26e/0x560
[49999.110691]  worker_thread+0x52/0x3b0
[49999.114364]  ? process_one_work+0x560/0x560
[49999.118551]  kthread+0x12c/0x150
[49999.121790]  ? __kthread_bind_mask+0x60/0x60
[49999.126064]  ret_from_fork+0x22/0x30
[49999.129659] task:kworker/7:179   state:D stack:    0 pid:263472 ppid:     2 flags:0x00004000
[49999.138095] Workqueue: dio/dm-5 iomap_dio_complete_work
[49999.143326] Call Trace:
[49999.145781]  __schedule+0x38b/0xc50
[49999.149281]  schedule+0x5b/0xc0
[49999.152426]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.157280]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.162219]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.166640]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.171320]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.175826]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49999.180767]  xfs_iomap_write_unwritten+0x129/0x330 [xfs]
[49999.186139]  ? lock_release+0x1cd/0x2a0
[49999.189979]  xfs_dio_write_end_io+0x203/0x250 [xfs]
[49999.194919]  iomap_dio_complete+0x45/0x130
[49999.199025]  ? aio_poll_complete_work+0x1b0/0x1b0
[49999.203734]  iomap_dio_complete_work+0x17/0x30
[49999.208184]  process_one_work+0x26e/0x560
[49999.212199]  worker_thread+0x52/0x3b0
[49999.215866]  ? process_one_work+0x560/0x560
[49999.220060]  kthread+0x12c/0x150
[49999.223301]  ? __kthread_bind_mask+0x60/0x60
[49999.227582]  ret_from_fork+0x22/0x30
[49999.231223] task:xfsaild/dm-5    state:D stack:    0 pid:267879 ppid:     2 flags:0x00004000
[49999.239662] Call Trace:
[49999.242116]  __schedule+0x38b/0xc50
[49999.245615]  ? list_sort+0x1f7/0x270
[49999.249203]  schedule+0x5b/0xc0
[49999.252351]  schedule_timeout+0xb6/0x1d0
[49999.256285]  ? xfs_buf_delwri_submit_buffers+0x253/0x290 [xfs]
[49999.262169]  ? __bpf_trace_tick_stop+0x10/0x10
[49999.266626]  xfsaild+0x55f/0xbe0 [xfs]
[49999.270448]  ? lock_release+0x1cd/0x2a0
[49999.274293]  ? _raw_spin_unlock_irqrestore+0x37/0x40
[49999.279260]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[49999.284719]  kthread+0x12c/0x150
[49999.287959]  ? __kthread_bind_mask+0x60/0x60
[49999.292233]  ret_from_fork+0x22/0x30
[49999.295829] task:fsstress        state:D stack:    0 pid:267885 ppid:267881 flags:0x00004000
[49999.304262] Call Trace:
[49999.306716]  __schedule+0x38b/0xc50
[49999.310215]  schedule+0x5b/0xc0
[49999.313360]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.318215]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.323155]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.327572]  ? lock_release+0x1cd/0x2a0
[49999.331414]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.336095]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.340600]  xfs_setattr_size+0x1a2/0x540 [xfs]
[49999.345193]  xfs_ioc_space+0x1b9/0x260 [xfs]
[49999.349529]  xfs_file_ioctl+0x2d7/0xde0 [xfs]
[49999.353947]  ? _copy_to_user+0x42/0x50
[49999.357708]  ? cp_new_stat+0x147/0x160
[49999.361470]  ? selinux_file_ioctl+0x12f/0x1d0
[49999.365836]  __x64_sys_ioctl+0x83/0xb0
[49999.369596]  do_syscall_64+0x40/0x80
[49999.373186]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[49999.378247] RIP: 0033:0x7f41c7ae3f7b
[49999.381835] RSP: 002b:00007ffe369d4768 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[49999.389408] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f41c7ae3f7b
[49999.396540] RDX: 00007ffe369d4790 RSI: 0000000040305824 RDI: 0000000000000003
[49999.403672] RBP: 0000000000000003 R08: 0000000000000038 R09: 00007ffe369d477c
[49999.410804] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000001c2c
[49999.417937] R13: 0000000000069b8d R14: 0000000000000000 R15: 0000000000000000
[49999.425079] task:fio             state:D stack:    0 pid:267969 ppid:     1 flags:0x00000000
[49999.433511] Call Trace:
[49999.435964]  __schedule+0x38b/0xc50
[49999.439465]  schedule+0x5b/0xc0
[49999.442610]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.447463]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.452404]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.456824]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.461505]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.466013]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49999.470950]  ? xfs_bmapi_read+0x14d/0x360 [xfs]
[49999.475525]  xfs_iomap_write_direct+0xbe/0x230 [xfs]
[49999.480552]  xfs_direct_write_iomap_begin+0x460/0x720 [xfs]
[49999.486189]  iomap_apply+0x8b/0x400
[49999.489688]  __iomap_dio_rw+0x1cc/0x560
[49999.493537]  ? iomap_dio_rw+0x30/0x30
[49999.497210]  iomap_dio_rw+0xa/0x30
[49999.500624]  xfs_file_dio_write_aligned+0x9d/0x190 [xfs]
[49999.505998]  ? lock_release+0x1cd/0x2a0
[49999.509844]  xfs_file_write_iter+0xd2/0x120 [xfs]
[49999.514602]  aio_write+0xe7/0x250
[49999.517924]  ? lock_release+0x1cd/0x2a0
[49999.521769]  ? lock_release+0x1cd/0x2a0
[49999.525610]  ? __fget_files+0xef/0x1a0
[49999.529370]  io_submit_one+0x4bc/0x880
[49999.533131]  ? trace_hardirqs_on+0x1b/0xd0
[49999.537238]  ? lock_acquire+0x15d/0x380
[49999.541078]  ? lock_acquire+0x15d/0x380
[49999.544919]  __x64_sys_io_submit+0x73/0x140
[49999.549113]  ? __x64_sys_io_getevents+0x49/0xb0
[49999.553653]  do_syscall_64+0x40/0x80
[49999.557232]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[49999.562286] RIP: 0033:0x7f83c1c17edd
[49999.565873] RSP: 002b:00007fffd4d32b88 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[49999.573445] RAX: ffffffffffffffda RBX: 00007f83b7efde88 RCX: 00007f83c1c17edd
[49999.580579] RDX: 0000562e788c6b58 RSI: 0000000000000001 RDI: 00007f83b7e8f000
[49999.587713] RBP: 00007f83b7e8f000 R08: 0000000000000000 R09: 0000000000000318
[49999.594845] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
[49999.601977] R13: 0000000000000000 R14: 0000562e788c6b58 R15: 0000562e788c87f0
[49999.609115] task:fio             state:D stack:    0 pid:267970 ppid:     1 flags:0x00000000
[49999.617550] Call Trace:
[49999.620004]  __schedule+0x38b/0xc50
[49999.623505]  schedule+0x5b/0xc0
[49999.626656]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.631508]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.636450]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.640871]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.645551]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.650059]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49999.654995]  ? xfs_bmapi_read+0x14d/0x360 [xfs]
[49999.659574]  xfs_iomap_write_direct+0xbe/0x230 [xfs]
[49999.664601]  xfs_direct_write_iomap_begin+0x460/0x720 [xfs]
[49999.670236]  iomap_apply+0x8b/0x400
[49999.673734]  __iomap_dio_rw+0x1cc/0x560
[49999.677582]  ? iomap_dio_rw+0x30/0x30
[49999.681257]  iomap_dio_rw+0xa/0x30
[49999.684672]  xfs_file_dio_write_aligned+0x9d/0x190 [xfs]
[49999.690041]  ? lock_release+0x1cd/0x2a0
[49999.693882]  xfs_file_write_iter+0xd2/0x120 [xfs]
[49999.698639]  aio_write+0xe7/0x250
[49999.701962]  ? lock_release+0x1cd/0x2a0
[49999.705807]  ? lock_release+0x1cd/0x2a0
[49999.709648]  ? __fget_files+0xef/0x1a0
[49999.713400]  io_submit_one+0x4bc/0x880
[49999.717161]  ? trace_hardirqs_on+0x1b/0xd0
[49999.721268]  ? lock_acquire+0x15d/0x380
[49999.725108]  ? lock_acquire+0x15d/0x380
[49999.728958]  __x64_sys_io_submit+0x73/0x140
[49999.733149]  ? __x64_sys_io_getevents+0x49/0xb0
[49999.737683]  do_syscall_64+0x40/0x80
[49999.741262]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[49999.746313] RIP: 0033:0x7f83c1c17edd
[49999.749892] RSP: 002b:00007fffd4d32b88 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[49999.757458] RAX: ffffffffffffffda RBX: 00007f83b7efde88 RCX: 00007f83c1c17edd
[49999.764591] RDX: 0000562e788c6b08 RSI: 0000000000000001 RDI: 00007f83b7e8e000
[49999.771722] RBP: 00007f83b7e8e000 R08: 0000000000000000 R09: 00000000000002c8
[49999.778855] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
[49999.785987] R13: 0000000000000000 R14: 0000562e788c6b08 R15: 0000562e788c87f0
[49999.793126] task:fio             state:D stack:    0 pid:267971 ppid:     1 flags:0x00004000
[49999.801561] Call Trace:
[49999.804015]  __schedule+0x38b/0xc50
[49999.807508]  schedule+0x5b/0xc0
[49999.810663]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.815522]  xlog_grant_head_check+0xd6/0x130 [xfs]
[49999.820464]  xfs_log_reserve+0xf6/0x310 [xfs]
[49999.824884]  xfs_trans_reserve+0x17f/0x250 [xfs]
[49999.829562]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[49999.834071]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[49999.839010]  ? xfs_bmapi_read+0x14d/0x360 [xfs]
[49999.843584]  xfs_iomap_write_direct+0xbe/0x230 [xfs]
[49999.848603]  xfs_direct_write_iomap_begin+0x460/0x720 [xfs]
[49999.854239]  ? trace_hardirqs_on+0x1b/0xd0
[49999.858345]  iomap_apply+0x8b/0x400
[49999.861838]  __iomap_dio_rw+0x1cc/0x560
[49999.865684]  ? iomap_dio_rw+0x30/0x30
[49999.869352]  iomap_dio_rw+0xa/0x30
[49999.872766]  xfs_file_dio_write_aligned+0x9d/0x190 [xfs]
[49999.878139]  ? lock_release+0x1cd/0x2a0
[49999.881987]  xfs_file_write_iter+0xd2/0x120 [xfs]
[49999.886752]  aio_write+0xe7/0x250
[49999.890071]  ? lock_release+0x1cd/0x2a0
[49999.893910]  ? lock_release+0x1cd/0x2a0
[49999.897750]  ? __fget_files+0xef/0x1a0
[49999.901505]  io_submit_one+0x4bc/0x880
[49999.905263]  ? lock_acquire+0x15d/0x380
[49999.909103]  ? lock_acquire+0x15d/0x380
[49999.912943]  __x64_sys_io_submit+0x73/0x140
[49999.917138]  ? __x64_sys_io_getevents+0x49/0xb0
[49999.921678]  do_syscall_64+0x40/0x80
[49999.925256]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[49999.930310] RIP: 0033:0x7f83c1c17edd
[49999.933888] RSP: 002b:00007fffd4d32b88 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[49999.941455] RAX: ffffffffffffffda RBX: 00007f83b7efde88 RCX: 00007f83c1c17edd
[49999.948587] RDX: 0000562e788c6920 RSI: 0000000000000001 RDI: 00007f83b7e8d000
[49999.955718] RBP: 00007f83b7e8d000 R08: 0000000000000000 R09: 00000000000000e0
[49999.962853] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
[49999.969984] R13: 0000000000000000 R14: 0000562e788c6920 R15: 0000562e788c87f0
[49999.977121] task:fio             state:D stack:    0 pid:267972 ppid:     1 flags:0x00000000
[49999.985558] Call Trace:
[49999.988013]  __schedule+0x38b/0xc50
[49999.991510]  schedule+0x5b/0xc0
[49999.994658]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[49999.999517]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.004457]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.008878]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.013560]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.018067]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
[50000.023006]  ? xfs_bmapi_read+0x14d/0x360 [xfs]
[50000.027581]  xfs_iomap_write_direct+0xbe/0x230 [xfs]
[50000.032607]  xfs_direct_write_iomap_begin+0x460/0x720 [xfs]
[50000.038243]  iomap_apply+0x8b/0x400
[50000.041745]  __iomap_dio_rw+0x1cc/0x560
[50000.045590]  ? iomap_dio_rw+0x30/0x30
[50000.049258]  iomap_dio_rw+0xa/0x30
[50000.052670]  xfs_file_dio_write_aligned+0x9d/0x190 [xfs]
[50000.058042]  ? lock_release+0x1cd/0x2a0
[50000.061881]  xfs_file_write_iter+0xd2/0x120 [xfs]
[50000.066639]  aio_write+0xe7/0x250
[50000.069961]  ? lock_release+0x1cd/0x2a0
[50000.073806]  ? lock_release+0x1cd/0x2a0
[50000.077646]  ? __fget_files+0xef/0x1a0
[50000.081401]  io_submit_one+0x4bc/0x880
[50000.085159]  ? lock_acquire+0x15d/0x380
[50000.088998]  ? lock_acquire+0x15d/0x380
[50000.092839]  __x64_sys_io_submit+0x73/0x140
[50000.097033]  ? __x64_sys_io_getevents+0x49/0xb0
[50000.101566]  do_syscall_64+0x40/0x80
[50000.105154]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[50000.110214] RIP: 0033:0x7f83c1c17edd
[50000.113794] RSP: 002b:00007fffd4d32b88 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[50000.121366] RAX: ffffffffffffffda RBX: 00007f83b7efde88 RCX: 00007f83c1c17edd
[50000.128499] RDX: 0000562e788c6b50 RSI: 0000000000000001 RDI: 00007f83b7e8c000
[50000.135633] RBP: 00007f83b7e8c000 R08: 0000000000000000 R09: 0000000000000310
[50000.142764] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000001
[50000.149899] R13: 0000000000000000 R14: 0000562e788c6b50 R15: 0000562e788c87f0
[50000.157035] task:fio             state:D stack:    0 pid:267973 ppid:     1 flags:0x00000000
[50000.165471] Call Trace:
[50000.167925]  __schedule+0x38b/0xc50
[50000.171424]  schedule+0x5b/0xc0
[50000.174570]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[50000.179426]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.184364]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.188783]  ? lock_release+0x1cd/0x2a0
[50000.192623]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.197303]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.201811]  xfs_vn_update_time+0xba/0x240 [xfs]
[50000.206489]  file_update_time+0xc6/0x120
[50000.210425]  __xfs_filemap_fault+0x189/0x380 [xfs]
[50000.215277]  ? lock_acquire+0x15d/0x380
[50000.219116]  do_page_mkwrite+0x4f/0xf0
[50000.222878]  do_wp_page+0x261/0x380
[50000.226378]  __handle_mm_fault+0xe30/0x14f0
[50000.230575]  handle_mm_fault+0x97/0x260
[50000.234420]  do_user_addr_fault+0x1d7/0x6a0
[50000.238616]  exc_page_fault+0x7f/0x270
[50000.242378]  ? asm_exc_page_fault+0x8/0x30
[50000.246483]  asm_exc_page_fault+0x1e/0x30
[50000.250495] RIP: 0033:0x7f83c1c80f96
[50000.254076] RSP: 002b:00007fffd4d32c18 EFLAGS: 00010292
[50000.259302] RAX: 00007f836afb5000 RBX: 0000562e78894c40 RCX: 0000000000001000
[50000.266433] RDX: 0000000000001000 RSI: 0000562e788c5830 RDI: 00007f836afb5000
[50000.273565] RBP: 00007f836b2008a0 R08: 0000000000000000 R09: 0000562e788c6830
[50000.280700] R10: 0000562e788ab088 R11: 00007fffd4d32b60 R12: 0000000000000000
[50000.287839] R13: 0000000000000001 R14: 0000000000001000 R15: 0000562e78894c68
[50000.294976] task:fio             state:D stack:    0 pid:267974 ppid:     1 flags:0x00000000
[50000.303414] Call Trace:
[50000.305866]  __schedule+0x38b/0xc50
[50000.309360]  schedule+0x5b/0xc0
[50000.312511]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[50000.317367]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.322305]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.326725]  ? lock_release+0x1cd/0x2a0
[50000.330565]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.335245]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.339753]  xfs_vn_update_time+0xba/0x240 [xfs]
[50000.344431]  file_update_time+0xc6/0x120
[50000.348359]  __xfs_filemap_fault+0x189/0x380 [xfs]
[50000.353210]  ? lock_acquire+0x15d/0x380
[50000.357049]  do_page_mkwrite+0x4f/0xf0
[50000.360801]  do_wp_page+0x261/0x380
[50000.364295]  __handle_mm_fault+0xe30/0x14f0
[50000.368488]  ? lock_release+0x1cd/0x2a0
[50000.372330]  handle_mm_fault+0x97/0x260
[50000.376177]  do_user_addr_fault+0x1d7/0x6a0
[50000.380370]  exc_page_fault+0x7f/0x270
[50000.384122]  ? asm_exc_page_fault+0x8/0x30
[50000.388221]  asm_exc_page_fault+0x1e/0x30
[50000.392234] RIP: 0033:0x7f83c1c80f96
[50000.395814] RSP: 002b:00007fffd4d32c18 EFLAGS: 00010292
[50000.401041] RAX: 00007f836aec9000 RBX: 0000562e78894c40 RCX: 0000000000001000
[50000.408179] RDX: 0000000000001000 RSI: 0000562e788c5830 RDI: 00007f836aec9000
[50000.415313] RBP: 00007f836b2452c8 R08: 0000000000000000 R09: 0000562e788c6830
[50000.422445] R10: 0000562e788ab068 R11: 00007fffd4d32b60 R12: 0000000000000000
[50000.429577] R13: 0000000000000001 R14: 0000000000001000 R15: 0000562e78894c68
[50000.436717] task:fio             state:D stack:    0 pid:267975 ppid:     1 flags:0x00000000
[50000.445152] Call Trace:
[50000.447606]  __schedule+0x38b/0xc50
[50000.451107]  schedule+0x5b/0xc0
[50000.454259]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[50000.459114]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.464053]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.468474]  ? lock_release+0x1cd/0x2a0
[50000.472320]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.477001]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.481507]  xfs_vn_update_time+0xba/0x240 [xfs]
[50000.486188]  file_update_time+0xc6/0x120
[50000.490123]  __xfs_filemap_fault+0x189/0x380 [xfs]
[50000.494974]  ? lock_acquire+0x15d/0x380
[50000.498814]  do_page_mkwrite+0x4f/0xf0
[50000.502576]  do_wp_page+0x261/0x380
[50000.506077]  __handle_mm_fault+0xe30/0x14f0
[50000.510272]  handle_mm_fault+0x97/0x260
[50000.514118]  do_user_addr_fault+0x1d7/0x6a0
[50000.518304]  exc_page_fault+0x7f/0x270
[50000.522066]  ? asm_exc_page_fault+0x8/0x30
[50000.526164]  asm_exc_page_fault+0x1e/0x30
[50000.530175] RIP: 0033:0x7f83c1c80f96
[50000.533757] RSP: 002b:00007fffd4d32c18 EFLAGS: 00010292
[50000.538980] RAX: 00007f836a93f000 RBX: 0000562e78894c40 RCX: 0000000000001000
[50000.546115] RDX: 0000000000001000 RSI: 0000562e788c5830 RDI: 00007f836a93f000
[50000.553247] RBP: 00007f836b289cf0 R08: 0000000000000000 R09: 0000562e788c6830
[50000.560380] R10: 0000562e788aafb8 R11: 00007fffd4d32b60 R12: 0000000000000000
[50000.567512] R13: 0000000000000001 R14: 0000000000001000 R15: 0000562e78894c68
[50000.574650] task:fio             state:D stack:    0 pid:267976 ppid:     1 flags:0x00000000
[50000.583084] Call Trace:
[50000.585539]  __schedule+0x38b/0xc50
[50000.589040]  schedule+0x5b/0xc0
[50000.592192]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[50000.597047]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.601986]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.606407]  ? lock_release+0x1cd/0x2a0
[50000.610253]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.614934]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.619440]  xfs_vn_update_time+0xba/0x240 [xfs]
[50000.624121]  file_update_time+0xc6/0x120
[50000.628055]  __xfs_filemap_fault+0x189/0x380 [xfs]
[50000.632899]  ? lock_acquire+0x15d/0x380
[50000.636740]  do_page_mkwrite+0x4f/0xf0
[50000.640500]  do_wp_page+0x261/0x380
[50000.643993]  __handle_mm_fault+0xe30/0x14f0
[50000.648186]  ? lock_release+0x1cd/0x2a0
[50000.652027]  handle_mm_fault+0x97/0x260
[50000.655873]  do_user_addr_fault+0x1d7/0x6a0
[50000.660059]  exc_page_fault+0x7f/0x270
[50000.663811]  ? asm_exc_page_fault+0x8/0x30
[50000.667910]  asm_exc_page_fault+0x1e/0x30
[50000.671925] RIP: 0033:0x7f83c1c80f96
[50000.675502] RSP: 002b:00007fffd4d32c18 EFLAGS: 00010292
[50000.680729] RAX: 00007f836a8fa000 RBX: 0000562e78894c40 RCX: 0000000000001000
[50000.687862] RDX: 0000000000001000 RSI: 0000562e788c5830 RDI: 00007f836a8fa000
[50000.694994] RBP: 00007f836b2ce718 R08: 0000000000000000 R09: 0000562e788c6830
[50000.702126] R10: 0000562e788aafb0 R11: 00007fffd4d32b60 R12: 0000000000000000
[50000.709258] R13: 0000000000000001 R14: 0000000000001000 R15: 0000562e78894c68
[50000.716394] task:dd              state:D stack:    0 pid:268009 ppid:267588 flags:0x00000004
[50000.724833] Call Trace:
[50000.727286]  __schedule+0x38b/0xc50
[50000.730787]  schedule+0x5b/0xc0
[50000.733939]  xlog_grant_head_wait+0xda/0x2d0 [xfs]
[50000.738794]  xlog_grant_head_check+0xd6/0x130 [xfs]
[50000.743733]  xfs_log_reserve+0xf6/0x310 [xfs]
[50000.748154]  xfs_trans_reserve+0x17f/0x250 [xfs]
[50000.752833]  xfs_trans_alloc+0x119/0x3b0 [xfs]
[50000.757338]  xfs_trans_alloc_icreate+0x41/0xd0 [xfs]
[50000.762367]  xfs_create+0x1c9/0x650 [xfs]
[50000.766443]  xfs_generic_create+0xfa/0x340 [xfs]
[50000.771120]  ? d_splice_alias+0x16e/0x490
[50000.775140]  lookup_open.isra.0+0x53c/0x660
[50000.779337]  ? verify_cpu+0xf0/0x100
[50000.782922]  ? verify_cpu+0xf0/0x100
[50000.786501]  path_openat+0x283/0xa90
[50000.790081]  ? xfs_iunlock+0x17b/0x280 [xfs]
[50000.794415]  do_filp_open+0x86/0x110
[50000.798005]  ? _raw_spin_unlock+0x1f/0x30
[50000.802021]  ? alloc_fd+0x12c/0x1f0
[50000.805516]  do_sys_openat2+0x7b/0x130
[50000.809279]  __x64_sys_openat+0x46/0x70
[50000.813125]  do_syscall_64+0x40/0x80
[50000.816703]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[50000.821755] RIP: 0033:0x7f530e47ab3b
[50000.825336] RSP: 002b:00007ffd4d27e110 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[50000.832902] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f530e47ab3b
[50000.840034] RDX: 0000000000000241 RSI: 00007ffd4d280563 RDI: 00000000ffffff9c
[50000.847166] RBP: 00007ffd4d280563 R08: 000000000000003d R09: 0000000000000000
[50000.854297] R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000241
[50000.861430] R13: 0000000000000241 R14: 00007ffd4d280563 R15: 00007ffd4d27e420

--wKueIIN5GUuwFT+3--

