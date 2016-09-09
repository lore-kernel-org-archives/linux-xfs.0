Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36338 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbcIICuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:50:06 -0400
Received: by mail-oi0-f48.google.com with SMTP id x125so55670800oia.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 19:50:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160909023452.GO2356@ZenIV.linux.org.uk>
References: <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <20160909023452.GO2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 19:50:05 -0700
Message-ID: <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 7:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> IDGI.  Suppose we do splice from file to pipe.  Everything had been in
> page cache, so we want to end up with pipe_buffers containing references
> to those page cache pages.  How do you propose to do that without having
> grabbed references to them?  What's to keep them from being freed by the
> time we get to reading from the pipe?

So that's obviously what we already do. That is, after all, why splice
doesn't actually keep track of "pages", it keeps track of "struct
pipe_buffer". So each page has not just offset/len associated with it,
but also a get/release/verify operation block and some flags with them
(it might not be a page-cache page, so in some cases it might be a skb
or something that needs different release semantics).

And if you can make the iterator basically interface with turning the
page/offset/len directly into a "struct pipe_buffer" and not do any
extra reference operations, then it actually would work very well.

But the way I read your description of what you'd do I just expected
you to have an extra "get/put" ref at the iterator level.

Maybe I misunderstood. I'd love to see a rough patch.

                           Linus
