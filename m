Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A79ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 23:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiH3XqL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 19:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH3XqJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 19:46:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CCB5A3D1;
        Tue, 30 Aug 2022 16:46:08 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso19475104pjh.5;
        Tue, 30 Aug 2022 16:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=KM7MQcdI/uBXf1bHHOdp8B5jnkXYtieavtHsCCtpcu8=;
        b=GIgp9LgNR/GmMqZfNuuqWTDa7dYdRqkbcNDUnoXt/PY1CKVVhpomkfMWTMqejJH1qZ
         In+NyfMS28R0CEI3Fimhy2GVj65jx01tayoBZIiiJC1UYaOmX/FNSARumAGKh7ojU8+v
         63Rkcf9LJTsRSGxHSKeu7A7hkRFATtM3njvewy5AT803uGXCVxHl15askvpwBHAYltIj
         uPn4ie2KOjKqQXO1Uv2rXk20PcckjPmeUUMHMqRkXv1U01h85bCb+N+8O3f6eJ8SQtHo
         VFFn/HbsoYLt8mriGFdiklRwYEFS+pIy9HdpnYLf/+ikJBoqEiAO3LLK74mlPFfA4r35
         I8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=KM7MQcdI/uBXf1bHHOdp8B5jnkXYtieavtHsCCtpcu8=;
        b=sZZBRUAvqU89HB1Uwt83rLx0jJH1DBzxhK3Mg8+u8joCs39RDIdxSifTCO2ZUjKQhM
         NLiqR6iM2hE2WsJjyCYBoPydRwOwcorWfH0ZXQbfDT25Zb61elip5bFe3U5bEhs34IIL
         uH2WXZ+h8ZUMG+lTxxxBgptdT47AJ2YowSd0+tgSPWFQgJDn4wrixyE4uMa0O58W6Gyp
         Rapr4YQ5hKkhLXe+tr7syP7t80LJRN782zoCwFZvlDH6+Q/iZmfRF02glAsQGZsAzelV
         FOqAWMZBnNhrODw+a+hprPp0XLK5ZRyfciHY/YmBPOHauaBLMufRUVNQbuqa0vaOUzeN
         2bmw==
X-Gm-Message-State: ACgBeo1hXcRJCxola6TJhZZqUsigw2Q/f8rXEDrW1OcfVlnd3hZ4vs9u
        pcaA/dNzpZe07Se1bYPJGGjC8oOX+dHitNW3avw=
X-Google-Smtp-Source: AA6agR6451jFC7j1AAzffR7F9NWG3Q98cW5F+aPO5e+Xbt7ubhQh+0mhvh+HVo0uhbkqUn9iiNLIL1KCNzrGkjQTeus=
X-Received: by 2002:a17:90a:fae:b0:1fd:a1bc:ff65 with SMTP id
 43-20020a17090a0fae00b001fda1bcff65mr444264pjz.73.1661903168384; Tue, 30 Aug
 2022 16:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-5-jencce.kernel@gmail.com> <20220830074936.eprwzg4auxtlhsom@zlang-mailbox>
 <Yw4l44ySWqhCe7dB@magnolia>
In-Reply-To: <Yw4l44ySWqhCe7dB@magnolia>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 07:45:56 +0800
Message-ID: <CADJHv_vFEO3-hkJWAg38dKGtBJMHykALcGvJqFmR3K03yHAWTw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] xfs/144: remove testing root dir inode in AG 1
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 10:59 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Tue, Aug 30, 2022 at 03:49:36PM +0800, Zorro Lang wrote:
> > On Tue, Aug 30, 2022 at 12:44:33PM +0800, Murphy Zhou wrote:
> > > Since this xfsprogs commit
> > >   1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
> > > this operation is not allowed.
> > >
> > > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > > ---
> > >  tests/xfs/144 | 10 +---------
> > >  1 file changed, 1 insertion(+), 9 deletions(-)
> > >
> > > diff --git a/tests/xfs/144 b/tests/xfs/144
> > > index 706aff61..3f80d0ee 100755
> > > --- a/tests/xfs/144
> > > +++ b/tests/xfs/144
> > > @@ -17,9 +17,6 @@ _begin_fstest auto mkfs
> > >  _supported_fs xfs
> > >  _require_test
> > >
> > > -# The last testcase creates a (sparse) fs image with a 2GB log, so we need
> > > -# 3GB to avoid failing the mkfs due to ENOSPC.
> > > -_require_fs_space $TEST_DIR $((3 * 1048576))
> > >  echo Silence is golden
> > >
> > >  testfile=$TEST_DIR/a
> > > @@ -36,7 +33,7 @@ test_format() {
> > >  }
> > >
> > >  # First we try various small filesystems and stripe sizes.
> > > -for M in `seq 298 302` `seq 490 520`; do
> > > +for M in `seq 1024 1030` ; do
> >
> > Can `seq 1024 1030` replace `seq 298 302` `seq 490 520`? I don't know how
> > Darrick choose these numbers, better to ask the original authoer of this
> > case. Others looks reasonable for me.
>
> Those sequences were a result of Eric prying broken edge-cases out of
> the original patch series, so I wired them up in the test.
>
> > Thanks,
> > Zorro
> >
> > >     for S in `seq 32 4 64`; do
> > >             test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> > >     done
> > > @@ -45,11 +42,6 @@ done
> > >  # log end rounded beyond EOAG due to stripe unit
> > >  test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4 -N
> > >
> > > -# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > > -# because this check only occurs after the root directory has been allocated,
> > > -# which mkfs -N doesn't do.
> > > -test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
>
> Also, why remove this bit?  Surely we ought to keep it just in case
> someone accidentally breaks the mkfs code again?

Because of this:
  1b580a773 mkfs: don't let internal logs bump the root dir inode chunk to AG 1
mkfs will fail here.

How can we achieve that? Add an expected result for _test_format?

THanks,
>
> --D
>
> > >  # success, all done
> > >  status=0
> > >  exit
> > > --
> > > 2.31.1
> > >
> >
