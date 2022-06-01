Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3F1C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 06:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344685AbiFAG5b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241227AbiFAG5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 02:57:30 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DE21147F;
        Tue, 31 May 2022 23:57:28 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id u8so844540qvj.2;
        Tue, 31 May 2022 23:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VNwVpmoBvcnpzZPlBoGgUFYgzyFdO2vlW3MF0F4BQ3A=;
        b=AYO0gZhReafZ0SpDEqdKORY4KgJMipDeiF4cZv7rxthP2HIWm5J/pqKkmK6hnhE5zU
         auoOhha1IrWxYrap0/YoEP8LEbA5wOB/hGGbELa1cmtGmWSx/Umfoq/htNSrF3SZty1x
         ef8a3ntDDLEgD/I6Nufvk/g5uE8YOKzRYiRBO3Xcpg2EVlcXGOTWEE0HyKta49+nALbw
         rOabnH9Na8YWsOkdoB4ohbHRyhHYcyMfHSagWn1yMGE5QS4vQmlevo8lVc4MaSWiWeJf
         LV6VMJMZQB6bCS6TqSh4TvkIV/K/howZRzHVBULK9NKB0iQ2GsJZNOyF45FS93zS6ebE
         y6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VNwVpmoBvcnpzZPlBoGgUFYgzyFdO2vlW3MF0F4BQ3A=;
        b=C3e9NJTkgnAAV7HOAqX7rNDl/HSZ96m4l3SvLm/7TkM+shXvsknQvEsoMuRaDvRUZm
         JvV6u0N0TTkeqMtHiu1epT7xpNN17tPnW3aAtiHmZhxI/25i9InLV3Oyv0K1vNHGnHvN
         gORkdSDY9Dfl1khJ+zXkGDURFa2T4yxu4XvqxNcDFA2PSRXN/90ApXdQltW5uj9l6nTy
         1xiLMJv8MtFJ94qFQ2FHH8ZLi3AGJ6kUBXhp5Mg6GZ8zqMd6gu4EIMDxK0w5jwYJx9Vg
         Api8SYJZzdkHDpZV9S/v0EYXGgWM9N+m6aO/L5zvgbh3suZh3lMeDqpchp/6+VqrooaO
         OcoA==
X-Gm-Message-State: AOAM533R5mMKzAT9cbEXHvG74FzWKzvPUYHS8OhaMqjoVAh+uTbuzpqz
        KGZyoLRtCsZ5/hqENOFg9w9M5PSGrW3LV8N36TOoI/28HbIu1g==
X-Google-Smtp-Source: ABdhPJzQFNb+5N4MzpeYddmEKnvJueZrsLxgzA70L21e2EAHoFzEkPl+HPD7wCA1rtQg7+gdFUJBGaTzZ8JqZ4VQrjM=
X-Received: by 2002:a05:6214:766:b0:462:1701:bca1 with SMTP id
 f6-20020a056214076600b004621701bca1mr47068510qvz.77.1654066647851; Tue, 31
 May 2022 23:57:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220530112905.79602-1-amir73il@gmail.com> <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
 <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
 <20220530215848.GR3923443@dread.disaster.area> <20220531085855.zpof4m3vmm6jlv4c@zlang-mailbox>
 <CAOQ4uxijAsEu_h3sTy=8kMqPgt6nyczJp_QGtrjpb9Bjbdf+aw@mail.gmail.com> <20220601062632.fgi5x5wgf6senn5j@zlang-mailbox>
