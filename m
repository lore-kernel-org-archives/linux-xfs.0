Return-Path: <SRS0=qbJ3=ZP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6693C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 16:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0FAE2072E
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Nov 2019 16:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="DekZD++o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKWQ4o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Nov 2019 11:56:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41515 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfKWQ4o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 Nov 2019 11:56:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id b18so12339651wrj.8
        for <linux-xfs@vger.kernel.org>; Sat, 23 Nov 2019 08:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KY52KTxwdopn/jI70RaOZOgdaHMHcfXz8p53IpMerl8=;
        b=DekZD++om05hlPralzR3pxn76QjfkEkNoaus4ZOEiplq6rEt4y2/wvG4pZJqynVW87
         Obq5CIxkJvIv4kiZsReP67A5+O75mIc6lQbzhCVLVGE6l3Pr3YKITMFh4Jgsp9kW9b42
         8yABENOqjm+rQuw5+EdSBvwRbN33ZYZr3uXcsAgLSfj3WDfRYMOePSdN5sBGXWjB5ihO
         BFzrMX5Fld9N6baDtVei1P/MzVzprk/OKD0sUkHC96JJGL7GpTj5zoWu7aUCPno5qNGU
         OiECViNVZd2HCX6NWCBoLHSVGzWKYvKhUXQb0F/4KcucrnUqqdp2JY2QlM9iHokQb/Og
         e2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KY52KTxwdopn/jI70RaOZOgdaHMHcfXz8p53IpMerl8=;
        b=b8CW0uX7iy9x6BEDVgfL8UTB3zirpwRkaAmKLgvGBTUS8/YZP69DJn2qtHnX2pfSuL
         VnrOjOjYejbFG8HJKWyMfrC+PvQZ47LH51sXUq1U6hyqMyq7XSrucEL/gjKjZsV47z75
         MZG6AVJAv2BOZbof9WODo8WNwRRQ4HsDmN645+eoz3UmWG+15plJuUl/ZyTwo6BrKKtS
         sMNAU5QftcYpPXmk+tbxfGu1n7RrvGUBcRUe1eQFyFzWkGbTsMJ2e5QZl3Ib9BJTVVQI
         33LNhiugrGUsErYBBf8k23MZ9fEP51LYMHV5VCKaEaZWVJf6hb0tdxB6gYJwzxPwzhEL
         YnJA==
X-Gm-Message-State: APjAAAVOVsm5ixsvrfcEWl9/XXwlVIVRCs2K0luGvYHgTM8cxOt5u1yP
        XUNUdsGrKMWIzLcRv7QPNAG9rNu6X468VnYB9ULG0g==
X-Google-Smtp-Source: APXvYqyChJIgir0vEJzyUIxRT6iANI+4X0h8RZpJgnC+BNG2vY25TM7ylFMHUrgI8/kIelsoHVWaDIiJPvIr+7gcmAA=
X-Received: by 2002:adf:f547:: with SMTP id j7mr23820073wrp.69.1574528202653;
 Sat, 23 Nov 2019 08:56:42 -0800 (PST)
MIME-Version: 1.0
References: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
In-Reply-To: <a3ab6c1b-1a69-5926-706f-1976b20d38a8@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 23 Nov 2019 09:56:26 -0700
Message-ID: <CAJCQCtSXhX8VFYwp9j7RXD3_CHPMC83D6W-mCS80byxmor1PCg@mail.gmail.com>
Subject: Re: Bug when mounting XFS with external SATA drives in USB enclosures
To:     Pedro Ribeiro <pedrib@gmail.com>
Cc:     xfs list <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 8:21 PM Pedro Ribeiro <pedrib@gmail.com> wrote:
>
> Hi,
>
> I have been trying to find out the cause of a bug that's affecting all
> my external hard drive backups.
>
> I have three external drives, in different USB enclosures, with the same
> configuration and the same problem.
>
> Drive A: 2TB HDD, USB3 Seagate self enclosed drive
> Drive B: 4TB HDD, USB3 Toshiba self enclosed drive
> Drive C: 512MB SSD, Crucial MX500 with USB-C third party enclosure
>
> All of the drives have a dm-crypt / LUKS on top, with a XFS partition
> inside. Drive A is a few months old, Drive B is about 3 years old, drive
> C about 1.5 years old. They are seldomly used (they're backup drives) so
> they are all fine mechanically.
>
> The problem is when I attach any of the drives, enter the LUKS password
> and then try to mount, this happens:
> [   66.039772] XFS (dm-0): Mounting V5 Filesystem
> [   66.060934] XFS (dm-0): log recovery read I/O error at daddr 0x0 len
> 8 error -5
> [   66.060939] XFS (dm-0): empty log check failed
> [   66.060940] XFS (dm-0): log mount/recovery failed: error -5
> [   66.061064] XFS (dm-0): log mount failed
>
> No matter what I do, using all the recovery tools, etc, it's impossible
> to mount...
>
> The thing is that is there is NOTHING wrong with these drives. The above
> happens when running my specific, stripped and locked down kernel config.
>
> If I take Debian's 4.19 kernel config, put it on a 5.3.11 tree, run make
> oldconfig and just answer the defaults on all prompts, all of the drives
> above mount fine:
> [   46.184068] XFS (dm-0): Mounting V5 Filesystem
> [   46.412566] XFS (dm-0): Ending clean mount
>
> I hit this problem recently when I moved from kernel 4.18.20, which I
> was using for a long time, to 5.3.X. In kernel 4.18.20, I did not have
> any problems with my specific stripped down config.
>
> I have asked for help in IRC at #xfs, and one of the guys there (ailiop)
> was very helpful in trying to track down the problem, but we ultimately
> failed, hence why I'm asking for help here.
>
> I'm attaching the kernel configs and the dmesg outputs. There is nothing
> obvious in the kernel config diff that should make this happen... it's a
> very weird bug.
>
> Regards,
> Pedro

What about checking for differences in kernel messages between the
stripped down and stocked kernel, during device discovery. That is
connect no drives, boot the stripped kernel with the problem, connect
one of the problem USB devices, record the kernel messages that
result. Repeat that with the stock Debian kernel that doesn't exhibit
the bug.

My guess is this is some obscure USB related bug. There are a ton of
bugs with USB enclosure firmware, controllers, and drivers.

Also, is this USB enclosure directly connected to the computer? Or to
a powered hub? I have inordinate problems with USB enclosures directly
connected to an Intel NUC, but when connected to a Dyconn USB hub with
external power source, the problems all go away. And my understanding
is the hub doesn't just act like a repeater. It pretty much rewrites
the entire stream. So there's something screwy going on either with
the Intel controller I have, or the USB-SATA bridge chip, that causes
confusing that the hub eliminates.

And it may be that your stripped down kernel has turned off some
obscure USB related error checking or mode switching that this
particular setup needs.


-- 
Chris Murphy
