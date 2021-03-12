Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DA7C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 616B564FB9
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 15:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCLPiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 10:38:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231976AbhCLPh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 10:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615563479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1WNLRHUBpjYvO6+BkTpO46mGYFHEtDuYFA27ceAwnY=;
        b=D9c3jPugFDy84h2rQkB48j9t2zQAB1NuNgiFxXmrLmUtdEEC0sz9h4fznJjxGXKIcuaUqw
        s1P/EEZtUKKZZ00U+A6iq4XVMHslVb+fV5XORWy292r51NL0j9lXPKQ44xsjqCyO/lsLmJ
        Ci4HdWu2G4TyJ4i/hHBV8BWicQppliw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-rDMfl0hpOP2uXuntR3AWNA-1; Fri, 12 Mar 2021 10:37:57 -0500
X-MC-Unique: rDMfl0hpOP2uXuntR3AWNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D721A40C2;
        Fri, 12 Mar 2021 15:37:56 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8614419744;
        Fri, 12 Mar 2021 15:37:49 +0000 (UTC)
Date:   Fri, 12 Mar 2021 23:56:13 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [RFC PATCH v2 2/3] xfs: basic functionality test for shrinking
 free space in the last AG
Message-ID: <20210312155613.GK3499219@localhost.localdomain>
Mail-Followup-To: Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312132300.259226-3-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 12, 2021 at 09:22:59PM +0800, Gao Xiang wrote:
> Add basic test to make sure the functionality works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  tests/xfs/990     | 59 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/990.out | 12 ++++++++++
>  tests/xfs/group   |  1 +
>  3 files changed, 72 insertions(+)
>  create mode 100755 tests/xfs/990
>  create mode 100644 tests/xfs/990.out
> 
> diff --git a/tests/xfs/990 b/tests/xfs/990
> new file mode 100755
> index 00000000..551c4784
> --- /dev/null
> +++ b/tests/xfs/990
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 990
> +#
> +# XFS shrinkfs basic functionality test
> +#
> +# This test attempts to shrink with a small size (512K), half AG size and
> +# an out-of-bound size (agsize + 1) to observe if it works as expected.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs

_require_scratch

> +_require_xfs_shrink
> +
> +rm -f $seqres.full
> +echo "Format and mount"
> +size="$((512 * 1024 * 1024))"

Is the fixed size necessary? Is that better to let testers run this test with
their different device/XFS geometry.

> +_scratch_mkfs -dsize=$size -dagcount=3 2>&1 | \
> +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> +. $tmp.mkfs
> +_scratch_mount >> $seqres.full 2>&1
> +
> +echo "Shrink fs (small size)"
> +$XFS_GROWFS_PROG -D $((dblocks-512*1024/dbsize)) $SCRATCH_MNT \
> +	>> $seqres.full 2>&1 || echo failure
> +_scratch_cycle_mount

I don't understand the XFS Shrink new feature that much, is the "cycle_mount"
necessary? If it's not, can we get more chances to find bugs without
"cycle_mount", or with a fsck?

Another question is, should we verify the new size after shrink?

> +
> +echo "Shrink fs (half AG)"
> +$XFS_GROWFS_PROG -D $((dblocks-agsize/2)) $SCRATCH_MNT \
> +	>> $seqres.full 2>&1 || echo failure
> +_scratch_cycle_mount
> +
> +echo "Shrink fs (out-of-bound)"
> +$XFS_GROWFS_PROG -D $((dblocks-agsize-1)) $SCRATCH_MNT \
> +	>> $seqres.full 2>&1 && echo failure
> +_scratch_cycle_mount
> +
> +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> +
> +_scratch_unmount
   ^^^
   It's not necessary.

> +echo "*** done"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/990.out b/tests/xfs/990.out
> new file mode 100644
> index 00000000..812f89ef
> --- /dev/null
> +++ b/tests/xfs/990.out
> @@ -0,0 +1,12 @@
> +QA output created by 990
> +Format and mount
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +Shrink fs (small size)
> +Shrink fs (half AG)
> +Shrink fs (out-of-bound)
> +*** done
> diff --git a/tests/xfs/group b/tests/xfs/group
> index e861cec9..a7981b67 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -525,3 +525,4 @@
>  525 auto quick mkfs
>  526 auto quick mkfs
>  527 auto quick quota
> +990 auto quick growfs
> -- 
> 2.27.0
> 

