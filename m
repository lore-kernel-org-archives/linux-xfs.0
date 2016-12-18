Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51276 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbcLRUaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2016 15:30:05 -0500
Date: Sun, 18 Dec 2016 20:30:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/12] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20161218203003.GZ1555@ZenIV.linux.org.uk>
References: <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035951.GN2356@ZenIV.linux.org.uk>
 <87shpmxrey.fsf@linux-m68k.org>
 <CA+55aFyJGz6njFjKe8O0+XRJhCrPHA_wnEuLbGSGypJ0G2-vpQ@mail.gmail.com>
 <20161218201207.GY1555@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161218201207.GY1555@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Dec 18, 2016 at 08:12:07PM +0000, Al Viro wrote:
> On Sun, Dec 18, 2016 at 11:28:44AM -0800, Linus Torvalds wrote:
> > On Sat, Dec 17, 2016 at 11:54 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > > This break EPIPE handling inside splice when SIGPIPE is ignored:
> > >
> > > Before:
> > > $ { sleep 1; strace -e splice pv -q /dev/zero; } | :
> > 
> > Where is that "splice" program from? Google isn't helpful, and fedora
> > doesn't seem to have it. I'm assuming it was posted in one of the
> > threads, but if so I've long since lost sight of it..
> 
> It's pv(1), actually.  I'm looking into that - debian-packaged pv reproduced
> that crap.

OK, I see what's going on - it's wait_for_space() lifted past the checks
for lack of readers.  The fix, AFAICS, is simply

diff --git a/fs/splice.c b/fs/splice.c
index 6a2b0db5..aeba2b7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1082,6 +1082,10 @@ EXPORT_SYMBOL(do_splice_direct);
 
 static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 {
+	if (unlikely(!pipe->readers)) {
+		send_sig(SIGPIPE, current, 0);
+		return -EPIPE;
+	}
 	while (pipe->nrbufs == pipe->buffers) {
 		if (flags & SPLICE_F_NONBLOCK)
 			return -EAGAIN;
@@ -1090,6 +1094,10 @@ static int wait_for_space(struct pipe_inode_info *pipe, unsigned flags)
 		pipe->waiting_writers++;
 		pipe_wait(pipe);
 		pipe->waiting_writers--;
+		if (unlikely(!pipe->readers)) {
+			send_sig(SIGPIPE, current, 0);
+			return -EPIPE;
+		}
 	}
 	return 0;
 }
