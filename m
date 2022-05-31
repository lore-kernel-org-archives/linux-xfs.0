Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6329C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 31 May 2022 08:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245034AbiEaI7H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 May 2022 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243566AbiEaI7G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 May 2022 04:59:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2542FBC36
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 01:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653987544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saLiCzbZolXA6IxcAM6JgwtRQPVc+6ncT31YzO8nYKw=;
        b=IPSlzadpacqXpA957EX3tO+IbKfzgoKU8WLqjcr36W4Kwn6xfERABqHSGs5VvSeA5sMD7g
        1i5PAf+fcRT9IYBfoBEjA1TX7wWJGoXnisDHa16wZzYA9Aq/bGeY9JE9EG1OzYjew1YXH7
        4D0ZgpvZsNsnASw8ahaJwgvEWly8cq4=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-aunymTGRPrWhLBl42m_M1w-1; Tue, 31 May 2022 04:59:02 -0400
X-MC-Unique: aunymTGRPrWhLBl42m_M1w-1
Received: by mail-oo1-f70.google.com with SMTP id v67-20020a4a5a46000000b0033331e32ee0so7060839ooa.20
        for <linux-xfs@vger.kernel.org>; Tue, 31 May 2022 01:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=saLiCzbZolXA6IxcAM6JgwtRQPVc+6ncT31YzO8nYKw=;
        b=bQPqoLW33Yl3beOTEv65HZpyrTYIETkrmRR2Xs8x2fYEDEm6BmwNPuN301fSlrJdL4
         WDfw7YqsJay4h1tIoWu7noR2yM9QzN69O7JUhX34VP5Fu5BxiHTSA9oV5gHnCU4Tj2fw
         lvFjKAtFW9Dkr8YkOO2fn5D7BhX74cTAKUMtPiXR1IyOPslBcrQFvujfNjB5HM+zDEmE
         2VBND94utaYebvXLRIMoy0TLcE10IDLFdtTIvZFzIZmn0xFvo7ENtW+iMOWqWiREE7oR
         evZxHYs1Ih1vboJwemtzBE8POAs6dg27skWl4+eTu8tLEoxyOJKD8vtBaOC1rw1G33p8
         Xm+g==
X-Gm-Message-State: AOAM533DVe8+2PzKCT2SdQqe8BTWvnzuO171fxwbdbt68HUyRTQQv/Jd
        OLCSzdpa6+osPm+m0WYR/V2P3EdMYcjgyk3bLWwZ9CnDOwXJynL2IrDNXgImDesqXGZRWFes5Qe
        mw2TK7gp8R+/fWwD7fzXh
X-Received: by 2002:a05:6808:1719:b0:2f9:ac49:842d with SMTP id bc25-20020a056808171900b002f9ac49842dmr12157192oib.234.1653987541799;
        Tue, 31 May 2022 01:59:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpWwHwDSKGHWKGyY9mMoL8M4BnXiI60s3KB7fHDccC2iorU3btJJHNS5LuhC9yxDdO984Pqg==
X-Received: by 2002:a05:6808:1719:b0:2f9:ac49:842d with SMTP id bc25-20020a056808171900b002f9ac49842dmr12157185oib.234.1653987541505;
        Tue, 31 May 2022 01:59:01 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y9-20020a056830070900b00606387601a2sm5948305ots.34.2022.05.31.01.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 01:59:00 -0700 (PDT)
Date:   Tue, 31 May 2022 16:58:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
Message-ID: <20220531085855.zpof4m3vmm6jlv4c@zlang-mailbox>
References: <20220530112905.79602-1-amir73il@gmail.com>
 <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
 <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
 <20220530215848.GR3923443@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530215848.GR3923443@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 31, 2022 at 07:58:48AM +1000, Dave Chinner wrote:
