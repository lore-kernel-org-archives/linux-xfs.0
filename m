Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7223BC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 20:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiDXUqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiDXUqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 16:46:09 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95113526D;
        Sun, 24 Apr 2022 13:43:06 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id kc12so5254278qvb.0;
        Sun, 24 Apr 2022 13:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4xoPy8+dhKtJ0Xx6SesC3azCTijFiMpFee6us/XyeHE=;
        b=G6C0yEz2DHxtZQK+4sGf3gIyTIK8K8DIDQqUWLlNcyKXujEW9E4dVOKpzSbhRDlnf4
         TCojy3Ju2KtrJL19FXkgcJ4jCstN1bSzkBuBIbHW+kCLxqbohzy+nHcrSSg8IVdxIipy
         4yus8KNX6b5dw+Nd3adIPbDXUGzfl1lREvZWAOtqpWBcxpMNlFSZbAKDCDuiuPxy/Ks8
         xpWP/b0Et/ym+MLKj8vJmixRJEX0kTpZPHjECQ/mrtY8ot3CkVdd5wOq9YIkVvwGiuDm
         rns5TFnMtPdp/pFWq+uggkKfnfodB/9KSU9u1iDHi8vcJQi0/4ggBNUvBdMGjIbhCe7g
         hyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4xoPy8+dhKtJ0Xx6SesC3azCTijFiMpFee6us/XyeHE=;
        b=esn8iasTJKoSk9uiqGUiejFU15BUVe88NJI8+mZk/604Xm33mvc4pvgM+5Kt+95bVa
         Enyqn995gkz1DXjxAyzauiUo1vHFaOgdMGUNZ7WeSW5TRk1ItcyB94yZA8Eww4bII4ca
         V/CJjhs6VZoro5QCSz5fHR7hPDp1J5hpDK84yJLmbjs9pylFJY6CmekPGvdFMu1Bz1Ba
         WUv6mWMcWGlLu4narqlUqDyjDPrbCx+lJHUpYonviEdKkpi2W1+wOL3TNf0NRf4C4FD1
         ZP4m4+zzbOLbg/HBzmreqnC1K/vwuubKbXR+rkQDSTBpzuWgiOl/4XW3tY/AhPe/b88k
         FxmQ==
X-Gm-Message-State: AOAM531/uiRMdwuKo9gO296tL8Z8L7bWtBg9EGuv1dPvqsr8QwN9MMO7
        2gCc4qRzoJpJ+wuFaYVBb2HHzk6XjDRkbOn54BLyaeckSmQ=
X-Google-Smtp-Source: ABdhPJzZSrWnAEXARj1kzommzgU0jdYUtmjozk5tM7Yuh41zzZoTQQWtDovxArX5olMqxRHy5qoevmFrrpBAB9tupic=
X-Received: by 2002:a05:6214:1cc4:b0:435:35c3:f0f1 with SMTP id
 g4-20020a0562141cc400b0043535c3f0f1mr10629953qvd.0.1650832985720; Sun, 24 Apr
 2022 13:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220424063751.1067376-1-libaokun1@huawei.com>
 <CAOQ4uxgEXEgZ-uAYgiJi1sxX9Zzmg25NewBRiRQR6D8z+qOXHA@mail.gmail.com>
 <20220424132357.m4nxrmbgu2r6ljo4@zlang-mailbox> <CAOQ4uxiQ-aM4TJmU3QYhGsVzaPKphMg06k6gjAe8By5ZZ8DZgw@mail.gmail.com>
 <20220424184120.w7byatovi7plihkw@zlang-mailbox>
In-Reply-To: <20220424184120.w7byatovi7plihkw@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Apr 2022 23:42:54 +0300
Message-ID: <CAOQ4uxguZ4aYSJkothDDSFoE9EfMcRuFZ7Jo9L0X7xEFy6p8sg@mail.gmail.com>
Subject: Re: [RFC] common: overlay support tmpfs
To:     Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 24, 2022 at 9:41 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Sun, Apr 24, 2022 at 05:34:44PM +0300, Amir Goldstein wrote:
> > On Sun, Apr 24, 2022 at 4:24 PM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > On Sun, Apr 24, 2022 at 03:02:03PM +0300, Amir Goldstein wrote:
> > > > On Sun, Apr 24, 2022 at 2:21 PM Baokun Li <libaokun1@huawei.com> wrote:
> > > > >
> > > > > xfstests support overlay+tmpfs
> > > >
> > > > Thanks for this improvement.
> > > > Can you please share the results of ./check -overlay -g auto ?
> > > >
> > > > How many tests ran? notran? failed?
> > > >
> > > > Best if you have those numbers compared to
> > > > overlay+(already supported base fs)
> > > >
> > > >
> > > > >
> > > > > ```local.config.example
> > > > > export FSTYP=tmpfs
> > > > > export TEST_DEV=tmpfs_test
> > > > > export TEST_DIR=/tmp/test
> > > > > export TEST_FS_MOUNT_OPTS="-t tmpfs"
> > > > > export SCRATCH_DEV=tmpfs_scratch
> > > > > export SCRATCH_MNT=/tmp/scratch
> > > > > export MOUNT_OPTIONS="-t tmpfs"
> > > >
> > > > These mount options for tmpfs are very awkward.
> > > > Please fix _overlay_base_mount to use -t $OVL_BASE_FSTYP
> > > > like _test_mount() and _try_scratch_mount() do
> > > >
> > > >
> > > > > ```
> > > > > Run `./check -overlay tests` to execute test case on overlay+tmpfs.
> > > > >
> > > > > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > > > > ---
> > > > >  common/config | 4 ++--
> > > > >  common/rc     | 7 ++++++-
> > > > >  2 files changed, 8 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/common/config b/common/config
> > > > > index 1033b890..3dc047e8 100644
> > > > > --- a/common/config
> > > > > +++ b/common/config
> > > > > @@ -614,7 +614,7 @@ _overlay_config_override()
> > > > >         #    the new OVL_BASE_SCRATCH/TEST_DEV/MNT vars are set to the values
> > > > >         #    of the configured base fs and SCRATCH/TEST_DEV vars are set to the
> > > > >         #    overlayfs base and mount dirs inside base fs mount.
> > > > > -       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || return 0
> > > > > +       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ] || return 0
> > > > >
> > > > >         # Config file may specify base fs type, but we obay -overlay flag
> > > > >         [ "$FSTYP" == overlay ] || export OVL_BASE_FSTYP="$FSTYP"
> > > >
> > > > Please move the setting of OVL_BASE_FSTYP to the top of the function and use
> > > > [ "$OVL_BASE_FSTYP" == tmpfs ] consistently.
> > >
> > > Actually I'm wondering if we can bring in a parameter to clarify that xfstests need to
> > > build uplying fs base on a underlying fs, don't depend on the "[ -b "$TEST_DEV" ] ||
> > > [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ]" things. Due to:
> > > 1) overlayfs might not only base on localfs, it can over NFS or something likes it. (right?)
> >
> > No it cannot.
> > The way that xfstests -overlay work is that both upper and lower layers
> > are created on the base fs, therefore only fs supported as upper fs
> > can be tested with -overlay.
> > None of the network fs qualify as valid overlay upper fs.
> > The only other non-blockdev fs besides tmpfs that could be tested
> > with -overlay is virtiofs.
>
> Oh, looks like my memory is a little jumbled, maybe overlayfs can be exported to NFS :)
>

