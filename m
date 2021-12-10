Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC55BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 20:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhLJUL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 15:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhLJUL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 15:11:28 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD484C061746
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 12:07:52 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so23977170ybn.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 12:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NC0AbFVpzUbsgioFaxV8T5WM4vEEaYqZagPZ7n9n4nA=;
        b=FDX3K8uOyfmIPZ93BB6TdePbgW/VJMxMwdfZsemGwVk8uH1KUoDdhRDYespZL1GZBr
         +k+8m7GoJh8ur3ZjgzIY9UoF1HPmbEE89kv8dtgiMUuBKx/tcyKSRi/nXwlLI5X2oP/U
         77S07gI+MqPH6jJsaMkpoCJglF5HkOqkEAnEEj1GfJeHfZnufnoDy/w5ob95il91CZIp
         9X4ludz3MHVuuFiVvrKHL/oiAjkp+1rdHf4FjXjy+rd98lhPeERAgtZ2rwtSDM58fgRk
         2918JF0uT6vJZLYiho+joQo5Oq5incK33auwd6OaB3ilhhsXT5Mz3IHm4wlLx2Sd2I3s
         jhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NC0AbFVpzUbsgioFaxV8T5WM4vEEaYqZagPZ7n9n4nA=;
        b=jvQkSh0MZ4R+3FWX71gfwhpUgLDHief1OvTIHwaGnq1qR74kKJZTvnF3cY+a3UcBkq
         8GnnyuXU8SKSrvlmpqhO5SBSjV3TDcYb+9RCsId6a+x6CKfebOm9juozGGrjvL37Nd8y
         gSGai7Gu4cVPKLUxAVm0g8z0CIs2o0sBWF862NXYQiXrjUyJW6Ryxl9cBo+bgOKrYhvq
         EjvoW1geRnsjkoPdlFaHDEv7M9DJfFGO8hZ8E1SjUhz1MRmKdcF+BbrDSdxqV/80eT7t
         9/JgoMDgpcQt8VW/vZsV49TuYcMQxktCaUAI9z2BCS2uzdoyIPx8V273IUXvtblRcrJf
         /auA==
X-Gm-Message-State: AOAM533oVhVq9oxaWfH1N1CPcafTDXgeIowLKRwFFMUfMYFQFw49IttI
        +YZ6sEnrip/DpQHuh03Z9UgM8Z3XqBXYM+MTBGwGpfGAHyOVieoBLd8=
X-Google-Smtp-Source: ABdhPJzR9macioCcHtpPZRulSJ8tIiO4cAV9OUfX69KyLx8UyBUvowxrTZFOXccyXx+hbsrqgXIuryeFDiQp4XbU5ac=
X-Received: by 2002:a25:71d7:: with SMTP id m206mr17084884ybc.695.1639166872067;
 Fri, 10 Dec 2021 12:07:52 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQdXZEXC+4iDgG9h5ETmytfaU1+mzAQ+sA9TfQ1qo3Y_w@mail.gmail.com>
 <20211208213339.GM449541@dread.disaster.area>
In-Reply-To: <20211208213339.GM449541@dread.disaster.area>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 10 Dec 2021 15:06:37 -0500
Message-ID: <CAJCQCtR5NjF61B4g4KkjBgdmV8rK8tWLNxtVvNbm4gzm9kdrhg@mail.gmail.com>
Subject: Re: VMs getting into stuck states since kernel ~5.13
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 8, 2021 at 4:33 PM Dave Chinner <david@fromorbit.com> wrote:
> Looking at the traces, I'd say IO is really slow, but not stuck.
> `iostat -dxm 5` output for a few minutes will tell you if IO is
> actually making progress or not.

Pretty sure like everything else we run once the hang happens, iostat
will just hang too. But I'll ask.

>
> Can you please provide the hardware configuration for these machines
> and iostat output before we go any further here?

Dell PERC H730P
megaraid sas controller, to 10x 600G sas drives, BFQ ioscheduler, and
the stack is:

partition->mdadm raid6, 512KiB chunk->dm-crypt->LVM->XFS

meta-data=/dev/mapper/vg_guests-LogVol00 isize=512    agcount=180,
agsize=1638272 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=294649856, imaxpct=25
         =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0



-- 
Chris Murphy