> On Mon, May 30, 2022 at 07:17:42PM +0300, Amir Goldstein wrote:
> > On Mon, May 30, 2022 at 4:29 PM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> > > > For this test to run on overlayfs we open a different file to perform
> > > > shutdown+fsync while keeping the writeback target file open.
> > > >
> > > > We should probably perform fsync on the writeback target file, but
> > > > the bug is reproduced on xfs and overlayfs+xfs also as is.
> > > >
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >
> > > > Zorro,
> > > >
> > > > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > > > and tested that both configs fail with the same warning on v5.10.109.
> > > >
> > > > I tried changing fsync to syncfs for the test to be more correct in the
> > > > overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> > > > and that would need some more output filtering (or disregarding output
> > > > completely).
> > > >
> > > > Since this minimal change does the job and does not change test behavior
> > > > on xfs on any of the tested kernels, I thought it might be good enough.
> > > >
> > > > Thanks,
> > > > Amir.
> > > >
> > > >  tests/generic/623 | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tests/generic/623 b/tests/generic/623
> > > > index ea016d91..bb36ad25 100755
> > > > --- a/tests/generic/623
> > > > +++ b/tests/generic/623
> > > > @@ -24,10 +24,13 @@ _scratch_mount
> > > >  # XFS had a regression where it failed to check shutdown status in the fault
> > > >  # path. This produced an iomap warning because writeback failure clears Uptodate
> > > >  # status on the page.
> > > > +# For this test to run on overlayfs we open a different file to perform
> > > > +# shutdown+fsync while keeping the writeback target file open.
> 
> To trigger the original bug, the post-shutdown fsync needs to be run
> on the original file. That triggers a writeback error writeback
> which clears the uptodate state on the mapped page. The mwrite that
> follows then trips over the state of the page and attempts IO
> operations without first checking shutdown state.
> 
> Hence moving the fsync to a different file will break the mechanism
> the regression test uses to trigger the original bug.
> 
> > > >  file=$SCRATCH_MNT/file
> > > >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> > > >  ulimit -c 0
> > > > -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > > > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> > > > +     -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
> > >
> > > Did you try to reproduce the original bug which this test case covers?
> > >
> > 
> > Yes. As I wrote:
> > "tested that both configs fail with the same warning on v5.10.109"
> > Meaning the same bug that the test triggered before my change
> > in v5.10 is still triggered on xfs in v5.10 and it is triggered on both
> > xfs and overlayfs+xfs in v5.10 with my change.
> 
> It reproduced on 5.10, but not because of the reasons you are
> suggesting.
> 
> > 
> > > According to the "man xfs_io":
> > >
> > >        open [[ -acdfrstRTPL ] path ]
> > >               Closes the current file, and opens the file specified by path instead.
> > 
> > The documentation is incorrect.
> > Current file is not closed.
> 
> It is not closed, but it's also not the target of subsequent file
> operations until you use "file 0" to switch back to it...

I checked the xfsprogs/io/open.c, it truely doesn't "Close the current file",
(need to update the man-page?) and it looks like make all opened files as a
list, then operate them one by one(?):

  execve("/usr/sbin/xfs_io", ["xfs_io", "-c", "mmap 0 4k", "-c", "mwrite 0 4k", "-c", "open testfile", "-c", "fsync", "-c", "mwrite 0 4k", "testfile"], 0x7ffdc2285b78 /* 42 vars */) = 0
  ...
  openat(AT_FDCWD, "testfile", O_RDWR)    = 3
  ...
  mmap(NULL, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_SHARED, 3, 0) = 0x7efc04548000
  ...
  openat(AT_FDCWD, "testfile", O_RDWR)    = 4
  ...
  fsync(3)                                = 0
  fsync(4)                                = 0
  exit_group(0)                           = ?
  +++ exited with 0 +++

Anyway, looks like we're stuck at here. So I have 3 crude methods which is just
out of my mind, hope to get review:)

1) Skip this test for overlay directly, as this patch does.
2) Add a _require_real_scratch_shutdown() helper, require the $FSTYP supporting
   GOINGDOWN ioctl, don't fallback to the underlying fs. Then let generic/623
   use it to skip overlay and other fs which really doesn't support shutdown.
3) Change xfsprogs/io/shutdown.c, let shutdown_f() accept an extra mountpoint
   path argument, to shutdown a specified mountpoint (?? not sure if it's
   reasonable for xfs_io :). Then let generic/623 require and use this feature.

Thanks,
Zorro

> 
> > > Although I doubt if it always real close the current file, but you open to get
> > > a new file descriptor, later operations will base on new fd. I don't know if
> > > it still has original testing coverage.
> > 
> > fsync on the fs root dir is not the same as fsync on the original file.
> 
> Yup, and that's what will break the regression test.
> 
> But why does it still fail on v5.10.109?
> 
> Well, that's because of a quirk of the xfs_io fsync command.  It
> doesn't have the CMD_FLAG_ONESHOT flag set on it, so it operates on
> *all open files*, not just the current file.
> 
> IOWs, the misunderstanding of how the bug is triggered has been
> covered up by the misunderstanding of how the xfs_io open file table
> and the fsync command interact.
> 
> > mwrite does not change because mwrite is not acted on open fd
> > it is acted on memory mapping of mmap.
> > 
> > I can either change fd again to first fd before doing fsync
> > or change fsync to syncfs.
> 
> Do not change it to syncfs - that executes completely different
> writeback and metadata sync code paths with different error
> propagation and may well result in very different behaviour from the
> underlying filesystem.  Fundamentally, syncfs() and fsync() are not
> interchangeable from a regression test POV - you *might* get the
> same high level result, but the low level code behaves very
> differently...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

