Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7491C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 06:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiF3Gh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 02:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiF3Gh0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 02:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6D882E68C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 23:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656571043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMdraqJ988nUyorA+H9lwzJVixuJXHhhTOJ8MUyHYVI=;
        b=aJoXlH82cKM3TDgFzwSE6CiCGvTM7jPoDfTWImyDYK7uWT8hJOpwtiVKDwoq/yusQ2+4zB
        whemD1qgY5v6N9WJa+oCGKA5x0oTJAZSh8W4Jwx7Mp2DBi0XgGU/epRmb1kwkZlOC2dkOp
        iBSl3WeY1sokSREWnBbma6ZCU4lcVY0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-K3WZl6MXOwi3JU4VYeYrzQ-1; Thu, 30 Jun 2022 02:37:22 -0400
X-MC-Unique: K3WZl6MXOwi3JU4VYeYrzQ-1
Received: by mail-qv1-f69.google.com with SMTP id 10-20020a0562140cca00b004702e8ce21bso17682296qvx.22
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 23:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMdraqJ988nUyorA+H9lwzJVixuJXHhhTOJ8MUyHYVI=;
        b=IFSzEeqOspA3cmOnTxivDUFanUmsBfkt0grmM60tgkuM3YHfHJX7vl+2lR6EWRszAE
         PFPL3DHbo6KKVx8KoFc71iYwDfc12YOlzrfAvEFYYYiBTyQQSI6WmDITv3vyzK4bufyh
         u7ONPKrCYumse9SmfqB35SIZH3mWvA6h/+iAbNshu10Ko5mQkCWn9P77GGR/b9vqQsOK
         601ZF/dftv6CiIHrtVx9uhFXzq1wNSsylkq3i3rsomjNBQyIlbOowMSY0ZCVEzorsHBm
         SkVK55DsvjiSgKbeHDxN61cc4Cku8xRHmY5ReaCh3FsGTV98C+DCKvP2hkV+sFdT0OS4
         h3Yg==
X-Gm-Message-State: AJIora/XUqMAaeh3Jr/IrR9gytx4DwiH6yVNZ9n8WibjFPb0V6Ms8+8m
        xQK/3vgvlkiXQQV71YJh8zotSf4fxD7dqJAZ+9VTpQ6VtobGWU623k9HG0hD2OpmVdQNPvZgBGz
        5CsnjelD6SAdwmCNR1kLR
X-Received: by 2002:a05:622a:19a9:b0:31b:eb4e:5cd with SMTP id u41-20020a05622a19a900b0031beb4e05cdmr6199082qtc.467.1656571041860;
        Wed, 29 Jun 2022 23:37:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkpnMc2dN7rykGGbT3nmvPDBrjDgjKOt17YDWp1kgTJtjvpML6ISHOVbzmT6Vm6KC3Qms03A==
X-Received: by 2002:a05:622a:19a9:b0:31b:eb4e:5cd with SMTP id u41-20020a05622a19a900b0031beb4e05cdmr6199069qtc.467.1656571041568;
        Wed, 29 Jun 2022 23:37:21 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g84-20020a379d57000000b0069c72b41b59sm14665914qke.2.2022.06.29.23.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 23:37:21 -0700 (PDT)
Date:   Thu, 30 Jun 2022 14:37:14 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <20220630063714.vrvyip5b2fari3up@zlang-mailbox>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644769450.1045534.8663346508633304230.stgit@magnolia>
 <20220629041807.GP1098723@dread.disaster.area>
 <YrzVmF1ixmr/3QhY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzVmF1ixmr/3QhY@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 03:43:36PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 29, 2022 at 02:18:07PM +1000, Dave Chinner wrote:
> > On Tue, Jun 28, 2022 at 01:21:34PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This is a regression test that exercises the mkfs.xfs code that creates
> > > log sizes that are very close to the AG size when stripe units are in
> > > play and/or when the log is forced to be in AG 0.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/843     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/843.out |    2 ++
> > >  2 files changed, 53 insertions(+)
> > >  create mode 100755 tests/xfs/843
> > >  create mode 100644 tests/xfs/843.out
> > > 
> > > 
> > > diff --git a/tests/xfs/843 b/tests/xfs/843
> > > new file mode 100755
> > > index 00000000..5bb4bfb4
> > > --- /dev/null
> > > +++ b/tests/xfs/843
> > > @@ -0,0 +1,51 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 843
> > > +#
> > > +# Now that we've increased the default log size calculation, test mkfs with
> > > +# various stripe units and filesystem sizes to see if we can provoke mkfs into
> > > +# breaking.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto mkfs
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs xfs
> > > +_require_test
> > > +echo Silence is golden
> > > +
> > > +testfile=$TEST_DIR/a
> > > +rm -f $testfile
> > > +
> > > +test_format() {
> > > +	local tag="$1"
> > > +	shift
> > > +
> > > +	echo "$tag" >> $seqres.full
> > > +	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
> > > +	local res=$?
> > > +	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
> > > +}
> > > +
> > > +# First we try various small filesystems and stripe sizes.
> > > +for M in `seq 298 302` `seq 490 520`; do
> > > +	for S in `seq 32 4 64`; do
> > > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> > > +	done
> > > +done
> > > +
> > > +# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > > +# because this check only occurs after the root directory has been allocated,
> > > +# which mkfs -N doesn't do.
> > > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
> > 
> > Why are you passing "-N" to the test if it can't be used to test
> > this?
> 
> I guess I went a little overboard after you asked for more -N and less
> test runtime last time.

Is there anything different coverage if mkfs.xfs with or without "-N" (except
really writing on disk) ? If no difference, I'm fine with that, or I think
without "-N" might be good, especially this case only makes fs with small size,
it's fast enough.

Thanks,
Zorro

> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

