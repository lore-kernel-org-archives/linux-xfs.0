Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC8C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8AB220EDD
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRnq1H1p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgJ2KfJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgJ2KfJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:35:09 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D556BC0613CF;
        Thu, 29 Oct 2020 03:35:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id y17so2490317ilg.4;
        Thu, 29 Oct 2020 03:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cziZU2mDGtPX5p1BiG/SpBPC/iEgynxGjU5ZYng/VPo=;
        b=fRnq1H1pOHo7sWiAmTIupVT/XcWo7bUq7XTiRq4qdPfqPorQ8swF12WOC11eSGRWat
         57SNp9I4sFglMJF1qMnAR1ShSWFZHbFDXUQ24IclS69Oqmxe7/F5eRABS8WNCH9piQwj
         Z75AXKmEEYy/cj240yw7xvbyKn/g3+izRR0t6x9KPOiUct512ofCLTr8OidHfBLg6JLb
         5HpGIjpkEYnZs/okG4Oj+RkQ25WOek/b7RUhcsQYYbbi9HdW53rEr6RYtDJous+bjsse
         Ml+uCxV5spqKloFPLkWH1TMg0u3ELh/SZ/pxmX+a0eNqY8sWu3GbT2Fv4a1PssKi3OYc
         kqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cziZU2mDGtPX5p1BiG/SpBPC/iEgynxGjU5ZYng/VPo=;
        b=I4ZoGcqoL32EpZAgYtjyqqdXv0eo+4CX8Br5IWZQAXRu/q/P/9USaI3eTR0ZlOxwST
         3BNaxwkhkyvo9rGlbUnc02rBhewgWzMDu6u3dNaHL+lk4hlpqyaL+AeXTxQRin35PWW8
         RB4GRQxlRAQtjEek4Yh3fVtSWZQKbcktPlpFHye5mc+FTJKS5BrGbX41ueamX+oc3Qnv
         +pZvJMs7q83Rsde1mZpfk1uAD0W1LjbZMb7Z1mecop4LJuQdqLq88Sf76RsCQyrDHHAc
         wLDCoJeS/3nr/5P5RZ3ALzh+kCN/TayuzL4WSyhcGROJFSNNQTS9NWGg1odgRsutTBBt
         3SJQ==
X-Gm-Message-State: AOAM530vtvzhAufTGEhgfUazskF+YoB4Zm76YhNW7rxmv3FHqDqy+btt
        /0ymeS1PLyJhjS8GCHyWeSxlY1FqgKeKMxkpXoY=
X-Google-Smtp-Source: ABdhPJw4vbHgpOlX4CoUf8upfLMbmAwMGwshbhRNcuqO38/myW7ldMAU6jRx8J57OQVm3cyIvfdhZZi9dNDAEKMZZFA=
X-Received: by 2002:a92:6403:: with SMTP id y3mr2636863ilb.72.1603967708130;
 Thu, 29 Oct 2020 03:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia> <160382544101.1203848.15837078115947156573.stgit@magnolia>
In-Reply-To: <160382544101.1203848.15837078115947156573.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 12:34:57 +0200
Message-ID: <CAOQ4uxh9ihsUTsuaFdDTkP4rguNyAfDKq3_k6y1iEpZ3qoU2TQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] generic: check userspace handling of extreme timestamps
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> These two tests ensure we can store and retrieve timestamps on the
> extremes of the date ranges supported by userspace, and the common
> places where overflows can happen.
>
> They differ from generic/402 in that they don't constrain the dates
> tested to the range that the filesystem claims to support; we attempt
> various things that /userspace/ can parse, and then check that the vfs
> clamps and persists the values correctly.

So this test will fail when run on stable kernels before the vfs
clamping changes
and there is no require_* to mitigate that failure.

At the time, I discussed this with Deepa and the result was the
_check_dmesg_for part of _require_timestamp_range, which is incomplete.
The complete check for kernel clamping support would be to run
_require_timestamp_range (on the second half thereof) on a loop mounted
ext2, so we know for sure that the kernel is going to emit the y2038 warning.

I am going to leave it to you and the maintainer the decide how
critical that is,
but I would suggest to at least factor out _require_timestamp_limits()
which is true if either the filesystem timestamp range is known or the kernel
emits y2038 warning.