In-Reply-To: <20220601062632.fgi5x5wgf6senn5j@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 Jun 2022 09:57:16 +0300
Message-ID: <CAOQ4uxiZYcX=e9jdDxRcyMmZA1FByGoEec05Whn-D-XKAN7W4A@mail.gmail.com>
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
To:     Zorro Lang <zlang@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 1, 2022 at 9:26 AM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, May 31, 2022 at 12:42:01PM +0300, Amir Goldstein wrote:
> > On Tue, May 31, 2022 at 11:59 AM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > On Tue, May 31, 2022 at 07:58:48AM +1000, Dave Chinner wrote:
> > > > On Mon, May 30, 2022 at 07:17:42PM +0300, Amir Goldstein wrote:
> > > > > On Mon, May 30, 2022 at 4:29 PM Zorro Lang <zlang@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> > > > > > > For this test to run on overlayfs we open a different file to perform
> > > > > > > shutdown+fsync while keeping the writeback target file open.
> > > > > > >
> > > > > > > We should probably perform fsync on the writeback target file, but
> > > > > > > the bug is reproduced on xfs and overlayfs+xfs also as is.
> > > > > > >
> > > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > > ---
> > > > > > >
> > > > > > > Zorro,
> > > > > > >
> > > > > > > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > > > > > > and tested that both configs fail with the same warning on v5.10.109.
> > > > > > >
> > > > > > > I tried changing fsync to syncfs for the test to be more correct in the
> > > > > > > overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> > > > > > > and that would need some more output filtering (or disregarding output
> > > > > > > completely).
> > > > > > >
> > > > > > > Since this minimal change does the job and does not change test behavior
> > > > > > > on xfs on any of the tested kernels, I thought it might be good enough.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Amir.
> > > > > > >
> > > > > > >  tests/generic/623 | 5 ++++-
> > > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/tests/generic/623 b/tests/generic/623
> > > > > > > index ea016d91..bb36ad25 100755
> > > > > > > --- a/tests/generic/623
> > > > > > > +++ b/tests/generic/623
> > > > > > > @@ -24,10 +24,13 @@ _scratch_mount
> > > > > > >  # XFS had a regression where it failed to check shutdown status in the fault
> > > > > > >  # path. This produced an iomap warning because writeback failure clears Uptodate
> > > > > > >  # status on the page.
> > > > > > > +# For this test to run on overlayfs we open a different file to perform
> > > > > > > +# shutdown+fsync while keeping the writeback target file open.
> > > >
> > > > To trigger the original bug, the post-shutdown fsync needs to be run
> > > > on the original file. That triggers a writeback error writeback
> > > > which clears the uptodate state on the mapped page. The mwrite that
> > > > follows then trips over the state of the page and attempts IO
> > > > operations without first checking shutdown state.
> > > >
> > > > Hence moving the fsync to a different file will break the mechanism
> > > > the regression test uses to trigger the original bug.
> > > >
> > > > > > >  file=$SCRATCH_MNT/file
> > > > > > >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> > > > > > >  ulimit -c 0
> > > > > > > -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > > > > > > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> > > > > > > +     -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
> > > > > >
> > > > > > Did you try to reproduce the original bug which this test case covers?
> > > > > >
> > > > >
> > > > > Yes. As I wrote:
> > > > > "tested that both configs fail with the same warning on v5.10.109"
> > > > > Meaning the same bug that the test triggered before my change
> > > > > in v5.10 is still triggered on xfs in v5.10 and it is triggered on both
> > > > > xfs and overlayfs+xfs in v5.10 with my change.
> > > >
> > > > It reproduced on 5.10, but not because of the reasons you are
> > > > suggesting.
> > > >
> > > > >
> > > > > > According to the "man xfs_io":
> > > > > >
> > > > > >        open [[ -acdfrstRTPL ] path ]
> > > > > >               Closes the current file, and opens the file specified by path instead.
> > > > >
> > > > > The documentation is incorrect.
> > > > > Current file is not closed.
> > > >
> > > > It is not closed, but it's also not the target of subsequent file
> > > > operations until you use "file 0" to switch back to it...
> > >
> > > I checked the xfsprogs/io/open.c, it truely doesn't "Close the current file",
> > > (need to update the man-page?) and it looks like make all opened files as a
> > > list, then operate them one by one(?):
> > >
> > >   execve("/usr/sbin/xfs_io", ["xfs_io", "-c", "mmap 0 4k", "-c", "mwrite 0 4k", "-c", "open testfile", "-c", "fsync", "-c", "mwrite 0 4k", "testfile"], 0x7ffdc2285b78 /* 42 vars */) = 0
> > >   ...
> > >   openat(AT_FDCWD, "testfile", O_RDWR)    = 3
> > >   ...
> > >   mmap(NULL, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, 3, 0) = 0x7efc04548000
> > >   ...
> > >   openat(AT_FDCWD, "testfile", O_RDWR)    = 4
> > >   ...
> > >   fsync(3)                                = 0
> > >   fsync(4)                                = 0
> > >   exit_group(0)                           = ?
> > >   +++ exited with 0 +++
> > >
> > > Anyway, looks like we're stuck at here.
> >
> > We are not stuck at all.
> > It is very simple to fix.
> > As you can see from the strace above and from Dave explanation,
> > The test as I posted in v1 already does the right thing, because
> > it does fsync the original file.
> > Which explains why the test I posted DOES work as expected on
> > both xfs and overlayfs and DOES reproduce the bug.
> >
> > However, if we want to write the test in a way that does NOT assume
> > that xfs_io -c fsync operates on all the open files, I need to add some
> > more commands:
> >
> > $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> >         -c "open $(_scratch_shutdown_handle)" -c shutdown \
> >         -c "file 0" -c fsync \
> >         -c "mwrite 0 4k" $file | _filter_scratch | _filter_xfs_io
> >
> > The only problem is this complicates the golden output
> > which does not produce the same output for overlayfs and xfs
> > open files, so I need to write another filter for that.
> >
> > The question is, is it worth it?
> >
> > Are we ever going to change xfs_io -c fsync to behave
> > differently and fsync only the current file?
> >
> > If not, that I can just change the comment and keep the command
> > and golden output:
> >
> >  # path. This produced an iomap warning because writeback failure
> > clears Uptodate
> >  # status on the page.
> >  # For this test to run on overlayfs we open a different file to perform
> > -# shutdown+fsync while keeping the writeback target file open.
> > +# shutdown while keeping the writeback target file open.
> > +# xfs_io -c fsync post-shutdown performs fsync also on the writeback
> > target file,
> > +# which is critical for triggering the writeback failure.
> >  file=$SCRATCH_MNT/file
> >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> >  $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> >         -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
> >         -c "mwrite 0 4k" $file | _filter_xfs_io
>
> OK, if you persist, my personal opinion is: at least don't change the
> original test logic of other fs especially when they're not wrong but
> the change is a little tricky.
>
> For example (not tested):
>
>   shutdown_cmd="shutdown"
>   # shutdown the underlying fs if there is
>   shutdown_handle="$(_scratch_shutdown_handle)"
>   if [ "$shutdown_handle" != "$SCRATCH_MNT" ];then
>           shutdown_cmd="\"open $shutdown_handle\" -c shutdown -c close"
>   fi
>   $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c ${shutdown_cmd}
>           -c fsync -c "mwrite 0 4k" $file | _filter_xfs_io
>

Ok, that works for me, but the extra close changes golder output
for overlayfs:

$ xfs_io -f x -c "open y" -c close
[000] x              (foreign,non-sync,non-direct,read-write)

So either we add more logic to filter that out or we just leave out the close
making the test in overlayfs depends on the fsync-all behavior of xfs_io
and leaving the test logic on xfs unchanged per your proposal.

If you are ok with that, I will test the version that you proposed and re-post.

Thanks,
Amir.
