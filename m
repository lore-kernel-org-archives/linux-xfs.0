Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C215DCCA485
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiFHGBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343676AbiFHFz4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 01:55:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76E873D9F84
        for <linux-xfs@vger.kernel.org>; Tue,  7 Jun 2022 20:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654660781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMT1wlgJbLx2m8SJsF/yfd3/kTWNTcXwn25iSFqRJ0U=;
        b=GfrBnxqaJQH4/cK1VKrwh0isJas5B/XigBBPfZpq3DUtoDSej6pjGmIrXDpBgtE75tRyor
        8RSvbX43EYoOldbjpnh2LONrvMBCAGqhLNQ1zgN0ronRhnsW2swK20SeWBfBmea9dp/x4r
        oiBRowqK5QoamdZBF9KB5ZoE+1zr6J4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-FkuUgbcjMKqHw0yC17n_Cw-1; Tue, 07 Jun 2022 23:59:40 -0400
X-MC-Unique: FkuUgbcjMKqHw0yC17n_Cw-1
Received: by mail-qv1-f70.google.com with SMTP id z10-20020ad4414a000000b004644d6dafe3so12197485qvp.11
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jun 2022 20:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FMT1wlgJbLx2m8SJsF/yfd3/kTWNTcXwn25iSFqRJ0U=;
        b=saO1F0gskrc9Q0uCEdoGVzIqsZw/ldhpJkMWV5PI4uEu3kNK1rPan8R5tjfw7Aj4qU
         jGReFlFqXoO4o1FRNjFukAOjeYYySyZ1V4T+bU/ygjv6E7dMTSSbKwlp0IpjsIG6/peI
         p2aHZulcmG9G48s1titOMu7hylFqSEWAx8joKcqwSahCass6TwDaxBhGh240R6eQIfYm
         hckUIwZjrNO0fXbT8QONMP9vxHuOZJrPT3voZ3gaOXSF3VEWYVXu/Ou5773SLWTfkdLC
         OQojivHPxkd25DRs3L0ikKZZU2gd84GpmYvfTxKeIAjermJRMRzwhLp2gRMzHR0GNJ8l
         KSNA==
X-Gm-Message-State: AOAM531T232PxQ7vD6yIfY7fQMDehUqIAw2m6ZY/hOH2KOYQMlYkeDE7
        yuVZxq/MPIPMqEYnJ3rdazIbCrOlNQmdaTAi8gGcO7bEdgrhlUfehiQ+btmzPz1jB7gbW69s1EE
        eXX9LEjUEkCWUmyshpjxz
X-Received: by 2002:ac8:5ac2:0:b0:304:c980:7d76 with SMTP id d2-20020ac85ac2000000b00304c9807d76mr25562570qtd.454.1654660780343;
        Tue, 07 Jun 2022 20:59:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUjCHX9AwQQcYhsCb41SYRAtX+JvP789ujrfGlt/LGhaF6PTUKGXkVu7YnFhxC7+tyI9JKAg==
X-Received: by 2002:ac8:5ac2:0:b0:304:c980:7d76 with SMTP id d2-20020ac85ac2000000b00304c9807d76mr25562565qtd.454.1654660780049;
        Tue, 07 Jun 2022 20:59:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bp38-20020a05622a1ba600b00304e4bbc369sm8831821qtb.10.2022.06.07.20.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 20:59:39 -0700 (PDT)
Date:   Wed, 8 Jun 2022 11:59:33 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/547: Verify that the correct inode extent
 counters are updated with/without nrext64
Message-ID: <20220608035933.rcaevihjijarst5v@zlang-mailbox>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-4-chandan.babu@oracle.com>
 <Yp4f/yalwFunfEgz@magnolia>
 <87zgion6nx.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgion6nx.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 07, 2022 at 03:06:58PM +0530, Chandan Babu R wrote:
