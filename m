Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D14C77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 May 2023 05:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbjEXFmh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 01:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjEXFmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 01:42:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFAA189
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 22:42:34 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae4c5e12edso4533145ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 22:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684906954; x=1687498954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSM893A9frb/bcVz8jr5fMWm9hgsNl/gbMxFOpWGBR8=;
        b=qZtqwgYHG+bh7Y5MAquRx13Hj9VsSdYvpLxgVdhcEpWR28v8DGuupg0mTQg1tkY/y6
         +y3uQbHxyCn1Brr256dwioUPkuagRHGoNSSy37gQb3vCYPhby/hJ0qDYFwnOLvylR4DB
         2/QygJ5yK5hNFlsFlTSJNloCLYeiaJL438aBZQ+QFFGO4XvGO/e5C0xXQFw+FeDhACqx
         vdCT0LBCCLq+lx62GQjynpu3cpdvHNGypJixrPLimlEum7gbeYxCwA1G3ybjYmSSZfQp
         IvIYKtMKP/CzynwyJL6O1aGfZ/CEV3ONu/HrtNfW1+654N2+/j6EO8SC7t1eFY6AFNs3
         hntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684906954; x=1687498954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSM893A9frb/bcVz8jr5fMWm9hgsNl/gbMxFOpWGBR8=;
        b=Zt/MvVhtak/QZyLSgq+yAKkIcrshBIT1WtCugbSjiqrB8siv+oNkWIRSL5uj16860h
         eJE31e4S5JJX3pQ2RucHaBLjwdWlgZ7iUSZ9fvXjlUQWs5Nwz7atBndh2tfxiNy5DNmF
         z5F66g8ZGW1jscFop9Hr+RuDO8f4sBfdiclV81VxBax3K7Xfz2TUoix9PdlLCnrWxgzA
         GoZfPWFK9FjATDZA5GRrb+RtusBQscqJtzaM0gmL2/S0O0kXb5/J08kBBJ/GB+fbWIAl
         NJwQJVfG9gWLCD9NK4ixXrRZZKHT/IBMbtPwrk5jgVnnPUdEmV7QsIkUIO9qTWygcXrK
         u1Jg==
X-Gm-Message-State: AC+VfDxfHYlIkN/A6QeArruUfese700dcsTONrJ7eUrjKNLSeJJoRJzE
        HqmzQ2sxnVInqePZq/1x/O4wLCCx3lYbIGbXvSQ=
X-Google-Smtp-Source: ACHHUZ41yn7mfLXYYVEd6p+gkfRm303XZ2U8ycbvNJPZQbfz/n/FkVHnWRWlFUJAMs+qdyFZEzGEGg==
X-Received: by 2002:a17:902:a589:b0:1ad:dd21:2691 with SMTP id az9-20020a170902a58900b001addd212691mr17815981plb.10.1684906954339;
        Tue, 23 May 2023 22:42:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902e54200b001afb96f4b90sm4471101plf.274.2023.05.23.22.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 22:42:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q1hGY-003DV8-2J;
        Wed, 24 May 2023 15:42:30 +1000
Date:   Wed, 24 May 2023 15:42:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     Mike Pastore <mike@oobak.org>, linux-xfs@vger.kernel.org
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Message-ID: <ZG2jxuLHqeeEOBy4@dread.disaster.area>
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
 <20230502220258.GA3223426@dread.disaster.area>
 <CAP_NaWZEcv3B0nPEFguxVuQ8m93mO7te-bZDfwo-C8eN+f_KNA@mail.gmail.com>
 <20230502231318.GB3223426@dread.disaster.area>
 <ZG0w21hcYEl64joP@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZG0w21hcYEl64joP@fedora64.linuxtx.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 04:32:11PM -0500, Justin Forbes wrote:
> On Wed, May 03, 2023 at 09:13:18AM +1000, Dave Chinner wrote:
> > On Tue, May 02, 2023 at 05:13:09PM -0500, Mike Pastore wrote:
> > > On Tue, May 2, 2023, 5:03 PM Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > >
> > > > If you can find a minimal reproducer, that would help a lot in
> > > > diagnosing the issue.
> > > >
> > > 
> > > This is great, thank you. I'll get to work.
> > > 
> > > One note: the problem occured with and without crc=0, so we can rule that
> > > out at least.
> > 
> > Yes, I noticed that. My point was more that we have much more
> > confidence in crc=1 filesystems because they have much more robust
> > verification of the on-disk format and won't fail log recovery in
> > the way you noticed. The verification with crc=1 configured
> > filesystems is also known to catch issues caused by
> > memory corruption more frequently, often preventing such occurrences
> > from corrupting the on-disk filesystem.
> > 
> > Hence if you are seeing corruption events, you really want to be
> > using "-m crc=1" (default config) filesystems...
> 
> Upon trying to roll out 6.3.3 to Fedora users, it seems that we have a
> few hitting this reliabily with 6.3 kernels.  It is certainly not all
> users of XFS though, as I use it extensively and haven't run across it.

Has anyone who is hitting this bisected the failure to a commit
between 6.2 and 6.3?  Has anyone who is hitting it tried a 6.4-rc3
kernel to see if the problem is already fixed?

> The most responsive users who can reproduce all seem to be running on
> xfs filesystems that were created a few years ago, and some even can't
> reproduce it on their newer systems.  Either way, it is a widespread
> enough problem that I can't roll out 6.3 kernels to stable releases
> until it is fixed.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=2208553

I only see one person reporting the issue in that bug, but you
implied that it is a widespread and easily reproducable issue. Where
can I find all the other bug reports so I can look through them for
hints as to what might be causing this?

Right now I only have two individual reports of the issue - the OP
and the user that reported the above bug.  Both are a shutdown has
occurred due to a metadata corruption being detected when reading
metadata, followed by a shutdown in recovery caused by reading an
inode buffer that doesn't actually contain inodes.

Both reports are from filesystems on LVM, both likely have stripe
units defined. The fedora case is on RAID5+LVM, no idea what the OP
was using.  Neither reports give us a workload description that we
can use to attempt to reproduce this.

Given that it's not widespread (i.e. only a small quantity of users
are seeing this issue) and we have very little details to go on, we
can't even be certain that the corruption is a result of an XFS
issue - it may be a problem in the layers below XFS (lvm, md raid,
drivers, etc) and XFS is simply the first thing to trip over it...

We really need more information to make any progress here. Can you
ask everyone who has reported the issue to you to supply us with
with their full hardware config (CPU, memory, storage devices,
hardware RAID cache settings, storage configuration, lvm/crtyp/md
setup, filesystem configuration (xfs_info), mount options, etc) as
well as what they are doing on their machines and what workloads are
running in the background when the problem manifests.

We need to work out how to reproduce this issue so we can triage it,
but right now we have nothing we can actually work with....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
