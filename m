Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D882C433F5
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 18:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiDXSof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 14:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiDXSoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 14:44:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BB0E6F9D3
        for <linux-xfs@vger.kernel.org>; Sun, 24 Apr 2022 11:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650825692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uw4YXEZv26PmHvXTnBt/w0NJ77ODvW8rCOy7kuR4Xrc=;
        b=QPpSa3MZOSp0p/7rjpqxeDKwa0nDpyS2FSMs8vtdX81pdbk0VgrePDy+zFK5h7AzxF5rkQ
        7IpUtO2zov1iWQyvi05OTXh+nCVWQM0VqaMvXlJf2BriutilPGOU+r9t8BQp8LjHwu+1p8
        zH+BLsFS965URDjilZwXq745Xg+E4tc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-nY75NPAYMiiw-aMpWrqCSQ-1; Sun, 24 Apr 2022 14:41:28 -0400
X-MC-Unique: nY75NPAYMiiw-aMpWrqCSQ-1
Received: by mail-qt1-f198.google.com with SMTP id o19-20020a05622a009300b002f24529993cso6966053qtw.0
        for <linux-xfs@vger.kernel.org>; Sun, 24 Apr 2022 11:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Uw4YXEZv26PmHvXTnBt/w0NJ77ODvW8rCOy7kuR4Xrc=;
        b=mf+WTERQ2d2rq/+uZuHeAho7F9o9jmQNaYYZNbCxTpoDYnfoWAqD3HaEzFRNYs0BXV
         pFCgRghoidJdctXkOlM/e4eUIQ9936rsQE7Ti7P8+FcMtrJr9Y27ZRYafAKs4XTmczff
         iZkHVjKGKdcxVAJSEi26SkBjMa93GpPsI8TwEFH5Joa4sbzSRyf3U4jNVzrSMV5324uI
         y2Fum6yI8LcGGHrtVe4Ur2gL4lA0Fu6yjxCnw5VDJIdRBh3RlrTHcDTShOQKH/ZVGYva
         GXBAGRAi4cRGtAbcl52Wjx+Vb3LUimeGhBK6o9+Y6B+6zaGFlsdIXTdRmcf1gQV6YKvc
         lc+g==
X-Gm-Message-State: AOAM532+zaVOaHSS8ITiYBc+vYcU196K6gh1W2/6CLYAUl7qrPxfoXjd
        shDJmmrzwmWVAE13YlImC7/TuKiczlsMTC2pyE3Ce0bmkr2Egoov1Am4dYc1fDG3MMyTTrUFSHs
        WMfy9cAmDtVSN11E9SOTo
X-Received: by 2002:ad4:5aac:0:b0:446:5ce1:10a8 with SMTP id u12-20020ad45aac000000b004465ce110a8mr10606634qvg.72.1650825687712;
        Sun, 24 Apr 2022 11:41:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBXm2ga26IPUefrGSD2nzRNxp/qzWZcWjIrO3LKUfs//AlzXYYKG2X9ipuDHxnI5Fm0aXfWw==
X-Received: by 2002:ad4:5aac:0:b0:446:5ce1:10a8 with SMTP id u12-20020ad45aac000000b004465ce110a8mr10606630qvg.72.1650825687390;
        Sun, 24 Apr 2022 11:41:27 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j12-20020a05622a038c00b002f340aeffb3sm5005465qtx.85.2022.04.24.11.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 11:41:26 -0700 (PDT)
Date:   Mon, 25 Apr 2022 02:41:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC] common: overlay support tmpfs
Message-ID: <20220424184120.w7byatovi7plihkw@zlang-mailbox>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <20220424063751.1067376-1-libaokun1@huawei.com>
 <CAOQ4uxgEXEgZ-uAYgiJi1sxX9Zzmg25NewBRiRQR6D8z+qOXHA@mail.gmail.com>
 <20220424132357.m4nxrmbgu2r6ljo4@zlang-mailbox>
 <CAOQ4uxiQ-aM4TJmU3QYhGsVzaPKphMg06k6gjAe8By5ZZ8DZgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiQ-aM4TJmU3QYhGsVzaPKphMg06k6gjAe8By5ZZ8DZgw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 24, 2022 at 05:34:44PM +0300, Amir Goldstein wrote:
