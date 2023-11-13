Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D954C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Nov 2023 16:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjKMQqu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 11:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjKMQqt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 11:46:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CCCD56
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 08:46:46 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF4DC433C8;
        Mon, 13 Nov 2023 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699894005;
        bh=zQdPGys/tEx9ZVUWZMLN2DvC5Oey9xL6A7qT/B2L6vA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgizAbfqNyJAMsW/qZoxu8ZUG4vRTx7JNIrkwZM69IyibxpD4NzC70Kl/73J5oVkP
         p7iiPUf4FeXSufAHRE6uSL4xBOUdMG6wv+kxGwLpxXOguRM8k4PDIjgk8GqZ2B6x92
         jUPfFQ6RdXlEZBuIaxqg8OybtDmuSBUzziSrY8k5TMwEGugIjHO4FgnZLA/sNmREoQ
         QpwuO29oKjVPRI6y+G4/DEfXeebEZAZuYqZN6T1t2qVpcx7OzAwHgjxgXn0sgX5lQC
         kBtURVS8SGLLbesGK80nXbIwBWeFtpkDeY29OJz/qzpYqxJe8PPpN26TDmcywWmBSA
         FiNL8ttQN462A==
Date:   Mon, 13 Nov 2023 08:46:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/1] generic: test reads racing with slow reflink
 operations
Message-ID: <20231113164645.GC36175@frogsfrogsfrogs>
References: <169947896328.203781.17647180888752123384.stgit@frogsfrogsfrogs>
 <169947896885.203781.13438458222742566484.stgit@frogsfrogsfrogs>
 <20231111222257.GB36175@frogsfrogsfrogs>
 <20231112024209.4lxcoozrxsngld7u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112024209.4lxcoozrxsngld7u@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 12, 2023 at 10:42:09AM +0800, Zorro Lang wrote:
> On Sat, Nov 11, 2023 at 02:22:57PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS has a rather slow reflink operation.  While a reflink operation is
> > running, other programs cannot read the contents of the source file,
> > which is causing latency spikes.  Catherine Hoang wrote a patch to
> > permit reads, since the source file contents do not change.  This is a
> > functionality test for that patch.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> > v2: fix a couple of things pointed out by zorro
> > ---
> >  configure.ac              |    1 
> >  include/builddefs.in      |    1 
> >  m4/package_libcdev.m4     |   13 ++
> >  src/Makefile              |    4 +
> >  src/t_reflink_read_race.c |  339 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1953        |   75 ++++++++++
> >  tests/generic/1953.out    |    6 +
> >  tests/xfs/1872            |   10 +
> >  tests/xfs/1873            |   10 +
> 
> This xfs/1953 looks good to me, but about the changes on xfs/1872 and 1873, I think
> those might be another patch :)

Aw, shucks, I must've applied those changes to the wrong patch.

