Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63980C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 16:17:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiE3QR4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 12:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbiE3QR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 12:17:56 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF73532E5;
        Mon, 30 May 2022 09:17:54 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id cv1so10309424qvb.5;
        Mon, 30 May 2022 09:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ILkgTjkaUQZ2I0uZmuE2xANkh0BVQ0rWXtc+1Ixun/g=;
        b=oCpfj/s24CA6DiMTcf4gT85IDfc3NFcHcoShbVQclz/m6CWqT8an2ZcyxziAyW57ha
         csAee1Anp/AcX+rSd/WYCq8JRztki27MOQ/f0TrMnd39IVi4c4Rb1XvLCnK102Uj3JvX
         vVTA5KSIcJVnooqBm2aMCshpvmpAHQ3FmxNONpo9RLV8ZJ4otxrhsmbc/B+uvAKzAxyO
         WD8Nfey9uechvgnIN1N9C3nW/AOj2/UTZ83eq4ArnA3Xg/qy4aQr3s/DLM0K0jKgXKYO
         Er1hrGUVcAlmC+KaA8TsfaeZ+TzxGblAXSLQE/+8FaFKJjR45KFxaCSzDAAkyNLtdZgq
         83rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ILkgTjkaUQZ2I0uZmuE2xANkh0BVQ0rWXtc+1Ixun/g=;
        b=Q6J5UZVBKUm3Lo6CJc4pd/EZAEpezc5ZmmJ/suewq9US6DteEFnTiJ0xfuJ6CRyYnR
         QJYlpJtfhXwrW31XF88xQP+CxtjWnVjp/Xtz52lUOML8Fv0uSk0aDxMHrnbrzHyiDndZ
         hQ41AIGDHo5WVoFmV/DfxN2urcWt/9FEpOkRFpjwcqAeuYgnOZS3V4eHZaX/6bvl2wen
         eFXgdN8kZzxIm5RZa1xN2+a7jeH3O5fMecgb9DMPFHm67aXWps9MTT9t3DX82xj+4ruf
         ccJ/FRy5MsHdem2InTgJ8Ek9C9V+Geqx9RLT1UZ4cgxP6Jvs5f6E/lt2rQqT+8Ul4Ezt
         pbNw==
X-Gm-Message-State: AOAM533ZfuCkLAIZNgcfXoygsox6rUzhzozTEyMEuqQeUb8DEn2IHkfs
        9B2CXxBePQh3rjEQsof6YWJeoN/m41bTW3bfTrvBHszw7YvKOw==
X-Google-Smtp-Source: ABdhPJyCP2KqOki+57yDkEYhneuC3e7J66HO4UROim+PL/+s7Tc/8oJpptfUVOn88Qbv0BSIj6v0cNuriMHJ+kwcRI8=
X-Received: by 2002:a05:6214:1c83:b0:443:6749:51f8 with SMTP id
 ib3-20020a0562141c8300b00443674951f8mr46857204qvb.74.1653927473797; Mon, 30
 May 2022 09:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220530112905.79602-1-amir73il@gmail.com> <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
In-Reply-To: <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 30 May 2022 19:17:42 +0300
Message-ID: <CAOQ4uxgoGxdWcqU6duRC58mtAPq5ZcwJQX3+=mX0yz2BB8J7tQ@mail.gmail.com>
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
To:     Zorro Lang <zlang@redhat.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 30, 2022 at 4:29 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> > For this test to run on overlayfs we open a different file to perform
> > shutdown+fsync while keeping the writeback target file open.
> >
> > We should probably perform fsync on the writeback target file, but
> > the bug is reproduced on xfs and overlayfs+xfs also as is.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Zorro,
> >
> > I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> > and tested that both configs fail with the same warning on v5.10.109.
> >
> > I tried changing fsync to syncfs for the test to be more correct in the
> > overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> > and that would need some more output filtering (or disregarding output
> > completely).
> >
> > Since this minimal change does the job and does not change test behavior
> > on xfs on any of the tested kernels, I thought it might be good enough.
> >
> > Thanks,
> > Amir.
> >
> >  tests/generic/623 | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/tests/generic/623 b/tests/generic/623
> > index ea016d91..bb36ad25 100755
> > --- a/tests/generic/623
> > +++ b/tests/generic/623
> > @@ -24,10 +24,13 @@ _scratch_mount
> >  # XFS had a regression where it failed to check shutdown status in the fault
> >  # path. This produced an iomap warning because writeback failure clears Uptodate
> >  # status on the page.
> > +# For this test to run on overlayfs we open a different file to perform
> > +# shutdown+fsync while keeping the writeback target file open.
> >  file=$SCRATCH_MNT/file
> >  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> >  ulimit -c 0
> > -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> > +     -c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \
>
> Did you try to reproduce the original bug which this test case covers?
>

Yes. As I wrote:
"tested that both configs fail with the same warning on v5.10.109"
Meaning the same bug that the test triggered before my change
in v5.10 is still triggered on xfs in v5.10 and it is triggered on both
xfs and overlayfs+xfs in v5.10 with my change.

> According to the "man xfs_io":
>
>        open [[ -acdfrstRTPL ] path ]
>               Closes the current file, and opens the file specified by path instead.

The documentation is incorrect.
Current file is not closed.

> Although I doubt if it always real close the current file, but you open to get
> a new file descriptor, later operations will base on new fd. I don't know if
> it still has original testing coverage.

fsync on the fs root dir is not the same as fsync on the original file.
mwrite does not change because mwrite is not acted on open fd
it is acted on memory mapping of mmap.

I can either change fd again to first fd before doing fsync
or change fsync to syncfs. Both solutions should be fine,
just a bit more work on the golden output.
I just wonder if we need to do anything at all as the bug is
reproduced and warning triggered anyway.

>
> I'd like to help this case to support overlay, presuppose original fs
> testing isn't changed. Or it's not worth.
>
> Welcome more review points from the author of this case and others.
>

Yes, me as well.

Thanks,
Amir.
