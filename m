Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628F8E7D0AA
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 20:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbjIUUeA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbjIUUdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 16:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B98897DD
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695318001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkPn1rRuDeTSkQf8G31WO9C/xqlwOshTJosTm+hvLws=;
        b=iMoLMdx+I34EBHUOeJMjVSxtBWSYLscfp2GsrTy/c53Esg2XwUhg+XTyo6hE4V9NlyXsal
        oO/gH5D0GzvCcR/bw0zHMiED+qNXlYU0UDgy7LGXSD+7a5Tv8auC7iak5ZoQePO3QS9X93
        MvkrEWlZH5fw8DJRBsdvXafbu7vluDs=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-5ZMz7KiSO9Cwuf___t3s7w-1; Thu, 21 Sep 2023 10:24:32 -0400
X-MC-Unique: 5ZMz7KiSO9Cwuf___t3s7w-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-690a0eedb2aso899665b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 07:24:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695306271; x=1695911071;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkPn1rRuDeTSkQf8G31WO9C/xqlwOshTJosTm+hvLws=;
        b=SYob0o/S/Qdpx0YunD8dQPJyUkHNcYdF5uFsKjK1nft5ZHHrG2QywPTJD9Y7PopvMf
         mHJXLmPVj5OKfvaBsaMgMbFDx7vJXthZ3gD+J3Lt4uh4FvbdF9cUfSwkUVzU9HTaBLn7
         oFInifFyxGDljfTkP8Gwl4bjguylzPusEuLdDDkjEsTZnSY87TVZ1D+cg+W5hMo9dVhl
         YoRua+UVbCVbEAVAawvRnR0iL3yhhJSi+duzulO+ih8t4ND6EEIf9rVjR4IFv/sxtzGN
         k1QoUi9hkCubI3m0hsvjJHLuz+QinKZO7ZxhbZsOp6G3v6v7KXbpKC7yKDsaV8Yllsmd
         UFOQ==
X-Gm-Message-State: AOJu0YyeFAHABcruKbMZx6fHBtAoyf1KEk6m9Gfwnfclt93MFcqLn5Hi
        tLeVYu8eY9BcygG9dxRGqgFet2lpyUx19bsy0qkS5JsfveRT8iP4Q6XeloAW3MPgiyg8ivvoQxr
        8ToTjC1ihAh1pI7iNVfkY
X-Received: by 2002:a05:6a00:188e:b0:68b:f529:a329 with SMTP id x14-20020a056a00188e00b0068bf529a329mr6943435pfh.5.1695306270751;
        Thu, 21 Sep 2023 07:24:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjXorDkEKq9+yTotM1RDnO2lIjUdzwDM4DqHwQyVI5QbcUJU1NUNUlr90ILKxU4f/UjeEcWQ==
X-Received: by 2002:a05:6a00:188e:b0:68b:f529:a329 with SMTP id x14-20020a056a00188e00b0068bf529a329mr6943405pfh.5.1695306270313;
        Thu, 21 Sep 2023 07:24:30 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q24-20020a62e118000000b0069029a3196dsm1409187pfh.184.2023.09.21.07.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:24:29 -0700 (PDT)
Date:   Thu, 21 Sep 2023 22:24:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ruiwen Zhao <ruiwen@google.com>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] overlay: add test for rename of lower symlink with
 NOATIME attr
Message-ID: <20230921142426.p5g7yqf2gunemnd6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20230920130355.62763-1-amir73il@gmail.com>
 <20230920151403.gsh5gphvlilhp6sv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxhxsg2AwttYPfhSLQQNbFxo2pmyNUMTC8QpxNw6L_afpw@mail.gmail.com>
 <20230921062645.lhryfrod7ggdxfuh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxjNy6tD87dsGKAOwu6VpkoH3+kgzOEw=KQOzDF1WhhN=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjNy6tD87dsGKAOwu6VpkoH3+kgzOEw=KQOzDF1WhhN=A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 11:00:37AM +0300, Amir Goldstein wrote:
> On Thu, Sep 21, 2023 at 9:26 AM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Wed, Sep 20, 2023 at 06:34:21PM +0300, Amir Goldstein wrote:
> > > On Wed, Sep 20, 2023 at 6:14 PM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Wed, Sep 20, 2023 at 04:03:55PM +0300, Amir Goldstein wrote:
> > > > > A test for a regression from v5.15 reported by Ruiwen Zhao:
> > > > > https://lore.kernel.org/linux-unionfs/CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com/
> >
> > Could you give one more sentence to tell what kind of regression
> > does this case test for? Not only a link address.
> >
> > > > >
> > > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > > ---
> > > > >
> > > > > Zorro,
> > > > >
> > > > > This is a test for a regression in kernel v5.15.
> > > > > The fix was merged for 6.6-rc2 and has been picked for
> > > > > the upcoming LTS releases 5.15, 6.1, 6.5.
> > > > >
> > > > > The reproducer only manifests the bug in fs that inherit noatime flag,
> > > > > namely ext4, btrfs, ... but not xfs.
> 
> FYI, I made a mistake in the statement above.
> xfs does support inherit of noatime flag, but
> it does not inherit noatime for *symlinks*.
> 
> I added the _require_chattr_inherit helper that you suggested
> in v2, but it only checks for inherit of noatime flag (the 2nd _notrun).
> I did not add a helper for _require_chattr_inherit_symlink
> because it was too specific and so I left the 3rd _notrun
> open coded in the test in v2.

OK, if xfs thinks it's an expected behavior which won't be changed :)

Thanks,
Zorro

