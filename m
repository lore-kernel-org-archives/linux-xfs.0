Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB30DC433F4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 07:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80B3D61A17
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 07:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhCYHwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 03:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhCYHw1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 03:52:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB45C06174A;
        Thu, 25 Mar 2021 00:52:26 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id l3so1182728pfc.7;
        Thu, 25 Mar 2021 00:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PmBrnGvNVKb1iMKacdjK2J1f9SVMaxTNeUy4/kDoe/0=;
        b=R9l11jMyOyKa7x4jekI+9vkqo5UVQLKlKSC/iOyvVwvAck77IhOckikepPg3pWVuAG
         KRJA5nptfpjQSHzZi4nuFJ4RV0UMBxnzdySMKlauzRaaNHkN5vAeTtADOS7fY4f//vS+
         XxejQhqmd7l8g87i2QaTJAzUuDeO//pbCUOziPgu81WWgiytOmfU0w8zg/sWdgrEWiJB
         UeunGprgFvMpS3DNiszcCOFJbh84F01KlUYojxJzuAHQcyhqXZAvDG5b3CSyJyAoiNfi
         vz8k4pj1z6/ixcQ48TilIm2bXqYEy9f42gBIrCY9yUjLuYQdDNK6rqq8oFBk4TxP+7HW
         PGuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PmBrnGvNVKb1iMKacdjK2J1f9SVMaxTNeUy4/kDoe/0=;
        b=sqr2D+kapO0iUTYe1OgQ9ykCEL10V9v0Urhsc2upKwYLVaVhjNoaAccxCd7LLRY8Kn
         937XOtPqxU+qeV2Y73gTXGnI/+R9SQ+Jt+gCk5mQys8NMvH3xhiz64heb+jo6y6YLOl1
         sgQLFVouOzGjuHPR/dX6Pp3hXLKPIUkGz8ThUwiLdFiAouvoe67XS5P0Kjwmc2dL/n0H
         OoQ18Yt9hWwqv2zx/xV/IuXZI4O+RuPUXCT5/1Sajyufg4fajyP9k9zm1D8vlJlK5W/C
         lzJVVmMAkTgUUhTZhdU5+GbbSEoUgytTbGq9VaNfUlrLiHM9fMqc4WHQzWrcsdc3k2+s
         g+4Q==
X-Gm-Message-State: AOAM530Ve1Q/cE4+cOzq4De5bfOQ63DVk3Ip5FUe4gJ5eM1atX2YqwjZ
        lLh/XZfsRxsntsbl9O2tYt4=
X-Google-Smtp-Source: ABdhPJzJMYPtbK5jOS7+chq/WARS/PcLBm8HRZVmNVXdLOOMvK6E12+KtbayLy6GMWzSyKfKXLInng==
X-Received: by 2002:a17:902:b68b:b029:e6:cda9:39d with SMTP id c11-20020a170902b68bb02900e6cda9039dmr8250006pls.63.1616658746088;
        Thu, 25 Mar 2021 00:52:26 -0700 (PDT)
Received: from garuda ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id u7sm4668138pfh.150.2021.03.25.00.52.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 00:52:25 -0700 (PDT)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526482015.1214319.6227125326960502859.stgit@magnolia> <87mtvaceaf.fsf@garuda> <20210323041532.GI1670408@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 03/10] xfs: test rtalloc alignment and math errors
In-reply-to: <20210323041532.GI1670408@magnolia>
Date:   Thu, 25 Mar 2021 13:22:22 +0530
Message-ID: <87pmznoekp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Mar 2021 at 09:45, Darrick J. Wong wrote:
> On Thu, Mar 11, 2021 at 01:28:32PM +0530, Chandan Babu R wrote:
>> On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
>> > From: Darrick J. Wong <djwong@kernel.org>
>> >
>> > Add a couple of regression tests for "xfs: make sure the rt allocator
>> > doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
>> > finsert operations are aligned to rt extent size".
>> >
>> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> > ---
>> >  tests/xfs/759     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  tests/xfs/759.out |    2 +
>> >  tests/xfs/760     |   68 ++++++++++++++++++++++++++++++++++++
>> >  tests/xfs/760.out |    9 +++++
>> >  tests/xfs/group   |    2 +
>> >  5 files changed, 181 insertions(+)
>> >  create mode 100755 tests/xfs/759
>> >  create mode 100644 tests/xfs/759.out
>> >  create mode 100755 tests/xfs/760
>> >  create mode 100644 tests/xfs/760.out
>> >
>> >
>> > diff --git a/tests/xfs/759 b/tests/xfs/759
>> > new file mode 100755
>> > index 00000000..8558fe30
>> > --- /dev/null
>> > +++ b/tests/xfs/759
>> > @@ -0,0 +1,100 @@
>> > +#! /bin/bash
>> > +# SPDX-License-Identifier: GPL-2.0-or-later
>> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
>> > +#
>> > +# FS QA Test No. 759
>> > +#
>> > +# This is a regression test for commit 2a6ca4baed62 ("xfs: make sure the rt
>> > +# allocator doesn't run off the end") which fixes an overflow error in the
>> > +# _near realtime allocator.  If the rt bitmap ends exactly at the end of a
>> > +# block and the number of rt extents is large enough to allow an allocation
>> > +# request larger than the maximum extent size, it's possible that during a
>> > +# large allocation request, the allocator will fail to constrain maxlen on the
>> > +# second run through the loop, and the rt bitmap range check will run right off
>> > +# the end of the rtbitmap file.  When this happens, xfs triggers a verifier
>> > +# error and returns EFSCORRUPTED.
>> > +
>> > +seq=`basename $0`
>> > +seqres=$RESULT_DIR/$seq
>> > +echo "QA output created by $seq"
>> > +
>> > +here=`pwd`
>> > +tmp=/tmp/$$
>> > +status=1    # failure is the default!
>> > +trap "_cleanup; exit \$status" 0 1 2 3 15
>> > +
>> > +_cleanup()
>> > +{
>> > +	cd /
>> > +	rm -f $tmp.*
>> > +}
>> > +
>> > +# get standard environment, filters and checks
>> > +. ./common/rc
>> > +. ./common/filter
>> > +
>> > +# real QA test starts here
>> > +_supported_fs xfs
>> > +_require_scratch
>> > +_require_realtime
>> > +_require_test_program "punch-alternating"
>> > +
>> > +rm -f $seqres.full
>> > +
>> > +# Format filesystem to get the block size
>> > +_scratch_mkfs > $seqres.full
>> > +_scratch_mount >> $seqres.full
>> > +
>> > +blksz=$(_get_block_size $SCRATCH_MNT)
>> > +rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
>> > +rextblks=$((rextsize / blksz))
>> > +
>> > +echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
>> > +
>> > +_scratch_unmount
>> > +
>> > +# Format filesystem with a realtime volume whose size fits the following:
>> > +# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes.
>> 
>> Shouldn't the multiplier be RT extent size rather than FS block size?
>
> No, because reproducing the bug requires a large enough allocation
> request that we can't fit it all in a single data fork extent mapping
> and have to call back into the allocator to get more space.  bmbt
> mappings are always in units of fsblocks, not rt extents.
>

Ah, I had not realized that.

The changes look good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
