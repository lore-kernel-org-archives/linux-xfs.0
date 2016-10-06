Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33605 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942018AbcJFRBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2016 13:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com>
 <20161005153014.GC26977@htj.duckdns.org> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk> <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com> <1149670394.870034.1475770286233.JavaMail.zimbra@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Oct 2016 10:00:08 -0700
Message-ID: <CA+55aFz28kQUAYoSFzvEpq5MkYHNcKx2KWP-kpruuyWe7AEY2Q@mail.gmail.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, tj <tj@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Oct 6, 2016 at 9:11 AM, CAI Qian <caiqian@redhat.com> wrote:
>
>>
>> Wait. There is also a lockep happened before the xfs internal error as well.
> Some other lockdep this time,

This one looks just bogus.

> [ 4872.569797]  Possible unsafe locking scenario:
> [ 4872.569797]
> [ 4872.576401]        CPU0
> [ 4872.579127]        ----
> [ 4872.581854]   lock(&xfs_nondir_ilock_class);
> [ 4872.586637]   <Interrupt>
> [ 4872.589558]     lock(&xfs_nondir_ilock_class);

I'm not seeing that .lock taken in interrupt context.

I'm wondering how many of your reports are confused by earlier errors
that  happened.

               Linus