> On Mon, Jun 06, 2022 at 08:40:47 AM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 06, 2022 at 06:11:00PM +0530, Chandan Babu R wrote:
> >> This commit adds a new test to verify if the correct inode extent counter
> >> fields are updated with/without nrext64 mkfs option.
> >> 
> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> >> ---
> >>  tests/xfs/547     | 91 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/xfs/547.out | 13 +++++++
> >>  2 files changed, 104 insertions(+)
> >>  create mode 100755 tests/xfs/547
> >>  create mode 100644 tests/xfs/547.out
> >> 
> >> diff --git a/tests/xfs/547 b/tests/xfs/547
> >> new file mode 100755
> >> index 00000000..d5137ca7
> >> --- /dev/null
> >> +++ b/tests/xfs/547
> >> @@ -0,0 +1,91 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 547
> >> +#
> >> +# Verify that correct inode extent count fields are populated with and without
> >> +# nrext64 feature.
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick metadata
> >> +
> >> +# Import common functions.
> >> +. ./common/filter
> >> +. ./common/attr
> >> +. ./common/inject
> >> +. ./common/populate
> >> +
> >> +# real QA test starts here
> >> +_supported_fs xfs
> >> +_require_scratch
> >> +_require_scratch_xfs_nrext64
> >> +_require_attrs
> >> +_require_xfs_debug
> >> +_require_test_program "punch-alternating"
> >> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> >> +
> >> +for nrext64 in 0 1; do
> >> +	echo "* Verify extent counter fields with nrext64=${nrext64} option"
> >> +
> >> +	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
> >> +		      >> $seqres.full
> >> +	_scratch_mount >> $seqres.full
> >> +
> >> +	bsize=$(_get_file_block_size $SCRATCH_MNT)
> >> +
> >> +	testfile=$SCRATCH_MNT/testfile
> >> +
> >> +	nr_blks=20
> >> +
> >> +	echo "Add blocks to test file's data fork"
> >> +	$XFS_IO_PROG -f -c "pwrite 0 $((nr_blks * bsize))" $testfile \
> >> +		     >> $seqres.full
> >> +	$here/src/punch-alternating $testfile
> >> +
> >> +	echo "Consume free space"
> >> +	fillerdir=$SCRATCH_MNT/fillerdir
> >> +	nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
> >> +	nr_free_blks=$((nr_free_blks * 90 / 100))
> >> +
> >> +	_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 \
> >> +		 >> $seqres.full 2>&1
> >> +
> >> +	echo "Create fragmented filesystem"
> >> +	for dentry in $(ls -1 $fillerdir/); do
> >> +		$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
> >> +	done
> >> +
> >> +	echo "Inject bmap_alloc_minlen_extent error tag"
> >> +	_scratch_inject_error bmap_alloc_minlen_extent 1
> >> +
> >> +	echo "Add blocks to test file's attr fork"
> >> +	attr_len=255
> >> +	nr_attrs=$((nr_blks * bsize / attr_len))
> >> +	for i in $(seq 1 $nr_attrs); do
> >> +		attr="$(printf "trusted.%0247d" $i)"
> >> +		$SETFATTR_PROG -n "$attr" $testfile >> $seqres.full 2>&1
> >> +		[[ $? != 0 ]] && break
> >> +	done
> >> +
> >> +	testino=$(stat -c '%i' $testfile)
> >> +
> >> +	_scratch_unmount >> $seqres.full
> >> +
> >> +	dcnt=$(_scratch_xfs_get_metadata_field core.nextents "inode $testino")
> >> +	acnt=$(_scratch_xfs_get_metadata_field core.naextents "inode $testino")
> >
> > Note: For any test requiring functionality added after 5.10, you can use
> > the xfs_db path command to avoid this sort of inode number saving:
> >
> > dcnt=$(_scratch_xfs_get_metadata_field core.nextents "path /testfile")
> >
> 
> Ok. I will post a v2 of the patchset to include the above suggestion.

_require_xfs_db_command path ?

Looks like the 'path' command is a new command will be in linux and xfsprogs
5.10.

It's not always recommended to use latest features/tools, that depends what does
this case test for. If this case is only for a bug/feature in 5.10, then the
'path' command is fine. If it's a common test case for old and new kernels, then
this new command isn't recommended, that will cause this test can't be run on
old system.

BTW, you'd better to not use a fixed case number in the patch subject, if the
patch is a new case. Due to the number might be changed when we merge it. And
a fixed case number in subject, might cause others feel this's a known case
update, not a new case.

Thanks,
Zorro

> 
> > Up to you if you want to change the test to do that; otherwise,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >
> 
> Thanks for the review.
> 
> -- 
> chandan
> 

