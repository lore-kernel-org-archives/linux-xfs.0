Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F67EB64D7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jun 2023 21:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjFZVqA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 17:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjFZVp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2023 17:45:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFC410FF
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 14:45:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-66f5faba829so1392149b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jun 2023 14:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687815958; x=1690407958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sTYxZhrQuKjbn6QoWZdbsuYnCCckU1Rdpj1aIW9FAF0=;
        b=151Z3fBhA2NvIKOXweU2GcBX8WPAKVz5yucdhryu640N7ZEm7ydfDvuQf1Wqdb4oA5
         YHtxlWt8Z22RU6CrCiO8rszQNA9R4BSX8aSiqEc9kv7Bv5W8MqMyqOR6tGpK79oKLdZ/
         VfIY9NPqataM3wecyJBl3jTG+xsDSnRYxxzzhJWBLUwZicDBrfHXVhfnCK8NUn/7Sycb
         +HKqSt8ITkpuFVDcCufLYmcSW80oTNWVpZhgY8PisCJOrfnIiqlND5rtscgQRGIQUy+b
         LmzPacy0xM/C6DsDo6FkEd2X5TIRxKc2l4tFFQhalRcZgmkoFXcCdgiZNHn5+jvNXXOY
         4ITw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687815958; x=1690407958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTYxZhrQuKjbn6QoWZdbsuYnCCckU1Rdpj1aIW9FAF0=;
        b=bcGCfTZOPSrdtsR/gm6WF6xRwHaUJJLlXqL9yx9uKAcihWxKBMNoRgH8QKz9mON2aw
         bspl69AJSdz6afcqeNKND8ujxEhnb67PnpRY/0VL5VSEUxBfWY7n2ClG+BGKDggymSyB
         bpqp3e4Ye6aSYfekDdVAu0CgqFbjF6PaxWaLgj3u5rpYByT1BMMWyny7Da22VlHjMpvD
         w5Dh0iNA27vh9nqACq7fLNPLEbpG/yJk6RhTdb7o0qbx4NX3xcQq37rBDtP6Q3MC7cPo
         x1e0lGZmYjkexk4IsfiDwCmBycWUEI9HzG3IKlnnf/PU3LYLxNCUysAmNC8jv+oeWFKz
         PWig==
X-Gm-Message-State: AC+VfDzGiRJGsd+om0gOODRfZdRxWiZm0rhbseqRdtljy2YfcHMSsMao
        0Vcm39QnPiZNqOnihZQO7Uy7eg==
X-Google-Smtp-Source: ACHHUZ6TNsWUixbKA0KJtWrU2C++k5Z1Y4xp/v58AiFf2/uTH9PMe97McagXrOCVWUcAL6xxiqWetg==
X-Received: by 2002:a05:6a20:7f88:b0:122:a808:dbb9 with SMTP id d8-20020a056a207f8800b00122a808dbb9mr19428004pzj.41.1687815957808;
        Mon, 26 Jun 2023 14:45:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id iw11-20020a170903044b00b001b03a7a40e7sm2718279plb.19.2023.06.26.14.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 14:45:57 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qDu1y-00Ga8e-1T;
        Tue, 27 Jun 2023 07:45:54 +1000
Date:   Tue, 27 Jun 2023 07:45:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     yangerkun <yangerkun@huaweicloud.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, sandeen@redhat.com,
        linux-xfs@vger.kernel.org, yangerkun@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH] xfs: fix deadlock when set label online
Message-ID: <ZJoHEuoMkg2Ngn5o@dread.disaster.area>
References: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626131542.3711391-1-yangerkun@huaweicloud.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 26, 2023 at 09:15:42PM +0800, yangerkun wrote:
> From: yangerkun <yangerkun@huawei.com>
> 
> Combine use of xfs_trans_hold and xfs_trans_set_sync in xfs_sync_sb_buf
> can trigger a deadlock once shutdown happened concurrently. xlog_ioend_work
> will first unpin the sb(which stuck with xfs_buf_lock), then wakeup
> xfs_sync_sb_buf. However, xfs_sync_sb_buf never get the chance to unlock
> sb until been wakeup by xlog_ioend_work.
> 
> xfs_sync_sb_buf
>   xfs_trans_getsb // lock sb buf
>   xfs_trans_bhold // sb buf keep lock until success commit
>   xfs_trans_commit
>   ...
>     xfs_log_force_seq
>       xlog_force_lsn
>         xlog_wait_on_iclog
>           xlog_wait(&iclog->ic_force_wait... // shutdown happened
>   xfs_buf_relse // unlock sb buf
>
> xlog_ioend_work
>   xlog_force_shutdown
>     xlog_state_shutdown_callbacks
>       xlog_cil_process_committed
>         xlog_cil_committed
>         ...
>         xfs_buf_item_unpin
>           xfs_buf_lock // deadlock
>       wake_up_all(&iclog->ic_force_wait)
> 
> xfs_ioc_setlabel use xfs_sync_sb_buf to make sure userspace will see the
> change for sb immediately. We can simply call xfs_ail_push_all_sync to
> do this and sametime fix the deadlock.

Why is this deadlock specific to the superblock buffer?

Can't any buffer that is held locked over a synchronous transaction
commit deadlock during a shutdown like this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
