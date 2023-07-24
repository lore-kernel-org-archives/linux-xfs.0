Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36935C001DC
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 00:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjGXA6E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jul 2023 20:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjGXA6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2023 20:58:04 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831BC97
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 17:58:02 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-d075a831636so2068414276.3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 17:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690160281; x=1690765081;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CpXGnHooagMmEUakZc4ePlVJ2xH/YsUKpAbQVyxUQY0=;
        b=CImXMLg3Q1s6ZVrZgxg7pp9PKMgBHgTBZ1ITZDkJe1x270/QBdSaSdwOJeVM4N8Y66
         hHtWD5dzT8yV1hwlCy1Cpjh7dm5QWpjr5pss3KD8DSKcl1rZFJIn235ykT9S07MRinkJ
         GQ/tMJTIL+/XbE2geCR3kfFOWZWmOhhVFiMFljTRNzwSOdH9IRhQa7nLOt4WIGhzaGOg
         rqmtvFcEAHSAT1RkaV4gpW3jh+ouH/gWHxiHZuFv26b8I38JNABdZEV7UFQpFmX7MakH
         GAbgMGphuClMQOmukgQzCzvMqx1Tj4BCza2iQMDdxoRfKwZyXTVNr11cagqFpcbTuJuv
         VY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690160281; x=1690765081;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpXGnHooagMmEUakZc4ePlVJ2xH/YsUKpAbQVyxUQY0=;
        b=iNlPUC5t9sDrZ9Gip69bIpYA4EE99iiH9105ocJxtbvnY2yrHFzQ66252hKkA3Hkbj
         0OG4ODIUTzrGTx5IQPYOWTBTAbl0Jq/Fq32lD4/trI88FTAzhJLcY/WSbbOe67cKy5Y+
         CELeioG9nhPFCUU0Rwc117AO2zBzfqrw0qsmYx8XHmVM8VFMsZxeJQcQkze5H96qSg19
         NpqZKiQZ99bFVby5N7Nq7FmgMaRpTfylXxy8XUHV2Ks3dabG9jHoj3AOItHUlBnEThXf
         qCAI91QnDakX+48kJc3bMr/sK4EZ9jKHdTv7WvVUHVEKCSI1B4E/sUc5uljgvSXAi2oL
         1r+w==
X-Gm-Message-State: ABy/qLZjdcbs7vYWs+ocp51qNPVIdbg0GVYipKdT8NaILP75yuVzW/CW
        NHrdanGhVtNzDukFIUYNhIq7Kqx7jAZoj4fNZpI=
X-Google-Smtp-Source: APBJJlHBsIq3/0ex3Pfx1WcCL2mgMj0z6lUYnUCrbH4NeFyz9N8x2YD1kiPzgDT/yjPuxhRUAHGweg==
X-Received: by 2002:a25:4cb:0:b0:d0a:a66b:cfbb with SMTP id 194-20020a2504cb000000b00d0aa66bcfbbmr2850165ybe.15.1690160281663;
        Sun, 23 Jul 2023 17:58:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id s15-20020a62e70f000000b0063d2dae6247sm6483070pfh.77.2023.07.23.17.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jul 2023 17:58:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qNjte-009l4V-0H;
        Mon, 24 Jul 2023 10:57:58 +1000
