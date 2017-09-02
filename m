Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:36310 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752787AbdIBXmb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 19:42:31 -0400
Received: by mail-pg0-f41.google.com with SMTP id r133so9572632pgr.3
        for <linux-xfs@vger.kernel.org>; Sat, 02 Sep 2017 16:42:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170902222003.GD10621@dastard>
References: <20170902215451.29265-1-raj.khem@gmail.com> <20170902222003.GD10621@dastard>
From: Khem Raj <raj.khem@gmail.com>
Date: Sat, 2 Sep 2017 16:42:00 -0700
Message-ID: <CAMKF1srdtshKkRAx0_3iybFfQv_fkHx-+KE+W2=JCZ7uJXQ+gw@mail.gmail.com>
Subject: Re: [PATCH] Rename progname as it is provided by libc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Sep 2, 2017 at 3:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Sep 02, 2017 at 02:54:51PM -0700, Khem Raj wrote:
>> Rename local variable progname to avoid a clash with libc
>> global symbols
>
> What libc is causing this problem?
>
> And why is it considered ok for that libc to pollute the global
> variable namespace with it's own internal variables?
>

I am building with -staitc -pie options

xfs_mdrestore.o: relocation R_ARM_REL32 against external or undefined
symbol `progname' can not be used when making a PIE executable;
recompile with -fPIC

libcs have __progname, So I will have to check where is progname coming from
probably an external header. I think renaming to avoid conflict is
good thing regardless.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
