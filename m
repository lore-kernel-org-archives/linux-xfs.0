Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35140 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbcIICWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:22:24 -0400
Received: by mail-oi0-f68.google.com with SMTP id 2so7673105oif.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 19:22:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160909015324.GD30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk> <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard> <20160908235521.GL2356@ZenIV.linux.org.uk> <20160909015324.GD30056@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 19:22:22 -0700
Message-ID: <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 6:53 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> So if we race iwth a truncate, the pages in spd.pages[] that are
> beyond the new EOF may or may not have been removed from the page
> cache.

So I'm not sure why we'd need to care?

The thing is, if the splicer and the hole puncher aren't synchronized,
then there is by definition no "before/after" point.

The splice data may be "stale" in the sense that we look at the page
after the hole punch has happened and the page no longer has a
->mapping associated with it, but it is equally valid to treat that as
just a case of "the read happened before the hole punch".

Put another way: it's not wrong to use the ostensibly "stale" data, it
just means that the splice acts as if the IO had happened before the
data became stale.

The whole point of "splice" is for the pipe to act as a in-kernel
buffer. So a splice does not *synchronize* the two end-points, quite
the reverse: it is meant to act as a "read + write" with the pipe
itself being the buffer in between (and because it's a in-kernel
buffer rather than a user space buffer like a real read()+write() pair
would be, it means that we then *can* do things like zero-copy, but
realistically it really aims for "one-copy" rather than "two-copy".

So if the splice buffer contains stale values, then that's exactly
similar to a user space application having done a "read()" of old
data, then the file is truncated (or hole punched), and then the
application does a "write()" on that data. The target clearly sees
*different* data than is on the filesystem at that point, but since
"complete synchronization" has never been a guarantee of splice() in
the first place, that's just not a downside.

If an application expects to have "splice()" give some kind of data
consistency guarantees wrt people writing to the file (or with
truncate or hole punching), then the application would have to
implement that serialization itself. Splice in itself does not do
serialization, it does data copying.

            Linus
