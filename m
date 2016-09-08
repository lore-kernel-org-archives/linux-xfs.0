Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33548 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbcIHSSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 14:18:46 -0400
Received: by mail-oi0-f50.google.com with SMTP id y2so83995879oie.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 11:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 11:18:45 -0700
Message-ID: <CA+55aFyPye0WM3RYx=K_eEy=xWbYvMTFtG3Hc1U0_BU4bMMPnA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 11:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So the problem really is that the vfs layer seems to simply not allow
> the filesystem to do any locking around the generic page cache helper
> functions. And XFS really wants to do that.

Hmm.

I wonder if we could just take the pipe lock *much* earlier at the
splice() layer? Do it before any callbacks to the low-level
filesystems, not inside the "generic" splice helpers at all?

That would clean up a ton of crap.

The *one* reason that seems impossible right now seems to be that we
use "pipe_wait()" in our splice ops. And "pipe_wait()" drops and
retakes the pipe lock over the waiting.

BUT.

What if we got rid of all the pipe-wait crap entirely, and just made
all the splice routines return EAGAIN instead of waiting? And then do
the pipe_wait() at the higher level, outside the filesystem callback
code, and outside the low-level generic helpers?

Maybe that pipe_wait() movement doesn't really work for some reason
that I didn't look at, but that would really help make the locking
enormously simpler. And then the pipe lock would *obviously* be the
outermost lock, and we'd get rid of all the issues with filesystem
lock ordering.

               Linus
