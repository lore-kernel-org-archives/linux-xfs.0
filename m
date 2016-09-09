Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33846 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755309AbcIIWTt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Sep 2016 18:19:49 -0400
Date: Fri, 9 Sep 2016 23:19:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909221945.GQ2356@ZenIV.linux.org.uk>
References: <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
 <20160909015324.GD30056@dastard>
 <CA+55aFzohsUXj_3BeFNr2t50Wm=G+7toRDEz=Tk7VJqP3n1hXQ@mail.gmail.com>
 <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Sep 08, 2016 at 07:50:05PM -0700, Linus Torvalds wrote:
> On Thu, Sep 8, 2016 at 7:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > IDGI.  Suppose we do splice from file to pipe.  Everything had been in
> > page cache, so we want to end up with pipe_buffers containing references
> > to those page cache pages.  How do you propose to do that without having
> > grabbed references to them?  What's to keep them from being freed by the
> > time we get to reading from the pipe?
> 
> So that's obviously what we already do. That is, after all, why splice
> doesn't actually keep track of "pages", it keeps track of "struct
> pipe_buffer". So each page has not just offset/len associated with it,
> but also a get/release/verify operation block and some flags with them
> (it might not be a page-cache page, so in some cases it might be a skb
> or something that needs different release semantics).
> 
> And if you can make the iterator basically interface with turning the
> page/offset/len directly into a "struct pipe_buffer" and not do any
> extra reference operations, then it actually would work very well.
> 
> But the way I read your description of what you'd do I just expected
> you to have an extra "get/put" ref at the iterator level.

Umm...  Looks like I misunderstood you, then.  Yes, it ends up with
get/get/put, the last two close in time.  Do you expect that to be a serious
overhead?  atomic_inc + atomic_dec_and_test + branch not taken shouldn't be
_that_ hot, and I would rather avoid complicating do_generic_file_read()
and friends with "iov_iter (somehow) told us not to put this page as we
normally would".  Can be done that way, but let's not bother until it really
shows in profiles.

> Maybe I misunderstood. I'd love to see a rough patch.

Cooking it...  The thing I really hate about the use of pipe_buffer is that
we want to keep the "use on-stack array for default pipe size" trick, and
pipe_buffer is fatter than I'd like.  Instead of pointer + two numbers +
something to indicate whether it's picked from page cache or something we'd
allocated we get get pointer + int + int + pointer + int + long, which turns
into 5 words on 64bit.  With 16-element array of those on stack frame, it's
not nice - more than half kilobyte of stack space with ->read_iter() yet to
be called...  bvec would be better (60% savings boils down to 384 bytes
shaved off that thing), but we'd need to play games with encoding the "is
it page cache or not" bit somewhere in it.

BTW, AFAICS that thing can be used to replace _all_ non-default filesystem
instances - lustre, nfs, gfs2, ocfs2, xfs, shmem, even coda.  What remains:
	* fuse_dev_splice_read()
	* relay_file_splice_read()
	* tracing_splice_read_pipe()
	* tracing_buffers_splice_read()
	* sock_splice_read()
TBH, the last one makes me nervious -
        /* Drop the socket lock, otherwise we have reverse
         * locking dependencies between sk_lock and i_mutex
         * here as compared to sendfile(). We enter here
         * with the socket lock held, and splice_to_pipe() will
         * grab the pipe inode lock. For sendfile() emulation,
         * we call into ->sendpage() with the i_mutex lock held
         * and networking will grab the socket lock.
         */
        release_sock(sk);
        ret = splice_to_pipe(pipe, spd);
        lock_sock(sk);
in skb_socket_splice() and
        mutex_unlock(&u->readlock);
        ret = splice_to_pipe(pipe, spd);
        mutex_lock(&u->readlock);
in skb_unix_socket_splice() smell like yet another indication that we are
taking the locks in wrong order.  OTOH, lifting the pipe lock all way out
of that, especially the last one, really smells like asking for deadlocks.
It is a separate issue, but it'll also need looking into...

I wonder if relay_file_read() would be better off converted to ->read_iter()
and unified with relay_file_splice_read() - we do copy_to_user() from
vmap'ed area, but we have the array of underlying struct page *, so it could
switch to copy_page_to_iter(), at which point ->splice_read() would _probably_
be OK with switch to ->read_iter() use.  The tricky part is their use games
with relay_consume_bytes() in relay_pipe_buf_release().  Who maintains that
thing (kernel/relay.c) these days?  git log for it looks like it's been
pretty much abandoned...
