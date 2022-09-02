Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03828C6FA82
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Sep 2022 01:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiIBBfW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 21:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiIBBfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 21:35:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A74F5B06F
        for <linux-xfs@vger.kernel.org>; Thu,  1 Sep 2022 18:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662082518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wu4GjUvBuNt5SvrsxfoZUzAyvaavMQCfJeiWkq7Jd7A=;
        b=itB0ZEKlRhr4cEiuz0P4mxXbHwRXmvFtNnmsXk+Ja7v2Fa+zjYgddiJBeUMLJhX5OJK0HG
        4q3PmdTRHgjeMfrdWb0HpwACFpD1wc2bv83sdOzw8vqHqtoIUTpLPEb7sT//+HlV86w75u
        4EYB1GZDqhG9egYK+lQnW51M4KO9Px4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-421-anc17B_cOxyMejpywtjp4g-1; Thu, 01 Sep 2022 21:35:16 -0400
X-MC-Unique: anc17B_cOxyMejpywtjp4g-1
Received: by mail-qt1-f200.google.com with SMTP id o21-20020ac87c55000000b00344646ea2ccso506987qtv.11
        for <linux-xfs@vger.kernel.org>; Thu, 01 Sep 2022 18:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wu4GjUvBuNt5SvrsxfoZUzAyvaavMQCfJeiWkq7Jd7A=;
        b=q0TcTt9QLUbLjd3sdtw6kU0lCEI4UGUkHPSOp7NCAFaA8WydxyWpnZ9vlI1z2pMQuj
         4YI/5qdCwSr4COuULIPFJlYPG69sh9CWdsGimYhNlJNueMnrFN/GDb29IyMl2okiwVfS
         rGVz6VA9U9uOvH7qchEe1T3fdhHStKP/aZD8KGVoEPA2d9sbdOH90VReOuxiJyZNjcVw
         G81SuSRP7zGMPBO8OHZyEqhBkoZKiut6YL5BW8w31nJqAob1ZY5LEf5Ad7kor00ZY62V
         WItIORziLlTPM7Tya7RpCn7DPML7MdD36dwuiMirxE+6JqWWJuBrm/eCDb27b1AVxI1x
         DFig==
X-Gm-Message-State: ACgBeo1jCkVR2cCWLH/ZtTtycacHcuRst9M7LpBQejzRmYJZdaOeDGjJ
        3wIkarXx14yu4xWt0kYFySx8b792tGIqhlrGe0HU3WfptYGjp3ihcPebOkl+td0HGfj6tZI3LdE
        2IilDrRzT6VhCEqKO0Gvx
X-Received: by 2002:a05:6214:2685:b0:477:1d22:f017 with SMTP id gm5-20020a056214268500b004771d22f017mr28133032qvb.96.1662082515832;
        Thu, 01 Sep 2022 18:35:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7+fU9oFjdiLPYHBFuQoLj08wbc1B+h7cyXKB88jJwDbh8PpvXRPGp/W8pFk7ledfgxxphBCQ==
X-Received: by 2002:a05:6214:2685:b0:477:1d22:f017 with SMTP id gm5-20020a056214268500b004771d22f017mr28133018qvb.96.1662082515485;
        Thu, 01 Sep 2022 18:35:15 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bj8-20020a05620a190800b006af10bd3635sm459805qkb.57.2022.09.01.18.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 18:35:15 -0700 (PDT)
Date:   Fri, 2 Sep 2022 09:35:09 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     Zorro Lang <zlang@kernel.org>, fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3] generic: new test to verify selinux label of whiteout
 inode
Message-ID: <20220902013509.cbrzq5ukclpcfor4@zlang-mailbox>
References: <20220901143459.3883118-1-zlang@kernel.org>
 <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADJHv_vX+7tONjguTw8ZgyV9uE=OW=RtZQ_FdF2-ViGaxQbzYw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 02, 2022 at 08:44:21AM +0800, Murphy Zhou wrote:
> On Thu, Sep 1, 2022 at 10:47 PM Zorro Lang <zlang@kernel.org> wrote:
> >
> > A but on XFS cause renameat2() with flags=RENAME_WHITEOUT doesn't
>        ^ bug

Sure, will fix

> > apply an selinux label. That's quite different with other fs (e.g.
> > ext4, tmpfs).
> >
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> >
> > V1 -> V2:
> > 1) Add "whiteout" group
> > 2) Add commit ID which fix that bug
> > 3) Rebase to latest fstests for-next branch
> >
> > V2 -> V3:
> > Rebase to latest fstests for-next branch again
> >
> > Thanks,
> > Zorro
> >
> >  tests/generic/695     | 64 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/695.out |  2 ++
> >  2 files changed, 66 insertions(+)
> >  create mode 100755 tests/generic/695
> >  create mode 100644 tests/generic/695.out
> >
> > diff --git a/tests/generic/695 b/tests/generic/695
> > new file mode 100755
> > index 00000000..f04d4b3d
> > --- /dev/null
> > +++ b/tests/generic/695
> > @@ -0,0 +1,64 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat, Copyright.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 695
> > +#
> > +# Verify selinux label can be kept after RENAME_WHITEOUT. This is
> > +# a regression test for:
> > +#   70b589a37e1a ("xfs: add selinux labels to whiteout inodes")
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rename attr whiteout
> > +
> > +# Import common functions.
> > +. ./common/attr
> > +. ./common/renameat2
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_scratch
> > +_require_attrs
> > +_require_renameat2 whiteout
> > +
> > +_fixed_by_kernel_commit 70b589a37e1a \
> > +       xfs: add selinux labels to whiteout inodes
> > +
> > +get_selinux_label()
> > +{
> > +       local label
> > +
> > +       label=`_getfattr --absolute-names -n security.selinux $@ | sed -n 's/security.selinux=\"\(.*\)\"/\1/p'`
> 
> Just curious, why `` instead of $() ? I see the latter is preferred in
> many articles.

Haha, nothing special reason, just get used to it, without too much thinking.
I'll replace  `` to $() in this case.

Thanks,
Zorro

> 
> Regards~
> 
> > +       if [ ${PIPESTATUS[0]} -ne 0 -o -z "$label" ];then
> > +               _fail "Fail to get selinux label: $label"
> > +       fi
> > +       echo $label
> > +}
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +# SELINUX_MOUNT_OPTIONS will be set in common/config if selinux is enabled
> > +if [ -z "$SELINUX_MOUNT_OPTIONS" ]; then
> > +       _notrun "Require selinux to be enabled"
> > +fi
> > +# This test need to verify selinux labels in objects, so unset this selinux
> > +# mount option
> > +export SELINUX_MOUNT_OPTIONS=""
> > +_scratch_mount
> > +
> > +touch $SCRATCH_MNT/f1
> > +echo "Before RENAME_WHITEOUT" >> $seqres.full
> > +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> > +# Expect f1 and f2 have same label after RENAME_WHITEOUT
> > +$here/src/renameat2 -w $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
> > +echo "After RENAME_WHITEOUT" >> $seqres.full
> > +ls -lZ $SCRATCH_MNT >> $seqres.full 2>&1
> > +label1=`get_selinux_label $SCRATCH_MNT/f1`
> > +label2=`get_selinux_label $SCRATCH_MNT/f2`
> > +if [ "$label1" != "$label2" ];then
> > +       echo "$label1 != $label2"
> > +fi
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/695.out b/tests/generic/695.out
> > new file mode 100644
> > index 00000000..1332ff16
> > --- /dev/null
> > +++ b/tests/generic/695.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 695
> > +Silence is golden
> > --
> > 2.31.1
> >
> 

