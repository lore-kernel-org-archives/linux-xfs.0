Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1457C56202
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 15:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4478A2466D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 15:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FnHkc1oc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgKQPZA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 10:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbgKQPY7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 10:24:59 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1819EC0613CF;
        Tue, 17 Nov 2020 07:25:00 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id s2so10392409plr.9;
        Tue, 17 Nov 2020 07:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsjB0Eh05EQos0zRPJfxl6QCJLD+cu5dQO3RxLN4Ngg=;
        b=FnHkc1ocvCEnLzrWdB/jeXUlciU6B/WsZFFLdYXovSIhxCXNfvf5Bvb3HV3IIizmix
         lQsfxSiJe/gq2jFY22zxVp4IBXAYAWQQk6pfckHHp2zq+p8ZpYJvOsi9poLn9vOlKjaK
         Ti+mfC2EP2PMdyryLX/HLprWIID3YVRDcqgiR9GycRVfR2peESeQYJ3YhH+LDhGhZuoT
         yTxTHFnfHDHyprm8b7F9Po8dfuJNGhjN1AayhDXppElSBRXKk1g+AI/6XcWpQejBvjaZ
         MpGhy2vwTTNhxEk0sXNsnUChGEXi6kuthMp0TPRqsP2rXmpbdluS/ko7jem00cDu8z9+
         za/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsjB0Eh05EQos0zRPJfxl6QCJLD+cu5dQO3RxLN4Ngg=;
        b=hNF+nHzWQf9LGVMF/hPX1KBQwnbPo5ILSD1tri919Fn8StRBArEmHX2pwDT9Lxl7YR
         CoD6U4BipCkH9LwAHqscuIU1a22N65OKU3uYQWE9aVH74IBTInIaUxGv+MsmjKTkVSVm
         nxzQ052rvDrZ93CG8A79sTZpXms5BWVSWZQ4ClD+/01hFq+EoAW+qfYBDeFFLlhyElmt
         Zeezj3MFM4hA/WEUmMZorWrWF0kfmVhkbKfBwYrpkNDsFnKxA0Fm34VSVHYkP8jZ6/vt
         1cXck1RF/qvP0ge49vwUz4h+STuey4gzx4SLF0zhHFonzeFVJ3pVTUzPDBF/WXaXVhEZ
         YeQQ==
X-Gm-Message-State: AOAM530/q+sg6dBOeNznXuznOz1dx2hDgbgeaZ93n26fnJ5e1xFYI+gB
        A567qJKtqjjh3ysjO6RCsKc=
X-Google-Smtp-Source: ABdhPJxDFuzbSln7o3OS+kddUr5JN0+AjgvebfWVRUa2b8PYCBBA78bmR2++K5JWfyjZYzmSOV2OUQ==
X-Received: by 2002:a17:90b:2343:: with SMTP id ms3mr4992476pjb.130.1605626699641;
        Tue, 17 Nov 2020 07:24:59 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id ga16sm3538968pjb.43.2020.11.17.07.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 07:24:59 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: Stress test with with bmap_alloc_minlen_extent error tag enabled
Date:   Tue, 17 Nov 2020 20:54:56 +0530
Message-ID: <3561994.ZRBtArQVq0@garuda>
In-Reply-To: <20201114000602.GZ9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-12-chandanrlinux@gmail.com> <20201114000602.GZ9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 5:36:02 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:57:03PM +0530, Chandan Babu R wrote:
> > This commit adds a stress test that executes fsstress with
> > bmap_alloc_minlen_extent error tag enabled.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/531     | 85 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/531.out |  6 ++++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 92 insertions(+)
> >  create mode 100755 tests/xfs/531
> >  create mode 100644 tests/xfs/531.out
> > 
> > diff --git a/tests/xfs/531 b/tests/xfs/531
> > new file mode 100755
> > index 00000000..e846cc0e
> > --- /dev/null
> > +++ b/tests/xfs/531
> > @@ -0,0 +1,85 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 531
> > +#
> > +# Execute fsstress with bmap_alloc_minlen_extent error tag enabled.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_debug
> > +_require_test_program "punch-alternating"
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +
> > +echo "Format and mount fs"
> > +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> 
> Why is a 1G fs required?

With the sparse file occupying almost half of the filesystem space, fsstress
will have only remaining half of the space to work with. With 1GiB sized
filesystem, fsstress can have ~512MiB of free space.

> 
> > +_scratch_mount >> $seqres.full
> > +
> > +bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +testfile=$SCRATCH_MNT/testfile
> > +
> > +echo "Consume free space"
> > +dd if=/dev/zero of=${testfile} bs=${bsize} >> $seqres.full 2>&1
> > +sync
> > +
> > +echo "Create fragmented filesystem"
> > +$here/src/punch-alternating $testfile >> $seqres.full
> > +sync
> > +
> > +echo "Inject bmap_alloc_minlen_extent error tag"
> > +xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +echo "Execute fsstress in background"
> > +$FSSTRESS_PROG -d $SCRATCH_MNT -p128 -n999999999 \
> 
> -n and -p ought to be computed from TIME_FACTOR and LOAD_FACTOR.

Ok. I will fix that.

> 
> --D
> 
> > +		 -f bulkstat=0 \
> > +		 -f bulkstat1=0 \
> > +		 -f fiemap=0 \
> > +		 -f getattr=0 \
> > +		 -f getdents=0 \
> > +		 -f getfattr=0 \
> > +		 -f listfattr=0 \
> > +		 -f mread=0 \
> > +		 -f read=0 \
> > +		 -f readlink=0 \
> > +		 -f readv=0 \
> > +		 -f stat=0 \
> > +		 -f aread=0 \
> > +		 -f dread=0 > /dev/null 2>&1 &
> > +
> > +fsstress_pid=$!
> > +sleep 2m
> > +
> > +echo "Killing fsstress process $fsstress_pid ..." >> $seqres.full
> > +kill $fsstress_pid >> $seqres.full
> > +wait $fsstress_pid
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/531.out b/tests/xfs/531.out
> > new file mode 100644
> > index 00000000..e0a419c2
> > --- /dev/null
> > +++ b/tests/xfs/531.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 531
> > +Format and mount fs
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject bmap_alloc_minlen_extent error tag
> > +Execute fsstress in background
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 81a15582..f4cb5af6 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -528,3 +528,4 @@
> >  528 auto quick reflink
> >  529 auto quick reflink
> >  530 auto quick
> > +531 auto stress
> 


-- 
chandan



