Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A0DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 23:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF316112E
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 23:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhIQXtl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 19:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhIQXtl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 19:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 183DF61152;
        Fri, 17 Sep 2021 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631922498;
        bh=oA51IDtQrhv7Uw2LEdbU4o/f0WAoAEkA6jN0cBA6nR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B19QvRf2x8LvgEfKW/Yzjz4EdrmXAUSDt3uTaItbJLHaHOa3AM4C2yexKZ/UGPLBc
         3QgoiyQnP2ozseif24re3qnenzFiGMqosix6uOJq+F+uRJrtwva+4j9iueDEVJeGMn
         DQ4DKVBcxMDEB8NRReqUpl+xWlY/nxzihde2GgVZU0InHP4ucW/y/BjmftX/Gubofl
         4sSgI0EnwEbNAD866Wai58/0aob2NTewfH0VCIeIi0IvNSRudnCixDPtjCTdDGR6Eq
         oyqR638ahqRXIAFWp5Wm6o9nSFt/bepT6A/nLZGqZv0Q4/Zc0BfG1xRiStSXCEd0aU
         2gIVkD4JO3ASQ==
Date:   Fri, 17 Sep 2021 16:48:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     riteshh <riteshh@linux.ibm.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] generic: fsstress with cpu offlining
Message-ID: <20210917234817.GA10197@magnolia>
References: <163174934876.380813.7279783755501552575.stgit@magnolia>
 <163174935421.380813.6102795123954022876.stgit@magnolia>
 <20210917183449.wyvvy436j3ifeazx@riteshh-domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917183449.wyvvy436j3ifeazx@riteshh-domain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 18, 2021 at 12:04:49AM +0530, riteshh wrote:
> On 21/09/15 04:42PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Exercise filesystem operations when we're taking CPUs online and offline
> > throughout the test.
> 
> Nice test coverage. Btw, I may have missed older versions, but could you point
> to the link which points to the bugs which this test uncovered?
> I guess it will be good to add tha in the comment section of test description
> too.

I didn't uncover any bugs with 5.14, fortunately.  Dave Chinner was
messing around with per-CPU lists in XFS, so I figured I had better
write something to exercise the cpu-dead handlers to try to make sure
there weren't any obvious bugs in the code, and this is the result.

> This also made me think whether doing memory online/offline while
> running
> fsstress, makes any sense?

Heh, perhaps.  I hadn't gotten /that/ far... :)

--D

> 
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/726     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/726.out |    2 +
> >  2 files changed, 76 insertions(+)
> >  create mode 100755 tests/generic/726
> >  create mode 100644 tests/generic/726.out
> >
> >
> > diff --git a/tests/generic/726 b/tests/generic/726
> > new file mode 100755
> > index 00000000..1a3f2fad
> > --- /dev/null
> > +++ b/tests/generic/726
> > @@ -0,0 +1,74 @@
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
> 
> Does it qualify for auto? This definitely is taking a longer time compared to
> other auto tests on my qemu setup.
> 
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
> > +	test -n "$stress_dir" && rm -r -f "$stress_dir"
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
> > +_require_test
> > +_require_command "$KILLALL_PROG" "killall"
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
> > +stress_dir="$TEST_DIR/$seq"
> > +rm -r -f "$stress_dir"
> > +mkdir -p "$stress_dir"
> > +
> > +echo "Silence is golden."
> > +
> > +sentinel_file=$tmp.hotplug
> > +touch $sentinel_file
> > +exercise_cpu_hotplug &
> > +
> > +# Cap the number of fsstress threads at one per hotpluggable CPU if we exceed
> > +# 1024 IO threads, per maintainer request.
> > +nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
> > +test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
> > +
> > +nr_ops=$((25000 * TIME_FACTOR))
> > +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $stress_dir -n $nr_ops -p $nr_cpus >> $seqres.full
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
