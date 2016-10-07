Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34868 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757320AbcJGP0H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Oct 2016 11:26:07 -0400
MIME-Version: 1.0
In-Reply-To: <20161007095749.GI9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
 <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com>
 <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com> <20161007095749.GI9806@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Oct 2016 08:25:59 -0700
Message-ID: <CA+55aFzJHGVB5UvBifCvNX9YkDG1Soh+z9ED-wfF1OfOCPJPKA@mail.gmail.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: CAI Qian <caiqian@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, tj <tj@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Oct 7, 2016 at 2:57 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> So it's not "fixed" and instead I'm ignoring it.  If you spend any
> amount of time running lockdep on XFS you'll get as sick and tired
> of playing this whack-a-lockdep-false-positive game as I am.

Thanks for the background here. I'll try to remember it for the next
time this comes up, it doesn't help that lockdep reports are often a
bit cryptic to begin with (that "interrupt" thing certainly didn't
help).

             Linus
