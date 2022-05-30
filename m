Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E15C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 21:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiE3V6x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 17:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiE3V6x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 17:58:53 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B90D6A00F;
        Mon, 30 May 2022 14:58:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 000AC534707;
        Tue, 31 May 2022 07:58:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nvnPU-000lRN-35; Tue, 31 May 2022 07:58:48 +1000
Date:   Tue, 31 May 2022 07:58:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>, Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
Message-ID: <20220530215848.GR3923443@dread.disaster.area>
References: <20220530112905.79602-1-amir73il@gmail.com>
 <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
 <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62953e1a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=9O5eKyu7gXvSTkiJRZwA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 30, 2022 at 07:17:42PM +0300, Amir Goldstein wrote:
> On Mon, May 30, 2022 at 4:29 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> > > For this test to run on overlayfs we open a different file to perform
> > > shutdown+fsync while keeping the writeback target file open.
> > >
> > > We should probably perform fsync on the writeback target file, but
> > > the bug is reproduced on xfs and overlayfs+xfs also as is.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Zorro,
> > >
> > > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > > and tested that both configs fail with the same warning on v5.10.109.
> > >
> > > I tried changing fsync to syncfs for the test to be more correct in the
> > > overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> > > and that would need some more output filtering (or disregarding output
> > > completely).
> > >
> > > Since this minimal change does the job and does not change test behavior
> > > on xfs on any of the tested kernels, I thought it might be good enough.
> > >
> > > Thanks,
> > > Amir.
> > >
> > >  tests/generic/623 | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tests/generic/623 b/tests/generic/623
> > > index ea016d91..bb36ad25 100755
> > > --- a/tests/generic/623
> > > +++ b/tests/generic/623
> > > @@ -24,10 +24,13 @@ _scratch_mount
> > >  # XFS had a regression where it failed to check shutdown status in the fault
> > >  # path. This produced an iomap warning because writeback failure clears Uptodate
> > >  # status on the page.
> > > +# For this test to run on overlayfs we open a different file to perform
> > > +# shutdown+fsync while keeping the writeback target file open.

To trigger the original bug, the post-shutdown fsync needs to be run
on the original file. That triggers a writeback error writeback
which clears the uptodate state on the mapped page. The mwrite that
follows then trips over the state of the page and attempts IO
operations without first checking shutdown state.

Hence moving the fsync to a different file will break the mechanism
the regression test uses to trigger the original bug.

> > >  file=$SCRATCH_MNT/file
> > >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> > >  ulimit -c 0
> > > -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> > > +     -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
> >
> > Did you try to reproduce the original bug which this test case covers?
> >
> 
> Yes. As I wrote:
> "tested that both configs fail with the same warning on v5.10.109"
> Meaning the same bug that the test triggered before my change
> in v5.10 is still triggered on xfs in v5.10 and it is triggered on both
> xfs and overlayfs+xfs in v5.10 with my change.

It reproduced on 5.10, but not because of the reasons you are
suggesting.

> 
> > According to the "man xfs_io":
> >
> >        open [[ -acdfrstRTPL ] path ]
> >               Closes the current file, and opens the file specified by path instead.
> 
> The documentation is incorrect.
> Current file is not closed.

It is not closed, but it's also not the target of subsequent file
operations until you use "file 0" to switch back to it....

> > Although I doubt if it always real close the current file, but you open to get
> > a new file descriptor, later operations will base on new fd. I don't know if
> > it still has original testing coverage.
> 
> fsync on the fs root dir is not the same as fsync on the original file.

Yup, and that's what will break the regression test.

But why does it still fail on v5.10.109?

Well, that's because of a quirk of the xfs_io fsync command.  It
doesn't have the CMD_FLAG_ONESHOT flag set on it, so it operates on
*all open files*, not just the current file.

IOWs, the misunderstanding of how the bug is triggered has been
covered up by the misunderstanding of how the xfs_io open file table
and the fsync command interact.

> mwrite does not change because mwrite is not acted on open fd
> it is acted on memory mapping of mmap.
> 
> I can either change fd again to first fd before doing fsync
> or change fsync to syncfs.

Do not change it to syncfs - that executes completely different
writeback and metadata sync code paths with different error
propagation and may well result in very different behaviour from the
underlying filesystem.  Fundamentally, syncfs() and fsync() are not
interchangeable from a regression test POV - you *might* get the
same high level result, but the low level code behaves very
differently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
