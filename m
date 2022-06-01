Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C03C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 06:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244617AbiFAG0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244446AbiFAG0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 02:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACFE7246
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 23:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654064800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RsOnse+ylIHREqigx9WMkvQgxTlgaDFJwjmRfOPzSAs=;
        b=cVEnltppTekEJwciopl3+u4iwNAsE0NtxtgTQujX1ZyE0L5/8a7vdjrRLsDJbIzRL2Ox5+
        qzrriIDmE2lnKjO3AaSpHmj4s+ZBHs6wecIOceKAY0QgufzTcLLjZIXcVnCLaVIWHZEmLG
        8xB1iHTR+4bNAQu7+roZRyFw5c9KFRQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-rB0mJumnN9SFQyNMRetvyA-1; Wed, 01 Jun 2022 02:26:39 -0400
X-MC-Unique: rB0mJumnN9SFQyNMRetvyA-1
Received: by mail-qk1-f197.google.com with SMTP id x9-20020a05620a14a900b006a32ca95a72so618140qkj.22
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 23:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RsOnse+ylIHREqigx9WMkvQgxTlgaDFJwjmRfOPzSAs=;
        b=G5fjRvccsCtkXR5sAfrUYKKLSGI/+htnXBZbzunNsMH7wCaX5irxvUgmJc59URf/Za
         GPr3Q9PvqYEx/GtQVCfgmbSCMSI3KIQk0gl24LtY3xz8lkMM1YlRoxxHtCspc+bBTLIj
         Chk6xkafYjflw80v6Hsf0V0ObOCeV/5x+C/6CRCilDYguohF+m8s0Qsj16ExDUjnPORk
         0pkEykgs00Shl72ddGEAhWD3e+1yptvLibYKueMOPXxQEGjoKu6sp1PaKGrrBbWvW5FR
         mYB/LtUuJ7rVer/Wjfw2BZwdhvPp3VGkTUYx2p9nWELEThjBwvM9j1VAdVjQtHsWNMfv
         jdlg==
X-Gm-Message-State: AOAM531ySxwZV73CbYLDVHD/pkj0+Dia+p35BxKPE5kDwPGuKWnl/Zwv
        39oZvcQ0Pfu8gVDSepXv3U4NtuPVWJuogYLUp3ywyUMy1HiCEY8oUrOU0wiCxpIvVXZM8ydkKYU
        WBG6724/nJNxPX+P2AR4T
X-Received: by 2002:a05:620a:2892:b0:6a6:3e04:bfdf with SMTP id j18-20020a05620a289200b006a63e04bfdfmr7743106qkp.653.1654064798916;
        Tue, 31 May 2022 23:26:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXounRJ64sXu2QnVTFq6k3/qdOYztbysh4ZHvlW4yEwhIVLCKG1zM8par6ynZkykUXim4wrA==
X-Received: by 2002:a05:620a:2892:b0:6a6:3e04:bfdf with SMTP id j18-20020a05620a289200b006a63e04bfdfmr7743101qkp.653.1654064798546;
        Tue, 31 May 2022 23:26:38 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r203-20020a37a8d4000000b0069fe1fc72e7sm677971qke.90.2022.05.31.23.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 23:26:37 -0700 (PDT)
Date:   Wed, 1 Jun 2022 14:26:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
Message-ID: <20220601062632.fgi5x5wgf6senn5j@zlang-mailbox>
References: <20220530112905.79602-1-amir73il@gmail.com>
 <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
 <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
 <20220530215848.GR3923443@dread.disaster.area>
 <20220531085855.zpof4m3vmm6jlv4c@zlang-mailbox>
 <CAOQ4uxijAsEu_h3sTy=8kMqPgt6nyczJp_QGtrjpb9Bjbdf+aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxijAsEu_h3sTy=8kMqPgt6nyczJp_QGtrjpb9Bjbdf+aw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 31, 2022 at 12:42:01PM +0300, Amir Goldstein wrote:
