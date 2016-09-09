Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48690 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbcIICey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:34:54 -0400
Date: Fri, 9 Sep 2016 03:34:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909023452.GO2356@ZenIV.linux.org.uk>
References: <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 07:26:44PM -0700, Linus Torvalds wrote:
> On Thu, Sep 8, 2016 at 7:22 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, Sep 8, 2016 at 6:53 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> So if we race iwth a truncate, the pages in spd.pages[] that are
> >> beyond the new EOF may or may not have been removed from the page
> >> cache.
> >
> > So I'm not sure why we'd need to care?
> 
> Side note, just to clarify: I'm not actually convinced that turning
> things into page/offset/len tuples is the right thing to do.
> 
> I still suspect that the reference count updates on each page may not
> be a good idea.  I suspect we'd easily be better off trying to do
> everything under the pipe lock exactly so that we can *avoid* having
> to do per-page "increment ref-count, then decrement it again". But the
> locking would have to be changed radically for us to be able to do
> that (and the only sane model ios, I think, to make pipe_lock be the
> outermost lock, and outside *every* downcall)

IDGI.  Suppose we do splice from file to pipe.  Everything had been in
page cache, so we want to end up with pipe_buffers containing references
to those page cache pages.  How do you propose to do that without having
grabbed references to them?  What's to keep them from being freed by the
time we get to reading from the pipe?
