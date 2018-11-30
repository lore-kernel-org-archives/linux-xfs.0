Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33780 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbeLAFdk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 00:33:40 -0500
Date: Fri, 30 Nov 2018 10:23:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [4.20-rc4 regression] generic/095 Concurrent mixed I/O hang on
 xfs based overlayfs
Message-ID: <20181130182322.GM8125@magnolia>
References: <20181130051253.GB7100@sh-el5.eng.rdu2.redhat.com>
 <20181130121506.GI2299@dhcp-12-149.nay.redhat.com>
 <CAOQ4uxg9MdMbkM5+CuXK-VmmqxF8UmNkNqeKTHoxOtTnQ2=LnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg9MdMbkM5+CuXK-VmmqxF8UmNkNqeKTHoxOtTnQ2=LnQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: jencce.kernel@gmail.com, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>

[add dave to cc]

On Fri, Nov 30, 2018 at 03:30:54PM +0200, Amir Goldstein wrote:
> On Fri, Nov 30, 2018 at 2:13 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Fri, Nov 30, 2018 at 12:12:53AM -0500, Murphy Zhou wrote:
> > > Hi,
> > >
> > > Hit a xfs regression issue by generic/095 on overlayfs.
> > >
> > > It's easy to reproduce. Tests processes hang there and never return.
> > > There are some warning in the dmesg.
> > >
> > > SIGINT (Ctrl+C) can't kill the tests, neither does SIGTERM (kill).
> > > However, SIGKILL (kill -9) can clean them up.
> > >
> > > This happens when testing on v4 or v5 or reflink, with the same behaviour.
> > > -m crc=0
> > > -m crc=1,finobt=1,rmapbt=0,reflink=0 -i sparse=1
> > > -m crc=1,finobt=1,rmapbt=1,reflink=1 -i sparse=1
> > >
> > > This does not happen if ext4 as base fs for overlayfs.
> > >
> > > Bisecting points to this commit:
> > >       4721a601 iomap: dio data corruption and spurious errors when pipes fill
> > >
> > > Test pass soon after this commit reverted.

UGH.

Ok, I ran g/095 on overlayfs and saw tons of this in the output:

XFS: Assertion failed: ret < 0 || ret == count, file: fs/xfs/xfs_file.c, line: 558

So, revert just this part of 4721a601:

	/*
	 * Splicing to pipes can fail on a full pipe. We have to
	 * swallow this to make it look like a short IO
	 * otherwise the higher splice layers will completely
	 * mishandle the error and stop moving data.
	 */
	if (ret == -EFAULT)
		ret = 0;

Does it work then?

No, because now we just bounce the EAGAIN out to userspace, recreating
the original problem where fsx dies.  I then stapled on some trace
printks to monitor what was going on, noticing that every time we tried
to do a directio read into the pipe, the stack trace was:

=> xfs_file_dio_aio_read (ffffffffa01b92a4)
=> xfs_file_read_iter (ffffffffa01b976a)
=> generic_file_splice_read (ffffffff812686da)
=> splice_direct_to_actor (ffffffff812689b6)
=> do_splice_direct (ffffffff81268b9f)
=> vfs_copy_file_range (ffffffff81230217)
=> __x64_sys_copy_file_range (ffffffff812305b1)
=> do_syscall_64 (ffffffff81002850)
=> entry_SYSCALL_64_after_hwframe (ffffffff8180007d)

Next I began looking at what those three splice functions actually do.
splice_direct_to_actor does (very roughly paraphrased):

while (len) {
	ret = do_splice_to(...len...) /* read data into pipe */
	if (ret < 0)
		goto out_release;
	actor(...ret) /* write data from pipe into file */
	len -= ret;
}

I observed that the pipe size is 64k.  The call do_splice_to() has a
length of 720k, so we allocate all the pipe buffers available, then
return EFAULT/EAGAIN.  We bounce straight out of this to userspace,
having not called ->actor (which empties the pipe by writing the
data), so we immediately EFAULT again, and now *anything* trying to use
current->pipe finds it is all jam up.

I think the solution here is that splice_direct_to_actor must clamp the
length argument to do_splice_to() to (buffers - nr_bufs) << PAGE_SHIFT.
It doesn't make sense to try to read more data than will fit in the
pipe, since the emptying process is synchronous with the reads.

So I tried it, and it seems to work with fsx and it makes generic/095
pass on overlayfs again.  I'll send that patch to the list shortly.

> > > # ps axjf
> > >  1839  1862   S+    0:00  |  \_ /bin/bash ./bin/single -o -t generic/095
> > >  1862  2005   S+    0:00  |      \_ /bin/bash ./check -T -overlay generic/095
> > >  2005  2292   S+    0:00  |          \_ /bin/bash ./tests/generic/095
> > >  2292  2516   Sl+   0:01  |              \_ /usr/bin/fio /tmp/2292.fio
> > >  2516  2565   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> > >  2516  2566   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> > >  2516  2567   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> > >  2516  2568   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> > >  2516  2569   Rs    6:02  |                  \_ /usr/bin/fio /tmp/2292.fio
> >
> > Nice catch! I didn't tried overlayfs on XFS regression test this time. I never hit
> > issue on XFS singly, even on glusterfs(XFS underlying).
> >
> > I just gave it a try. This bug is reproducible on xfs-linux git tree
> > xfs-4.20-fixes-2 HEAD. And by strace all fio processes, they all
> > keep outputing [1]. More details as [2]. Only overlayfs on XFS can
> > reproduce this bug, overlayfs on Ext4 can't.
> >
> 
> Darrick,
> 
> This is my cue to insert a rant. You already know what I am going to rant about.
> 
> I cannot force you to add a check -overlay xfstests run to your pull
> request validation
> routine. I can offer assistance in any questions you may have and I can offer
> support for check -overlay infrastructure if it breaks or if it needs
> improvements.
> 
> I have checked on several recent point releases that check -overlay does not
> regress any tests compared to xfs reflink configuration, and when I
> found a regression
> (mostly in overlayfs code, but also in xfs code sometimes) I reported
> and/or fixed it.
> But I do not have the resources to validate every xfs merge and
> certainly not xfs-next.
> 
> There is a large group of tests that is expected to notrun, which
> makes running the
> -overlay test a lot faster than any given xfs configuration and IMO
> running just a single
> xfs reflink config with -overlay would give a pretty good test coverage.
> 
> So what do you say?...

Frankly I'd rather push the kernelci/0day/lf/whoever folks to kick off
fstests across all the major filesystems after the daily for-next merge
so that we can all see if there are regressions over the previous day's
test.  IOWs, rather than loading ourselves down with more testing
burden, let's make it more public.

I've received occasional reports from the 0day robot, but I'm not sure
if it's testing consistently because it only ever seems to emit
complaints, not "I love your branch and even better nothing regressed!".

That said, this *does* confirm Zorro's earlier point that I should give
him a week to test xfs for-next before pushing to Linus.

Sorry everyone, and especially Zorro & Amir...

--D

> Thanks,
> Amir.
