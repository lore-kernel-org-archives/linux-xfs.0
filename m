Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51126 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760377AbcIWTAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 15:00:38 -0400
Date: Fri, 23 Sep 2016 20:00:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC][CFT] splice_read reworked
Message-ID: <20160923190032.GA25771@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20160909023452.GO2356@ZenIV.linux.org.uk>
 <CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
 <20160909221945.GQ2356@ZenIV.linux.org.uk>
 <CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
 <20160914031648.GB2356@ZenIV.linux.org.uk>
 <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160917190023.GA8039@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org

	The series is supposed to solve the locking order problems for
->splice_read() and get rid of code duplication between the read-side
methods.
	pipe_lock is lifted out of ->splice_read() instances, along with
waiting for empty space in pipe, etc. - we do that stuff in callers.
	A new variant of iov_iter is introduced - it's backed by a pipe,
copy_to_iter() results in allocating pages and copying into those,
copy_page_to_iter() just sticks a reference to that page into pipe.
Running out of space in pipe yields a short read, as a fault in iovec-backed
iov_iter would have.  Enough primitives are implemented for normal
->read_iter() instances to work.
	generic_file_splice_read() switched to feeding such iov_iter to
->read_iter() instance.  That turns out to be enough to kill almost all
->splice_read() instances; the only ones _not_ using generic_file_splice_read()
or default_file_splice_read() (== no zero-copy fallback) are
fuse_dev_splice_read(), 3 instances in kernel/{relay.c,trace/trace.c} and
sock_splice_read().  It's almost certainly possible to convert fuse one
and the same might be possible to do to socket one.  relay and tracing
stuff is just plain weird; might or might not be doable.

	Something hopefully working is in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.splice_read

Several commits in that pipe (#1, #8 and #9) are trivial cleanups and fixes
for crap caught while doing the rest, probably ought to be separated.

Shortlog:
Al Viro (11):
      fix memory leaks in tracing_buffers_splice_read()
      splice_to_pipe(): don't open-code wakeup_pipe_readers()
      splice: switch get_iovec_page_array() to iov_iter
      splice: lift pipe_lock out of splice_to_pipe()
      skb_splice_bits(): get rid of callback
      new helper: add_to_pipe()
      fuse_dev_splice_read(): switch to add_to_pipe()
      cifs: don't use memcpy() to copy struct iov_iter
      fuse_ioctl_copy_user(): don't open-code copy_page_{to,from}_iter()
      new iov_iter flavour: pipe-backed
      switch generic_file_splice_read() to use of ->read_iter()

Diffstat:
 drivers/staging/lustre/lustre/llite/file.c         |  70 +--
 .../staging/lustre/lustre/llite/llite_internal.h   |  15 +-
 drivers/staging/lustre/lustre/llite/vvp_internal.h |  14 -
 drivers/staging/lustre/lustre/llite/vvp_io.c       |  45 +-
 fs/cifs/file.c                                     |  14 +-
 fs/coda/file.c                                     |  23 +-
 fs/fuse/dev.c                                      |  48 +-
 fs/fuse/file.c                                     |  30 +-
 fs/gfs2/file.c                                     |  28 +-
 fs/nfs/file.c                                      |  25 +-
 fs/nfs/internal.h                                  |   2 -
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/ocfs2/file.c                                    |  34 +-
 fs/ocfs2/ocfs2_trace.h                             |   2 -
 fs/splice.c                                        | 578 +++++++--------------
 fs/xfs/xfs_file.c                                  |  41 +-
 fs/xfs/xfs_trace.h                                 |   1 -
 include/linux/fs.h                                 |   2 -
 include/linux/skbuff.h                             |   8 +-
 include/linux/splice.h                             |   3 +
 include/linux/uio.h                                |  14 +-
 kernel/trace/trace.c                               |  14 +-
 lib/iov_iter.c                                     | 390 +++++++++++++-
 mm/shmem.c                                         | 115 +---
 net/core/skbuff.c                                  |  28 +-
 net/ipv4/tcp.c                                     |   3 +-
 net/kcm/kcmsock.c                                  |  16 +-
 net/unix/af_unix.c                                 |  17 +-
 28 files changed, 648 insertions(+), 934 deletions(-)

	It's not all I would like to do there (in particular, I hadn't
done fuse splice_read conversion to read_iter, even though it does appear
to be doable; that'll take copy_page_to_iter_nosteal() as a new primitive
+ considerable amount of massage in fs/fuse/dev.c), but it should at least
	* make pipe lock the outermost
	* switch generic_file_splice_read() to ->read_iter(), making
it suitable for lustre/coda/gfs2/ocfs2/xfs/shmem without any wrappers
	* somewhat simplify socket ->splice_read() guts (not by much - to
start doing that right we'd need the same new primitive)
	* remove a considerable pile of code.
	* get rid of a bunch of splice_{grow,shrink}_spd/splice_to_pipe
callers; remaining ones are in default_file_splice_read() (trivially
killable by conversion to iov_iter_get_pages_alloc(), followed by the same
build iovec array + use kernel_readv as we do now + iov_iter_advance to
the length returned by kernel_readv), kernel/relay and kernel/trace/trace.c
ones (should switch to add_to_pipe(), AFAICS) and skb_splice_bits()
(again, a matter of copy_page_to_iter_nosteal(), which will take out
spd_can_coalesce/spd_fill_page in there as well).  Once the remaining ones
are taken care of, splice_pipe_desc and friends will go away.

	In its current form it survives LTP, xfstests and overlayfs testsuite;
if anybody has additional tests for splice and friends, I would like to hear
about such.  It really needs more beating, though.

	Please, help with review and testing.
