Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45178 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753267AbcIHUox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 16:44:53 -0400
Date: Thu, 8 Sep 2016 21:44:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908204450.GJ2356@ZenIV.linux.org.uk>
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
Cc: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 11:12:33AM -0700, Linus Torvalds wrote:

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
> 
> So the problem really is that the vfs layer seems to simply not allow
> the filesystem to do any locking around the generic page cache helper
> functions. And XFS really wants to do that.

Why *have* ->splice_read() there at all?  Let's use its ->read_iter(), where
it will take its lock as it always did for read.

All we need is a variant of __generic_file_splice_read() that would pass
a new kind of iov_iter down to filesystem's own ->read_iter().  And let that
guy do whatever locking it wants.  It will end up doing a sequence of
copy_page_to_iter() and, possibly, copy_to_iter() (XFS one would only do the
former).  So let's add an iov_iter flavour that would simply grab a reference
to page passed to copy_page_to_iter() and allocate-and-copy for copy_to_iter().
As the result, you'll get an array of <page, offset, count> triples - same
as you would from the existing __generic_file_splice_read().  Pages already
uptodate, with all readahead logics done as usual, etc.

What else do we need?  Just feed the resulting triples into the pipe and
that's it.  Sure, they can get stale by truncate/punchhole/whatnot.  So
they can right after we return from xfs_file_splice_read()...

Moreover, I don't see why we need to hold pipe lock the actual call of
->read_iter().  Right now we only grab it for "feed into pipe buffers"
part.  Objections?
