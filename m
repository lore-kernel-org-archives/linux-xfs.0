Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07B4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Feb 2022 21:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbiBGVmm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239433AbiBGVmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 16:42:42 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DA6C061355
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 13:42:40 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id v47so19172593ybi.4
        for <linux-xfs@vger.kernel.org>; Mon, 07 Feb 2022 13:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ol6kQEVKreQvAlKJ0J8z4+R//rXWOdbyA7WHatk5aCk=;
        b=ZQ0QnANUpOlady+g2k+6qep2xujRiSdWpsh6G1cLaEGpMgBuqG2aMMeeCf1D9Jb69A
         7W65rbwhgowEwjvMzast15IKIHw1945B0XzroQAFSMp7ylMV4VSj569Hdm7woz8UGoK1
         oOjy8yooqTfMCSfh7+SWCr/l1n4DTSTJ15unC9YyujCpnVlCmAdfZj20R/pkbdUtRntT
         hebmmftjtfLuWQxDlFGi/EZUgIaxb3/79RPqDIBtglRZzyFy3lJY7c8HDNQwCxcjr0qs
         ehfcWw6WAax+ZCuHiRWh8mLpIYhqm8DQldlV97m22NwISn7F91uuJWxfBtj8dB9ApqDe
         pY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ol6kQEVKreQvAlKJ0J8z4+R//rXWOdbyA7WHatk5aCk=;
        b=WTh6WDWItnCDJRp9hdJtMcQ7O7s4F8DGqTzOonLuQN2EoXAY2qGusVBumd+QIUU/t5
         P3CvVOZ0DD4RROObTTQ5isj1v1faxLubN7/ioyaVWL7/iuh9G/no+oIcRlRGZ8z41rHv
         CjMOUh6t63BuYWRd7tkIxmMtv69x0OGtb3kt8QFgNhIC5sBigLI6bfutVk7FIhElrrOR
         KVt/uyW/jDEDWpGdjaeJdC+1XuiW/R3YzsjEEMFpAzwz9vlqHByI/OKfd4jJmrgVZhkl
         x4l5EG1uQ6gL/5Vr3jqQ5+dihI1gaciOhTC+YEv5jffi4E70cbSuUf1lb0G8KqZLhRWO
         VTfQ==
X-Gm-Message-State: AOAM532BuKusOO3G5I9c5n4avYZvh5NSlVstaXB7KeR3maTgLE3H7mhU
        3cjaAZpyb9FZoeV6m/vGnaAGFPcNzgTpkPIo+vtCm9k60NA=
X-Google-Smtp-Source: ABdhPJz0t9zukBYn8wBsmDAwbmgaGMaZaCaNky5b8fnZLhbw5UhJRHry1RC8Ff+6ybJiF2/tOFOIaSxpO57xqLVIQwg=
X-Received: by 2002:a81:3795:: with SMTP id e143mr2002152ywa.514.1644270159820;
 Mon, 07 Feb 2022 13:42:39 -0800 (PST)
MIME-Version: 1.0
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area> <CAA43vkV_nDTJjXqtWw-jpc8KVWwa2jQ8-2bNbNJZBcsBSHV8dw@mail.gmail.com>
 <20220202024430.GZ59729@dread.disaster.area> <20220202074242.GA59729@dread.disaster.area>
 <CAA43vkXxyHmQdu-GqVukmeOqEh8g-xJDCDD6sx7t4f-MVn+BBA@mail.gmail.com>
 <CAA43vkX6au8gmO97otOT4LQOzspomodGSO__qPMmFozzMsrRQg@mail.gmail.com>
 <CAA43vkUFW3Y_0L7dFc+iAySdf4j3cX4M9Xoz+3eU4raoavmnew@mail.gmail.com>
 <20220202220559.GB59729@dread.disaster.area> <CAA43vkXsEydXtf8urxSBKo2WN4arbMDKw3+8mA7YSAJ9ZJwg9w@mail.gmail.com>
 <20220206223421.GD59729@dread.disaster.area>
In-Reply-To: <20220206223421.GD59729@dread.disaster.area>
From:   Sean Caron <scaron@umich.edu>
Date:   Mon, 7 Feb 2022 16:42:28 -0500
Message-ID: <CAA43vkWYtA2XfvvM3Z74NgyzimE3qztpK3VMjsATDBc4HvZ7gA@mail.gmail.com>
Subject: Re: [PATCH] metadump: handle corruption errors without aborting
To:     Dave Chinner <david@fromorbit.com>, Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

Your suggestion was right on. I ran xfs_metadump with the "-a"
parameter and it was able to finish without any more showstoppers.

Thanks!

Sean


On Sun, Feb 6, 2022 at 5:34 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Feb 02, 2022 at 06:45:34PM -0500, Sean Caron wrote:
> > Sure! Please see gdb backtrace output below.
> >
> > (gdb) bt
> > #0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:51
> > #1  0x00007f289d5c7921 in __GI_abort () at abort.c:79
> > #2  0x00007f289d610967 in __libc_message (action=action@entry=do_abort,
> >     fmt=fmt@entry=0x7f289d73db0d "%s\n") at ../sysdeps/posix/libc_fatal.c:181
> > #3  0x00007f289d6179da in malloc_printerr (
> >     str=str@entry=0x7f289d73f368 "malloc_consolidate(): invalid chunk
> > size") at malloc.c:5342
> > #4  0x00007f289d617c7e in malloc_consolidate
> > (av=av@entry=0x7f289d972c40 <main_arena>)
> >     at malloc.c:4471
> > #5  0x00007f289d61b968 in _int_malloc (av=av@entry=0x7f289d972c40 <main_arena>,
> >     bytes=bytes@entry=33328) at malloc.c:3713
> > #6  0x00007f289d620275 in _int_memalign (bytes=32768, alignment=512,
> > av=0x7f289d972c40 <main_arena>)
> >     at malloc.c:4683
>
> Ok, so there's nothing wrong with the memalign() parameters being
> passed to glibc, so something has previously caused heap corruption
> that is only now being tripped over trying to allocate memory for a
> new inode cluster buffer.
>
> I wonder if it was the zeroing of the "unused" part of the inode
> data fork area that did this (perhaps a corrupt inode fork offset?)
> so maybe it is worth turning off the stale data zeroing function
> (-a to copy all metadata blocks) so that it doesn't try to interpret
> corrupt metadata to determine what is unused areas or not...
>
> If that does get past this inode, then we'll need to make the
> stale region zeroing a lot more careful and avoid zeroing in the
> case of badly broken metadata.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
