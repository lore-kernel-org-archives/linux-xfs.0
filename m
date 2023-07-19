Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05BEEB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 00:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjGSALI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 20:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGSALI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 20:11:08 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E5B3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 17:11:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-666e5f0d60bso4088134b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 17:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689725466; x=1692317466;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YJL5EJ25ozm9FqA+bPuR1guL4gfnFxrdVAT7JvqdaJM=;
        b=YlWnsvOWx+2FYMpczGcMS5usSRRcF5RZvDoOg3KYj199bky+e7IM+EHIJAEree6PJK
         q3zyDExiG6hA5TKJuVGDjJOWjqrofawomZb7RLFDhdLaIzy8hWPuncCI+Qf8WW9AteKG
         URY0S586I4XRlH595utRV3FOilsdT684+Et5EWBQTkcQHag8cp3t96hWOL+1nOhlZgI4
         CgprRkpBiUij2F+P+aIsSmlJ546YpfTrHCHkpdF3ys302nxzvbOTtNsrNZIu2ocVkZCM
         /xAjrB5dhtcYNQsrHZMO5L/cMHQ51zI0lMOVGbXHT6aUZtF9967qjxh9D6u3mKZEOtux
         UVoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689725466; x=1692317466;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YJL5EJ25ozm9FqA+bPuR1guL4gfnFxrdVAT7JvqdaJM=;
        b=YJjY/wKz1O6Z8K7WGOMjcEmpy3epD/SMaibLDyx4Jox6yWr9NPsF/m0QSfL/rKqGt7
         1FGptlUjpsmlynNDS+i88OMCOW5zRrNfFk+vzO6rWzmmJaWNYHXqQ6N5Wwf8zJwWl1+X
         2to+PpQoz2DJ0+6xUpgdGu+o8sAH9J3ZhfJmJfKv+NOXqHxDwXwM3JNyl0xh8UsfYlxz
         ywvVGC3s0zB9KOaEP3yDK1wru9MB6mfI9dpvP/Nn+WFq/gEbzKMhq9iNPzRdWhBUZuVU
         mzEjQe94e9wZxoz7bUlpmG+UmWoPBbjMisFt5puoszNCgg0Ccw0V5WYC4ffWqx4eDKrk
         aM/A==
X-Gm-Message-State: ABy/qLalcxYMUi2NZUr2xrG/S384fKupwSjVavvLuoFw4XT4+ichfP9p
        /iqy39+KX6A3ZlIqiFlBIUcV/MF6Gh17x1xAUss=
X-Google-Smtp-Source: APBJJlEfDKLplOZZdBvFZb1NKSYUR18c9038qux4xoOuG1/20UOlCcOHbI2KUg0rcehm97AenPEVdw==
X-Received: by 2002:a05:6a20:7f86:b0:12f:dc60:2b9e with SMTP id d6-20020a056a207f8600b0012fdc602b9emr16513376pzj.48.1689725466444;
        Tue, 18 Jul 2023 17:11:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id 6-20020aa79106000000b0062cf75a9e6bsm2044997pfh.131.2023.07.18.17.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:11:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qLumV-007l46-0M;
        Wed, 19 Jul 2023 10:11:03 +1000
Date:   Wed, 19 Jul 2023 10:11:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZLcqF2/7ZBI44C65@dread.disaster.area>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 10:57:38PM +0000, Wengang Wang wrote:
> Hi,
> 
> I have a XFS metadump (was running with 4.14.35 plussing some back ported patches),
> mounting it (log recover) hang at log space reservation. There is 181760 bytes on-disk
> free journal space, while the transaction needs to reserve 360416 bytes to start the recovery.
> Thus the mount hangs for ever.

Most likely something went wrong at runtime on the 4.14.35 kernel
prior to the crash, leaving the on-disk state in an impossible to
recover state. Likely an accounting leak in a transaction
reservation somewhere, likely in passing the space used from the
transaction to the CIL. We've had bugs in this area before, they
eventually manifest in log hangs like this either at runtime or
during recovery...

> That happens with 4.14.35 kernel and also upstream
> kernel (6.4.0).

Upgrading the kernel won't fix recovery - it is likely that the
journal state on disk is invalid and so the mount cannot complete 

> The is the related stack dumping (6.4.0 kernel):
> 
> [<0>] xlog_grant_head_wait+0xbd/0x200 [xfs]
> [<0>] xlog_grant_head_check+0xd9/0x100 [xfs]
> [<0>] xfs_log_reserve+0xbc/0x1e0 [xfs]
> [<0>] xfs_trans_reserve+0x138/0x170 [xfs]
> [<0>] xfs_trans_alloc+0xe8/0x220 [xfs]
> [<0>] xfs_efi_item_recover+0x110/0x250 [xfs]
> [<0>] xlog_recover_process_intents.isra.28+0xba/0x2d0 [xfs]
> [<0>] xlog_recover_finish+0x33/0x310 [xfs]
> [<0>] xfs_log_mount_finish+0xdb/0x160 [xfs]
> [<0>] xfs_mountfs+0x51c/0x900 [xfs]
> [<0>] xfs_fs_fill_super+0x4b8/0x940 [xfs]
> [<0>] get_tree_bdev+0x193/0x280
> [<0>] vfs_get_tree+0x26/0xd0
> [<0>] path_mount+0x69d/0x9b0
> [<0>] do_mount+0x7d/0xa0
> [<0>] __x64_sys_mount+0xdc/0x100
> [<0>] do_syscall_64+0x3b/0x90
> [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> 
> Thus we can say 4.14.35 kernel didn’t reserve log space at IO time to make log recover
> safe. Upstream kernel doesn’t do that either if I read the source code right (I might be wrong).

Sure they do.

Log space usage is what the grant heads track; transactions are not
allowed to start if there isn't both reserve and write grant head
space available for them, and transaction rolls get held until there
is write grant space available for them (i.e. they can block in
xfs_trans_roll() -> xfs_trans_reserve() waiting for write grant head
space).

There have been bugs in the grant head accounting mechanisms in the
past, there may well still be bugs in it. But it is the grant head
mechanisms that is supposed to guarantee there is always space in
the journal for a transaction to commit, and by extension, ensure
that we always have space in the journal for a transaction to be
fully recovered.

> So shall we reserve proper amount of log space at IO time, call it Unflush-Reserve, to
> ensure log recovery safe?  The number of UR is determined by current un flushed log items.
> It gets increased just after transaction is committed and gets decreased when log items are
> flushed. With the UR, we are safe to have enough log space for the transactions used by log
> recovery.

The grant heads already track log space usage and reservations like
this. If you want to learn more about the nitty gritty details, look
at this patch set that is aimed at changing how the grant heads
track the used/reserved log space to improve performance:

https://lore.kernel.org/linux-xfs/20221220232308.3482960-1-david@fromorbit.com/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
