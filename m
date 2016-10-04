Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51114 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbcJDO2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Oct 2016 10:28:09 -0400
Date: Tue, 4 Oct 2016 15:28:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
Message-ID: <20161004142805.GX19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
 <1415238593.811146.1475257337058.JavaMail.zimbra@redhat.com>
 <20161003014218.GS19539@ZenIV.linux.org.uk>
 <19064316.41568.1475503587628.JavaMail.zimbra@redhat.com>
 <37510012.118174.1475526739119.JavaMail.zimbra@redhat.com>
 <20161003203539.GW19539@ZenIV.linux.org.uk>
 <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209071853.342152.1475587775353.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

On Tue, Oct 04, 2016 at 09:29:35AM -0400, CAI Qian wrote:

> > Is there any way to record the sequence of syscalls leading to that?
> > 
> Yes, a bit long shot though.
> 
> http://people.redhat.com/qcai/tmp/trinity-child113.log

;-/

Not enough information, unfortunately (descriptor in question opened
outside of that log, sendfile(out_fd=578, in_fd=578, offset=0x7f8318a07000,
count=0x3ffc00) doesn't tell what *offset was before the call) ;-/

Anyway, I've found and fixed a bug in pipe_advance(), which might or might
not help with those.  Could you try vfs.git#work.splice_read (or #for-next)
and see if these persist?
