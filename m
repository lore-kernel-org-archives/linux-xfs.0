Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770B5C43217
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 21:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKCVRP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 17:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiKCVQz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 17:16:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A97B1BEB0
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 14:16:55 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q1so2734791pgl.11
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2022 14:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oQnLQOqYDQ3J3f5rWv2h1dsC8pInVHtq5Sbro5Qd65I=;
        b=KPqIgPJhndPKlVQlXRb8w+nS0+PlW8szuHQP4UD6tJ1J14ZSHis/E5d5MQXPQDWWD1
         GUn3JqWtyipRYAzOet+egMhNUCR8r9ln5+I9GL6F0tPd/oNCQugtjjvDJvgR2VHzv97t
         DyEIL2qZuYQA3p5SEhmCe/V59saQ+tsAtT1DsBgnc3jLtGYaw/RHiysrtIRGrW3MAP2k
         Q5QAu3mGOX6oygHCjIeYPSXLB8111rYDxKtSQdCCoijp41xhHiXD27qTAjhuPuRpCwqo
         o1jd2yzi4qnBKx62yW/y+KW4KEqpXYabgnQ9m+Og/vr3Ar02+5zfQv1Pb4w0kxZ6EaUe
         zehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oQnLQOqYDQ3J3f5rWv2h1dsC8pInVHtq5Sbro5Qd65I=;
        b=dUfQ9u1R/Nd5TZZ/7lBAb9WR6+IMipTwZoI//bXghGZ6BunLTma7nL4McY2orCR+E+
         DxeI0VGpxyOVeIApu0I105zc6ipmjNWUCfrq1XPBusvFqx+mGPYiuXv55rNOGiMm8nc4
         W0r0Vf5ZjX52bu9FxqSCeJDgTG6Cp0mUdWL9NEleLsq1O+My1Jp0ZoyC7GkLzVuu8xVy
         zofBCUdRAOVVWI7EgyDHFrB5bOgFzcnW0TX7EKx4luTAPPk0lqaO8ta99JJL0ugUDXHY
         IYMzGzmHGey2zfGsY+8Ny4rGmLhHJJIUOkLDDeYNlvK378Xuq/I9y1C33OCVBkhkKnV8
         a6VQ==
X-Gm-Message-State: ACrzQf2WryzptjZsQP2Fapb7tRWoUhcDkvuLI6mL5CfNcEGK0iocpPzr
        0/f3GSZaixSwyYLfq2svqYf4xg==
X-Google-Smtp-Source: AMsMyM5GIjoLu9IApImIWdpFsdee8K8XlbYw5YEkUJWjNgEH/ZQcmzpvEv7SNXxtOgaOi9njf2jV1w==
X-Received: by 2002:a63:914b:0:b0:46e:dbd5:ae15 with SMTP id l72-20020a63914b000000b0046edbd5ae15mr27897791pge.94.1667510214646;
        Thu, 03 Nov 2022 14:16:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b0016d72804664sm1084402pln.205.2022.11.03.14.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:16:54 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqhZz-009v1x-JS; Fri, 04 Nov 2022 08:16:51 +1100
Date:   Fri, 4 Nov 2022 08:16:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        houtao1@huawei.com, jack.qiu@huawei.com, fangwei1@huawei.com,
        yi.zhang@huawei.com, zhengbin13@huawei.com, leo.lilong@huawei.com,
        zengheng4@huawei.com
Subject: Re: [PATCH 1/2] xfs: wait xlog ioend workqueue drained before
 tearing down AIL
Message-ID: <20221103211651.GH3600936@dread.disaster.area>
References: <20221103083632.150458-1-guoxuenan@huawei.com>
 <20221103083632.150458-2-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103083632.150458-2-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 04:36:31PM +0800, Guo Xuenan wrote:
> Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
> In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
> xlog_state_shutdown_callbacks") changed the order of running callbacks
> and wait for iclog completion to avoid unmount path untimely destroy AIL.
> But which seems not enough to ensue this, adding mdelay in
> `xfs_buf_item_unpin` can prove that.
> 
> The reproduction is as follows. To ensure destroy AIL safely,
> we should wait all xlog ioend workers done and sync the AIL.
> 
> ==================================================================
> BUG: KASAN: use-after-free in xfs_trans_ail_delete+0x240/0x2a0
> Read of size 8 at addr ffff888023169400 by task kworker/1:1H/43
> 
> CPU: 1 PID: 43 Comm: kworker/1:1H Tainted: G        W
> 6.1.0-rc1-00002-gc28266863c4a #137
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: xfs-log/sda xlog_ioend_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4d/0x66
>  print_report+0x171/0x4a6
>  kasan_report+0xb3/0x130
>  xfs_trans_ail_delete+0x240/0x2a0
>  xfs_buf_item_done+0x7b/0xa0
>  xfs_buf_ioend+0x1e9/0x11f0
>  xfs_buf_item_unpin+0x4c8/0x860
>  xfs_trans_committed_bulk+0x4c2/0x7c0
>  xlog_cil_committed+0xab6/0xfb0
>  xlog_cil_process_committed+0x117/0x1e0
>  xlog_state_shutdown_callbacks+0x208/0x440
>  xlog_force_shutdown+0x1b3/0x3a0
>  xlog_ioend_work+0xef/0x1d0

So we are still processing an iclog at this point and have it
locked (iclog->ic_sema is held). These aren't cycled to wait for
all processing to complete until xlog_dealloc_log() before they are
freed.

If we cycle through the iclog->ic_sema locks when we quiesce the log
(as we should be doing before attempting to write an unmount record)
this UAF problem goes away, right?

> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index f51df7d94ef7..1054adb29907 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -929,6 +929,9 @@ xfs_trans_ail_destroy(
>  {
>  	struct xfs_ail	*ailp = mp->m_ail;
>  
> +	drain_workqueue(mp->m_log->l_ioend_workqueue);
> +	xfs_ail_push_all_sync(ailp);

This isn't the place to be draining the AIL and waiting for IO to
complete. As per above, that should have been done long before we
get here...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
