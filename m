Return-Path: <SRS0=6Z+e=CI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76982C433E6
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 15:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D0F2071B
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Aug 2020 15:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QebRjcBV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgH3P5c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Aug 2020 11:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgH3P5a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 11:57:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB3AC061573;
        Sun, 30 Aug 2020 08:57:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1880966plr.0;
        Sun, 30 Aug 2020 08:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qzTf400N+G6QyvLZBx+2AISNpc2/be5W2xwEXuZiLPM=;
        b=QebRjcBVBS389/k0xT5UTsDSmr81sQ4lgsXImxjkUrLk+3Y7H6PozOPwdMJNIykCmV
         AnEFjY2/+WFjTNLXjTfOx1maP7UZcfQUIn22wqi6vgyEG8oKGtKD/tTj2XsqKDijPJ9n
         z+SeGVN4ddQqK6NbRFbc6yEdapGhx2/kkwaEC/8tsY2l9eRFRu/p5/UQCVL8a5QB4vdC
         WDxY0Ni0pFS/qTHChpWRs1nGVPkNtY1xnKgefSpAmm6kxq0hUL7Qhnvun6/qXTG7mXVz
         pR792hWTIrD2kd3ozuSFyYzgtMsd4tlzyAFr6mXOgq6xvueHpdRRPZ4RXI+ahDbGfT5/
         OAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzTf400N+G6QyvLZBx+2AISNpc2/be5W2xwEXuZiLPM=;
        b=KIChCbg0h/IFKblAzqFHBcraDrMJWnqrrwbHuoH1KTHsgGIsgm1miFxSI0FhlzizFE
         a7OO+BYkADxGc8saElQRKkkzltiKmDAitIeBZ4VEmmHZgeHJxnqQZjb+nEUfEz4tqDPA
         f/uPGsV+7Vcv/tnoMyvv8JzunFVvcz3nxfdjTvE3HLFfqWaaHLMofFD2B9sRSBWzqw+0
         Ljg/dp9/IWZOChN6rx1lHNjD2PI4mvV2pMVgC20iQ8UgYzZsmNckNAKermqcbbWKQ7hs
         HYOfDFRYkg7r2g5E8aNXcaeM+SKU+0BmcKkqD3O3ILH1Wney5ud9JtxiqqwSb4gMgJo9
         UH7g==
X-Gm-Message-State: AOAM532/ldQv1nzAaTApoDJ3YIh4BX/2b/Z1KaGgkMdmMs17ifN3SBFJ
        faeGgktcazqy0r3tom6Mgmbu+MXItCc=
X-Google-Smtp-Source: ABdhPJzvw9fvUkC9erddY4A5xggCehtNQ4r6hoYsLjZmkxhaN13FvTAn9VrqIh/A47V1Yn9lxfYycw==
X-Received: by 2002:a17:90b:1a89:: with SMTP id ng9mr6981077pjb.202.1598803048701;
        Sun, 30 Aug 2020 08:57:28 -0700 (PDT)
Received: from localhost ([47.89.231.86])
        by smtp.gmail.com with ESMTPSA id q5sm5275436pfg.89.2020.08.30.08.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 08:57:27 -0700 (PDT)
Date:   Sun, 30 Aug 2020 23:57:23 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v3] xfstests: add test for xfs_repair progress reporting
Message-ID: <20200830155723.GA3853@desktop>
References: <20200524164648.GB3363@desktop>
 <20200817075313.1484879-1-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817075313.1484879-1-ddouwsma@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 05:53:13PM +1000, Donald Douwsma wrote:
> xfs_repair's interval based progress has been broken for
> some time, create a test based on dmdelay to stretch out
> the time and use ag_stride to force parallelism.
> 
> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>

Thanks for the revision! But I'm still seeing the following diff with
v5.9-rc2 kernel and latest xfsprogs for-next branch, which should
contains the progress reporting patches I guess (HEAD is commit
2cf166bca8a2 ("xfs_db: set b_ops to NULL in set_cur for types without
verifiers"))

 Format and populate
 Introduce a dmdelay
 Run repair
+ - #:#:#: Phase #: #% done - estimated remaining time 
  - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
  - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
  - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done

Thanks,
Eryu

> ---
> Changes since v2:
> - Fix cleanup handling and function naming
> - Added to auto group
> Changes since v1:
> - Use _scratch_xfs_repair
> - Filter only repair output
> - Make the filter more tolerant of whitespace and plurals
> - Take golden output from 'xfs_repair: fix progress reporting'
> 
>  tests/xfs/521     | 75 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/521.out | 15 ++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 91 insertions(+)
>  create mode 100755 tests/xfs/521
>  create mode 100644 tests/xfs/521.out
> 
> diff --git a/tests/xfs/521 b/tests/xfs/521
> new file mode 100755
> index 00000000..c16c82bf
> --- /dev/null
> +++ b/tests/xfs/521
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 521
> +#
> +# Test xfs_repair's progress reporting
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_cleanup_delay > /dev/null 2>&1
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmdelay
> +. ./common/populate
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_dm_target delay
> +
> +# Filter output specific to the formatters in xfs_repair/progress.c
> +# Ideally we'd like to see hits on anything that matches
> +# awk '/{FMT/' repair/progress.c
> +filter_repair()
> +{
> +	sed -ne '
> +	s/[0-9]\+/#/g;
> +	s/^\s\+/ /g;
> +	s/\(second\|minute\)s/\1/g
> +	/#:#:#:/p
> +	'
> +}
> +
> +echo "Format and populate"
> +_scratch_populate_cached nofill > $seqres.full 2>&1
> +
> +echo "Introduce a dmdelay"
> +_init_delay
> +
> +# Introduce a read I/O delay
> +# The default in common/dmdelay is a bit too agressive
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 100 $SCRATCH_DEV 0 0"
> +_load_delay_table $DELAY_READ
> +
> +echo "Run repair"
> +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> +        tee -a $seqres.full > $tmp.repair
> +
> +cat $tmp.repair | filter_repair | sort -u
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/521.out b/tests/xfs/521.out
> new file mode 100644
> index 00000000..03337083
> --- /dev/null
> +++ b/tests/xfs/521.out
> @@ -0,0 +1,15 @@
> +QA output created by 521
> +Format and populate
> +Introduce a dmdelay
> +Run repair
> + - #:#:#: Phase #: #% done - estimated remaining time # minute, # second
> + - #:#:#: Phase #: elapsed time # second - processed # inodes per minute
> + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> + - #:#:#: process known inodes and inode discovery - # of # inodes done
> + - #:#:#: process newly discovered inodes - # of # allocation groups done
> + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> + - #:#:#: verify and correct link counts - # of # allocation groups done
> + - #:#:#: zeroing log - # of # blocks done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..1c8ec5fa 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -517,3 +517,4 @@
>  518 auto quick quota
>  519 auto quick reflink
>  520 auto quick reflink
> +521 auto repair
> -- 
> 2.18.4
