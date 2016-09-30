Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:33283 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932646AbcI3NdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 09:33:03 -0400
Date: Fri, 30 Sep 2016 09:32:53 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <2131586457.763354.1475242373422.JavaMail.zimbra@redhat.com>
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com> <20160914031648.GB2356@ZenIV.linux.org.uk> <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com> <20160914042559.GC2356@ZenIV.linux.org.uk> <20160917082007.GA6489@ZenIV.linux.org.uk> <20160917190023.GA8039@ZenIV.linux.org.uk> <20160923190032.GA25771@ZenIV.linux.org.uk>
Subject: Re: [RFC][CFT] splice_read reworked
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "Al Viro" <viro@ZenIV.linux.org.uk>
> To: "Linus Torvalds" <torvalds@linux-foundation.org>
> Cc: "Dave Chinner" <david@fromorbit.com>, "CAI Qian" <caiqian@redhat.com>, "linux-xfs" <linux-xfs@vger.kernel.org>,
> xfs@oss.sgi.com, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org
> Sent: Friday, September 23, 2016 3:00:32 PM
> Subject: [RFC][CFT] splice_read reworked
> 
> The series is supposed to solve the locking order problems for
> ->splice_read() and get rid of code duplication between the read-side
> methods.
> 	pipe_lock is lifted out of ->splice_read() instances, along with
> waiting for empty space in pipe, etc. - we do that stuff in callers.
> 	A new variant of iov_iter is introduced - it's backed by a pipe,
> copy_to_iter() results in allocating pages and copying into those,
> copy_page_to_iter() just sticks a reference to that page into pipe.
> Running out of space in pipe yields a short read, as a fault in iovec-backed
> iov_iter would have.  Enough primitives are implemented for normal
> ->read_iter() instances to work.
> 	generic_file_splice_read() switched to feeding such iov_iter to
> ->read_iter() instance.  That turns out to be enough to kill almost all
> ->splice_read() instances; the only ones _not_ using
> generic_file_splice_read()
> or default_file_splice_read() (== no zero-copy fallback) are
> fuse_dev_splice_read(), 3 instances in kernel/{relay.c,trace/trace.c} and
> sock_splice_read().  It's almost certainly possible to convert fuse one
> and the same might be possible to do to socket one.  relay and tracing
> stuff is just plain weird; might or might not be doable.
> 
> 	Something hopefully working is in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.splice_read
Tested-by: CAI Qian <caiqian@redhat.com>
