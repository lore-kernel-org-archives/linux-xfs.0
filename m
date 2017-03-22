Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758645AbdCVDJa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 23:09:30 -0400
Date: Wed, 22 Mar 2017 11:09:23 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] generic: test pagecache invalidation after direct
 write
Message-ID: <20170322030923.GB14226@eguan.usersys.redhat.com>
References: <20170321165314.11434-1-eguan@redhat.com>
 <20170321173509.GC59313@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170321173509.GC59313@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Mar 21, 2017 at 01:35:09PM -0400, Brian Foster wrote:
> On Wed, Mar 22, 2017 at 12:53:14AM +0800, Eryu Guan wrote:
> > Test if direct write invalidates pagecache correctly, so that subsequent
> > buffer read reads the correct data from disk.
> > 
> > This test is inspired by LTP tests dio29, and serves as a regression
> > test for the bug found by it, see kernel commit c771c14baa33
> > ("iomap: invalidate page caches should be after iomap_dio_complete()
> > in direct write").
> > 
> > The test can be easily expanded to other write/read combinations, e.g.
> > buffer write + direct read and direct write + direct read, so they are
> > also being tested.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > v2: Address Brian's review comments
> > - compare buffer content byte-by-byte instead of strncmp
> > - use 'pids[i]' not *(pids + 1)
> > - dump buffer content to stdout on error
> > - initialize write buffer with (i + 1)
> > - use pwrite/pread instead of lseek+write/read
> > - remove increment of unused 'ret'
> > - call fsync(fd) instead of sync()
> > - fix typos
> > 
> >  .gitignore                 |   1 +
> >  src/Makefile               |   3 +-
> >  src/dio-invalidate-cache.c | 326 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/418          | 122 +++++++++++++++++
> >  tests/generic/418.out      |   2 +
> >  tests/generic/group        |   1 +
> >  6 files changed, 454 insertions(+), 1 deletion(-)
> >  create mode 100644 src/dio-invalidate-cache.c
> >  create mode 100755 tests/generic/418
> >  create mode 100644 tests/generic/418.out
> > 
> ...
> > diff --git a/src/dio-invalidate-cache.c b/src/dio-invalidate-cache.c
> > new file mode 100644
> > index 0000000..bc795f9
> > --- /dev/null
> > +++ b/src/dio-invalidate-cache.c
> > @@ -0,0 +1,326 @@
> ...
> > +static void kill_children(pid_t *pids, int nr_child)
> > +{
> > +	int i;
> > +	pid_t pid;
> > +
> > +	for (i = 0; i < nr_child; i++) {
> > +		pid = *(pids + i);
> > +		if (pid == 0)
> > +			continue;
> > +		kill(pid, SIGTERM);
> > +	}
> > +	return;
> 
> Still have pids pointer arithmetic above and the return is unnecessary.
> Otherwise looks Ok to me:

I applied this change and queued for next update.

diff --git a/src/dio-invalidate-cache.c b/src/dio-invalidate-cache.c
index bc795f9..4c40c87 100644
--- a/src/dio-invalidate-cache.c
+++ b/src/dio-invalidate-cache.c
@@ -73,12 +73,11 @@ static void kill_children(pid_t *pids, int nr_child)
        pid_t pid;
 
        for (i = 0; i < nr_child; i++) {
-               pid = *(pids + i);
+               pid = pids[i];
                if (pid == 0)
                        continue;
                kill(pid, SIGTERM);
        }
-       return;
 }
 
 static int wait_children(pid_t *pids, int nr_child)

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

Eryu
