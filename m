Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35057 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758992AbcIHSMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 14:12:34 -0400
Received: by mail-oi0-f65.google.com with SMTP id 2so6003981oif.2
        for <linux-xfs@vger.kernel.org>; Thu, 08 Sep 2016 11:12:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160908175632.GH2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard> <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2016 11:12:33 -0700
Message-ID: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 8, 2016 at 10:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> ... and brings back a lot of other crap.  The thing is, pipe lock should
> be on the outside of everything fs might be taking, so that splice IO
> is the same as normal IO as far as filesystem locking is concerned.  For
> the write side it had been done in that commit, for the read side it's yet
> to be done.

Al, look at generic_file_splice_read().

The problem is that XFS takes its own

        xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
        ..
        xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);

around all the generic file accessors. So for example, it doesn't use
"generic_file_read_iter()", it does

STATIC ssize_t
xfs_file_buffered_aio_read(
        struct kiocb            *iocb,
        struct iov_iter         *to)
{
        struct xfs_inode        *ip = XFS_I(file_inode(iocb->ki_filp));
        ssize_t                 ret;

        trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);

        xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
        ret = generic_file_read_iter(iocb, to);
        xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);

        return ret;
}

and the exact same pattern holds for generic_file_splice_read().

So the XFS model *requires* that XFS_IOLOCK to be outside all the operations.

But then in iter_file_splice_write we have the other ordering.

Now, xfs could do a wrapper for ->splice_write() like it used to, and
have that same "take the xfs lock around the call to
iter_file_splice_write(). That was my first obvious patch.

I threw it out because that's garbage too: then we end up doing
->write_iter(), which takes the xfs_rw_ilock() again, and would
immediately deadlock *there* instead.

So the problem really is that the vfs layer seems to simply not allow
the filesystem to do any locking around the generic page cache helper
functions. And XFS really wants to do that.

              Linus
