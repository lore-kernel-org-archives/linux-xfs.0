Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C63FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 14:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiDXOiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 10:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239390AbiDXOiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 10:38:00 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D069233A3A;
        Sun, 24 Apr 2022 07:34:56 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id kc12so4786896qvb.0;
        Sun, 24 Apr 2022 07:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=vKvBoC6fQdRvnrnGUjqDDCsE7Pd4Q3k3zAADj/LXHxE=;
        b=I7KnuENU9fgZVT+KK2WcsydRMZBhm4kpJzl3pElPg8fWW3EOwA5aY46FtKdowlskg8
         3jOMQtmzm1naa9AHtOwmmYiQzN0jyj7UBZO5t0mFiFhn6StR5NiPPMp3qnKJZs5dkKkv
         il4wNRYhYkfUXrFoZw5sstAl7FYl2EuNV+ds4IP5/Tq9Q+A2xlGVVhIgyMhQhxISinKD
         A5lGu3h1s3MOZF97lX+bqpXlbztu7GXG06cF7VkCz9TnKXx2czGDus6RCrPoq35ikYtp
         AFJdIw5o8optLZnQkOgKlJ8kB4KB48npt5cR7kyqSgeu3v6MBOJpsUfRgaxvIkKvuIMc
         P0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=vKvBoC6fQdRvnrnGUjqDDCsE7Pd4Q3k3zAADj/LXHxE=;
        b=MkP3LAO0KLQPqg/0/rElEByEtXLXaTdrG2dzvd1Nbn4bPFGm7JCZYhwdzqieCw5+nJ
         YmEGFlKNjde0fofYNaNDAI3cNW7fyqE0d7iPMV9gqhfaMYbvKP/3toyOW2QtO+I09188
         qfbXHWdNleZPN7FjqhzLAu6N9mUJzITlbHq58FEJRW5dW8pMUC3zSOrlX9SnvS5rkzuC
         Q/2fBNcSIXcKlBfMqlRiLhVXWd7uRQ73nqNufKfdddwOY01tE3IAXk/Oa/gF/MJ4zhvQ
         uIXiE7c2t9Km7/Irnhd5opilENAqd5wR7RUrAMaR+6nS6ihlbNB2yftJBgQO5W9oBb/S
         goJg==
X-Gm-Message-State: AOAM531FFJ0PigHJp7/D9ZWUzlOoyXdd86eZsQgVvNpFCVXpuPo7yZbA
        aoV0OkUNhsnctiX/ovkUiiHWWIQzOJxuqZZ9pC3M9K6KXDQ=
X-Google-Smtp-Source: ABdhPJyy/5ZqE3y+mIc9+A9xL/oCaySEWP4PWi55SB+VePtFLY3uSAjZbOud5kVKU8/5BldTiXtxGLOyP+JpRAUqCBY=
X-Received: by 2002:a05:6214:1c83:b0:443:6749:51f8 with SMTP id
 ib3-20020a0562141c8300b00443674951f8mr9930649qvb.74.1650810895605; Sun, 24
 Apr 2022 07:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220424063751.1067376-1-libaokun1@huawei.com>
 <CAOQ4uxgEXEgZ-uAYgiJi1sxX9Zzmg25NewBRiRQR6D8z+qOXHA@mail.gmail.com> <20220424132357.m4nxrmbgu2r6ljo4@zlang-mailbox>
In-Reply-To: <20220424132357.m4nxrmbgu2r6ljo4@zlang-mailbox>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Apr 2022 17:34:44 +0300
Message-ID: <CAOQ4uxiQ-aM4TJmU3QYhGsVzaPKphMg06k6gjAe8By5ZZ8DZgw@mail.gmail.com>
Subject: Re: [RFC] common: overlay support tmpfs
To:     fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 24, 2022 at 4:24 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Sun, Apr 24, 2022 at 03:02:03PM +0300, Amir Goldstein wrote:
> > On Sun, Apr 24, 2022 at 2:21 PM Baokun Li <libaokun1@huawei.com> wrote:
> > >
> > > xfstests support overlay+tmpfs
> >
> > Thanks for this improvement.
> > Can you please share the results of ./check -overlay -g auto ?
> >
> > How many tests ran? notran? failed?
> >
> > Best if you have those numbers compared to
> > overlay+(already supported base fs)
> >
> >
> > >
> > > ```local.config.example
> > > export FSTYP=tmpfs
> > > export TEST_DEV=tmpfs_test
> > > export TEST_DIR=/tmp/test
> > > export TEST_FS_MOUNT_OPTS="-t tmpfs"
> > > export SCRATCH_DEV=tmpfs_scratch
> > > export SCRATCH_MNT=/tmp/scratch
> > > export MOUNT_OPTIONS="-t tmpfs"
> >
> > These mount options for tmpfs are very awkward.
> > Please fix _overlay_base_mount to use -t $OVL_BASE_FSTYP
> > like _test_mount() and _try_scratch_mount() do
> >
> >
> > > ```
> > > Run `./check -overlay tests` to execute test case on overlay+tmpfs.
> > >
> > > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > > ---
> > >  common/config | 4 ++--
> > >  common/rc     | 7 ++++++-
> > >  2 files changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/common/config b/common/config
> > > index 1033b890..3dc047e8 100644
> > > --- a/common/config
> > > +++ b/common/config
> > > @@ -614,7 +614,7 @@ _overlay_config_override()
> > >         #    the new OVL_BASE_SCRATCH/TEST_DEV/MNT vars are set to the values
> > >         #    of the configured base fs and SCRATCH/TEST_DEV vars are set to the
> > >         #    overlayfs base and mount dirs inside base fs mount.
> > > -       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || return 0
> > > +       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ] || return 0
> > >
> > >         # Config file may specify base fs type, but we obay -overlay flag
> > >         [ "$FSTYP" == overlay ] || export OVL_BASE_FSTYP="$FSTYP"
> >
> > Please move the setting of OVL_BASE_FSTYP to the top of the function and use
> > [ "$OVL_BASE_FSTYP" == tmpfs ] consistently.
>
> Actually I'm wondering if we can bring in a parameter to clarify that xfstests need to
> build uplying fs base on a underlying fs, don't depend on the "[ -b "$TEST_DEV" ] ||
> [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ]" things. Due to:
> 1) overlayfs might not only base on localfs, it can over NFS or something likes it. (right?)

No it cannot.
The way that xfstests -overlay work is that both upper and lower layers
are created on the base fs, therefore only fs supported as upper fs
can be tested with -overlay.
None of the network fs qualify as valid overlay upper fs.
The only other non-blockdev fs besides tmpfs that could be tested
with -overlay is virtiofs.

>    If so, how many judgements we need to add at here?
> 2) If xfstests can help overlayfs, that means it can help to build other fs (e.g. nfs, cifs,
>    ceph, etc) from an underlying fs in one day.
>
> So how about bring in a parameter, maybe USE_UNDERLYING_FS=yes/no(default), or use "BASE_FSTYP"
> directly, e.g.
> export USE_UNDERLYING_FS=yes
> export FSTYP=tmpfs

This already exists:

export OVERLAY=true
export FSTYP=tmpfs

means exactly that, but is usually set internally by ./check -overlay

I think what you mean is that this should be a helper:

_overlay_is_valid_upper_fs()
{
        local basedev=$1

        case $FSTYP in
        tmpfs)
                return 0
                ;;
        *)
                [ -b "$basedev" ] || [ -c "$basedev" ]
                return $?
                ;;
        esac
}

Then we could whitelist other fs after tmpfs
and also blacklist other fs even if they are blockdev fs.

Thanks,
Amir.
