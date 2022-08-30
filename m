Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85169ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 23:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiH3XmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 19:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiH3XmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 19:42:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D2F57571;
        Tue, 30 Aug 2022 16:42:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q15so7477205pfn.11;
        Tue, 30 Aug 2022 16:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=gCvQhwuZDokCsu5KWO0lmIzLPJsW+2ABY33ZHkYeJRc=;
        b=kpmmqZYq7rEihanXoGtKxH1VxWKIEyvdOBPYsf73VfEDHSWO8nJg6Z9QwGZAwwF9wB
         DtEHsUylUMB8skMXFd5sM3Je5cKA7aPr+u2b5mpBMLUnO4Gq4YlF2gxzo3pAT7c9QSoM
         fUOvT8wsgCRKzznPfOA/WAajy8ztTKw+JCHtM0UgO2Ao47owRdTmTvvKFwLrNHnKLkUk
         EjYmmgkL5xGxtjaEp3FoPrIcUAjSXn4BDhtuU7bb2xOK3XwTqlLV273JxGIFAWnrWsuW
         obT2hHPOGLI5/dUxzE2+YGlsyDf5IkgUBwUZqtqYO23SfVll7TPribPDT63G/j9X2xqO
         Zr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=gCvQhwuZDokCsu5KWO0lmIzLPJsW+2ABY33ZHkYeJRc=;
        b=o38XpDpKKbv/ufKbVHbYDyLbz7uD9neLYIEKhC+DKmOjEH3HS1wSusb0uGyHnr2IC7
         TrPcqHkjBh3YPcCMHO9AdgIVWJLIXK27ZOmXk8BAfBOKmswZLmaen6ylJUix9p54kf74
         ID6ifxw7g7Fa0xleAux18U4G+b2Vj30CG7ZAx0ecEK1ZgD3Th7NpW4nbXOQ2keuTTCHk
         jbYvwojSTl0E2M/nZtuCSm3z6eTVXyRzzd7Z88yV2UssoHb7GjJQCwRsLa1Ucmhwqmcz
         Dz+k+7nY6TBAVFPIUdbTF+PSmh3sbI73ADwqc404xLn2BFdHS5pD6NXqn8z9ZKX67Dve
         ZRlw==
X-Gm-Message-State: ACgBeo1Rs6iR3IUM1Vu877qjfv9EzkiRtFimoytri/5HqrJwOVGpkLje
        vn30vXbZfbMIsrvCukmk9a+hf8AChkQDmMAN20Yf+/Vri3c=
X-Google-Smtp-Source: AA6agR5MsthtN3meOWuwmgp5nb52KmB4F3Pobfge4ACtgb1ZhCPBE16E876zpz7DhAT+PAFhCBE2ukY+0c9sKrWbWG4=
X-Received: by 2002:a63:4e25:0:b0:41c:62a2:ecc3 with SMTP id
 c37-20020a634e25000000b0041c62a2ecc3mr20057740pgb.596.1661902937238; Tue, 30
 Aug 2022 16:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-5-jencce.kernel@gmail.com> <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
In-Reply-To: <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 07:42:05 +0800
Message-ID: <CADJHv_u7itLBJ+ET5ciaH-f6Ko9r7J-DBcZYz_n6Z3dbbb45pg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] xfs/144: remove testing root dir inode in AG 1
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 3:49 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Tue, Aug 30, 2022 at 12:44:33PM +0800, Murphy Zhou wrote:
> > Since this xfsprogs commit
> >   1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
> > this operation is not allowed.
> >
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  tests/xfs/144 | 10 +---------
> >  1 file changed, 1 insertion(+), 9 deletions(-)
> >
> > diff --git a/tests/xfs/144 b/tests/xfs/144
> > index 706aff61..3f80d0ee 100755
> > --- a/tests/xfs/144
> > +++ b/tests/xfs/144
> > @@ -17,9 +17,6 @@ _begin_fstest auto mkfs
> >  _supported_fs xfs
> >  _require_test
> >
> > -# The last testcase creates a (sparse) fs image with a 2GB log, so we need
> > -# 3GB to avoid failing the mkfs due to ENOSPC.
> > -_require_fs_space $TEST_DIR $((3 * 1048576))
> >  echo Silence is golden
> >
> >  testfile=$TEST_DIR/a
> > @@ -36,7 +33,7 @@ test_format() {
> >  }
> >
> >  # First we try various small filesystems and stripe sizes.
> > -for M in `seq 298 302` `seq 490 520`; do
> > +for M in `seq 1024 1030` ; do
>
> Can `seq 1024 1030` replace `seq 298 302` `seq 490 520`? I don't know how
> Darrick choose these numbers, better to ask the original authoer of this
> case. Others looks reasonable for me.

Oh, they are needed for fs size reason and log size reason during my test.

Forgot to move this part of patch to the fs size one.
>
> Thanks,
> Zorro
>
> >       for S in `seq 32 4 64`; do
> >               test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> >       done
> > @@ -45,11 +42,6 @@ done
> >  # log end rounded beyond EOAG due to stripe unit
> >  test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
> >
> > -# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > -# because this check only occurs after the root directory has been allocated,
> > -# which mkfs -N doesn't do.
> > -test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> > -
> >  # success, all done
> >  status=0
> >  exit
> > --
> > 2.31.1
> >
>
