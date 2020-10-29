Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC05AC55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 13:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA8620825
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 13:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xfq23avM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJ2NNm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 09:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2NNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 09:13:42 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74979C0613CF;
        Thu, 29 Oct 2020 06:13:42 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id k6so2951251ilq.2;
        Thu, 29 Oct 2020 06:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1AnBkIA2CTXcd1DOB5m1dzkPgu4i5QmiOenYrZYJQ68=;
        b=Xfq23avMU0rgeBa+gc7X0emoK8LVMO8gDSGb7kall9BGu+LW0U9ryaY/wrIqq95svu
         jcfxcSQxDroEKVXhlOySD1qIzw0uH1JZ9ofkcSm4Z3nf6U6iY6Cmaj1bz+PEzcAJE38z
         hFRKZ4Q4bjSQnxXFLCxS2vy8s+4TXzfO4IKEy4UyzO/3lKWxfQmZnY0rYlzfYm7oraWw
         27gCK6FucXSlHYRLTXcu4rZMknmGvW3ZFRJ3nfC503lJqZAb4I/B9TIELps+cjkyfaLB
         a5759c4b8vHZ2v3BLDl8pJOk3/URkH7LhipRqCMTk0Or8vqrsBCd+gtQfl+WJW7g5Ave
         B6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1AnBkIA2CTXcd1DOB5m1dzkPgu4i5QmiOenYrZYJQ68=;
        b=ZWGXlkVDkPiXabXROxK/9ePfR51PDC55Nj9GS8or77IaUSmetIEfp5WZKX6B/K1Woo
         5FhOXAC02df7Pi28ugu/CtpTwiRvikPHRnDjG4ZuNe9RiqX090lc5uioFruFYfW7DfcM
         /NVsA0QdjqIVgWeSuGgP9hi1VLWW+2R5z82nd6dZoqRXBaGQ7LNOYPQ1v8QHL6bvr6YB
         zFNXwR45/N/aPRsK3iEeInsfNNINxeof85IDYJE6SoFup5pJOAPb6psQJ5oHJkgdfNMI
         VGjlFOrSqI5NWQyXxMG1kpyDqSqOvykeDRbYL4k7EJfico8uoF6EpynFp+uNoDjhyWY4
         6nUg==
X-Gm-Message-State: AOAM5316kFXJKR78EClQgdHrKMypWNYhPtVbWEMVdrwtXJleL7Q2cacJ
        7gXfzDCmnkaXATcHf1+YjTHCi4Ll36Zh9ChEvDWqXXO7vWE=
X-Google-Smtp-Source: ABdhPJwTWCjpF/lS0xkmCDV3ocYs3W0keywADawuMZrON8zEbmusWCcdjFj9au1Ccb1amDA60fZBHIP/KlTbFAXVsDA=
X-Received: by 2002:a92:d30f:: with SMTP id x15mr1350973ila.9.1603976826806;
 Thu, 29 Oct 2020 06:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia> <160382545965.1203848.17436126884496645934.stgit@magnolia>
In-Reply-To: <160382545965.1203848.17436126884496645934.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 15:06:55 +0200
Message-ID: <CAOQ4uxiCe+fnXh6eeduWDbtaZQxMuj5UuU+B85j4z1OnbxthcA@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Test that we can upgrade an existing filesystem to use bigtime.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Just some nits.
Not adding RVB because I would rather someone with more understanding of quotas
will review this.

> ---
>  common/xfs        |   16 ++++++
>  tests/xfs/908     |   87 ++++++++++++++++++++++++++++++
>  tests/xfs/908.out |   10 +++
>  tests/xfs/909     |  153 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/909.out |    4 +
>  tests/xfs/group   |    2 +
>  6 files changed, 272 insertions(+)
>  create mode 100755 tests/xfs/908
>  create mode 100644 tests/xfs/908.out
>  create mode 100755 tests/xfs/909
>  create mode 100644 tests/xfs/909.out
>
>
> diff --git a/common/xfs b/common/xfs
> index 19ccee03..4274eee7 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1008,3 +1008,19 @@ _xfs_timestamp_range()
>                 $dbprog -f -c 'timelimit --compact' | awk '{printf("%s %s", $1, $2);}'
>         fi
>  }
> +
> +_require_xfs_mkfs_bigtime()
> +{
> +       _scratch_mkfs_xfs_supported -m bigtime=1 >/dev/null 2>&1 \
> +          || _notrun "mkfs.xfs doesn't have bigtime feature"
> +}
> +
> +_require_xfs_scratch_bigtime()
> +{
> +       _require_scratch
> +
> +       _scratch_mkfs -m bigtime=1 > /dev/null
> +       _try_scratch_mount || \
> +               _notrun "bigtime not supported by scratch filesystem type: $FSTYP"
> +       _scratch_unmount
> +}
> diff --git a/tests/xfs/908 b/tests/xfs/908
> new file mode 100755
> index 00000000..e368d66c
> --- /dev/null
> +++ b/tests/xfs/908
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 908
> +#
> +# Check that we can upgrade a filesystem to support bigtime and that inode
> +# timestamps work properly after the upgrade.
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
> +. ./common/filter
> +
> +# We have very specific formatting parameters, so don't let things get complex
> +# with realtime devices and external logs.
> +unset USE_EXTERNAL
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_mkfs_crc
> +_require_xfs_mkfs_bigtime
> +_require_xfs_scratch_bigtime

Should we also explicitly require support for xfs_admin -O bigtime?

> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +       _notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/a
> +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/b
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo before upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime >> $seqres.full
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +# Modify one of the timestamps to stretch beyond 2038
> +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> +
> +echo after upgrade:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +_scratch_cycle_mount
> +
> +# Did the timestamp survive the remount?
> +ls -la $SCRATCH_MNT/* >> $seqres.full
> +
> +echo after upgrade and remount:
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/908.out b/tests/xfs/908.out
> new file mode 100644
> index 00000000..f0f412be
> --- /dev/null
> +++ b/tests/xfs/908.out
> @@ -0,0 +1,10 @@
> +QA output created by 908
> +before upgrade:
> +915909559
> +915909559
> +after upgrade:
> +915909559
> +7956915742
> +after upgrade and remount:
> +915909559
> +7956915742
> diff --git a/tests/xfs/909 b/tests/xfs/909
> new file mode 100755
> index 00000000..7010eb9e
> --- /dev/null
> +++ b/tests/xfs/909
> @@ -0,0 +1,153 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 909
> +#
> +# Check that we can upgrade a filesystem to support bigtime and that quota
> +# timers work properly after the upgrade.
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
> +. ./common/filter
> +. ./common/quota
> +
> +# We have very specific formatting parameters, so don't let things get complex
> +# with realtime devices and external logs.
> +unset USE_EXTERNAL
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_quota
> +_require_xfs_mkfs_crc
> +_require_xfs_mkfs_bigtime
> +_require_xfs_scratch_bigtime
> +
> +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> +       _notrun "Userspace does not support dates past 2038."
> +
> +rm -f $seqres.full
> +
> +# Format V5 filesystem without bigtime support and populate it
> +_scratch_mkfs -m crc=1,bigtime=0 > $seqres.full
> +_qmount_option "usrquota"
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +# Force the block counters for uid 1 and 2 above zero
> +_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
> +_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
> +sync
> +chown 1 $SCRATCH_MNT/a
> +chown 2 $SCRATCH_MNT/b
> +
> +# Set quota limits on uid 1 before upgrading
> +$XFS_QUOTA_PROG -x -c 'limit -u bsoft=12k bhard=1m 1' $SCRATCH_MNT
> +
> +# Make sure the grace period is at /some/ point in the future.  We have to
> +# use bc because not all bashes can handle integer comparisons with 64-bit
> +# numbers.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace="$(cat $tmp.repquota | grep '^#1' | awk '{print $6}')"
> +now="$(date +%s)"
> +res="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test $res -eq 1 || echo "Expected timer expiry (${grace}) to be after now (${now})."
> +
> +_scratch_unmount
> +
> +# Now upgrade to bigtime support
> +_scratch_xfs_admin -O bigtime >> $seqres.full
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +
> +# Mount again, see if our quota timer survived
> +_scratch_mount
> +
> +# Set a very generous grace period and quota limits on uid 2 after upgrading
> +$XFS_QUOTA_PROG -x -c 'timer -u -b -d 2147483647' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'limit -u bsoft=10000 bhard=150000 2' $SCRATCH_MNT
> +
> +# Query the grace periods to see if they got set properly after the upgrade.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +now="$(date +%s)"
> +
> +# Make sure that uid 1's expiration is in the future...
> +res1="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
> +
> +# ...and that uid 2's expiration is after uid 1's...
> +res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
> +test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
> +
> +# ...and that uid 2's expiration is after 2038 if right now is far enough
> +# past 1970 that our generous grace period would provide for that.
> +res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
> +test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
> +
> +_scratch_cycle_mount
> +
> +# Query the grace periods to see if they survived a remount.
> +repquota -upn $SCRATCH_MNT > $tmp.repquota
> +cat $tmp.repquota >> $seqres.full
> +grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +now="$(date +%s)"
> +
> +# Make sure that uid 1's expiration is in the future...
> +res1="$(echo "${grace} > ${now}" | $BC_PROG)"
> +test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
> +
> +# ...and that uid 2's expiration is after uid 1's...
> +res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
> +test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
> +
> +# ...and that uid 2's expiration is after 2038 if right now is far enough
> +# past 1970 that our generous grace period would provide for that.
> +res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
> +test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
> +
> +# Now try setting uid 2's expiration to Feb 22 22:22:22 UTC 2222
> +new_expiry=$(date -d 'Feb 22 22:22:22 UTC 2222' +%s)
> +now=$(date +%s)
> +test $now -ge $new_expiry && \
> +       echo "Now is after February 2222?  Expect problems."
> +expiry_delta=$((new_expiry - now))
> +
> +echo "setting expiration to $new_expiry - $now = $expiry_delta" >> $seqres.full
> +$XFS_QUOTA_PROG -x -c "timer -u $expiry_delta 2" -c 'report' $SCRATCH_MNT >> $seqres.full
> +
> +# Did we get an expiration within 5s of the target range?
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +echo "grace2 is $grace2" >> $seqres.full
> +_within_tolerance "grace2 expiry" $grace2 $new_expiry 5 -v
> +
> +_scratch_cycle_mount
> +
> +# ...and is it still within 5s after a remount?
> +grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
> +echo "grace2 is $grace2" >> $seqres.full
> +_within_tolerance "grace2 expiry after remount" $grace2 $new_expiry 5 -v
> +
> +# success, all done
> +echo Silence is golden.
> +status=0
> +exit
> diff --git a/tests/xfs/909.out b/tests/xfs/909.out
> new file mode 100644
> index 00000000..948502b7
> --- /dev/null
> +++ b/tests/xfs/909.out
> @@ -0,0 +1,4 @@
> +QA output created by 909
> +grace2 expiry is in range
> +grace2 expiry after remount is in range
> +Silence is golden.

Output is not silent ;-)

Thanks,
Amir.