> 
> > > > >
> > > > > The test does _notrun on xfs for that reason.
> > > > >
> > > > > Thanks,
> > > > > Amir.
> > > > >
> > > > >  tests/overlay/082     | 68 +++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/overlay/082.out |  2 ++
> > > > >  2 files changed, 70 insertions(+)
> > > > >  create mode 100755 tests/overlay/082
> > > > >  create mode 100644 tests/overlay/082.out
> > > > >
> > > > > diff --git a/tests/overlay/082 b/tests/overlay/082
> > > > > new file mode 100755
> > > > > index 00000000..abea3c2b
> > > > > --- /dev/null
> > > > > +++ b/tests/overlay/082
> > > > > @@ -0,0 +1,68 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test 082
> > > > > +#
> > > > > +# kernel commit 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
> > > > > +# from v5.15 introduced a regression.
> >
> > Hi Amir,
> >
> > Thanks for this new regression test. More detailed (picky:) review points
> > as below ...
> >
> > So this commit is the one which introduced a regression. But we generally
> > say what kind of regression does this case test for, in this comment.
> >
> > > > > +#
> > > > > +. ./common/preamble
> > > > > +_begin_fstest auto quick
> >
> > According the source code of this case, please think about more detailed group
> > names, likes: "symlink", "copyup" and "atime".
> >
> > > > > +
> > > > > +# Import common functions.
> > > > > +. ./common/filter
> >
> > I think this case doesn't use any filter helpers, right?
> >
> > > > > +
> > > > > +# real QA test starts here
> > > > > +_supported_fs overlay
> > > > > +_fixed_by_kernel_commit ab048302026d \
> > > > > +     "ovl: fix failed copyup of fileattr on a symlink"
> > > > > +
> > > > > +_require_scratch
> > > > > +_require_chattr A
> > > > > +
> > > > > +# remove all files from previous runs
> > > > > +_scratch_mkfs
> > > > > +
> > > > > +# prepare lower test dir with NOATIME flag
> > > > > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > > > > +mkdir -p $lowerdir/testdir
> > > > > +$CHATTR_PROG +A $lowerdir/testdir >> $seqres.full 2>&1 ||
> > > > > +     _notrun "base fs $OVL_BASE_FSTYP does not support No_Atime flag"
> > > > > +
> > > > > +# The NOATIME is inheritted to children symlink in ext4/fs2fs
> > > > > +# (and on tmpfs on recent kernels).
> > > > > +# The overlayfs test will not fail unless base fs is
> > > > > +# one of those filesystems.
> > > > > +#
> > > > > +# The problem with this inheritence is that the NOATIME flag is inheritted
> > > > > +# to a symlink and the flag does take effect, but there is no way to query
> > > > > +# the flag (lsattr) or change it (chattr) on a symlink, so overlayfs will
> > > > > +# fail when trying to copy up NOATIME flag from lower to upper symlink.
> > > > > +#
> > > > > +touch $lowerdir/testdir/foo
> > > > > +ln -sf foo $lowerdir/testdir/lnk
> > > > > +
> > > > > +$LSATTR_PROG -l $lowerdir/testdir/foo >> $seqres.full 2>&1
> > > > > +$LSATTR_PROG -l $lowerdir/testdir/foo | grep -q No_Atime || \
> > > > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag"
> > > > > +
> > > > > +before=$(stat -c %x $lowerdir/testdir/lnk)
> > > > > +echo "symlink atime before readlink: $before" >> $seqres.full 2>&1
> >
> > I remember some filesystems' timestamp for atime (e.g. exfat) might have more
> > seconds granularity. So it would be better to `sleep 2s` at here.
> >
> > Correct me if someone fs need more or less :)
> >
> 
> That would be a futile waste of 2 seconds IMO, because
> Those niche fs probably do not support chattr and because
> This is an overlayfs regression test and overlayfs is highly
> unlikely to be running in production on those niche fs and it
> probably does not support many of them.
> 
> 
> > > > > +cat $lowerdir/testdir/lnk
> > > > > +after=$(stat -c %x $lowerdir/testdir/lnk)
> > > > > +echo "symlink atime after readlink: $after" >> $seqres.full 2>&1
> > > > > +
> > > > > +[ "$before" == "$after" ] || \
> > > > > +     _notrun "base fs $OVL_BASE_FSTYP does not inherit No_Atime flag on symlink"
> > > > > +
> > > > > +# mounting overlay
> > > > > +_scratch_mount
> > > > > +
> > > > > +# moving symlink will try to copy up lower symlink flags
> > > > > +mv $SCRATCH_MNT/testdir/lnk $SCRATCH_MNT/
> > > >
> > > > Lots of above codes are checking if the underlying fs supports No_Atime (and inherit),
> > > > and _notrun if not support. How about do these checking steps in a require_*
> > > > function locally or in common/, likes _require_noatime_inheritance(). And we also
> > > > can let _require_chattr accept one more argument to specify a test directory.
> > > >
> > >
> > > ok.
> > >
> > > > The "mv ..." command looks like the final testing step. If there's not that bug,
> > > > nothing happen, but I'm wondering what should happen if there's a bug?
> > >
> > > mv fails with error ENXIO, see linked bug report in commit message.
> >
> > Thanks, I think we can add "fails with error ENXIO at here, if the bug is reproduced" in
> > the comment of that "mv ..." command.
> >
> 
> Sure. no problem.
> I will post v2 soon with _require_chattr_inherit and
> above comments fixed.
> 
> Thanks for the review!
> Amir.
> 

