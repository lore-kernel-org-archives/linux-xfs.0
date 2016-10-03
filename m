Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39826 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbcJCUfn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 16:35:43 -0400
Date: Mon, 3 Oct 2016 21:35:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161003203539.GW19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
 <20161003014218.GS19539@ZenIV.linux.org.uk>
 <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
 <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Mon, Oct 03, 2016 at 04:32:19PM -0400, CAI Qian wrote:
> > It is pretty reproducible so far by just running the trinity from a docker
> > container backed by overlayfs/xfs.
> > 
> > # su - test
> > $ trinity
> Also, AFACIT, this is NOT reproducible on v4.8 mainline, but only with this
> splice_read reworked branch of vfs tree.

I would be very surprised if mainline had somehow managed to trip sanity
checks added in vfs tree ;-)

Is there any way to record the sequence of syscalls leading to that?
