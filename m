Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D57FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Sep 2021 14:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA3560F5E
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Sep 2021 14:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhIEOt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Sep 2021 10:49:28 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:57759 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237646AbhIEOtV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Sep 2021 10:49:21 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1001756|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.217289-0.00897824-0.773733;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.LFtY8rE_1630853296;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LFtY8rE_1630853296)
          by smtp.aliyun-inc.com(10.147.42.253);
          Sun, 05 Sep 2021 22:48:16 +0800
Date:   Sun, 5 Sep 2021 22:48:15 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] generic: fsstress with cpu offlining
Message-ID: <YTTYr52ahATT74KK@desktop>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
 <163045511017.770026.7524779302645203861.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045511017.770026.7524779302645203861.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:11:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Exercise filesystem operations when we're taking CPUs online and offline
> throughout the test.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/726     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/726.out |    2 +
>  2 files changed, 71 insertions(+)
>  create mode 100755 tests/generic/726
>  create mode 100644 tests/generic/726.out
> 
> 
> diff --git a/tests/generic/726 b/tests/generic/726
> new file mode 100755
> index 00000000..cb709795
> --- /dev/null
> +++ b/tests/generic/726
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 726
> +#
> +# Run an all-writes fsstress run with multiple threads while exercising CPU
> +# hotplugging to shake out bugs in the write path.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw stress
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +	wait	# for exercise_cpu_hotplug subprocess
> +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> +		echo 1 > "$i" 2>/dev/null
> +	done
> +}
> +
> +exercise_cpu_hotplug()
> +{
> +	while [ -e $sentinel_file ]; do
> +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> +		local cpu="${hotplug_cpus[idx]}"
> +		local action=$(( RANDOM % 2 ))
> +
> +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> +		sleep 0.5
> +	done
> +}
> +
> +_supported_fs generic
> +
> +sysfs_cpu_dir="/sys/devices/system/cpu"
> +
> +# Figure out which CPU(s) support hotplug.
> +nrcpus=$(getconf _NPROCESSORS_CONF)
> +hotplug_cpus=()
> +for ((i = 0; i < nrcpus; i++ )); do
> +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> +done
> +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
> +
> +_require_scratch
> +_require_command "$KILLALL_PROG" "killall"
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1

I think we could just run fsstress against a dir in $TEST_DIR?

> +
> +sentinel_file=$tmp.hotplug
> +touch $sentinel_file
> +exercise_cpu_hotplug &
> +
> +nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))

We'd better to cap nr_cpu just in case we're testing on a system with
1024 cpus and taking very long time for fsstress to finish.

Thanks,
Eryu

> +nr_ops=$((25000 * TIME_FACTOR))
> +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> +rm -f $sentinel_file
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/726.out b/tests/generic/726.out
> new file mode 100644
> index 00000000..6839f8ce
> --- /dev/null
> +++ b/tests/generic/726.out
> @@ -0,0 +1,2 @@
> +QA output created by 726
> +Silence is golden.
> 
