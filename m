Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBA0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 20:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKCUvN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 16:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKCUvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 16:51:12 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FEBBBE
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 13:51:11 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q71so2693790pgq.8
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2022 13:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dvdJl9a9NOvkSMk1dlLir6JV4j1f8MWrHAZPm72su50=;
        b=0j4VlGwQYycrPCE93iCDueVw7FjpSfxFfoEQUSHIkrsgwmnM+PJv1e+c5F1pMtiJTl
         BlPO8u3x4ue4GbR8aZ0OV+BSbTEQRi88/xMDwTWEGPvFN7IaKHd54EEaSh2UbhS1utDe
         2fcSMX/ccYuOL4ZJIx8ciHgCBY0nHJOqiz8nNoQT1Po1PScU+KoBf8gglCAIsI+p1Jlf
         HvB7Ui8yJEnYeK12HN1VtXv1phNpJCSP22vMSOjpYsfIXL8LvErbraLvVwE3hX3PR+Li
         /3MsZBNwJFHZYmi04gGweGbY0PDfu6youqO3Kk7PKn6ljpJzPvWXpNtNBE5L3Fg/Epxv
         paUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvdJl9a9NOvkSMk1dlLir6JV4j1f8MWrHAZPm72su50=;
        b=VQVDZmwy+aiJ6bauGzUTjyUkucBdSr/LYOvMo9JbSSkpISa5gIugd+Sk1qu4T2K6Vv
         pxueczP8a0OV/PpYN4WUgG8dqRhBI8MFV8StKK5E0Tb3aFjMe37N3iJh4WDSMfZYGRmW
         yvuoBWfn2GORKyxXCRosuemXA+JJydloVJtQJdz7+C//lpYydv8/XOtR3M7YBl9GEjJZ
         unEzmP0DbUU5SViXEQ8NHPLrzdQlhUBV80DRts9GtvCSA8eMj/C/3Xof5ssLIiBjoBC3
         cesRGUs2FgCx9W0lMN8Eg5L4lPcdsqS+jfBeEzRUJsxFFFpuHFE/HfWsTE4gF86qCqYf
         E0DQ==
X-Gm-Message-State: ACrzQf36y+ZR2olZxvRk5RsuNDWFYBrY5Kss7VL+5T4JksMgIqdCicro
        7tKzrsm+pmhIT2KEVqswW2xHcQ==
X-Google-Smtp-Source: AMsMyM7G6DiwbBNmCjkksIIJU3z9hego5ls12eZiF2khgz8vJrQV4SqZBmGE5vdrGBN+XMPCqFxArg==
X-Received: by 2002:a05:6a00:cc9:b0:56c:b47:a73e with SMTP id b9-20020a056a000cc900b0056c0b47a73emr31672809pfv.19.1667508671021;
        Thu, 03 Nov 2022 13:51:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902d1d200b00186abb95bfdsm1122591plb.25.2022.11.03.13.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 13:51:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oqhB5-009uaB-WF; Fri, 04 Nov 2022 07:51:08 +1100
Date:   Fri, 4 Nov 2022 07:51:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Lukas Herbolt <lukas@herbolt.com>
Subject: Re: [PATCH] xfs: Print XFS UUID on mount and umount events.
Message-ID: <20221103205107.GG3600936@dread.disaster.area>
References: <l2a3zCkMp4g9yjUsn7MdftktWgI6xqW45ngK9WGU8-OQp_SWHRFpO5xZbUySxT3QRk1C4PyeLgqoVEY3VRRH_w==@protonmail.internalid>
 <f23e8ec8-b4cc-79d2-95b5-df4821878f91@sandeen.net>
 <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103133252.ycw5awieh7ckiih7@ovpn-192-135.brq.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 02:32:52PM +0100, Lukas Czerner wrote:
> On Tue, Nov 01, 2022 at 12:19:06PM -0500, Eric Sandeen wrote:
> > From: Lukas Herbolt <lukas@herbolt.com>
> > 
> > As of now only device names are printed out over __xfs_printk().
> > The device names are not persistent across reboots which in case
> > of searching for origin of corruption brings another task to properly
> > identify the devices. This patch add XFS UUID upon every mount/umount
> > event which will make the identification much easier.
> > 
> > Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> > [sandeen: rebase onto current upstream kernel]
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Hi,
> 
> it is a simple enough, nonintrusive change so it may not really matter as
> much, but I was wondering if there is a way to map the device name to
> the fs UUID already and I think there may be.
> 
> I know that udev daemon is constantly scanning devices then they are
> closed in order to be able to read the signatures. It should know
> exactly what is on the device and I know it is able to track the history
> of changes. What I am not sure about is whether it is already logged
> somewhere?
> 
> If it's not already, maybe it can be done and then we can cross
> reference kernel log with udev log when tracking down problems to see
> exactly what is going on without needing to sprinkle UUIDs in kernel log ?
> 
> Any thoughts?

Don't like it. Emitting the UUID on the fs mount/unmount log message
is a trivial change that has zero impact on anything as well as
being really easy for log scrapers to deal with.

Screwing around with udev to manage and/or find this correlationi
is ... unnecssarily awful.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