> >  9 files changed, 447 insertions(+), 12 deletions(-)
> >  create mode 100644 src/t_reflink_read_race.c
> >  create mode 100755 tests/generic/1953
> >  create mode 100644 tests/generic/1953.out
> > 
> 
> [snip]
> 
> > diff --git a/tests/generic/1953 b/tests/generic/1953
> > new file mode 100755
> > index 0000000000..70aefc736b
> > --- /dev/null
> > +++ b/tests/generic/1953
> > @@ -0,0 +1,75 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1953
> > +#
> > +# Race file reads with a very slow reflink operation to see if the reads
> > +# actually complete while the reflink is ongoing.  This is a functionality
> > +# test for XFS commit f3ba4762fa56 "xfs: allow read IO and FICLONE to run
> > +# concurrently".
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto clone punch
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_xfs_io_command "fpunch"
> > +_require_test_program "punch-alternating"
> > +_require_test_program "t_reflink_read_race"
> > +_require_command "$TIMEOUT_PROG" timeout
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount >> "$seqres.full" 2>&1
> > +
> > +testdir="$SCRATCH_MNT/test-$seq"
> > +mkdir "$testdir"
> > +
> > +calc_space() {
> > +	blocks_needed=$(( 2 ** (fnr + 1) ))
> > +	space_needed=$((blocks_needed * blksz * 5 / 4))
> > +}
> > +
> > +# Figure out the number of blocks that we need to get the reflink runtime above
> > +# 1 seconds
> > +echo "Create a many-block file"
> > +for ((fnr = 1; fnr < 40; fnr++)); do
> > +	free_blocks=$(stat -f -c '%a' "$testdir")
> > +	blksz=$(_get_file_block_size "$testdir")
> > +	space_avail=$((free_blocks * blksz))
> > +	calc_space
> > +	test $space_needed -gt $space_avail && \
> > +		_notrun "Insufficient space for stress test; would only create $blocks_needed extents."
> > +
> > +	off=$(( (2 ** fnr) * blksz))
> > +	$XFS_IO_PROG -f -c "pwrite -S 0x61 -b 4194304 $off $off" "$testdir/file1" >> "$seqres.full"
> > +	"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
> > +
> > +	timeout 1s cp --reflink=always "$testdir/file1" "$testdir/garbage" || break
> 
> As there's `_require_command "$TIMEOUT_PROG" timeout`, so better to use $TIMEOUT_PROG
> at here. I can help to change this, but the 1872 and 1873 need to be removed, they
> block the patch merging.

Eh, now I have to respin and resubmit two complete series, so you might
as well wait for me to retest the whole stupid mess.

--D

> Thanks,
> Zorro
> 
> > +done
> > +echo "fnr=$fnr" >> $seqres.full
> > +
> > +echo "Reflink the big file"
> > +$here/src/t_reflink_read_race "$testdir/file1" "$testdir/file2" \
> > +	"$testdir/outcome" &>> $seqres.full
> > +
> > +if [ ! -e "$testdir/outcome" ]; then
> > +	echo "Could not set up program"
> > +elif grep -q "finished read early" "$testdir/outcome"; then
> > +	echo "test completed successfully"
> > +else
> > +	cat "$testdir/outcome"
> > +fi
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/1953.out b/tests/generic/1953.out
> > new file mode 100644
> > index 0000000000..8eaacb7ff0
> > --- /dev/null
> > +++ b/tests/generic/1953.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 1953
> > +Format and mount
> > +Create a many-block file
> > +Reflink the big file
> > +Terminated
> > +test completed successfully
> > diff --git a/tests/xfs/1872 b/tests/xfs/1872
> > index 004e99176e..289fc99612 100755
> > --- a/tests/xfs/1872
> > +++ b/tests/xfs/1872
> > @@ -10,15 +10,13 @@
> >  . ./common/preamble
> >  _begin_fstest auto quick unlink
> >  
> > -# Import common functions.
> > -source ./common/filter
> > -source ./common/fuzzy
> > -source ./common/quota
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/quota
> >  
> >  # real QA test starts here
> >  
> > -# Modify as appropriate.
> > -_supported_fs generic
> > +_supported_fs xfs
> >  _require_xfs_db_command iunlink
> >  _require_scratch_nocheck	# we'll run repair ourselves
> >  
> > diff --git a/tests/xfs/1873 b/tests/xfs/1873
> > index 46af16f5d1..5d9fc620dc 100755
> > --- a/tests/xfs/1873
> > +++ b/tests/xfs/1873
> > @@ -10,15 +10,13 @@
> >  . ./common/preamble
> >  _begin_fstest auto online_repair
> >  
> > -# Import common functions.
> > -source ./common/filter
> > -source ./common/fuzzy
> > -source ./common/quota
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/quota
> >  
> >  # real QA test starts here
> >  
> > -# Modify as appropriate.
> > -_supported_fs generic
> > +_supported_fs xfs
> >  _require_xfs_db_command iunlink
> >  # The iunlink bucket repair code wasn't added to the AGI repair code
> >  # until after the directory repair code was merged
> > 
> 
> 