> On Sun, Apr 24, 2022 at 4:24 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > On Sun, Apr 24, 2022 at 03:02:03PM +0300, Amir Goldstein wrote:
> > > On Sun, Apr 24, 2022 at 2:21 PM Baokun Li <libaokun1@huawei.com> wrote:
> > > >
> > > > xfstests support overlay+tmpfs
> > >
> > > Thanks for this improvement.
> > > Can you please share the results of ./check -overlay -g auto ?
> > >
> > > How many tests ran? notran? failed?
> > >
> > > Best if you have those numbers compared to
> > > overlay+(already supported base fs)
> > >
> > >
> > > >
> > > > ```local.config.example
> > > > export FSTYP=tmpfs
> > > > export TEST_DEV=tmpfs_test
> > > > export TEST_DIR=/tmp/test
> > > > export TEST_FS_MOUNT_OPTS="-t tmpfs"
> > > > export SCRATCH_DEV=tmpfs_scratch
> > > > export SCRATCH_MNT=/tmp/scratch
> > > > export MOUNT_OPTIONS="-t tmpfs"
> > >
> > > These mount options for tmpfs are very awkward.
> > > Please fix _overlay_base_mount to use -t $OVL_BASE_FSTYP
> > > like _test_mount() and _try_scratch_mount() do
> > >
> > >
> > > > ```
> > > > Run `./check -overlay tests` to execute test case on overlay+tmpfs.
> > > >
> > > > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > > > ---
> > > >  common/config | 4 ++--
> > > >  common/rc     | 7 ++++++-
> > > >  2 files changed, 8 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/common/config b/common/config
> > > > index 1033b890..3dc047e8 100644
> > > > --- a/common/config
> > > > +++ b/common/config
> > > > @@ -614,7 +614,7 @@ _overlay_config_override()
> > > >         #    the new OVL_BASE_SCRATCH/TEST_DEV/MNT vars are set to the values
> > > >         #    of the configured base fs and SCRATCH/TEST_DEV vars are set to the
> > > >         #    overlayfs base and mount dirs inside base fs mount.
> > > > -       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || return 0
> > > > +       [ -b "$TEST_DEV" ] || [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ] || return 0
> > > >
> > > >         # Config file may specify base fs type, but we obay -overlay flag
> > > >         [ "$FSTYP" == overlay ] || export OVL_BASE_FSTYP="$FSTYP"
> > >
> > > Please move the setting of OVL_BASE_FSTYP to the top of the function and use
> > > [ "$OVL_BASE_FSTYP" == tmpfs ] consistently.
> >
> > Actually I'm wondering if we can bring in a parameter to clarify that xfstests need to
> > build uplying fs base on a underlying fs, don't depend on the "[ -b "$TEST_DEV" ] ||
> > [ -c "$TEST_DEV" ] || [ "$FSTYP" == tmpfs ]" things. Due to:
> > 1) overlayfs might not only base on localfs, it can over NFS or something likes it. (right?)
> 
> No it cannot.
> The way that xfstests -overlay work is that both upper and lower layers
> are created on the base fs, therefore only fs supported as upper fs
> can be tested with -overlay.
> None of the network fs qualify as valid overlay upper fs.
> The only other non-blockdev fs besides tmpfs that could be tested
> with -overlay is virtiofs.

Oh, looks like my memory is a little jumbled, maybe overlayfs can be exported to NFS :)

> 
> >    If so, how many judgements we need to add at here?
> > 2) If xfstests can help overlayfs, that means it can help to build other fs (e.g. nfs, cifs,
> >    ceph, etc) from an underlying fs in one day.

Actually I asked for this ^^ mainly.

> >
> > So how about bring in a parameter, maybe USE_UNDERLYING_FS=yes/no(default), or use "BASE_FSTYP"
> > directly, e.g.
> > export USE_UNDERLYING_FS=yes
> > export FSTYP=tmpfs
> 
> This already exists:
> 
> export OVERLAY=true
> export FSTYP=tmpfs

Yes, it's same with ./check -overlay, so how about

# need override
if [ "$OVERLAY" = "true" -a "$FSTYP" != "overlay" ];then
...

> 
> means exactly that, but is usually set internally by ./check -overlay
> 
> I think what you mean is that this should be a helper:
> 
> _overlay_is_valid_upper_fs()
> {
>         local basedev=$1
> 
>         case $FSTYP in
>         tmpfs)
>                 return 0
>                 ;;
>         *)
>                 [ -b "$basedev" ] || [ -c "$basedev" ]
>                 return $?
>                 ;;
>         esac
> }

Sure, if we don't leave this job to tester (tester makes sure he provide proper TEST_DEV
and SCRATCH_DEV), we help to judge that :)

......

Now uplying fs testing in xfstests supports two ways:
1) Let testers prepare uplying fs TEST_DEV and SCRATCH_DEV, then set FSTYP=$upfs
2) The testers prepare underlying fs TEST_DEV and SCRATCH_DEV, then set FSTYP=$underfs, and
   run ./check -$upfs ...

Until now, only overlayfs supports both 2 ways (if I don't remember wrong), others (likes
nfs, cifs, glusterfs, ceph etc) are only support the 1st way.

So I'm thinking if other fs would like to be supported as overlay, we might can help to
provide:
1) A parameter UPLYING_FS to record if we're testing a fs can be uplying fs, e.g:
        -nfs)           FSTYP=nfs; UPLYING_FS=nfs ;;
        -glusterfs)     FSTYP=glusterfs; UPLYING_FS=glusterfs ;;
        -cifs)          FSTYP=cifs; export UPLYING_FS=cifs ;;
        -overlay)       FSTYP=overlay; export UPLYING_FS=overly ;;

2) A common _config_override() function, and different _${UPLYING_FS}_config_override()
   functions.
3) After source local.config, check if [ "$UPLYING_FS" != "$FSTYP" ]. If they're equal,
   then return, else we need underlying things, then run _${UPLYING_FS}_is_valid() to check
   the TEST_DEV and SCRATCH_DEV are good for ${UPLYING_FS}.
4) Do real override.

As overlayfs is the only one supports the 2nd way, so maybe we can let overlay testing
to be a demonstration. Does that make sense?

Thanks,
Zorro

> 
> Then we could whitelist other fs after tmpfs
> and also blacklist other fs even if they are blockdev fs.
> 
> Thanks,
> Amir.
> 

