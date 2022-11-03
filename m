Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE43C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 21:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKCVoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 17:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKCVoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 17:44:12 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8E9F54
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 14:44:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 4so3221221pli.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2022 14:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bE2rYo/Va6oQR+LsH4LN6otl/QXlmJMD4nEAzWeWVps=;
        b=QE9CbeUZetIS8G3IOKGM7PVc9h94+2Eeypn70YKJG2w333AvF6EJNkQrPxZ5jFd5g9
         llQGJIXecwJtz5aiQlMT00Rbv6M8vdEjg6+ou+l7eawNbFxnrfcNP+nMZyTyijQvYecY
         BsL4rFti8XQw3dPuNP5py197eqqhu6yzKjsGCgaawmBkHEvhBQ1jev/XZdGZM8RfKtVv
         yvXkvrdLm/qClxrPV+wgJrxZPyqPtx7iC6bPVvMt87k3L9n1PEUF3SjykNXN568mgWtA
         uxMRGh8SWuN9ikIuQxhhyQ57I/EbfCg1OgVUHEQXUg87ruszccp0J3YBE4guDTazBnXE
         iFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bE2rYo/Va6oQR+LsH4LN6otl/QXlmJMD4nEAzWeWVps=;
        b=WJ9XZJzrBDHqu/v7+3XGjPgWWeWHKQS+qAOa1qKBH+F1kdqwem0lYoosknzdgq0zsW
         6b9dROhdfF3DwBgHPtCRwp7VgGdbEcvZkMAh1wZUD1BkJCWeGveBfyXB2nDEAKg8z4Vu
         8XB4y6jQ7x+nG57wQGchOCQteQtKxXRp6cM2eVXpF63ThWaiHoNxlmXIxkZNEBBQKgLS
         aDJFfUElgHEHv+gkwbAMmx39dMwr+N5BjMq9RPS5tQEoFryLB/w5eoOU28lUNNuk/Rmr
         L6yx22VI3lvAInW7dUGd0P2iJpOuge4gztsrjqNSPcIlwQjenEpvXEHeJE1GFTeDOc9b
         UP1g==
X-Gm-Message-State: ACrzQf1gpzxdQP2dElkk5w/0TM2a3eNfFdZCv4ykiX1tWhgC7eQkPMjR
        TQWTDdc/LsdBi0mjzjl47eMUyQ==
X-Google-Smtp-Source: AMsMyM4JW6rh6v69J/PRH0ee90sOIlYXbgBoTZOSubbhp0Vk4RJb6RtyBCcn08rBDKUNv4X1t1Ei3A==
X-Received: by 2002:a17:903:22d2:b0:187:1f4a:6593 with SMTP id y18-20020a17090322d200b001871f4a6593mr24108044plg.138.1667511851658;
        Thu, 03 Nov 2022 14:44:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id d16-20020a170902ced000b001869d71228bsm1131159plg.170.2022.11.03.14.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:44:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqi0O-009vWf-6v; Fri, 04 Nov 2022 08:44:08 +1100
Date:   Fri, 4 Nov 2022 08:44:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
        houtao1@huawei.com, jack.qiu@huawei.com, fangwei1@huawei.com,
        yi.zhang@huawei.com, zhengbin13@huawei.com, leo.lilong@huawei.com,
        zengheng4@huawei.com
Subject: Re: [PATCH 2/2] xfs: fix super block buf log item UAF during force
 shutdown
Message-ID: <20221103214408.GI3600936@dread.disaster.area>
References: <20221103083632.150458-1-guoxuenan@huawei.com>
 <20221103083632.150458-3-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103083632.150458-3-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 04:36:32PM +0800, Guo Xuenan wrote:
> xfs log io error will trigger xlog shut down, and end_io worker call
> shutdown_callbacks to unpin and release the buf log item. The race
> condition is that when there are some thread doing transaction commit
> and happened not to be intercepted by xlog_is_shutdown, then, these
> log item will be insert into CIL, when unpin and release these buf log
> item, UAF will occur. BTW, add delay before `xlog_cil_commit` while xlog
> shutdown status can increase recurrence probability.
> 
> The following call graph actually encountered this bad situation.
> fsstress                    io end worker kworker/0:1H-216
> 		             xlog_ioend_work
> 		               ->xlog_force_shutdown
> 		                 ->xlog_state_shutdown_callbacks
> 		             	 ->xlog_cil_process_committed
> 		             	   ->xlog_cil_committed
> 		             	     ->xfs_trans_committed_bulk
> ->xfs_trans_apply_sb_deltas               ->li_ops->iop_unpin(lip, 1);
>   ->xfs_trans_getsb
>     ->_xfs_trans_bjoin
>       ->xfs_buf_item_init
>         ->if (bip) { return 0;} //relog

_xfs_trans_bjoin() takes a reference to the bli.

> ->xlog_cil_commit
>   ->xlog_cil_insert_items //insert into CIL
>                                             ->xfs_buf_ioend_fail(bp);
>                                               ->xfs_buf_ioend
>                                                 ->xfs_buf_item_done
>                                                   ->xfs_buf_item_relse
>                                                     ->xfs_buf_item_free

So how is the bli getting freed here if the fstress task has just
taken an extra reference and inserted it into the CIL?

Ah, the problem is that xfs_buf_item_relse() isn't checking the
reference count before it frees the BLI. That is,
xfs_buf_item_relse() assumes that it is only called at the end of
the BLI life cycle and so doesn't check the reference count, when in
fact it clearly isn't.

Also, should we be inserting new items into the CIL if the log is
already marked as shut down?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