Date:   Mon, 24 Jul 2023 10:57:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZL3MlgtPWx5NHnOa@dread.disaster.area>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 21, 2023 at 07:36:03PM +0000, Wengang Wang wrote:
> FYI:
> 
> I am able reproduce the XFS mount hang issue with hacked kernels based on
> both 4.14.35 kernel or 6.4.0 kernel.
> 
> The hacking patch is like this (based on 6.4.0 kernel):
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index f9e36b810663..e04e8738c564 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -491,6 +491,12 @@ xfs_extent_free_finish_item(
>     struct xfs_extent_free_item *xefi;
>     int             error;
> 
> +   if (strcmp(tp->t_mountp->m_super->s_id,"loop0") == 0) {
> +       pr_err("loop0 free extent enter sleeping 5 hours\n");
> +       msleep(3600*1000*5);
> +       pr_err("loop0 free extent end sleeping 5 hours\n");
> +   }
>     xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
> 
>     error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 7d4109af193e..b571fe6966af 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -557,6 +557,13 @@ xfsaild_push(
>     xfs_trans_ail_cursor_done(&cur);
>     spin_unlock(&ailp->ail_lock);
> 
> +   if (strcmp(ailp->ail_log->l_mp->m_super->s_id,"loop0") == 0) {
> +       pr_err("loop0 aild enter sleeping 5 hours\n");
> +       msleep(3600*1000*5); // sleep 5 hours
> +       pr_err("loop0 aild end sleeping 5 hours\n");
> +       pr_err("loop0 start issuing buffer IO\n");
> +   }
> +
>     if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
>         ailp->ail_log_flush++;
> 
> The hacking patch does two things:
> 1. sleeps 5 hours in the ext freeing deferred op before reserving log space.

No it doesn't. The delay you added above occurs *after* the
transaction has already guaranteed it has full log reservation for
the extent freeing operation. You even use the transaction pointer
to get the mount id (loop0) before stalling it....

>    That simulates very slow extent free processing

> 2. sleeps 5 hours before flushing metadata buffers. That simulate very slow
>    AIL processing.

Well, it actually simulates *completely stalled* AIL processing.
If it was simulating slow processing, then the tail of the log would
always still be moving forwards slowly. Stalling metadata writeback
for 5 hours is effectively hanging the journal for 5 hours, not
making it "go slow". Those are very different situations that result
in very different behaviours.

> Though the hacking patch sleeps 5 hours, it actually needs only 10 minutes
> to reproduce this issue.

You should be able to fully stall the log and filesystem in under a
second with this patch.

> Reproduce steps:
> 
> 1. create a XFS with 10MiB log size (small so easier to reproduce). The following
>    steps all aim at this XFS volume.

Actually, make that a few milliseconds.... :)

mkfs/xfs_info output would be appreciated.

> 2. with un-hacked kernel, create 100K files, 1 block each file, under a dedicated
>    directory. We will overwrite those files causing inode timestamp logging.

Ok, that's step 4, right? You're not doing that here?

>    A timestamp logging (tr_fsyncts) requires/resevers 2508 bytes, which is less
>    than the required size for 360416 (tr_itrunc) for 4.14.35 kernel. Not able to get
>    the exact number for 6.4.0, but should be similar. With those timestamp updating,
>     we are able to make the free log size less than 360416.
>
> 3. With hacked kernel, create a new file, allocating block(s) to it and remove it.
>    Because of the hacking patch, EFI would be logged but the EFD will not in 5 hours.
>    We will panic the kernel in 5 hours so that with next mount, EFI recover would
>    happen.

Ok, so one EFI at the tail of the log, with a full reserve grant
head and write grant head reservation for the extent free
transaction that has been blocked.

> 4. with another console, overwrite serially that 100K files we created in step2.
>    This get stuck after overwritten 57K+ files. That's because we used up (almost)
>    all the free log space and we pinned log tail position with the hacking patch.
>    Checking vmcore, It is stuck waiting for 2508 log bytes (1552 free bytes available).
>    The numbers are exactly same with 4.14.35 kernel and 6.4.0 kernel.

Yup, and the reserve grant head should also include at least one
full tr_itrunc reservation for the EFI in progress.

> 
> 5. Checking the on disk left free log space, it’s 181760 bytes for both 4.14.35
>    kernel and 6.4.0 kernel.

Which is is clearly wrong. It should be at least 360416 bytes (i.e
tr_itrunc), because that's what the EFI being processed that pins
the tail of the log is supposed to have reserved when it was
stalled. So where has the ~180kB of leaked space come from?

Have you traced the grant head reservations to find out
what the runtime log space and grant head reservations actually are?

i.e. we have full tracing of the log reservation accounting via
tracepoints in the kernel. If there is a leak occurring, you need to
capture a trace of all the reservation accounting operations and
post process the output to find out what operation is leaking
reserved space. e.g.

# trace-cmd record -e xfs_log\* -e xlog\* -e printk touch /mnt/scratch/foo
....
# trace-cmd report > s.t
# head -3 s.t
cpus=16
          touch-289000 [008] 430907.633820: xfs_log_reserve:      dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 1024 grant_write_cycle 1 grant_write_bytes 1024 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
          touch-289000 [008] 430907.633829: xfs_log_reserve_exit: dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 482800 grant_write_cycle 1 grant_write_bytes 482800 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2

#

So this tells us the transaction reservation unit size, the count of
reservations, the current reserve and grant head locations, and the
current head and tail of the log at the time the transaction
reservation is started and then after it completes.

Hence we can tell if the reservation moved the grant head correctly,
whether there was space available prior to the reservation being
made, whether the grant heads contain in-memory reservations or
whether they are empty (i.e. match the log tail), etc. 

All cases where we change the reservation and the grant heads are
also captured by the above trace-cmd event filter, so a full picture
of the grant head reservations vs log head/tail can be determined
from post-processing the events....

This is how I've found log space leaks in the past. It's entirely
possible that we are leaking a couple of bytes somewhere in the
accounting, and that's the cause of the issue. It's happened before,
and the accounting is complex enough it will most likely happen
again...

>    It’s not same as the free log space as seen in vmcore,
>    1552 bytes. I am not able to figure oute why they are different yet. The delta aims
>    to make log recover safe?

Because different runtime conditions lead to different free log space
state.

> 6. panic the kernel manually and reboot to un-hacked kernel. Verify the on disk
>    free log space, it's the same as seen in step 5.

Right, so something has gone wrong with the runtime accounting, and
log recovery is just the messenger. We need to find out what went
wrong at runtime, not hack about in recovery trying to handle a
situation that should not be happening in the first place...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
