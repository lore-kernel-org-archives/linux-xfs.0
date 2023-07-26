Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E641C001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 04:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbjGZEPC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jul 2023 00:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjGZEOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jul 2023 00:14:35 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A59E5FFE
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 21:08:49 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6b9c57c4d12so5021250a34.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jul 2023 21:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690344488; x=1690949288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QMb1LAAMoPtNL9of/OjNOi+8/ta6qZgT2PAM1jyEH0Q=;
        b=jKPesSwGW7KCDGIy0i9AtUvWnAaPg8YTM/9kV+hpf4p490P+ZjWHY8g8wtg3t1pIAM
         7NmDPkb6RQ4KXJW2CuNbWIExhDhczexU1P3yzJfErPdm5/ZKGgTlg0Z0uTHTme1ue5Ca
         7bXs9NLK6z18FLYztPs6dre3zSu7UXEhHkriZ4y3SScgIxt1kfoonjMe8MWe8zB40/gv
         zMsSkjTZ2l/ehjiDs4KDNqx/W45xQjSQEgE/QM2S0V4QviMid2iMXLPxAqSmwK7Dma+z
         iP+G/WXPVy3xraOkSVWd4dz7dwWriz0TWev0Unt3/GOWBbvVKGE5c+fgBf2a5MEwEEgi
         Ux7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690344488; x=1690949288;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QMb1LAAMoPtNL9of/OjNOi+8/ta6qZgT2PAM1jyEH0Q=;
        b=NZFkNCuy710xFcfu8niGcHwZwmShKraFGQXyGX8oZ7Hmf9vGaZvGAaXN08zWZevigZ
         m0q4xxTIOm/x3HRP6ThUrw98hpJF5LHeS/acgs9P1+8LaXgAmJgw5Q4uqNYikVCR6Hle
         YtZcuqFdOJvFqJ55zr+xqth8bVZUJDIXJIgrRIoo4M3SxmCS7gsiZrUsz1MRZhpNTrf7
         00mfgWGFVOo+aLkEHBc0pb+ITNuTSDDU8/p/WsshDOwy19zqYkridIRgs+b/V/PQs5Tx
         +EvdUC0iPVQW5BH7YcB1fM0FU1KkjBW+/Eh2ynrwhX1wekCa9PSUIq+APZ4cnAuVRnG0
         gykA==
X-Gm-Message-State: ABy/qLYJPrGqg36chbzKP0ZDTvkCWZ9BjtuES87hdImSGzJGJb80DJX3
        xvd6OMQ/WGlJWFlSPloO4/bn7g==
X-Google-Smtp-Source: APBJJlG3M4iE6YR8BiSctwBv25CUSx3dsuWjZw4mC8raQna498k8ZfYFPU3Fl2JvD+PetbSHM5M1AA==
X-Received: by 2002:a05:6870:4249:b0:1bb:4c5f:6db0 with SMTP id v9-20020a056870424900b001bb4c5f6db0mr1367578oac.36.1690344488397;
        Tue, 25 Jul 2023 21:08:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id f2-20020aa782c2000000b006661562429fsm10646692pfn.97.2023.07.25.21.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 21:08:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOVoj-00Abqo-0U;
        Wed, 26 Jul 2023 14:08:05 +1000
Date:   Wed, 26 Jul 2023 14:08:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZMCcJSLiWIi3KBOl@dread.disaster.area>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 06:03:02PM +0000, Wengang Wang wrote:
> > On Jul 23, 2023, at 5:57 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jul 21, 2023 at 07:36:03PM +0000, Wengang Wang wrote:
> >> FYI:
> >> 
> >> I am able reproduce the XFS mount hang issue with hacked kernels based on
> >> both 4.14.35 kernel or 6.4.0 kernel.
> >> Reproduce steps:
> >> 
> >> 1. create a XFS with 10MiB log size (small so easier to reproduce). The following
> >>   steps all aim at this XFS volume.
> > 
> > Actually, make that a few milliseconds.... :)
> 
> :)
> 
> > mkfs/xfs_info output would be appreciated.
> 
> sure,
> # xfs_info 20GB.bk2
> meta-data=20GB.bk2               isize=256    agcount=4, agsize=1310720 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0

Hmmmm. Why are you only testing v4 filesystems? They are deprecated
and support is largely due to be dropped from upstream in 2025...

Does the same problem occur with a v5 filesystems?

> >> 5. Checking the on disk left free log space, it’s 181760 bytes for both 4.14.35
> >>   kernel and 6.4.0 kernel.
> > 
> > Which is is clearly wrong. It should be at least 360416 bytes (i.e
> > tr_itrunc), because that's what the EFI being processed that pins
> > the tail of the log is supposed to have reserved when it was
> > stalled.
> 
> Yep, exactly.
> 
> > So where has the ~180kB of leaked space come from?
> > 
> > Have you traced the grant head reservations to find out
> > what the runtime log space and grant head reservations actually are?
> I have the numbers in vmcore (ignore the WARNs),

That's not what I'm asking. You've dumped the values at the time of
the hang, not traced the runtime reservations that have been made.

> > i.e. we have full tracing of the log reservation accounting via
> > tracepoints in the kernel. If there is a leak occurring, you need to
> > capture a trace of all the reservation accounting operations and
> > post process the output to find out what operation is leaking
> > reserved space. e.g.
> > 
> > # trace-cmd record -e xfs_log\* -e xlog\* -e printk touch /mnt/scratch/foo
> > ....
> > # trace-cmd report > s.t
> > # head -3 s.t
> > cpus=16
> >          touch-289000 [008] 430907.633820: xfs_log_reserve:      dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 1024 grant_write_cycle 1 grant_write_bytes 1024 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> >          touch-289000 [008] 430907.633829: xfs_log_reserve_exit: dev 253:32 t_ocnt 2 t_cnt 2 t_curr_res 240888 t_unit_res 240888 t_flags XLOG_TIC_PERM_RESERV reserveq empty writeq empty grant_reserve_cycle 1 grant_reserve_bytes 482800 grant_write_cycle 1 grant_write_bytes 482800 curr_cycle 1 curr_block 2 tail_cycle 1 tail_block 2
> > 
> > #
> > 
> > So this tells us the transaction reservation unit size, the count of
> > reservations, the current reserve and grant head locations, and the
> > current head and tail of the log at the time the transaction
> > reservation is started and then after it completes.
> 
> Will do that and report back. You want full log or only some typical
> ones? Full log would be big, how shall I share? 

I don't want to see the log. It'll be huge - I regularly generate
traces containing gigabytes of log accounting traces like this from
a single workload.

What I'm asking you to do is run the tracing and then post process
the values from the trace to determine what operation is using more
space than is being freed back to the log.

I generally do this with grep, awk and sed. some people use python
or perl. But either way it's a *lot* of work - in the past I have
spent _weeks_ on trace analysis to find a 4 byte leak in the log
space accounting. DOing things like graphing the head, tail and grant
spaces over time tend to show if this is a gradual leak versus a
sudden step change. If it's a sudden step change, then you can
isolate it in the trace and work out what happened. If it's a
gradual change, then you need to start looking for accounting
discrepancies...

e.g. a transaction records 32 bytes used in the item, so it releases
t_unit - 32 bytes at commit. However, the CIL may then only track 28
bytes of space for the item in the journal and we leak 4 bytes of
reservation on every on of those items committed.

These sorts of leaks typically only add up to being somethign
significant in situations where the log is flooded with tiny inode
timestamp changes - 4 bytes iper item doesn't really matter when you
only have a few thousand items in the log, but when you have
hundreds of thousands of tiny items in the log...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
