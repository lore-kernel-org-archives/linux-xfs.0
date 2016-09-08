Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:17206 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932862AbcIHVii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 17:38:38 -0400
Date: Fri, 9 Sep 2016 07:38:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908213835.GY30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 11:12:33AM -0700, Linus Torvalds wrote:
> On Thu, Sep 8, 2016 at 10:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > ... and brings back a lot of other crap.  The thing is, pipe lock should
> > be on the outside of everything fs might be taking, so that splice IO
> > is the same as normal IO as far as filesystem locking is concerned.  For
> > the write side it had been done in that commit, for the read side it's yet
> > to be done.
> 
> Al, look at generic_file_splice_read().
> 
> The problem is that XFS takes its own
> 
>         xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
>         ..
>         xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
> 
> around all the generic file accessors. So for example, it doesn't use
> "generic_file_read_iter()", it does
> 
> STATIC ssize_t
> xfs_file_buffered_aio_read(
>         struct kiocb            *iocb,
>         struct iov_iter         *to)
> {
>         struct xfs_inode        *ip = XFS_I(file_inode(iocb->ki_filp));
>         ssize_t                 ret;
> 
>         trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
> 
>         xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
>         ret = generic_file_read_iter(iocb, to);
>         xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
> 
>         return ret;
> }
> 
> and the exact same pattern holds for generic_file_splice_read().
> 
> So the XFS model *requires* that XFS_IOLOCK to be outside all the operations.
> 
> But then in iter_file_splice_write we have the other ordering.
> 
> Now, xfs could do a wrapper for ->splice_write() like it used to, and
> have that same "take the xfs lock around the call to
> iter_file_splice_write(). That was my first obvious patch.
> 
> I threw it out because that's garbage too: then we end up doing
> ->write_iter(), which takes the xfs_rw_ilock() again, and would
> immediately deadlock *there* instead.

That's what I first tried when this was first reported back in
3.18-rc0, and after a couple of other aborted attempts to work
around the pipe_lock I came to the same conclusion:

	"That smells like a splice architecture bug. splice write puts the
	pipe lock outside the inode locks, but splice read puts the pipes
	locks *inside* the inode locks. "

http://oss.sgi.com/archives/xfs/2014-10/msg00319.html

> So the problem really is that the vfs layer seems to simply not allow
> the filesystem to do any locking around the generic page cache helper
> functions. And XFS really wants to do that.

It's not an XFS specific problem: any filesystem that supports hole
punch and it's fallocate() friends needs this high level splice IO
exclusion as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
