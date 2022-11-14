Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B22FC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 22:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbiKNWpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 17:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236117AbiKNWpH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 17:45:07 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355C8B01
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 14:45:06 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k5so11662335pjo.5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 14:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ck53/Uo9rwm/mGHAPSV+j93BR2C1Kt/q53zC5hVWdEE=;
        b=G+5zP+wZT8eHsZc96uuxGy3+SOtcoIIRnxmXbTYFQRL9x3DuPVCkqh7F4Kizs1xCcG
         dZZDEci2uyBgp5MJRIyf0vmTbtlShE+fICnPRSPc5RP+ZApn51PErCSnRq3Wv7RSO2YS
         DJ5EJ0yFXY4mmqa0BcnZikPsnseWzMudAilXkF+Zu+pCdMqpb+f9gKNx1q5uat2+Osqh
         i98QfF6NV+pbpxTUtCGybDJV0lnS4RWiD8PVxOLnBiOZEUcpT3DlSdjsq+IJAD8D2HRK
         Jd9vN2+h8KBNygV7W/d4/jrVqgUjODTCGCRjJPvRlA+9lvSHy375kKOoCR6sQ8RKJ9Uj
         gTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck53/Uo9rwm/mGHAPSV+j93BR2C1Kt/q53zC5hVWdEE=;
        b=kER6hckNRRufSz3p/YEPR4f1ThUun1h3miyF5Y6mlgML1Pvnn9XzFcm5SssyKXTCLG
         n23HnmDJK610wCupl5lfhbiCWMvDqKskAKOb5dQGsBbbzhb/+CgCQrL44xswNvOciAyw
         utzwngzJB4oOy9hTAzac64drS1Orc4tVUKRFb3YpLywANRLnwub5x1JenVENwJIBkWZz
         KdkOvtVy0Xt/6A1GOC54Ig3do/7PN6wOL/EKboucNsQ7MuqoTJYgT9WOqZUF/gZYP/5X
         fI0bEmffh4pCZW/MtWZsYOGtRvgw4aQo1OuYaysw9Tg++keyFvDK7uzp/9E5s9aROtgW
         336A==
X-Gm-Message-State: ANoB5pkeOO4NhNNZLXCN23nlJS91nkhG0OZJOH9VYQOY81EPBgAR6atW
        6aLEGvLYb/P5eXA3MbHX4ixifQ==
X-Google-Smtp-Source: AA0mqf6m8Di7HP/RpKtr86nOTy00hsHU3KrMlVouo4hrLEswqfzgIPA6ys3zQfoP+vo5KBe/9ejqBw==
X-Received: by 2002:a17:90a:9b85:b0:212:f8e5:81ab with SMTP id g5-20020a17090a9b8500b00212f8e581abmr16058309pjp.114.1668465905568;
        Mon, 14 Nov 2022 14:45:05 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902eccd00b0017f9db0236asm8171462plh.82.2022.11.14.14.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 14:45:04 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ouiCL-00EHME-5z; Tue, 15 Nov 2022 09:45:01 +1100
Date:   Tue, 15 Nov 2022 09:45:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Alexander Hartner <thahartner@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Detecting disk failures on XFS
Message-ID: <20221114224500.GR3600936@dread.disaster.area>
References: <CAG5wfU0E+y_gnfQLP4x2Ctan0Ts4d3frjVgZ9dt-xegVrucdXQ@mail.gmail.com>
 <CAG5wfU2p08ju-SbaRYMjuPXzzEXGneQzTTP56xYrWatO=NUS0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5wfU2p08ju-SbaRYMjuPXzzEXGneQzTTP56xYrWatO=NUS0g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 12:58:55PM +0800, Alexander Hartner wrote:
> We have dealing with a problem where a NVME drive fails every so
> often. More than it really should. While we are trying to make sense
> of the hardware issue, we are also looking at the recovery options.
> 
> Currently we are using Ubuntu 20.04 LTS on XFS with a single NVME
> disk. If the disk fails the following error is reported.
> 
> Nov 6, 2022 @ 20:27:12.000    [1095930.104279] nvme nvme0: controller
> is down; will reset: CSTS=0x3, PCI_STATUS=0x10
> Nov 6, 2022 @ 20:27:12.000    [1095930.451711] nvme nvme0: 64/0/0
> default/read/poll queues
> Nov 6, 2022 @ 20:27:12.000    [1095930.453846] blk_update_request: I/O
> error, dev nvme0n1, sector 34503744 op 0x1:(WRITE) flags 0x800
> phys_seg 1 prio class 0
> 
> And the system becomes completely unresponsive.

What is the system stuck on? The output of sysrq-w will would help
us understand what is happening as a result of this failed NVMe
drive.

> I am looking for a solution to stop the system when this happens, so
> the other nodes in our cluster can carry the work. However since the
> system is unresponsive and the disk presumably in read-only mode we
> stuck in a sort of zombie state, where the processes are still running
> but don't have access to the disk. On EXT3/4 there is an option to
> take the system down.

On XFS, there are some configurable error behaviours that
can be changed under /sys/fs/xfs/<dev>/error/metadata.

See the Error Handling of the linux kernel admin guide XFS page:

https://docs.kernel.org/admin-guide/xfs.html#error-handling

I'm guessing that the behaviour you are seeing is that metadata
write EIO errors default to "retry until unmount" behaviour (i.e.
retry writes forever, fail_at_unmount = true).

> Is there an equivalent for XFS ? I didn't find anything similar on the
> XFS man page.

Hmmmm.  It might be worth documenting this sysfs stuff in xfs(5),
not just the mount options supported...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