Yes it can.

> >
> > >    If so, how many judgements we need to add at here?
> > > 2) If xfstests can help overlayfs, that means it can help to build other fs (e.g. nfs, cifs,
> > >    ceph, etc) from an underlying fs in one day.
>
> Actually I asked for this ^^ mainly.
>

Ahhh I completely misunderstood what you meant.
It's interesting. I also wanted to improve test coverage of fuse by running
fuse passthrough with xfstests.


> > >
> > > So how about bring in a parameter, maybe USE_UNDERLYING_FS=yes/no(default), or use "BASE_FSTYP"
> > > directly, e.g.
> > > export USE_UNDERLYING_FS=yes
> > > export FSTYP=tmpfs
> >
> > This already exists:
> >
> > export OVERLAY=true
> > export FSTYP=tmpfs
>
> Yes, it's same with ./check -overlay, so how about
>
> # need override
> if [ "$OVERLAY" = "true" -a "$FSTYP" != "overlay" ];then
> ...

That could make sense.
TBH, I never test overlay without ./check -overlay.
I only tried to avoid breaking this config in case people are still
using it. If someone is interested in making changes here they
need to test those non-standard configurations and make sure
they are not broken by these changes.

>
> >
> > means exactly that, but is usually set internally by ./check -overlay
> >
> > I think what you mean is that this should be a helper:
> >
> > _overlay_is_valid_upper_fs()
> > {
> >         local basedev=$1
> >
> >         case $FSTYP in
> >         tmpfs)
> >                 return 0
> >                 ;;
> >         *)
> >                 [ -b "$basedev" ] || [ -c "$basedev" ]
> >                 return $?
> >                 ;;
> >         esac
> > }
>
> Sure, if we don't leave this job to tester (tester makes sure he provide proper TEST_DEV
> and SCRATCH_DEV), we help to judge that :)
>
> ......
>
> Now uplying fs testing in xfstests supports two ways:

I am not a native English speaker myself, but I don't think this term
fits so well to describe what you mean.
Maybe "overlayed" fs sounds too overlayfs oriended, but it could describe
other fs.

> 1) Let testers prepare uplying fs TEST_DEV and SCRATCH_DEV, then set FSTYP=$upfs
> 2) The testers prepare underlying fs TEST_DEV and SCRATCH_DEV, then set FSTYP=$underfs, and
>    run ./check -$upfs ...
>
> Until now, only overlayfs supports both 2 ways (if I don't remember wrong), others (likes
> nfs, cifs, glusterfs, ceph etc) are only support the 1st way.
>
> So I'm thinking if other fs would like to be supported as overlay, we might can help to
> provide:
> 1) A parameter UPLYING_FS to record if we're testing a fs can be uplying fs, e.g:
>         -nfs)           FSTYP=nfs; UPLYING_FS=nfs ;;
>         -glusterfs)     FSTYP=glusterfs; UPLYING_FS=glusterfs ;;
>         -cifs)          FSTYP=cifs; export UPLYING_FS=cifs ;;
>         -overlay)       FSTYP=overlay; export UPLYING_FS=overly ;;
>
> 2) A common _config_override() function, and different _${UPLYING_FS}_config_override()
>    functions.
> 3) After source local.config, check if [ "$UPLYING_FS" != "$FSTYP" ]. If they're equal,
>    then return, else we need underlying things, then run _${UPLYING_FS}_is_valid() to check
>    the TEST_DEV and SCRATCH_DEV are good for ${UPLYING_FS}.
> 4) Do real override.
>
> As overlayfs is the only one supports the 2nd way, so maybe we can let overlay testing
> to be a demonstration. Does that make sense?
>

I think it does make sense, but the complications are in the details,
so I'll need
to look closer at some examples and mainly need some developers or testers
of nfs/cifs/glusterfs to care about this.

I may get around to look at fuse passthrough as the first target and see
what benefits this could bring on top of standard fuse support [1]

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20210812045950.3190-1-bhumit.attarde01@gmail.com/