> On Tue, May 31, 2022 at 11:59 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Tue, May 31, 2022 at 07:58:48AM +1000, Dave Chinner wrote:
> > > On Mon, May 30, 2022 at 07:17:42PM +0300, Amir Goldstein wrote:
> > > > On Mon, May 30, 2022 at 4:29 PM Zorro Lang <zlang@redhat.com> wrote:
> > > > >
> > > > > On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> > > > > > For this test to run on overlayfs we open a different file to perform
> > > > > > shutdown+fsync while keeping the writeback target file open.
> > > > > >
> > > > > > We should probably perform fsync on the writeback target file, but
> > > > > > the bug is reproduced on xfs and overlayfs+xfs also as is.
> > > > > >
> > > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > > ---
> > > > > >
> > > > > > Zorro,
> > > > > >
> > > > > > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > > > > > and tested that both configs fail with the same warning on v5.10.109.
> > > > > >
> > > > > > I tried changing fsync to syncfs for the test to be more correct in the
> > > > > > overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> > > > > > and that would need some more output filtering (or disregarding output
> > > > > > completely).
> > > > > >
> > > > > > Since this minimal change does the job and does not change test behavior
> > > > > > on xfs on any of the tested kernels, I thought it might be good enough.
> > > > > >
> > > > > > Thanks,
> > > > > > Amir.
> > > > > >
> > > > > >  tests/generic/623 | 5 ++++-
> > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/tests/generic/623 b/tests/generic/623
> > > > > > index ea016d91..bb36ad25 100755
> > > > > > --- a/tests/generic/623
> > > > > > +++ b/tests/generic/623
> > > > > > @@ -24,10 +24,13 @@ _scratch_mount
> > > > > >  # XFS had a regression where it failed to check shutdown status in the fault
> > > > > >  # path. This produced an iomap warning because writeback failure clears Uptodate
> > > > > >  # status on the page.
> > > > > > +# For this test to run on overlayfs we open a different file to perform
> > > > > > +# shutdown+fsync while keeping the writeback target file open.
> > >
> > > To trigger the original bug, the post-shutdown fsync needs to be run
> > > on the original file. That triggers a writeback error writeback
> > > which clears the uptodate state on the mapped page. The mwrite that
> > > follows then trips over the state of the page and attempts IO
> > > operations without first checking shutdown state.
> > >
> > > Hence moving the fsync to a different file will break the mechanism
> > > the regression test uses to trigger the original bug.
> > >
> > > > > >  file=$SCRATCH_MNT/file
> > > > > >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> > > > > >  ulimit -c 0
> > > > > > -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > > > > > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> > > > > > +     -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
> > > > >
> > > > > Did you try to reproduce the original bug which this test case covers?
> > > > >
> > > >
> > > > Yes. As I wrote:
> > > > "tested that both configs fail with the same warning on v5.10.109"
> > > > Meaning the same bug that the test triggered before my change
> > > > in v5.10 is still triggered on xfs in v5.10 and it is triggered on both
> > > > xfs and overlayfs+xfs in v5.10 with my change.
> > >
> > > It reproduced on 5.10, but not because of the reasons you are
> > > suggesting.
> > >
> > > >
> > > > > According to the "man xfs_io":
> > > > >
> > > > >        open [[ -acdfrstRTPL ] path ]
> > > > >               Closes the current file, and opens the file specified by path instead.
> > > >
> > > > The documentation is incorrect.
> > > > Current file is not closed.
> > >
> > > It is not closed, but it's also not the target of subsequent file
> > > operations until you use "file 0" to switch back to it...
> >
> > I checked the xfsprogs/io/open.c, it truely doesn't "Close the current file",
> > (need to update the man-page?) and it looks like make all opened files as a
> > list, then operate them one by one(?):
> >
> >   execve("/usr/sbin/xfs_io", ["xfs_io", "-c", "mmap 0 4k", "-c", "mwrite 0 4k", "-c", "open testfile", "-c", "fsync", "-c", "mwrite 0 4k", "testfile"], 0x7ffdc2285b78 /* 42 vars */) = 0
> >   ...
> >   openat(AT_FDCWD, "testfile", O_RDWR)    = 3
> >   ...
> >   mmap(NULL, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, 3, 0) = 0x7efc04548000
> >   ...
> >   openat(AT_FDCWD, "testfile", O_RDWR)    = 4
> >   ...
> >   fsync(3)                                = 0
> >   fsync(4)                                = 0
> >   exit_group(0)                           = ?
> >   +++ exited with 0 +++
> >
> > Anyway, looks like we're stuck at here.
> 
> We are not stuck at all.
> It is very simple to fix.
> As you can see from the strace above and from Dave explanation,
> The test as I posted in v1 already does the right thing, because
> it does fsync the original file.
> Which explains why the test I posted DOES work as expected on
> both xfs and overlayfs and DOES reproduce the bug.
> 
> However, if we want to write the test in a way that does NOT assume
> that xfs_io -c fsync operates on all the open files, I need to add some
> more commands:
> 
> $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
>         -c "open $(_scratch_shutdown_handle)" -c shutdown \
>         -c "file 0" -c fsync \
>         -c "mwrite 0 4k" $file | _filter_scratch | _filter_xfs_io
> 
> The only problem is this complicates the golden output
> which does not produce the same output for overlayfs and xfs
> open files, so I need to write another filter for that.
> 
> The question is, is it worth it?
> 
> Are we ever going to change xfs_io -c fsync to behave
> differently and fsync only the current file?
> 
> If not, that I can just change the comment and keep the command
> and golden output:
> 
>  # path. This produced an iomap warning because writeback failure
> clears Uptodate
>  # status on the page.
>  # For this test to run on overlayfs we open a different file to perform
> -# shutdown+fsync while keeping the writeback target file open.
> +# shutdown while keeping the writeback target file open.
> +# xfs_io -c fsync post-shutdown performs fsync also on the writeback
> target file,
> +# which is critical for triggering the writeback failure.
>  file=$SCRATCH_MNT/file
>  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
>  $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
>         -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
>         -c "mwrite 0 4k" $file | _filter_xfs_io

OK, if you persist, my personal opinion is: at least don't change the
original test logic of other fs especially when they're not wrong but
the change is a little tricky.

For example (not tested):

  shutdown_cmd="shutdown"
  # shutdown the underlying fs if there is
  shutdown_handle="$(_scratch_shutdown_handle)"
  if [ "$shutdown_handle" != "$SCRATCH_MNT" ];then
          shutdown_cmd="\"open $shutdown_handle\" -c shutdown -c close"
  fi
  $XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c ${shutdown_cmd}
          -c fsync -c "mwrite 0 4k" $file | _filter_xfs_io

Thanks,
Zorro

> 
> 
> > So I have 3 crude methods which is just
> > out of my mind, hope to get review:)
> >
> > 1) Skip this test for overlay directly, as this patch does.
> > 2) Add a _require_real_scratch_shutdown() helper, require the $FSTYP supporting
> >    GOINGDOWN ioctl, don't fallback to the underlying fs. Then let generic/623
> >    use it to skip overlay and other fs which really doesn't support shutdown.
> > 3) Change xfsprogs/io/shutdown.c, let shutdown_f() accept an extra mountpoint
> >    path argument, to shutdown a specified mountpoint (?? not sure if it's
> >    reasonable for xfs_io :). Then let generic/623 require and use this feature.
> >
> 
> All of the above are overkills.
> The test fix already works.
> 
> Thanks,
> Amir.
> 

