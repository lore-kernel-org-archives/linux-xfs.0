Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33994 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbcIHSBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 14:01:24 -0400
Received: by mail-oi0-f66.google.com with SMTP id x125so3370783oia.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 11:01:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 11:01:23 -0700
Message-ID: <CA+55aFyfDNR9vkQ3sZMhLcoizE5VCLJDVukyPk=gbhDz9aNLgA@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 8:29 AM, CAI Qian <caiqian@redhat.com> wrote:
> Right. FYI, revert the commit below fixes the regression,
>
> 8d02076 : ->splice_write() via ->write_iter()

I guess you didn't actually revert that, because so much else has
changed. So you just tested the pre- and post- state of that commit?

It does look like that commit is just buggy, exactly because XSF was
the only user of -generic_file_splice_write() in order to be able to
do the filesystem locks *before* taking the pipe lock.

Al? I wonder if we could just re-introduce xfs_file_splice_write()
(except with the modern iter-based interface)?

Looking at not holding the pipe lock, that really does seem very bad,
because it would require us to:

 (a) play the ref-count games with each page

 (b) make concurrent splice writers have very subtle semantics

I'm not sure (b) is a big issue, because concurrent splice writers
already have random ordering, but at least right now they'd have
non-overlapping data accesses rather than possibly splicing the same
data twice (and some data not at all).

The basic issue with splice and xfs is that right now our splice
interface *forces*:

 - generic_file_splice_read() when called by a filesystem will take
the filesystem locks *first*, and the pipe lock second (ie
xfs_file_splice_read)

 - iter_file_splice_write() forces the reverse ordering.

So it really is our splice helpers that do things in fundamentally the
wrong order.

Other filesystems don't seem to have that extra filesystem lock that shows this.

Ideas?

             Linus
