Return-Path: <SRS0=zudJ=42=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BA8C10DCE
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 01:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7873E206DB
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Mar 2020 01:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SZv+1Vp2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCIBcz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Mar 2020 21:32:55 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:46070 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCIBcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Mar 2020 21:32:55 -0400
Received: by mail-ot1-f49.google.com with SMTP id f21so7989212otp.12
        for <linux-xfs@vger.kernel.org>; Sun, 08 Mar 2020 18:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NM+3yHHb1GYn71sq9okYNjTtppi1tsJhjgjnaUztLrQ=;
        b=SZv+1Vp23plc5jC112QHuW2C9EyNuQ2nSiDq1GFJ3qRN3RMNcSMq4y+Wq8eeKkXwy3
         +ckHtehMoQEJAHlGbSWYfNJEjtdd0LPFTGK/1oJcI7D+KZs/BQ+t+dLjaT5aaqK5/QDJ
         JJfVbNps2sFyqbHRtzktyEtzlVnjsS3scXfS5SeB5sbC/w/FrcI+s7Px2QWZPE4CsnlG
         Be6B2HZRCDcD4Lzc5Yu0DxhzoNsoVPOmf4n7xw226EIE1nQfZ/LhHL+61DG6qavOnymI
         97JzqXFU6gL5vWP+b/PHKNy43Uby6dSH6rBLUb23KbSASPyFGDYUlShJYmyaCCAEQR7e
         9hIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NM+3yHHb1GYn71sq9okYNjTtppi1tsJhjgjnaUztLrQ=;
        b=BCadxE67Aaw9DdRNZsi14nmqov8Y1aGnNw4SE1IUSgfoJ/skKxDv3ou8aITTVtw3vL
         NgEO3PwrVX6xBV7ba4ckjfNhGgnTbhm4SFBfN5pVJi8d0afy+d3DgBRILocXVmYV/rcN
         KUZDxDedPQZzaAhykZNieNNOtaiBjPQO6cfRO0yNYHihRKLrP2FFQQZtx2IJWqwF7ke4
         ZrYlsSeb93yhx5Q/+VFJNxZfwyBJr5wPtcD5dBs7LgvLJguJOvBU6D/WQt6BCIi6SJEB
         fL5tDMMtZt7QEwrC/e9qfHj6o1Kkz7/jV6U9SBNqXkstnIMCGUatPyVpViNgGBeFiPP0
         OY/w==
X-Gm-Message-State: ANhLgQ1joIh7hefTvbsvX2vFqw/00M3ws1BNREZ0LS1yVCpo/RJfunLW
        nxo7T9uCPTyzplXXW66KEwopj2yjjTngBy3zQuw=
X-Google-Smtp-Source: ADFU+vsQJBWz+c+eR5P/WRtiCtb0mBQ05qpsWuz/Ab3wq9jj6Hkg47EydMLI6rjxI7/dZxHBUmDCtebshje0ykQgRp0=
X-Received: by 2002:a05:6830:1645:: with SMTP id h5mr11699580otr.317.1583717574675;
 Sun, 08 Mar 2020 18:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAHgh4_+15tc6ekqBRHqZrdDmVSfUmMpOGyg_9kWYQ7XOs7D+eQ@mail.gmail.com>
 <CAHgh4_+p0okyt3kC=6HOZb6dr8o3dxqQARoFB-LkR9x-tGuvSA@mail.gmail.com> <20200308222646.GL10776@dread.disaster.area>
In-Reply-To: <20200308222646.GL10776@dread.disaster.area>
From:   Bart Brashers <bart.brashers@gmail.com>
Date:   Sun, 8 Mar 2020 18:32:41 -0700
Message-ID: <CAHgh4_K_01dS2Z-2QwR2dc5ZDz9J2+tG6W-paOeneUa6G_h9Kw@mail.gmail.com>
Subject: Re: mount before xfs_repair hangs
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks Dave!

We had what I think was a power fluctuation, and several more drives
went offline in my JBOD. I had to power-cycle the JBOD to make them
show "online" again. I unmounted the arrays first, though.

After doing the "echo w > /proc/sysrq-trigger" I was able to mount the
problematic filesystem directly, no having to read dmesg output. If
that was due to the power cycling and forcing logicalvolumes to be
"optimal" (online) again, I don't know.

I was able to run xfs_repair on both filesystems, and have tons of
files in lost+found to parse now, but at least I have most of my data
back.

Thanks!

Bart


Bart
---
Bart Brashers
3039 NW 62nd St
Seattle WA 98107
206-789-1120 Home
425-412-1812 Work
206-550-2606 Mobile


On Sun, Mar 8, 2020 at 3:26 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Mar 08, 2020 at 12:43:29PM -0700, Bart Brashers wrote:
> > An update:
> >
> > Mounting the degraded xfs filesystem still hangs, so I can't replay
> > the journal, so I don't yet want to run xfs_repair.
>
> echo w > /proc/sysrq-trigger
>
> and dump demsg to find where it is hung. If it is not hung and is
> instead stuck in a loop, use 'echo l > /proc/sysrq-trigger'.
>
> > I can mount the degraded xfs filesystem like this:
> >
> > $ mount -t xfs -o ro,norecovery,inode64,logdev=/dev/md/nvme2
> > /dev/volgrp4TB/lvol4TB /export/lvol4TB/
> >
> > If I do a "du" on the contents, I see 3822 files with either
> > "Structure needs cleaning" or "No such file or directory".
>
> TO be expected - you mounted an inconsistent filesystem image and
> it's falling off the end of structures that are incomplete and
> require recovery to make consistent.
>
> > Is what I mounted what I would get if I used the xfs_repair -L option,
> > and discarded the journal? Or would there be more corruption, e.g. to
> > the directory structure?
>
> Maybe. Maybe more, maybe less. Maybe.
>
> > Some of the instances of "No such file or directory" are for files
> > that are not in their correct directory - I can tell by the filetype
> > and the directory name. Does that by itself imply directory
> > corruption?
>
> Maybe.
>
> It also may imply log recovery has not been run and so things
> like renames are not complete on disk, and recvoery would fix that.
>
> But keep in mind your array had a triple disk failure, so there is
> going to be -something- lost and not recoverable. That may well be
> in the journal, at which point repair is your only option...
>
> > At this point, can I do a backup, either using rsync or xfsdump or
> > xfs_copy?
>
> Do it any way you want.
>
> > I have a separate RAID array on the same server where I
> > could put the 7.8 TB of data, though the destination already has data
> > on it - so I don't think xfs_copy is right. Is xfsdump to a directory
> > faster/better than rsync? Or would it be best to use something like
> >
> > $ tar cf - /export/lvol4TB/directory | (cd /export/lvol6TB/ ; tar xfp -)
>
> Do it how ever you are confident the data gets copied reliably in
> the face of filesystem traversal errors.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