>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/generic/721     |  117 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/721.out |    1
>  tests/generic/722     |  120 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/722.out |    1
>  tests/generic/group   |    2 +
>  5 files changed, 241 insertions(+)
>  create mode 100755 tests/generic/721
>  create mode 100644 tests/generic/721.out
>  create mode 100755 tests/generic/722
>  create mode 100644 tests/generic/722.out
>
>
> diff --git a/tests/generic/721 b/tests/generic/721
> new file mode 100755
> index 00000000..9638fbfc
> --- /dev/null
> +++ b/tests/generic/721
> @@ -0,0 +1,117 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 721
> +#
> +# Make sure we can store and retrieve timestamps on the extremes of the
> +# date ranges supported by userspace, and the common places where overflows
> +# can happen.
> +#
> +# This differs from generic/402 in that we don't constrain ourselves to the
> +# range that the filesystem claims to support; we attempt various things that
> +# /userspace/ can parse, and then check that the vfs clamps and persists the
> +# values correctly.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +# Does our userspace even support large dates?
> +test_bigdates=1
> +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> +
> +# And can we do statx?
> +test_statx=1
> +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> +       test_statx=0
> +
> +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> +
> +touchme() {
> +       local arg="$1"
> +       local name="$2"
> +
> +       echo "$arg" > $SCRATCH_MNT/t_$name
> +       touch -d "$arg" $SCRATCH_MNT/t_$name
> +}
> +
> +report() {
> +       local files=($SCRATCH_MNT/t_*)
> +       for file in "${files[@]}"; do
> +               echo "${file}: $(cat "${file}")"
> +               TZ=UTC stat -c '%y %Y %n' "${file}"
> +               test $test_statx -gt 0 && \
> +                       $XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> +       done
> +}
> +
> +# -2147483648 (S32_MIN, or classic unix min)
> +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> +
> +# 2147483647 (S32_MAX, or classic unix max)
> +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> +
> +# 7956915742, all twos
> +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> +
> +if [ $test_bigdates -gt 0 ]; then
> +       # 16299260424 (u64 nsec counter from s32_min, like xfs does)
> +       touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> +
> +       # 15032385535 (u34 time if you start from s32_min, like ext4 does)
> +       touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> +
> +       # 17179869183 (u34 time if you start from the unix epoch)
> +       touchme 'May 30 01:53:03 UTC 2514' u34_max
> +
> +       # Latest date we can synthesize(?)
> +       touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> +
> +       # Earliest date we can synthesize(?)
> +       touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> +fi
> +
> +# Query timestamps from incore
> +echo before >> $seqres.full
> +report > $tmp.times0
> +cat $tmp.times0 >> $seqres.full
> +
> +_scratch_cycle_mount
> +
> +# Query timestamps from disk
> +echo after >> $seqres.full
> +report > $tmp.times1
> +cat $tmp.times1 >> $seqres.full
> +
> +# Did they match?
> +cmp -s $tmp.times0 $tmp.times1
> +

Please use suffix $tmp.{before,after}_cycle_mount
It makes the meaning of the diff in the test failure much clearer
to a bystander.

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/721.out b/tests/generic/721.out
> new file mode 100644
> index 00000000..087decb5
> --- /dev/null
> +++ b/tests/generic/721.out
> @@ -0,0 +1 @@
> +QA output created by 721

What? no "Silence is golden"? :-D

> diff --git a/tests/generic/722 b/tests/generic/722
> new file mode 100755
> index 00000000..3e8c553b
> --- /dev/null
> +++ b/tests/generic/722
> @@ -0,0 +1,120 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 722
> +#
> +# Make sure we can store and retrieve timestamps on the extremes of the
> +# date ranges supported by userspace, and the common places where overflows
> +# can happen.  This test also ensures that the timestamps are persisted
> +# correctly after a shutdown.
> +#
> +# This differs from generic/402 in that we don't constrain ourselves to the
> +# range that the filesystem claims to support; we attempt various things that
> +# /userspace/ can parse, and then check that the vfs clamps and persists the
> +# values correctly.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_scratch
> +_require_scratch_shutdown
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount
> +
> +# Does our userspace even support large dates?
> +test_bigdates=1
> +touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
> +
> +# And can we do statx?
> +test_statx=1
> +($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
> + $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
> +       test_statx=0
> +
> +echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
> +echo "xfs_io support of statx: $test_statx" >> $seqres.full
> +
> +touchme() {
> +       local arg="$1"
> +       local name="$2"
> +
> +       echo "$arg" > $SCRATCH_MNT/t_$name
> +       touch -d "$arg" $SCRATCH_MNT/t_$name
> +}
> +
> +report() {
> +       local files=($SCRATCH_MNT/t_*)
> +       for file in "${files[@]}"; do
> +               echo "${file}: $(cat "${file}")"
> +               TZ=UTC stat -c '%y %Y %n' "${file}"
> +               test $test_statx -gt 0 && \
> +                       $XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
> +       done
> +}
> +
> +# -2147483648 (S32_MIN, or classic unix min)
> +touchme 'Dec 13 20:45:52 UTC 1901' s32_min
> +
> +# 2147483647 (S32_MAX, or classic unix max)
> +touchme 'Jan 19 03:14:07 UTC 2038' s32_max
> +
> +# 7956915742, all twos
> +touchme 'Feb 22 22:22:22 UTC 2222' all_twos
> +
> +if [ $test_bigdates -gt 0 ]; then
> +       # 16299260424 (u64 nsec counter from s32_min, like xfs does)
> +       touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
> +
> +       # 15032385535 (u34 time if you start from s32_min, like ext4 does)
> +       touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
> +
> +       # 17179869183 (u34 time if you start from the unix epoch)
> +       touchme 'May 30 01:53:03 UTC 2514' u34_max
> +
> +       # Latest date we can synthesize(?)
> +       touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
> +
> +       # Earliest date we can synthesize(?)
> +       touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
> +fi
> +
> +# Query timestamps from incore
> +echo before >> $seqres.full
> +report > $tmp.times0
> +cat $tmp.times0 >> $seqres.full
> +
> +_scratch_shutdown -f
> +_scratch_cycle_mount
> +
> +# Query timestamps from disk
> +echo after >> $seqres.full
> +report > $tmp.times1
> +cat $tmp.times1 >> $seqres.full
> +
> +# Did they match?
> +cmp -s $tmp.times0 $tmp.times1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/722.out b/tests/generic/722.out
> new file mode 100644
> index 00000000..83acd5cf
> --- /dev/null
> +++ b/tests/generic/722.out
> @@ -0,0 +1 @@
> +QA output created by 722
> diff --git a/tests/generic/group b/tests/generic/group
> index cf4fdc23..b533d6b2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -615,5 +615,7 @@
>  610 auto quick prealloc zero
>  611 auto quick attr
>  612 auto quick clone
> +721 auto quick atime bigtime
> +722 auto quick atime bigtime

shutdown group please.

If we are going to use "bigtime" for generic tests to describe y2038 tests,
perhaps add it to 258 and 402 as well?

Thanks,
Amir.
