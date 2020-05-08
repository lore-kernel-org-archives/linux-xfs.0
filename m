Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8484C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 21:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF943218AC
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 21:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHVM6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 17:12:58 -0400
Received: from sandeen.net ([63.231.237.45]:52376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgEHVM6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 May 2020 17:12:58 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C35674D7;
        Fri,  8 May 2020 16:12:47 -0500 (CDT)
Subject: Re: [RFC PATCH] xfs: make sure our default quota warning limits and
 grace periods survive quotacheck
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Eryu Guan <guaneryu@gmail.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
References: <20200219003423.GB9511@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <ae143a2f-7074-2297-1d23-578ab8d0ee94@sandeen.net>
Date:   Fri, 8 May 2020 16:12:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200219003423.GB9511@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/18/20 6:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that the default quota grace period and maximum warning limits
> set by the administrator survive quotacheck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> This is the testcase to go with 'xfs: preserve default grace interval
> during quotacheck', though Eric and I haven't figured out how we're
> going to land that one...

<it landed>

This looks fine to me and it works.  Sorry for derailing it thinking that it
didn't work based on a bug in my patch stack.  :(

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/xfs/913     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/913.out |   13 ++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 83 insertions(+)
>  create mode 100755 tests/xfs/913
>  create mode 100644 tests/xfs/913.out
> 
> diff --git a/tests/xfs/913 b/tests/xfs/913
> new file mode 100755
> index 00000000..94681b02
> --- /dev/null
> +++ b/tests/xfs/913
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 913
> +#
> +# Make sure that the quota default grace period and maximum warning limits
> +# survive quotacheck.
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
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_quota
> +
> +rm -f $seqres.full
> +
> +# Format filesystem and set up quota limits
> +_scratch_mkfs > $seqres.full
> +_qmount_option "usrquota"
> +_scratch_mount >> $seqres.full
> +
> +$XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Remount and check the limits
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Run repair to force quota check
> +_scratch_xfs_repair >> $seqres.full 2>&1
> +
> +# Remount (this time to run quotacheck) and check the limits.  There's a bug
> +# in quotacheck where we would reset the ondisk default grace period to zero
> +# while the incore copy stays at whatever was read in prior to quotacheck.
> +# This will show up after the /next/ remount.
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# Remount and check the limits
> +_scratch_mount >> $seqres.full
> +$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
> +_scratch_unmount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/913.out b/tests/xfs/913.out
> new file mode 100644
> index 00000000..ee989388
> --- /dev/null
> +++ b/tests/xfs/913.out
> @@ -0,0 +1,13 @@
> +QA output created by 913
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> +Blocks grace time: [0 days 05:00:00]
> +Inodes grace time: [0 days 05:00:00]
> +Realtime Blocks grace time: [0 days 05:00:00]
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 056072fb..87b3c75d 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -539,4 +539,5 @@
>  910 auto quick inobtcount
>  911 auto quick bigtime
>  912 auto quick label
> +913 auto quick quota
>  997 auto quick mount
> 
