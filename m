Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8509FC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E66261418
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbhD1SFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 14:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241704AbhD1SFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 14:05:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619633064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WwQwsPdsXrGNk3ZqmC+mcov3m33KP0EMDaGudJhW/4c=;
        b=ETUKJexyYCTzzDHlO1X2TzvSFM5W7Bb4slngjDP3QEeMJ0M3jamJ9gOvVY1+xlbZoAgRo3
        2018gCepNLXO1QJjRw0nc57GDA4cPM3YMjk+Py0DheNXuohK7p4V8VOZ3fyYEeuyIYcBL/
        b1GPyZ++6JvRkvt9JNTOe91KV3LLBfE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-mdqLWLMAPzK1oh4EjZBUnw-1; Wed, 28 Apr 2021 14:04:07 -0400
X-MC-Unique: mdqLWLMAPzK1oh4EjZBUnw-1
Received: by mail-qk1-f200.google.com with SMTP id d185-20020ae9efc20000b02902e45ca32479so9829040qkg.21
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 11:04:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WwQwsPdsXrGNk3ZqmC+mcov3m33KP0EMDaGudJhW/4c=;
        b=ULhhn1C7z05x0R1xNtU63LiHUXuSSkecJf+6Ao2uxiLkE+iuDYqfqPapCS9EiXdGT0
         BUiQ/FW2FNV0YLfm95/Gv7x2V7lSVBXwyzZcWke7Yw2eK6CiQj2nmny05lb85jIDnAQr
         d3KSWWcrXHGbM7B1AZaTQSTNkTYUCMvCQG+ddiV8oIRUj8uLNHzFffzlp+rCdWrZbGXO
         dGeXo/UG2tAi35ZXFfSLJ6WUknMWxIS2uVzWpfSolBRLfher6CfoRpQa57kTtUrQvce2
         mRVw7pKUNSShaevJlXY2c4qGBgEZnLS6Lxp+5utLxD/RMOIAQLxgSnQtXHRKRQdRhnQt
         V8gw==
X-Gm-Message-State: AOAM533AbgsR01YiDHfCmv0NneZTuTSK23amzSzq0bH8sO557zpHNFhs
        IsjAW9B5VqNs4VFE4iIC8car3vzw7G4q/lI4zjGQQj90itIUxpPWvSzIxytTeZz6sVn7gq5W1y4
        UhlYFaHsTa78rglyNg3TA
X-Received: by 2002:a05:622a:94:: with SMTP id o20mr28689766qtw.158.1619633047257;
        Wed, 28 Apr 2021 11:04:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgf4JjYWOQnubsfqngU9igAHuW/I+NIt8V3d5jVsqnIYj0aMqWGlC8Ehjcg+yNLuE0fd+Q1g==
X-Received: by 2002:a05:622a:94:: with SMTP id o20mr28689739qtw.158.1619633047016;
        Wed, 28 Apr 2021 11:04:07 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id f2sm327117qkm.84.2021.04.28.11.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 11:04:06 -0700 (PDT)
Date:   Wed, 28 Apr 2021 14:04:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs/419: remove irrelevant swapfile test
Message-ID: <YImjlA1DEbaUpxwo@bfoster>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
 <161958297507.3452499.6111068461177037465.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958297507.3452499.6111068461177037465.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since the advent of iomap_swapfile_activate in XFS, we actually /do/
> support having swap files on the realtime device.  Remove this test.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/419     |   58 -----------------------------------------------------
>  tests/xfs/419.out |    5 -----
>  tests/xfs/group   |    1 -
>  3 files changed, 64 deletions(-)
>  delete mode 100755 tests/xfs/419
>  delete mode 100644 tests/xfs/419.out
> 
> 
> diff --git a/tests/xfs/419 b/tests/xfs/419
> deleted file mode 100755
> index fc7174bd..00000000
> --- a/tests/xfs/419
> +++ /dev/null
> @@ -1,58 +0,0 @@
> -#! /bin/bash
> -# SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
> -#
> -# FS QA Test No. 419
> -#
> -# Check that we can't swapon a realtime file.
> -#
> -seq=`basename $0`
> -seqres=$RESULT_DIR/$seq
> -echo "QA output created by $seq"
> -
> -here=`pwd`
> -tmp=/tmp/$$
> -status=1	# failure is the default!
> -trap "_cleanup; exit \$status" 0 1 2 3 7 15
> -
> -_cleanup()
> -{
> -	cd /
> -	rm -rf $tmp.*
> -}
> -
> -# get standard environment, filters and checks
> -. ./common/rc
> -. ./common/filter
> -
> -# real QA test starts here
> -_supported_fs xfs
> -_require_realtime
> -_require_scratch_swapfile
> -
> -echo "Format and mount"
> -_scratch_mkfs > $seqres.full 2>&1
> -_scratch_mount >> $seqres.full 2>&1
> -
> -testdir=$SCRATCH_MNT/test-$seq
> -mkdir $testdir
> -
> -blocks=160
> -blksz=65536
> -
> -echo "Initialize file"
> -echo >> $seqres.full
> -$XFS_IO_PROG -c "open -f -R $testdir/dummy" $testdir >> $seqres.full
> -echo moo >> $testdir/dummy
> -$XFS_IO_PROG -c "open -f -R $testdir/file1" $testdir >> $seqres.full
> -_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
> -$MKSWAP_PROG -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
> -
> -echo "Try to swapon"
> -swapon $testdir/file1 2>&1 | _filter_scratch
> -
> -swapoff $testdir/file1 >> $seqres.full 2>&1
> -
> -# success, all done
> -status=0
> -exit
> diff --git a/tests/xfs/419.out b/tests/xfs/419.out
> deleted file mode 100644
> index 83b7dd45..00000000
> --- a/tests/xfs/419.out
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -QA output created by 419
> -Format and mount
> -Initialize file
> -Try to swapon
> -swapon: SCRATCH_MNT/test-419/file1: swapon failed: Invalid argument
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 76e31167..549209a4 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -407,7 +407,6 @@
>  416 dangerous_fuzzers dangerous_scrub dangerous_repair
>  417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  418 dangerous_fuzzers dangerous_scrub dangerous_repair
> -419 auto quick swap realtime
>  420 auto quick clone punch seek
>  421 auto quick clone punch seek
>  422 dangerous_scrub dangerous_online_repair
> 

