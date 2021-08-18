Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F21C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 16:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7FE6103E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 16:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhHRQCA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 12:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhHRQCA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 12:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90DF2610A6;
        Wed, 18 Aug 2021 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629302485;
        bh=mOP1N88jj6n2kcpvc5X+5XTjD3WArt9ZoWVjf+IgQeU=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=jgaiUtDacRdBwA1vYl+uZ5LIX5NBt2aADutyQfwrV4qruk58W0pLEG3gJ+Y7ZMvn7
         1ScN5vzOH25QlW+1CB3cI+EHS4D8Z09HMM62PtOFqU/YHxPt5Wde3X2m8iuSo2AwF2
         F+4RyZphK4yVlambbMWNHSCUIzDKFr/f8e8U3gQeXCXy/oWVbQBln4gcR8oDSfj7Xu
         Llw+Al0v413r+3DHD9Xq8wZZScT+laucfhze/ZzDKg7jFqKBSi4FdZuHiyDkvn2wIO
         bLtEdMwMWbiXQLaYpKgF+i6VtZMzhHZHwkDSB97LDl/ockxhAUBjfgT7xUh6bhbMdA
         yW5O0oJkz9n/A==
Date:   Wed, 18 Aug 2021 09:01:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic: fsstress with cpu offlining
Message-ID: <20210818160125.GI12640@magnolia>
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924439973.779465.13771500926240153773.stgit@magnolia>
 <20210818060737.bi5ulz43robj3i7v@fedora>
 <20210818063249.box2au5yz2afvszi@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818063249.box2au5yz2afvszi@fedora>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 02:32:49PM +0800, Zorro Lang wrote:
> On Wed, Aug 18, 2021 at 02:07:37PM +0800, Zorro Lang wrote:
> > On Tue, Aug 17, 2021 at 04:53:19PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Exercise filesystem operations when we're taking CPUs online and offline
> > > throughout the test.
> > 
> > Just ask, is this test cover something (commits)?

This test started its life as a simple exerciser to try to spot problems
with the percpu data structure handling in Dave's log scalability
patchset.  Now that inode inactivation also uses percpu lists, it covers
both of those things.

However, filesystems were already supposed to keep running even with
CPUs going off and online, so I didn't list any specific commits.

> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/726     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/726.out |    2 +
> > >  2 files changed, 73 insertions(+)
> > >  create mode 100755 tests/generic/726
> > >  create mode 100644 tests/generic/726.out
> > > 
> > > 
> > > diff --git a/tests/generic/726 b/tests/generic/726
> > > new file mode 100755
> > > index 00000000..4b072b7f
> > > --- /dev/null
> > > +++ b/tests/generic/726
> > > @@ -0,0 +1,71 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 726
> > > +#
> > > +# Run an all-writes fsstress run with multiple threads while exercising CPU
> > > +# hotplugging to shake out bugs in the write path.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto rw
> 
> Oh, I think it can be in 'stress' group, due to it's a fsstress random test, and
> it really takes long time on my system (with 24 cpus):
> 
> generic/726      1041s
> 
> And might take more time :)

Hmm.  Ok, back to the drawing board on this one then...

> Thanks,
> Zorro
> 
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > 
> > At least there's "exercise_cpu_hotplug &", should we wait at here? Even we removed
> > $tmp.hotplug, can't make sure the process is over.

Yes.

> > 
> > > +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> > > +		echo 1 > "$i" 2>/dev/null
> > > +	done
> > > +}
> > > +
> > > +exercise_cpu_hotplug()
> > > +{
> > > +	while [ -e $sentinel_file ]; do
> > > +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> > > +		local cpu="${hotplug_cpus[idx]}"
> > > +		local action=$(( RANDOM % 2 ))
> > > +
> > > +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> > > +		sleep 0.5
> > > +	done
> > > +}
> > > +
> > > +# Import common functions.
> > > +
> > > +# Modify as appropriate.
> > 
> > Two useless comments at here?

Removed.

> > > +_supported_fs generic
> > > +
> > > +sysfs_cpu_dir="/sys/devices/system/cpu"
> > > +
> > > +# Figure out which CPU(s) support hotplug.
> > > +nrcpus=$(getconf _NPROCESSORS_CONF)
> > > +hotplug_cpus=()
> > > +for ((i = 0; i < nrcpus; i++ )); do
> > > +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> > > +done
> > > +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> > > +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
> > 
> > Is that worth being a helper?

I would defer that to the second time someone wants to write a cpu
hotplug test.

> > > +
> > > +_require_scratch
> > > +_require_command "$KILLALL_PROG" "killall"
> > > +
> > > +echo "Silence is golden."
> > > +
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount >> $seqres.full 2>&1
> > > +
> > > +sentinel_file=$tmp.hotplug
> > > +touch $sentinel_file
> > > +exercise_cpu_hotplug &
> > > +
> > > +nr_cpus=$((LOAD_FACTOR * 4))

Hm, this probably ought to be nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))

> > > +nr_ops=$((10000 * nr_cpus * TIME_FACTOR))

And this nr_ops=$((25000 * TIME_FACTOR))

--D

> > > +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > > +rm -f $sentinel_file
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/726.out b/tests/generic/726.out
> > > new file mode 100644
> > > index 00000000..6839f8ce
> > > --- /dev/null
> > > +++ b/tests/generic/726.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 726
> > > +Silence is golden.
> > > 
> 
