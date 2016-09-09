Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36852 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcIIC0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:26:46 -0400
Received: by mail-oi0-f45.google.com with SMTP id x125so54555195oia.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 19:26:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard> <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 19:26:44 -0700
Message-ID: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 7:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 8, 2016 at 6:53 PM, Dave Chinner <david@fromorbit.com> wrote:
>>
>> So if we race iwth a truncate, the pages in spd.pages[] that are
>> beyond the new EOF may or may not have been removed from the page
>> cache.
>
> So I'm not sure why we'd need to care?

Side note, just to clarify: I'm not actually convinced that turning
things into page/offset/len tuples is the right thing to do.

I still suspect that the reference count updates on each page may not
be a good idea.  I suspect we'd easily be better off trying to do
everything under the pipe lock exactly so that we can *avoid* having
to do per-page "increment ref-count, then decrement it again". But the
locking would have to be changed radically for us to be able to do
that (and the only sane model ios, I think, to make pipe_lock be the
outermost lock, and outside *every* downcall)

               Linus
