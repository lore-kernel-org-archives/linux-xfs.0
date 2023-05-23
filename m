Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F56DC7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 21:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjEWVcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 17:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjEWVcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 17:32:16 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F9FB5
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 14:32:14 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39425ea8e1fso191728b6e.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 14:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1684877533; x=1687469533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xz/5c60tMUXOhL3uRY7jEBPxDlS57zQ1KWoXU9Gxx/s=;
        b=QRgmWcF8mYeqggJEXZZLsZo/F7VPmVZQGU/EyJ8r8nzhE4lkjIYujimMXPh9Iiuhh/
         Hz0l4A7XdGxbG4Aj6GgSxBWGfuDjLeSThwO1klon3n2dxtml83uP+pIMOklitN+oTW5T
         BrYLn+0UafuFUUOQxRjnXVC3xPNHGzBibARzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684877533; x=1687469533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xz/5c60tMUXOhL3uRY7jEBPxDlS57zQ1KWoXU9Gxx/s=;
        b=inWu7KkHnyHP6JQIaDr+zgCinrLqXeKGm6EgskWzU6lZJGoUXwoQ43MR3zeRu9y+Te
         9giXe+5sR/OorcyaXdgaprNtVohbuXHAZLuMpqmof4kGf5bUEAD6EWrayHmS3Kyq5KrU
         JcNCQ775FqjB+gCqs6uGMvf9l9Hii+D64aTZay5S8zE9+CgZh/3B8xe5IWhjConiQTsD
         j7EvwpoV+1GP66KKG0a9LPSYCYwg6pkqSEfycbbcSsIuX0dNlaKt+jLTB39tdkTqlhIO
         ArTqGhJQnreC2BRBmia3dy0BcPsF9wM0DnR3kjV7y2yWoJJv9Zh4lKzW2SLmbWswvAzZ
         1edQ==
X-Gm-Message-State: AC+VfDwukYl5+VnlJQlo8bJiM+TqUWZLWTWWg1drvzE4SGfeviu755BQ
        X77E0vqacGKp0y81IKc8lbyqmguYwskup1ML1tbW1IT/
X-Google-Smtp-Source: ACHHUZ5ZVCUTCsd2SXQBtgqIfZz/Fu/D/W7Jdl2sQNqQtNI/5NWUDGat+/5DTA5fvxJ23jB9qeg70Q==
X-Received: by 2002:a05:6808:2884:b0:38b:e6:3d95 with SMTP id eu4-20020a056808288400b0038b00e63d95mr9103451oib.40.1684877533649;
        Tue, 23 May 2023 14:32:13 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id a22-20020a056830009600b006af92419e70sm835141oto.70.2023.05.23.14.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 14:32:13 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 23 May 2023 16:32:11 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Mike Pastore <mike@oobak.org>, linux-xfs@vger.kernel.org
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Message-ID: <ZG0w21hcYEl64joP@fedora64.linuxtx.org>
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
 <20230502220258.GA3223426@dread.disaster.area>
 <CAP_NaWZEcv3B0nPEFguxVuQ8m93mO7te-bZDfwo-C8eN+f_KNA@mail.gmail.com>
 <20230502231318.GB3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502231318.GB3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 03, 2023 at 09:13:18AM +1000, Dave Chinner wrote:
> On Tue, May 02, 2023 at 05:13:09PM -0500, Mike Pastore wrote:
> > On Tue, May 2, 2023, 5:03 PM Dave Chinner <david@fromorbit.com> wrote:
> > 
> > >
> > > If you can find a minimal reproducer, that would help a lot in
> > > diagnosing the issue.
> > >
> > 
> > This is great, thank you. I'll get to work.
> > 
> > One note: the problem occured with and without crc=0, so we can rule that
> > out at least.
> 
> Yes, I noticed that. My point was more that we have much more
> confidence in crc=1 filesystems because they have much more robust
> verification of the on-disk format and won't fail log recovery in
> the way you noticed. The verification with crc=1 configured
> filesystems is also known to catch issues caused by
> memory corruption more frequently, often preventing such occurrences
> from corrupting the on-disk filesystem.
> 
> Hence if you are seeing corruption events, you really want to be
> using "-m crc=1" (default config) filesystems...

Upon trying to roll out 6.3.3 to Fedora users, it seems that we have a
few hitting this reliabily with 6.3 kernels. It is certainly not all
users of XFS though, as I use it extensively and haven't run across it.
The most responsive users who can reproduce all seem to be running on
xfs filesystems that were created a few years ago, and some even can't
reproduce it on their newer systems.  Either way, it is a widespread
enough problem that I can't roll out 6.3 kernels to stable releases
until it is fixed.

https://bugzilla.redhat.com/show_bug.cgi?id=2208553

Justin

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
