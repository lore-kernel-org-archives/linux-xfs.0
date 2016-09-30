Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35156 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbcI3HaX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 03:30:23 -0400
Received: by mail-oi0-f66.google.com with SMTP id n202so6691251oig.2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Sep 2016 00:30:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160929225003.GQ19539@ZenIV.linux.org.uk>
References: <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk> <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk> <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924040117.GP2356@ZenIV.linux.org.uk> <CAELBmZDpm635PcTPQfnpLGs2P4bfT6JU+DEuFu9pBut=uzOLHw@mail.gmail.com>
 <20160929225003.GQ19539@ZenIV.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 Sep 2016 09:30:21 +0200
Message-ID: <CAJfpegs9He0bWX3VWkr2EY-7X3-pAhNAUT=mQad-zxtWkQt_SQ@mail.gmail.com>
Subject: Re: [PATCH 10/12] new iov_iter flavour: pipe-backed
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Sep 30, 2016 at 12:50 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Sep 29, 2016 at 10:53:55PM +0200, Miklos Szeredi wrote:
>
>> The EFAULT logic seems to be missing across the board.  And callers
>> don't expect a zero return value.  Most will loop indefinitely.
>
> Nope.  copy_page_to_iter() *never* returns -EFAULT.  Including the iovec
> one - check copy_page_to_iter_iovec().  Any caller that does not expect
> a zero return value from that primitive is a bug, triggerable as soon as
> you feed it an iovec with NULL ->iov_base.

Right.

I was actually looking at iov_iter_get_pages() callers...

Thanks,
Miklos
