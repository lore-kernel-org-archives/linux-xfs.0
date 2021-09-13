Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08876C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D42676108B
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhIMS0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 14:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233133AbhIMS0o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 14:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F93760F9F;
        Mon, 13 Sep 2021 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631557528;
        bh=Rz0AqxMbQnOg0qWGh6JLFUwcNr+LZlxwz715i+TRGNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2eo2BWI00P0xaLOaQ0wgSvPsaDftMwFg8amgrbge/p2NXapgx8dX2dE+CkBq09wC
         a0Gcj4V1OdB8owIadBgi8NNyTC+hYc/Sc0cgKIZNmekf0nCqEP23iuXiVbppHcJGSV
         In9L96lpqQjxBpgIKU9Zrkd8kLx2mnAedok5yMKQteIepn0QHrQAm0g8vQHTPWaZl5
         Bbkuil9YWgzSH8I+5eG3gho/3iF/mTMI8/AIy1j44gMNoBWwHVjGA2J9mPpmKSfUgc
         wnM62DEqjwtZKR4Upr1dkkVat8I2cDyMbrMBAOHpuyFa/tr0o29g+WoCJBHUizuxdi
         5Tj5leOdyUtkA==
Date:   Mon, 13 Sep 2021 11:25:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] generic: fsstress with cpu offlining
Message-ID: <20210913182528.GE638503@magnolia>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
 <163045511017.770026.7524779302645203861.stgit@magnolia>
 <YTTYr52ahATT74KK@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTTYr52ahATT74KK@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 05, 2021 at 10:48:15PM +0800, Eryu Guan wrote:
> On Tue, Aug 31, 2021 at 05:11:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Exercise filesystem operations when we're taking CPUs online and offline
> > throughout the test.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/726     |   69 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/726.out |    2 +
> >  2 files changed, 71 insertions(+)
> >  create mode 100755 tests/generic/726
> >  create mode 100644 tests/generic/726.out
> > 
> > 
> > diff --git a/tests/generic/726 b/tests/generic/726
> > new file mode 100755
> > index 00000000..cb709795
> > --- /dev/null
> > +++ b/tests/generic/726
> > @@ -0,0 +1,69 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 726
> > +#
> > +# Run an all-writes fsstress run with multiple threads while exercising CPU
> > +# hotplugging to shake out bugs in the write path.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw stress
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +	wait	# for exercise_cpu_hotplug subprocess
> > +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> > +		echo 1 > "$i" 2>/dev/null
> > +	done
> > +}
> > +
> > +exercise_cpu_hotplug()
> > +{
> > +	while [ -e $sentinel_file ]; do
> > +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> > +		local cpu="${hotplug_cpus[idx]}"
> > +		local action=$(( RANDOM % 2 ))
> > +
> > +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> > +		sleep 0.5
> > +	done
> > +}
> > +
> > +_supported_fs generic
> > +
> > +sysfs_cpu_dir="/sys/devices/system/cpu"
> > +
> > +# Figure out which CPU(s) support hotplug.
> > +nrcpus=$(getconf _NPROCESSORS_CONF)
> > +hotplug_cpus=()
> > +for ((i = 0; i < nrcpus; i++ )); do
> > +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> > +done
> > +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> > +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
> > +
> > +_require_scratch
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> 
> I think we could just run fsstress against a dir in $TEST_DIR?

Ok.

> > +
> > +sentinel_file=$tmp.hotplug
> > +touch $sentinel_file
> > +exercise_cpu_hotplug &
> > +
> > +nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
> 
> We'd better to cap nr_cpu just in case we're testing on a system with
> 1024 cpus and taking very long time for fsstress to finish.

Not sure why that matters, but I'll cap the number of IO thread at one
per hotpluggable CPU if we go over 1024.

--D

> Thanks,
> Eryu
> 
> > +nr_ops=$((25000 * TIME_FACTOR))
> > +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > +rm -f $sentinel_file
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/726.out b/tests/generic/726.out
> > new file mode 100644
> > index 00000000..6839f8ce
> > --- /dev/null
> > +++ b/tests/generic/726.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 726
> > +Silence is golden.
> > 
